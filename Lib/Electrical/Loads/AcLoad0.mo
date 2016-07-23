within Lib.Electrical.Loads;

model AcLoad0
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Anschluss";
  Lib.RealInput P_el_set "el. Leistung [W]";
  //variables
  Real E_el(start=0, fixed=true) "el. Energie, Bilanz [kWh]";
  //eod

equation
  der(E_el) = P_el_set / 1000;
  ac.p = P_el_set;
  
end AcLoad0;