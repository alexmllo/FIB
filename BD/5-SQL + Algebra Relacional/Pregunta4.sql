----------------
-- Neteja
----------------



------------------------
-- Inicialitzacio
------------------------

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

-- Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de la taula següent:
-- presentacioTFG(idEstudiant, titolTFG, dniDirector, dniPresident, dniVocal, instantPresentacio, nota)

-- Hi ha una fila de la taula per cada treball final de grau (TFG) que estigui pendent de ser presentat o que ja s'hagi presentat.

-- En la creació de la taula cal que tingueu en compte que:
-- - No hi pot haver dos TFG d'un mateix estudiant.
-- - Tot TFG ha de tenir un títol.
-- - No hi pot haver dos TFG amb el mateix títol i el mateix director.
-- - El director, el president i el vocal han de ser professors que existeixin a la base de dades, i tot TFG té sempre director, president i vocal.
-- - El director del TFG no pot estar en el tribunal del TFG (no pot ser ni president, ni vocal).
-- - El president i el vocal no poden ser el mateix professor.
-- - L'identificador de l'estudiant i el títol del TFG són chars de 100 caràcters.
-- - L'instant de presentació ha de ser un enter diferent de nul.
-- - La nota ha de ser un enter entre 0 i 10.
-- - La nota té valor nul fins que s'ha fet la presentació del TFG.

-- Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms s'han de posar en majúscues/minúscules com surt a l'enunciat.

create table presentacioTFG
        (   idEstudiant char(100),
    titolTFG char(100) not null,
    dniDirector char(50) not null,
    dniPresident char(50) not null,
    dniVocal char(50) not null,
    instantPresentacio integer not null,
    nota integer check(nota>=0 and nota<=10),
    unique(titolTFG, dniDirector),
    constraint check_director check(dniDirector != dniPresident and dniDirector != dniVocal),
    constraint check_p_v check(dniPresident != dniVocal),
    primary key (idEstudiant),
    foreign key (dniDirector) references professors,
    foreign key (dniPresident) references professors,
    foreign key (dniVocal) references professors);