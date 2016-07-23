within Lib.Buildings.Ventilation;

/*
<DOC>
Lueftungsanlage
- Berechnung der Waermerueckgewinnung ueber Waermerueckgewinnungsgrad

Parameter:
- Investitionskosten und KEA_h auf eine Anlage bezogen
</DOC>
*/

/*
<NOTES>
DIN V 18599-6
VDI 3803-5
---
Viessmann Vitovent 200-D
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Wohnungslueftung/Vitovent-200-D/kpr-w-Vitovent_200-D.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitovent_200-D.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Wohnungslueftung/Vitovent-200-D/DB-5848039_Vitovent_200-D.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/DB-5848039_Vitovent_200-D.pdf
>>
a_pel = 0.51156 Wh/m3
b_pel = -4.54422 W
r2_pel = 0.97738
---
STIEBEL-ELTRON LWZ 170 E plus, LWZ 370 plus
https://www.stiebel-eltron.de/content/dam/ste/de/de/products/downloads/erneuerbare_energien/lueftung/Bedienungs-_u._Installationsanleitungen__LWZ_170-370_E_plus__DM0000025987-gnk.pdf
-> Beschreibung technischer Funktionen und ihrer Parameter (Bypass, Frostschutz, ...)
---
Ermittlung des Waermebereitstellungsgrades
http://www.der-energie-coach.net/Downloads/Waermebereitstellungsgrad.pdf
---
* 2-Punkt-Regelung um naechtliche Kuehleffekte im Sommer zu nutzen
  parameter Real deltaT_bypass = 2 "Temperaturdifferenz [K]";

Produktdatenblaetter
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Produktdatenblatt_LivingAir_LABLAK.pdf
https://www.stiebel-eltron.de/de/home/produkte-loesungen/erneuerbare_energien/lueftung.html
http://www.vaillant.de/heizung/produkte/produktgruppen/luftung/index.de_de.html
http://www.viessmann.de/content/dam/vi-brands/DE/PDF/Technologien/pr-wohnungslueftungs-systeme.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/pr-wohnungslueftungs-systeme.pdf
http://www.wolf-heiztechnik.de/produkte/ein-mehrfamilienhaus/lueftungssyteme/
</NOTES>
*/

model VentilationSystem2
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;
  extends Lib.Electrical.AcDevice;

  //parameters
  parameter Real n_min = 0.5 "Hygienischer Mindest-Luftwechsel [1/h]";
  parameter Real V_i = 100 "belueftetes Volumen [m3]";
  parameter Real eta_hr = 0 "Waermerueckgewinnungsgrad [1]";
  parameter Real rho_air_int = 1.2 "Dichte der Raumluft [kg/m3]";
  parameter Real tau_n = 0.1 "Zeitkonstante Anpassung Luftwechselrate [h]";
  parameter Real T_int_bp = 22 + 273.15 "Raumtemperatur Bypass [K]";
  parameter Real a_pel = 0 "elektrische Leistungsaufnahme, Anstieg [Wh/m3]";
  parameter Real b_pel = 0 "elektrische Leistungsaufnahme, Schnittpunkt [W]";
  //
  parameter Real Vf_n = 45 "Nennvolumenstrom eines Lueftungsgeraetes [m3/h]";

  //calculated
  parameter Boolean use_hr = eta_hr > 0 "WRG [-]";
  parameter Real N_dev = if tech__exists then ceil(n_min * V_i / Vf_n) else 0 "Anzahl notwendiger Lueftungsgeraete [1]";

  //components

  //connectors
  Lib.RealInput clock_hour "Uhrzeit [h]";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.RealInput x_air_ext "Wasserdampfgehalt Auszenluft [kg/kg]";
  Lib.RealInput n_nat "Luftwechselrate der natuerlichen Lueftung [1/h]";
  Lib.RealOutput n_vsys(start=0, fixed=true) "Luftwechselrate der Lueftungsanlage [1/h]";

  //variables
  Real deltaT "Temperaturdifferenz [K]";
  Real n_set "Soll-Luftwechselrate [1/h]";
  Real P_th_loss "Waermeverlustleistung [W]";
  Real E_th_loss(start=0, fixed=true) "Waermeverlust-Bilanz [kWh]";
  Boolean bypass_on(start=false) "WRG-Bypass aktiv [-]";
  Real eta_hr_act "wirksamer Waermerueckgewinnungsgrad [1]";
  Real P_el_aux "elektrische Leistung Hilfsenergie [W]";
  Real E_el_aux(start=0, fixed=true) "elektrische Energie Hilfsenergie [kWh]";   
  
  //eod

equation
  deltaT = hp_int.T - hp_ext.T;

  // Bypass
  when {deltaT <= 0 and use_hr, deltaT > 0 and use_hr, hp_int.T < T_int_bp and use_hr, hp_int.T >= T_int_bp and use_hr} then
    bypass_on = deltaT < 0 or hp_int.T >= T_int_bp;
  end when;
  eta_hr_act = if bypass_on then 0 else eta_hr;

  n_set = max(0, n_min - n_nat);
  tau_n * der(n_vsys) = n_set - n_vsys;
  P_th_loss = n_vsys * V_i * rho_air_int * (1006 + x_air_ext * 1840) * deltaT * (1 - eta_hr_act) / 3600;
  der(E_th_loss) = P_th_loss / 1000;
  hp_int.Q_flow = P_th_loss;
  hp_ext.Q_flow = -P_th_loss;

  // elektrische Verbrauch
  P_el_aux = max(0, a_pel * n_vsys * V_i + b_pel);
  der(E_el_aux) = P_el_aux / 1000;
  ac.p = P_el_aux;
  
algorithm
  when terminal() then
    eco__res.K_inv := N_dev * eco__K_inv;
    eco__res.K_serv := eco__k_serv * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := tech__TL;
    eco__res.f_r := 1;
    eco__res.flags := eco__flags;
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := N_dev * env__KEA_h;
    env__res.KEA_ne := N_dev * env__KEA_h_ne;
  end when; 

end VentilationSystem2;