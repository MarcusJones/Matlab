
function matprop = matpropf41(l,matnr);
% The function returns for a given thickness of a layer in a building construction
% and a layer indentification number the hygrothermal properties of the layer(s)
%
% matprop = matpropf(l,matnr);
%
% l     = thickness (meter)
% matnr = number of the material (see below)
% matprop = [thickness,heat conductivity,density,heat capacity,emmissivity,diffusion resistance
%    factor,vapour capacity*10^7] or [l,lambda,rho,C,eps,mu,ksi,bv.10^7].In case of an air cavity
% (matnr=2 or 3 or 4) the heat conductivity is calculated with lambda=thickness/Rcav 
%
% If l and matnr are vectors the function returns a matrix. Each row of the matrix 
% corresponds with a layer. 
%  
% Example
%  l = [0.1,0.5,0.4];
%  matnr = [205,301,501];
%  matprop = matpropf(l,matnr)
%  matprop =
%    1.0e+003 *
%    0.0001  0.0006  1.3000  0.8400  0.0009  0.0075  0.0020  0.0015
%    0.0005  0.0001  0.5000  0.8400  0.0009  0.0050  0.0300  0.0072
%    0.0004  0.0002  0.8000  1.8800  0.0009  0.0300  0.0400  0.0034
%
% Literature
% NOV = Novem, BDA=Bureau Dakadvies, BFT=BouwFysisch Tabellarium,
% SBR = Stichting Bouw Research, ISSO=Instituut voor Studie en Stimulering van
%     Onderzoek op het gebied van gebouwinstallaties
%
% Author: Martin de Wit 13-Apr-1998
%
% Categorie
%
%100 Metalen
%200 Natuursteen
%230 Metselwerk
%260 Tegels
%300 Beton
%360 Pleisterlagen						
%380 Andere anorganische materialen
%400 Isolatie (anorg)
%500 Houtprodukten
%540 Gebonden organ. mat. muv hout en kunststoffen
%580 Harde Kunststof
%450 Isolatie (organisch)
%600 Dak
%
% Materiaal				Lambda	Rho	C	Eps	Mu	Ksi	bv.10^7	bron	
%
%1	lucht				0.023	1.2	1000	0.9	1	0	0	BFT
%2 zwak geventileerde spouw Rcav=0.17	0.023	1.2	1000	0.9	1	0	0	
%3 goed geventileerde spouw Rcav=0.09	0.023	1.2	1000	0.9	1	0	0	
%4 plenum Rcav=0.15 m2K/W		0.023	1.2	1000	0.9	1	0	0	
%
%100 Metalen
%101	Lood         			35	11336	130	0.28	900000	0	0	SBR17	
%102	Koper   		 	370	9000	390	0.79	900000	0	0	SBR17	
%103	IJzer    			72	7900	530	0.9	900000	0	0	SBR17	
%104	Staal    			46	7800	500	0.68	900000	0	0	SBR17	
%105	Zink     			110	7180	390	0.6	900000	0	0	SBR17	
%106	Aluminium			200	2800	880	0.22	900000	0	0	SBR17	
%107	Staal beplating (gevel)		58	7800	505	0.9	1000	0	0	BDA	
%108	Staal (afgekit)			58	7800	505	0.9	20000	0	0	BDA	
%109	Staal (koppen dicht) 		58	7800	505	0.9	5000	0	0	BDA	
%110	Geperforeerd staaldak		58	4800	505	0.9	50	0	0	BDA	
%111	Alu. beplating (gevel)		200	2800	505	0.9	1000	0	0	BDA	
%112	Alu. (afgekit)			200	2800	505	0.9	20000	0	0	BDA	
%113	Alu (koppen dicht)		200	2800	505	0.9	5000	0	0	BDA	
%114	Alu. lamellenplaat(open)plafond 58	2800	505	0.9	1	0	0	BDA
%115	Aluminium			200	2800	880	0.22	200000000	0	0	annex41
%
%200 Natuursteen
%201	Kalksteen			2.3	2750	840	0.9	29	2	0.8	SBR17	
%202	Hardsteen			2.9	2750	840	0.9	29	0	0	SBR17	
%203	Marmer				2.3	2750	840	0.9	29	0	0	SBR17	
%204	Basalt				3.5	3000	840	0.9	100	2	0.4	SBR17	
%205	Tufsteen			0.6	1300	840	0.9	7.5	2	1.5	SBR17	
%206	Graniet				3.5	3000	840	0.9	100	0	0	SBR17	
%207	Zandsteen			5	2150	840	0.9	15	0	0	SBR17	
%208	Lavasteen			1.3	2300	840	0.9	19	10	2.1	ESP	
%
%230 Metselwerk
%231	Isolatiesteen			0.3	1000	840	0.9	20	10	2.1	SBR17	
%232	gevelklinker			1.3	2100	840	0.9	28	6	1.4	BDA	
%233	Hardgrauw			1.04	1900	840	0.9	24	6	1.5	BDA	
%234	Rood				0.6	1500	840	0.9	10	4	1.9	BDA	
%235	Kalkzandsteen			1.2	2000	840	0.9	15	37	4.6	BDA	
%236	Poriso				0.53	1200	840	0.9	8	60	8.1	BDA	
%237	Holle baksteenvloer		0.66	2000	840	0.9	7	10	3.5	BDA
%238	baksteen		0.6	1650	850	0.9	9.5	9 3.5	annex41	
%239	Kalkzandsteen			1	1900	850	0.9	28	25	4.6	annex41										
%
%260 Tegels
%261	Hardgebakken tegels		1.2	2000	840	0.9	28	8	1.6	SBR17	
%262	Plavuizen			0.8	1700	840	0.9	23	8	1.7	SBR17	
%
%300 Beton
%301	Isolatiebeton			0.1	500	840	0.9	5	30	7.2	SBR17	
%302	lichte toeslagstof bijv.	0.26	800	840	0.9	6	8	3.4	SBR17	
%303	(idem)    geëxp. klei ed	0.6	1400	840	0.9	9	8	2.8	SBR17	
%304	Polystyreenschuimbeton		0.07	220	840	0.9	18	40	4.4	SBR17	
%305	Polystyreenschuimbeton		0.11	400	840	0.9	18	40	4.4	SBR17	
%306	Polystyreenschuimbeton		0.2	650	840	0.9	18	25	3.5	SBR17	
%307	Hoogovenslakkenbeton		0.7	1900	840	0.9	14	40	5.0	SBR17	
%308	Hoogovenslakkenbeton		0.45	1600	840	0.9	10	40	5.9	SBR17	
%309	hoogovenslakkenbeton		0.3	1300	840	0.9	8	40	6.6	SBR17	
%310	Hoogovenslakkenbeton		0.23	1000	840	0.9	6.5	40	7.3	SBR17	
%311	Grindbeton			1.86	2500	840	0.9	30	40	3.4	BDA	
%312	Grindbeton			1.7	2400	840	0.9	30	40	3.4	BDA	
%313	Grindbeton			1.4	2300	840	0.9	25	40	3.7	BDA
%314	Grindbeton ongewapend		1.3	2200	840	0.9	30	85	4.9	SBR17
%315	Cassetteplaat			1.86	2500	840	0.9	20	40	4.2	BDA
%316	Kanalenvloer			1.4	2500	840	0.9	20	40	4.2	BDA
%317	Lichtbeton			1.04	1900	840	0.9	14	71	6.6	BDA
%318	Lichtbeton			0.78	1600	840	0.9	8	98	10.3	BDA
%319	Lichtbeton			0.55	1300	840	0.9	7	50	7.9	BDA
%320	Lichtbeton			0.38	1000	840	0.9	6	50	8.5	BDA
%321	Lichtbeton			0.26	700	840	0.9	5	37	8.0	BDA
%322	Lichtbeton			0.2	500	840	0.9	4	50	10.4	BDA
%323	Lichtbeton			0.15	300	840	0.9	3.5	75	13.6	BDA
%324	Lichtbeton			0.14	200	840	0.9	3	100	17.0	BDA
%325	Lichbeton cassetteplaat		0.78	1600	860	0.9	8	98	10.3	BDA
%326	Cellenbeton			0.12	400	840	0.9	6	29	6.5	BDA
%327	Cellenbeton			0.14	500	840	0.9	6	20	5.4	BDA
%328	Cellenbeton			0.16	600	840	0.9	6	10	3.8	BDA
%329	Cellenbeton			0.19	700	840	0.9	6	5	2.7	BDA	
%330	Cellenbeton			0.22	700	840	0.9	6	5	2.7	BDA	
%331	cellenbeton op	cementbasis	0.21	600	840	0.9	5	10	4.2	SBR17	
%332	cellenbeton op	kalkbasis	0.21	600	840	0.9	5	5	2.9	SBR17	
%333	Gasbeton			0.24	700	840	0.9	6	5	2.7	BDA	
%334	Houtbeton			0.13	430	1470	0.9	5	50	9.3	BDA	
%335	Bimsbeton			0.42	1200	840	0.9	8	0.94	1.0	BDA	
%336	Bimsbeton			0.29	850	840	0.9	6	0.52	0.9	BDA	
%337	Argex				0.15	425	840	0.9	6	50	8.5	BDA	
%338	B2 blokken (gevel)		0.42	1200	840	0.9	8	50	7.4	BDA	
%339 	Cellenbeton tegels		0.24	700	840	0.9	6	50	8.5	BDA	
%340	Kanaal platen			0.13	700	840	0.9	5	50	9.3	BDA	
%341    beton screed    1.6  1950  850  0.9 75 38 6.6 annex41
%342    beton           1.6 2300 850 0.9 180 85 6.6 annex41
%343    concrete block  0.51 1400 1000 	0.9	8	50	7.4 annex41
%344    Concrete slab  1.13 1400 1000  0.9	14	71	6.6	annex41
%
%360 Pleisterlagen	
%361	Stuclaag			0.8	1900	840	0.9	14	20	3.5	BDA	
%362	Stuclaag (kalk)			0.8	1900	840	0.9	14	20	3.5	BDA	
%363	Stuclaag (gips)			0.6	1300	840	0.9	6	20	5.4	BDA	
%364	Steengaas			0.6	1200	840	0.9	6	20	5.4	BDA	
%365	Pleisterlaag (cement)		1.2	1900	840	0.9	14	20	3.5	BDA	
%366	Vezel spuitlaag (plafond)	0.1	300	840	0.9	10	20	4.2	BDA	
%367	Stuclaag (gips)			0.2	850	850	0.9	8.3	6.3	3.5	annex41
%368	Stuclaag (gips)			0.2	1721 850	0.9	13	1.8	3.5	annex41	
%369	minerale pleister		0.8	1900 850	0.9	25	45	3.5	annex41	
%370	pleister gips			0.2	850 850	0.9	9	6	3.5	annex41					
%
%380 Andere anorganische materialen	 
%381	Gipsplaat			0.6	1300	840	0.9	6	40	7.6	BDA	
%382	Asbestcement			0.95	1800	840	0.9	90	120	3.4	SBR17	
%383	Spiegelglas / vensterglas	0.8	2500	840	0.9	900000	0	0	SBR17	
%384	Glaskeramiek			1.4	2500	840	0.9	900000	0	0	SBR17	
%385	Gipsplaat			0.16	850	870	0.9	6	35	0	annex41	
%386	Gipsplaat			0.31	710	850	0.9	8	9.5	0	annex41	
%387    Plasterboard        0.16	950	840	0.9	6	35	0	annex41
%
%400 Isolatie (anorg)
%401	Glaswol (MWG)			0.038	110	840	0.9	3	1	1.7	BDA	
%402	Glaswoldeken			0.038	15	840	0.9	1.3	1	2.6	BDA	
%403	Glaswol				0.046	10	840	0.9	1.3	1	2.6	BFT	
%404	Glaswol				0.038	20	840	0.9	1.3	1	2.6	BFT	
%405	Glaswol				0.035	35	840	0.9	1.3	1	2.6	BFT	
%406	Glaswol				0.034	120	840	0.9	1.3	1	2.6	BFT	
%407	Steenwol (MWR)			0.038	160	840	0.9	1.5	1	2.4	BDA	
%408	Steenwol			0.045	15	840	0.9	1.5	1	2.4	BFT	
%409	Steenwol			0.039	30	840	0.9	1.5	1	2.4	BFT	
%410	Steenwol			0.037	50	840	0.9	1.5	1	2.4	BFT	
%411	Steenwol			0.037	100	840	0.9	1.5	1	2.4	BFT	
%412	Steenwol			0.041	200	840	0.9	1.5	1	2.4	BFT	
%413	Minerale wol geperst (plafond)	0.06	250	840	0.9	3	1	1.7	BDA	
%414	Minerale wol achteraf gevuld	0.045	80	840	0.9	1	1	2.9	ISSO6	
%415	Minerale toeslag van beton	0.23	800	840	0.9	10	1	0.9	SBR17	
%416	Perlite				0.061	240	840	0.9	1	5	6.6	ISSO	
%417	Gesiliconiseerde perliet	0.045	80	840	0.9	1	5	6.6	ISSO6	
%418	Vermiculite			0.06	100	840	0.9	1	5	6.6	NOV	
%419	Cellulair glas			0.042	120	840	0.9	900000	0	0	NOV	
%420	Cellulair glas (CG) (staaldak)	0.042	120	840	0.9	2000	0	0	BDA	
%421	Cellulair glas (CG) (beton)	0.042	120	840	0.9	40000	0	0	BDA	
%422    minerale wol    0.04 60 850 0.9 1.3 1 0 annex41
%423    Fiberglass quilt  0.04 12 840	0.9	1.3	1	2.6 annex41
%
%500 Houtprodukten
%501	Hardhout			0.17	800	1880	0.9	30	40	3.4	SBR17	
%502	Naaldhout			0.14	550	1880	0.9	16	80	6.6	SBR17	
%503	Hardboard 			0.29	1000	1680	0.91	60	80	3.4	SBR17	
%504	Balsa				0.14	125	1880	0.9	30	20	2.4	SBR17	
%505	Spaanderplaat			0.15	450	1880	0.9	10	33	5.3	BDA	
%506	Spaanderplaat			0.2	600	1880	0.9	12	40	5.4	BDA	
%507	Spaanderplaat			0.26	750	1880	0.9	15	40	4.8	BDA	
%508	Multiplex / triplex		0.2	600	1880	0.9	50	99	4.1	BDA	
%509	Triplex (spec. verlijmd)	0.2	600	1880	0.9	150	99	2.4	BDA	
%510	Houtwolcementplaat HWC		0.12	450	1470	0.9	6	40	7.6	BDA	
%511	Houtwolmagnesietplaat HWM	0.12	450	1470	0.9	6	60	9.3	BDA	
%512	Zachtboard (plafond)		0.12	275	2100	0.9	4	40	9.3	BDA	
%513	Schrooties 			0.16	550	1880	0.9	16	80	6.6	BDA	
%514	Schrootjes (open)		0.4	1	0	0.9	1	80	26.3	BDA	
%515	Schrootjes + firet		0.4	1	0	0.9	1	80	26.3	BDA	
%516    hout                    0.09  400 1500 0.9 200 60 6.6 annex41
%517    Wood siding     0.14 530 900    0.9	16	80	6.6 annex41
%518    Timber flooring   0.14 650 1200   0.9	16	80	6.6	annex41
%
%540 Gebonden organ. mat. muv hout en kunststoffen
%541	Linoleum			0.17	1200	1470	0.9	1800	0	0	SBR17	
%542	Rubber				0.23	1350	1470	0.9	900	0	0	SBR17	
%543 	geëxpandeerd eboniet		0.035	100	1470	0.9	700	10	0.4	SBR17	
%544	vlasschevenplaat. met kunsthars	0.013	500	1880	0.9	26	40	3.6	SBR17	
%545	vlasschevencementplaat		0.01	500	1470	0.9	5	20	5.9	SBR17	
%546	Vlasvezelplaat			0.13	300	2100	0.9	5	40	8.3	BDA	
%547	Vlasvezel kanaalplaten		0.13	360	1470	0.9	5	40	8.3	BDA	
%548	Dakbeschot			0.16	550	1470	0.9	16	40	4.6	BDA	
%549	Masonite			0.35	1000	1680	0.9	62	2	0.5	BDA	
%550	Rietplaat			0.05	160	1470	0.9	5	40	8.3	ISSO	
%551	Rietvezelplaat			0.1	300	2100	0.9	3	40	10.7	BDA	
%552	Strovezelplaat			0.09	400	1470	0.9	5	40	8.3	BDA	
%553	Stroleem			0.4	1000	1000	0.9	5	200	18.6	NOV	
%554	Kurk geexpandeerd		0.044	150	1760	0.9	6	24	5.9	BDA	
%555	richtwaarden	 		0.5	1600	1840	0.9	50	10	1.3	BFT	
%556	richtwaarden 			0.4	1300	1840	0.9	50	10	1.3	BFT	
%557	richtwaarden 			0.3	1000	1840	0.9	50	10	1.3	BFT	
%558	richtwaarden 			0.17	700	1880	0.9	50	10	1.3	BFT	
%559	richtwaarden 			0.12	500	1880	0.9	50	10	1.3	BFT	
%560	richtwaarden 			0.08	300	1880	0.9	50	10	1.3	BFT	
%561	richtwaarden 			0.07	200	2100	0.9	50	10	1.3	BFT	
%562	richtwaarden 			0.06	100	2100	0.9	50	10	1.3	BFT	
%563	Linoleum			0.16	1000	1500	0.9	15000	1	0	annex41	
%										
%580 Harde Kunststof
%581	Polyesterplaat
%		(glasvezelversterkt)	0.2	1200	1470	0.9	90000	0	0	SBR17	
%582	Polyetheen			0.2	935	1470	0.9	90000	0	0	SBR17	
%583	Polymethylacrylaat		0.2	1200	1470	0.9	90000	0	0	SBR17	
%584	Polypropeen			0.2	900	1470	0.9	90000	0	0	SBR17	
%585	Polyvinylchloride (PVC)		0.2	1400	1470	0.9	100	0	0	SBR17	
%586	ABS polymeren			0.2	1100	1470	0.9	90000	0	0	SBR17	
%
%450 Isolatie (organisch)
%451	Polyvinylchloride schuim PVC	0.035	40	1470	0.9	150	0	0	SBR17	
%452	Geëxpandeerd polystyreen, EPS15	0.038	15	1470	0.9	20	0	0	BDA	
%453	Geëxpandeerd polystyreen, EPS20	0.036	20	1470	0.9	30	0	0	BDA	
%454	Geëxpandeerd polystyreen, EPS25	0.036	25	1470	0.9	40	0	0	BDA	
%455	Geëxpandeerd polystyreen, EPS35	0.036	35	1470	0.9	80	0	0	BDA	
%456	Geëxpandeerd polystyreen, EPS40	0.036	35	1470	0.9	90	0	0	BDA	
%457	Polystyreenschuim geëxtrud.(XPS)0.03	35	1470	0.9	80	0	0	BDA	
%458	PHenolharsschuim PF (hard)	0.035	100	1470	0.9	3.7	0	0	SBR17	
%459	Resol/phenol (PF)		0.02	30	1470	0.9	40	0	0	BDA	
%460	Resol CFK			0.018	40	1470	0.9	40	0	0	NOV	
%461	Polyurethaan met CFK PUR	0.026	33	1470	0.9	60	0	0	NOV	
%462	Polyurethaan met HCFK		0.026	33	1470	0.9	60	0	0	NOV	
%463	Polyurethaan (H) CFK-vrij	0.026	33	1470	0.9	60	0	0	NOV	
%464	Polyurethaan ter plaatse
%		gespoten		0.035	33	1470	0.9	2	0	0	NOV	
%465	Polyisocyanaatschuim PIR	0.026	33	1470	0.9	60	0	0	NOV	
%466	Achteraf geschuimde spouw	0.054	60	1470	0.9	2	0	0	BFT	
%467	Ureumformaldehydeschuim UF	0.05	10	1470	0.9	2	0	0	ISSO6	
%468	PS kanaalplaat			0.08	245	1470	0.9	5	0	0	BDA	
%469	Geëxpandeerd perliet (EPB)	0.05	150	840	0.9	6	0	0	BDA	
%470	Gebitum. perliet (BEP)		0.056	190	1000	0.9	7	0	0	BDA
%471	C-EPS (mortel)			0.1	300	840	0.9	9	0	0.0	BDA
%472	Cellulose isolatie		0.048	35	1880	0.9	1.5	7	6.4	IEA24
%473    polystyreen         0.04 30 1500 0.9 50 0 0 annex41
%474    Insulation          0.04    20  0    0.9     50  0 0 annex41
%475    Foam insulation     0.04 10 1400 0.9 50 0 0  annex41
%
%600 Dak
%601	PVC-dakbaan			0.17	1300	1470	0.9	10000	0	0	BDA
%602	Dakbedekking,PVC-dakbaan
%		(bit. best.)		0.17	1300	1470	0.9	8000	0	0	BDA
%603	Dampremmende Lagen,PEC
%		(CPE)-dakbaan		0.17	1530	1470	0.9	100000	0	0	BDA
%604	Afschotlaag	PlB-dakbaan	0.17	1600	1470	0.9	100000	0	0	BDA
%605	Dakafwerking,EPDM-dakbaan	0.17	1180	1470	0.9	70000	0	0	BDA
%606	CSM - dakbaan			0.17	1400	1470	0.9	40000	0	0	BDA
%607	CR-dakbaan			0.17	1500	1470	0.9	40000	0	0	BDA
%608	ECB-dakbaan			0.17	1000	1470	0.9	40000	0	0	BDA
%609	IIR dakbaan			0.17	1300	1470	0.9	100000	0	0	BDA
%610	PVF-dakbaan			0.17	1100	1470	0.9	20000	0	0	BDA
%611	PEH-dakbaan			0.17	1300	1470	0.9	100000	0	0	BDA
%612	E/VAC-dakbaan			0.17	1300	1470	0.9	10000	0	0	BDA
%613	Gebitum. glasvlies		0.2	1050	1470	0.9	10000	0	0	BDA
%614	Gebitum. polyestermat		0.2	1050	1470	0.9	10000	0	0	BDA
%615	Gemod gebit. pol.		0.2	1050	1470	0.9	20000	0	0	BDA
%616	Bestaande dakbedekking		0.2	1050	1470	0.9	I 0000	0	0	BDA
%617	Bezand teervilt			0.2	700	1470	0.9	5000	0	0	BDA
%618	Cacheerlaag gebit glasvlies	0.2	1050	1470	0.9	1000	0	0	BDA
%619	Alufolie(tape) cacheerlaag	200	2800	880	0.9	70000	0	0	BDA
%620	Alufolie cacheerlaag		200	2800	880	0.9	3000	0	0	BDA
%621	PVC-folie(tape)			0.17	750	1470	0.9	5000	0	0	BDA
%622	PE-folie (tape)			0.17	750	1470	0.9	65000	0	0	BDA
%623	Gebitum. alu.-folie		200	2800	880	0.9	700000	0	0	BDA
%624	Shingles			0.2	1200	1470	0.9	500	0	0	BDA
%625	Gespoten bitumenlatex		0.2	1050	1470	0.9	20000	0	0	BDA
%626	Glasvezelverst. pol.		0.17	1200	1470	0.9	10000	0	0	BDA
%627	Dakpannen beton			1.5	2100	840	0.9	20	0	0	BDA
%628	Keramische pannen		1.28	2100	840	0.9	28	0	0	BDA
%629	Geglazuurde pannen		1.28	2100	840	0.9	28	0	0	BDA
%630	Vezelcement			0.37	1750	840	0.9	45	0	0	BDA
%631	Golfplaten			0.37	1750	840	0.9	25	0	0	BDA
%632	Vezelcement leien		0.37	1750	840	0.9	25	0	0	BDA
%633	Rietbedekking			0.11	300	2100	0.9	3	0	0	BDA
%634	Vegetatiedek/gras		0.11	500	2100	0.9	3	0	0	BDA
%635	Afschotlaag (zand/cem.)		1.5	2000	840	0.9	10	0	0	BDA
%636	Afwerklaag (zand/cem.)		1.5	2000	840	0.9	10	0	0	BDA
%637	Afschotlaag (licht)		0.25	800	840	0.9	6	0	0	BDA
%638	Grof Grind			3.5	1650	840	0.9	2	0	0	BDA
%639	Betontegels			1.86	2500	840	0.9	20	0	0	BDA
%640	Drainata tegels			0.5	300	840	0.9	1	0	0	BDA
%641	Olasfa vloer			0.5	300	840	0.9	1	0	0	BDA
%642	Asbestcement tegels		0.9	1750	840	0.9	25	0	0	BDA
%643	Zand				3	1650	840	0.9	2.5	0	0	BDA
%644	Gietasfalt			0.2	2200	1470	0.9	2000	0	0	BDA
%645	Vezelrubber			0.13	900	1470	0.9	150	0	0	BDA	
%646    Soil           1.3 1500 800 0.9	2.5	0	0 annex41
%					Lam	Rho	C	Eps	Mu	Ksi	bv.10^7	
%
% overgangsweerstanden/overdrachtscoëfficiënten
% totale overdrachtscoëfficiënt binnen hrcv=7.5 m2K/W (of 8=1/0.13)
% bij vloeren (binnen) met warmtestroom naar beneden hrcv=6 m2K/W(=1/0.17)
% convectieve overdrachtscoëfficiënt binnen hcv=2.5 W/m2K 
% totale overdrachtscoëfficiënt buiten he=23 W/m2K (of 25=1/0.04)

materiaal=zeros(700,7);
%	Lam	Rho	C	Eps	Mu	Ksi	bv.10^7	
materiaal(1:4,:)=[
	0.023	1.2	1000	0.9	1	0	0;
	0.023	1.2	1000	0.9	1	0	0;	
	0.023	1.2	1000	0.9	1	0	0;	
	0.023	1.2	1000	0.9	1	0	0];

materiaal(101:115,:)=[
   35	  11336	130	0.28	900000	0	0;	
   370  9000	390	0.79	900000	0	0;	
   72	  7900	530	0.9	900000	0	0;	
   46	  7800	500	0.68	900000	0	0;
   110  7180	390	0.6	900000	0	0;	
   200  2800	880	0.22	900000	0	0;	
   58	  7800	505	0.9	1000  	0	0;	
   58	  7800	505	0.9	20000	   0	0;
   58	  7800	505	0.9	5000	   0	0;	
   58	  4800	505	0.9	50	      0	0;	
   200  2800	505	0.9	1000	   0	0;	
   200  2800	505	0.9	20000	   0	0;	
   200  2800	505	0.9	5000	   0	0;	
   58	  2800	505	0.9	1	      0	0;	
  200	2800	880	0.22	200000000	0	0];

materiaal(201:208,:)=[
   2.3  2750	840	0.9	29	     2 0.8;
   2.9  2750	840	0.9	29	     0   0;
   2.3  2750	840	0.9	29	     0	0;
   3.5  3000	840	0.9	100     2 0.4;	
   0.6  1300	840	0.9	7.5	  2 1.5;	
   3.5  3000	840	0.9	100	  0	0;	
   5	  2150	840	0.9	15	     0	0;	
   1.3  2300	840	0.9	19	     10 2.1]; 	

materiaal(231:239,:)=[
   0.3	1000	840	0.9	20	10	2.1;	
   1.3	2100	840	0.9	28	6	1.4;	
   1.04	1900	840	0.9	24	6	1.5;	
   0.6	1500	840	0.9	10	4	1.9;	
   1.2	2000	840	0.9	15	37	4.6;	
   0.53	1200	840	0.9	8	60	8.1;	
   0.66	2000	840	0.9	7	10	3.5; 	
   0.6	1650	850	0.9	9.5	9 3.5;	
   1 1900	850	0.9	28	25	4.6 ];		

materiaal(261:262,:)=[
   1.2	2000	840	0.9	28	8	1.6;	
   0.8	1700	840	0.9	23	8	1.7];	

materiaal(301:344,:)=[
   0.1	500	840	0.9	5	30	7.2;
   0.26	800	840	0.9	6	8	3.4;	
   0.6	1400	840	0.9	9	8	2.8;	
   0.07	220	840	0.9	18	40	4.4;	
   0.11	400	840	0.9	18	40	4.4;	
   0.2	650	840	0.9	18	25	3.5;	
   0.7	1900	840	0.9	14	40	5.0;	
   0.45	1600	840	0.9	10	40	5.9;	
   0.3	1300	840	0.9	8	40	6.6;	
   0.23	1000	840	0.9	6.5	40	7.3;	
   1.86	2500	840	0.9	30	40	3.4;	
   1.7	2400	840	0.9	30	40	3.4;	
   1.4	2300	840	0.9	25	40	3.7;
   1.3	2200	840	0.9	30	85	4.9;
   1.86	2500	840	0.9	20	40	4.2;
   1.4	2500	840	0.9	20	40	4.2;
   1.04	1900	840	0.9	14	71	6.6;
   0.78	1600	840	0.9	8	98	10.3;
   0.55	1300	840	0.9	7	50	7.9;
   0.38	1000	840	0.9	6	50	8.5;
   0.26	700	840	0.9	5	37	8.0;
   0.2	500	840	0.9	4	50	10.4;
   0.15	300	840	0.9	3.5	75	13.6;
   0.14	200	840	0.9	3	100	17.0;
   0.78	1600	860	0.9	8	98	10.3;
   0.12	400	840	0.9	6	29	6.5;
   0.14	500	840	0.9	6	20	5.4;
   0.16	600	840	0.9	6	10	3.8;
   0.19	700	840	0.9	6	5	2.7;	
   0.22	700	840	0.9	6	5	2.7;	
   0.21	600	840	0.9	5	10	4.2;	
   0.21	600	840	0.9	5	5	2.9;	
   0.24	700	840	0.9	6	5	2.7;	
   0.13	430	1470	0.9	5	50	9.3;	
   0.42	1200	840	0.9	8	0.94	1.0;	
   0.29	850	840	0.9	6	0.52	0.9;	
   0.15	425	840	0.9	6	50	8.5;	
   0.42	1200	840	0.9	8	50	7.4;	
   0.24	700	840	0.9	6	50	8.5;	
   0.13	700	840	0.9	5	50	9.3;
   1.6  1950  850  0.9 75 38 6.6;
   1.6 2300 850 0.9 180 85 6.6;
   0.51 1400 1000 	0.9	8	50	7.4;
   1.13 1400 1000  0.9	14	71 6.6];

materiaal(361:370,:)=[
   0.8	1900	840	0.9	14	20	3.5;	
   0.8	1900	840	0.9	14	20	3.5;	
   0.6	1300	840	0.9	6	20	5.4;	
   0.6	1200	840	0.9	6	20	5.4;	
   1.2	1900	840	0.9	14	20	3.5;	
   0.1	300	    840	0.9	10	20	4.2;
   0.2	850	850	0.9	8.3	6.3	3.5	;
   0.2	1721 850	0.9	13	1.8	3.5;
   0.8	1900 850	0.9	25	45	3.5;
   0.2	850 850	0.9	9	6	3.5];
  
			
%
materiaal(381:387,:)=[
   0.6	1300	840	0.9	6	40	7.6;	
   0.95	1800	840	0.9	90	120	3.4;	
   0.8	2500	840	0.9	900000	0	0;	
   1.4	2500	840	0.9	900000	0	0;
   0.16	850	870	0.9	6	35	0;
   0.31	710	850	0.9	8	9.5	0;	
   0.16	950	840	0.9	6	35	0];
   
materiaal(401:423,:)=[
   0.038	110	840	0.9	3	1	1.7;	
   0.038	15	840	0.9	1.3	1	2.6;	
   0.046	10	840	0.9	1.3	1	2.6;	
   0.038	20	840	0.9	1.3	1	2.6;	
   0.035	35	840	0.9	1.3	1	2.6;	
   0.034	120	840	0.9	1.3	1	2.6;	
   0.038	160	840	0.9	1.5	1	2.4;	
   0.045	15	840	0.9	1.5	1	2.4;	
   0.039	30	840	0.9	1.5	1	2.4;	
   0.037	50	840	0.9	1.5	1	2.4;	
   0.037	100	840	0.9	1.5	1	2.4;	
   0.041	200	840	0.9	1.5	1	2.4;	
   0.06	250	840	0.9	3	1	1.7;	
   0.045	80	840	0.9	1	1	2.9;	
   0.23	800	840	0.9	10	1	0.9;	
   0.061	240	840	0.9	1	5	6.6;	
   0.045	80	840	0.9	1	5	6.6;	
   0.06	100	840	0.9	1	5	6.6;	
   0.042	120	840	0.9	900000	0	0;	
   0.042	120	840	0.9	2000	0	0;	
   0.042	120	840	0.9	40000	0	0;
   0.04 60 850 0.9 1.3 1 0 ;
   0.04 12 840	0.9	1.3	1	2.6];

materiaal(501:518,:)=[
   0.17	800	1880	0.9	30	40	3.4;	
   0.14	550	1880	0.9	16	80	6.6;	
   0.29	1000	1680	0.91	60	80	3.4;	
   0.14	125	1880	0.9	30	20	2.4;	
   0.15	450	1880	0.9	10	33	5.3;	
   0.2	600	1880	0.9	12	40	5.4;	
   0.26	750	1880	0.9	15	40	4.8;	
   0.2	600	1880	0.9	50	99	4.1;	
   0.2	600	1880	0.9	150	99	2.4;	
   0.12	450	1470	0.9	6	40	7.6;	
   0.12	450	1470	0.9	6	60	9.3;	
   0.12	275	2100	0.9	4	40	9.3;	
   0.16	550	1880	0.9	16	80	6.6;	
   0.4	1	0	0.9	1	80	26.3;	
   0.4	1	0	0.9	1	80	26.3;
   0.09  400 1500 0.9 200 60 6.6;
   0.14 530 900    0.9	16	80	6.6;
   0.14 650 1200   0.9	16	80	6.6];

materiaal(541:563,:)=[
   0.17	1200	1470	0.9	1800	0	0;	
   0.23	1350	1470	0.9	900	0	0;
   0.035	100	1470	0.9	700	10	0.4;	
   0.013	500	1880	0.9	26	40	3.6;	
   0.01	500	1470	0.9	5	20	5.9;	
   0.13	300	2100	0.9	5	40	8.3;	
   0.13	360	1470	0.9	5	40	8.3;	
   0.16	550	1470	0.9	16	40	4.6;	
   0.35	1000	1680	0.9	62	2	0.5;	
   0.05	160	1470	0.9	5	40	8.3;	
   0.1	300	2100	0.9	3	40	10.7;	
   0.09	400	1470	0.9	5	40	8.3;	
   0.4	1000	1000	0.9	5	200	18.6;	
   0.044	150	1760	0.9	6	24	5.9;	
   0.5	1600	1840	0.9	50	10	1.3;	
   0.4	1300	1840	0.9	50	10	1.3;	
   0.3	1000	1840	0.9	50	10	1.3;	
   0.17	700	1880	0.9	50	10	1.3;	
   0.12	500	1880	0.9	50	10	1.3;	
   0.08	300	1880	0.9	50	10	1.3;	
   0.07	200	2100	0.9	50	10	1.3;	
   0.06	100	2100	0.9	50	10	1.3;
   0.16	1000	1500	0.9	15000	0	0];

materiaal(581:586,:)=[
   0.2	1200	1470	0.9	90000	0	0;	
   0.2	935	1470	0.9	90000	0	0;	
   0.2	1200	1470	0.9	90000	0	0;	
   0.2	900	1470	0.9	90000	0	0;	
   0.2	1400	1470	0.9	100	0	0;	
   0.2	1100	1470	0.9	90000	0	0];	

materiaal(451:475,:)=[
   0.035	40	1470	0.9	150	0	0;
   0.038	15	1470	0.9	20	0	0;	
   0.036	20	1470	0.9	30	0	0;	
   0.036	25	1470	0.9	40	0	0;	
   0.036	35	1470	0.9	80	0	0;	
   0.036	35	1470	0.9	90	0	0;	
   0.03	35	1470	0.9	80	0	0;	
   0.035	100	1470	0.9	3.7	0	0;	
   0.02	30	1470	0.9	40	0	0;	
   0.018	40	1470	0.9	40	0	0;	
   0.026	33	1470	0.9	60	0	0;	
   0.026	33	1470	0.9	60	0	0;	
   0.026	33	1470	0.9	60	0	0;	
   0.035	33	1470	0.9	2	0	0;	
   0.026	33	1470	0.9	60	0	0;	
   0.054	60	1470	0.9	2	0	0;	
   0.05	10	1470	0.9	2	0	0;	
   0.08	245	1470	0.9	5	0	0;	
   0.05	150	840	0.9	6	0	0;	
   0.056	190	1000	0.9	7	0	0;
   0.1	300	840	0.9	9	0	0;
   0.048	35	1880	0.9	1.5	7	6.4;
   0.04 30 1500 0.9 50 0 0 ;
   0.04    20  0    0.9     50  0 0 ;
   0.04 10 1400 0.9 50 0 0];
   
materiaal(601:646,:)=[
   0.17	1300	1470	0.9	10000	0	0;
   0.17	1300	1470	0.9	8000	0	0;
   0.17	1530	1470	0.9	100000	0	0;
   0.17	1600	1470	0.9	100000	0	0;
   0.17	1180	1470	0.9	70000	0	0;
   0.17	1400	1470	0.9	40000	0	0;
   0.17	1500	1470	0.9	40000	0	0;
   0.17	1000	1470	0.9	40000	0	0;
   0.17	1300	1470	0.9	100000	0	0;
   0.17	1100	1470	0.9	20000	0	0;
   0.17	1300	1470	0.9	100000	0	0;
   0.17	1300	1470	0.9	10000	0	0
   0.2	1050	1470	0.9	10000	0	0;
   0.2	1050	1470	0.9	10000	0	0;
   0.2	1050	1470	0.9	20000	0	0;
   0.2	1050	1470	0.9	10000	0	0;
   0.2	700	1470	0.9	5000	0	0;
   0.2	1050	1470	0.9	1000	0	0;
   200	2800	880	0.9	70000	0	0;
   200	2800	880	0.9	3000	0	0;
   0.17	750	1470	0.9	5000	0	0;
   0.17	750	1470	0.9	65000	0	0;
   200	2800	880	0.9	700000	0	0;
   0.2	1200	1470	0.9	500	0	0;
   0.2	1050	1470	0.9	20000	0	0;
   0.17	1200	1470	0.9	10000	0	0;
   1.5	2100	840	0.9	20	0	0;
   1.28	2100	840	0.9	28	0	0;
   1.28	2100	840	0.9	28	0	0;
   0.37	1750	840	0.9	45	0	0;
   0.37	1750	840	0.9	25	0	0;
   0.37	1750	840	0.9	25	0	0;
   0.11	300	2100	0.9	3	0	0;
   0.11	500	2100	0.9	3	0	0;
   1.5	2000	840	0.9	10	0	0;
   1.5	2000	840	0.9	10	0	0;
   0.25	800	840	0.9	6	0	0;
   3.5	1650	840	0.9	2	0	0;
   1.86	2500	840	0.9	20	0	0;
   0.5	300	840	0.9	1	0	0;
   0.5	300	840	0.9	1	0	0;
   0.9	1750	840	0.9	25	0	0;
   3	1650	840	0.9	2.5	0	0;
   0.2	2200	1470	0.9	2000	0	0;
   0.13	900	1470	0.9	150	0	0;
   1.3 1500 800 0.9	2.5	0	0 ];

matprop(:,1)=l';
matprop(:,2:8)=materiaal(matnr,:);
k2=find(matnr==2);
matprop(k2,2)=(max(0.023,l(k2)'/0.17));
matprop(k2,6)=0.01*matprop(k2,6);
k3=find(matnr==3);
matprop(k3,2)=(max(0.023,l(k3)'/0.09));
matprop(k3,6)=0.01*matprop(k3,6);
k4=find(matnr==4);
matprop(k4,2)=(max(0.023,l(k4)'/0.15));
matprop(k4,6)=0.01*matprop(k4,6);

%  2000 toegevoegd accenten reg 560 en fout k3-k4etc