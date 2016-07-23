within Lib.Thermal;

model TwoPort
  //parameters
  //components
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "Waermeknoten 1";
  Lib.Thermal.Interfaces.HeatPort hp2 "Waermeknoten 2";
  //variables
  Real dT "Temperaturdifferenz [K]";
  Real Q_flow "Waermefluss von hp1 nach hp2 [W]";
  //eod
equation
  dT = hp1.T - hp2.T;
  hp1.Q_flow = Q_flow;
  hp2.Q_flow = -Q_flow;
end TwoPort;