% description of variables
%
function [cont, unit]=psydescription(factor)
switch factor
case 1
   cont='Patm ';   unit='kPa';
case 2
   cont='Tdb  ';   unit='deg.C';
case 3
   cont='Twb  ';   unit='deg.C';
case 4
   cont='Tdp  ';	unit='deg.C';
case 5
   cont='RH   ';   unit='%%';
case 6
   cont='DOS  ';   unit='%%';   
case 7
   cont='Pws  ';   unit='kPa';
case 8
   cont='Pw   ';	unit='kPa';   
case 9
   cont='AH   ';   unit='kg/kg';
case 10
   cont='h    ';	unit='kJ/kg';   
case 11
   cont='sv   ';    unit='m^3/kg';
case 12
   cont='hfg  ';   unit='kJ/kg';   
case 13
   cont='Bianca''s THI';   unit='';
case 14
   cont='ASAE''s THI  ';   unit='';
case 15
   cont='ASHRAE''s DI';   unit='';
end
