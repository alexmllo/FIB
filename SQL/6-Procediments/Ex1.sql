-- SentËncies d'esborrat de la base de dades:
drop table lloguers_actius;
drop table treballadors;
drop table cotxes;
drop table missatgesExcepcions;
drop function  llistat_treb(char(8), char(8));

-- SentËncies de preparaciÛ de la base de dades:
create table cotxes(
	matricula char(10) primary key,
	marca char(20) not null,
	model char(20) not null,
	categoria integer not null,
	color char(10),
	any_fab integer
	);
create table treballadors(
	dni char(8) primary key,
	nom char(30) not null,
	sou_base real not null,
	plus real not null
	);
create table lloguers_actius(
	matricula char(10) primary key    references cotxes,
	dni char(8) not null constraint fk_treb  references treballadors,
	num_dies integer not null,
	preu_total real not null
	);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No hi ha cap tupla dins del interval demanat');
insert into missatgesExcepcions values(2, 'Error intern');

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies de neteja de les taules:
delete from lloguers_actius;
delete from treballadors;
delete from cotxes;

-- SentËncies d'inicialitzaciÛ:
insert into cotxes values ('1111111111','Audi','A4',1,'Vermell',1998);
insert into cotxes values ('2222222222','Audi','A3',2,'Blanc',1998);
insert into cotxes values ('3333333333','Volskwagen','Golf',2,'Blau',1990);
insert into cotxes values ('4444444444','Toyota','Corola',3,'groc',1999);
insert into cotxes values ('5555555555','Honda','Civic',3,'Vermell',2000);
insert into cotxes values ('6666666666','BMW','Mini',2,'Vermell',2000);

insert into treballadors values ('22222222','Joan',1700,150);

insert into lloguers_actius values ('1111111111','22222222',7,750);
insert into lloguers_actius values ('2222222222','22222222',5,550);
insert into lloguers_actius values ('3333333333','22222222',4,450);
insert into lloguers_actius values ('4444444444','22222222',8,850);
insert into lloguers_actius values ('5555555555','22222222',2,250);




-- Donat un intèrval de DNIs, programar un procediment emmagatzemat "llistat_treb(dniIni,dniFi)" per obtenir la informació de cadascun 
-- dels treballadors amb un DNI d'aquest interval.

-- Per cada treballador de l'interval cal obtenir:
-- - Les seves dades personals: dni, nom, sou_base i plus

-- - En cas que el treballador tingui 5 o més lloguers actius, al llistat hi ha de sortir una fila per cadascun dels cotxes que té llogats.
-- - En qualsevol altre cas, al llistat hi ha de sortir una única fila amb les dades del treballador, i nul a la matrícula.

-- Tingueu en compte que:
-- - Es vol que retorneu els treballadors ordenats per dni i matricula de forma ascendent.
-- - El tipus de les dades que s'han de retornar han de ser els mateixos que hi ha a la taula on estan definits els atributs corresponents.

-- El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que heu d'identificar són les tipificades a la 
-- taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents al fitxer adjunt. En el vostre procediment heu 
-- d'incloure, on s'identifiquin aquestes situacions, les sentències:
-- SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 o 2, depenent de l'error)
-- RAISE EXCEPTION '%',missatge;
-- On la variable missatge ha de ser una variable definida al vostre procediment.

-- Pel joc de proves que trobareu al fitxer adjunt i la crida següent,
-- SELECT * FROM llistat_treb('11111111','33333333');
-- el resultat ha de ser:

-- DNI		Nom		Sou		Plus		Matricula
-- 22222222		Joan		1700		150		1111111111
-- 22222222		Joan		1700		150		2222222222
-- 22222222		Joan		1700		150		3333333333
-- 22222222		Joan		1700		150		4444444444
-- 22222222		Joan		1700		150		5555555555


create type Tdades as (
    dni_t char(8),
    nom_t char(30),
    sou_base_t real,
    plus_t real,
    matricula_t char(10)
)

create or replace function llistat_treb(dniIni char(8), dniFi char(8))
returns setof Tdades as $$
declare
    dades_treballadors Tdades;
    n_lloguers integer;
    matricula_f char(10);
    missatge varchar(50);
begin
    for dades_treballadors in select * from treballadors t where t.dni >= dniIni and t.dni <= dniFi
        loop
            select count(*) into n_lloguers 
                from lloguers_actius la
                where dades_treballadors.dni = la.dni;
        if (n_lloguers >= 5)
        then
            for matricula_f in select la2.matricula from lloguers_actius la2
                                    where dades_treballadors.dni = la2.dni
                loop
                    dades_treballadors.matricula_t := matricula_f;
                    return next dades_treballadors;
        else
            return next dades_treballadors;
        end if;
    end loop;
    
    if not found then
        select texte into missatge from missatgesExcepcions where num = 1;
        raise excepcion '%', missatge;
    end if;
    return;

    EXCEPTION
        WHEN raise_exception THEN
            RAISE EXCEPTION '%', SQLERRM;
        WHEN others then
            raise exception '%', missatge;
end;
$$language plpgsql;






