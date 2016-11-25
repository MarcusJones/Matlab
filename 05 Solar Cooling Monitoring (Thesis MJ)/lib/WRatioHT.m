% This function returns the enthalpy of the air from ASHRAE fundamentals
% T [C]
% h [kJ/kg]

function WRatioHT=WRatioHT(T,h)

WRatioHT = (h-1.006*T)./(2501+1.805*T);

end