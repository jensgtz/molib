within Lib.Thermal;

/*
<DOC>
- Konvention: eingehende Fluesse positiv
</DOC>
*/

model ConstantHeatSource
  //parameters
  parameter Real P = 0 "[W]";
  //components
  //connectors
  Lib.Thermal.Interfaces.HeatPort heatport;
  //variables
  //eod
equation
  heatport.Q_flow = -P;
end ConstantHeatSource;