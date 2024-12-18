-- SentËncies d'esborrat de la base de dades:
drop table empleats;
drop table departaments;
drop table projectes;

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

--------------------------
-- Joc de proves P˙blic
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO  DEPARTAMENTS VALUES (1,'DIRECCIO',10,'PAU CLARIS','BARCELONA');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (1,'CARME',400000,'MATARO',1,1);


-- Doneu una sentència SQL per obtenir els departaments tals que tots els empleats del departament estan assignats a un mateix projecte.
-- No es vol que surtin a la consulta els departaments que no tenen cap empleet.
-- Es vol el número, nom i ciutat de cada departament.

-- Cal resoldre l'exercici sense fer servir funcions d'agregació.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- Num_dpt		Nom_dpt		Ciutat_dpt
-- 1		DIRECCIO		BARCELONA

select d.Num_dpt, d.Nom_dpt, d.Ciutat_dpt
from departaments d natural inner join empleats e
where d.Num_dpt not in (select e2.Num_dpt from empleats e2 where e2.NUM_PROJ != e.NUM_PROJ)
group by d.Num_dpt;






