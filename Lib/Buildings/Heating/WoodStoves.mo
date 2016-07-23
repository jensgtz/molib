within Lib.Buildings.Heating;

/*
<DOC>
ein oder mehrere Holzoefen / Kamine ...
</DOC>
*/

model WoodStoves
  extends Lib.Technical.TechObject;
  extends Lib.Economic.InvestmentObject;
  extends Lib.Environmental.EnvImpactObject;

  //parameters
  parameter Real N = 1 "Anzahl [1]";
  parameter Real P_n = 5000 "Leistung [W]";
  parameter Real eta_n = 0.70 "Wirkungsgrad [1]";
  parameter Real t_d_start = 6 "Start der Holzfeurung [h]";
  parameter Real t_d_stop = 22 "Ende der Holzfeuerung [h]"; 
  //components
  //connectors
  Lib.RealInput clock_hour "Uhrzeit";
  Lib.Thermal.Interfaces.HeatPort hp_air "Raumluft";

  //variables
  Real P_h(start=0) "Heizwaermeleistung [W]";
  Real Q_h(start=0, fixed=true) "Heizwaermeabgabe [kWh]";

  //eod

equation
  hp_air.Q_flow = 0;
  P_h = 0;
  der(Q_h) = P_h / 1000;

algorithm
  when terminal() then
    eco__res.K_inv := 0;
    eco__res.K_serv := 0.02 * eco__res.K_inv;
    eco__res.K_op_e := 0;
    eco__res.K_op_ne := 0;
    eco__res.K_misc := 0;
    eco__res.T_n := 20;
    eco__res.f_r := 1;
    eco__res.flags := "";
    eco__res.action := if eco__is_investment then 1 else 0;
    //
    env__res.T_n := 20;
    env__res.Q_e := 0;
    env__res.Q_p := 0;
    env__res.Q_pne := 0;
    env__res.KEA := 0;
    env__res.KEA_ne := 0;
  end when; 

end WoodStoves;