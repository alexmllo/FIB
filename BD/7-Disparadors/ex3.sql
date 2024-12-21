create table productes
(idProducte char(9),
nom char(20),
mida char(20),
preu integer check(preu>0),
primary key (idProducte),
unique (nom,mida));

create table domicilis
(numTelf char(9),
nomCarrer char(20),
numCarrer integer check(numCarrer>0),
pis char(2),
porta char(2),
primary key (numTelf));

create table comandes
(numComanda integer check(numComanda>0),
instantFeta integer not null check(instantFeta>0),
instantServida integer check(instantServida>0),
numTelf char(9),
import integer ,
primary key (numComanda),
foreign key (numTelf) references domicilis,
check (instantServida>instantFeta));
-- numTelf es el numero de telefon del domicili des don sha 
-- fet la comanda. Pot tenir valor nul en cas que la comanda 
-- sigui de les de recollir a la botiga. 

create table liniesComandes
(numComanda integer,
idProducte char(9),
quantitat integer check(quantitat>0),
primary key(numComanda,idProducte),
foreign key (idProducte) references productes,
foreign key (numComanda) references comandes
);
-- quantitat es el numero d'unitats del producte que sha demanat 
-- a la comanda

insert into productes values ('p111', '4 formatges', 'gran', 10);   

insert into productes values ('p222', 'margarita', 'gran', 5);  
 
insert into comandes(numComanda,instantfeta,instantservida,numtelf, import) values (110, 1091, 1101, null, 10);

insert into liniesComandes values (110, 'p222', 2);



-- En aquest exercici es tracta de mantenir de manera automàtica, mitjançant triggers, l'atribut derivat import de la taula comandes.

-- En concret, l'import d'una comanda és igual a la suma dels resultats de multiplicar per cada línia de comanda, la quantitat del producte 
-- de la línia pel preu del producte .

-- Només heu de considerar les operacions de tipus INSERT sobre la taula línies de comandes.

-- Pel joc de proves que trobareu al fitxer adjunt, i la sentència: INSERT INTO liniesComandes VALUES (110, 'p111', 2);
-- La sentència s'executarà sense cap problema, i l'estat de la taula de comandes després de la seva execució ha de ser:

-- numcomanda		instantfeta		instantservida		numtelf		import
-- 110		1091		1101		null		30



create or replace function proc() returns trigger as $$
declare
    preu_in integer;
begin
    select preu into preu_in from productes p where p.idProducte = new.idProducte;
    preu_in := preu_in * new.quantitat;

    update comandes
    set import = import + preu_in where new.numComanda = comandes.numComanda;
    return null;
end;
$$ language plpgsql;



create trigger ins
after insert on liniesComandes
for each row execute procedure proc(); 