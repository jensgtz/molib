within Lib.Buildings.Db;

function getLambda
  input Integer material_id;
  output Real lambda;
algorithm
  lambda := Lib.Data.pgReal("select lambda from buildings.material where id=" + String(material_id));
end getLambda;