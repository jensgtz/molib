within Lib.Thermal;

model CapacityX
  //parameters
  //components
  //connectors
  Lib.RealInput C "aktueller Kapazitaetswert [Wh/K]";
  Lib.Thermal.Interfaces.HeatPort hp "Knoten";
  //variables
  //eod
equation
  C * der(hp.T) = hp.Q_flow;
end CapacityX;