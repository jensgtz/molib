within Lib.Thermal;

/*
<DOC>
- Umsetzung der Einstrahlung in Waerme
- lineare Anpassung ueber Absorptionskoeffizient
</DOC>
*/

model RadiationHeatSource
  //parameters
  parameter Real A "Flaeche [m2]";
  parameter Real alpha "Absorptionskoeffizient [1]";
  //components
  //connectors
  Lib.RealInput G "Einstrahlung [W/m2]";
  Lib.Thermal.Interfaces.HeatPort hp "Waeme";
  //variables
  //eod
equation
  hp.Q_flow = -1 * alpha * G * A;
end RadiationHeatSource;