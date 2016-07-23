within Lib.Buildings.Heating;

/*
<DOC>
Funktion Soll-Heizleitung in Abhaengigkeit der Regelabweichung (ΔT)
http://ba.localhost/img/Documentation/Buildings/Heating/BaseHeatingSystem/image1.png
</DOC>
*/

model BaseHeatingSystem
  parameter Real T_set = 293.15 "set point temperature [K]";
  parameter Real P_max = 25e3 "max power [W]";
  parameter Real a_dp = 0.1 "time constant [1/h]";
  parameter Real T_min = 283.15 "min. temperature [K]";
  parameter Real eta = 0.7 "Wirkungsgrad [1]";
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  Lib.Economic.Good fuel "Brennstoff";
  //variables
  Real T_err;
  Real P_set;
  Real P_diff;
  Real P(start = 0, fixed = true) "Leistung [W]";
  Real Q(start = 0, fixed = true) "Energie [kWh]";
  //eod
equation
  T_err = T_set - hp.T;
  P_set = max(0, min(P_max * (1 - 1/exp(T_err)), P_max) );
  P_diff = P_set - P;
  der(P) = max(-a_dp * P_max, min(a_dp * P_diff, a_dp * P_max));
  der(Q) = P / 1000;
  hp.Q_flow = -P; 
  fuel.f = P / (eta * 1000); // [kW] = [W] / ([1] * 1000)
end BaseHeatingSystem;