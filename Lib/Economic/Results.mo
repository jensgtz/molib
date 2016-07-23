within Lib.Economic;

record Results
  //variables
  Real K_inv "Investitionskosten [EUR]";
  Real K_serv "Instandhaltungskosten [EUR/a]";
  Real K_op_e "Betriebskosten, energetische [EUR/a]";
  Real K_op_ne "Betriebskosten, nicht-energetische [EUR/a]";
  Real K_misc "sonstige Kosten [EUR/a]";
  Real T_n "Nutzungsdauer [a]";
  Real f_r "Ersatz-Faktor [1]";
  Integer action "Ausgangszustand oder Investition 0/1 [-]";
  String flags "Flags [-]";
  //eod
end Results;