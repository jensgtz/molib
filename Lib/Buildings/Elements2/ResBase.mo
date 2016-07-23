within Lib.Buildings.Elements2;

/*
<DOC>
---REMOVED---
  Lib.Thermal.Interfaces.HeatPort hp_int;
  Lib.Thermal.Interfaces.HeatPort hp_ext;
</DOC>
*/

model ResBase
  extends Lib.Buildings.Elements2.Base;

  //parameters

  //components
  Lib.Thermal.Resistor resistor(R = RT / A_set) "Widerstand";

  //connectors

  //variables

  //eod

equation
  connect(hp_int, resistor.hp1);
  connect(resistor.hp2, hp_ext);

  // Oberflaechentemperatur, innen
  T_si_deg = param.R_si / RT * (hp_ext.T - hp_int.T) + hp_int.T - 273.15;

  // Oberflaechentemperatur, auszen
  T_se_deg = (param.R_si + R_cond) / RT * (hp_ext.T - hp_int.T) + hp_int.T - 273.15;

end ResBase;