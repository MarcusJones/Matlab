%---------------------------
% Psychrometrics 
%---------------------------
Function Tdp=db.cal(Twb, RH, Tdb)
'... need iterations ... given Twb (øC) and rh (%), find Tdb (øC)
         DO
            Tdb = Tdb + .01
            CALL Psat1.cal(Tdb, Psat)   '... find Psat
            Pvap = Psat * RH / 100       '... find Pvap
            CALL HR.cal(Pvap, AH1)
            CALL Tdp.cal(Pvap, Tdp)      '... find Tdp
            CALL wb1.cal(Tdb, Tdp, Twbcal)  '... find Twb
            IF ABS(Twbcal - Twb) < .1 THEN EXIT DO
         LOOP
%---------------------------
% Degree of Saturation
%---------------------------
Function DOS=DOS.cal (RH, Pvap, Psat, dos)
    Patm = 101.325
    DOS = RH * (Patm - Psat) / (Patm - Pvap)
%---------------------------
% Enthalpy
%---------------------------
Function h=h.cal(Tdb, ah, h)
    h = Tdb + ah * (2501 + 1.805 * Tdb)
%---------------------------
Function ah=HR.cal(Pvap, ah)
    Patm = 101.325   '... both Pvap and Patm are in kPa
    ah = .6219 * Pvap / (Patm - Pvap)   '... AH is dimensionless
%---------------------------
Function xlh=LH.cal (Tdb,action)
case select action
action=1
    '... Wei Fang's equation
    '    developed using Regression Analysis
    '    r? = 0.999996846
    '
    xlh = 2500.3381# - (2.347061 + .0000088614668# * Tdb * Tdb) * Tdb
action=2
    '... Tdb in øC
    IF Tdb < 338.72 - 273.16 THEN
      xlh = 2502535.259# - 2385.76424# * Tdb
    END IF
    IF Tdb >= 338.72 - 273.16 THEN
      xlh = (7329155978000# - 15995964.08# * (Tdb + 273.16) ^ 2) ^ .5
    END IF
    xlh = xlh / 1000
    '... LH  in kJ/kg or J/g
action=3
    '... only good within 5 to 50 øC  (error < 0.2 %)  simple equation
    xlh = 595 - .51 * (Tdb)   '... in cal/g
    xlh = xlh * 4.19002       '.... 1 cal = 4.19002 Joule
action=4
    '... Wei Fang's equation
    '    developed using Regression Analysis
    '    r? = 0.999986231
    '
    xlh = 2499.7815# - (2.2887403# + .0013791296# * Tdb) * Tdb
End select

%---------------------------
SUB Psat1.cal (Tdb, Psat, action)
%to calculate saturated vapor pressure and saturated humidity ratio
action=1
     TQQ = Tdb + 273.16
     T10 = TQQ / 100!
     a = -5800.2206# / TQQ + 1.3914993# - .04860239# * TQQ
     b = .41764768# * T10 * T10 - .014452093# * T10 * T10 * T10
     c = 6.5459673# * LOG(TQQ)
     BETA = a + b + c
     Psat = EXP(BETA) / 1000   %.... now in kPa
     WWW = .622 * Psat / (101! - Psat)   %... Humidity ratio
                           %.. 1 ATM = 0.101 MPa

action=2
    %... eq. from D.S. Wang, Dept. AE
    %
    T = Tdb   %... in øC, Psat in mbar
    Psat = 33.8639 * ((.00738 * T + .8072) ^ 8 - .0000191# * (1.8 * T + 48) + .001316)
    Psat = Psat * .1   %... Psat was in mbar now in kPa

   %mbar /1000 * 0.1 = MPa
   %mbar * 0.1  = kPa

action=3
    '... eq. used by C.C. Chen
    '
    T = Tdb!   '... in øC, Psat in kPa
    Psat! = .68158 + T * (.0273 + T * (.0027176# + T * (-.0000136# + 8.3E-07 * T)))

action=4
    '... eq. used by Dilley
    '
    T = Tdb!   '... in øC, Psat in mbar
    Psat! = 6.1078 * EXP(17.269 * T / (T + 237.3))
    Psat = Psat * .1   '... Psat was in mbar now in kPa

END Select
%---------------------------
SUB Pv.cal (ah, Pvap)
    Patm = 101.325  '.. kPa
    Pv = ah * Patm / (.6219 + ah)
END SUB

SUB Pv2.cal (sv, Tdb, Pvap)
    Patm = 101.325  '.. kPa
    Pvap = Patm - .287 * (Tdb + 273.16) / sv
END SUB

%---------------------------
SUB rh.cal (Tdb, Twb, RH)
'... RH in %
'... note that this equation is only good for Tdb in the range of 10 - 70 øC
    IF ABS(Tdb - Twb) < .001 THEN RH = 100: EXIT SUB
    
    aa = 6.5283207# - 3243.72695# / Tdb + 27478.51412# * LOG(Tdb) / Tdb / Tdb - 31804.835# / Tdb / Tdb
    bb = -5.7823757# + .00014449003# * Tdb * Tdb * SQR(Tdb) - .000012648953# * Tdb * Tdb * Tdb + 45.725691# / SQR(Tdb)
    cc = -1.8793625# - .034446164# * Tdb - .51282028# * (LOG(Tdb)) ^ 2 + 1.6161997# * SQR(Tdb)
    dd = .0018867775# - .00000020696545# * Tdb * Tdb * SQR(Tdb) + .000000020593745# * Tdb * Tdb * Tdb - 59.002463# * EXP(-Tdb)
   
    RH = aa + bb * Twb + cc * Twb * Twb + dd * Twb * Twb * Twb
   
    IF RH < 0 THEN RH = 0
    IF RH > 100 THEN RH = 100
END SUB

%---------------------------
SUB SlopeWB.cal (Tdb, Twb, RH, slope)
   Patm = 101 '.. kPa

   CALL rh.cal(Tdb, Twb, RH)
   CALL Psat1.cal(Tdb, Psat)
   Pv = Psat * RH / 100
   CALL Psat1.cal(Twb, Psat): Pswb = Psat
   'CALL LH2.cal(Tdb, xlh)
   CALL LH1.cal(Tdb, xlh)
   slope = 1006.9254# * (Pswb - Patm) * (1 + .15577 * Pv / Patm) / (.62194 * xlh) / 1000
   'PRINT USING "Tdb = ###.## Twb = ###.## RH = ##.## % "; Tdb; Twb; RH
   'PRINT "Pv = "; Pv
   'PRINT "Pswb = "; Pswb
   'PRINT "Slope * (Twb - Tdb)+Pv  = "; Slope * (Twb - Tdb) + Pv
END SUB
%---------------------------
SUB SlopeWB2.cal (Tdb, RH, slope)
   '... RH in %
   Patm = 101 '.. kPa
   CALL Psat1.cal(Tdb, Psat)
   Pv = Psat * RH / 100
   CALL Psat1.cal(Twb, Psat): Pswb = Psat
   CALL LH2.cal(Tdb, xlh)
   slope = 1006.9254# * (Pswb - Patm) * (1 + .15577 * Pv / Patm) / (.62194 * xlh) / 1000
END SUB
%---------------------------
SUB SV.cal (Tdb, Pvap, sv)
    Patm = 101.325
    sv = .287 * (Tdb + 273.16) / (Patm - Pvap)    '... in m^3/kg
END SUB
%---------------------------
SUB Tdp.cal (Pvap, Tdp)
'... given Pvap (in kPa) to find Tdp (in øC) ASHRAE 1977
IF Pvap > .00016 AND Pvap <= .61074 THEN
   a = 82.44543: b = .1164067#: c = 3.056448: D = -76.34573
END IF
IF Pvap > .61074 AND Pvap <= 101.34 THEN
   a = 33.38269: b = .2226162#: c = 7.156019: D = -26.39589
END IF
IF Pvap > 101.34 AND Pvap <= 4688.5 THEN
   a = 13.85606: b = .2949901#: c = 12.10512: D = -10.03128
END IF
Tdp = a * Pvap ^ b + c * LOG(Pvap) + D

END SUB

%---------------------------
SUB Tdp2.cal (Tdb, RH, Tdp)
   '... equation from
   '... Linsley, R.K., M.A. Kohler and Joseph L.H. Paulhus. 1975
   '... Hydraulics for Engineers. 2nd Ed. McGraw-Hill.   p.35
   '
   T = Tdb     '... absolute T in K
   RHdec = RH / 100     '... RH in decimal
   R = 1 - RHdec
   Tdp = T - (14.55 + .114 * T) * R - ((2.5 + .007 * T) * R) ^ 3 - (15.9 + .117 * T) * R ^ 14
   ' Tdp in øC
END SUB
%---------------------------
SUB Tdp3.cal (Tdb, RH, Tdp)
    '... Wei Fang's equation
    '    developed using Regression Analysis
    
    IF RH = 100 THEN Tdp = Tdb: EXIT SUB
    
    IF Tdb < 0 AND Tdb >= -40 THEN

      xa = -46.5433512# + .6366532# * Tdb - .00031105# * Tdb * Tdb - .000016342# * Tdb * Tdb * Tdb
      xB = 8.388685181# + .061480148# * Tdb - .00025636# * Tdb * Tdb + .016242088# / Tdb
      xC = .365102103# - .00014002# * Tdb - .01284458# / Tdb - .00690945# / Tdb / Tdb
      Tdp = xa + xB * LOG(RH) + xC * LOG(RH) * LOG(RH)
   
    ELSEIF Tdb > 0 AND Tdb <= 70 THEN
      xa = -35.4549173# + .136834671# * Tdb + .01229719# * Tdb * Tdb - .00204423# * Tdb * Tdb * LOG(Tdb)
      xB = 2.367977132# + .168485066# * Tdb - .0006361# * Tdb * Tdb + .0000014884# * Tdb * Tdb * Tdb
      xC = 1.168111677# - .0029605# * Tdb + .000212586# * Tdb * SQR(Tdb) + .004721025# * LOG(Tdb) * LOG(Tdb)
      Tdp = xa + xB * LOG(RH) + xC * LOG(RH) * LOG(RH)
    END IF
END SUB
%---------------------------
SUB THI1.cal (Tdb, RH, THI1, THI2, DI)
    CALL Tdp2.cal(Tdb, RH, Tdp)
    CALL wb1.cal(Tdb, Tdp, Twb)            %... Twb1
    THI1 = .35 * Tdb + .65 * Twb    %.. eq. from Bianca, 1962.
    THI2 = Tdb + .36 * Tdp + 41.2   %... eq. from ASAE STANDARD
    DI = .99 * Tdb + .36 * Tdp + 41.5 %... Discomfort index from ASHRAE
END SUB
%---------------------------
SUB THI2.cal (Tdb, Twb, THI1, THI2, DI)
    CALL rh.cal(Tdb, Twb, RH)
    CALL Tdp2.cal(Tdb, RH, Tdp)
    THI1 = .35 * Tdb + .65 * Twb  '.. eq. from Bianca, 1962.
    THI2 = Tdb + .36 * Tdp + 41.2 '... eq. from ASAE STANDARD
    DI = .99 * Tdb + .36 * Tdp + 41.5 '... Discomfort index from ASHRAE
END SUB

%---------------------------
SUB wb1.cal (Tdb, Tdp, Twb)
%... all in degree C

IF ABS(Tdb - Tdp) < .001 THEN Twb = Tdb: EXIT SUB

X = Tdb
a = .011569: b = .613423862#: c = -.00643928#: D = 7.52158E-05: e = -4.5287E-07
ap1 = a + b * X + c * X ^ 2 + D * X ^ 3 + e * X ^ 4
a = .419636669#: b = .027436851#: c = .007711576#: D = .001536155#: e = .00023861#
bp1 = (a + c * X + e * X ^ 2) / (1 + b * X + D * X ^ 2)
a = .011146403#: b = .027956528#: c = .000255119#: D = .002122386#: e = 7.1215E-06
cp1 = (a + c * X + e * X ^ 2) / (1 + b * X + D * X ^ 2)
a = 9.65426E-05: b = -.00292091#: c = 7.15163E-07: D = .001201577#
dp1 = (a + c * X) / (1 + b * X + D * X ^ 2)

Twb = ap1 + bp1 * Tdp + cp1 * Tdp * Tdp + dp1 * Tdp * Tdp * Tdp

IF Twb > Tdb THEN Twb = Tdb
IF Twb < Tdp THEN Twb = Tdp

END SUB

%---------------------------
SUB wb2.cal (Tdb, RH, Twb)
    % Wei Fang's equation
    % developed using Regression Analysis
IF RH = 100 THEN Twb = Tdb: EXIT SUB
IF Tdb >= 5.1 AND Tdb <= 70 THEN
   X = Tdb'  in 10 to 70 degree C
   a = -6.0007032#: b = .0080227306#: c = .6110789#: D = .0000149408#
   xa = (a + c * X) / (1 + b * X + D * X * X)
   a = .061050694#: b = -.017868932#: c = .010074969#: D = .000141617#:
   xB = (a + c * X) / (1 + b * X + D * X * X)
   a = .000505985#: b = -.018881072#: c = -.0015164147#: D = .0001449228#:
   xC = (a + c * X) / (1 + b * X + D * X * X)
   a = -6.874193200000001D-02: b = -.0008939499#: c = .0000122365#: D = 3.6569408D-32:
   xD = a + b * X * X + c * X * X * X + D * EXP(X)
   Twb = xa + xB * RH + xC * RH * LOG(RH) + xD * SQR(RH)
END IF
IF Tdb <= 5 AND Tdb >= -40 THEN
   X = Tdb'  from -40 to 5 degree C
   a = -6.08584568#: b = .674089603#: c = -.00422043#: D = .000009862#
   xa = a + b * X + c * X * X + D * X * X * X
   a = .092118318#: b = -.01103043#: c = .006853166#: D = .0000882606#: e = .000163494#: f = .0000009894#: g = .0000010495#:
   xB = (a + c * X + e * X * X + g * X * X * X) / (1 + b * X + D * X * X + f * X * X * X)
   a = -.00629357#: b = -9.336270000000001D-03: c = -.00081209#: D = .0000589127#: e = -.000028407#: f = .000001353#: g = -.0000002847#:
   xC = (a + c * X + e * X * X + g * X * X * X) / (1 + b * X + D * X * X + f * X * X * X)
   a = .0000204853#: b = -.0081593#: c = -.00039146#: D = -.0000004102#: e = .0000001029#
   xD = a + b * X + c * X * X + D * X * X * X + e * X * X * X * X
   Twb = xa + xB * RH + xC * RH * LOG(RH) + xD * SQR(RH)
END IF
%---------------------------
Function Twb=wb3.cal(Tdb, Tdp, Twb)
%... all in degree C
%eq from C.C. Chen , this eq. is the same w/ wb1.cal but w/ much simple form
D1 = Tdb - Tdp;
b1 = 1.57853E-05: b2 = -.0041328#: b3 = .5872: b4 = 5.6038E-05: b5 = -.019737: b6 = 1.15724;
IF (D1 * b4 + b5) < 0 
	break;
else
	Twb = Tdp + (b1 * D1 ^ 3 + b2 * D1 ^ 2 + b3 * D1) * EXP((b4 * D1 + b5) * Tdp ^ b6);
end
IF Twb > Tdb, Twb = Tdb;end
IF Twb < Tdp, Twb = Tdp;end
%---------------------------
