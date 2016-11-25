% This function returns the enthalpy of the air from ASHRAE fundamentals
% 2005 ASHRAE handbook "Fundamentals", chapter 6, equation 32 
% Marcus Jones - July 2007 - from M.Sc. thesis
% Marcus Jones - Novemeber 2009 - Update for AIT
% 
% T - Temperature [C]
% W - asbsolute humidity [kg/kg]
% EnthalpyAir - Enthalpy of moist air [kJ/kg]

function EnthalpyAir=enthalpyMoistAir(T,W)

EnthalpyAir = 1.006.*T + W.*(2501+1.805.*T);

end