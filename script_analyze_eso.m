%% 
clear all

% Home PC:
env_path = 'C:\';

% iC Laptop:
env_path = 'D:\';
%% 
%cd('C:\Projects\AllScripts\L Matlab');
%cd('D:\AllScripts\L Matlab');
cd(strcat(env_path, 'AllScripts\L Matlab'))

script_gen_paths

%% Load

load(strcat(env_path,'Projects\IDFout\ProposedTableZone Summary dataframe.mat'));
load(strcat(env_path,'Projects\IDFout\BaselineTableZone Summary dataframe.mat'));

zonesummary_proposed = ProposedTable;
zonesummary_baseline = BaselineTable;

clear ProposedTable BaselineTable

load(strcat(env_path,'Projects\IDFout\Baseline 1 - UNTITLED -   48.20 -   17.20 -    1.00 -  130.00.mat'));
load(strcat(env_path,'Projects\IDFout\Proposed 1 - UNTITLED -   48.20 -   17.20 -    1.00 -  130.00.mat'));

%load('C:\Projects\IDFout\Baseline 1 - HOTEL CENTRAL -   48.20 -   17.20 -    1.00 -  130.00.mat');
%load('C:\Projects\IDFout\Proposed 1 - HOTEL CENTRAL -   48.20 -   17.20 -    1.00 -  130.00.mat');

frame_list = {Proposed BaselineG000};

%% All headers
heads_bl = BaselineG000.headers';
heads_ad = Proposed.headers';



%% All variables
df = Proposed

heads = df.headers';

for row = 1:size(heads,1)
    this_row = heads(row,:);
    for col = 1:size(this_row,2)
        item = heads{row,col};
        display(-1,'* %s', item);
        
        %jprintf(-1,'* %s', item);
    end
    %jprintf(-1,'\n');
end

jprintf(-1,'****** Time step %.2f hours ********\n', 11);

%% ZONE DETAILS
zn = '1NP:1MEETING'
zn = '3NP:3OFF2'

df = BaselineG000
df = Proposed

mask = func_selection(df,{{'Category',zn}});

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df


%% Baseline AHU 1
df = BaselineG000

mask = func_selection(df,{{'Category','AHU 1NP'}});

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df

%% PIU operation
df = BaselineG000

mask = func_selection(df,{{'Category','PARALLEL PIU SUPPLY FAN OUTLET'},{'Name','System Node Mass Flow Rate '}});

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df


%% 1CORR
df = BaselineG000
%df = Proposed

mask = func_selection(df,{{'Category','1NP:1CORR1'}});

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df

%% Baseline chiller
df = BaselineG000

%mask1 = func_selection(df,{{'Category','CHILLER CHW INLET NODE'},{'Name','System Node Temperature '}});
%#mask2 = func_selection(df,{{'Category','CHILLER CHW OUTLET NODE'},{'Name','System Node Temperature '}});
%mask3 = func_selection(df,{{'Category','CHILLER CHW INLET NODE'},{'Name','System Node Mass Flow Rate '}});
%mask = mask1 | mask2 | mask3;

mask = func_selection(df,{{'Category','CHILLER '}});
new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df


%% Baseline air
df = BaselineG000

mask1 = func_selection(df,{{'Category','AHU 6NP SUPPLY SIDE OUTLET 1'},{'Name','System Node Mass Flow Rate '}});
mask2 = func_selection(df,{{'Category','AHU 6NP SUPPLY SIDE OUTLET 1'},{'Name','System Node Temperature '}});
mask3 = func_selection(df,{{'Category','AHU 6NP AHU COOLING COIL AIR OUTLET NODE'},{'Name','System Node Temperature '}});

mask = mask1 | mask2 | mask3;
new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);

plot_time_series2(new_df,pdef)
clear df

%% Fresh air BAR chart
df = Proposed
mask = func_selection_and(df,{{'Category','.* AHU.*OUTDOOR'},{'Name','System Node Mass Flow Rate'}});




%% Fresh air
fresh_air_df.headerDef = {'Name'}
fresh_air_df.headers = {{'A'},{'B'}}
fresh_air_df.time = Proposed.time
data = []
for i = 1:length(frame_list)
    df = frame_list{i};
    frame_list{i}
    mask = func_selection_and(df,{{'Category','.* AHU.*OUTDOOR'},{'Name','System Node Mass Flow Rate'}});
    col = sum(df.data(:,mask),2);
    data(:,i) = col;
end
fresh_air_df.data = data
pdef = func_get_pdef(1);

%mask = func_selection_and(df,{{'Category','AHU'}});
%pdef.dmask = mask;

%total_air = sum(df.data(:,mask),2)
plot_time_series2(fresh_air_df,pdef)

%% Heat pump ALL
df = Proposed

mask = func_selection(df,{{'Category','HEAT PUMP'}});

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);
plot_time_series2(new_df,pdef)


%% Heat pump temperatures
df = Proposed

mask1 = func_selection_and(df,{{'Category','HEAT PUMP COOLING CHW INLET NODE'},{'Name','System Node Temperature'}});
mask2 = func_selection_and(df,{{'Category','HEAT PUMP COOLING CHW OUTLET NODE'},{'Name','System Node Temperature'}});
mask3 = func_selection_and(df,{{'Category','HEAT PUMP HEATING HW INLET NODE'},{'Name','System Node Temperature'}});
mask4 = func_selection_and(df,{{'Category','HEAT PUMP HEATING HW OUTLET NODE'},{'Name','System Node Temperature'}});

mask = mask1 | mask2 | mask3 | mask4;

new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);
plot_time_series2(new_df,pdef)

%% Ventilation air temps
df = Proposed

mask = func_selection_and(df,{{'Category','AHU NR. 1.01 SUPPLY SIDE OUTLET 1'},{'Name','System Node Temperature'}});
new_df = func_get_new_df(df,mask);

pdef = func_get_pdef(1);
plot_time_series2(new_df,pdef)


%% Occupancy
occ_df.headerDef = {'Name'}
occ_df.headers = {{'A'},{'B'}}
occ_df.time = Proposed.time
data = []
for i = 1:length(frame_list)
    df = frame_list{i};
    mask = func_selection_and(df,{{'Name','People Occupant Count'}});
    col = sum(df.data(:,mask),2);
    data(:,i) = col;
end
occ_df.data = data
pdef = func_get_pdef(1);

plot_time_series2(occ_df,pdef)

%% PROPOSED Occupied temperature

zone_names = zonesummary_proposed.index;
func_occupied_temp(Proposed,zone_names)


%% BASELINE Occupied temperature

%df = BaselineG000
%this_zn = '1NP:1MEETING0'
%search_struct = ({{'Category',this_zn},{'Name','People Occupant Count'}});
%mask1 = func_selection_and(df,search_struct);

zone_names = zonesummary_baseline.index;
func_occupied_temp(BaselineG000,zone_names)


%% Plot environment
mask = func_selection(df,{{'Category','Env'}});

pdef = func_get_pdef(1);
pdef.dmask = mask;
%pdef.tmask = mask

plot_time_series2(df,pdef)


%% Print Stats

df = Proposed;

interval = 60;
jprintf(-1,'****** Time step %.2f hours ********\n', interval);

df.headers'


for idxCol = 1:size(df.headers,2)
    for idxRow = 1:size(df.headers,1)
        %jprintf(-1,'%10s, ',framedHead{idxRow,idxCol});
        jprintf(-1,'%s, ',df.headers{idxRow,idxCol});
    end
    jprintf(-1,'\n');
end


clear df


%% BASELINE Zone temperatures
%mask = func_selection(ProposedTable,{{'Header',''}});
df = BaselineG000

search_struct = {};
zone_names = zonesummary_proposed.index;
for i = 1:length(zone_names)
    this_zn = zone_names{i};
    search_struct{end + 1} =  ({'Category',this_zn});
end
mask1 = func_selection_or(df,search_struct);
mask2 = func_selection_and(df,{{'Name','Zone Mean Air Temperature'}});
mask = mask1 & mask2;
sum(mask)
pdef = func_get_pdef(1);
pdef.dmask = mask;
%pdef.tmask = mask

plot_histogram_lines2(df,pdef,1:0.1:50)
%plot_time_series2(df,pdef)
clear df


%% PROPOSED Zone temperatures TIME SERIES
%mask = func_selection(ProposedTable,{{'Header',''}});
df = BaselineG000
df = Proposed

search_struct = {};
zone_names = zonesummary_proposed.index;
for i = 1:length(zone_names)
    this_zn = zone_names{i};
    search_struct{end + 1} =  ({'Category',this_zn});
end
mask1 = func_selection_or(df,search_struct);
mask2 = func_selection_and(df,{{'Name','Zone Mean Air Temperature'}});
mask = mask1 & mask2;
sum(mask)
pdef = func_get_pdef(1);
pdef.dmask = mask;
%pdef.tmask = mask

plot_time_series2(df,pdef)
%plot_time_series2(df,pdef)
clear df



%% PROPOSED Zone temperatures HISTOGRAM
%mask = func_selection(ProposedTable,{{'Header',''}});
df = BaselineG000
df = Proposed

search_struct = {};
zone_names = zonesummary_proposed.index;
for i = 1:length(zone_names)
    this_zn = zone_names{i};
    search_struct{end + 1} =  ({'Category',this_zn});
end
mask1 = func_selection_or(df,search_struct);
mask2 = func_selection_and(df,{{'Name','Zone Mean Air Temperature'}});
mask = mask1 & mask2;
sum(mask)
pdef = func_get_pdef(1);
pdef.dmask = mask;
%pdef.tmask = mask

plot_histogram_lines2(df,pdef,1:0.1:50)
%plot_time_series2(df,pdef)
clear df

%%
%func_print_stats2()

%% Plot 1 zone

zone_name = '04.NP:CONF%4NP'
mask = func_selection(df,{{'Category',zone_name},{'Name','Zone Mean Air Temperature'}});
mask = func_selection(df,{});

pdef = func_get_pdef(1);
pdef.dmask = mask;
%pdef.tmask = mask

plot_time_series2(df,pdef)
