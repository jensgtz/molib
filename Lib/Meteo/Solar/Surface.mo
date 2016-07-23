within Lib.Meteo.Solar;

/*
<DOC>
Einstrahlung auf die geneigte Ebene
nach [Quasch11] S. 67 ff.

//Klucher fuehrt zu hoeheren Einstrahlungen als isotroper Ansatz
G_diff := Lib.Meteo.Solar.DiffRadKlucher(G_dir_hor=G_dir_hor, G_diff_hor=G_diff_hor, gamma_sun=gamma_sun, gamma_surf=gamma, phi=Phi);
</DOC>
*/

model Surface
  import Modelica.Math.acos;
  import Modelica.Math.sin;
  import Modelica.Math.cos;
  import Modelica.Constants.pi;

  //parameters
  parameter Real Azimuth = 180 "Azimut [deg]";
  parameter Real Slope = 32 "Neigung [deg]";
  parameter Real Albedo = 0.2 "Albedo [1]";
  parameter Real Horizon = 5 "Hoehe des Horizontes [deg]";
  parameter Real f_diff = 2.5 "Anpassungsfaktor fuer diff. Einstrahlung [1]";
  //
  parameter Real alpha = Azimuth / 180 * pi;
  parameter Real gamma = Slope / 180 * pi;
  parameter Real gamma_horizon = Horizon / 180 * pi;
  parameter Real f_diff_shad = Lib.Meteo.Solar.ShadedDiffRad(gamma_surface=gamma, gamma_horizon=gamma_horizon);
  //components

  //connectors
  Lib.RealInput alpha_sun "Sonnenazimut [rad]";
  Lib.RealInput gamma_sun "Sonnenhoehe [rad]";
  Lib.RealInput G_dir_hor "direkte Einstrahlung auf die Horizontale [W/m2]";
  Lib.RealInput G_diff_hor "diffuse Einstrahlung auf die Horizontale [W/m2]";
  Lib.RealOutput G "Einstrahlung auf geneigte Ebene [W/m2]";
  Lib.RealOutput f_g_transp "Koeffizient Strahlungsdurchgang transparente Flaechen, Verhaeltnis g/g_max [1]";

  //variables
  Real Phi "Einfallswinkel [rad]";
  Real G_glob_hor "Globalstrahlung auf die Horizontale [W/m2]";
  Real G_dir_0 "direkte Nenn-Einstrahlung [W/m2]";
  Real G_dir "direkte Einstrahlung [W/m2]";
  Real G_dir_shad "verschattete direkte Einstrahlung [W/m2]";
  Real G_diff_0 "diffuse Nenn-Einstrahlung [W/m2]";
  Real G_diff "diffuse Einstrahlung [W/m2]";
  Real G_diff_shad "verschattete diffuse Einstrahlung [W/m2]";
  Real G_ref "reflektierte Einstrahlung [W/m2]";
  Real E "empfangene solare Einstrahlung [kWh/m2]";
  Real E_shad(start=0, fixed=true) "verschattete solare Einstrahlung [kWh/m2]";
  //eod

protected
  Real G_dir_max;

algorithm
  G_glob_hor := G_dir_hor + G_diff_hor;
  G_dir_max := max(0, 1360.8 * sin(gamma_sun));

  // nach [Quasch11] S. 67, "acos(cos(..." statt "acos(-cos(..." !!!
  Phi := acos(cos(gamma_sun) * sin(gamma) * cos(alpha_sun - alpha) + sin(gamma_sun) * cos(gamma));

  G_dir_0 := max(0, min(G_dir_hor * cos(Phi) / sin(gamma_sun), G_dir_max));
  if noEvent(gamma_sun > gamma_horizon) then
    G_dir := G_dir_0;
    G_dir_shad := 0;
  else
    G_dir := 0;
    G_dir_shad := G_dir_0;
  end if;

  G_diff_0 := Lib.Meteo.Solar.DiffRadIsotrop(G_diff_hor=G_diff_hor, gamma_surf=gamma);
  G_diff := (1 - f_diff_shad)  * G_diff_0;
  G_diff_shad := f_diff_shad * G_diff_0;

  G_ref := Lib.Meteo.Solar.RefRadIsotrop(G_glob_hor=G_glob_hor, Albedo=Albedo, gamma_surf=gamma);

  G := G_dir + G_diff + G_ref;

equation
  der(E) = G / 1000;
  der(E_shad) = (G_dir_shad + G_diff_shad) / 1000;

  if noEvent(0 <= Phi and Phi <= pi/2) then
    f_g_transp = 1 - (2 * Phi / pi)^4.7;
  else
    f_g_transp = 0;
  end if;

end Surface;