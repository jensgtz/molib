within Lib.Environmental;

record Results
  //variables
  Real T_n "Nutzungsdauer [a]";
  Real Q_e "Endenergiebedarf [kWh]";
  Real Q_p "Primaerenergiebedarf [kWh]";
  Real Q_pne "nicht-erneuerbarer Primaerenergiebedarf [kWh]";
  Real KEA "Kumulierter Energieaufwand, Herstellungsphase A1-A3 [kWh]";
  Real KEA_ne "nicht-erneuerbarer Kumulierter Energieaufwand, Herstellungsphase A1-A3 [kWh]";
  //eod
end Results;