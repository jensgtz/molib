within Lib.Environmental;

function writeResults
  input String name;
  input Lib.Environmental.Results res;
protected
  constant String PATH = "./res/env_res.csv";
algorithm
  Modelica.Utilities.Streams.print(name + ";" + String(res.T_n) + ";" + String(res.Q_e) + ";" + String(res.Q_p) + ";" + String(res.Q_pne) + ";" + String(res.KEA) + ";" + String(res.KEA_ne), PATH);
  Modelica.Utilities.Streams.close(PATH);
end writeResults;