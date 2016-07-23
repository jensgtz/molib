within Lib.Tests;

model PCTest
  //parameters
  parameter Real n = 3 "number ...";
  //components
  Lib.Tests.PC pc1 "PC1";
  Lib.Tests.PC pc2(clock=2000) "PC2";
  Lib.Tests.PC pc3(clock=3000, name="pc_3") "PC3";
  //connectors
  Lib.Tests.LAN lan "ext lan";
  //variables
  //eod
equation
  connect(lan, pc1.lan1);
  connect(pc1.lan2, pc2.lan1);
  connect(pc2.lan2, pc3.lan1);
  connect(pc3.lan2, lan);
end PCTest;