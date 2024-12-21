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

-- SentËncies d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'BARCELONA',3,null);
INSERT INTO  EMPLEATS VALUES (5,'EULALIA',150000,'BARCELONA',3,null);

-- SentËncies de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

-- NOTE: Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen 2 o més empleats que viuen a la mateixa ciutat.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- NUM_DPT		NOM_DPT
-- 3		MARKETING

select d.num_dpt, d.nom_dpt
from departaments d
where d.num_dpt in (
    select e.num_dpt
    from empleats e
    group by e.num_dpt, e.ciutat_empl
    having count(*) >= 2
);
