function Dilution_Enthalpy = Dilution_Enthalpy(T,C)

% Based on Conde 2003 (Ref. 212)
% Uses empircal fit to calculate differential enthalpy of dilution given 
% Temperature T [K]
% Concentration C [%]
% Returns Hdil [kJ/kg]

Temp = T + 273.15;
Conc = C./100;

CritTWater = 374 + 273.15; % Critical temperature of water
phi = Temp./CritTWater; % Reduced temperature

H1 =  0.845;
H2 = -1.965;
H3 = -2.265;
H4 =  0.6;
H5 = 169.105;
H6 = 457.850;

Zai = Conc./(H4 - Conc);

% Reference value
HdilRef = H5 + H6.*phi;

Dilution_Enthalpy = HdilRef.*(1+ (Zai./H1).^H2).^H3;
