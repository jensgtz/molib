within Lib.Buildings.Elements2;

/*
<DOC>
R_si == R_se
R = 0.5 * (R_si + 0.5 * R_cond)
Oberflaechentemperatur:
  T_si = (0.5 * R_cond) / (0.5 * R_cond + R_si) * (T_air - T_cap) + T_cap

//
extends Lib.Buildings.Elements2.Base;
</DOC>
*/

model IntWall
  
  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Real A_set = max(1e-4, A) "Flaeche (min. 1 cm2) [m2]";
  parameter Lib.Buildings.Elements.ConstructionParam param "Eigenschaften der Konstruktion";
  parameter Real T_start = 283.15 "Start-Temperatur [K]";
  //
  parameter Real U = 1 / (param.R_si + param.R_cond + param.R_se) "U-Wert [W/(m2*K)]";
  parameter Real HT = U*A "zur Berechnung von H_T' [W/K]";

  //components
  Lib.Thermal.Resistor resistor(R = 0.5 * (param.R_si + 0.5 * param.R_cond) / A_set) "Widerstand";
  Lib.Thermal.Capacity capacity(C = param.Cp_a * A_set, T_start=T_start) "Kapazitaet";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_air;
  Lib.RealOutput T_si_deg "Oberflaechentemperatur, innen [degC]";
  Lib.RealOutput T_se_deg "Oberflaechentemperatur, auszen [degC]";

  //variables

  //eod

equation
  connect(capacity.hp, resistor.hp1);
  connect(resistor.hp2, hp_air);

  // Oberflaechentemperatur
  T_si_deg = (0.5 * param.R_cond) / (0.5 * param.R_cond + param.R_si) * (hp_air.T - capacity.hp.T) + capacity.hp.T - 273.15;
  T_se_deg = T_si_deg;

end IntWall;