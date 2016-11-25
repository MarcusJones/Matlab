%STARTEXAMPLE2  Example 1-year period, with Climate Evaluattion Chart 
%               profiles are adapted compared to example1
% ------------------------------------------------------------------------
%             HAMBASE
%
% HEAT And Moisture Building And Systems Evaluation
% -------------------------------------------------------------------------
% BUILDINGref
% 
% Example input file to specify the building, profiles, systems are off  
% The name of this m-file can be changed at wish.
% dec 2004


% ------------------------------------------------------------------------------
%  PART 1 : THE CALCULATION PERIOD
% -------------------------------------------------------------------------

% The available climate data of De Bilt are of the years 1971 till 2000. If the
% climate files of a different location are used the name and format must be
% adapted and the geographical coordinates must be changed (in InClimate-file).
% As an average year can be considered 1 May 1974 till 30 April 1975.
% A cold winter (242 days) started 1 September 1978.
% A hot summer (123 days) started 1 May 1976.
% 9 hot days started at 1 July 1976 and 9 cold days started at 30 December 1978.

% 
% FORMAT BASE.Period=[yr,month,day,ndays]
%
% yr 		= start year
% month 	= start
% month day	= start day
% ndays     = number of days simulated

%BASE.Period=[1976,1,1,90,1];
BASE.Period=[1981,11,15,365];

% If BASE.DSTime=1 the EU daylight-savings time is taken into account. It starts on the
% last Sunday of March and ends on the the last Sunday of October (the total
% duration is 30 or 31 weeks). If there is no daylight-savings period BASE.DSTime=0
% If the daylight-savings period is different from the EU the starting and ending days
% must be given:
% BASE.DSTime(1,:)=[year,starting month,day,ending month,day];
% BASE.DSTime(2,:)=[year+1,starting month,day,ending month,day]; etc.

%BASE.DSTime(1,:)=[1987,4,28,4,29];
%BASE.DSTime(2,:)=[1988,4,3,4,3];
BASE.DSTime=1;

% ------------------------------------------------------------------------- ---
% PART 2 : THE BUILDING 
% ------------------------------------------------------------------------- ---

%   ZONES NUMBERS [-] & VOLUMES [m3]
%
% A zone consist of a room or several adjacent rooms with oubout the same 
% temperature and relative humidity and the same climate control e.g. a dwelling
% might have three zones: the ground floor (living room etc), the first floor
% (sleeping) and the attic (not heated). There is however no restriction in the
% number of zones that can be simulated. Example: three zones: BASE.Vol{1}=..;
% BASE.Vol{2}=..; BASE.Vol{3}=.. If alone 2: use '%' for 1 and 3 so only
% BASE.Vol{2} remains.
%
% FORMAT BASE.Vol{zonenumber}=volume (m3);
BASE.Vol{1}= 145.8;
BASE.Vol{2}=110.8;
BASE.Vol{3}= 58.4;
BASE.Vol{4}= 58.4;

% ** CONSTRUCTION COMPONENTS DATA **
%
% A construction component usually consists of different layers. The order of
% the input of the properties of these layers is standard from indoors to
% outdoors and for construction components between zones from the zone with the
% lowest zone-number to the highest so: 1->2,1->3,2->3etc..  The material
% properties of the component layer are inserted by a material ID-number. By
% typing 'help matpropf' a list of materials appear with a material ID-number.
% Also each different construction component gets a different construction
% ID-number: conID=1,2,....
%
% FORMAT BASE.Con{conID}=[Ri,d1,matID,...,dn,matID,Re,ab,eb].
% dn 	= material layer thickness [m]
% matn = material ID-number.
% Ri = internal surface heat transfer resistance (for example Ri=0.13) [Km2/W]
% Re = surface heat transfer resistance at the opposite site (for example Re=0.04) [Km2/W]
% ab = external solar radiation absorption coefficient [-] e.g.light ab=0.4, dark ab=0.9.
% eb = external longwave emmisivity [-]. Almost always: eb=0.9

% BASE.Con{conID}=[Ri,  d1,matID,...         ,    							dn,matID,  Re,   ab,   eb].
BASE.Con{1} =  [0.13,  	0.214,235, 	0.120,409,  0.050,003, 	0.100,234, 				0.04,	0.9,	0.9];
BASE.Con{2} =  [0.13,	0.013,381,	0.074,409,	0.013,381,			   				0.13,	0.5,	0.9];		
BASE.Con{3} =  [0.13,	0.070,326,									   						0.13,	0.5,	0.9];
BASE.Con{4} =  [0.13, 	0.010,261,	0.070,235,						   					0.13,	0.5,	0.9];
BASE.Con{5} =  [0.13,	0.100,235,	0.170,404,	0.030,001, 	0.100,233, 				0.04,	0.9,	0.9];
BASE.Con{6} =  [0.13,	0.020,512,	0.480,002, 	0.370,316, 	0.200,453,0.005,601,	0.04,	0.8,	0.9];
BASE.Con{7} =  [0.13,	0.200,312, 	0.080,456,  0.050,312,								1,		0.9,	0.9];
BASE.Con{8} =  [0.13, 	0.015,262,	0.200,312,	0.050,456,	0.050,312,  			1,		0.9,	0.9];
BASE.Con{9} =  [0.17,	0.050,365,	0.370,316,	0.480,002,	0.020,512,				0.1,	0.6,	0.9];
BASE.Con{10}= 	[0.17,	0.010,366,	0.200,312,	0.015,262,								0.1,	0.6,	0.9];
BASE.Con{11}=  [0.13,	0.040,501,																0.04,	0.8,	0.9];
BASE.Con{12}=  [0.13,	0.040,505,																0.13,	0.6,	0.9];

% Commments
% 1:  limestone,insulation,air gap,brick (external wall)
% 2:  plaster,insulation,plaster (internal wall)
% 3:  light concrete (internal wall, not used in this example)
% 4:  tiles, limestone (internal wall, not used in this example)
% 5:  limestone, insulation, air gap, hard brick (external wall)
% 6:  roof construction 
% 7:  floor construction
% 8:  floor construction
% 9:  plaster, system floor, air gap, medium hardboard (floor between zones)
% 10: floor between zones 
% 11: exterior door
% 12: interior door 

% ** GLAZING SYSTEMS DATA**
% 
% The solar gain factor of glazing depends on the incident angle of the solar
% radiation. The properties below are independent of this angle but if one wants
% to account for the incident angle this can be done with the shadow section
% (below). Each different glazing system gets an ID-number: glaID=1,2,.
%
% FORMAT BASE.Glas{glaID}=[Uglas,CFr,ZTA,ZTAw,CFrw,Uglasw]
%
% Uglas	= U-value without sunblinds  [W/m2K]
% CFr	= convection factor without blinds [-]
% ZTA	= Solar gain factor [-] without blinds
% ZTAw  = Solar gain factor [-] with blinds
% CFrw	= convection factor with blinds [-]
% Uglasw = U-value with blinds  [W/m2K]
%
%BASE.Glas{glaID}=[Uglas,	CFr,		ZTA,		ZTAw,		CFrw, 	Uglasw]
BASE.Glas{1}=		[1.309,	0.047,	0.308,	0.072,	0.116,	1.253	];
BASE.Glas{2}=		[5.7,		0.01,		0.80,		0.31,		0.34,		5.7		];
BASE.Glas{3}=		[1.4,		0.03,		0.65,		0.3,		0.4,		1.4		];

% Comments
% Glazing 1  saint-roch skn 165
% Glazing 2  single glazing with interior sunblinds
% Glazing 3 HR glazing with interior sunblinds
% Glazing 4 double glazing with interior sunblinds

% ** ORIENTATIONS **
%
% For each surface of the building envelope (exterior walls) the tilt and the
% orientation with respect to the south has to be known. Each different
% orientation gets a different orientation-ID-numbernumber: orID.
%
% FORMAT  BASE.Or{orID}=[beta gamma]
% beta	= tilt (vertical=90,horizontal=0)
% gamma = azimuth (east=-90, west=90, south=0, north=180)
%
%BASE.Or{orID}=[beta, 	gamma];
BASE.Or{1}= [90.0,  		135.0	];
BASE.Or{2}= [90.0,  		-45.0	];
BASE.Or{3}= [45.0,  		135.0	];
BASE.Or{4}= [90.0,   	0.0	]; 		% south wall
BASE.Or{5}= [0.0,    	0.0	]; 		% horizontal roof

% **SHADOWING DATA**
%
% For each vertical window the shadow by exterior obstacles can be accounted
% for. The obstacles can have any combination of blocks, cylinders and spheres,
% provided some limitations regarding the positioning: The position of the
% blocks is such that two planes are horizontal, two vertical and perpendicular
% to the window pane and two parallel. The axis of the cylinder must be
% vertical. E.g. a tree is a cylinder and a sphere. If two equal windows with
% the same orientation and zone have a different shadow they cannot be added to
% one window (with the sum of the surface areas) anymore. Each shadow situation
% gets a shadow ID-number:shaID.
%
% FORMAT BASE.shad{shaID}= [
% typenr, size1, size2, size3, x, y, z, extra;
% ......,......,......,......,..,..,..,......;
% typenr, size1, size2, size3, x, y, z, extra;
% typenr, size1, size2, size3, x, y, z, extra;]
%
% x,y,z are Cartesian coordinates where z is vertical and x is horizontal and
% perpendicular to the window plane. Left means left when facing the window from
% outside. The sizes are always positive numbers.
%
% typenr=1 (window):size1=depth (=distance glazing to exterior surface), size2=
%   width, size3=height of the window
%   [x,y,z] = the coordinates of the lowest window corner at the left side
%   extra   = elevation-angle of the horizon in degrees to account for far-away
%   obstacles.
% typenr=2 (block):size1= width(in x-direction),size2=length(in y-direction),
%   size3=height(in z-direction)
%   x,y,z] coordinates of the left block corner closest to the window
%   extra= solar transmission
%   factor (0 opaque) 
% typenr=3 (tree):size1=radius crown,size2=radius trunk (e.g.1/20*radius crown),
%   size3=height center of crown
%   [x,y,z]: coordinates of the bottom of trunk.
%   extra=solar transmission factor of crown (0 opaque). In winter(120<iday< 304)
%   this is higher than in summer. e.g. winter extra=0.8, summer extra=0.35
% typenr =4 input for incident angle dependency of transmittivity of glazing.
%   Perpendicular (angle=0) always 1 and for 90 degrees (parallel) always 0. So
%   there is no need for an input for these angles! First row [4, incident
%   angle1,.,incident angle7], second row [5, transmittivity1,.,transmittivity7] 
%
% Example input
%
BASE.shad{1}=[
    1  0.07     5        1.6          0        0.5000         0.7   3;...
        2  0.1      5.1      3.0000       17.00    0.0000         0     0;...
        2  17.00    0.1      3.0000       0        5.1000         0     0;...
        2 17.00     0.1      2.0000       0        0.0000         0     0;...
        2  0.5      24.00    9.2000       34.10   -9.0000         0     0;...
        3  1.25     1.25/7   2.75         15.50    0.0            0     0;...
        3  1.50     1.50/7   1.50         12.70    1.50           0     0;...
        4 0 10 20 30  50 60 90;...
        5 1 0.9 0.8 0.7 0.6 0.5 0.4];

BASE.shad{2}=[
    4 20       30         40 		50  		60 		70 		80		;...
        5 787/789 784/789 775/789 754/789 	700/789 	563/789	302/789];

% Changing below '0' into '1' below, gives a drawing of the
% obstacle geometry for ShaID.
if 1==0 
    shaID=1;
    figure(1)
    shaddrawf1101(BASE.shad,shaID);
end

% ------------------------------------------------------------------------------
% A building is an assembly of different construction components. The input here
% is about the seize, place in the building and ID of these different components
% (for convenience called walls and windows i.e. also if doors, floors or roofs are meant).
% They are divided into 5 groups:
% I.   Constructions separating a zone from the exterior climate: EXTERNAL WALLS
% II.  Windows in external walls I
% III. Constructions separating a zone from an environment with a constant
%   temperature e.g. the ground: CONSTANT TEMPERATURE WALLS
% IV.  Constructions separating a zone from an environment with the same
%   conditions: ADIABATIC EXTERNAL WALLS 
% V.   Constructions between and in zones: INTERNAL WALLS
% For external walls and constant temperature walls the heat loss by thermal
% bridges can be accounted for if the extra steady state heat loss in Watt per 1K
% temperature difference across these bridges is known. These values can be
% obtained by thermal bridge software or a approximate methods. Use '0' if not
% known.
% -------------------------------------------------------------------------

% I. EXTERNAL WALLS
%
% For each wall ID-number exID=1,2,...
%
% FORMAT BASE.wallex{exID} = [zonenr,surf,conID,orID,bridge];
% zonenr 	= select zone number from ZONES section
% surf 		= total surface area[m2] including the windows surface area.
% conID	= select construction ID-number from CONSTRUCTION section.
% orID	= select orientation ID-number from ORIENTATIONS section
% bridge= the heat loss in W/K of the thermal bridges (choose 0 if unknown)

%BASE.wallex{exID}= 	[zonenr, surf, conID,	orID, 	bridge]
BASE.wallex{1} = 		[1,      27.0,    1,   		4,    0];  
BASE.wallex{2} = 		[2,      54.0,    6,   		5,    0];  		
BASE.wallex{3} = 		[3,      54.0,    6,   		5,    0]; 
BASE.wallex{4} = 		[4,      54.0,    6,   		5,    0];


% II. WINDOWS IN EXTERNAL WALLS
%
% Each external wall can have one or more windows. The surface area is the area
% of the transparent part. If the surface is curved the effective area for solar
% radiation is needed. The U-value must be increased in such a way that the
% heat loss per 1K temperature difference equals the one for the curved glazing,
% e.g. a glazed dome in a flat roof has an orientation with tilt=0, surface
% area=pi*r^2 and U-value=Uglazing*2*pi*r^2/pi*r^2.
% If a wall has 100% glazing use an EXTERNAL WALL that is slightly larger than
% the window area. Each window gets an ID-number winID=1,2,...
%
% FORMAT window{winID} = [exID, surf,glaID, shaID];
% exID 	= select external construction ID-number from CONSTRUCTIONS section
% surf   = surface area of the glazing [m2]
% glaID  = select glass ID-number from GLAZING section
% shaID  = select ID-number of shadow from SHADOW section, no shadow: shaID=0

%BASE.window{winID}= [exID,    surf,	glaID,   shaID]
BASE.window{1} = 		[1,     		8,  		1,        0];  
BASE.window{2} = 		[2,     		3.2,  	2,        0];   
BASE.window{3} = 		[3,     		4.8,  	3,        0];  
BASE.window{4} = 		[4,     		3.2,  	3,        0]; 

% III. CONSTANT TEMPERATURE WALLS
%
%  Each constant temperature wall gets an ID: i0ID=1,2,...
%
% FORMAT walli0{i0ID} = [zonenr, surf, conID ,temp];
% zonenr 	= select zone number from ZONES section
% surf 		= total surface area [m2]
% conID 	= select construction ID-number from CONSTRUCTION section.
% temp 		= constant temperature [oC],e.g ground = '10' 
% bridge   = the heat loss in W/K of the thermal bridges (0 if unknown)

%BASE.walli0{i0ID}= 	[zonenr, surf,   conID,			temp,    bridge]
BASE.walli0{1} = 		[1,     20.5,  	7,     		10.0,        0];
BASE.walli0{2} = 		[1,     20.5,  	7,     		10.0,        0];

% IV ADIABATIC EXTERNAL WALLS
%
% Each adiabatic wall gets an ID: iaID=1,2,... 
%
% FORMAT wallia{iaID} = [zonenr,surf,conID];
% zonenr 	= select zone number from ZONES section
% surf 		= total surface area in m2
% conID = select construction ID-number from CONSTRUCTION section.  

%BASE.wallia{iaID}= 	[zonenr, surf,		conID]
BASE.wallia{1} = 		[1,      23.0, 	2   ]; 
BASE.wallia{2} = 		[1,      14.6, 	2   ]; 
BASE.wallia{3} = 		[1,      14.6, 	2   ]; 
BASE.wallia{4} = 		[1,      54.0, 	9   ]; 
BASE.wallia{5} = 		[1,      4.0,  	12  ]; 

% V. INTERNAL WALLS BETWEEN AND IN ZONES
%
% Also here all different internal walls get an ID-number: inID. 
% If there are 3 different walls (or floors) between zonenr1 and zonenr2, the
% input is BASE.wallin{1}=[1,2,...  t/m BASE.wallin{3}=[1,2,.... If the 4th
% construction is completely in zonenr2 the input is consequently:
% BASE.wallin{4}=[2,2,... The first layer (Ri) of the construction component is
% in the zone that comes first. If instead BASE.wallin{3}=[2,1,.... is used the
% construction is reversed and Ri is in zonenr2. The surface area is the surface
% area of one side of the wall also for walls that are completely in the same
% zone.
%
% FORMAT wallin{inID} = [zonenr1,zonenr2,surf,conID];
% zonenr1 	= select zone number from ZONES section
% zonenr2 	= select zone number from ZONES section
% surf 		= total surface area [m2]
% conID 	= select construction number from CONSTRUCTION section.  

%BASE.wallin{inID}= 	[zonenr1,	zonenr2,	surf,		conID	]
BASE.wallin{1} = 		[1, 		   1,       7,  		4   ];
BASE.wallin{2} = 		[1,		   2,       35,      9   ];
BASE.wallin{3} = 		[1,		   2,       6,       9   ];


%-------------------------------------------------------------------------- --
% PART 3 : profiles for internal sources, ventilation, sunblinds and free
% cooling
% ------------------------------------------------------------------------- ---
%
%
% **PROFILES**
%
% Profiles are related to the use of a zone: office, living room, school etc
% Each day of a week can have a different profile e.g. weekends are different.
% Here the profiles are defined and given an ID-number; proID.
% For each day up to 24 different periods can be defined with different data. period1:
% start time = hrnr1 and end time = hrnr2; period2: start time = hrnr2 and end
% time = hrnr3; last period: the hours that are left on the same day. 
% for example [1,8,18] means period1: 1h till 8h, period2: 8h till 18h, period 3:
% 24h(==0h) till 1h and 18h till 24h. (3 periods are often used).
% The inserted hours are the clock time. 
% The profile allows for free cooling i.e. above a certain threshold Tfc (oC)
% the ventilation is increased from vvmin to vvmax: e.g. vvmax=3*vvmin. So if
% vvmin=vvmax there is no free cooling. The temperature Tfc is also used for the
% control of blinds: if the solar irradiance on the window is higher than Ers
% and the indoor temperature higher than Tfc the blinds will be down. This means
% that if there is no free cooling the temperature Tfc is still necessary for
% the control of blinds. Ers is the same for all zones. A number often
% encountered for Ers is 300W/m2.
%
% BASE.Ers{proID}     = irradiance level for sun blinds [W/m2]
% BASE.dayper{proID} = [hrnr1,hrnr2,hrnr3], the starting time of a new period
% BASE.vvmin{proID} = [.  .  . ], the ventilation ACR [1/hr], for each period
% BASE.vvmax{proID}	= [.  .  . ], the ventilation ACR [1/hr] in case free cooling
% BASE.Tfc{proID}  	= [.  .  . ], treshold [oC] for free cooling, for each period
% BASE.Tsetmin{proID}= [.  .  . ], setpoint [oC] switch for heating, (in case of
%   no heating choose -100)
% BASE.Tsetmax{proID} = [.  .  . ], setpoint [oC] switch for cooling, (in case
%   of no cooling choose  100)
% BASE.Qint{proID} 	= [.  .  . ], internal heat gains [W]
% BASE.Gint{proID} 	= [.  .  . ], moisture gains [kg/s]
% BASE.RVmin{proID}	= [.  .  . ], setpoint [%] switch for humidification,(in case of no
%   humidifcation choose -1)
% BASE.RVmax{proID}	= [.  .  . ], setpoint [%] switch for dehumidification,(in case
%   of no dehumidifcation choose 101)

% proID=1 Comfort due to people 
BASE.Ers{1} =300;
BASE.dayper{1}=	    [   0,  		8,	   	18 	];
BASE.vvmin{1}=		[	1, 		1, 		1		]; 
BASE.vvmax{1}=		[	1, 		1, 		1		];
BASE.Tfc{1}=		[	100, 	100,     100	];
BASE.Qint{1}=		[	0, 		185,		0	];
BASE.Gint{1}=		[	0, 		5.5e-6,	0		];
BASE.Tsetmin{1}=	[   16,  20,    16	];
BASE.Tsetmax{1}=	[   100,    100,     100	]; 
BASE.RVmin{1}=		[	-1,		-1,		-1  	];
BASE.RVmax{1}=		[	100,	100,	100		];

%proID=2 ASHRAE climate class B due to objects
BASE.Ers{2}=300;
BASE.dayper{2}= 	[   0, 		8,		18 	];
BASE.vvmin{2}=		[	1, 		1, 		1	]; 
BASE.vvmax{2}=		[	1, 		1, 		1	];
BASE.Tfc{2}=		[	100, 	100, 	100	];
BASE.Qint{2}=		[	0, 		184.5,	0	];
BASE.Gint{2}=		[	0, 		5.5e-6, 0	];
BASE.Tsetmin{2}=	[   20,  20,    20];
BASE.Tsetmax{2}=	[   25,    25,     25]; 
BASE.RVmin{2}=		[	40,		40,		40	];
BASE.RVmax{2}=		[	60,	60,	60 ];


%proID=3 Free floating
BASE.Ers{3}=2000;
BASE.dayper{3}=	    [   0,	    8,		    18  ];
BASE.vvmin{3}=		[	0.5, 	0.5, 	   	 0.5]; 
BASE.vvmax{3}=		[	1.6, 	1.6, 	    1.6	];
BASE.Tfc{3}=		[	100, 	100, 	   	 100];
BASE.Qint{3}=		[	222,	222,	   	222	];
BASE.Gint{3}=		[1.3e-5, 	1.3e-5,    1.3e-5];
BASE.Tsetmin{3}=	[   -100,  -100,        -100];
BASE.Tsetmax{3}=	[   100,    100,        100]; 
BASE.RVmin{3}=		[	-1,		-1,		    -1];
BASE.RVmax{3}=		[	100,	100,	   	 100];


% THE PROFILES OF THE BUILDING
%
% FORMAT BASE.weekfun{zonenr} = [upnrmon, upnrtue, upnrwed, upnrthu, upnrfri,
% upnrsat, upnrsun]
% for each zone n=1.. number of zones,  select profiles ID-numbers for each
% day
% upnrmon = select profile ID-numbers for Monday from PROFILES
% upnrtue = select profile ID-numbers for Tuesday from PROFILES
% upnrwed = select profile ID-numbers for Wednesday from PROFILES
% upnrthu = select profile ID-numbers for Thursday from PROFILES
% upnrfri = select profile ID-numbers for Friday from PROFILES
% upnrsat = select profile ID-numbers for Saturday from PROFILES
% upnrsun = select profile ID-numbers for Sunday from PROFILES
%
% BASE.weekfun{zonenr} =[upnrmon,	upnrtue,	upnrwed,	upnrthu, upnrfri, upnrsat,	upnrsun]
BASE.weekfun{1}=			[1, 		1, 		1, 		    1, 		    1, 		    1, 		    1];
BASE.weekfun{2}=			[2, 		2, 		2, 		    2, 		    2, 		    2, 		    2];
BASE.weekfun{3}=			[3, 		3, 		3, 		    3, 		    3, 		    3, 		    3];
BASE.weekfun{4}=			[3, 		3, 		3, 		    3, 		    3, 		    3, 		    3];

%-------------------------------------------------------------------------- --
% PART 4 : Heating, cooling, humidification, dehumidification 
% ------------------------------------------------------------------------- ---

% If the maximum heating capacity is known then that value can be used. If it is
% unknown  the value '-1' means an infinite capacity. The value '-2' can be used
% for a reasonable estimate of the maximum heating capacity. Cooling and dehumification 
% are negative! If there is no cooling the dehumidification capacity is '0'.
% For each zone : 
%
% FORMAT BASE.Plant{zonenr}=[heating capacity [W], cooling capacity [W],
%  humidification capacity [kg/s],dehumidification capacity [kg/s]];

BASE.Plant{1}=[2000,-2000,0.001,-0.001];
BASE.Plant{2}=[2000,-2000,0.001,-0.001];
BASE.Plant{3}=[0,0,0,0];
BASE.Plant{4}=[2000,-2000,0.001,-0.001];

% The simulation program treats radiant heat and convective heat differently.
% For each zone:
%
% FORMAT BASE.convfac{zonenr}=[CFh, CFset, CFint ];
% CFh =Convection factor of the heating system: air heating CFh=1, 
%       radiators CFh=0.8 floor heating CFh=0.5, cooling usually CFh=1
% CFset= Factor that determines whether the temperature control is on the air
% temperature (CFset=1), or comforttemperature (CFset=0.6),Tset=CFset*Ta+(1-CFset)*Tr
%   
% CFint= is the convection factor of the casual gains (usually CFint=0.5)

BASE.convfac{1}=[0.8, 1, 0.5 ];
BASE.convfac{2}=[0.8, 1, 0.5 ];
BASE.convfac{3}=[0.8, 1, 0.5 ];
BASE.convfac{4}=[0.8, 1, 0.5 ];

% If a heat recovery from ventilation air is used the effective temperature
% efficiency 'etaww' and the maximum indoor air temperature 'Twws' above which
% the  heat exchanger will be by-passed must be known. In summer with cooling
% conditions this temperature is used to switch the exchanger on, e.g Twws=22oC 
%
% FORMAT BASE.heatexch{zonenr}=[etaww, Twws];

BASE.heatexch{1}=[0 22];
BASE.heatexch{2}=[0 22];
BASE.heatexch{3}=[0 22];
BASE.heatexch{4}=[0 22];

% Real rooms are furnished. Furnishings are important for moisture storage.
% Moisture is released dependent on the change in relative humidity. Especially
% in zones with a lot of paper or textiles this can easily outweigh the moisture
% storage of the building. A value of '1' means that about the same amount is
% stored as in the air that fills the volume of the zone. The heat storage of
% furnishings is less important but by absorbing solar radiation and releasing
% that directly to the indoor air more solar energy is released in a convective
% way. A value for the convective fraction of 0.2 can be considered as
% reasonable.  For each zone:
%
% FORMAT BASE.furnishings{zonenr}=[fbv, CFfbi];
% fbv = Moisture storage factor
% CFfbi= The convection factor for the solar radiation due to furnishings.

BASE.furnishings{1}=[1, 0.2];
BASE.furnishings{2}=[1, 0.2];
BASE.furnishings{3}=[1, 0.2];
BASE.furnishings{4}=[1, 0.2];

%******************* END OF INPUT***************************************************
%
% This input is now completely stored in the structured array BASE. By typing
% BASE in the command window, the input can be checked and changed.
%
% In Hambasefun input is changed to an input the simulation program WAVO needs.

[Control,Profiles,InClimate,InBuil]=Hambasefun4(BASE);

% The advanced user can modify the files InClimate, InBuil,Profiles, Control
% (type help_wavooutput2)

Output=Wavox1205(Control,Profiles,InClimate,InBuil);

% Output contains all calculated data. Weather data are in InClimate. With
% these file the program wavooutput makes some plots. Type 'hamlabmollier' to
% see the explanation of the content.

hamlabmollier2(BASE,Output,1,'Example 2 zone 1','example2_zone1','comfort',1)
hamlabmollier2(BASE,Output,2,'Example 2 zone 2','example2_zone2','ashraeb',1)
hamlabmollier2(BASE,Output,3,'Example 2 zone 3','example2_zone3','ashraec',1)


