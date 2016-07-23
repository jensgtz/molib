within Lib.DH;

model Location

  //parameters
  parameter Real Longitude = 12.413807 "Laengengrad [deg]";
  parameter Real Latitude = 51.348756 "Breitengrad [deg]";
  parameter Real Elevation = 113 "Hoehe NHN [m]";
  parameter Real TimeZone = 1 "Zeitzone UTC+X [h]";
  parameter Real Azimuth = 0 "Ausrichtung der Gebaeude-Nordseite (Azimut) [deg]";
  parameter Real Slope = 32 "Dach-Neigung [deg]";

  //components
  Lib.Misc.Clock clock(Longitude=Longitude, TimeZone=TimeZone) "Uhr";
  Lib.Economic.ConditionsModel ecocond "oekonom. Rahmenbedingungen";
  Lib.Thermal.TableTemperature air_temperature "Lufttemperatur (TRY)";
  Lib.Meteo.SoilTemperature soiltemp "Bodentemperatur";
  Lib.Meteo.TRY_AbsHumidity abs_humidity "abs. Luftfeuchte (TRY)";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_ext "Auszenluft";
  Lib.Thermal.Interfaces.HeatPort hp_soil1 "Erdboden (1m)";
  Lib.Thermal.Interfaces.HeatPort hp_soil2 "Erdboden (2m)";
  Lib.RealOutput x_air_ext "abs. Auszenluftfeuchte [kg/kg]";

  //variables

  //eod

equation
  connect(hp_ext, air_temperature.hp);
  connect(soiltemp.hp_air, hp_ext);
  //
  hp_soil1.T = soiltemp.T_50_deg + 273.15;
  hp_soil2.T = soiltemp.T_150_deg + 273.15;
  //
  x_air_ext = abs_humidity.x_air;

end Location;