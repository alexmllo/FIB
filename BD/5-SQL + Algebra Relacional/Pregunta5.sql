-- SentËncies de preparaciÛ de la base de dades:
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

CREATE TABLE COST_CIUTAT
        (CIUTAT_DPT CHAR(20),
        COST INTEGER,
        PRIMARY KEY (CIUTAT_DPT));

-- SentËncies d'esborrat de la base de dades:
DROP TABLE cost_ciutat;
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO  PROJECTES VALUES (3,'PR1123','TELEVISIO',600000);

INSERT INTO  DEPARTAMENTS VALUES (4,'MARKETING',3,'RIOS ROSAS','BARCELONA');

-- SentËncies de neteja de les taules:
delete from cost_ciutat;
delete from empleats;
delete from departaments;
delete from projectes;

-- Doneu una sentència d'inserció de files a la taula cost_ciutat que l'ompli a partir del contingut de la resta de taules de la base de dades. Tingueu en compte el següent:

-- Cal inserir una fila a la taula cost_ciutat per cada ciutat on hi ha un o més departaments, però no hi ha cap departament que tingui empleats.

-- Per tant, només s'han d'inserir les ciutats on cap dels departaments situats a la ciutat tinguin empleats.

-- El valor de l'atribut cost ha de ser 0.

-- Pel joc de proves públic del fitxer adjunt, un cop executada la sentència d'inserció, a la taula cost_ciutat hi haurà les tuples següents:

-- CIUTAT_DPT		COST
-- BARCELONA		0

-- afegir les ciutats que tenen departaments pero no tenen empleats en els departaments

insert into COST_CIUTAT
select distinct d.CIUTAT_DPT, 0
from departaments d
where d.NUM_DPT not in (select e.NUM_DPT from empleats e, departaments d1 WHERE e.num_dpt = d1.num_dpt AND d.ciutat_dpt = d1.ciutat_dpt);

-- millor
insert into COST_CIUTAT
select distinct d.CIUTAT_DPT, 0
from departaments d
where d.CIUTAT_DPT not in (select d2.CIUTAT_DPT from departaments d2 natural inner join empleats);













