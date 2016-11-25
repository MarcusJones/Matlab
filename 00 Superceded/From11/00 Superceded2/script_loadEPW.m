%% Load EPW 
%written and copyrighted by Ted Ngai www.tedngai.net 
%version 0.1 Apr 2010
% Modified June 09 2012 MJones

epw.Path = 'D:\Dropbox\00 Decathlon Development\Weather\EPW';
epw.Name = 'CZ08RV2.epw';
epw.FullPath = [epw.Path '\' epw.Name];

fid = fopen(epw.FullPath);

%Reads line 1
loc = fgetl(fid);
loc = textscan(loc, '%*s %s %s %s %s %f %f %f %f %f', 'delimiter',',');

%Skip line 2-8
for i = 1:7
    fgetl(fid);
end

%Read weather data
r = 1;
while 1
    readin = fgetl(fid);
    if readin == -1 break;end
    epw.data(r,:) = textscan(readin, '%f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]', 'delimiter',',','MultipleDelimsAsOne',1);
    r = r+1;
end

epw.data(:,6)= [];
epw.data=cell2mat(epw.data);

epw.header = {'Year', 'Month', 'Day', 'Hour', 'Minute', 'Dry Bulb Temperature (C)', 'Dew Point Temperature (C)', 'Relative Humidity', 'Atmospheric Station Pressure (Pa)', 'Extraterrestrial Horizontal Radiation (Wh/m2)', 'Extraterrestrial Direct Normal Radiation (Wh/m2)', 'Horizontal Infrared Radiation from Sky (Wh/m2)', 'Global Horizontal Radiation (Wh/m2)', 'Direct Normal Radiation (Wh/m2)', 'Diffuse Horizontal Radiation (Wh/m2)', 'Global Horizontal Illuminance (lux)', 'Direct Normal Illuminance (lux)', 'Diffuse Horizontal Illuminance (lux)', 'Zenith Illuminance (lux)', 'Wind Direction (deg)', 'Wind Speed (m/s)', 'Total Sky Cover', 'Opaque Sky Cover', 'Visibility (km)', 'Ceiling Height (m)', 'Present Weather Ovservation', 'Present Weather Codes', 'Precipitable Water (mm)', 'Aerosol Optical Depth (thousandths)', 'Snow Depth (cm)', 'Days Since Last Snowfall'};

fclose('all');

epw.units = {}
for i = 1:size(epw.data,2)
    epw.units = [epw.units '-'];
end

clearvars -except sched epw epwExp

display(sprintf(' - Loaded EPW Weather'))
