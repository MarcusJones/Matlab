% This function returns the enthalpy of the air from ASHRAE fundamentals
% T [C]
% W [kg/kg]

function EnthalpyAir=EnthalpyAir(TC,W)

EnthalpyAir = 1.006.*TC + W.*(2501+1.805.*TC);

end