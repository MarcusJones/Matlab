function return_df = func_convert_to_strings(this_df)

    return_df = this_df;
    for idxCol = 1:size(this_df.headers,2)
        for idxRow = 1:size(this_df.headers,1)
            %jprintf(-1,'%10s, ',framedHead{idxRow,idxCol});
            elem = num2str(this_df.headers{idxRow,idxCol});
            return_df.headers{idxRow,idxCol} = elem;
        end
    end