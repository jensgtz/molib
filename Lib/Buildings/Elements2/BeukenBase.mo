within Lib.Buildings.Elements2;

/*
<DOC>
Starttemperaturen: innerste Schicht +10 K, aeuszerste Schicht -10 K bzgl. T_start
</DOC>
*/

model BeukenBase
  extends Lib.Buildings.Elements2.Base;

  //parameters
  //calculated

  //components
  Lib.Thermal.Resistor res_int(R = param.R_si / A_set) "Waermeuebergang innen";
  Lib.Buildings.Elements2.BeukenModel beuken(A=A_set, N=10, R=param.R_bk10, C=param.C_bk10, T_1_start=T_start+10, T_N_start=T_start-10) "Schichten mit Beuken-Modell";
  Lib.Thermal.Resistor res_ext(R = param.R_se / A_set) "Waermeuebergang auszen";

  //connectors
  //variables
  //eod

equation
  connect(hp_int, res_int.hp1);
  connect(res_int.hp2, beuken.hp1);
  connect(beuken.hp2, res_ext.hp1);
  connect(res_ext.hp2, hp_ext);

  // Oberflaechentemperaturen
  T_si_deg = beuken.hp1.T - 273.15;
  T_se_deg = beuken.hp2.T - 273.15;

end BeukenBase;