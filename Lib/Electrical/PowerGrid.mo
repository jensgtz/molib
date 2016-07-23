within Lib.Electrical;

/*
<DOC>
Einspeisung: Einspeisung in das oeffentliche Netz
Entnahme: Lieferung an Anschluss
</DOC>
*/

model PowerGrid
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject; 

  //parameters
  parameter Boolean in_use = false "wird genutzt [-]";
  parameter Real K_a = 12 * 8 "Leistungskosten-Pauschale [EUR/a]";
  parameter Real k_w = 0.27 "Arbeitspreis [EUR/kWh]";
  parameter Real f_p = 2.8 "Primaerenergiefaktor, gesamt [1]";
  parameter Real f_p_ne = 2.4 "Primaerenergiefaktor, nicht erneuerbar [1]";
  parameter Real c_pv = 0.1231 "Einspeiseverguetung PV-Strom [EUR/kWh]";
  parameter Real c_chp = 0.08 "Einspeiseverguetung KWK-Strom [EUR/kWh]";

  //components

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "Netzanschlusspunkt";
  Lib.RealInput x_chp "KWK-Anteil [1]";
  Lib.RealInput x_pv "PV-Anteil [1]";

  //variables
  Real P "Leistung [W]";
  Real P_in "Einspeiseleistung [W]";
  Real P_out "Entnahmeleistung [W]";
  Real E(start=0, fixed=true) "Energiebilanz [kWh]";
  Real E_in(start=0, fixed=true) "Einspeisung in Netz [kWh]";
  Real E_out(start=0, fixed=true) "Entnahme aus Netz [kWh]";
  Real E_abs(start=0, fixed=true) "abs. transp. Energie [kWh]";
  Real E_in_chp(start=0, fixed=true) "Einspeisung KWK-Strom [kWh]";
  Real E_in_pv(start=0, fixed=true) "Einspeisung PV-Strom [kWh]";

  //eod

equation
  ac.f = 50;
  P = ac.p;
  if noEvent(P > 0) then
    P_in = P;
    P_out = 0;
  else
    P_in = 0;
    P_out = -P;
  end if;
  der(E) = P / 1000;
  der(E_in) = P_in / 1000;
  der(E_out) = P_out / 1000;
  E_abs = E_in + E_out;
  der(E_in_chp) = x_chp * P_in / 1000;
  der(E_in_pv) = x_pv * P_in / 1000;

algorithm
  when terminal() then
    eco__res.K_inv := 0;
    eco__res.K_serv := 0;
    eco__res.K_op_e := k_w * E_out;
    eco__res.K_op_ne := if in_use then K_a * time/8760 else 0;
    eco__res.K_misc := -c_chp * E_in_chp - c_pv * E_in_pv;
    eco__res.T_n := 100;
    eco__res.f_r := 1;
    eco__res.flags := if in_use then "cf_el=1" else "";
    eco__res.action := 0;
    //
    env__res.T_n := 100;
    env__res.Q_e := E_out;
    env__res.Q_p := f_p * E_out;
    env__res.Q_pne := f_p_ne * E_out;
    env__res.KEA := 0;
    env__res.KEA_ne := 0;
  end when;

end PowerGrid;