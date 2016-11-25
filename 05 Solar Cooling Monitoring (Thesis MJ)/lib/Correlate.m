for i = 1:length(StartEnd(1,:))

    Start = StartEnd(1,i);
    End = StartEnd(2,i);

    StartIndx = find(Date>=Start);
    EndIndx = find(Date>=End);
    
    % Process air
    Cor.C.Air.Temp.In(i)...
        = Air.Amb.Temp(StartIndx(1):EndIndx(1));
    Cor.C.Air.Temp.Out(i)...
        = Air.Proc.Temp(StartIndx(1):EndIndx(1));
    Cor.C.Air.W.In(i)...
        = Air.Amb.W(StartIndx(1):EndIndx(1)).*1000; % [g/kg]
    Cor.C.Air.W.Out(i)...
        = Air.Proc.W(StartIndx(1):EndIndx(1)).*1000; % [g/kg]
    Cor.C.Air.H.In(i)...
        = Air.Amb.H(StartIndx(1):EndIndx(1)); % [kJ/kg]
    Cor.C.Air.H.Out(i)...
        = Air.Proc.H(StartIndx(1):EndIndx(1)); % [kJ/kg]

    % Scavenging Air
    Cor.R.Air.Temp.In(i)...
        = Air.Amb.Temp(StartIndx(1):EndIndx(1));
    Cor.R.Air.Temp.Out(i)...
        = Air.Reg.Temp(StartIndx(1):EndIndx(1));
    Cor.R.Air.W.In(i)...
        = Air.Amb.W(StartIndx(1):EndIndx(1));
    Cor.R.Air.W.Out(i)...
        = Air.Reg.W(StartIndx(1):EndIndx(1));
    Cor.R.Air.dE(i)... % Hold
        = Air.Proc.W(StartIndx(1):EndIndx(1));
    Cor.R.Air.H.In(i)...
        = Air.Amb.H(StartIndx(1):EndIndx(1));
    Cor.R.Air.H.Out(i)...
        = Air.Reg.H(StartIndx(1):EndIndx(1));

    % CW
    Cor.C.CW.Temp.In(i)...
        = Cold.Temp.In(StartIndx(1):EndIndx(1)); % [C]
    Cor.C.CW.Temp.Out(i)...
        = Cold.Temp.Out(StartIndx(1):EndIndx(1)); % [C]

    % HW
    Cor.R.HW.Temp.In(i) ...
        = Hot.Temp.In(StartIndx(1):EndIndx(1)); % [C]
    Cor.R.HW.Temp.Out(i)...
        = Hot.Temp.Out(StartIndx(1):EndIndx(1)); % [C]
    Cor.R.HW.FlowKH(i) ...
        = Hot.FlowKH(StartIndx(1):EndIndx(1)); % [kg/h]
    
    % Strong
    Cor.C.Str.Temp.In(1,i)...
        = SimpleAverage(Des.C.TempIn, 0, StartIndx(1), EndIndx(1)); % [C]
    Cor.C.Str.Conc.In(1,i)...
        = SimpleAverage(Des.C.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.C.Str.Temp.Out(1,i)...
        = SimpleAverage(Des.C.TempOut, 0, StartIndx(1), EndIndx(1)); % [C]
    Cor.C.Str.Conc.Out(1,i)...
        = SimpleAverage(Des.C.ConcOut, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.C.Str.dC(1,i) ...
        = SimpleAverage(Des.C.ConcOut - ...
        Des.C.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.C.Str.WA_DesTOT_Mass(1,i) ...
        = DaySum(Perf.C.WA_Des, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    Cor.C.Str.WA_AirTOT_Mass(1,i) ...
        = DaySum(Perf.C.WA_Air, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    Cor.C.Str.WA_DesTOT_Enth(1,i) ...
        = DaySum(Enthalpy.Cond.WA_Des, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    Cor.C.Str.WA_AirTOT_Enth(1,i) ...
        = DaySum(Enthalpy.Cond.WA_Air, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    
    % Weak
    Cor.R.Wk.Temp.In(1,i)...
        = SimpleAverage(Des.R.TempIn, 0, StartIndx(1), EndIndx(1)); % [C]
    Cor.R.Wk.Conc.In(1,i)...
        = SimpleAverage(Des.R.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.R.Wk.Temp.Out(1,i)...
        = SimpleAverage(Des.R.TempOut, 0, StartIndx(1), EndIndx(1)); % [C]
    Cor.R.Wk.Conc.Out(1,i)...
        = SimpleAverage(Des.R.ConcOut, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.R.Wk.dC(1,i) ...
        = SimpleAverage(Des.R.ConcOut - ...
        Des.R.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
    Cor.R.Wk.WR_Des(1,i)...
        = SimpleAverage(Perf.R.WR_Des, 0, StartIndx(1), EndIndx(1)); % [kg/h]
    Cor.R.Wk.WR_Air(1,i)...
        = SimpleAverage(Perf.R.WR_Air, 0, StartIndx(1), EndIndx(1)); % [kg/h]
    Cor.R.Wk.WR_AirTOT_Mass(1,i)...
        = DaySum(Perf.R.WR_Air, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    Cor.R.Wk.WR_DesTOT_Mass(1,i)...
        = DaySum(Perf.R.WR_Des, 0, StartIndx(1), EndIndx(1))./60; % [kg]
    Cor.R.Wk.WR_DesTOT_Enth(1,i)...
        = DaySum(Enthalpy.Regen.WR_Des, 0, StartIndx(1), EndIndx(1))./60; % [kJ]
    Cor.R.Wk.WR_AirTOT_Enth(1,i)...
        = DaySum(Enthalpy.Regen.WR_Air, 0, StartIndx(1), EndIndx(1))./60; % [kJ]

    
    % COP
    Cor.R.COP_Air(1,i)...
        = SimpleAverage(Perf.R.COPth_Air, 0, StartIndx(1), EndIndx(1)); % [-]
    Cor.R.COP_Des(1,i)...
        = SimpleAverage(Perf.R.COPth_Des, 0, StartIndx(1), EndIndx(1)); % [-]

    % Cooling
    Cor.C.TC(1,i)...
        = DaySum(Perf.C.TC, 0, StartIndx(1), EndIndx(1))./60; % [kJ]
    Cor.C.SC(1,i)...
        = DaySum(Perf.C.SC, 0, StartIndx(1), EndIndx(1))./60; % [kJ]
    Cor.C.LC(1,i)...
        = DaySum(Perf.C.LC, 0, StartIndx(1), EndIndx(1))./60; % [kJ]
    Cor.C.SHR(1,i)...
        = Day.C.SC(1,i)/Day.C.TC(1,i);
    Cor.C.LHR(1,i)...
        = Day.C.LC(1,i)/Day.C.TC(1,i);
    
end
