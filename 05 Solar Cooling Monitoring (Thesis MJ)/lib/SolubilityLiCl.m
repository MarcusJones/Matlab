function SolubilityLiCl = SolubilityLiCl(C)

% Based on Conde 2003 (Ref. 212)
% Uses empircal fit to calculate solubility boundary of solution given
% Temperature T [K]
% Concentration C [%]
% Returns boundary line


CritTWater = 374 + 273.15; % Critical temperature of water
MF = C/100;


if MF <= 0
    'ERROR'
elseif MF <= 0.253 % A
    A0 =  0.422088;
    A1 = -0.090410;
    A2 = -2.936350;
    phi = A0 + A1.*MF + A2.*MF.^2.5;
    Temp = phi * CritTWater;
    SolubilityLiCl = Temp - 273.15;
    return
elseif MF <= .287 % B
    A0 = -0.005340;
    A1 =  2.015890;
    A2 = -3.114590;
elseif MF <= .369  % C
    A0 = -0.560360;
    A1 =  4.723080;
    A2 = -5.811050;
elseif MF <= .452  % D
    A0 = -0.315220;
    A1 =  2.882480;
    A2 = -2.624330;
elseif MF <= .558  % E
    A0 = -1.312310;
    A1 =  6.177670;
    A2 = -5.034790;
elseif MF <= 1  % F
    A0 = -1.35680;
    A1 =  3.448540;
    A2 =  0.0;
end


% phi = Temp./CritTWater; % Reduced temperature

phi = A0 + A1.*MF + A2.*MF.^2;

Temp = phi * CritTWater;

SolubilityLiCl = Temp - 273.15;



