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

-- NOTE: Suposem que aquesta base de dades està en un estat on no hi ha cap fila.
-- Doneu una seqüència de sentències SQL d'actualització (INSERTs i/o UPDATEs) que acabi amb la violació de la regla d'integritat 
-- referencial definida entre la taula Assignacions i la taula Despatxos. La violació ha de ser causada per una sentència 
-- d'actualització de la taula Assignacions.
-- Les sentències NOMÉS han de violar aquesta restricció.

insert into professors VALUES ('111', 'Toni', '3111', 100);
insert into despatxos VALUES ('omega', '118', 16);
insert into assignacions values ('111', 'omega', '118', 1, 2);
update assignacions set modul = 'omg2';

