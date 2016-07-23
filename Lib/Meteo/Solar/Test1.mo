within Lib.Meteo.Solar;

/*
<DOC>
- Ueberpruefung der jaehrlichen Einstrahlung fuer den Standort Potsdam
- Koordinaten: 52.4degN 13.04degO
- TRY-Region: 4
- Summe hor. dir. und diff. Strahlung aus TRY: 1075 kWh/(m2*a)

- Einstrahlung auf die Horizontale
  - DASSL # 1072 kWh/(m2*a)
  - Runge-Kutta # 1/16h: 1072

- Abbrueche mit DASSL bei geneigten Flaechen

- Einstrahlung Nord:
  - Runge-Kutta # 1/16h:
- Einstrahlung Ost:
  - Runge-Kutta # 1/16h:
- Einstrahlung Sued:
  - Runge-Kutta # 1/16h:
- Einstrahlung West:
  - Runge-Kutta # 1/16h:
- Einstrahlung Ost 32deg:
  - Runge-Kutta # 1/16h:
- Einstrahlung West 32deg: 
  - Runge-Kutta # 1h: 1081.6, 1/2h: 1172.0, 1/4h: 1108.0, 1/8h: 1093.0, 1/16h: 1091.0
</DOC>
*/

model Test1
  //parameters
  parameter Real Lon = 13.04;
  parameter Real Lat = 52.4;
  parameter Real Azimuth = 0 "Azimuth [deg]";
  parameter Real Slope = 0 "Neigung [deg]";
  parameter Real Albedo = 0.2 "Albedo [1]";
  parameter Real Horizon = 5 "Horizont [deg]";
  parameter Real F_diff = 2.5 "Jahreszeit-Faktor Diff.-Strahlung [1]"; 
  //components
  Lib.Meteo.TRY_Source src;
  Lib.Meteo.Solar.Sun sun(Longitude=Lon, Latitude=Lat);
  Lib.Meteo.Solar.Surface surface(Azimuth=Azimuth, Slope=Slope, Albedo=Albedo, f_diff=F_diff, Horizon=Horizon);
  Lib.Misc.Clock clock(TimeZone=1, Longitude=Lon);
  //connectors
  //variables
  Real E(start=0, fixed=true);
  Real E_dir_0(start=0, fixed=true);
  Real E_diff_0(start=0, fixed=true);
  Real E_sum_0(start=0, fixed=true);
  //eod
equation
  connect(sun.r_day, clock.r_day);
  connect(sun.hour_moz, clock.hour_moz);
  connect(sun.alpha, surface.alpha_sun);
  connect(sun.gamma, surface.gamma_sun);
  connect(src.try_out.G_dir_hor, surface.G_dir_hor);
  connect(src.try_out.G_diff_hor, surface.G_diff_hor);
  //
  der(E) = surface.G / 1000;
  der(E_dir_0) = src.try_out.G_dir_hor / 1000;
  der(E_diff_0) = src.try_out.G_diff_hor / 1000;
  der(E_sum_0) = (src.try_out.G_dir_hor + src.try_out.G_diff_hor) / 1000;
end Test1;