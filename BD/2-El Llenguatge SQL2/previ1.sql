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



INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',2,'PAU CLARIS','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,null);
INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);


-- Doneu una sentència SQL per obtenir el nom dels empleats que guanyen el sou més alt.
-- Cal ordenar el resultat descendenment per nom de l'empleat.

SELECT DISTINCT e.nom_empl
from empleats e
WHERE e.sou = (SELECT MAX(sou) FROM empleats)
ORDER BY e.nom_empl DESC;
