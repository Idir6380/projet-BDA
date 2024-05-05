--9
select value(c).numCompte
from agence a , table (a.comptes) c
where a.numAgence = 101 and deref(value(c).client).typeClient='Entreprise';
--10

select value(p).numPret,a.numAgence, value(c).numCompte , value(p).montantPret
from agence a ,table(a.comptes) c ,table (value(c).prets ) p
where deref(a.succursale).numSucc=005;

--11
SELECT c.numCompte FROM Compte c
WHERE c.numCompte NOT IN (
SELECT comp.numCompte
FROM compte comp ,TABLE(comp.operations) op
WHERE value(op).natureOp = 'Debit'
AND EXTRACT(YEAR FROM value(op).dateOp) BETWEEN 2000 AND 2022);

--12    
SELECT SUM(deref(VALUE(op)).montantOp)
FROM COMPTE C, TABLE(C.OPERATIONS) op
WHERE numCompte = 3023540212
AND EXTRACT(YEAR FROM deref(VALUE(op)).dateOp) = 2023
AND deref(VALUE(op)).natureOp = 'Credit';


--13
SELECT p.numPret,
       deref(deref(p.compte).agence).numAgence AS numAgence,
       deref(p.compte).numCompte AS numCompte,
       deref(deref(p.compte).client).numClient AS numClient,
       p.montantPret
FROM Pret p
WHERE p.dateEffet + p.duree > TRUNC(SYSDATE);



SELECT p.numPret,
       deref(deref(p.compte).agence).numAgence AS numAgence,
       deref(p.compte).numCompte AS numCompte,
       deref(deref(p.compte).client).numClient AS numClient,
       p.montantPret - COALESCE((SELECT SUM(op.montantOp)
                                 FROM Operation op
                                 WHERE op.natureOp = 'Debit'
                                   AND op.compte = p.compte), 0) AS montantRestant
FROM Pret p
WHERE (p.dateEffet + p.duree <= TRUNC(SYSDATE)) -- Vérifier si la période de remboursement est terminée
      AND (p.montantPret - COALESCE((SELECT SUM(op.montantOp)
                                     FROM Operation op
                                     WHERE op.natureOp = 'Debit'
                                       AND op.compte = p.compte), 0)) > 0; -- Vérifier si le montant restant dû est supérieur à zéro

--14

SELECT compte_mouvemente.numCompte, compte_mouvemente.nb_operations
FROM (
  SELECT c.numCompte, COUNT(*) AS nb_operations
  FROM Compte c, TABLE(c.operations) op
  WHERE EXTRACT(YEAR FROM deref(VALUE(op)).dateOp) = 2023
  GROUP BY c.numCompte
  ORDER BY nb_operations DESC
) compte_mouvemente
WHERE ROWNUM = 1;

---les methodes cree
--obtention du nombre de prêts dans une agence :
SELECT a.nomAgence, a.nbr_pret() AS nombre_de_prets
FROM Agence a;

-- le montant global des prêts dans une agence :
SELECT a.nomAgence, a.montant_global_pret(304) AS montant_global_des_prets
FROM Agence a
WHERE a.numAgence = 304;

-- le nombre d'agences principales dans une succursale
SELECT s.nomSucc, s.nbr_agences_principales() AS nombre_d_agences_principales
FROM Succursale s;

--la liste des agences secondaires dans une succursale qui ont des prêts de type 'ANSEJ' 
SELECT s.nomSucc, ag.nom_agence
FROM Succursale s, TABLE(s.show_agences_secondaires()) ag;
