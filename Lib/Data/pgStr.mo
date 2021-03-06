within Lib.Data;

/*
<DOC>
postgresql database interface

- newlines have to be escaped by python scricpt
</DOC>
*/

function pgStr
  input String sql;
  output String result;
protected
  String path;
  Integer cmd_result;
  String file_string;
  Boolean eof;
algorithm
  path := "/home/uzanto/web/ba/modelica/pgexec.out";
  cmd_result := Modelica.Utilities.System.command("python /home/uzanto/web/ba/modelica/pgexec.py \"1s\" \"" + sql + "\" \"" + path + "\"");
  (file_string, eof) := Modelica.Utilities.Streams.readLine(path, 1);
  result := file_string;
  Modelica.Utilities.Streams.close(path);
  //Modelica.Utilities.Files.remove(path);
end pgStr;