function binout=isADPstruct(structin)
timelength=length(structin.time);
headersize=size(structin.header);
datasize=size(structin.data);
binout=(timelength==datasize(1))&&(headersize(1)==10)&&(headersize(2)==datasize(2));