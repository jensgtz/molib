within Lib.Buildings.Heating;

/*
<DOC>
(Waermespeicher ->) Verteilung -> Heizgeraete

mode:
  1: Raumlufttemperatur
  2: operative Raumtemperatur


--- REMOVED
  if mode == 1 then
    T_act = hp_int.T;
  else
    T_act = T_op_deg + 273.15;
  end if;


  eta = (eta_max - eta_0) / (P_max - 0) * (P - 0) + eta_0;
</DOC>
*/

model Heater
  //parameters
  parameter Integer mode = 1 "Modus 1/2 [-]";
  parameter Real P_max = 20000 "max. Waermeleistung [W]";
  parameter Real T_diff_max = 1 "max. Temperaturdifferenz [K]";
  parameter Real dP_max = 1 "max. rel. Leistungsgradient [1/h]";
  parameter Real x_integral = 0.5 "Integral-Anteil [1]";

  //components

  //connectors
  Lib.RealInput T_set "Soll-Temperatur [K]";
  Lib.RealInput T_op_deg "Operative Raumtemperatur [degC]";
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.Thermal.Interfaces.HeatPort hp_hws "Waermespeicher";
  Lib.Electrical.Interfaces.AcPower ac_aux "elektrische Hilfsenergie";

  //variables
  Real T_set_deg "Soll-Raumtemperatur [degC]";
  Real T_act "Temperatur-Messwert [K]";
  Real T_act_deg "Temperatur-Messwert [degC]";
  Real T_diff "Temperatur-Differenz [K]";
  Real P_set "Soll-Waermeleistung [W]";
  Real P(start=0, fixed=true) "Waermeleistung [W]";
  Real eta "Wirkungsgrad [1]";
  Real Q_h(start=0, fixed=true) "Waermeabgabe [kWh]";
  Real Q_hws(start=0, fixed=true) "Waermebezug Speicher [kWh]";
  Real T_diff_Int(start=0, fixed=true) "Integral der Temperaturdifferenz [Kh]";
  Real T_diff_m "mittlere Temperaturdifferenz [K]";
  Real T_diff_mr "mittlere Temperaturdifferenz, groeszer null [K]";
  Real P_el_aux "Leistung elektrische Hilfsenergie [W]";
  Real E_el_aux(start=0, fixed=true) "elektrische Hilfsenergie [kWh]";
  Real t_Int0(start=0, fixed=true) "Startzeit Integration [h]";
  //eod

algorithm
  T_set_deg := T_set - 273.15;
  T_act := hp_int.T;
  T_act_deg := T_act - 273.15;
  T_diff := T_set - T_act;

equation
  when sample(24, 24) then
    reinit(T_diff_Int, 0);
    t_Int0 = time;
  end when;
  der(T_diff_Int) = T_diff;
  T_diff_m = noEvent(if time - t_Int0 > 0 then T_diff_Int / (time - t_Int0) else 0);
  T_diff_mr = max(0, T_diff_Int);
  P_set = max(0, min(((1 - x_integral) * T_diff + x_integral * T_diff_mr) / T_diff_max * P_max, P_max));
  der(P) = dP_max * (P_set - P);
  der(Q_h) = P / 1000;

  eta = 1;
  der(Q_hws) = P / (eta * 1000);

  // Waermeuebergabe
  hp_int.Q_flow = -P;

  // Waermeentnahme
  hp_hws.Q_flow = P / eta;

  // elektrische Hilfsenergie
  P_el_aux = 0;
  der(E_el_aux) = P_el_aux / 1000;
  ac_aux.p = P_el_aux;

end Heater;