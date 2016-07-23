within Lib.Tests;

model PC
  //parameters
  parameter Real clock = 1000 "[Mhz]";
  //components
  //connectors
  Lib.Tests.LAN lan1 "lan port 1";
  Lib.Tests.LAN lan2 "lan port 2";
  //variables
  //eod
end PC;