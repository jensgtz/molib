within Lib.Buildings.Heating;

/*
<DOC>
allgemeiner Heizkessel
zur Abbildung als Gas-BW-, Holzpellet-, Holzhackschnitzel- oder sonstigen -Kesseln
</DOC>
*/

/*
<NOTES>
nicht vorhanden -> eta = 1


Produktdatenblaetter

https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Datenblatt_BGB.pdf
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Technische_Doku_BA_Gas_FHW_GH/ba_bgb.pdf
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Datenblatt_WHS_WHC.pdf
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Datenblatt_WMS_WMC.pdf
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Datenblatt_WGB-U_WGB-C.pdf

http://www.vaillant.de/heizung/produkte/produktgruppen/brennwert/index.de_de.html
http://www.vaillant.de/heizung/produkte/produktgruppen/pellet/index.de_de.html

Viessmann Gasbrennwert
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Gas-Brennwertkessel/Vitosorp-200-F/kpr-w-Vitosorp_200-F.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitosorp_200-F.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Gas-Brennwertkessel/Vitodens-222-W/kpr-w-vitodens_200-W_222-W.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-vitodens_200-W_222-W.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Gas-Brennwertkessel/Vitodens-300-W/kpr-w-vitodens_300-W.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-vitodens_300-W.pdf

Viessmann Stueckholz
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Festbrennstoffkessel/Holzkessel/Vitoligno-100-S/kpr-w-vitoligno_100-S.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-vitoligno_100-S.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Festbrennstoffkessel/Holzkessel/Vitoligno-200-S/kpr-w-Vitoligno_200-S.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitoligno_200-S.pdf

Viessmann Pelletkessel
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Festbrennstoffkessel/Pelletkessel/Vitoligno-300-C/kpr-w-Vitoligno_300-C.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitoligno_300-C.pdf

http://www.wolf-heiztechnik.de/produkte/ein-mehrfamilienhaus/heizsysteme/gas/
</NOTES>
*/

model Boiler
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject; 
  
  //parameters
  parameter Real P_th_min = 5000 "Mindest-Waermeleistung [W]";
  parameter Real P_th_n = 15000 "Nenn-Waermeleistung [W]";
  parameter Real eta_boil = 0.94 "Kesselwirkungsgrad [1]";
  parameter Real eta_0 = 0.95 "Bereitschaftswirkungsgrad [1]";
  parameter Real eta_dist = 1 "Verteilungswirkungsgrad [1]";
  parameter Real tau = 0.1 "Zeitkonstante Leistungsanpassung [h]";
  parameter Real fuel__f_p = 1.1 "Primaerenergiefaktor Brennstoff [1]";
  parameter Real fuel__f_pne = 1.1 "Primaerenergiefaktor Brennstoff, nicht-erneuerbar [1]";
  parameter Real fuel__k = 0.1 "Brennstoffkosten, brt. [EUR/kWh]";
  parameter Real fuel__K_misc = 0 "Zusatzkosten fuer Brennstoffbereitstellung [EUR/a]"; 
  parameter Real P_el_aux_1 = 0 "el. Leistung Eigenbedarf [W]";
  parameter Real P_el_aux_0 = 0 "el. Leistung Eigenbedarf Standby [W]";

  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_hws "Waermespeicher";
  Lib.Electrical.Interfaces.AcPower ac_aux "AC, Bezug Hilfsenergie";
  Lib.BoolInput switch "An/Aus [-]";
 
  //variables
  Real P_th_set "thermische Leistung, Soll [W]";
  Real P_th(start=0, fixed=true) "Nutzwaermestrom [W]";
  Real E_th(start=0, fixed=true) "Nutzwaerme [kWh]";
  Real E_fuel(start=0, fixed=true) "Endenergieverbrauch [kWh]";
  Real P_el_aux "elektrische Leistung Hilfsenergie [W]";
  Real E_el_aux(start=0, fixed=true) "elektrische Energie Hilfsenergie [kWh]";
  Real t_op(start=0, fixed=true) "Betriebszeit [h]";

  //eod

equation
  //
  P_th_set = if tech__exists and switch then P_th_n else 0; 
  tau * der(P_th) = P_th_set - P_th;
  hp_hws.Q_flow = -P_th;

  //
  der(E_th) = P_th / 1000;
  der(E_fuel) = P_th / (eta_boil * eta_0 * eta_dist * 1000);

  //
  P_el_aux = if tech__exists and switch then P_el_aux_1 else if tech__exists then P_el_aux_0 else 0;
  der(E_el_aux) = P_el_aux / 1000;
  ac_aux.p = P_el_aux;

  //
  der(t_op) = if noEvent(tech__exists and switch) then 1 else 0;

algorithm
  when terminal() then
    eco__res.K_inv := eco__K_inv;
    eco__res.K_serv := eco__k_serv * eco__K_inv;
    eco__res.K_op_e := fuel__k * E_fuel;
    eco__res.K_op_ne := fuel__K_misc;
    eco__res.K_misc := 0;
    eco__res.T_n := tech__TL;
    eco__res.f_r := 1;
    eco__res.flags := "cf_th=1,KfW";
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := E_fuel;
    env__res.Q_p := fuel__f_p * E_fuel;
    env__res.Q_pne := fuel__f_pne * E_fuel;
    env__res.KEA := env__KEA_h;
    env__res.KEA_ne := env__KEA_h_ne;
  end when; 

end Boiler;