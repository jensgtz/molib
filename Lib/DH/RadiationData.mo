within Lib.DH;

/*
<DOC>
ContinuousDerivative
LinearSegments
ConstantSegments
</DOC>
*/

model RadiationData
  //parameters
  parameter String part = "atrw_G" "Flaechen-Bezeichner";
  parameter String path = "./data/dhrad/" + part + ".txt" "Datei-Pfad";
  //components
  Modelica.Blocks.Tables.CombiTable1D table(tableOnFile = true, tableName = part, fileName = path, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  //connectors
  Lib.RealOutput G "Einstrahlung [W/m2]";
  //variables
  //eod

equation
  table.u[1] = time;
  G = table.y[1];

end RadiationData;