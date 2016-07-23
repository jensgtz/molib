within Lib.DH;

/*
<DOC>
http://ba.localhost/img/Documentation/DH/EnergySupply/Prim%c3%a4renergiefaktoren_DINV18599.png
</DOC>
*/

model EnergySupply
  //parameters
  //components
  //connectors
  Lib.Economic.MultiFuelPort mfp1 "Energiemarkt";
  Lib.Economic.MultiFuelPort mfp2 "Verbraucher";
  //variables
  Real Q_e(start=0, fixed=true);
  Real Q_p(start=0, fixed=true);
  Real Q_pe(start=0, fixed=true);
  Real Q_pne(start=0, fixed=true);

  Real K(start=0, fixed=true);
  //eod
equation
  connect(mfp1, mfp2);
  der(Q_e) = mfp1.ng.f + mfp1.lpg.f + mfp1.wc.f + mfp1.wp.f + mfp1.di.f + mfp1.bdi.f + mfp1.el.f;
  der(Q_p) = 1.1*mfp1.ng.f + 1.1*mfp1.lpg.f + 1.2*mfp1.wc.f + 1.2*mfp1.wp.f + 1.1*mfp1.di.f + 1.5*mfp1.bdi.f + 2.8*mfp1.el.f;
  der(Q_pne) = 1.1*mfp1.ng.f + 1.1*mfp1.lpg.f + 0.2*mfp1.wc.f + 0.2*mfp1.wp.f + 1.1*mfp1.di.f + 0.5*mfp1.bdi.f + 2.4*mfp1.el.f;
  Q_pe = Q_p - Q_pne;
  der(K) = mfp1.ng.f * mfp1.ng.k + mfp1.lpg.f * mfp1.lpg.k + mfp1.wc.f * mfp1.wc.k + mfp1.wp.f * mfp1.wp.k + mfp1.di.f * mfp1.di.k + mfp1.bdi.f * mfp1.bdi.k + mfp1.el.f * mfp1.el.k;
end EnergySupply;