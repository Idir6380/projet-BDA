from pymongo import MongoClient
from random import randint, choice
from datetime import datetime, timedelta
# Connexion à la base de données MongoDB
client = MongoClient('mongodb://localhost:27017')
db = client['banque']
db.clients.drop()
db.comptes.drop()
db.opérations.drop()
db.prêts.drop()
db.Succursale.drop()
db.Agence.drop()
collection_succursales = db['Succursale']

# Succursales à insérer
succursales = [
    {"numSucc": 1, "nomSucc": "Succursale Alger Centre", "adresseSucc": "12 Rue Didouche Mourad, Alger", "region": "Nord"},
    {"numSucc": 2, "nomSucc": "Succursale Oran", "adresseSucc": "25 Boulevard de la Soummam, Oran", "region": "Ouest"},
    {"numSucc": 3, "nomSucc": "Succursale Constantine", "adresseSucc": "5 Rue Zighoud Youcef, Constantine", "region": "Est"},
    {"numSucc": 4, "nomSucc": "Succursale Ouargla", "adresseSucc": "8 Avenue du 1er Novembre, Ouargla", "region": "Sud"},
    {"numSucc": 5, "nomSucc": "Succursale Tizi Ouzou", "adresseSucc": "15 Boulevard Maurice Audin, Tizi Ouzou", "region": "Nord"},
    {"numSucc": 6, "nomSucc": "Succursale Sétif", "adresseSucc": "3 Rue des Frères Bouadou, Sétif", "region": "Est"}
]


# Insertion des succursales dans MongoDB
result = collection_succursales.insert_many(succursales)
print(f"Succursales insérées avec les ID : {result.inserted_ids}")

collection_agences = db['Agence']


# Agences à insérer
agences = [
    # Agences de la succursale 1
    {"numAgence": 101, "nomAgence": "Agence Alger Centre", "adresseAgence": "10 Rue Didouche Mourad, Alger", "categorie": "Principale", "numSucc": 1},
    {"numAgence": 102, "nomAgence": "Agence Bab El Oued", "adresseAgence": "5 Rue Ahmed Ouaked, Alger", "categorie": "Secondaire", "numSucc": 1},
    {"numAgence": 103, "nomAgence": "Agence Belcourt", "adresseAgence": "2 Rue Belcourt, Alger", "categorie": "Secondaire", "numSucc": 1, },
    {"numAgence": 104, "nomAgence": "Agence Bab Ezzouar", "adresseAgence": "18 Boulevard Bab Ezzouar, Alger", "categorie": "Secondaire", "numSucc": 1},
    {"numAgence": 105, "nomAgence": "Agence El Harrach", "adresseAgence": "25 Rue Hassiba Ben Bouali, El Harrach", "categorie": "Secondaire", "numSucc": 1},
    # Agences de la succursale 2
    {"numAgence": 201, "nomAgence": "Agence Oran Centre", "adresseAgence": "20 Boulevard de la Soummam, Oran", "categorie": "Principale", "numSucc": 2},
    {"numAgence": 202, "nomAgence": "Agence Oran El Mokrani", "adresseAgence": "8 Rue El Mokrani, Oran", "categorie": "Secondaire", "numSucc": 2},
    {"numAgence": 203, "nomAgence": "Agence Oran Es Senia", "adresseAgence": "5 Rue Es Senia, Oran", "categorie": "Secondaire", "numSucc": 2},
    {"numAgence": 204, "nomAgence": "Agence Oran Khemisti", "adresseAgence": "12 Boulevard Khemisti, Oran", "categorie": "Secondaire", "numSucc": 2},
    {"numAgence": 205, "nomAgence": "Agence Oran Akid Lotfi", "adresseAgence": "30 Rue Akid Lotfi, Oran", "categorie": "Secondaire", "numSucc": 2},
    # Agences de la succursale 3
    {"numAgence": 301, "nomAgence": "Agence Constantine Centre", "adresseAgence": "10 Rue Zighoud Youcef, Constantine", "categorie": "Principale", "numSucc": 3},
    {"numAgence": 302, "nomAgence": "Agence Constantine Cité Cirta", "adresseAgence": "5 Rue Cité Cirta, Constantine", "categorie": "Secondaire", "numSucc": 3},
    {"numAgence": 303, "nomAgence": "Agence Constantine Didouche Mourad", "adresseAgence": "2 Rue Didouche Mourad, Constantine", "categorie": "Secondaire", "numSucc": 3},
    {"numAgence": 304, "nomAgence": "Agence Constantine Emir Abdelkader", "adresseAgence": "18 Rue Emir Abdelkader, Constantine", "categorie": "Secondaire", "numSucc": 3},
    {"numAgence": 305, "nomAgence": "Agence Constantine Ali Mendjeli", "adresseAgence": "25 Boulevard Ali Mendjeli, Constantine", "categorie": "Secondaire", "numSucc": 3},
    # Agences de la succursale 4
    {"numAgence": 401, "nomAgence": "Agence Ouargla Centre", "adresseAgence": "20 Avenue du 1er Novembre, Ouargla", "categorie": "Principale", "numSucc": 4},
    {"numAgence": 402, "nomAgence": "Agence Ouargla El Hadjira", "adresseAgence": "8 Rue El Hadjira, Ouargla", "categorie": "Secondaire", "numSucc": 4},
    {"numAgence": 403, "nomAgence": "Agence Ouargla Touggourt", "adresseAgence": "5 Rue de Touggourt, Ouargla", "categorie": "Secondaire", "numSucc": 4},
    {"numAgence": 404, "nomAgence": "Agence Ouargla Hassi Messaoud", "adresseAgence": "12 Boulevard Hassi Messaoud, Ouargla", "categorie": "Secondaire", "numSucc": 4},
    {"numAgence": 405, "nomAgence": "Agence Ouargla El Oued", "adresseAgence": "30 Rue El Oued, Ouargla", "categorie": "Secondaire", "numSucc": 4},
    # Agences de la succursale 5
    {"numAgence": 501, "nomAgence": "Agence Tizi Ouzou Centre", "adresseAgence": "10 Boulevard Maurice Audin, Tizi Ouzou", "categorie": "Principale", "numSucc": 5},
    {"numAgence": 502, "nomAgence": "Agence Tizi Ouzou Larbaa Nath Irathen", "adresseAgence": "5 Rue Larbaa Nath Irathen, Tizi Ouzou", "categorie": "Secondaire", "numSucc": 5},
    {"numAgence": 503, "nomAgence": "Agence Tizi Ouzou Azazga", "adresseAgence": "2 Rue Azazga, Tizi Ouzou", "categorie": "Secondaire", "numSucc": 5},
    {"numAgence": 504, "nomAgence": "Agence Tizi Ouzou Ouaguenoun", "adresseAgence": "18 Rue Ouaguenoun, Tizi Ouzou", "categorie": "Secondaire", "numSucc": 5},
    {"numAgence": 505, "nomAgence": "Agence Tizi Ouzou Boghni", "adresseAgence": "25 Rue Boghni, Tizi Ouzou", "categorie": "Secondaire", "numSucc": 5},
    # Agences de la succursale 6
    {"numAgence": 601, "nomAgence": "Agence Sétif Centre", "adresseAgence": "20 Rue des Frères Bouadou, Sétif", "categorie": "Principale", "numSucc": 6},
    {"numAgence": 602, "nomAgence": "Agence Sétif Ain El Fouara", "adresseAgence": "8 Rue Ain El Fouara, Sétif", "categorie": "Secondaire", "numSucc": 6},
    {"numAgence": 603, "nomAgence": "Agence Sétif El Eulma", "adresseAgence": "5 Rue El Eulma, Sétif", "categorie": "Secondaire", "numSucc": 6},
    {"numAgence": 604, "nomAgence": "Agence Sétif Bougaa", "adresseAgence": "12 Rue Bougaa, Sétif", "categorie": "Secondaire", "numSucc": 6},
    {"numAgence": 605, "nomAgence": "Agence Sétif Ain Azel", "adresseAgence": "30 Rue Ain Azel, Sétif", "categorie": "Secondaire", "numSucc": 6},
    # ... ajouter les autres agences
]

# Insertion des agences dans MongoDB
result = collection_agences.insert_many(agences)
print(f"Agences insérées avec les ID : {result.inserted_ids}")

def generate_address():
    street_names = ['Rue 1', 'Rue 2', 'Rue 3', 'Rue 4', 'Rue 5']
    cities = ['Alger', 'Oran', 'Constantine', 'Ouargla', 'Tizi Ouzou', 'Sétif']
    return f"{randint(1, 100)} {choice(street_names)}, {choice(cities)}"


# Remplissage de la table des clients
numeros_agence = [agence["numAgence"] for agence in agences]

for i in range(1, 101):
    client_data = {
        "NumClient": i,
        "NomClient": f"Client {i}",
        "TypeClient": choice(["Particulier", "Entreprise"]),
        "AdresseClient": generate_address(),  # Supposons que vous avez une fonction generate_address() pour générer une adresse aléatoire
        "NumTel": f"06{randint(10000000, 99999999)}",
        "Email": f"client{i}@example.com",
        "NumAgence": choice(numeros_agence)
    }
    db.clients.insert_one(client_data)

# Remplissage de la table des comptes avec des opérations
clients_data = db.clients.find({}, {"NumClient": 1, "NumAgence": 1})
nb = 1
for c_data in clients_data:
    num_client = c_data["NumClient"]
    num_agence = c_data["NumAgence"]
    compte_data = {
        "NumCompte": nb,
        "dateOuverture": datetime.now(),
        "étatCompte": choice(["Actif", "Bloqué"]),
        "Solde": randint(100, 10000),
        "NumClient": num_client,
        "NumAgence": num_agence  # Numéro d'agence aléatoire
    }
    db.comptes.insert_one(compte_data)

    # Ajout des opérations (débit/crédit) pour chaque compte
    for _ in range(randint(1, 10)):
        operation_data = {
            "NumOpération": randint(1, 1000),
            "NatureOp": choice(["Crédit", "Débit"]),
            "montantOp": randint(10, 1000),
            "DateOp": datetime.now() - timedelta(days=randint(1, 365)),
            "Observation": "Opération bancaire",
            "NumCompte": nb
        }
        db.opérations.insert_one(operation_data)
    nb+=1
# Remplissage de la table des prêts (40 clients ont effectué des prêts)

comptes = db.comptes.find({}, {"NumCompte":1})

for compte in comptes:
    prêt_data = {
        "NumPrêt": randint(1000, 100000),
        "montantPrêt": randint(1000, 100000),
        "dateEffet": datetime.now() - timedelta(days=randint(1, 365)),
        "durée": choice([12, 24, 36]),
        "typePrêt": choice(["Véhicule", "Immobilier", "ANSEJ", "ANJEM"]),
        "tauxIntérêt": round(randint(1, 10) / 100, 2),
        "montantEchéance": randint(100, 10000),
        "NumCompte": compte
    }
    db.prêts.insert_one(prêt_data)

print("Base de données remplie avec succès !")