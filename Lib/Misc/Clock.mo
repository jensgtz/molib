within Lib.Misc;

/*
<DOC>
Simulationszeit = UTC + TZ

Tage im Monat fuer Sommerzeit-Rechnung
- 31+28+31+30+31+30+31+31+30+31+30+31

Start Sommerzeit
- letzter Sonntag im Maerz
- vereinfacht nach 31+28+31 = 90 Tagen (2160 h)
- Maerz endet mit (Sonntag - WDO)
- Maerz endet nach 12,857 Wochen an einem WDO+6 (Sonntag fuer WDO=0)

Ende Sommerzeit
- letzter Sonntag im Oktober
- vereinfacht nach 31+28+31+30+31+30+31+31+30+31 = 304 Tagen (7296 h)
- Oktober endet nach 43,428 Wochen an einem WDO+3 (Donnerstag fuer WDO=0)

  parameter Real WDO = 0 "Wochentag-Offset bzw. erster Wochentag im Jahr, 0 MO [-]";
  parameter Real useSummerTime = 0 "Sommerzeit in Local Time ja/nein [-]";
  parameter Real SummerTimeStarts = 2160 "Start der Sommerzeit [h]";
  parameter Real SummerTimeStops = 7296 "Ende der Sommerzeit [h]";
 
  Real timeOffset(start=0) "Zeit-Offset [h]";
</DOC>
*/

model Clock
  
  //parameters
  parameter Real TimeZone = 1 "Zeitzone [h]";
  parameter Real Longitude = 12 "Laengengrad [deg]";

  //components
  
  //connectors
  Lib.RealOutput hour_utc "Stunde, UTC (0, 24) [h]";
  Lib.RealOutput hour_local "Stunde, lokal (0, 24) [h]";
  Lib.RealOutput hour_moz "Stunde, mittlere Ortszeit (0, 24) [h]";
  Lib.RealOutput r_day "Tag des Jahres, kont. [1]";
  
  //variables
  Integer i_day "Tag des Jahres, bzgl. UTC+TZ [1]";
  Integer i_month "Monat des Jahres, bzgl.UTC+TZ [1]";
  
  //eod

algorithm
  // UTC
  hour_utc := rem(time - TimeZone, 24.0);
  hour_utc := if noEvent(hour_utc >= 24.0) then 0 else hour_utc;

  // mittlere Ortszeit
  hour_moz := rem(time - TimeZone + Longitude / 15.0, 24.0);
  hour_moz := if noEvent(hour_moz >= 24.0) then 0 else hour_moz;

  // gesetzliche lokal gueltige Zeit (DE)
  hour_local := rem(time, 24.0);
  hour_local := if noEvent(hour_local >= 24.0) then 0 else hour_local;

  // Tag des Jahres, kontinuierlich, bzgl. UTC + TZ
  r_day := time / 24;

  // Tag des Jahres, bzgl. UTC + TZ
  i_day := integer(div(time, 24) + 1);

  // Monat des Jahres, bzgl. UTC + TZ
  i_month := integer(div(time, 730) + 1);

end Clock;