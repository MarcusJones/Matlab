%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAPHS for INDOOR CLIMATE MEASUREMENTS
% February 8, 2005, TUe, PBE, MM                      INPUTFILE
% files needed: conversion, year, month, week, reduce, timeplot, mollier, demands, statistics, errtime, numbers, mollierdensity
%               getsimresult, compare, also read instruction_guide.pdf for details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1: LOAD DATA
% load datafile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load input.mat % loads measurement data
load sim.mat   % loads simulation data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2: DEFINE TIME AND SENSORS
% time=datenum(yyyy,mm,dd,uu,mm,ss);
% sensor=conversion(Tair,Tsurf,RHair,time,Tin,Tsurf2,RHin,Taircavity,RHaircavity), 4,7 or 9 inputs, if data isn't available: []
% cli=conversion(Tclimate,[],RHclimate,time) if no climate file is available: cli=conversion([],[],[],time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time1=datenum(Data(:,3)-3,Data(:,1),Data(:,2),Data(:,4),Data(:,5),Data(:,6));
time2=tsim;
sensor1=conversion(Data(:,8),Data(:,7),Data(:,9),time1);
simu1=conversion(bintemp(:,1),opptemp(:,1),binvocht(:,1),time2);
cli=conversion([],[],[],time1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3: PREDEFINED PLOTS (PLOTS WHICH CONTAIN A SPECIFIC PERIOD)
% year(sensor,climate,title,filename,year,Tmin,Tmax,RHmin,RHmax,[0;0;0;0;0;0;1;0;0;0])
%                                                                ASHRAE A  Thomson1
%                                                                  ASHRAE B  Thomson2
%                                                                    ASHRAE C  Deltaplan
%                                                                      ASHRAE D  Mecklenburg
%                             (only one at a time can be '1')            Jutte     Lafontaine
% month(sensor,climate,title,filename,year,month)
% week(sensor,climate,title,filename,year,week)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=2000;
year(sensor1,cli,'TU/e example inputfile','Example',y,'ashraec')

m=11;
month(sensor1,cli,'TU/e example inputfile','Example',y,m)

w=48;
week(sensor1,cli,'TU/e example inputfile','Example',y,w)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 4: DEFINE TIMESPAN TO PLOT
% starttime=datenum(yyyy,mm,dd,uu,mm,ss);      if you wish to plot the whole data period, don't use this step
% endtime=datenum(yyyy,mm,dd,uu,mm,ss);
% sensor=reduce(sensor,starttime,endtime);     NOTE: data needs to be larger than starttime and endtime 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

starttime=datenum(2000,2,1,0,0,0);
endtime=datenum(2000,6,1,0,0,0);
sensor1=reduce(sensor1,starttime,endtime);
simu1=reduce(simu1,starttime,endtime);
cli=reduce(cli,starttime,endtime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 5: OTHER PLOTS
% timeplot(sensor,climate,title,filename) plots sensor readings against time
% mollier(sensor,condition,title,filename,[0;0;0;0;0;0;1;0;0;0]), condition can be 1=air, 2=surf, 3=in, 4=surf2, 5=cavity
%                                          ASHRAE A  Thomson1
%                                            ASHRAE B  Thomson2
%                                              ASHRAE C  Deltaplan
%                                                ASHRAE D  Mecklenburg
%                                                  Jutte     Lafontaine        (none, one or more can be '1')
% mollierdensity(time,temp,rh,name,savename,demand,varargin);
%    s: sensor
%    name: title to put above graph
%    savename: file will be saved to disk under this name
%    demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%             'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%             or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
%    varargin: if there's an extra input which has value 1, the histograms won't be plotted
% numbers(s,name,savename,demand);
%    s: sensor
%    name: title to put above graph
%    savename: file will be saved to disk under this name
%    demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%             'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%             or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
% errtime(s,name,savename,demand)
%    s: sensor (10 column vector)
%    name: title to put above graph
%    savename: file will be saved to disk under this name
%    demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%               'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%               or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
% compare(sen1,sen2,name1,name2,title,filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeplot(sensor1,cli,'TU/e example inputfile','Example')

mollier(sensor1,1,'TU/e example inputfile','Example',[1,1,1,1,1,1,1,1,1,1])

mollierdensity(sensor1,'TU/e example inputfile','Example','jutte')

errtime(sensor1,'TU/e example inputfile','Example','cci')

numbers(sensor1,'TU/e example inputfile','Example','thomson1')

compare(sensor1,simu1,'Measured','Simulated','TU/e comparison example','Example')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear global
clear Data t