within Lib.Electrical.Controllers;

model EMS1
  //parameters
  parameter Real DeltaT_0 = 0.25 "Zeitschritt zu Beginn [h]";
  parameter Real DeltaT_min = 1/60 "min. Zeitschritt [h]";
  parameter Real DeltaT_max = 1 "max. Zeitschritt [h]";
  parameter Real DeltaP_max = 500 "max. Fehler [W]";
  //components
  //connectors
  Lib.Electrical.Interfaces.EMB_ControllerPlug emb1;
  Lib.Electrical.Interfaces.EMB_ControllerPlug emb2;
  Lib.Electrical.Interfaces.EMB_ControllerPlug emb3;
  Lib.Electrical.Interfaces.EMB_ControllerPlug emb4;
  Lib.Electrical.Interfaces.EMB_ControllerPlug emb5;
  Lib.RealInput P_sn;
  //variables
  Real DeltaP "aktuelle Regelabweichung [W]";
  //Real DeltaT(start=DeltaT_0, fixed=true) "Periode [h]";
  Real nextTime(start=DeltaT_0, fixed=true) "naechster Regelvorgang [h]";
  Real rem_demand;
  //eod

protected
  Real costs[5];
  Real powers[5];
  Real set_points[5];
  Real total_cost;


algorithm
  DeltaP := P_sn;
  when time >= nextTime then
    if DeltaP < 0 then
      // Unterdeckung -> Anforderung pos. Regelleistung
      costs := {emb1.K_pos, emb2.K_pos, emb3.K_pos, emb4.K_pos, emb5.K_pos};
      powers := {emb1.P_pos, emb2.P_pos, emb3.P_pos, emb4.P_pos, emb5.P_pos};
      (set_points, total_cost, rem_demand) := getOperationalPlan(n = 5, costs = costs, powers = powers, demand = -DeltaP, period = DeltaT_0, psign=-1);
    else
      // Ueberdeckung -> Anforderung neg. Regelleistung
      costs := {emb1.K_neg, emb2.K_neg, emb3.K_neg, emb4.K_neg, emb5.K_neg};
      powers := {emb1.P_neg, emb2.P_neg, emb3.P_neg, emb4.P_neg, emb5.P_neg};
      (set_points, total_cost, rem_demand) := getOperationalPlan(n = 5, costs = costs, powers = powers, demand = DeltaP, period = DeltaT_0, psign=1);
    end if;
    //
    emb1.P_set := emb1.P + set_points[1];
    emb2.P_set := emb2.P + set_points[2];
    emb3.P_set := emb3.P + set_points[3];
    emb4.P_set := emb4.P + set_points[4];
    emb5.P_set := emb5.P + set_points[5];
    //
    //DeltaT := Lib.Math.inRange(DeltaT_min, DeltaT * DeltaP_max / max(0.1, abs(DeltaP)), DeltaT_max);
    nextTime := nextTime + DeltaT_0;
  end when;
end EMS1;