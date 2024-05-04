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
