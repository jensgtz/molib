within Lib.DH;

record LocationCfg
  //parameters
  parameter Real Longitude = 12.413807 "Laengengrad [deg]";
  parameter Real Latitude = 51.348756 "Breitengrad [deg]";
  parameter Real Elevation = 113 "Hoehe NHN [m]";
  parameter Real Azimuth = 0 "Ausrichtung [deg]";
  //
  parameter Real Ds_n = 4 "Entfernung Verschattungsobjekte Nord [m]";
  parameter Real Ds_e = 2 "Entfernung Verschattungsobjekte Ost [m]";
  parameter Real Ds_s = 3 "Entfernung Verschattungsobjekte Sued [m]";
  parameter Real Ds_w = 10 "Entfernung Verschattungsobjekte West [m]";
  parameter Real Hs_n = 6 "Hoehe Verschattungsobjekte Nord [m]";
  parameter Real Hs_e = 10 "Hoehe Verschattungsobjekte Ost [m]";
  parameter Real Hs_s = 12 "Hoehe Verschattungsobjekte Sued [m]";
  parameter Real Hs_w = 6 "Hoehe Verschattungsobjekte West [m]";
  //
  parameter Real Albedo = 0.20 "Albedo der Umgebung [1]";
  //components
end LocationCfg;