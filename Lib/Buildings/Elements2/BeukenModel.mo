within Lib.Buildings.Elements2;

model BeukenModel

  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Integer N = 10 "Anzahl Elemente [-]";
  parameter Real R[N] = ones(N) "Widerstandswerte [m2*K/W]";
  parameter Real C[N] = ones(N) "Kapazitaetswerte [Wh/(m2*K)]";
  parameter Real T_1_start = 293.15 "Start-Temperatur 1. Schicht [K]";
  parameter Real T_N_start = 273.15 "Start-Temperatur N. Schicht [K]";

  //components
  Lib.Thermal.ResistorX res1[N] "halbe Waermeleitwiderstaende links";
  Lib.Thermal.ResistorX res2[N] "halbe Waermeleitwiderstaende rechts";
  Lib.Thermal.CapacityX cap[N] "Waermekapazitaeten";

  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "Knoten 1";
  Lib.Thermal.Interfaces.HeatPort hp2 "Knoten 2";

  //variables
  Real T_deg[N] "Temperaturen [degC]";

  //eod

initial equation
  // Start-Temperaturen der Schichten setzen
  for i in 1:N loop
    cap[i].hp.T = (T_N_start - T_1_start) * (i / N) + T_1_start;
  end for;

equation
  // Auszenverbindung
  connect(hp1, res1[1].hp1);
  connect(hp2, res2[N].hp2);

  // Verbinden von R1, R2 und C je Schicht
  for i in 1:N loop
    connect(res1[i].hp2, cap[i].hp);
    connect(res2[i].hp1, cap[i].hp);
  end for;

  // Verbinden der Schichten untereinander
  for i in 1:N - 1 loop
    connect(res2[i].hp2, res1[i + 1].hp1);
  end for;

  // Zuweisen von R- und C-Werten
  for i in 1:N loop
    cap[i].C = C[i] * A;
    res1[i].R = 0.5 * R[i] / A;
    res2[i].R = 0.5 * R[i] / A;
  end for;

  // Grad Celsius - Temperaturen
  for i in 1:N loop
    T_deg[i] = cap[i].hp.T - 273.15;
  end for;

end BeukenModel;