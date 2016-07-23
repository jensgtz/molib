within Lib.Buildings.Asmt;

/*
<DOC>
Behaglichkeitsfeld
</DOC>
*/

/*
<NOTES>
Uhrzeitabhaengigkeit entfernt
  parameter Real t_on = 6 "Bewertungsbeginn, Uhrzeit [h]";
  parameter Real t_off = 23 "Bewertungsende, Uhrzeit [h]";
  Lib.Misc.Clock clock "Uhrzeit";
  Real f_on(start=0) "Tageszeit-Bewertungsfaktor [1]";
  when {clock.hour_local >= t_on, clock.hour_local >= t_off} then
    f_on = if clock.hour_local >= t_on and clock.hour_local < t_off then 1 else 0;
  end when;
  der(TC_balance) = f_on * TC;
  when terminal() then
    TC_final := TC_balance / ((t_off - t_on)/24 * time);
  end when;
</NOTES>
*/

model TC_Pistohl09_H8

  //parameters

  //components

  //connectors
  Lib.RealInput T_air_deg "Raumlufttemperatur [degC]";
  Lib.RealInput T_si_deg "Temperatur der Raumumschlieszungsflaechen [degC]";
  Lib.RealOutput TC "Behaglichkeit [1]";

  //variables
  Real TC_balance(start=0, fixed=true) "kumulierte Behaglichkeit [h]";
  Real TC_final(start=0, fixed=true) "Mittelwert der thermischen Behaglichkeit, Simulation [1]";

  //eod

  Modelica.Blocks.Tables.CombiTable2D tc_table(table =
  [0, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30;
  12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  16, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
  18, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1;
  20, 0, 0, 0, 1, 1, 2, 2, 2, 2, 1, 1;
  22, 0, 0, 1, 1, 2, 2, 2, 2, 1, 1, 0;
  24, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0;
  26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);
  
equation
  tc_table.u1 = T_air_deg;
  tc_table.u2 = T_si_deg;
  TC = tc_table.y;
  der(TC_balance) = TC;

algorithm
  when terminal() then
    TC_final := TC_balance / time;
  end when;

end TC_Pistohl09_H8;