within Lib.Electrical;

/*
<DOC>
Verknuepfungspunkt ohne eigenes Verhalten

[ENV]
http://www.oekobaudat.de/OEKOBAU.DAT/datasetdetail/process.xhtml?uuid=4cb7ca91-5be5-4fa6-99c1-99f597310351&lang=de
</DOC>
*/

model AcTerminal
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac;
  //variables
  //eod

equation
  ac.p = 0;

end AcTerminal;