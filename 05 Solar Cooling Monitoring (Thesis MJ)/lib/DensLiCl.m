function DensLiCl = DensLiCl(T,C)

% Based on Conde 2003 (Ref. 212)
% Uses empircal fit to calculate density of solution given 
% Temperature T [K]
% Concentration C [%]
% Returns rho [kg/m3]

Temp = T + 273.15;
Conc = C/100;

CritTWater = 374 + 273.15; % Critical temperature of water
CritDensWater = 322; % [kg/m3]
phi = Temp./CritTWater; % Reduced temperature
tau = 1 - phi; 

MassFrac = Conc./(1-Conc); % Mass fraction of solute to solvent

% Fitted constants for empirical relation; water density
B0 = 1.993771843;
B1 = 1.0985211604;
B2 = -0.5094492996;
B3 = -1.7619124270;
B4 = -44.9005480267;
B5 = -723692.26118632;

% Fitted constants for empirical relation; LiCl density
r0 =  1;
r1 =  0.540966;
r2 = -0.303792;
r3 =  0.100791;

% Density of water
DensWater = CritDensWater .* (1+B0*tau.^(1/3) + B1.*tau.^(2/3) + ...
    B2.*tau.^(5/3) + B3.*tau.^(16/3) + B4.*tau.^(43/3) + B5.*tau.^(110/3));

% Density of LiCl
DensLiCl = DensWater.*(r0.*MassFrac.^0+r1.*MassFrac.^1+r2.*MassFrac.^2+r3.*MassFrac.^3);
