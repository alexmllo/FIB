-- SentËncies de preparaciÛ de la base de dades:
create table professors
(dni char(50),
nomProf char(50) unique,
telefon char(15),
sou integer not null check(sou>0),
primary key (dni));

create table despatxos
(modul char(5), 
numero char(5), 
superficie integer not null check(superficie>12),
primary key (modul,numero));

create table assignacions
(dni char(50), 
modul char(5), 
numero char(5), 
instantInici integer, 
instantFi integer,
primary key (dni, modul, numero, instantInici),
foreign key (dni) references professors,
foreign key (modul,numero) references despatxos);
-- instantFi te valor null quan una assignacio es encara vigent.

-- SentËncies d'esborrat de la base de dades:
DROP TABLE assignacions;
DROP TABLE despatxos;
DROP TABLE professors;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
insert into professors values('111','toni','3111',3500);

insert into despatxos values('omega','120',20);

insert into assignacions values('111','omega','120',345,null);

-- SentËncies de neteja de les taules:
DELETE FROM assignacions;
DELETE FROM despatxos;
DELETE FROM professors;

-- Doneu una seqüència d'operacions en àlgebra relacional per obtenir el nom dels professors que o bé tenen un sou superior a 2500, 
-- o bé que cobren igual o menys de 2500 i no tenen cap assignació a un despatx amb superfície inferior a 20.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

-- NomProf
-- toni

#
A = professors(sou>2500)
B = professors(sou<=2500)
C = despatxos(superficie<20)
D = B*assignacions
D = C*D
E = professors[nomProf]
F = D[nomProf]
G = E-F
H = A[nomProf]
R = H_u_G











