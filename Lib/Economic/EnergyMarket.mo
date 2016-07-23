within Lib.Economic;

/*
<DOC>
Energiemarkt / Endenergie-Bereitsteller
Preise je kWh Heizwert

Erdgas - ng - natural gas
Propangas - lpg - liquid petroleum gas
Holzhackschnitzel - wc - wood chips
Holzpellets - wp - wooden pellets
Diesel (Standard, Tankstelle) - di - diesel
Biodiesel (Tankstelle) - bdi - biodiesel
Elektrizitaet (Strom-Mix DE, Haushaltsverbraucher) - el - electricity

https://www.destatis.de/DE/Publikationen/Thematisch/Preise/Energiepreise/EnergiepreisentwicklungPDF_5619001.pdf?__blob=publicationFile
</DOC>
*/

model EnergyMarket
  //parameters
  parameter Real k_ng = 0.7 "Preis Erdgas [EUR/kWh]";
  parameter Real k_lpg = 0.9 "Preis Propangas [EUR/kWh]";
  parameter Real k_wc = 0.1 "Preis Holzhackschnitzel [EUR/kWh]";
  parameter Real k_wp = 0.2 "Preis Holzpellets [EUR/kWh]";
  parameter Real k_di = 0.1 "Preis Standard-Diesel [EUR/kWh]";
  parameter Real k_bdi = 0.1 "Preis Bio-Diesel [EUR/kWh]";
  parameter Real k_el = 0.26 "Preis Strom [EUR/kWh]";
  parameter Real k_el_chp = 0.117 "Verguetung KWK-Strom [EUR/kWh]";
  parameter Real k_el_pv = 0.127 "Verguetung PV-Strom [EUR/kWh]";
  //components
  //connectors
  Lib.Economic.MultiFuelPort mfp "Energietraeger";
  //variables
  //eod
equation
  mfp.ng.k = k_ng;
  mfp.lpg.k = k_lpg;
  mfp.wc.k = k_wc;
  mfp.wp.k = k_wp;
  mfp.di.k = k_di;
  mfp.bdi.k = k_bdi;
  mfp.el.k = k_el;
end EnergyMarket;