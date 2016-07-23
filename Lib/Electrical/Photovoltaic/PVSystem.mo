within Lib.Electrical.Photovoltaic;

/*
<NOTES>
7 % MPP-Anpassungs-Verluste
2 % Verluste durch Verschmutzung
1 % Kabelverluste
=>
eta_misc = 0.90

KEA_h nach [http://www.volker-quaschning.de/datserv/kev/index.php] - Ito2010
KEA_h_ne mit Faktor 0.95 berechnet 
mono: 9899 kWh/kW_pk

---STD---
Standardwerte: BenQ Solar, PM096B00 330 Wp, mono

---ECO---
- netzgekoppelt: feste Einspeiseverguetung / Direktvermarktung, ...?
- netzautark: Foerderfaehigkeit von PV-Anlagen ?

---ENV---
[NGeusen01], S. 189
- PV-Modul (Si-mono 350 μm, rahmenlos) KEA_H = 13055 kWh_PE / kW_pk
- PV-Modul (Si-poly 350 μm, rahmenlos) KEA_H = 9722 kWh_PE / kW_pk
[Quaschning-online]
- [Ito2010]: ...
</NOTES>
*/

model PVSystem
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real P_mod = 330 "Modulleistung STC [W]";
  parameter Real N_mod = 6 "Anzahl Module [1]";
  parameter Real A_mod = 1.63071 "Flaeche eines Modules [m2]";
  parameter Real eta_mod = 0.203 "Modul-Wirkungsgrad STC [1]";
  parameter Real eta_inv = 0.95 "Wechselrichter-Wirkungsgrad, EURO [deg]";
  parameter Real eta_misc = 0.90 "WG weiterer Aspekte MPP-Anpassung, Verschmutzung, Kabelverluste [1]";
  parameter Real P_sc_0 = 6 "Eigenverbrauch Standby [W]";
  parameter Real P_sc_1 = 17 "Eigenverbrauch Leerlauf / Betrieb [W]";
  parameter String radPart = "atrw_G" "Bezeichner Teilflaeche Einstrahlungsdaten [-]";

  //calculated
  parameter Real P_inst = N_mod * P_mod "installierte peak-Leistung [W]";
  parameter Real f_ex = if tech__exists then 1 else 0 "f_ex [1]";

  //components
  Lib.DH.RadiationData rad_data(part=radPart) "Einstrahlungsdaten";

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "Einspeisung";
  Lib.Electrical.Interfaces.AcPower ac_aux "elektrischer Eigenverbrauch";

  //variables
  Real P_el "el. Leistung, Einspeisung [W]";
  Real E_el(start=0, fixed=true) "el. Energie, Einspeisung [kWh]";
  Real P_el_aux "el. Eigenverbrauch Wechselrichter [W]";
  Real E_el_aux(start=0, fixed=true) "el. Eigenverbrauch [kWh]";

  //eod

equation
  // Einspeisung
  P_el = f_ex * max(0, N_mod * A_mod * rad_data.G * eta_mod * eta_inv * eta_misc);
  der(E_el) = P_el / 1000;
  ac.p = -P_el;

  // elektrischer Eigenverbrauch
  P_el_aux = if noEvent(P_el > 0.1) then P_sc_1 else f_ex * P_sc_0;
  der(E_el_aux) = P_el_aux / 1000;
  ac_aux.p = P_el_aux;

algorithm
  when terminal() then
    eco__res.K_inv := f_ex * 1500 * P_inst / 1000;
    eco__res.K_serv := f_ex * 0.02 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := tech__TL;
    eco__res.f_r := 1;
    eco__res.flags := if eco__is_investment then "cf_el=1,KfW" else "";
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := tech__TL;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := f_ex * env__KEA_h * P_inst / 1000;
    env__res.KEA_ne := f_ex * env__KEA_h_ne * P_inst / 1000;
  end when;

end PVSystem;