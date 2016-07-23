within Lib.Buildings.Elements2;

model CapResBase
  extends Lib.Buildings.Elements2.Base;

  //parameters
  parameter Real R_1 = param.R_si + 0.5 * R_cond "resultierender Widerstand 1 [m2*K/W]";
  parameter Real R_2 = param.R_se + 0.5 * R_cond "resultierender Widerstand 2 [m2*K/W]";

  //components
  Lib.Thermal.Resistor res1(R = R_1 / A_set) "WUe innen + WL 1";
  Lib.Thermal.Resistor res2(R = R_2 / A_set) "WL 2 + WUe auszen";
  Lib.Thermal.Capacity cap(C = param.Cp_a * A_set, T_start=T_start) "Waermekapazitaet";

  //connectors


  //variables
  
  //eod

equation
  connect(hp_int, res1.hp1);
  connect(res1.hp2, cap.hp);
  connect(cap.hp, res2.hp1);
  connect(res2.hp2, hp_ext);

  // Oberflaechentemperaturen
  T_si_deg = hp_int.T + param.R_si / R_1 * (cap.hp.T - hp_int.T) - 273.15;
  T_se_deg = cap.hp.T + 0.5 * R_cond / R_2 * (hp_ext.T - cap.hp.T) - 273.15;


end CapResBase;