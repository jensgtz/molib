within Lib.Economic;

model ConditionsModel
  //parameters
  //components
  parameter Lib.Economic.Conditions conditions;
  //connectors
  //variables
  //eod
algorithm
  when initial() then
    Lib.Economic.removeResults();
  end when;
  when terminal() then
    Lib.Economic.writeConditions(cond = conditions, T_s_real = time/8760);
  end when;
end ConditionsModel;