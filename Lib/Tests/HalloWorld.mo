within Lib.Tests;

/*
<DOC>
returns time multiplied by constant value
</DOC>
*/

model HalloWorld
  //parameters
  parameter String name = "Hallo";
  parameter Real a = 10;
  //components
  //connectors
  //variables
  Real y;
  //eod
equation
  y = a * time;
end HalloWorld;