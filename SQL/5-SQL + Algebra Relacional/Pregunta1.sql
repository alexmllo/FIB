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
insert into professors values('111','toni','3111',100);
insert into professors values('222','pere','4111',200);

insert into despatxos values('omega','118',16);

insert into assignacions values('111','omega','118',109,344);
insert into assignacions values('222','omega','118',345,null);

-- SentËncies de neteja de les taules:
DELETE FROM assignacions;
DELETE FROM despatxos;
DELETE FROM professors;


-- Donar una sentència SQL per obtenir per cada mòdul on hi hagi despatxos, la suma de les durades de les assignacions 
-- finalitzades (instantFi diferent de null) a despatxos del mòdul. El resultat ha d'estar ordenat ascendentment pel nom del mòdul.

-- Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

-- MODUL		SUMAA
-- Omega		235

select d.modul, sum(a.instantFi - a.instantInici) as SUMAA
from departaments d natural inner join assignacions a
where a.instantFi is not null
group by d.modul order by d.modul asc;

-- millor
select a.modul, sum(a.instantInici-a.instantFi) as SUMAA
from assignacions a
where a.instantFi is not null
group by a.modul order by a.modul asc;














