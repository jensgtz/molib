within Lib.Buildings.Heating;

/*
<DOC>
WD ... Waermedaemmung
U-Wert WD inkl. R_se = 0.13 m2*K/W, WUe Innen und R_Behaelter vernachlaessigt

Standardwerte:
- rho und c_p: Mittelwerte fuer 60 degC und 1,5 bar
- 60degC Starttemperatur

Produkt-Datenblaetter:
- http://www.sonnenwaermeag.de/index.php/produkte/speicher/-kombispeicher

Kostenfunktion
- lineare Regression
- Daten: http://www.energie-datenbank.eu/?category=55dadc19a7525804135e63ca&subcategory=55dadc19a7525804135e63cf
</DOC>
*/

/*
<NOTES>
Produktdatenblaetter
https://www.stiebel-eltron.de/de/home/produkte-loesungen/warmwasser/kleinspeicher_undwandspeicher/standspeicher_ab200l.html
https://www.stiebel-eltron.de/de/home/produkte-loesungen/erneuerbare_energien/systemspeicher.html
http://www.vaillant.de/heizung/produkte/systemerganzung/speicher/index.de_de.html
http://www.viessmann.de/content/dam/vi-brands/DE/PDF/Technologien/pr-speicher-wassererwaermer_vitocell.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/pr-speicher-wassererwaermer_vitocell.pdf
http://www.wolf-heiztechnik.de/fileadmin/content/Technische%20Dokumentationen/Heizen/4800235_201507_Speichersysteme_DE.pdf
</NOTES>
*/

model StorageTank
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  import Modelica.Constants.pi;

  //parameters
  parameter Real V_s = 0.25 "Speichervolumen [m3]";
  parameter Real H_ins = 1.6 "Hoehe mit WD [m]";
  parameter Real S_ins = 0.125 "Daemmstaerke [m]";
  parameter Real lambda_ins = 0.036 "Waermeleitfaehigkeit WD [W/(m*K)]";
  //
  parameter Real c_p = 4184.7 "isobare spezif. Waermekapazitaet Wasser [J/(kg*K)]";
  parameter Real rho = 982.8 "Dichte Wasser [kg/m3]";
  parameter Real T_start = 333.15 "Temperatur zu Beginn [K]";
  //
  parameter Real theta_h_max = 90 "max. Temperatur am Speicherkopf [degC]";
  parameter Real theta_0_max = 30 "max. Temperatur am Speicherboden [degC]";
  parameter Real theta_u = 10 "Referenztemperatur [degC]";
  parameter Real SOC_hc_max = 0.98 "Ladezustand ab dem keine Heizpatrone eingesetzt wird [1]";
 
  //calculated
  parameter Real theta_m_max = (theta_h_max + theta_0_max) / 2 "max. mittlere Speichertemperatur [degC]";
  parameter Real Q_max = c_p * rho * V_s * (theta_m_max - theta_u) * 3.6e-6 "max. Waermeinhalt bei linearer Schichtung [kWh]";
  //
  parameter Real H_s = H_ins - 2 * S_ins "Tank-Hoehe [m]";
  parameter Real A_s = V_s / H_s "Grundflaeche Tank [m2]";
  parameter Real D_s = sqrt(4 * A_s / pi) "Tank-Durchmesser [m]";
  parameter Real D_ins = 2 * S_ins + D_s "Durchmesser mit WD [m]";
  parameter Real A_ins = 2 * 0.25 * pi * D_ins^2 + pi * D_ins * H_ins "Oberflaeche mit WD [m2]"; 
  parameter Real R_ins = S_ins / lambda_ins "flaechenspezif. Waermeleitwiderstand WD [m2*K/W]";
  parameter Real U_ins = 1 / (R_ins + 0.13) "U-Wert WD [W/(m2*K)]";
  parameter Real z_f = H_s - 0.15 "Vorlauf [m]";
  parameter Real z_r = 0.15 "Ruecklauf [m]";

  //components
  Lib.Thermal.Capacity capacity(V=V_s, rho=rho, cp=c_p, T_start=T_start) "Waermekapazitaet";
  Lib.Thermal.Resistor resistor(R=1/(U_ins*A_ins)) "Waermedaemmung";
  Lib.Thermal.HeatSource cartridge "Heizpatrone";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  Lib.Thermal.Interfaces.HeatPort hp_air;
  Lib.RealInput P_dump "Leistung Heizpatrone [W]";
  Lib.RealOutput theta_f "Vorlauftemperatur [degC]";
  Lib.RealOutput theta_r "Ruecklauftemperatur [degC]";
  Lib.RealOutput theta_h "Temperatur am Behaelterkopf [degC]";
  Lib.RealOutput theta_0 "Temperatur am Behaelterboden [degC]";
  Lib.RealOutput SOC "Ladezustand [1]";
  
  //variables
  Real theta_m "mittlere Speichertemperatur [degC]";
  Real P_loss "Waermeverlustleistung [W]";
  Real Q_loss(start=0, fixed=true) "Waermeverluste [kWh]";
  Real Q "aktueller Waermeinhalt [kWh]";
  //
  Real f_dump_use "Faktor Nutzung Stromueberschuss [1]";
  Real E_dump_use(start=0, fixed=true) "genutzter Stromueberschuss [kWh]";
  Real E_dump_loss(start=0, fixed=true) "ungenutzter Stromueberschuss [kWh]";

  //eod

equation
  theta_m = hp.T - 273.15;
  Q = c_p * rho * V_s * (theta_m - theta_u) * 3.6e-6;
  SOC = Q / Q_max;
  theta_h = SOC * (theta_h_max - theta_u) + theta_u;
  theta_0 = SOC * (theta_0_max - theta_u) + theta_u;
  theta_f = (theta_h - theta_0) * (z_f / H_s) + theta_0;
  theta_r = (theta_h - theta_0) * (z_r / H_s) + theta_0;

  // Speicherwasser
  connect(hp, capacity.hp);

  // Waermedaemmung
  connect(hp, resistor.hp1);
  connect(resistor.hp2, hp_air);

  // Waermeverluste
  if noEvent(resistor.Q_flow > 0) then
    P_loss = resistor.Q_flow;
  else
    P_loss = 0;
  end if;
  der(Q_loss) = P_loss / 1000;

  // Heizpatrone
  f_dump_use = 1 / (1 + exp(1000 * (SOC - SOC_hc_max)));
  cartridge.P_th = f_dump_use * P_dump;
  connect(cartridge.hp, hp);
  der(E_dump_use) = f_dump_use * P_dump / 1000;
  der(E_dump_loss) = (1 - f_dump_use) * P_dump / 1000;

algorithm
  when terminal() then
    eco__res.K_inv := eco__K_inv;
    eco__res.K_serv := eco__k_serv * eco__K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := tech__TL;
    eco__res.f_r := 1;
    eco__res.flags := "cf_th=1, kfw";
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := env__KEA_h;
    env__res.KEA_ne := env__KEA_h_ne;
  end when; 

end StorageTank;