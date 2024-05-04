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
WHERE numCompte = 1180005564
AND EXTRACT(YEAR FROM deref(VALUE(op)).dateOp) = 2023
AND deref(VALUE(op)).natureOp = 'Credit';



SELECT numCompte
FROM COMPTE C, TABLE(C.OPERATIONS) op
WHERE numCompte = 3023540212
AND EXTRACT(YEAR FROM deref(VALUE(op)).dateOp) = 2023
AND deref(VALUE(op)).natureOp = 'Credit';