within Lib.Buildings.Floors;

/*
<DOC>
Basisklasse fuer Geschosse
</DOC>
*/

model Base

  //parameters
  parameter Real L_x = 8.31 "x-Auszenmasz [m]";
  parameter Real L_y = 7.05 "y-Auszenmasz [m]";
  parameter Real L_xi = 7.55 "x-Innenmasz [m]";
  parameter Real L_yi = 6.29 "y-Innenmasz [m]";
  parameter Real H = 2.83 "Geschosshoehe [m]";
  parameter Real H_i = 2.53 "Raumhoehe [m]";
  parameter Real X_refurb_building = 0 "Sanierungszustand Gebaeude (Infiltration) [1]";
  parameter Real n_50_ur = 4 "Luftwechselrate im Ausgangszustand [1/h]";

  //components

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_ext "auszen";
  Lib.Thermal.Interfaces.HeatPort hp_int "innen";
  Lib.RealOutput T_si_deg "mittlere Temperatur der Raumumschlieszungsflaechen [degC]";
  Lib.RealOutput T_op_deg "operative Raumtemperatur [degC]";
  Lib.RealInput x_air_ext "abs. Auszenluftfeuchte [kg/kg]";

  //variables
  Real T_air_deg "Innentemperatur [degC]";

  //eod

equation
  T_air_deg = hp_int.T - 273.15;
  T_op_deg = (T_air_deg + T_si_deg) / 2;

end Base;