
settings.currFile = mfilename;
settings.currFilePath = mfilename('fullpath');
settings.currFilePath = ...
    settings.currFilePath(1:length(settings.currFilePath) ...
    -length(settings.currFile));
cd(settings.currFilePath);
localLibDir = [pwd, '\lib'];

mssg = judp('receive',4001,10,5000);

char(mssg')

for i = 1 : 1000
    judp('send',4001,'10.101.20.62',int8('Howdy!'))
    pause(1)
end


dos('netstat -a -n')
judp('send',21566,'208.77.188.166',int8('Howdy!'))
dos('netstat -a -n')