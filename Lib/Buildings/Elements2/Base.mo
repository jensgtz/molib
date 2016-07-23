within Lib.Buildings.Elements2;

/*
<DOC>
Bauerhaltungskosten werden als Instandhaltungskosten (K_serv) beruecksichtigt.
Es wird 1% der Investitionskosten (K_inv) als jaehrliche Kosten veranschlagt.
Nach Metzger reichen die Bauerhaltungskosten von 0,12 % bei Mauerwerk, Beton und Stahlbeton, 
ueber Fenster und Tueren mit 2,5 % und 1 %, bis 14 % bei Anstrichen (vgl. [Metzger13] S. 54).
</DOC>
*/

model Base
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Real A_set = max(1e-4, A) "Flaeche (min. 1 cm2) [m2]";
  parameter Lib.Buildings.Elements.ConstructionParam param "Eigenschaften der Konstruktion";
  parameter Real T_start = 283.15 "Start-Temperatur [K]";

  //calculated
  parameter Real U = 1 / (param.R_si + param.R_cond + param.R_se) + param.U_plus "U-Wert [W/(m2*K)]";
  parameter Real RT = 1 / U "Waermedurchgangswiderstand [(m2*K)/W]";
  parameter Real R_cond = RT - param.R_si - param.R_se "Waermeleitwiderstand inkl. Waermebrueckenzuschlag [(m2*K)/W]";
  parameter Real HT = U*A "zur Berechnung von H_T' [W/K]";

  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_int "innerer Waermeknoten";
  Lib.Thermal.Interfaces.HeatPort hp_ext "aeuszerer Waermeknoten";
  Lib.RealOutput T_si_deg "Oberflaechentemperatur, innen [degC]";
  Lib.RealOutput T_se_deg "Oberflaechentemperatur, auszen [degC]";

  //variables
  Real P_in "th. Leistung Energiezufuhr auszen [W]";
  Real P_out "th. Leistung Energieabfuhr auszen [W]";
  Real E_in(start=0, fixed=true) "Energiezufuhr auszen [kWh]";
  Real E_out(start=0, fixed=true) "Energieabfuhr auszen [kWh]";

  //eod

equation
  if noEvent(hp_ext.Q_flow > 0) then
    P_in = hp_ext.Q_flow;
    P_out = 0;
  else
    P_in = 0;
    P_out = -hp_ext.Q_flow;
  end if;
  der(E_in) = P_in / 1000;
  der(E_out) = P_out / 1000;

algorithm
  when terminal() then
    eco__res.K_inv := param.eco__k * A;
    eco__res.K_serv := 0.01 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := param.tech__TL;
    eco__res.f_r := param.tech__RF;
    eco__res.flags := param.flags;
    eco__res.action := param.refurb;
    //
    env__res.T_n := param.tech__TL;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := param.env__kea_h * A;
    env__res.KEA_ne := param.env__kea_h_ne * A;
  end when;

end Base;