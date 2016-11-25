function y=aanroepmollier(s,ss,name,sn,e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aangepast aan folders: niet verplaatsen !!!
% plots data into a mollier diagram, 
% december 23, 2004, TUe, PBE, MM en JvS
% demands(sensor,condition,title,filename,[0;0;0;0;0;0;1;0;0;0]), condition can be 1=air, 2=surf, 3=in, 4=surf2, 5=gap
%                                          ASHRAE A  Thomson1
%                                            ASHRAE B  Thomson2
%                                              ASHRAE C  Deltaplan
%                                                ASHRAE D  Mecklenburg
%                                                  Jutte     Lafontaine        (only one at a time can be '1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ss==[1]                                              % sets variables to match plot subject, a=column T, b=column x
    a=1;                                                % T = T air
    b=3;                                                % RH = RH air
    c=8;                                                % x = x air
    what=(['AIR conditions']);
elseif ss==[2]
    a=2;                                                % T = T surface
    b=4;                                                % RH = RH surface
    c=8;                                                % x = x surface ( = x air )
    what=(['SURFACE conditions']);
elseif ss==[3]
    a=11;                                               % T = T supplied by installation
    b=13;                                               % RH = RH supplied by installation
    c=18;                                               % x = x supplied by installation
    what=(['INSTALLATION AIR conditions']);
elseif ss==[4]
    a=12;                                               % T = T surface 2
    b=14;                                               % RH = RH surface 2
    c=8;                                                % x = x surface 2 ( = x air )
    what=(['EXTRA SURFACE conditions']);
elseif ss==[5]
    a=21;                                               % T = T cavity
    b=22;                                               % RH = RH cavity
    c=25;                                               % x = x cavity
    what=(['CAVITY AIR conditions']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demands (minimum T, maximum T, deltaT 1h, deltaT 24h, minimum RH, maximum RH, deltaRH 1h, deltaRH 24 h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(e)==8
demands=e;
dem=(['Indoor climate compared to demand']);
demleg=(['Demand         ';'min T  =     �C';'max T  =     �C';'DeltaTh =    �C';'DeltaT24 =   �C';'min RH  =     %';'max RH  =     %';'DeltaRHh =    %';'DeltaRH24 =   %']);
demleg(2,13-length(sprintf('%d',e(1))):12)=sprintf('%d',e(1));
demleg(3,13-length(sprintf('%d',e(2))):12)=sprintf('%d',e(2));
demleg(4,13-length(sprintf('%d',e(3))):12)=sprintf('%d',e(3));
demleg(5,13-length(sprintf('%d',e(4))):12)=sprintf('%d',e(4));
demleg(6,14-length(sprintf('%d',e(5))):13)=sprintf('%d',e(5));
demleg(7,14-length(sprintf('%d',e(6))):13)=sprintf('%d',e(6));
demleg(8,14-length(sprintf('%d',e(7))):13)=sprintf('%d',e(7));
demleg(9,14-length(sprintf('%d',e(8))):13)=sprintf('%d',e(8));
else
if e(1)==1;                                             % indoor climate according to ASHRAE A
demands([1:8])=[15 25 2 2 45 55 5 5];
dem=(['Indoor climate compared to ASHRAE A']);
demleg=(['ASHRAE A       ';'min T  =  15 �C';'max T  =  25 �C';'DeltaTh =  2 �C';'DeltaT24 = 2 �C';'min RH  =  45 %';'max RH  =  55 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
end
if e(2)==1;                                             % indoor climate according to ASHRAE B
demands([1:8])=[15 25 5 5 40 60 10 10];
dem=(['Indoor climate compared to ASHRAE B']);
demleg=(['ASHRAE B       ';'min T  =  15 �C';'max T  =  25 �C';'DeltaTh =  5 �C';'DeltaT24 = 5 �C';'min RH  =  40 %';'max RH  =  60 %';'DeltaRHh = 10 %';'DeltaRH24 = 10%']);
end
if e(3)==1;                                             % indoor climate according to ASHRAE C
demands([1:8])=[15 25 NaN NaN 25 75 NaN NaN];
dem=(['Indoor climate compared to ASHRAE C']);
demleg=(['ASHRAE C       ';'min T  =  15 �C';'max T  =  25 �C';'min RH  =  25 %';'max RH  =  75 %']);
end
if e(4)==1;                                             % indoor climate according to ASHRAE D
demands([1:8])=[15 25 NaN NaN 0 75 NaN NaN];
dem=(['Indoor climate compared to ASHRAE D']);
demleg=(['ASHRAE D       ';'min T  =  15 �C';'max T  =  25 �C';'min RH  =   0 %';'max RH  =  75 %']);
end
if e(5)==1;                                             % indoor climate according to Ton J�tte
demands([1:8])=[2 25 3 3 48 55 2 3];
dem=(['Indoor climate compared to Ton J�tte']);
demleg=(['Ton J�tte      ';'min T  =  02 �C';'max T  =  25 �C';'DeltaTh =  3 �C';'DeltaT24 = 3 �C';'min RH  =  48 %';'max RH  =  55 %';'DeltaRHh =  2 %';'DeltaRH24 = 3 %']);
end
if e(6)==1;                                             % indoor climate according to Thomson class 1
demands([1:8])=[19 24 1 1 50 55 5 5];
dem=(['Indoor climate compared to Thomson class 1']);
demleg=(['Thomson class 1';'min T  =  19 �C';'max T  =  24 �C';'DeltaTh =  1 �C';'DeltaT24 = 1 �C';'min RH  =  50 %';'max RH  =  55 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
end
if e(7)==1;                                             % indoor climate according to Thomson class 2
demands([1:8])=[-20 60 NaN NaN 40 70 NaN NaN];
dem=(['Indoor climate compared to Thomson class 2']);
demleg=(['Thomson class 2';'min RH  =  40 %';'max RH  =  70 %']);
end
if e(8)==1;                                             % indoor climate according to RGD Deltaplan
demands([1:8])=[18 20 2 2 50 60 5 5];
dem=(['Indoor climate compared to RGD Deltaplan']);
demleg=(['RGD Deltaplan  ';'min T  =  18 �C';'max T  =  20 �C';'DeltaTh =  2 �C';'DeltaT24 = 2 �C';'min RH  =  50 %';'max RH  =  60 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
end
if e(9)==1;                                             % indoor climate according to Marion Mecklenburg
demands([1:8])=[20 23 5 5 35 60 5 5];
dem=(['Indoor climate compared to Marion Mecklenburg']);
demleg=(['Mecklenburg, M.';'min T  =  20 �C';'max T  =  23 �C';'DeltaTh =  5 �C';'DeltaT24 = 5 �C';'min RH  =  35 %';'max RH  =  60 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
end
if e(10)==1;                                            % indoor climate according to CCI Lafontaine
demands([1:8])=[20 25 1.5 1.5 35 58 3 3];
dem=(['Indoor climate compared to CCI Lafontaine']);
demleg=(['Lafontaine CCI ';'min T  =  20 �C';'max T  =  25 �C';'DeltaTh= 1,5 �C';'DeltaTd= 1,5 �C';'min RH  =  35 %';'max RH  =  58 %';'DeltaRHh =  3 %';'DeltaRH24 = 3 %']);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
molliernieuw(s,ss,name,sn,demands,dem,demleg)