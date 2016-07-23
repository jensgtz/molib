within Lib.Buildings.VDI6020;

/*
<DOC>
Lib.Buildings.Elements2.ExtWallBeuken ceiling(A=17.5, param=p_ceiling, T_start=273.15+22) "Decke";
  Lib.Buildings.Elements2.ExtWallBeuken floor(A=17.5, param=p_floor, T_start=273.15+22) "Fuszboden";
  Lib.Buildings.Elements2.ExtWallBeuken wall(A=3.5, param=p_wall, T_start=273.15+22) "Auszenwand";
  Lib.Buildings.Elements2.ExtWallBeuken iwall(A=40.5, param=p_iwall, T_start=273.15+22) "Innenwaende";
</DOC>
*/

model Example1
  //parameters
  parameter Real V_air = 52.5 "[m3]";
  //components
  parameter Lib.Buildings.Elements.CeilingParam p_ceiling "Eigenschaften Decke";
  parameter Lib.Buildings.Elements.FloorParam p_floor "Eigenschaften Fuszboden";
  parameter Lib.Buildings.Elements.WallParam p_wall "Eigenschaften AW";
  parameter Lib.Buildings.Elements.IntWallParam p_iwall "Eigenschaften IW";
  parameter Lib.Buildings.Elements.WindowParam p_window "Eigenschaften Fenster";
  //
  Lib.Misc.Clock clock "Uhr";
  Lib.Thermal.ConstantTemperature ext_temp(T=273.15+22) "Auszentemperatur";
  Lib.Thermal.ConstantHeatSource hs_floor(P=0) "HS1 P=0";
  Lib.Thermal.ConstantHeatSource hs_ceiling(P=0) "HS2 P=0";
  Lib.Thermal.ConstantHeatSource hs_iwall(P=0) "HS3 P=0";
  Lib.Thermal.HeatSource hs_machines "Maschinen, konvektiv";
  //
  Lib.Buildings.Elements2.ExtWall ceiling(A=17.5, param=p_ceiling, T_start=273.15+22) "Decke";
  Lib.Buildings.Elements2.ExtWall floor(A=17.5, param=p_floor, T_start=273.15+22) "Fuszboden";
  Lib.Buildings.Elements2.ExtWall wall(A=3.5, param=p_wall, T_start=273.15+22) "Auszenwand";
  Lib.Buildings.Elements2.ExtWall iwall(A=40.5, param=p_iwall, T_start=273.15+22) "Innenwaende";
  Lib.Buildings.Elements2.Window win(A=7, param=p_window, T_start=273.15+22) "Fenster";
  //
  Lib.Thermal.Capacity air(C=V_air * 1.2306 * 1006.1, T_start=273.15+22) "Innenluftvolumen";
  //connectors
  //variables
  Boolean machines_on(start=false, fixed=true) "M on [-]";
  Real T_deg "Temp [degC]";
  Real T_deg2 "Temp [degC]";
  Real Tx(start=0, fixed=true) "xTemp. [degC]";
  Real T_m "mittlere Temperatur [degC]";
  //eod
  Modelica.Blocks.Tables.CombiTable1D tbl(table=[0.0346821,21.9840;1.92486,21.9840;4.17919,22.0011;5.35838,21.9669;6,21.9669;6.50289,25.0798;6.76301,26.7902;6.98844,28.1585;11.8092,29.1676;15.6069,29.9373;17.9480,30.4162;18.4335,27.7993;18.7283,25.9008;19.0058,24.5154;20.4798,24.4641;22.5434,24.4470;23.9306,24.3786], smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);

equation
  connect(ceiling.hp_int, air.hp);
  connect(ceiling.hp_ext, hs_ceiling.heatport);
  //
  connect(floor.hp_int, air.hp);
  connect(floor.hp_ext, hs_floor.heatport);
  //
  connect(wall.hp_int, air.hp);
  connect(wall.hp_ext, ext_temp.hp);
  //
  connect(iwall.hp_int, air.hp);
  connect(iwall.hp_ext, hs_iwall.heatport);
  //
  connect(win.hp_int, air.hp);
  connect(win.hp_ext, ext_temp.hp);
  //
  when {clock.hour_local >= 6, clock.hour_local > 18} then
    machines_on = clock.hour_local <= 18;
  end when;
  hs_machines.P_th = if noEvent(machines_on) then 1000 else 0;
  connect(hs_machines.hp, air.hp);
  //
  der(Tx) = air.hp.T - 273.15;
  T_m = Tx / 1440;
  T_deg = air.hp.T - 273.15;
  //
  tbl.u[1] = time;
  T_deg2 = tbl.y[1];

end Example1;