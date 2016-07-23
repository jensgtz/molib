within Lib.Technical;

/*
<DOC>
Basisklasse fuer technische Objekte
</DOC>
*/

model TechObject
  //parameters
  parameter String tech__name = "noname" "Bezeichnung [-]";
  parameter Boolean tech__exists = true "Objekt existiert ja/nein [-]";
  parameter Real tech__TL = 20 "Lebensdauer [a]";
  parameter Real tech__mass = 0 "Masse des Objektes [kg]";
  //components
  //connectors
  //variables
  //eod
end TechObject;