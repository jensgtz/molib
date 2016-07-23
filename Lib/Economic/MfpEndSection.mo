within Lib.Economic;

model MfpEndSection
  //connectors
  Lib.Economic.MultiFuelPort mfp;
  //variables
equation
  mfp.ng.f = 0;
  mfp.lpg.f = 0;
  mfp.wc.f = 0;
  mfp.wp.f = 0;
  mfp.di.f = 0;
  mfp.bdi.f = 0;
  mfp.el.f = 0;
end MfpEndSection;