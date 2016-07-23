within Lib.Electrical.Controllers;

function getOperationalPlan
  input Integer n;
  input Real costs[n];
  input Real powers[n];
  input Real demand;
  input Real period;
  input Real psign;
  output Real set_points[n];
  output Real total_cost;
  output Real rem_demand;
protected
  Real sorted_costs[n];
  Integer sorted_costs_indices[n];
  Real power;
  Real cost;
algorithm
  (sorted_costs, sorted_costs_indices) := Modelica.Math.Vectors.sort(costs);
  rem_demand := demand;
  total_cost := 0;
  for i in sorted_costs_indices loop
    power := Lib.Math.inRange(0, powers[i], rem_demand);
    cost := costs[i] * power * period;
    total_cost := total_cost + cost;
    set_points[i] := psign * power;
    rem_demand := rem_demand - power;
  end for;
end getOperationalPlan;