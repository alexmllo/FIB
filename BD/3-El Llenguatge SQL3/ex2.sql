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

insert into despatxos values('omega','118',16);
insert into despatxos values('omega','120',20);

insert into assignacions values('111','omega','118',109,344);
insert into assignacions values('111','omega','120',345,null);

-- SentËncies de neteja de les taules:
DELETE FROM assignacions;
DELETE FROM despatxos;
DELETE FROM professors;

-- NOTE: Donar una sentència SQL per obtenir els professors que tenen alguna assignació finalitzada (instantFi diferent de null)
-- a un despatx amb superfície superior a 15 i que cobren un sou inferior o igual a la mitjana del sou de tots els professors.
-- En el resultat de la consulta ha de sortir el dni del professor, el nom del professor, i el darrer instant en què el professor
-- ha estat assignat a un despatx amb superfície superior a 15. Sortida:

-- DNI	NomProf	Darrer_instant
-- 111	toni	344

select p.dni, p.nomProf, max(a.instantFi) as Darrer_instant
from professors p natural inner join assignacions a natural inner join despatxos d
where a.instantFi is not null and d.superficie > 15 and p.sou <= (select avg(sou) from professors)
group by p.dni;

