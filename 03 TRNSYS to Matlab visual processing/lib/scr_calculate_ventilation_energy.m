% TempAmbient = get_pData(get_state_points2(trnData,'ZoneAir','ZoA','all'),'T');

% this script is not complete




load WaterProps
load AirProps

AmbientTemperature = get_state_points2(trnData,'SHX','MoistAir',1);
                 T = trnData.SHX.MoistAir{1}.data(:,1);
                % Extract the humidity ratio [kg/kg]
                w = trnData.SHX.MoistAir{1}.data(:,2);
                % Extract the mass flow rate [kg/hr]
                mf = trnData.SHX.MoistAir{5}.data(:,3);
                % Find the specific heat at this temperature [kJ/(kg.'C)]
                H = EnthalpyAir(T,w);
                % The equation for enthalpy flow rate
                hf1 = mf.*H; % [kJ/hr]
                AmbEnth = sum(hf1)*trnTime.interval/3600;
                
                %T = trnData.SHX.MoistAir{5}.data(:,1);
                T=23;
                % Extract the humidity ratio [kg/kg]
                %w = trnData.SHX.MoistAir{5}.data(:,2);
                w=0.00723
                % Extract the mass flow rate [kg/hr]
                mf = trnData.SHX.MoistAir{5}.data(:,3);
                % Find the specific heat at this temperature [kJ/(kg.'C)]
                H = EnthalpyAir(T,w);
                % The equation for enthalpy flow rate
                hf2 = mf.*H; % [kJ/hr]
                FreshEnth = sum(hf2)*trnTime.interval/3600;
                AmbEnth-FreshEnth