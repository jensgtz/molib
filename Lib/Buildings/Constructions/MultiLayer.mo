within Lib.Buildings.Constructions;

model MultiLayer
  //parameters
  parameter Integer construction_id = 1;
  parameter Integer n_layers;
  //components
  Layer[n_layers] layers;
  //connectors
  Lib.Thermal.Interfaces.HeatPort left_heatport;
  Lib.Thermal.Interfaces.HeatPort right_heatport;
  //variables
  //eod
equation
  for i in 1:n_layers - 1 loop
    connect(layers[i].right_heatport, layers[i + 1].left_heatport);
  end for;
  connect(left_heatport, layers[1].left_heatport);
  connect(layers[n_layers].right_heatport, right_heatport);
end MultiLayer;