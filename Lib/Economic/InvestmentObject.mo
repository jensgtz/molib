within Lib.Economic;

model InvestmentObject
  //parameters
  parameter Boolean eco__is_investment = true "Investition ja/nein [-]";
  parameter Real eco__K_inv = 0 "Investitionskosten, brt. [EUR]";
  parameter Real eco__k_serv = 0 "relative Instandhaltungskosten [1/a]";
  parameter String eco__flags = "" "flags";
  //components
  //connectors
  //variables
  Lib.Economic.Results eco__res "Ergebnisse";
  //eod

algorithm
  when terminal() then
    Lib.Economic.writeResults(name = getInstanceName(), res = eco__res);
  end when;

end InvestmentObject;