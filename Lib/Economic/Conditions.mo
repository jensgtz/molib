within Lib.Economic;

record Conditions
  //parameters
  Real p_z = 0.05 "Kapitalzinssatz [1]";
  Real p_k = 0.02 "Preissteigerungsrate, allgemeine [1]";
  Real p_e = 0.03 "Preissteigerungsrate, Energietraeger [1]";
  Real T_b = 25 "Betrachtungszeitraum [a]";
  Real T_s = 1 "Simulationszeitraum [a]";
  Real f_ek = 0.2 "Eigenkapitalanteil [1]";
  Integer kfw_prod = 430 "KfW-Produkt [-]";
  //components
end Conditions;