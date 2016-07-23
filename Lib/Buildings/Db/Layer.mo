within Lib.Buildings.Db;

model Layer
  //imports
  import Lib.Buildings.Db.getLambda;
  import Lib.Buildings.Db.getRho;
  import Lib.Buildings.Db.getCp;
  import Lib.Buildings.Db.getD;

  //parameters
  parameter Integer construction_id "";
  parameter Integer i_block "";
  parameter Integer i_layer "";
  parameter Integer material_id =  Lib.Buildings.Db.getMaterialID(construction_id=construction_id, i_block=i_block, i_layer=i_layer) "reference to material";
  parameter Real A "area [m2]";
  parameter Real d = getD(construction_id=construction_id, i_block=i_block, i_layer=i_layer) "Staerke / thickness [m]";
  parameter Real lambda = getLambda(material_id) "thermal conductivity [W/(m*K)]";
  parameter Real rho = getRho(material_id) "Dichte / density [kg/m3]";
  parameter Real cp = getCp(material_id) "spzifische Waermekapazitaet / specific heat capacity [J/(kg*K)]";
  parameter Real U = lambda / d "Waermedurchgangskoeffizient (U-Wert) / heat transition coefficient [W/(m2*K)]";
  parameter Real R = 1 / (U * A) "Waermedurchgangswiderstand / thermal resistance [K/W]";
  parameter Real T_start = 283.15 "start temperature [K]";

  //components
  Lib.Thermal.Resistor resistor1(R = R / 2);
  Lib.Thermal.Capacity capacity(V = A * d, rho = rho, cp = cp);
  Lib.Thermal.Resistor resistor2(R = R / 2);
  
  //connectors
  Lib.Thermal.Interfaces.HeatPort hp1 "";
  Lib.Thermal.Interfaces.HeatPort hp2 "";
  
  //variables
  //Real T_deg "inner temperature [degC]";

  //eod
equation
  connect(hp1, resistor1.hp1);
  connect(resistor1.hp2, resistor2.hp1);
  connect(resistor1.hp2, capacity.hp);
  connect(resistor2.hp2, hp2);
  //
  //T_deg = capacity.T_deg;
end Layer;