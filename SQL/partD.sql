-- 8

-- insertion des succursales
INSERT INTO Succursale VALUES (
    tsuccursale(1, 'Succursale Alger Centre', '12 Rue Didouche Mourad, Alger', 'Nord', tset_ref_agences())
);

INSERT INTO Succursale VALUES (
    tsuccursale(2, 'Succursale Oran', '25 Boulevard de la Soummam, Oran', 'Ouest', tset_ref_agences())
);

INSERT INTO Succursale VALUES (
    tsuccursale(3, 'Succursale Constantine', '5 Rue Zighoud Youcef, Constantine', 'Est', tset_ref_agences())
);

INSERT INTO Succursale VALUES (
    tsuccursale(4, 'Succursale Ouargla', '8 Avenue du 1er Novembre, Ouargla', 'Sud', tset_ref_agences())
);

INSERT INTO Succursale VALUES (
    tsuccursale(5, 'Succursale Tizi Ouzou', '15 Boulevard Maurice Audin, Tizi Ouzou', 'Nord', tset_ref_agences())
);

INSERT INTO Succursale VALUES (
    tsuccursale(6, 'Succursale Sétif', '3 Rue des Frères Bouadou, Sétif', 'Est', tset_ref_agences())
);
/

-- Succursale Alger Centre (numSucc = 1)
INSERT INTO Agence VALUES (tagence(101, 'Agence Alger Centre', '10 Rue Didouche Mourad, Alger', 'Principale', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 1), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(102, 'Agence Bab El Oued', '5 Rue Ahmed Ouaked, Alger', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 1), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(103, 'Agence Belcourt', '2 Rue Belcourt, Alger', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 1), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(104, 'Agence Bab Ezzouar', '18 Boulevard Bab Ezzouar, Alger', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 1), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(105, 'Agence El Harrach', '25 Rue Hassiba Ben Bouali, El Harrach', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 1), tset_ref_comptes()));

-- Succursale Oran (numSucc = 2)
INSERT INTO Agence VALUES (tagence(201, 'Agence Oran Centre', '20 Boulevard de la Soummam, Oran', 'Principale', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 2), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(202, 'Agence Oran El Mokrani', '8 Rue El Mokrani, Oran', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 2), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(203, 'Agence Oran Es Senia', '5 Rue Es Senia, Oran', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 2), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(204, 'Agence Oran Khemisti', '12 Boulevard Khemisti, Oran', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 2), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(205, 'Agence Oran Akid Lotfi', '30 Rue Akid Lotfi, Oran', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 2), tset_ref_comptes()));

-- Succursale Constantine (numSucc = 3)
INSERT INTO Agence VALUES (tagence(301, 'Agence Constantine Centre', '1 Rue Zighoud Youcef, Constantine', 'Principale', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 3), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(302, 'Agence Constantine El Kantara', '8 Rue El Kantara, Constantine', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 3), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(303, 'Agence Constantine Ziadia', '15 Rue Ziadia, Constantine', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 3), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(304, 'Agence Constantine Sidi Mabrouk', '22 Boulevard Sidi Mabrouk, Constantine', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 3), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(305, 'Agence Constantine Ibn Badis', '3 Rue Ibn Badis, Constantine', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 3), tset_ref_comptes()));

-- Succursale Ouargla (numSucc = 4)  
INSERT INTO Agence VALUES (tagence(401, 'Agence Ouargla Centre', '8 Avenue du 1er Novembre, Ouargla', 'Principale', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 4), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(402, 'Agence Ouargla Mibker', '15 Rue des Frères Bekkar, Ouargla', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 4), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(403, 'Agence Ouargla Rouiba', '20 Rue Rouiba, Ouargla', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 4), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(404, 'Agence Ouargla El Fedjoudj', '5 Boulevard El Fedjoudj, Ouargla', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 4), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(405, 'Agence Ouargla Hai Ennasr', '10 Rue Hai Ennasr, Ouargla', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 4), tset_ref_comptes()));

-- Succursale Tizi Ouzou (numSucc = 5)
INSERT INTO Agence VALUES (tagence(501, 'Agence Tizi Ouzou Centre', '10 Boulevard Maurice Audin, Tizi Ouzou', 'Principale', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 5), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(502, 'Agence Tizi Ouzou Haoucine', '2 Rue Haoucine, Tizi Ouzou', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 5), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(503, 'Agence Tizi Ouzou Bougie', '18 Boulevard Bougie, Tizi Ouzou', 'Secondaire', (SELECT REF(s) FROM Succursale s WHERE s.numSucc = 5), tset_ref_comptes()));
-- Succursale Sétif (numSucc = 6)
INSERT INTO Agence VALUES (tagence(601, 'Agence Sétif Centre', '3 Rue des Frères Bouadou, Sétif', 'Principale',(SELECT REF(s) FROM Succursale s WHERE s.numSucc = 6), tset_ref_comptes()));
INSERT INTO Agence VALUES (tagence(602, 'Agence Sétif El Hidhab', '25 Rue Larbi Ben Mhidi, Sétif', 'Secondaire',(SELECT REF(s) FROM Succursale s WHERE s.numSucc = 6), tset_ref_comptes()));

-- mise a jour de l attribut agences dans la table succursale 

insert into table (select s.agences from Succursale s where numSucc=1)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=1));

insert into table (select s.agences from Succursale s where numSucc=2)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=2));

insert into table (select s.agences from Succursale s where numSucc=3)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=3));

insert into table (select s.agences from Succursale s where numSucc=4)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=4));

insert into table (select s.agences from Succursale s where numSucc=5)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=5));

insert into table (select s.agences from Succursale s where numSucc=6)
(select ref(a) from Agence a where  a.succursale=(select ref(s) from Succursale s where numSucc=6));