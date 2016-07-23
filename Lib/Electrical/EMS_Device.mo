within Lib.Electrical;

/*
<DOC>
P_el, P_el_pos, P_el_neg, K_el_pos, K_el_neg in Subklassen berechnen
</DOC>
*/

model EMS_Device
  //parameters
  //components
  //connectors
  Lib.Electrical.Interfaces.AcPower ac "AC";
  Lib.Electrical.Interfaces.EMB_DevicePlug emb;
  //variables
  Real P_el "elektrische Leistung [W]";
  Real E_el(start=0, fixed=true) "elektrische Energie [kWh]";
  Real P_el_pos "positive Regelleistungsreserve [W]";
  Real P_el_neg "negative Regelleistungsreserve [W]";
  Real K_el_pos "Kosten der positiven Regelleistung [EUR/kWh]";
  Real K_el_neg "Kosten der positiven Regelleistung [EUR/kWh]";
  //eod

equation
  ac.p = P_el;
  der(E_el) = P_el / 1000;
  emb.P = P_el;
  emb.P_pos = P_el_pos;
  emb.P_neg = P_el_neg;
  emb.K_pos = K_el_pos;
  emb.K_neg = K_el_neg;

end EMS_Device;