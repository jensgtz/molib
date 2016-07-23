within Lib.Thermal;

/*
<DOC>
[NGeusen01], S. 123:
q_flow = epsilon_A * sigma * ((T_H)⁴ - (T_A)⁴)
T_H ... Himmelstemperatur
T_A ... Temperatur Bauteilauszenseite

[VDI6020]:
http://ba.localhost/img/Documentation/Thermal/RadiationEmitter/VDI6020_p15.png
</DOC>
*/

model RadiationEmitter
  //constants
  constant Real sigma = 5.670367e-8 "Stefan-Bolzmann-Konstante [W/(m2*K4)]";
  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Real epsilon = 0.5 "mittlerer Emissionsgrad [1]";
  //components
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp;
  Lib.RealOutput P_em;
  //variables
  Real P_th "therm. Leistung Abstrahlung [W]";
  Real E_th "abgestrahlte therm. Leistung [kWh]";
  //eod
equation
  P_th = epsilon * sigma * A * hp.T^4;
  der(E_th) = P_th / 1000;
  hp.Q_flow = P_th;
  P_em = P_th;
end RadiationEmitter;