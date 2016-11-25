function h = enthalpyWater(waterProps, T)
% ABSOLUTE_ENTHALPY = enthalpyWater(waterProps, T)
% waterProps is a fixed table of water properties
% Returns the absolute enthalpy [kJ/kg] given a vector of TEMPERATURE [°C]
% Watch the units!
% See also enthalpyAir

cp = interp1(waterProps.Temp,waterProps.SpecHeat,T);

h = T*cp;

if any(any(isnan(h)))
	disp('WARNING: Enthalpy data contains NaN. Probable cause; Temperatures are outside range of water property table.');
end