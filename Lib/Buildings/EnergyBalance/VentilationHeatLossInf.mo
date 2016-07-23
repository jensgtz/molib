within Lib.Buildings.EnergyBalance;

/*
<DOC>
vgl. [Pistohl13-2] H34 f. und 

Dichte der Luft rho = 1,2 kg/m3
spezif. Waermekapazitaet der Luft cp = 1000 J/(kg*K)
=> rho * cp = 0,34 Wh/(m3*K)

---
Interpolation Luftwechselrate zwischen Ausgangszustand und Mindestluftwechsel anhand des Sanierungszustandes
</DOC>
*/

model VentilationHeatLossInf

  //parameters
  parameter Boolean use_x = true "Auszenluftfeuchte beruecksichtigen (0/1) [-]";
  parameter Real n_50_ur = 10 "Luftwechsel im Ausgangszustand [1/h]";
  parameter Real X_refurb = 0 "Anteil sanierter Bauteile [1]";
  parameter Real V_i = 200 "beheiztes Innenvolumen [m3]";
  parameter Real n_50 = n_50_min + (n_50_ur - n_50_min) * (1 - X_refurb) "nat. Luftwechsel [1/h]";
  parameter Real n_50_min = 0.5 "min. nat. Luftwechsel [1/h]";  
  parameter Real e = 0.03 "Abschirmungskoeffizient [1]";
  parameter Real epsilon_i = 1 "Hoehenkorrekturfaktor [1]";  
  parameter Real V_min_i = n_50_min * V_i "hyg. Mindest-Luftwechsel [m3/h]";
  parameter Real V_inf_i = 2 * V_i * n_50 * e * epsilon_i "nat. Luftwechsel [m3/h]";
  parameter Real Vf_i = max(V_inf_i, V_min_i) "Luftvolumenstrom [m3/h]";
  parameter Real H_vi = 0.34 * Vf_i "Norm-Lueftungswaermeverlustkoeffizient [W/K]";
  parameter Real rho_air_int = 1.2 "Luftdichte Raumluft [kg/m3]";
  
  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.RealInput x_air_ext "abs. Auszenluftfeuchte [kg/kg]";

  //variables
  Real P_th_1 "Waermeverlustleistung ohne Beruecksichtigung Auszenluftfeuchte [W]";
  Real P_th_2 "Waermeverlustleistung mit Beruecksichtigung Auszenluftfeuchte [W]";
  Real E_th_1(start=0, fixed=true) "Waermeverlust ohne Beruecksichtigung Auszenluftfeuchte [kWh]";
  Real E_th_2(start=0, fixed=true) "Waermeverlust mit Beruecksichtigung Auszenluftfeuchte [kWh]";

  //eod

equation
  // nach [Pistohl13-2] S. H34
  P_th_1 = H_vi * (hp_int.T - hp_ext.T);
  der(E_th_1) = P_th_1 / 1000;

  // nach [BPK15]/[Fouad15] S. 201
  // Qf_v = mf_v * (h_i - h_e)
  // h_i - h_e = (1006 + x_e * 1840) * (theta_i - theta_e)
  // [W] = [m3/h] * [kg/m3] * ([J/(kg*K)] + [kg/kg] * [J/(kg*K)]) * [K] * 1h / 3600s
  P_th_2 = Vf_i * rho_air_int * (1006 + x_air_ext * 1840) * (hp_int.T - hp_ext.T) / 3600;
  der(E_th_2) = P_th_2 / 1000;

  hp_int.Q_flow = if noEvent(use_x) then P_th_2 else P_th_1;

  // ungenutzt - besser RealInput
  hp_ext.Q_flow = 0;

end VentilationHeatLossInf;