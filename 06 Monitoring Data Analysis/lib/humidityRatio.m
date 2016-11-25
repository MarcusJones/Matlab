% W=humidityRatio(T,p,phi)
% This function returns the humidity ratio given the rh, temperature, and
% pressure from Ashrae correlation
% 2005 ASHRAE handbook "Fundamentals", chapter 6, equations 5 and 6
% Marcus Jones - July 2007 - Created file for M.Sc. thesis
% Marcus Jones - November 2009 - Update for AIT
%
% T - temperature [C]
% p - pressure [Pa]
% phi - relative humidity [%]
% W - absolute humidity [kg/kg]

function Wratio=humidityRatio(T,p,phi)

T = T + 273;
phi = phi/100;
% Finding W from eq. 22
% Where p_w is the partial pressure of water vapor and p is the total pressure. 
% W = M_w/M_a;
%                                       M[w]
%                                   W = ----
%                                       M[a]
% M_w is the mass of water, M_a is the mass of air
% W = .62198*x[w]/x[a];
%                                   0.62198 x[w]
%                               W = ------------
%                                       x[a]    
% x_w/x_a is the mole fraction ratio, multiplied by the ratio of molecular masses, 18.01528/28.9645 = 0.62198.
% The partial pressure of water, p_w is derived from;
% phi = (p_w)/(p_ws)

%Where p_ws [Pa] is the saturation pressure of water vapor in the absence of air at a given temperature
%The saturation pressure over liquid water for 0 to 200degC is;

C_8 = -5800.2206;
C_9 = 1.3914993;
C_10 = -0.48640239e-1;
C_11 = 0.41764768e-4;
C_12 = -0.14452093e-7;
C_13 = 6.5459673;

% Find p_ws from empirical fit agaist T
p_ws = exp(C_8./T+C_9+C_10.*T+C_11.*T.^2+C_12.*T.^3+C_13.*log(T));

% Use p_ws and rh to get p_w
p_w = p_ws.*phi;

% W is a function of p and p_w
Wratio = .62198.*p_w./(p-p_w);

end