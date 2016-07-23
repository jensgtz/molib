within Lib.Thermal;

model RadiationTransmission
  //parameters
  parameter Real A = 1 "Flaeche [m2]";
  parameter Real tau = 0 "mittlerer Transmissionsgrad [1]";
  //components
  //connectors
  Lib.RealInput G "Einstrahlung [W/m2]";
  Lib.RealOutput P_tsr "Transmission [W]";
  //variables
  //eod
equation
  P_tsr = tau * G * A;
end RadiationTransmission;