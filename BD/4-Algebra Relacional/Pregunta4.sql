CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

INSERT INTO DEPARTAMENTS VALUES(3,'MARKETING',1,'EDIFICI1','SABADELL');

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,null);

-- NOTE: Doneu una seqüència d'operacions de l'àlgebra relacional per obtenir el número i 
-- nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- Num_dpt		Nom_dpt
-- 3		MARKETING

-- TODO: 

#
A = empleats{ciutat_empl->ciutat_empl2, num_empl->num_empl2, sou->sou2, num_dpt->num_dpt2, num_proj->num_proj2, nom_empl->nom_empl2}
B = empleats[ciutat_empl!=ciutat_empl2, num_empl!=num_empl2, num_dpt!=num_dpt2]A
C = B * DEPARTAMENTS
R = C{num_dpt, nom_dpt}
