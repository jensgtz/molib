within Lib.CHP;

/*
<DOC>
default-Werte:
Viessmann Vitotwin 300-W (Stirling)
</DOC>
*/

/*
<NOTES>
---removed---
parameter Real eta_el = 0.15 "el. Wirkungsgrad [1]";
parameter Real eta_th = 0.81 "th. Wirkungsgrad [1]";

---
autarke Versorgung und als einziger Gasverbraucher: Fluessiggas-Zusatzkosten 300 EUR/a (Tankmiete, ...)

---

Produktdatenblaetter
https://www.broetje.de/cps/rde/xbcr/broetje_de/DOCUMENTS/Produkte_Broschueren/Produktdatenblatt_EcoGen_WGS.pdf
http://www.vaillant.de/heizung/produkte/produktgruppen/kraft-warme-kopplung/index.de_de.html

http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Kraft-Waerme-Kopplung/Blockheizkraftwerke/kpr-w-Vitobloc_200.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitobloc_200.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/Produkte/Kraft-Waerme-Kopplung/Mikro-KWK/kpr-w-Vitotwin_300-W_350-F.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitotwin_300-W_350-F.pdf
http://www.viessmann.de/content/dam/vi-brands/DE/PDF/Kurzprospekt/kpr-w-Vitovalor_300-P.pdf/_jcr_content/renditions/original.media_file.download_attachment.file/kpr-w-Vitovalor_300-P.pdf
</NOTES>
*/

model MicroCogenerationUnit
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real P_el_min = 300 "el. Leistung bei P_th_min [W]";
  parameter Real P_el_n = 1000 "el. Leistung bei P_th_n [W]";
  parameter Real P_th_min = 3600 "th. Mindestleistung [W]";
  parameter Real P_th_n = 5300 "th. Nennleistung [W]";
  parameter Real eta = 0.96 "Gesamtwirkungsgrad Basisgeraet [1]";
  parameter Real P_th_sup_n = 20700 "th. Nennleistung Zusatzheizgeraet [W]";
  parameter Real eta_sup = 1.02 "th. Wirkungsgrad Zusatzheizgeraet [1]";
  parameter Real tau = 0.1 "Zeitkonstante Leistungsanpassung [h]";
  parameter Real tau_sup = 0.1 "Zeitkonstante Leistungsanpassung Zusatzheizgeraet [h]";
  parameter Real eta_0 = 0.95 "Bereitschaftswirkungsgrad [1]";
  parameter Real eta_dist = 1 "Verteilwirkungsgrad [1]";
  //
  parameter Real P_el_sc = 50 "el. Eigenverbrauch, Betrieb [W]";
  parameter Real P_el_sc_0 = 5 "el. Eigenverbrauch, Standby [W]";
  //
  parameter Real fuel__f_p = 1.1 "Primaerenergiefaktor Brennstoff [1]";
  parameter Real fuel__f_pne = 1.1 "Primaerenergiefaktor Brennstoff, nicht-erneuerbar [1]";
  parameter Real fuel__k = 0.07 "Brennstoffkosten, brutto [EUR/kWh]";
  parameter Real fuel__K_misc = 0 "Zusatzkosten fuer Brennstoffbereitstellung [EUR/a]";

  //calculated
  parameter Boolean no_modulation = abs(P_th_n - P_th_min) < 1e-3 "keine Modulation [1]";
  parameter Real f__P_el = if no_modulation then 0 else (P_el_n - P_el_min) / (P_th_n - P_th_min) "Steigung P_el/P_th [1]";
  parameter Real f_ex = if tech__exists then 1 else 0 "f_ex [1]";

  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_hws "Waermespeicher";
  Lib.Electrical.Interfaces.AcPower ac_chp "AC, Einspeisung";
  Lib.Electrical.Interfaces.AcPower ac_aux "AC, Bezug Hilfsenergie";
  Lib.BoolInput switch "An / Aus [-]";
  Lib.BoolInput switch_sup "An / Aus, Zusatzheizgeraet [-]";
  Lib.RealInput P_el_bal "Leistungsbilanz Netzanschluss [W]";

  //variables
  Real P_th_0_set "thermische Leistung Basisgeraet, Soll [W]";
  Real P_th_0(start=0, fixed=true) "thermische Leistung Basisgeraet [W]";
  Real P_th_sup_set "thermische Leistung Zusatzheizgeraet, Soll [W]";
  Real P_th_sup(start=0, fixed=true) "thermische Leistung Zusatzheizgeraet [W]";
  Real P_th "Nutzwaermestrom [W]";
  Real E_th(start=0, fixed=true) "Nutzwaerme [kWh]";
  Real P_el "el. Leistung [W]";
  Real E_el(start=0, fixed=true) "Elektroenergie [kWh]";
  Real P_fuel "Brennstoff-Leistung [W]";
  Real E_fuel(start=0, fixed=true) "Brennstoff-Energie [kWh]";
  Real P_el_aux "elektrische Leistung Hilfsenergie [W]";
  Real E_el_aux(start=0, fixed=true) "elektrische Energie Hilfsenergie [kWh]"; 
  Integer N_op(start=0, fixed=true) "Anzahl Start-/Stopp-Vorgaenge [1]";
  Real t_op(start=0, fixed=true) "Betriebsstunden [h]";
  Real t_op_sup(start=0, fixed=true) "Betriebsstunden Zusatzheizgeraet [h]";
  Real t_op_cur(start=0) "aktuelle Betriebszeit [h]";
  Real t_op_start(start=0) "Zeitpunkt letzter Start [h]";
  Real P_el_supply "Bilanz Stromversorgung [W]";
  //
  Real f_op(start=0) "op [1]";
  Real f_op_sup(start=0) "op_sup [1]";

  //eod

equation
  // Bilanz nach Def. in der Arbeit (Vorzeichentausch)
  P_el_supply = -P_el_bal;
  
  // Start-Zaehler
  when {switch and tech__exists} then
    N_op = pre(N_op) + 1;
    t_op_start = time;
  end when;

  // Betriebszeit
  t_op_cur = f_op * (time - t_op_start);

  // Eigenverbrauch Strom
 
  // Basisgeraet
  if switch and tech__exists then
    P_th_0_set = 1 / (1+ exp(-P_el_bal)) * (P_th_n - P_th_min) + P_th_min;
    P_el = max(0, f__P_el * (P_th_0 - P_th_min) + P_el_min);
    f_op = 1;
  else
    P_th_0_set = 0;
    P_el = 0;
    f_op = 0;
  end if;
  tau * der(P_th_0) = P_th_0_set - P_th_0;

  // Zusatzheizgeraet
  if switch and switch_sup and tech__exists then
    P_th_sup_set = P_th_sup_n;
    f_op_sup = 1;
  else
    P_th_sup_set = 0;
    f_op_sup = 0;
  end if;
  tau_sup * der(P_th_sup) = P_th_sup_set - P_th_sup;

  P_th = P_th_0 + P_th_sup;
  P_fuel = ((P_el + P_th_0) / eta + P_th_sup / eta_sup) / (eta_0 * eta_dist);

  der(E_th) = P_th / 1000;
  der(E_el) = P_el / 1000;
  der(E_fuel) = P_fuel / 1000;

  // elektrische Hilfsenergie
  P_el_aux = if noEvent(f_op > 0.5) then P_el_sc else P_el_sc_0;
  der(E_el_aux) = P_el_aux / 1000;
  ac_aux.p = P_el_aux;

  hp_hws.Q_flow = -P_th;
  ac_chp.p = -P_el;

  der(t_op) = f_op;
  der(t_op_sup) = f_op_sup;

algorithm
  when terminal() then
    eco__res.K_inv := eco__K_inv;
    eco__res.K_serv := eco__k_serv * eco__K_inv;
    eco__res.K_op_e := fuel__k * E_fuel;
    eco__res.K_op_ne := fuel__K_misc;
    eco__res.K_misc := 0;
    eco__res.T_n := tech__TL;
    eco__res.f_r := 1;
    eco__res.flags := if eco__is_investment then "cf_th=" + String(E_th/(E_th+E_el)) + ",cf_el=" + String(1 - E_th/(E_th+E_el)) + ",KfW" else "";
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := E_fuel;
    env__res.Q_p := fuel__f_p * E_fuel;
    env__res.Q_pne := fuel__f_pne * E_fuel;
    env__res.KEA := env__KEA_h;
    env__res.KEA_ne := env__KEA_h_ne;
  end when; 

end MicroCogenerationUnit;