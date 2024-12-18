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
drop table Assignacions;
drop table Despatxos;
drop table Professors;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies de neteja de les taules:
delete from assignacions;
delete from despatxos;
delete from professors;

-- NOTE: Doneu una seqüència de sentències SQL d'actualització (INSERTs i/o UPDATEs) de tal manera que, un cop executades, 
-- el resultat de la consulta següent sigui el que s'indica. El nombre de files de cada taula ha de ser el més petit possible, 
-- i hi ha d'haver com a màxim un professor.
-- Per a la consulta:

Select count(*) as quant
From assignacions ass
Where ass.instantInici>50
Group by ass.instantInici
order by quant;

-- El resultat haurà de ser:

-- quant
-- 1
-- 2

insert into professors values('111','toni','3111',100);

insert into despatxos values('omega','118',16);
insert into despatxos values('omega','120',20);

insert into assignacions values('111','omega','118',109,null);
insert into assignacions values('111','omega','120',109,null);
insert into assignacions values('111', 'omega','120',346,null);


