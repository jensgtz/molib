within Lib.Economic;

function writeResults
  input String name;
  input Lib.Economic.Results res;
protected
  constant String PATH = "./res/eco_res.csv";
algorithm
  Modelica.Utilities.Streams.print(name + ";" + String(res.K_inv) + ";" + String(res.K_serv) + ";" + String(res.K_op_e) + ";" + String(res.K_op_ne) + ";" + String(res.K_misc) + ";" + String(res.T_n) + ";" + String(res.f_r) + ";" + String(res.action) + ";" + res.flags, PATH);
  Modelica.Utilities.Streams.close(PATH);
end writeResults;