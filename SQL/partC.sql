--------------1---------------

DROP TYPE tsuccursale;
/
DROP TYPE tagence;
/
DROP TYPE tclient;
/
DROP TYPE tcompte;
/
DROP TYPE toperation;
/
DROP TYPE tpret;
/
DROP TYPE tset_ref_prets FORCE;
DROP TYPE tset_ref_operations FORCE;
DROP TYPE tset_ref_comptes FORCE;
DROP TYPE tset_ref_agences FORCE;
DROP TYPE tclient FORCE;
DROP TYPE tcompte FORCE;
DROP TYPE tagence FORCE;
DROP TYPE tsuccursale FORCE;
--------------------------------
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

--------5------------
CREATE TYPE tset_ref_agences AS TABLE OF REF tagence;
/
CREATE TYPE tset_ref_comptes AS TABLE OF REF tcompte;
/
CREATE TYPE tset_ref_operations AS TABLE OF REF toperation;
/
CREATE TYPE tset_ref_prets AS TABLE OF REF tpret;
/

---------------------
CREATE OR REPLACE TYPE tsuccursale AS OBJECT
(
    numSucc NUMBER(3),
    nomSucc VARCHAR2(50),
    adresseSucc VARCHAR2(100),
    region VARCHAR2(10),
    agences tset_ref_agences
);
/
CREATE OR REPLACE TYPE tagence AS OBJECT
(
    numAgence NUMBER(3),
    nomAgence VARCHAR2(50),
    adresseAgence VARCHAR2(100),
    categorie VARCHAR2(10),
    succursale REF tsuccursale,
    comptes tset_ref_comptes
);
/
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
/
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
/

--------------6-----------------
ALTER TYPE tagence DROP MEMBER FUNCTION nbrPret;
ALTER TYPE tagence DROP MEMBER FUNCTION montGlobal;
ALTER TYPE tagence ADD MEMBER FUNCTION nbrPret RETURN NUMBER CASCADE;
/
ALTER TYPE tagence ADD MEMBER FUNCTION montGlobal RETURN NUMBER CASCADE;
/
-- Méthode pour calculer le nombre de prêts effectués

CREATE OR REPLACE TYPE BODY tagence AS
  MEMBER FUNCTION nbrPret RETURN NUMBER IS
    totalPret NUMBER := 0;
  BEGIN
    FOR c IN (SELECT * FROM TABLE(comptes)) LOOP
      totalPret := totalPret + c.prets.COUNT;
    END LOOP;
    RETURN totalPret;
  END nbrPret;
END;
/
-- Méthode pour calculer le montant global des prêts effectués
CREATE OR REPLACE TYPE BODY tagence AS
    MEMBER FUNCTION montant_global_prets(p_date_debut DATE, p_date_fin DATE) RETURN FLOAT IS
        total_montant FLOAT := 0;
    BEGIN
        FOR c IN (SELECT t FROM TABLE(comptes) t) LOOP
            FOR p IN (SELECT t FROM TABLE(c.prets) t WHERE t.datePret BETWEEN p_date_debut AND p_date_fin) LOOP
                total_montant := total_montant + p.montant;
            END LOOP;
        END LOOP;
        RETURN total_montant;
    END montant_global_prets;
END;
/
----    
ALTER TYPE tsuccursale ADD MEMEBER FUNCTION nbrAgencePrincipale RETURN NUMBER CASCADE;
/
