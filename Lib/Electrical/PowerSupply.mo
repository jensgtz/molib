within Lib.Electrical;

model PowerSupply
  //parameters

  //components
  Lib.Electrical.PowerGrid grid(in_use=not(offgrid.is_installed)) "netzgekoppeltes System";
  Lib.Electrical.OffGridSystem offgrid "netzautarkes System";
  Lib.Electrical.AcSource grid_src "Netz Quelle";
  Lib.Electrical.AcSource offgrid_src "Autark Quelle";

  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC-Anschluss";
  Lib.RealInput x_chp "Anteil KWK-Strom [1]";
  Lib.RealInput x_pv "Anteil PV-Strom [1]";
  Lib.RealOutput SOC_rel "Batterie-Status SOC_r [1]";
  Lib.RealOutput P_dump "Leistung Heizelement [W]";

  //variables
  Real f_grid;
  Real P_el "el. Leistung [W]";

  //eod

equation
  f_grid = if noEvent(offgrid.is_installed) then 0 else 1;
  ac.f = 50;
  P_el = ac.p;

  // netzgekoppelte Stromversorgung
  connect(grid.ac, grid_src.ac);
  grid_src.P_set = f_grid * P_el;
  connect(x_chp, grid.x_chp);
  connect(x_pv, grid.x_pv);

  // netzautarke Stromversorgung
  connect(offgrid.ac, offgrid_src.ac);
  offgrid_src.P_set = (1-f_grid) * P_el;
  connect(offgrid.SOC_rel, SOC_rel);
  connect(offgrid.P_dump, P_dump);

end PowerSupply;