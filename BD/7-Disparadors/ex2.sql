CREATE TABLE empleats(
  nempl integer primary key,
  salari integer);

insert into empleats values(1,1000);

insert into empleats values(2,2000);

insert into empleats values(123,3000);

CREATE TABLE dia(
dia char(10));

insert into dia values('dijous');

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No es poden esborrar empleats el dijous');


-- Implementar mitjançant disparadors la restricció d'integritat següent:
--  No es poden esborrar empleats el dijous

create or replace function proc() returns trigger as $$
declare
    missatge varchar(100);
    n_dia char(10);
begin
    select dia into n_dia from dia;
    if (n_dia = 'dijous') then
        select texte into missatge from missatgesExcepcions where num = 1;
        raise exception '%', missatge;
    end if;
    return null;

    exception
        WHEN raise_exception THEN raise exception '%', SQLERRM;

end;
$$LANGUAGE plpgsql;


create trigger del_empl
before delete on empleats
for each statement execute procedure proc();