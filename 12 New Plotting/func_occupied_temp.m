function func_occupied_temp(df,zone_names)

% Take an eso frame

% Plot temperature histogram during occupied hours, for all zone names

%% Occupied temperature
occtemp_df.headerDef = {'Name'};
occtemp_df.headers = {}
occtemp_df.time = df.time;
data = [];

for i = 1:length(zone_names)
    this_zn = zone_names{i};
    this_zn = strcat(this_zn,'$');
    display(strcat('Working on ', this_zn));
    %%% First, mask the rows where no occupants are detected in this zone
    search_struct = ({{'Category',this_zn},{'Name','People Occupant Count'}});
    mask1 = func_selection_and(df,search_struct);
    df.headers(:,mask1);
    this_occ_col = df.data(:,mask1);
    this_occ_mask = this_occ_col > 0;
    display(strcat('	Found hours:  ', int2str(sum(this_occ_mask))) );
    
    %%% Second, get the zone temperature column for this zone
    mask2 = func_selection_and(df,{{'Category',this_zn},{'Name','Zone Mean Air Temperature'}});
    this_temp_col = df.data(:,mask2); % Get col
    this_temp_col(~this_occ_mask,:) = NaN; % Blank the unocc hours
    
    % Append all this
    data(:,end + 1) = this_temp_col;
    occtemp_df.headers(end+1) = {this_zn};
    
    
end
occtemp_df.data = data;
pdef = func_get_pdef(1);

plot_histogram_lines2(occtemp_df,pdef,1:0.2:50)


df.headers(:,mask1)

%regexp('1NP:1OFF5','^1NP:1OFF5$')

%plot_time_series2(occtemp_df,pdef)
