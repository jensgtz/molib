within Lib.Thermal;

model ResistorX
  //parameters
  //components
  //connectors
  Lib.RealInput R "aktueller Widerstandswert [K/W]";
  Lib.Thermal.Interfaces.HeatPort hp1 "Knoten 1";
  Lib.Thermal.Interfaces.HeatPort hp2 "Knoten 2";
  //variables
  //eod
equation
  hp1.Q_flow + hp2.Q_flow = 0;
  hp1.T - hp2.T = R * hp1.Q_flow;
end ResistorX;