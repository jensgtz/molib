within Lib.Buildings.Ventilation;

/*
<DOC>
- Beruecksichtigung des Sanierungszustandes
- Einbeziehung der Auszenluftfeuchte (Wasserdampfgehalt)

vgl. [Pistohl13-2] H34 f. und 

Dichte der Luft rho = 1,2 kg/m3
spezif. Waermekapazitaet der Luft cp = 1000 J/(kg*K)
=> rho * cp = 0,34 Wh/(m3*K)

  // nach [BPK15]/[Fouad15] S. 201
  // Qf_v = mf_v * (h_i - h_e)
  // h_i - h_e = (1006 + x_e * 1840) * (theta_i - theta_e)
  // [W] = [m3/h] * [kg/m3] * ([J/(kg*K)] + [kg/kg] * [J/(kg*K)]) * [K] * 1h / 3600s

---
Interpolation Luftwechselrate zwischen Ausgangszustand und Mindestluftwechsel anhand des Sanierungszustandes
</DOC>
*/

model NaturalVentilation

  //parameters
  parameter Real V_i = 200 "beheiztes Innenvolumen [m3]";
  parameter Real n_min = 0.5 "hyg. Mindest-Luftwechsel [1/h]";
  parameter Real e = 0.03 "Abschirmungskoeffizient [1]";
  parameter Real epsilon = 1 "Hoehenkorrekturfaktor [1]";  
  parameter Real X_refurb = 0 "Anteil sanierter Bauteile [1]";
  parameter Real n_50_ur = 10 "Luftwechselrate im Ausgangszustand 50Pa [1/h]";
  parameter Real n_50_min = 1.5 "Luftwechselrate bei Vollsanierung 50Pa [1/h]";
  parameter Real rho_air_int = 1.2 "Luftdichte Raumluft [kg/m3]";
  
  //calculated
  parameter Real n_50 = n_50_min + (n_50_ur - n_50_min) * (1 - X_refurb) "Luftwechselrate Infiltration 50Pa [1/h]";
  parameter Real V_inf = 2 * V_i * n_50 * e * epsilon "Luftvolumenstrom Infiltration [m3/h]";
  parameter Real n_inf = V_inf / V_i "Luftwechselrate Infiltration [1/h]";
  
  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.RealInput x_air_ext "abs. Auszenluftfeuchte [kg/kg]";
  Lib.RealInput n_vsys "Luftwechselrate Lueftungsanlage [1/h]";
  Lib.RealOutput n_nat "Luftwechsel durch natuerliche Lueftung [1/h]";

  //variables
  Real n_win "Luftwechselrate Fensterlueftung [1/h]";
  Real P_th_loss "Waermeverlustleistung [W]";
  Real E_th_loss(start=0, fixed=true) "Waermeverlust-Bilanz [kWh]";

  //eod

equation
  n_win = max(0, n_min - n_inf - n_vsys);
  n_nat = n_inf;
  P_th_loss = (n_inf + n_win) * V_i * rho_air_int * (1006 + x_air_ext * 1840) * (hp_int.T - hp_ext.T) / 3600;
  der(E_th_loss) = P_th_loss / 1000;
  hp_int.Q_flow = P_th_loss;
  hp_ext.Q_flow = -P_th_loss;

end NaturalVentilation;