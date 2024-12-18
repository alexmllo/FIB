create table empleats1 (nemp1 integer primary key, nom1 char(25), ciutat1 char(10) not null);

create table empleats2 (nemp2 integer primary key, nom2 char(25), ciutat2 char(10) not null);

insert into empleats2 values(1,'joan','bcn');
insert into empleats2 values(2,'pere','mad');
insert into empleats2 values(3,'enric','bcn');
insert into empleats1 values(1,'joan','bcn');
insert into empleats1 values(2,'maria','mad');

-- En aquest exercici es tracta definir els disparadors necessaris sobre empleats2 (veure definició de la base de dades al fitxer adjunt) 
-- per mantenir la restricció següent:
-- Els valors de l'atribut ciutat1 de la taula empleats1 han d'estar inclosos en els valors de ciutat2 de la taula empleats2
-- Per mantenir la restricció, la idea és que:

-- En lloc de treure un missatge d'error en cas que s'intenti executar una sentència sobre empleats2 que pugui violar la restricció,
-- cal executar operacions compensatories per assegurar el compliment de l'asserció. En concret aquestes operacions compensatories ÚNICAMENT 
-- podran ser operacions DELETE.

-- Pel joc de proves que trobareu al fitxer adjunt, i la sentència:
-- DELETE FROM empleats2 WHERE nemp2=1;
-- La sentència s'executarà sense cap problema,i l'estat de la base de dades just després ha de ser:

-- Taula empleats1
-- nemp1	nom1	ciutat1
-- 1	joan	bcn
-- 2	maria	mad

-- Taula empleats2
-- nemp2	nom2	ciutat2
-- 2	pere	mad
-- 3	enric	bcn


create or replace function proc() returns trigger as $$
begin
    if (not exists(select * from empleats2 where ciutat2 = old.ciutat2)) then -- Comprovem que despres del delete o update no queda cap old.ciutat2 despres de eliminar o update en la taula empleats2
        delete from empleats1 where ciutat1 = old.ciutat2;
    end if;
    return null;
end;
$$language plpgsql;


create trigger tri
after update or delete of ciutat2 on empleats2
for each row execute procedure proc();