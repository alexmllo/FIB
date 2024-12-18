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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'VERDAGUER','VIC');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,1);

-- NOTE: Doneu una seqüència d'operacions d'algebra relacional per obtenir el número i nom dels departaments tals que 
-- tots els seus empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- Num_dpt		Nom_dpt
-- 3		MARKETING

-- FIX: Aquesta consulta no funcionara ja que:
-- 1. A conte nomes als empleats que viuen a Madrid
-- 2. B, es un natural join entre la relacio A (empleats a Madrid) i la relacio departaments, basantse en el atribut num_dpt
-- Aixo incloura les files d'empleats que viuen a Madrid i els departaments corresponents, pero NO EXCLOU als departaments que tenen empleats que no viuen a Madrid
-- El objectiu es trobar els departaments que NOMES tenen empleats que viuen a Madrid.
#
A = EMPLEATS(ciutat_empl = 'MADRID')
B = A * DEPARTAMENTS
R = B[num_dpt, nom_dpt]

A=empleats(ciutat_empl != 'MADRID')
B=empleats*departaments
C=A*departaments
D=B[num_dpt, nom_dpt]
E=C[num_dpt, nom_dpt]
F=D-E
