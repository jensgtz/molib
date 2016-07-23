within Lib.Electrical.Interfaces;

/*
<DOC>
output Real P_1 "[W]";
  output Real P_load_max "[W]";
  output Real P_gen_max "[W]";
  output Real k_gen_1 "[EUR/kWh]";
  output Real k_gen_2 "[EUR/kWh]";
</DOC>
*/

connector EMB_DevicePlug
  input Real P_set "Soll-Leistung [W]";
  output Real P "aktuelle Leistung [W]";
  output Real P_neg "negative Regelleistungsreserve [W]";
  output Real P_pos "positive Regelleistungsreserve [W]";
  output Real K_neg "Kosten der negativen Regelleistung [EUR/kWh]";
  output Real K_pos "Kosten der positive Regelleistung [EUR/kWh]";
end EMB_DevicePlug;