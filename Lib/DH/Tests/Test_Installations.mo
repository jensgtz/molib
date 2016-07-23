within Lib.DH.Tests;

model Test_Installations
  //parameters
  //components
  Lib.DH.Installations inst;
  //connectors
  //variables
  //eod
equation
  //inst.hp_ext.T = 265;
  //inst.hp_at.T = 270;
  inst.hp_gfuf.T = 290;
  inst.hp_bm.T = 280;

end Test_Installations;