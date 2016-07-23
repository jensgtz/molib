within Lib.Electrical;

/*
<DOC>
positive Zaehlrichtung: in -> out
</DOC>
*/

model Meter
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac_in "Eingang";
  Lib.Electrical.Interfaces.AcPower ac_out "Ausgang";
  //variables
  Real P "Leistung [W]";
  Real P_pos "Leistung, vorwaerts [W]";
  Real P_neg "Leistung, rueckwaerts [W]";
  Real E_bal "Energiebilanz [kWh]";
  Real E_pos "Energie, vorwaerts [kWh]";
  Real E_neg "Energie, rueckwaerts [kWh]";
  Real E_sum "Energie, vorwaerts plus rueckwaerts [kWh]";
  //eod

equation
  // Verknuepfung ac_in und ac_out
  connect(ac_in, ac_out);  
//  ac_in.f = ac_out.f;
//  ac_in.p + ac_out.p = 0;
  

  // Leistung
  P = ac_in.p;
  if noEvent(P > 0) then
    P_pos = P;
    P_neg = 0;
  else
    P_pos = 0;
    P_neg = -P;
  end if;
  
  // Energie
  der(E_bal) = P / 1000;
  der(E_pos) = P_pos / 1000;
  der(E_neg) = P_neg / 1000;
  E_sum = E_pos + E_neg;

end Meter;