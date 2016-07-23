within Lib.Environmental;

model EnvImpactObject
  //parameters
  parameter Real env__KEA_h = 0 "spezif. kumulierter Energieaufwand, Herstellungsphase [kWh/X]";
  parameter Real env__KEA_h_ne = 0 "spezif. kumulierter Energieaufwand, Herstellungsphase, n.e. [kWh/X]";

  //components

  //connectors

  //variables
  Lib.Environmental.Results env__res "Ergebnisse";

  //eod

algorithm
  when terminal() then
    Lib.Environmental.writeResults(name = getInstanceName(), res = env__res); 
  end when;

end EnvImpactObject;