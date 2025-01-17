-- Sent�ncies de preparaci� de la base de dades:
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

-- Sent�ncies d'esborrat de la base de dades:
-- DROP TABLE empleats;
-- DROP TABLE departaments;
-- DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sent�ncies d'inicialitzaci�:
-- INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');
--
-- INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

-- NOTE: 
-- Doneu una sentència SQL per obtenir el número i el nom dels departaments que no tenen cap empleat que visqui a MADRID.
-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
-- NUM_DPT		NOM_DPT
-- 3		MARKETING

select d.num_dpt, d.nom_dpt
from departaments d
where d.num_dpt not in (select e.num_dpt from empleats e where e.ciutat_empl = 'MADRID');

-- TODO: Si fem servir not exists, s'executa per cada departament, si la subconsulta troba algun empleat
-- en el departament actual que visqui a Madrid, el departament actual no es selecciona.

select d.num_dpt, d.nom_dpt
from departaments d
where not exits (select * from empleats e where e.num_dpt = d.num_dpt and e.ciutat_empl = 'MADRID');

-- Sent�ncies de neteja de les taules:
-- DELETE FROM empleats;
-- DELETE FROM departaments;
-- DELETE FROM projectes;

