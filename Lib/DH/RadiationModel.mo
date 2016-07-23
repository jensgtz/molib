within Lib.DH;

model RadiationModel
  //parameters
  parameter Real Longitude "Laengengrad [deg]";
  parameter Real Latitude "Breitengrad [deg]";
  parameter Real Azimuth "Azimut [deg]";
  parameter Real Slope "Dachneigung [deg]";
  //components
  Lib.Meteo.Solar.Sun sun(Longitude=Longitude, Latitude=Latitude);
  Lib.Meteo.Solar.Surface surf_n(Azimuth=Azimuth+0, Slope=90);
  Lib.Meteo.Solar.Surface surf_e(Azimuth=Azimuth+90, Slope=90);
  Lib.Meteo.Solar.Surface surf_s(Azimuth=Azimuth+180, Slope=90);
  Lib.Meteo.Solar.Surface surf_w(Azimuth=Azimuth+270, Slope=90);
  Lib.Meteo.Solar.Surface surf_re(Azimuth=Azimuth+90, Slope=Slope);
  Lib.Meteo.Solar.Surface surf_rw(Azimuth=Azimuth+270, Slope=Slope);
  //connectors
  Lib.RealInput r_day "Tag des Jahes, kont. [1]";
  Lib.RealInput hour_moz "mittlere Ortszeit (0-24) [h]";
  Lib.Meteo.TRY_InPort try_in;
  Lib.Thermal.Interfaces.Irradiation6Out eip;
  //variables
  //eod

equation
  connect(sun.r_day, r_day);
  connect(sun.hour_moz, hour_moz);
  //
  connect(surf_n.alpha_sun, sun.alpha);
  connect(surf_n.gamma_sun, sun.gamma);
  connect(surf_n.G_dir_hor, try_in.G_dir_hor);
  connect(surf_n.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_e.alpha_sun, sun.alpha);
  connect(surf_e.gamma_sun, sun.gamma);
  connect(surf_e.G_dir_hor, try_in.G_dir_hor);
  connect(surf_e.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_s.alpha_sun, sun.alpha);
  connect(surf_s.gamma_sun, sun.gamma);
  connect(surf_s.G_dir_hor, try_in.G_dir_hor);
  connect(surf_s.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_w.alpha_sun, sun.alpha);
  connect(surf_w.gamma_sun, sun.gamma);
  connect(surf_w.G_dir_hor, try_in.G_dir_hor);
  connect(surf_w.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_re.alpha_sun, sun.alpha);
  connect(surf_re.gamma_sun, sun.gamma);
  connect(surf_re.G_dir_hor, try_in.G_dir_hor);
  connect(surf_re.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_rw.alpha_sun, sun.alpha);
  connect(surf_rw.gamma_sun, sun.gamma);
  connect(surf_rw.G_dir_hor, try_in.G_dir_hor);
  connect(surf_rw.G_diff_hor, try_in.G_diff_hor);
  //
  connect(surf_n.G, eip.G_n);
  connect(surf_e.G, eip.G_e);
  connect(surf_s.G, eip.G_s);
  connect(surf_w.G, eip.G_w);
  connect(surf_re.G, eip.G_re);
  connect(surf_rw.G, eip.G_rw);
  /*
  eip.G_n = surf_n.G;
  eip.G_e = surf_e.G;
  eip.G_s = surf_s.G;
  eip.G_w = surf_w.G;
  eip.G_re = surf_re.G;
  eip.G_rw = surf_rw.G;
  */
end RadiationModel;