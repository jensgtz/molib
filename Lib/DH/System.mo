within Lib.DH;

/*
<DOC>
---
  Lib.Economic.EnergyMarket emarket "Energiemarkt";
  // Energiemarkt
  connect(emarket.mfp, installations.mfp);
</DOC>
*/

model System

  Lib.Misc.SimProgress sim_progress "Simulationsfortschritt";

  //parameters

  //components
  Lib.DH.Location location "Standort";
  Lib.DH.Envelope2 envelope "Gebaeudehuelle";
  Lib.DH.Installations installations(V_i_h=envelope.V_i_h) "Anlagentechnik";

  //connectors

  //variables
  Real Q_e(start=0) "Endenergieverbrauch [kWh]";
  Real Q_p(start=0) "Primaerenergieverbrauch [kWh]";
  Real q_e "spezif. Endenergieverbrauch bzgl. A_n [kWh/m2]";
  Real q_p "spezif. Primaerenergieverbrauch bzgl. A_n [kWh/m2]";

  //eod

equation
  // Standort
  connect(location.hp_ext, envelope.hp_ext);
  connect(location.hp_soil1, envelope.hp_soil1);
  connect(location.hp_soil2, envelope.hp_soil2);
  connect(location.x_air_ext, envelope.x_air_ext);
  connect(location.x_air_ext, installations.x_air_ext);

  // Gebaeudehuelle
  connect(envelope.hp_at, installations.hp_at);
  connect(envelope.hp_gfuf, installations.hp_gfuf);
  connect(envelope.hp_bm, installations.hp_bm);
  connect(envelope.n_nat, installations.n_nat);
  
  // Anlagentechnik
  connect(installations.hp_ext, location.hp_ext);
  connect(installations.n_vsys, envelope.n_vsys);

  //
  connect(envelope.T_op_deg, installations.T_op_deg);

  // energetische Kennwerte
  Q_e = 1;
  Q_p = 1;
  q_e = Q_e / envelope.A_n;
  q_p = Q_p / envelope.A_n;
  
end System;