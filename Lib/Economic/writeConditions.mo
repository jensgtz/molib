within Lib.Economic;

/*
<DOC>
T_s == 0: Simulationszeit T_s_real uebernehmen
</DOC>
*/

function writeConditions
  input Lib.Economic.Conditions cond;
  input Real T_s_real "Simulationszeitraum nach Zeit am Simulationsende [a]";
protected
  constant String PATH = "./res/eco_cond.txt";
algorithm
  Modelica.Utilities.Files.removeFile(PATH);
  if cond.T_s > 0 then
      Modelica.Utilities.Streams.print(String(cond.p_z) + "\n" + String(cond.p_k) + "\n" + String(cond.p_e) + " \n" + String(cond.T_b) + "\n" + String(cond.T_s) + "\n" + String(cond.f_ek) + "\n" + String(cond.kfw_prod), PATH);
  else
    Modelica.Utilities.Streams.print(String(cond.p_z) + "\n" + String(cond.p_k) + "\n" + String(cond.p_e) + " \n" + String(cond.T_b) + "\n" + String(T_s_real) + "\n" + String(cond.f_ek) + "\n" + String(cond.kfw_prod), PATH);
  end if;
  Modelica.Utilities.Streams.close(PATH);
end writeConditions;