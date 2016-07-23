within Lib.Buildings.Db;

function getMeanR
  input Integer construction_id;
  output Real mean_r;
algorithm
  mean_r := Lib.Data.pgReal("select mean_r from buildings.construction where id=" + String(construction_id));
end getMeanR;