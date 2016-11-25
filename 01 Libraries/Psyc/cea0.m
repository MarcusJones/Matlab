function cea0(action)
clc

if nargin==0
   action='init';
end
switch (action)
case 'init'

   figure('tag','CEA','Resize','on','MenuBar','none',...
   'Name','Controlled Environment Agricultural Engineering','NumberTitle','off','Position',[100,100,600,420]);

   fp = uimenu('Label','Psychrometrics');
	uimenu(fp,'Label','psy1','Callback','psy1');
	uimenu(fp,'Label','psy2','Callback','psy2');
   uimenu(fp,'Label','psy0','Callback','psy0');
   uimenu(fp,'Label','ex2_1','Callback','ex2_1');
   uimenu(fp,'Label','figure2_2','Callback','fig2_2');   
   uimenu(fp,'Label','ex2_2','Callback','ex2_2');
   uimenu(fp,'Label','ex2_3','Callback','ex2_3');
   uimenu(fp,'Label','ex2_4','Callback','ex2_4');
   uimenu(fp,'Label','ex2_5','Callback','ex2_5');
   uimenu(fp,'Label','table2_2','Callback','table2_2');
   uimenu(fp,'Label','ex2_11','Callback','ex2_11');
   uimenu(fp,'Label','ex2_13','Callback','ex2_13');
   uimenu(fp,'Label','thi_chart','Callback','thi_chart');

   uimenu(fp,'Label','Psychart','Callback','psychart');
   uimenu(fp,'Label','Close all','Callback','close','Separator','on');
   
	fp1 = uimenu('Label','Balance');
	uimenu(fp1,'Label','ex3-9','Callback','balance1(''1'')');
	uimenu(fp1,'Label','ex3-16','Callback','balance1(''2'')');
	uimenu(fp1,'Label','ex3-17','Callback','balance1(''3'')');
	uimenu(fp1,'Label','ex3-18','Callback','balance1(''4'')');
   uimenu(fp1,'Label','Close all','Callback','close','Separator','on');
   
   fp2 = uimenu('Label','View Factor');
  	uimenu(fp2,'Label','Edit','Callback','cea0(''edit'')','Accelerator','E');
	uimenu(fp2,'Label','configuration 1','Callback','viewfactor(''1'')');
   uimenu(fp2,'Label','configuration 2','Callback','viewfactor(''2'')');
	uimenu(fp2,'Label','configuration 3','Callback','viewfactor(''3'')');
	uimenu(fp2,'Label','configuration 4','Callback','viewfactor(''4'')');
   uimenu(fp2,'Label','configuration 5','Callback','viewfactor(''5'')');
	uimenu(fp2,'Label','configuration 6','Callback','viewfactor(''6'')');
	uimenu(fp2,'Label','configuration 7','Callback','viewfactor(''7'')');
   
   fp3 = uimenu('Label','Radiation');
   uimenu(fp3,'Label','Plancks'' Law','Callback','Plancks(''1'')');
  	uimenu(fp3,'Label','Stefan-Boltzmaan''s Law','Callback','Plancks(''2'')');
   fp4 = uimenu('Label','Exchanger');      
   uimenu(fp4,'Label','Parallel flow (NTU unknown)','Callback','ntu(''1'')');
   uimenu(fp4,'Label','Counter flow (NTU unknown)','Callback','ntu(''2'')');
   uimenu(fp4,'Label','Compare (NTU unknown)','Callback','ntu(''3'')');   
	uimenu(fp4,'Label','Parallel flow (NTU given)','Callback','ntu(''4'')','Separator','on');   
	uimenu(fp4,'Label','Counter flow (NTU given)','Callback','ntu(''5'')');   
   uimenu(fp4,'Label','Counter flow (NTU given,C=0,1)','Callback','ntu(''6'')');   
   uimenu(fp4,'Label','function exp','Callback','funEX','Separator','on');   
   uimenu(fp4,'Label','ex4-9       Please check the...','Callback','ex4_9','Separator','on');
   uimenu(fp4,'Label','ex4-11        command window...','Callback','ex4_11');
   uimenu(fp4,'Label','ex4-12,13      for results.','Callback','ex4_1213');

  	fp6 = uimenu('Label','Snell');
	uimenu(fp6,'Label','POLYNOM_1','Callback','snell_law(1)');
	uimenu(fp6,'Label','ex5-5','Callback','snell_law(2)');
	uimenu(fp6,'Label','ex5-6','Callback','snell_law(3)');
	uimenu(fp6,'Label','Close','Callback','snell_law(4)','Separator','on');

  	fp7 = uimenu('Label','Ventilation');
	uimenu(fp7,'Label','POLYNOM_2','Callback','polynom');
	uimenu(fp7,'Label','VentGraph','Callback','ventgraph');
   uimenu(fp7,'Label','Natural Vent.','Callback','NV','separator','on');
   uimenu(fp7,'Label','Pad and Fan','Callback','padandfan');
   

   
   fp5 = uimenu('Label','Solar Eng.');      
   uimenu(fp5,'Label','Run Solar0','Callback','solar0');

  
   fh = uimenu('Label','Help');
	uimenu(fh,'Label','About Author','Callback','cea0(''author'')');
	uimenu(fh,'Label','About Software','Callback','cea0(''version'')');
   
case 'version'
	figure('tag','VERSION','Resize','off','MenuBar','none',...
   	'Name','Version','NumberTitle','off','Position',[140,200,200,60]);
	t1 = uicontrol('Units','normalized','Position',[.1, .1, .8, .8],...
	   'string','This software was last updated on 2001/10/4.','style','text'); % disp Text in Figure
	act1 = uicontrol('Units','normalized','Position',[.4,.1, .2, .3],...
   	'string','OK','style','pushbutton',...
	   'callback','close');    
case 'author'
   figure('tag','AUTHOR','Resize','off','MenuBar','none',...
   'Name','Author','NumberTitle','off','Position',[140,200,250,100]);

	showtxt='Professor Wei Fang, Ph.D., Dept. of Bio-Industrial Mechatronics Engineering, National Taiwan University, Email: weifang@ccms.ntu.edu.tw';
	t1 = uicontrol('Units','normalized','Position',[.1, .1, .8,.8],...
         'string',showtxt,'style','text'); % disp Text in Figure
   act1 = uicontrol('Units','normalized','Position',[.4,.1,.2,.2],...
   'string','OK','style','pushbutton',...
   'callback','close'); % you can enter 'push' for 'pushbutton'
%-------------------------------------------------set UI position
case 'cbTdb'
   f2=findobj(0,'tag','F2');
   h2=findobj(0,'tag','H2');
	tdb=str2num(get(f2,'string'));
	set(h2,'string',tdb,'style','text');
   
case 'cbAct1'
   clear all;
   close all;
end
%---------------------------------------------


