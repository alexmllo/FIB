CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER PRIMARY KEY,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,null);

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

INSERT INTO  EMPLEATS VALUES (5,'PERE',35000,'BARCELONA',3,null);

-- NOTE: Doneu una seqüència d'operacions d'àlgebra relacional per obtenir el nom dels empleats que guanyen més que l'empleat amb num_empl 3.
-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- Nom_empl
-------------
-- JOAN
-- PERE

#
A = empleats(num_empl = 3)
B = A[sou]
C = B{sou->sou2}
D = empleats[sou>sou2]C
R = D[nom_empl]
