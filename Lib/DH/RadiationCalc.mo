within Lib.DH;

/*
<DOC>
Berechnung der Einstrahlung auf alle Teilflaechen eines Gebaeudes
</DOC>
*/

model RadiationCalc
  import Lib.Math.atan_deg;

  //parameters
  parameter Real h_at = env.H_gf_0 + env.H_gf + env.H_uf + (env.H_r - (env.H_gf_0 + env.H_gf + env.H_uf)) / 2;
  parameter Real h_uf = env.H_gf_0 + env.H_gf + env.H_uf / 2;
  parameter Real h_gf = env.H_gf_0 + env.H_gf / 2;
  parameter Real h_bm = env.H_gf_0 / 2;
  parameter Real az = env.azimuth;
  parameter Real sl = env.phi_roof_deg;

  //components
  parameter Lib.DH.EnvelopeCfg env;
  parameter Lib.DH.LocationCfg loc;
  //
  Lib.Misc.Clock clock;
  Lib.Meteo.TRY_Source src;
  Lib.Meteo.Solar.Sun sun;

  //attic
  Lib.Meteo.Solar.Surface atn(Azimuth=az, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_n - h_at) / loc.Ds_n) ); 
  Lib.Meteo.Solar.Surface ats(Azimuth=az+180, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_s - h_at) / loc.Ds_s) ); 
  Lib.Meteo.Solar.Surface atre(Azimuth=az+90, Slope=sl, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_e - h_at) / loc.Ds_e) ); 
  Lib.Meteo.Solar.Surface atrw(Azimuth=az+270, Slope=sl, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_w - h_at) / loc.Ds_w) ); 
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc_at "Fenster-Konf. AT";

  //upperfloor
  Lib.Meteo.Solar.Surface ufn(Azimuth=az, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_n - h_uf) / loc.Ds_n) ); 
  Lib.Meteo.Solar.Surface ufe(Azimuth=az+90, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_e - h_uf) / loc.Ds_e) ); 
  Lib.Meteo.Solar.Surface ufs(Azimuth=az+180, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_s - h_uf) / loc.Ds_s) ); 
  Lib.Meteo.Solar.Surface ufw(Azimuth=az+270, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_w - h_uf) / loc.Ds_w) ); 
  Lib.Meteo.Solar.Surface ufre(Azimuth=az+90, Slope=sl, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_e - h_uf) / loc.Ds_e) ); 
  Lib.Meteo.Solar.Surface ufrw(Azimuth=az+180, Slope=sl, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_w - h_uf) / loc.Ds_w) ); 
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc_uf "Fenster-Konf. OG";

  //groundfloor
  Lib.Meteo.Solar.Surface gfn(Azimuth=az, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_n - h_gf) / loc.Ds_n) ); 
  Lib.Meteo.Solar.Surface gfe(Azimuth=az+90, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_e - h_gf) / loc.Ds_e) ); 
  Lib.Meteo.Solar.Surface gfs(Azimuth=az+180, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_s - h_gf) / loc.Ds_s) ); 
  Lib.Meteo.Solar.Surface gfw(Azimuth=az+270, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_w - h_gf) / loc.Ds_w) ); 
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc_gf "Fenster-Konf. EG";

  //basement
  Lib.Meteo.Solar.Surface bmn(Azimuth=az, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_n - h_bm) / loc.Ds_n) ); 
  Lib.Meteo.Solar.Surface bme(Azimuth=az+90, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_e - h_bm) / loc.Ds_e) ); 
  Lib.Meteo.Solar.Surface bms(Azimuth=az+180, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_s - h_bm) / loc.Ds_s) ); 
  Lib.Meteo.Solar.Surface bmw(Azimuth=az+270, Slope=90, Albedo=loc.Albedo, Horizon=atan_deg((loc.Hs_w - h_bm) / loc.Ds_w) ); 
  parameter Lib.Buildings.Floors.FloorWindowCfg fwc_bm "Fenster-Konf. KG";

  //connectors

  //variables
  Real G_win_at_n;
  Real G_win_at_s;
  Real G_win_at "Einstrahlung Fenster SB [W]";
  Real E_win_at(start=0, fixed=true) "Einstrahlung Fenster SB [kWh]";
  Real G_win_uf_n;
  Real G_win_uf_e;
  Real G_win_uf_s;
  Real G_win_uf_w;
  Real G_win_uf "Einstrahlung Fenster OG [W]";
  Real E_win_uf(start=0, fixed=true) "Einstrahlung Fenster OG [kWh]";
  Real G_win_gf_n;
  Real G_win_gf_e;
  Real G_win_gf_s;
  Real G_win_gf_w;
  Real G_win_gf "Einstrahlung Fenster EG [W]";
  Real E_win_gf(start=0, fixed=true) "Einstrahlung Fenster EG [kWh]";
  Real G_win_bm_n;
  Real G_win_bm_e;
  Real G_win_bm_s;
  Real G_win_bm_w;
  Real G_win_bm "Einstrahlung Fenster KG [W]";
  Real E_win_bm(start=0, fixed=true) "Einstrahlung Fenster KG [kWh]";
  Real E_win(start=0, fixed=true) "Einstrahlung alle Fenster [kWh]";
  //eod

equation
  connect(clock.r_day, sun.r_day);
  connect(clock.hour_moz, sun.hour_moz);

  //attic
  connect(src.try_out.G_dir_hor, atre.G_dir_hor);
  connect(src.try_out.G_diff_hor, atre.G_diff_hor); 
  connect(src.try_out.G_dir_hor, atrw.G_dir_hor);
  connect(src.try_out.G_diff_hor, atrw.G_diff_hor); 
  connect(src.try_out.G_dir_hor, atn.G_dir_hor);
  connect(src.try_out.G_diff_hor, atn.G_diff_hor); 
  connect(src.try_out.G_dir_hor, ats.G_dir_hor);
  connect(src.try_out.G_diff_hor, ats.G_diff_hor); 

  //upperfloor
  connect(src.try_out.G_dir_hor, ufn.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufn.G_diff_hor);
  connect(src.try_out.G_dir_hor, ufe.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufe.G_diff_hor);
  connect(src.try_out.G_dir_hor, ufs.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufs.G_diff_hor); 
  connect(src.try_out.G_dir_hor, ufw.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufw.G_diff_hor); 
  connect(src.try_out.G_dir_hor, ufre.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufre.G_diff_hor); 
  connect(src.try_out.G_dir_hor, ufrw.G_dir_hor);
  connect(src.try_out.G_diff_hor, ufrw.G_diff_hor); 

  //groundfloor
  connect(src.try_out.G_dir_hor, gfn.G_dir_hor);
  connect(src.try_out.G_diff_hor, gfn.G_diff_hor); 
  connect(src.try_out.G_dir_hor, gfe.G_dir_hor);
  connect(src.try_out.G_diff_hor, gfe.G_diff_hor); 
  connect(src.try_out.G_dir_hor, gfs.G_dir_hor);
  connect(src.try_out.G_diff_hor, gfs.G_diff_hor); 
  connect(src.try_out.G_dir_hor, gfw.G_dir_hor);
  connect(src.try_out.G_diff_hor, gfw.G_diff_hor); 

  //basement
  connect(src.try_out.G_dir_hor, bmn.G_dir_hor);
  connect(src.try_out.G_diff_hor, bmn.G_diff_hor); 
  connect(src.try_out.G_dir_hor, bme.G_dir_hor);
  connect(src.try_out.G_diff_hor, bme.G_diff_hor); 
  connect(src.try_out.G_dir_hor, bms.G_dir_hor);
  connect(src.try_out.G_diff_hor, bms.G_diff_hor); 
  connect(src.try_out.G_dir_hor, bmw.G_dir_hor);
  connect(src.try_out.G_diff_hor, bmw.G_diff_hor); 



  //attic
  connect(sun.alpha, atre.alpha_sun);
  connect(sun.gamma, atre.gamma_sun); 
  connect(sun.alpha, atrw.alpha_sun);
  connect(sun.gamma, atrw.gamma_sun); 
  connect(sun.alpha, atn.alpha_sun);
  connect(sun.gamma, atn.gamma_sun); 
  connect(sun.alpha, ats.alpha_sun);
  connect(sun.gamma, ats.gamma_sun); 

  //upperfloor
  connect(sun.alpha, ufn.alpha_sun);
  connect(sun.gamma, ufn.gamma_sun);
  connect(sun.alpha, ufe.alpha_sun);
  connect(sun.gamma, ufe.gamma_sun);
  connect(sun.alpha, ufs.alpha_sun);
  connect(sun.gamma, ufs.gamma_sun); 
  connect(sun.alpha, ufw.alpha_sun);
  connect(sun.gamma, ufw.gamma_sun); 
  connect(sun.alpha, ufre.alpha_sun);
  connect(sun.gamma, ufre.gamma_sun); 
  connect(sun.alpha, ufrw.alpha_sun);
  connect(sun.gamma, ufrw.gamma_sun); 

  //groundfloor
  connect(sun.alpha, gfn.alpha_sun);
  connect(sun.gamma, gfn.gamma_sun); 
  connect(sun.alpha, gfe.alpha_sun);
  connect(sun.gamma, gfe.gamma_sun); 
  connect(sun.alpha, gfs.alpha_sun);
  connect(sun.gamma, gfs.gamma_sun); 
  connect(sun.alpha, gfw.alpha_sun);
  connect(sun.gamma, gfw.gamma_sun); 

  //basement
  connect(sun.alpha, bmn.alpha_sun);
  connect(sun.gamma, bmn.gamma_sun); 
  connect(sun.alpha, bme.alpha_sun);
  connect(sun.gamma, bme.gamma_sun); 
  connect(sun.alpha, bms.alpha_sun);
  connect(sun.gamma, bms.gamma_sun); 
  connect(sun.alpha, bmw.alpha_sun);
  connect(sun.gamma, bmw.gamma_sun);

  // Einstrahlung Fenster SB
  G_win_at_n = atn.f_g_transp * atn.G * fwc_at.N_n * fwc_at.A_n; 
  G_win_at_s = ats.f_g_transp * ats.G * fwc_at.N_s * fwc_at.A_s;
  G_win_at = G_win_at_n + G_win_at_s;
  der(E_win_at) = G_win_at / 1000;

  // Einstrahlung Fenster OG
  G_win_uf_n = ufn.f_g_transp * ufn.G * fwc_uf.N_n * fwc_uf.A_n;
  G_win_uf_e = ufe.f_g_transp * ufe.G * fwc_uf.N_e * fwc_uf.A_e; 
  G_win_uf_s = ufs.f_g_transp * ufs.G * fwc_uf.N_s * fwc_uf.A_s;
  G_win_uf_w = ufw.f_g_transp * ufw.G * fwc_uf.N_w * fwc_uf.A_w; 
  G_win_uf = G_win_uf_n + G_win_uf_e + G_win_uf_s + G_win_uf_w;
  der(E_win_uf) = G_win_uf / 1000;

  // Einstrahlung Fenster EG
  G_win_gf_n = gfn.f_g_transp * gfn.G * fwc_gf.N_n * fwc_gf.A_n;
  G_win_gf_e = gfe.f_g_transp * gfe.G * fwc_gf.N_e * fwc_gf.A_e; 
  G_win_gf_s = gfs.f_g_transp * gfs.G * fwc_gf.N_s * fwc_gf.A_s; 
  G_win_gf_w = gfw.f_g_transp * gfw.G * fwc_gf.N_w * fwc_gf.A_w; 
  G_win_gf = G_win_gf_n + G_win_gf_e + G_win_gf_s + G_win_gf_w;
  der(E_win_gf) = G_win_gf / 1000;

  // Einstrahlung Fenster KG
  G_win_bm_n = bmn.f_g_transp * bmn.G * fwc_bm.N_n * fwc_bm.A_n;
  G_win_bm_e = bme.f_g_transp * bme.G * fwc_bm.N_e * fwc_bm.A_e;
  G_win_bm_s = bms.f_g_transp * bms.G * fwc_bm.N_s * fwc_bm.A_s; 
  G_win_bm_w = bmw.f_g_transp * bmw.G * fwc_bm.N_w * fwc_bm.A_w; 
  G_win_bm = G_win_bm_n + G_win_bm_e + G_win_bm_s + G_win_bm_w;
  der(E_win_bm) = G_win_bm / 1000;

  E_win = E_win_at + E_win_uf + E_win_gf + E_win_bm;

end RadiationCalc;