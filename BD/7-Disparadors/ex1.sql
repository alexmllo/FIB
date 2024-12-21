-- SentËncies de preparaciÛ de la base de dades:
create table empleats(
                 nempl integer primary key,
                 salari integer);

create table missatgesExcepcions(
	num integer, 
	texte varchar(100));

insert into missatgesExcepcions values(1,'No es pot esborrar l''empleat 123 ni modificar el seu n˙mero d''empleat');

-- SentËncies d'esborrat de la base de dades:
drop table empleats;
drop table missatgesExcepcions;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
insert into empleats values(1,1000);
insert into empleats values(2,2000);
insert into empleats values(123,3000);

-- Dades d'entrada o sentËncies d'execuciÛ:
delete from empleats where nempl=123;


-- Implementar mitjançant disparadors la restricció d'integritat següent:
-- No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat.

-- Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu 
-- trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències:
-- SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__; (el número que sigui, depenent de l'error)
-- RAISE EXCEPTION '%',missatge;
-- La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades.

-- Pel joc de proves que trobareu al fitxer adjunt i la instrucció:
-- DELETE FROM empleats WHERE nempl=123;
-- La sortida ha de ser:

-- No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat


create or replace function proc() returns trigger as $$
declare 
	missatge varchar(100);
begin 
	if (old.nempl = 123) then
		select texte into missatge from missatgesExcepcions where num = 1;
		raise exception '%', missatge;
	end if;
	if (TG_OP = 'UPDATE') then return new;
	else return old;
	end if;

	exception
		WHEN raise_exception THEN raise exception '%', SQLERRM;  	

end;
$$LANGUAGE plpgsql; 



create trigger restrict_delete
before delete on empleats 
for each row execute procedure proc();

create trigger update_empl
before update of nempl on empleats 
for each row execute procedure proc();











