-- Supprimer les tables
DROP TABLE Pret;
DROP TABLE Operation;
DROP TABLE Client;
DROP TABLE Compte;
DROP TABLE Agence;
DROP TABLE Succursale;


-- Supprimer les types
DROP TYPE tset_ref_prets;
DROP TYPE tset_ref_operations;
DROP TYPE tset_ref_comptes;
DROP TYPE tset_ref_agences;
DROP TYPE tpret;
DROP TYPE toperation;
DROP TYPE tcompte;
DROP TYPE tclient;
DROP TYPE tagence;
DROP TYPE tsuccursale;


--------------5------------------

----creation des type incomplet
CREATE TYPE tsuccursale;
/
CREATE TYPE tagence;
/
CREATE TYPE tclient;
/
CREATE TYPE tcompte;
/
CREATE TYPE toperation;
/
CREATE TYPE tpret;
/

------definition des des association par les tables de ref
CREATE TYPE tset_ref_agences AS TABLE OF REF tagence;
/
CREATE TYPE tset_ref_comptes AS TABLE OF REF tcompte;
/
CREATE TYPE tset_ref_operations AS TABLE OF REF toperation;
/
CREATE TYPE tset_ref_prets AS TABLE OF REF tpret;
/

---------creation et definition des types------------
CREATE OR REPLACE TYPE tsuccursale AS OBJECT
(
    numSucc NUMBER(3),
    nomSucc VARCHAR2(50),
    adresseSucc VARCHAR2(100),
    region VARCHAR2(10),
    agences tset_ref_agences
);

CREATE OR REPLACE TYPE tagence AS OBJECT
(
    numAgence NUMBER(3),
    nomAgence VARCHAR2(50),
    adresseAgence VARCHAR2(100),
    categorie VARCHAR2(10),
    succursale REF tsuccursale,
    comptes tset_ref_comptes
);

CREATE OR REPLACE TYPE tcompte AS OBJECT
(
    numCompte NUMBER(10),
    dateOuverture DATE,
    dateCompte DATE,
    etatCompte VARCHAR2(10),
    solde FLOAT,
    operations tset_ref_operations,
    prets tset_ref_prets,
    client REF tclient,
    agence REF tagence
);

CREATE OR REPLACE TYPE tclient AS OBJECT
(
    numClient NUMBER(5),
    nomClient VARCHAR2(50),
    typeCLient VARCHAR2(50),
    adresseClient VARCHAR2(100),
    numTel VARCHAR2(10),
    email VARCHAR2(50),
    comptes tset_ref_comptes
);



CREATE OR REPLACE TYPE toperation AS OBJECT(
    numOperation NUMBER,
    natureOp VARCHAR2(30),
    montantOp FLOAT,
    dateOp DATE,
    observation VARCHAR2(10),
    compte REF tcompte
);

CREATE OR REPLACE TYPE tpret AS OBJECT(
    numPret NUMBER,
    montantPret FLOAT,
    dateEffet DATE,
    duree NUMBER,
    typePret VARCHAR2(30),
    tauxInteret NUMBER,
    compte REF tcompte
);
/

--------------6-----------------
ALTER TYPE tagence ADD MEMBER FUNCTION nbr_pret RETURN NUMBER CASCADE;

ALTER TYPE tagence ADD MEMBER FUNCTION montant_global_pret(numagence NUMBER) RETURN NUMBER CASCADE;


CREATE OR REPLACE TYPE BODY tagence AS
    MEMBER FUNCTION nbr_pret RETURN NUMBER IS
        nb NUMBER;
        BEGIN
            SELECT COUNT(*) INTO nb FROM TABLE(SELF.comptes) c, TABLE(VALUE(c).prets) p;
            RETURN nb;
        END nbr_pret;
    MEMBER FUNCTION montant_global_pret(numagence NUMBER) RETURN NUMBER IS
        total_montant NUMBER;
        BEGIN
            SELECT SUM(VALUE(p).montantPret) INTO total_montant FROM
            TABLE(comptes) c, TABLE(VALUE(c).prets) p
            WHERE VALUE(C).agence.NumAgence = numagence
            AND value(p).dateEffet >= TO_DATE('01-01-2020', 'DD-MM-YYYY') 
            AND value(p).dateEffet + value(p).duree <= TO_DATE('01-01-2024', 'DD-MM-YYYY');
            RETURN total_montant;
        END montant_global_pret;
    END;
/


CREATE OR REPLACE TYPE agence_succ AS OBJECT(
    nom_agence VARCHAR2(50),
    nom_succursale VARCHAR2(50)
);
/
CREATE TYPE liste_agence_succ AS TABLE OF agence_succ;
/
ALTER TYPE tsuccursale ADD MEMBER FUNCTION nbr_agences_principales RETURN NUMBER CASCADE;
ALTER TYPE tsuccursale ADD MEMBER FUNCTION show_agences_secondaires RETURN liste_agence_succ CASCADE;

CREATE OR REPLACE TYPE  BODY tsuccursale AS
    MEMBER FUNCTION nbr_agences_principales RETURN NUMBER IS
        nb NUMBER;
        BEGIN
            SELECT COUNT(*) INTO nb FROM TABLE(SELF.agences) a
            WHERE VALUE(a).categorie = 'Principale';
            RETURN nb;
        END nbr_agences_principales;
        
        MEMBER FUNCTION show_agences_secondaires RETURN liste_agence_succ IS
        liste liste_agence_succ;

        BEGIN
            SELECT CAST(MULTISET(
                SELECT DISTINCT deref(value(a)).nomAgence ,self.nomSucc
                FROM TABLE(self.agences) a
                WHERE  deref(VALUE(a)).categorie = 'Secondaire'
                AND EXISTS (
                SELECT 1
			    FROM TABLE(VALUE(a).comptes) c, TABLE(value(c).prets) p
                WHERE value(p).typePret = 'ANSEJ'
            )
            ) AS liste_agence_succ)
            INTO liste
            FROM dual;
    RETURN liste;
END show_agences_secondaires;

    END;
/





-- 7

CREATE TABLE Succursale OF tsuccursale(
    CONSTRAINT pk_succursale PRIMARY KEY (numSucc),
    CONSTRAINT ch_region CHECK (region IN ('Nord', 'Sud', 'Est', 'Ouest')
    )
)
nested table agences STORE AS agence_succursale;

CREATE TABLE Agence OF tagence(
    CONSTRAINT pk_agence PRIMARY KEY (numAgence),
    CONSTRAINT ch_categorie CHECK (categorie IN ('Principale', 'Secondaire'))
)
nested table comptes STORE AS compte_agence;

CREATE TABLE Compte OF tcompte(
    CONSTRAINT pk_compte PRIMARY KEY (numCompte),
    CONSTRAINT ch_etat CHECK (etatCompte IN ('Actif', 'BLOQUE'))
)
NESTED TABLE prets STORE AS pret_compte, NESTED TABLE operations STORE AS operation_compte;


CREATE TABLE Client OF tclient(
    CONSTRAINT pk_client PRIMARY KEY (numClient),
    CONSTRAINT ch_type_client CHECK (typeClient IN ('Particulier', 'Entreprise'))
)
nested table comptes STORE AS compte_client;

CREATE TABLE operation OF toperation(
    CONSTRAINT pk_operation PRIMARY KEY (numOperation),
    CONSTRAINT ch_nature_op CHECK (natureOp IN ('Credit', 'Debit'))
);


CREATE TABLE Pret OF tpret(
    CONSTRAINT pk_pret PRIMARY KEY (numPret),
    CONSTRAINT ch_type_pret CHECK (typePret IN ('Vehicule', 'Immobilier','ANSEJ', 'ANJEM'))
);
