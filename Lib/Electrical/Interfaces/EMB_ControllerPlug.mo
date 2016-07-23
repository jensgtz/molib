within Lib.Electrical.Interfaces;

connector EMB_ControllerPlug
  input Real P "aktuelle Leistung [W]";
  input Real P_neg "negative Regelleistungsreserve [W]";
  input Real P_pos "positive Regelleistungsreserve [W]";
  input Real K_neg "Kosten der negativen Regelleistung [EUR/kWh]";
  input Real K_pos "Kosten der positive Regelleistung [EUR/kWh]";
  output Real P_set "Soll-Leistung [W]";
end EMB_ControllerPlug;