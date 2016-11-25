function CpLiCl = CpLiCl(T,C)

% Based on Conde 2003 (Ref. 212)
% Uses empircal fit to calculate specific thermal capacity of solution given 
% Temperature T [K]
% Mass Fraction C [%]
% Returns Cp [kJ/kg/K]

% clear
% T = 25
% C = 40

Temp = T + 273.15;
Conc = C/100;

phi=Temp/228 - 1; % New reduced temperature (What is 228?)

% Constants to the fit of water specific thermal capacity
A = 88.7891;
B = -120.1958;
C = -16.9264;
D = 52.4654;
E = 0.10826;
F = 0.46988;

CpWater = A + B.*phi.^0.02 + C.*phi.^0.04 + D.*phi.^0.06 + E.*phi.^1.8 + F.*phi.^8;

% Constants to the fit of LiCl specific thermal capacity
A = 1.43980;
B = -1.24317;
C = -0.12070;
D = 0.12825;
E = 0.62934;
F = 58.5225;
G = -105.6343;
H = 47.7948;

if Conc > 0.31
    f1 = D + E*Conc;
else
    f1 = A*Conc + B*Conc.^2 + C*Conc.^3;
end

f2 = F.*phi.^0.02 + G.*phi.^0.04 + H.*phi.^0.06;

CpLiCl = CpWater.*(1 - f1.*f2);