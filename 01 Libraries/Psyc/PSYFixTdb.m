function PSYFixTdb(action)
if nargin==0
   action='init';
end

switch (action)
case 'init'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   note8=findobj(0,'tag','Note8');
   note9=findobj(0,'tag','Note9');
   
   global patm
   global rh
   global tdb
      
pws=psy(tdb,0,0,'pws'); 			% in kPa
hfg=psy(tdb,0,0,'hfg'); 				% in kJ/kg
pw=psy(pws,rh,0,'pw');  			% in kPa
ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
ahoftdb=psy(patm,pws,100,'ah'); 	% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
h=psy(tdb,ah,0,'h'); 				% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
dos=psy(patm,pws,rh,'dos');			% in kg/kg
twb=psy(tdb,tdp,0,'twb');			% in degree C
%-------------------------------------------------
z=zeros(1,13);
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;
set(h1,'string',num2str(z(1)),'visible','on');
set(h2,'string',num2str(z(2)),'visible','on');
set(h3,'string',num2str(z(3)),'visible','on');
set(h4,'string',num2str(z(4)),'visible','on');
set(h5,'string',num2str(z(5)),'visible','on');
set(h6,'string',num2str(z(6)),'visible','on');
set(h7,'string',num2str(z(7)),'visible','on');
set(h8,'string',num2str(z(8)),'visible','on');
set(h9,'string',num2str(z(9)),'visible','on');
set(h10,'string',num2str(z(10)),'visible','on');
set(h11,'string',num2str(z(11)),'visible','on');
set(h12,'string',num2str(z(12)),'visible','on');
%-------------------------------------------------print limite area
pwmax=psy(pws,100,0,'pw');
ahmax=psy(patm,pws,100,'ah');
strPw=['0<Pw<' num2str(pwmax)];
strAH=['0<AH<' num2str(ahmax)];
set(note8,'string',strPw);
set(note9,'string',strAH);



figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));
   
%-------------------------------------------------------------------------------------
%UI functions
case 'cbTdb'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
tdb=str2num(get(h2,'string'));
if tdb>70
   tdb=70;
elseif tdb<-40
   tdb=-40;
end
 
   
pws=psy(tdb,0,0,'pws'); 			% in kPa
hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
pw=psy(pws,rh,0,'pw');  			% in kPa
ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
ahoftdb=psy(patm,pws,100,'ah');	% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
h=psy(tdb,ah,0,'h'); 				% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
dos=psy(patm,pws,rh,'dos');		% in kg/kg
twb=psy(tdb,tdp,0,'twb');			% in degree C

z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));


case 'cbTwb'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
   twb=str2num(get(h3,'string'));  
   
      	pws=psy(tdb,0,0,'pws'); 			% in kPa
	      hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
         ahoftdb=psy(patm,pws,100,'ah');	% in kg/kg
   		rh=psy(tdb,twb,0,'rh2');
			pw=psy(pws,rh,0,'pw');  			% in kPa
			ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
			tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
         
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));
   
case 'cbTdp'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
   tdp=str2num(get(h4,'string'));
     	pws=psy(tdb,0,0,'pws'); 			% in kPa
	   hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
      ahoftdb=psy(patm,pws,100,'ah'); 	% in kg/kg
      pw=psy(tdp,0,0,'pws'); 				% in kPa
      rh=pw/pws*100;
		ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
		h=psy(tdb,ah,0,'h'); 				% in kJ/kg
		sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
		dos=psy(patm,pws,rh,'dos');		% in kg/kg
		twb=psy(tdb,tdp,0,'twb');			% in degree C
      
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));

   
   
   
case 'cbRH'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
rh=str2num(get(h5,'string'));
if rh>99.99
   rh=99.99;
elseif rh<0.01
   rh=0.01;
end
   
pws=psy(tdb,0,0,'pws'); 			% in kPa
hfg=psy(tdb,0,0,'hfg'); 				% in kJ/kg
pw=psy(pws,rh,0,'pw');  			% in kPa
ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
ahoftdb=psy(patm,pws,100,'ah'); 		% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
h=psy(tdb,ah,0,'h'); 				% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
dos=psy(patm,pws,rh,'dos');			% in kg/kg
twb=psy(tdb,tdp,0,'twb');			% in degree C

z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));


case 'cbPw'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
   pw=str2num(get(h8,'string'));
   
     	pws=psy(tdb,0,0,'pws'); 			% in kPa
	   hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
      ahoftdb=psy(patm,pws,100,'ah');	% in kg/kg
      rh=pw/pws*100;
		ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
		tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
		h=psy(tdb,ah,0,'h'); 				% in kJ/kg
		sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
		dos=psy(patm,pws,rh,'dos');		% in kg/kg
      twb=psy(tdb,tdp,0,'twb');			% in degree C
      
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));

case 'cbAH'
   h1=findobj(0,'tag','H1');
   h2=findobj(0,'tag','H2');
   h3=findobj(0,'tag','H3');
   h4=findobj(0,'tag','H4');
   h5=findobj(0,'tag','H5');
   h6=findobj(0,'tag','H6');
   h7=findobj(0,'tag','H7');
   h8=findobj(0,'tag','H8');
   h9=findobj(0,'tag','H9');
   h10=findobj(0,'tag','H10');
   h11=findobj(0,'tag','H11');
   h12=findobj(0,'tag','H12');
   global patm
   global rh
   global tdb
   
   ah=str2num(get(h9,'string'));
   
     	pws=psy(tdb,0,0,'pws'); 				% in kPa
	   hfg=psy(tdb,0,0,'hfg'); 				% in kJ/kg
      ahoftdb=psy(patm,pws,100,'ah'); 		% in kg/kg
      pw=psy(patm,ah,0,'pw2');				% in kPa
      rh=pw/pws*100;							% in %
      tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
	   h=psy(tdb,ah,0,'h'); 				% in kJ/kg
		sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
		dos=psy(patm,pws,rh,'dos');		% in kg/kg
      twb=psy(tdb,tdp,0,'twb');			% in degree C
      
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;

set(h1,'string',num2str(z(1)));
set(h2,'string',num2str(z(2)));
set(h3,'string',num2str(z(3)));
set(h4,'string',num2str(z(4)));
set(h5,'string',num2str(z(5)));
set(h6,'string',num2str(z(6)));
set(h7,'string',num2str(z(7)));
set(h8,'string',num2str(z(8)));
set(h9,'string',num2str(z(9)));
set(h10,'string',num2str(z(10)));
set(h11,'string',num2str(z(11)));
set(h12,'string',num2str(z(12)));

figure(findobj('Tag','CHART'));
PSchart;
figure(findobj('Tag','INPUT'));
end