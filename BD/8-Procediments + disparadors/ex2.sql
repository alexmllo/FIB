-- SentËncies de preparaciÛ de la base de dades:
CREATE TABLE usuaris (
    idUsuari CHAR(10),
    nomUsuari VARCHAR(50) NOT NULL,
    mail varchar(100) NOT NULL UNIQUE,
    PRIMARY KEY(idUsuari)
);

CREATE TABLE biblioteques (
    idBiblioteca CHAR(10),
    nomBiblioteca VARCHAR(50) NOT NULL,
    barri varchar(50) NOT NULL,
    capacitatUsuaris INTEGER CHECK(capacitatUsuaris > 0) NOT NULL,
    limitPrestecs INTEGER CHECK(limitPrestecs > 0) NOT NULL,
    PRIMARY KEY(idBiblioteca)
);

CREATE TABLE llibres (
    ISBN char(15),
    titol VARCHAR(100) NOT NULL,
    PRIMARY KEY(ISBN)
);

CREATE TABLE exemplars (
    idBiblioteca CHAR(10),
    idExemplar CHAR(10),
    ISBN char(15) NOT NULL,
   	PRIMARY KEY (idBiblioteca, idExemplar),
    FOREIGN KEY (ISBN) REFERENCES llibres,
    FOREIGN KEY (idBiblioteca) REFERENCES biblioteques
);

CREATE TABLE exemplarsEnPrestec (
    idBiblioteca CHAR(10),
    idExemplar CHAR(10),
   	PRIMARY KEY (idBiblioteca, idExemplar),
    FOREIGN KEY (idBiblioteca, idExemplar) REFERENCES exemplars
);

CREATE TABLE prestecs (
    idBibliotecaP CHAR(10),
    idExemplarP CHAR(10),
    idUsuariP CHAR(10),
    instantIniciPrestec INTEGER CHECK(instantIniciPrestec > 0),
    instantFiPrestec INTEGER CHECK(instantFiPrestec>instantIniciPrestec),
    PRIMARY KEY (idUsuariP, idBibliotecaP, idExemplarP, instantIniciPrestec),
    FOREIGN KEY (idUsuariP) REFERENCES usuaris,
    FOREIGN KEY (idBibliotecaP,idExemplarP) REFERENCES exemplars
);

CREATE TABLE biblioteques_saturades (
    idBiblioteca CHAR(10) PRIMARY KEY,
    FOREIGN KEY (idBiblioteca) REFERENCES biblioteques
);

CREATE TABLE missatgesExcepcions (
    num INTEGER,
    texte VARCHAR(50)
);

INSERT INTO missatgesExcepcions VALUES
(1, 'Aquest exemplar esta en prÈstec'),
(2, 'Exemplar o usuaris no existeixen'),
(3, 'Biblioteca ha superat el lÌmit de prÈstecs'),
(4, 'Error intern');

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO usuaris VALUES ('u-Anna', 'Anna', 'c@d.e');
INSERT INTO usuaris VALUES ('u-Ona', 'Ona', 'f@g.e');
INSERT INTO llibres VALUES ('1001', 'El Quixot');
INSERT INTO llibres VALUES ('2002', 'Nada');
INSERT INTO biblioteques VALUES ('BC', 'Biblioteca Central','Sants',150,10);
INSERT INTO biblioteques VALUES ('BA', 'Biblioteca Autonoma','Gr‡cia',100,12);
INSERT INTO exemplars VALUES ('BC', 'E-01', '1001');
INSERT INTO exemplars VALUES ('BA', 'E-01', '2002');
INSERT INTO prestecs VALUES ('BA', 'E-01', 'u-Ona', 200, null);
INSERT INTO exemplarsEnPrestec VALUES ('BA', 'E-01');

-- Disposem de la base de dades del fitxer adjunt que permet gestionar els prèstecs d'exemplars de llibres que es guarden a diferents biblioteques.

-- Cal implementar un procediment emmagatzemat nou_prestec(idBib,idEx,idUs,instIni).

-- El procediment ha de:
-- - Enregistrar el nou prèstec de l'exemplar idEx, que pertany a la biblioteca idBib. El prèstec l'ha fet l'usuari idUs en l'instant instIni. 
-- Això s'ha de fer inserint una nova fila a les taules prestecs i exemplarsEnPrestec.
-- - Quan es fa un nou prèstec l'instantFiPrestec del prèstec ha de tenir valor NULL.
-- - Si la biblioteca passa a tenir més de 4 prèctecs, inserir la biblioteca a la taula biblioteques_saturades.
-- - El procediment ha de retornar com a resultat una fila per cada exemplar de la biblioteca idBib que alguna vegada ha estat agafat en prèstec, 
-- indicant quantes vegades ha estat deixat en prèstec. A cada fila del resultat hi ha d'haver idBiblioteca, idExemplar i quantsPrestecs.

-- Les situacions d'error que cal identificar són les tipificades a la taula missatgesExcepcions.
-- Quan s'identifiqui una d'aquestes situacions cal generar una excepció:
-- SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 .. 5, depenent de l'error)
-- RAISE EXCEPTION '%',missatge; (missatge ha de ser una variable definida al vostre procediment)

-- Suposem el joc de proves que trobareu al fitxer adjunt i la sentència
-- SELECT * FROM nou_prestec('BC', 'E-01','u-Anna', 100);


create type Texemplar as (
    idBiblioteca char(10),
    idExemplar char(10),
    quantsPrestecs integer
);

CREATE or replace function nou_prestec(idBib char(10), idEx char(10), idUs char(10), instIni integer) returns setof Texemplar as $$
declare
    missatge varchar(50);
    numPrestecs integer;
    r_exemplars Texemplar;
begin
    -- Verificar si l'exemplar ja esta en prestec (Error 1)
    if (exists(select * from exemplarsEnPrestec where idBiblioteca = idBib and idExemplar = idEx)) then
        select texte into missatge from missatgesExcepcions where num = 1;
        raise exception '%', missatge;
    end if;

    -- Verificar si l'exemplar i/o l'usuari no existeixen (Error 2)
    if (not exists(select * from usuaris where idUsuari = idUs) or not exists(select * from exemplars where idExemplar = idEx and idBiblioteca = idBib)) then
        select texte into missatge from missatgesExcepcions where num = 2;
        raise exception '%', missatge;
    end if;

    -- Verificar si la biblioteca esta saturada (Error 3)
    if (exists(select * from biblioteques_saturades where idBiblioteca = idBib)) then
        select texte into missatge from missatgesExcepcions where num = 3;
        raise exception '%', missatge;
    end if;

    insert into prestecs values (idBib, idEx, idUs, instIni, null);
    insert into exemplarsEnPrestec values (idBib, idEx);

    select count(*) into numPrestecs
    from prestecs 
    where idBibliotecaP = idBib;

    -- Si la biblioteca supera el limit de prestecs, afegir-la a biblioteques_saturades
    if (numPrestecs > 4) then
        insert into biblioteques_saturades values (idBib);
    end if;

    for r_exemplars in 
        select idBibliotecaP, idExemplarP, count(*) as quantsPrestecs
        from prestecs
        where idBibliotecaP = idBib
        group by idBibliotecaP, idExemplarP
    loop
        return next r_exemplars;
    end loop;

    return;

    exception
        when others then select texte into missatge from missatgesExcepcions where num = 4;
        raise exception '%', missatge;

end;
$$language plpgsql;