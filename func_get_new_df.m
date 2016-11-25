function new_df = func_get_new_df(df,mask)

new_df.time = df.time;
new_df.headerDef = df.headerDef;
new_df.headers = df.headers(:,mask);
new_df.data = df.data(:,mask);
