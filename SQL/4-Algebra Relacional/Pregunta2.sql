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

INSERT INTO  DEPARTAMENTS VALUES (5,'VENDES',3,'MUNTANER','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'MANEL',250000,'MADRID',5,null);

-- NOTE: Doneu una seqüència d'operacions d'algebra relacional per obtenir els números i els noms dels departament situats a MADRID, 
-- que tenen algun empleat que guanya més de 200000.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

-- Num_dpt		Nom_dpt
-- 5		VENDES

#
A = DEPARTAMENTS(ciutat_dpt='MADRID')
B = EMPLEATS(sou > 200000)
C = A*B
R = C[NUM_DPT, NOM_DPT]
