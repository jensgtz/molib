within Lib.Meteo;

/*
<DOC>
Datenquelle:
- http://www.bbsr.bund.de/EnEVPortal/DE/Regelungen/Testreferenzjahre/Testreferenzjahre/03_ergebnisse.html?nn=436654
Handbuch:
- http://www.bbsr-energieeinsparung.de/EnEVPortal/DE/Regelungen/Testreferenzjahre/Testreferenzjahre/TRY_Handbuch.pdf;jsessionid=D0523AC1AF9038E3604B3F090C8EA7E8.live1042?__blob=publicationFile&v=2

Inhalt:
- RG  TRY-Region {1..15}
- IS  Standortinformation {1,2}
- MM  Monat {1..12}
- DD  Tag {1..28,30,31}
- HH  Stunde (MEZ) {1..24}
- N  Bedeckungsgrad [Achtel] {0..8;9}
- WR  Windrichtung in 10 m Hoehe ueber Grund [deg] {0;10..360;999}
- WG  Windgeschwindigkeit in 10 m Hoehe ueber Grund [m/s]
- t  Lufttemperatur in 2m Hoehe ueber Grund [degC]
- p  Luftdruck in Stationshoehe [hPa]
- x  Wasserdampfgehalt, Mischungsverhaeltnis [g/kg]
- RF  Relative Feuchte in 2 m Hoehe ueber Grund [%] {1..100} 
- W  Wetterereignis der aktuellen Stunde {0..99}  
- B  Direkte Sonnenbestrahlungsstaerke (horiz. Ebene) [W/m2]   abwaerts gerichtet: positiv 
- D  Difuse Sonnenbetrahlungsstaerke (horiz. Ebene) [W/m2]   abwaerts gerichtet: positiv
- IK  Information, ob B und oder D Messwert/Rechenwert {1;2;3;4;9}
- A  Bestrahlungsstaerke d. atm. Waermestrahlung (horiz. Ebene) [W/m2] abwaerts gerichtet: positiv
- E  Bestrahlungsstaerke d. terr. Waermestrahlung [W/m2] aufwaerts gerichtet: negativ
- IL  Qualitaetsbit fuer die langwelligen Strahlungsgroeszen {1;2;3;4;5;6;7;8;9}
</DOC>
*/

model TRY_Source
  //parameters
  parameter String region = "04" "Region";
  parameter String ytype = "Jahr" "Jahres-Typ (Jahr/Wint/Somm)";
  parameter String basePath = "./data/TRY/TRY2010_" + region + "_" + ytype + "/";
  //components
  Modelica.Blocks.Tables.CombiTable1D air_temperature(tableOnFile = true, tableName = "air_temperature", fileName = basePath + "air_temperature.txt", smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  Modelica.Blocks.Tables.CombiTable1D dir_hor_rad(tableOnFile = true, tableName = "dir_radiation", fileName = basePath + "dir_radiation.txt", smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  Modelica.Blocks.Tables.CombiTable1D diff_hor_rad(tableOnFile = true, tableName = "diff_radiation", fileName = basePath + "diff_radiation.txt", smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  //connectors
  Lib.Meteo.TRY_OutPort try_out;
  //variables
  //eod
equation
  air_temperature.u[1] = time;
  try_out.T_air = air_temperature.y[1];
  dir_hor_rad.u[1] = time;
  try_out.G_dir_hor = dir_hor_rad.y[1];
  diff_hor_rad.u[1] = time;
  try_out.G_diff_hor = diff_hor_rad.y[1];
end TRY_Source;