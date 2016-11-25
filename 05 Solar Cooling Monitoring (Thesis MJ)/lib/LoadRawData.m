% This script loads and formats the raw data and column labels


%Import raw data from CR10X DAT file
fileToRead = 'D:\L Scripts\02L Matlab\05 Solar Cooling Monitoring (Thesis MJ)\Data\RawData\AILr AC_FSArea1.dat';
DELIMITER = ',';
HEADERLINES = 0;
rawdata = importdata(fileToRead, DELIMITER, HEADERLINES);

% Patch Holes!
% PatchHoles


%Import label data from CR10X FSL file
fileToRead = 'D:\L Scripts\02L Matlab\05 Solar Cooling Monitoring (Thesis MJ)\Data\RawData\07072008_QUEENS_1.fsl';
DELIMITER = ' ';
HEADERLINES = 0;
labels = importdata(fileToRead);

% Extract text from the data file and append date column
Headers = char(labels.textdata(:,1));
Headers(1,:) = [];

Headers(1:5,:) = []; %Preamble
% Headers(1:3,:) = []; %Date
Headers = char('1 Date', Headers);
% Headers(1,:) = ['Date']
% Headers(length(Headers(:,1))-11:length(Headers(:,1)),:) = [];

%Headers = strtrim(Headers);
%for i = 1:length(Headers)
%    s(i).l = Headers(:,:)
%end

clear fileToRead DELIMITER HEADERLINES labels

HH = zeros(1,length(rawdata(:,4)));
MM = zeros(1,length(rawdata(:,4)));
DD = zeros(1,length(rawdata(:,4)));
MO = zeros(1,length(rawdata(:,4)));
DateNumber = zeros(1,length(rawdata(:,4)));

% Process date into serial date number and append
for i = 1:length(rawdata(:,4))
    [HH(i),MM(i)] = HourMin(rawdata(i,4));
    DD(i) = DayMonthNumber(rawdata(i,3));
    MO(i) = MonthNumber(rawdata(i,3));
    DateNumber(i) = datenum(2008, MO(i), DD(i), HH(i), MM(i), 0);
end

% Clear the first column of raw data
rawdata (:,1) = [];

% And append the datenumber to the raw data
DatedData = [DateNumber', rawdata];

clear HH MM DD MO DateNumber i rawdata