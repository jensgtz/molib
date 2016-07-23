within Lib.Meteo;

model SoilTemperature
  //parameters
  parameter Real A = 1 "Oberflaeche [m2]";
  parameter Real R_s = 0.1 "Waermeuebergangswiderstand Grenzschicht [(m2*K)/W]";
  parameter Real T_1500 = 9.5 + 273.15 "T in 15 m Tiefe [K]";
  parameter Real T_start = 273.15 + 1.5 "Temperatur der 1. Schicht (0.25 m) zu Beginn [K]";
  parameter Real lambda = 2 "Waermeleitfaehigkeit [W/(m*K)]";
  parameter Real cp = 2000 / 3.6 "volumetrische Waermekapazitaet [Wh/(m3*K)]";

  //calculated
  parameter Real R[6] = {0.5/lambda, 0.5/lambda, 0.5/lambda, 3.5/lambda, 5/lambda, 5/lambda} "R-Werte [(m2*K)/W]";
  parameter Real C[6] = {0.5*cp, 0.5*cp, 0.5*cp, 3.5*cp, 5*cp, 5*cp} "C-Werte [Wh/(m2*K)]";

  //components
  Lib.Thermal.Resistor transfer(R=R_s) "WUe Luft-Boden";
  Lib.Buildings.Elements2.BeukenModel beuken(A=A, N=6, R=R, C=C, T_1_start=T_start, T_N_start=T_1500) "Boden-Schichten";
  Lib.Thermal.ConstantTemperature consttemp(T=T_1500) "Konstant-Temperatur";
 
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp_air "Auszenluftknoten";
  Lib.RealOutput T_0_deg;
  Lib.RealOutput T_50_deg;
  Lib.RealOutput T_100_deg;
  Lib.RealOutput T_150_deg;
  Lib.RealOutput T_500_deg;
  Lib.RealOutput T_1000_deg;

  //variables

  //eod

equation
  connect(hp_air, transfer.hp1);
  connect(transfer.hp2, beuken.hp1);
  connect(beuken.hp2, consttemp.hp);

  //
  T_0_deg = beuken.res1[1].hp1.T - 273.15;
  T_50_deg = beuken.res1[2].hp1.T - 273.15;
  T_100_deg = beuken.res1[3].hp1.T - 273.15;
  T_150_deg = beuken.res1[4].hp1.T - 273.15;
  T_500_deg = beuken.res1[5].hp1.T - 273.15;
  T_1000_deg = beuken.res1[6].hp1.T - 273.15;

end SoilTemperature;