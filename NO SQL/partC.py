from datetime import datetime
from pymongo import MongoClient


client = MongoClient('mongodb://localhost:27017')
db = client['banque']

#récupération des prêts effectués au sein de l'agence ayant le numéro d'agence 102
agence_102_prêts = list(db.prêts.find({"NumCompte": {"$in": db.comptes.find({"NumAgence": 102}).distinct("NumCompte")}}, {"NumPrêt":1}))

#affichage des prêts
print(f"{len(agence_102_prêts)} prêts effectués à l'agence 102 :")
for prêt in agence_102_prêts:
    print(f"Numéro de prêt : {prêt['NumPrêt']}")
    print("-------------------------")

"""Afficher tous prêts effectués auprès des agences rattachées aux succursales de la région
« Nord ». Préciser NumPrêt, NumAgence, numCompte, numClient et MontantPrêt.
"""
#recuperer les numSucc nord
succursales_nord = db.Succursale.find({"region": "Nord"}, {"_id":0,"numSucc":1})
succursales_nord = [succ["numSucc"] for succ in succursales_nord]
#recuperer les numAgence relié à ces succursale
agences_nord = db.Agence.find({"numSucc": {"$in": succursales_nord}}, {"numAgence": 1})
agences_nord = [agence["numAgence"] for agence in agences_nord]
#recuperer les num de comptes associes a ses agences
comptes_nord = db.comptes.find({"NumAgence": {"$in": agences_nord}}, {"NumCompte": 1})
comptes_nord = [compte["NumCompte"] for compte in comptes_nord]
#recuperer les prets associes a ces comptes
prêts_nord = db.prêts.find({"NumCompte": {"$in": comptes_nord}}, {"NumPrêt": 1, "NumAgence": 1, "NumCompte": 1, "NumClient": 1, "montantPrêt": 1})
print("Prêts effectués auprès des agences rattachées aux succursales de la région Nord :")
for prêt in prêts_nord:
    # Récupération du numéro d'agence et numéro Client associés au compte du prêt
    compte = db.comptes.find_one({"NumCompte": prêt["NumCompte"]})
    num_agence = compte["NumAgence"]
    num_client = compte["NumClient"]
    print(f"Numéro de prêt : {prêt['NumPrêt']}, Numéro d'agence : {num_agence}, Numéro de compte : {prêt['NumCompte']}, Numéro de client : {num_client}, Montant du prêt : {prêt['montantPrêt']} DA")

"""
Récupérer dans une nouvelle collection Agence-NbPrêts, les numéros des agences et le
nombre total de prêts, par agence ; la collection devra être ordonnée par ordre décroissant
du nombre de prêts. Afficher le contenu de la collection.
"""
pipeline = [
    #grouper les documents de prêts par leur champ NumCompte et calculer le nombre total de prêts pour chaque compte 
    {"$group": {"_id": "$NumCompte", "totalPrêts": {"$sum": 1}}},
    #joindre les documents de prêts avec ceux de comptes pour récupérer le numéro d'agence de chaque compte
    {"$lookup": {"from": "comptes", "localField": "_id", "foreignField": "NumCompte", "as": "compte_info"}},
    #permet de travailler avec chaque document individuellement par la suite.
    {"$unwind": "$compte_info"},
    #projeter les champs NumAgence et totalPrêts
    {"$project": {"NumAgence": "$compte_info.NumAgence", "totalPrêts": 1}},
    #regrouper les documents par NumAgence et calculer le nombre total de prêts 
    {"$group": {"_id": "$NumAgence", "totalPrêts": {"$sum": "$totalPrêts"}}},
    #trier les résultats par ordre décroissant du nombre total de prêts.
    {"$sort": {"totalPrêts": -1}},
    #projeter les champs NumAgence et totalPrêts
    {"$project": {"_id": 0, "NumAgence": "$_id", "totalPrêts": 1}}
]

result = db.prêts.aggregate(pipeline)

# inserer le résultat dans une nouvelle collection
db.Agence_NbPrêts.drop()  # supprimer la collection si elle existe déja
db.Agence_NbPrêts.insert_many(result)

print('liste de prets par agence:')
# afficher le contenu de la collection
for agence in db.Agence_NbPrêts.find({}, {"_id":0}):
    print(f'agence:{agence["NumAgence"]}: {agence["totalPrêts"]} prets')

"""
Dans une collection Prêt-ANSEJ, récupérer tous les prêts liés à des dossiers ANSEJ.
Préciser NumPrêt, numClient, MontantPrêt et dateEffet.
"""
# Récupérer les prêts liés à des dossiers ANSEJ
prêts_ANSEJ = db.prêts.find({"typePrêt": "ANSEJ"})
# Afficher les informations des prêts liés à des dossiers ANSEJ
print("prêts liés à des dossiers ANSEJ :")
for prêt in prêts_ANSEJ:
    print(f"Numéro de prêt : {prêt['NumPrêt']}, Numéro de client : {prêt['NumCompte']}, Montant du prêt : {prêt['montantPrêt']} DA, Date d'effet : {prêt['dateEffet']}")

"""
Afficher tous les prêts effectués par des clients de type « Particulier ». On affichera le NumClient, NomClient, NumPrêt, montantPrêt.
"""




#recuperation des prêts des clients de type "Particulier"
print('prêts effectués par des clients de type "Particulier"')
prets = db.prêts.aggregate([
    {
        '$lookup': {
            'from': 'comptes',
            'localField': 'NumCompte',
            'foreignField': 'NumCompte',
            'as': 'compte'
        }
    },
    {
        '$unwind': '$compte'
    },
    {
        '$lookup': {
            'from': 'clients',
            'localField': 'compte.NumClient',
            'foreignField': 'NumClient',
            'as': 'client'
        }
    },
    {
        '$unwind': '$client'
    },
    {
        '$match': {
            'client.TypeClient': 'Particulier'
        }
    },
    {
        '$project': {
            'NumClient': '$client.NumClient',
            'NomClient': '$client.NomClient',
            'NumPrêt': 1,
            'montantPrêt': 1
        }
    }
])

"""
Nous utilisons l'agrégation avec la méthode aggregate pour effectuer des opérations de jointure entre les collections prêts, comptes et clients.
Le premier $lookup permet de joindre les données des comptes avec les prêts correspondants.
Le $unwind permet de dé-normaliser le tableau compte pour chaque document.
Le deuxième $lookup permet de joindre les données des clients avec les comptes correspondants.
Le deuxième $unwind permet de dé-normaliser le tableau client pour chaque document.
Le $match filtre les documents pour ne garder que ceux où le client est de type "Particulier".
Le $project sélectionne les champs à inclure dans le résultat final (NumClient, NomClient, NumPrêt, montantPrêt).
Enfin, nous itérons sur les résultats et affichons les informations demandées.
"""
# afficher les résultats
for pret in prets:
    print(f"NumClient: {pret['NumClient']}, NomClient: {pret['NomClient']}, NumPrêt: {pret['NumPrêt']}, montantPrêt: {pret['montantPrêt']}")

"""
Augmenter de 2000DA, le montant de l’échéance 
de tous les prêts non encore soldés, dont la date
 d’effet est antérieure à (avant) janvier 2021.
"""
date_reference = datetime(2021, 1, 1)
# Récupérer les prêts non soldés dont la date d'effet est antérieure à janvier 2021
prêts_non_soldés = db.prêts.find({
    "dateEffet": {"$lt": date_reference},  # Date d'effet antérieure à janvier 2021
    "montantEchéance": {"$exists": True},  # Vérifier si le montant d'échéance existe
    "montantEchéanceSoldé": {"$exists": False}  # Vérifier si le prêt n'est pas encore soldé
})
# Parcourir les prêts et mettre à jour le montant de l'échéance
for prêt in prêts_non_soldés:
    # Récupérer le montant d'échéance actuel
    montant_echéance_actuel = prêt["montantEchéance"]
    
    # Calculer le nouveau montant d'échéance en ajoutant 2000 DA
    nouveau_montant_echéance = montant_echéance_actuel + 2000
    
    # Mettre à jour le montant d'échéance dans la base de données
    db.prêts.update_one(
        {"_id": prêt["_id"]},  # Identifier le prêt par son ID
        {"$set": {"montantEchéance": nouveau_montant_echéance}}  # Mettre à jour le montant d'échéance
    )

print("Montant de l'échéance des prêts non encore soldés, antérieurs à janvier 2021, augmenté avec succès de 2000 DA.")

"""
Avec votre conception, peut-on répondre à la requête suivante : Afficher toutes les
opérations de crédit effectuées sur les comptes des clients de type « Entreprise » pendant
l’année 2023. Justifiez votre réponse.S
"""
#recuperation des numeros de clients de type "Entreprise"
clients_entreprise = db.clients.find({"TypeClient": "Entreprise"}, {"NumClient": 1, "_id": 0})
numeros_clients_entreprise = [client["NumClient"] for client in clients_entreprise]

#recuperation des numeros de comptes correspondants
numeros_comptes_entreprise = [compte["NumCompte"] for compte in db.comptes.find({"NumClient": {"$in": numeros_clients_entreprise}}, {"NumCompte": 1, "_id": 0})]

#recuperation des opérations de crédit de l'année 2023
debut_2023 = datetime(2023, 1, 1)
fin_2023 = datetime(2023, 12, 31)
operations_credit_2023 = db.opérations.find({
    "NatureOp": "Crédit",
    "DateOp": {"$gte": debut_2023, "$lte": fin_2023},
    "NumCompte": {"$in": numeros_comptes_entreprise}
})

print('les opérations de crédit effectuées sur les comptes des clients de type « Entreprise » pendantl’année 2023.')
# Afficher les opérations
for operation in operations_credit_2023:
    print(operation)