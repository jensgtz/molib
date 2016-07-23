within Lib.Electrical.Loads;

model AcLoad
  //parameters
  parameter Real P_n = 5000 "el. Nennleistung [W]";
  parameter Real dP = 10 "rel. Leistungsgradient [1/h]";
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Anschluss";
  Lib.RealInput P_set "Soll-Leistung [W]";
  //variables
  Real P_el(start=0, fixed=true) "el. Leistung [W]";
  Real E_el(start=0, fixed=true) "el. Energie [kWh]";
  //eod

equation
  der(P_el) = dP * (P_set - ac.p);
  der(E_el) = P_el / 1000;
  ac.p = P_el;
  
end AcLoad;