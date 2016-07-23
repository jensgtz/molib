within Lib.Buildings.Elements2;

model ExtWallBeuken
  extends Lib.Buildings.Elements2.Base;

  //parameters

  //components
  Lib.Thermal.Resistor res_si(R=param.R_si / A_set) "WUe innen";
  Lib.Buildings.Elements2.BeukenModel beuken(A=A_set, N=10, R=param.R_bk10, C=param.C_bk10, T_1_start=T_start+5, T_N_start=T_start-5) "Beuken-Modell";
  Lib.Thermal.Resistor res_se(R = param.R_se / A_set) "WUe auszen";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_int "Innenluft-Knoten";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft-Knoten";

  //variables
  
  //eod

equation
  // Verknuepfungen
  connect(hp_int, res_si.hp1);
  connect(res_si.hp2, beuken.hp1);
  connect(beuken.hp2, res_se.hp1);
  connect(res_se.hp2, hp_ext);

  // Oberflaechentemperatur, innen [degC]
  T_si_deg = res_si.hp2.T - 273.15;

  // Oberflaechentemperatur, auszen [degC]
  T_se_deg = res_se.hp1.T - 273.15;

end ExtWallBeuken;