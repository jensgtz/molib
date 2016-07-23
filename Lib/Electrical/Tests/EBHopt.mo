within Lib.Electrical.Tests;

model EBHopt
  //parameters

  //components
  Lib.Electrical.Loads.TableLoad load(E_a = 4000) "Last";
  Lib.Electrical.Storages.Battery bat(C = 15) "Batteriesystem";
  Lib.Electrical.Generators.Generator gen(P_n = 2500) "Stromaggregat";
  Lib.Electrical.Photovoltaic.System1 pv_east() "PV-Ost";
  Lib.DH.RadiationData rd_east(part="atre_G") "PV-Ost Einstrahlung";
  Lib.Electrical.Photovoltaic.System1 pv_west() "PV-West";
  Lib.DH.RadiationData rd_west(part="atrw_G") "PV-West Einstrahlung";
  Lib.Electrical.AcTerminal term "Sammelschiene";
  Lib.Electrical.Controllers.EMS1 ems "EMS";
  Lib.Electrical.PowerGrid grid "Versorgungsnetz";
  //
  Lib.Economic.ConditionsModel eco_cond "wirtschaftl. Rahmenbed.";

  //connectors
  //variables
  //eod

equation
  connect(grid.ac, term.ac);
  connect(load.ac, term.ac);
  connect(bat.ac, term.ac);
  connect(gen.ac, term.ac);
  connect(pv_east.ac, term.ac);
  connect(rd_east.G, pv_east.G);
  connect(pv_west.ac, term.ac);
  connect(rd_west.G, pv_west.G);
  //
  connect(load.emb, ems.emb1);
  connect(bat.emb, ems.emb2);
  connect(gen.emb, ems.emb3);
  connect(pv_east.emb, ems.emb4);
  connect(pv_west.emb, ems.emb5);
  connect(grid.P_sn, ems.P_sn);
end EBHopt;