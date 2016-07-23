within Lib.Thermal.HeatExchangers;

/*
<DOC>
Entkopplung von zwei HeatPorts, unidirektional
Seite 1 (hp1): Waermesenke
Seite 2 (hp2): Waermequelle

eta Wirkungsgrad (eta):
P1 = m1 * cp1 * T1
P2 = m2 * cp2 * T2
</DOC>
*/

model HX_2HP_U
  //parameters
  parameter Real eta "Wirkungsgrad [1]";
  //components
  //connectors
  Lib.Thermal.Interfaces hp1 "HP1";
  Lib.Thermal.Interfaces hp2 "HP2";
  //variables
  //eod

algorithm
  hp2.T := eta * hp1.T;
  hp2.Q_flow := eta * hp1.Q_flow;

end HX_2HP_U;