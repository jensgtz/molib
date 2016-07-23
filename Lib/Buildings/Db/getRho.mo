within Lib.Buildings.Db;

function getRho
  input Integer material_id;
  output Real rho;
algorithm
  rho := Lib.Data.pgReal("select rho from buildings.material where id=" + String(material_id));
end getRho;