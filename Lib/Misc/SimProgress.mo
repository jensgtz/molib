within Lib.Misc;

model SimProgress
  //parameters
  parameter Real TimeStep = 24 "Zeitschritt [h]";
  parameter String LogPath = "./sim_progress.txt" "Datei-Pfad";
  //components
  //connectors
  //variables
  //eod
equation
  when sample(0, TimeStep) then
    Modelica.Utilities.Streams.print(String(time), LogPath);
  end when;
end SimProgress;