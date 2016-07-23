within Lib.Buildings.Constructions;

model Layer "allgemeine Huellflaeche"
  //parameters
  parameter Real A = 1 "Flaeche / area [m2]";
  parameter Real d = 1 "Staerke / thickness [m]";
  parameter Real lambda = 1 "thermal conductivity [W/(m*K)]";
  parameter Real rho = 1 "Dichte / density [kg/m3]";
  parameter Real cp = 1 "spzifische Waermekapazitaet / specific heat capacity [kJ/(kg*K)]";
  parameter Real U = lambda / d "Waermedurchgangskoeffizient (U-Wert) / heat transition coefficient [W/(m2*K)]";
  parameter Real R = 1 / (U * A) "Waermedurchgangswiderstand / thermal resistance [K/W]";
  parameter Real T_start = 293.15 "start temperature [K]";
  //components
  Lib.Thermal.Resistor outside_resistor(R = R / 2);
  Lib.Thermal.Capacity capacity(V = A * d, rho = rho, cp = cp);
  Lib.Thermal.Resistor inside_resistor(R = R / 2);
  //connectors
  Lib.Thermal.Interfaces.HeatPort inside_heatport;
  Lib.Thermal.Interfaces.HeatPort outside_heatport;
  //variables
  Real Q_flow;
  Real Q(start = 0);
  //eod
equation
  connect(outside_heatport, outside_resistor.left);
  connect(outside_resistor.right, inside_resistor.left);
  connect(inside_resistor.right, inside_heatport);
  connect(outside_resistor.right, capacity.heatport);
  Q_flow = inside_resistor.Q_flow;
  der(Q) = Q_flow;
end Layer;