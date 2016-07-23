within Lib.Thermal;

model HeatSource
  //parameters
  parameter Real f = 1 "linearer Anpassungsfaktor [1]";
  //components
  //connectors
  Lib.RealInput P_th "thermische Leistung [W]";
  Lib.Thermal.Interfaces.HeatPort hp "Waermeknoten";
  //variables
  Real E_th(start=0, fixed=true) "thermische Energie [kWh]";
  //eod
equation
  hp.Q_flow = -f * P_th ;
  der(E_th) = f * P_th / 1000;
end HeatSource;