within Lib.Data;

/*
<DOC>
postgresql database interface
</DOC>
*/

function pgReal
  input String sql;
  output Real result;
protected
  String path;
  Integer cmd_result;
  String file_string;
  Boolean eof;
algorithm
  path := "/home/uzanto/web/ba/modelica/pgexec.out";
  cmd_result := Modelica.Utilities.System.command("python /home/uzanto/web/ba/modelica/pgexec.py \"1f\" \"" + sql + "\" \"" + path + "\"");
  (file_string, eof) := Modelica.Utilities.Streams.readLine(path, 1);
  result := Modelica.Utilities.Strings.scanReal(file_string);
  Modelica.Utilities.Streams.close(path);
  //Modelica.Utilities.Files.remove(path);
end pgReal;