within Lib.Thermal;

/*
<DOC>
---
Real T_deg(start = T_start - 273.15, fixed = true) "temperature [degC]";
</DOC>
*/

model Capacity
  //parameters
  parameter Real V = 0.001 "Volumen [m3]";
  parameter Real rho = 1000 "Dichte [kg/m3]";
  parameter Real cp = 4190 "spezif. Waermekapazitaet [J/(kg*K)]";
  parameter Real T_start = 273.15 "Temperatur [K]";
  //
  parameter Real C = V * rho * cp "Waermekapazitaet [J/K]";
  parameter Real C_Wh = C / 3600 "Waermekapazitaet [Wh/K]";

  //components
  
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  
  //variables
  Real T(start = T_start, fixed = true) "Temperatur [K]";
  Real Q_flow "Waermefluss +hinein -heraus [W]";
  
  //eod

equation
  T = hp.T;
  Q_flow = hp.Q_flow;
  C_Wh * der(T) = Q_flow;

end Capacity;