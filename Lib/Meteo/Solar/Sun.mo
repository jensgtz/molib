within Lib.Meteo.Solar;

model Sun
  //Sonnenstand nach [Quaschning, V.: Regenerative Energiesysteme, Hanser, 2011] S. 64 ff.
  import Modelica.Math.asin;
  import Modelica.Math.acos;
  import Modelica.Constants.pi;
  import Lib.Math.cos_deg;
  //parameters
  parameter Real Longitude = 12 "Laengengrad [deg]";
  parameter Real Latitude = 50 "Breitengrad [deg]";
  //
  parameter Real lambda = Longitude / 180 * pi "Laengengrad [rad]";
  parameter Real phi = Latitude / 180 * pi "Breitengrad [rad]";
  //components
  //connectors
  Lib.RealInput r_day "Tag des Jahres, kont. [1]";
  Lib.RealInput hour_moz "mittlere Ortszeit (0-24) [h]";
  Lib.RealOutput alpha "Azimut [rad]";
  Lib.RealOutput gamma "Hoehenwinkel [rad]";
  //variables
  Real day_deg "Tag des Jahres [deg]";
  Real delta "Deklination [rad]";
  Real delta_deg "Deklination [deg]";
  Real zgl_min "Zeitgleichung [min]";
  Real hour_woz "Wahre Ortszeit 0..24 [h]";
  Real omega "Stundenwinkel [rad]";
  Real omega_deg "Stundenwinkel [deg]";
  Real alpha_deg "Azimuth [deg]";
  Real gamma_deg "Hoehenwinkel [deg]";
  Boolean is_day "es ist (nicht) Tag [1]";
  //eod
algorithm
  day_deg := 360 * r_day / 365;
  delta_deg := 0.3948 - 23.2559 * cos_deg(day_deg + 9.1) - 0.3915 * cos_deg(2 * day_deg + 5.4) - 0.1764 * cos_deg(3 * day_deg + 26);
  delta := delta_deg / 180 * pi;
  zgl_min := 0.0066 + 7.3525 * cos_deg(day_deg + 85.9) + 9.9359 * cos_deg(2 * day_deg + 108.9) + 0.3387 * cos_deg(3 * day_deg + 105.2);
  hour_woz := hour_moz + zgl_min / 60;
  omega_deg := (12 - hour_woz) * 15;
  omega := omega_deg / 180 * pi;
  gamma := asin(cos(omega) * cos(phi) * cos(delta) + sin(phi) * sin(delta));
  gamma_deg := gamma * 180 / pi;
  if noEvent(hour_woz <= 12) then
    alpha := pi - acos((sin(gamma) * sin(phi) - sin(delta)) / (cos(gamma) * cos(phi)));
  else
    alpha := pi + acos((sin(gamma) * sin(phi) - sin(delta)) / (cos(gamma) * cos(phi)));
  end if;
  alpha_deg := alpha * 180 / pi;
  is_day := if noEvent(gamma > 0) then true else false;
end Sun;