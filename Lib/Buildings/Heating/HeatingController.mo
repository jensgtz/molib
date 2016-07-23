within Lib.Buildings.Heating;

/*
<NOTES>
Produktdatenblaetter
http://www.vaillant.de/heizung/produkte/systemerganzung/regelung/index.de_de.html
http://www.wolf-heiztechnik.de/produkte/ein-mehrfamilienhaus/regelungssysteme/
</NOTES>
*/

model HeatingController

  //parameters
  parameter Real T_std = 20 + 273.15 "Soll-Temperatur [K]";
  parameter Real t_std = 6 "Start Normalbetrieb [h]";
  parameter Real T_red = 16 + 273.15 "Soll-Temperatur reduzierter Betrieb [K]";
  parameter Real t_red = 23 "Start reduzierter Betrieb [h]";
  parameter Real SOC_B1_off_w = 0.99 "Stopp Kessel 1, Winter [1]";
  parameter Real SOC_B2_off_w = 0.95 "Stopp Kessel 2, Winter [1]";
  parameter Real SOC_B1_on_w = 0.90 "Start Kessel 1, Winter [1]";
  parameter Real SOC_B2_on_w = 0.85 "Start Kessel 2, Winter [1]";
  parameter Real DeltaSOC = 0.10 "Sommer-Winter-Abweichung der Schwellwerte [1]";  
  parameter Real theta_ext_min = -10 "min. Auszentemperatur, Winter [degC]";
  parameter Real theta_ext_max = 30 "max. Auszentemperatur, Sommer [degC]";

  //calculated
  
  //components

  //connectors
  Lib.RealInput clock_hour "Uhrzeit [h]";
  Lib.RealInput T_int "Raumtemperatur [K]";
  Lib.RealInput T_ext "Auszentemperatur [K]";
  Lib.RealInput T_hws "Temperatur Waermespeicher [K]";
  Lib.RealInput SOC_hws "Ladezustand Waermespeicher [1]";
  Lib.RealOutput T_set(start=T_red, fixed=true) "Soll-Raumtemperatur [K]";
  Lib.BoolOutput B1_on(start=false, fixed=true) "Kessel 1 an/aus [-]";
  Lib.BoolOutput B2_on(start=false, fixed=true) "Kessel 2 an/aus [-]";
  
  //variables
  Real T_int_err "Abweichung Raumtemperatur [K]";
  Real SOC_B1_off "Stopp Kessel 1 [1]";
  Real SOC_B2_off "Stopp Kessel 2 [1]";
  Real SOC_B1_on "Start Kessel 1 [1]";
  Real SOC_B2_on "Start Kessel 2 [1]";
  Real f_theta_ext "Schwellwert-Korrekturfaktor [1]";
  //eod

equation
  T_int_err = T_set - T_int;

  // Soll-Raumtemperatur
  when {clock_hour >= t_std, clock_hour >= t_red} then
    T_set = if clock_hour >= t_std and clock_hour < t_red then T_std else T_red;
  end when;

  // Start/Stopp-Schwellwerte in Abhaengigkeit der Auszentemperatur
  f_theta_ext = ((T_ext - 273.15) - theta_ext_min) / (theta_ext_max - theta_ext_min);
  SOC_B1_off = SOC_B1_off_w - DeltaSOC * f_theta_ext;
  SOC_B2_off = SOC_B2_off_w - DeltaSOC * f_theta_ext;
  SOC_B1_on = SOC_B1_on_w - DeltaSOC * f_theta_ext;
  SOC_B2_on = SOC_B2_on_w - DeltaSOC * f_theta_ext;

  // Kessel 1 Start/Stopp
  when {SOC_hws < SOC_B1_on, SOC_hws > SOC_B1_off} then
    B1_on = SOC_hws < SOC_B1_on;
  end when;

  // Kessel 2 Start/Stopp
  when {SOC_hws < SOC_B2_on, SOC_hws > SOC_B2_off} then
    B2_on = SOC_hws < SOC_B2_on;
  end when;
  
end HeatingController;