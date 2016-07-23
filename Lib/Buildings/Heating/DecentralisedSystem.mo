within Lib.Buildings.Heating;

/*
<DOC>
Heizung und Warmwasserversorgung mittels:
- Holzoefen
- Badeofen
</DOC>
*/

model DecentralisedSystem
  //parameters

  //components
  Lib.Buildings.Heating.WoodStoves woodstoves "Holzoefen";
  Lib.Buildings.HotWater.BathWaterHeater bathwaterheater "Badeofen";

  //connectors
  Lib.RealInput clock_hour "Uhrzeit";
  Lib.Thermal.Interfaces.HeatPort hp_int "Raumluft";
  Lib.Thermal.Interfaces.HeatPort hp_hw "Warmwasser";

  //variables
  //eod

equation
  // Holzoefen  
  woodstoves.clock_hour = clock_hour;
  connect(woodstoves.hp_air, hp_int);

  // Badeofen
  bathwaterheater.clock_hour = clock_hour;
  connect(bathwaterheater.hp_air, hp_int);
  connect(bathwaterheater.hp_hw, hp_hw);

end DecentralisedSystem;