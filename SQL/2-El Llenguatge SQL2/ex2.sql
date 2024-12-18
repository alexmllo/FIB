-- -- SentËncies de preparaciÛ de la base de dades:
-- CREATE TABLE DEPARTAMENTS
--          (	NUM_DPT INTEGER,
-- 	NOM_DPT CHAR(20),
-- 	PLANTA INTEGER,
-- 	EDIFICI CHAR(30),
-- 	CIUTAT_DPT CHAR(20),
-- 	PRIMARY KEY (NUM_DPT));
--
-- CREATE TABLE PROJECTES
--          (	NUM_PROJ INTEGER,
-- 	NOM_PROJ CHAR(10),
-- 	PRODUCTE CHAR(20),
-- 	PRESSUPOST INTEGER,
-- 	PRIMARY KEY (NUM_PROJ));
--
-- CREATE TABLE EMPLEATS
--          (	NUM_EMPL INTEGER,
-- 	NOM_EMPL CHAR(30),
-- 	SOU INTEGER,
-- 	CIUTAT_EMPL CHAR(20),
-- 	NUM_DPT INTEGER,
-- 	NUM_PROJ INTEGER,
-- 	PRIMARY KEY (NUM_EMPL),
-- 	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
-- 	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

-- SentËncies d'esborrat de la base de dades:
-- DROP TABLE empleats;
-- DROP TABLE projectes;
-- DROP TABLE departaments;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
-- INSERT INTO  DEPARTAMENTS VALUES (
-- 5,'VENDES',3,'CASTELLANA','MADRID');
--
-- INSERT INTO  EMPLEATS VALUES (1,'MANEL',250000,'MADRID',5,null);
--
-- INSERT INTO  EMPLEATS VALUES (3,'JOAN',25000,'GIRONA',5,null);

-- SentËncies de neteja de les taules:
-- DELETE FROM empleats;
-- DELETE FROM Projectes;
-- DELETE FROM departaments;

-- NOTE: Doneu una sentència SQL per obtenir les ciutats on hi viuen empleats però no hi ha cap departament.
-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
-- CIUTAT_EMPL
-- GIRONA

select distinct e.ciutat_empl
from empleats e
where e.ciutat_empl not in (select d.ciutat_dpt from departaments d);

-- TODO: Comprova si no existeix cap departament que estigui situat a la mateixa ciutat que algun empleat.
-- Si no existeix cap departament a la ciutat on viu l'empleat, NOT EXISTS serà cert i aquesta ciutat s'inclourà en els resultats.

select distinct e.ciutat_empl
from empleats e
where not exists (select * from departaments d where e.ciutat_empl = d.ciutat_dpt);

