within Lib.Buildings.Floors;

record FloorWindowCfg
  //parameters
  Real N_n = 1 "Anzahl Nord-Fenster [1]";
  Real A_n = 1 "Flaeche eines Nord-Fensters [m2]";
  Real N_e = 1 "Anzahl Ost-Fenster [1]";
  Real A_e = 1 "Flaeche eines Ost-Fensters [m2]";
  Real N_s = 1 "Anzahl Sued-Fenster [1]";
  Real A_s = 1 "Flaeche eines Sued-Fensters [m2]";
  Real N_w = 1 "Anzahl West-Fenster [1]";
  Real A_w = 1 "Flaeche eines West-Fenster [m2]";
  //components
end FloorWindowCfg;