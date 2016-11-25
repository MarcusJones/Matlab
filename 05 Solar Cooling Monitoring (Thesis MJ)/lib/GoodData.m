clear Good

Cnt = 1;

for i = 1:length(StartEnd2(1,:))-2

    Start = StartEnd2(1,i);
    End = StartEnd2(2,i);

    StartIndx = find(Date>=Start);
    EndIndx = find(Date>=End);

    for j = StartIndx:1:EndIndx
        Good.Date(Cnt) = Date(j);
        
        Good.dT.Temp.dT(Cnt) = -1*(Hot.Temp.Out(j)-Hot.Temp.In(j));
        Good.Strong.dC(Cnt) = Des.R.ConcOut(j)-Des.R.ConcIn(j);
        Good.Air.Amb.W(Cnt) = Air.Amb.W(j);
        Good.Strong.C.In(Cnt) = Des.R.ConcIn(j);
        Good.Air.Amb.RH(Cnt) = Air.Amb.RH(j);
        Good.Hot.Temp.In(Cnt) = Hot.Temp.In(j);
        Good.Strong.Tempin(Cnt) = Des.R.TempIn(j);
        Good.WD(Cnt) = Perf.R.WR_Des(j);
        
        Good.C.Air.WA(Cnt) = Perf.C.WA_Air(j);
        Good.Weak.dC(Cnt) = Des.C.ConcOut(j) - Des.C.ConcIn(j);
        Good.Air.Amb.W(Cnt) = Air.Amb.W(j);
        Good.Air.Amb.T(Cnt) = Air.Amb.Temp(j);
        Good.Air.Amb.dT(Cnt) = Air.Amb.Temp(j) - Air.Proc.Temp(j);
        Good.Cool.Temp.In(Cnt) = Cold.Temp.In(j);
        Good.Weak.C.In(Cnt) = Des.C.ConcIn(j);
        Good.Des.Temp(Cnt) = Des.C.TempIn(j);
        Good.Cool.dT(Cnt) = Cold.Temp.In(j) - Cold.Temp.Out(j);
        Cnt = Cnt + 1;
    end

end


%datevec(StartEnd2(:,1))
clear Data Data2


% for i = 1:length(Good.dT.Temp.dT)
%     if (Good.dT.Temp.dT(i) > 4.5) && (Good.Hot.Temp.In(i) > 65) && (Good.Hot.Temp.In(i) <75)
%         %Good.dT.Temp.dT(i) = 0;
%         New(:,i) = datevec(Good.Date(i));
%     end
% end



% Data = [...
%         Good.dT.Temp.dT'...
%         Good.Strong.dC'...
%         Good.Air.Amb.W'...
%         Good.Strong.C.In' ...
%         Good.Air.Amb.RH'...
%         Good.Hot.Temp.In'...
%     ];
% 
% Data2 = [ ...
%         Good.C.Air.WA'...
%         Good.Weak.dC'...
%         Good.Air.Amb.W'...
%         Good.Air.Amb.T'...
%         Good.Cool.Temp.In'...
%         Good.Weak.C.In'...
%                 Good.Des.Temp'...
%                 -Good.Cool.dT'...
% ];
clear i j