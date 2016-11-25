function func_check_frame(frame)

[rows cols] = size(frame.data);

assert(all(size(frame.time) == [rows, 1]), 'Time length mismatch')

[hrows hcols] = size(frame.headers);

assert(cols == hcols, 'Head length mismatch')

assert(all(size(frame.headerDef) == [hrows, 1]), 'Header def length mismatch')

assert(cols == hcols, 'Head length mismatch')
