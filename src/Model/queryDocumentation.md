# Documentation du module de requètes

## Objectif

Ce module représente le lien entre l'application et la base de données, il s'agit d'une classe

## Relations avec d'autres modules
 
- Lien avec la base de donnée graphdb
- Lien avec le front-end

## Dépendances du module

- Le module dépend de la base de données graphdb, qui doit être remplie et allumée
- L'ensemble du front-end dépend de ce module

## Types

- URL : String => L'Url de connexion a la base de données, fourni lors de l'instantiation de la classe

## Fonctions

- constructor(string : url) => constructeur de la classe
- query(string : query) => envoie la requète query à la base de donnée, et retourne des données au format JSON. Fonction asynchrone pour les connexions externes. Contient aussi les paramètres avec lesquels on envoie la requète
- enumPropertyQueryBuilder(type) => retourne la requète pour récuperer les elements de type énumération connectés au type passé en paramètres (ex : Sculpture) au format string.
- dataPropertyQueryBuilder(type) => retourne la requète pour récuperer les elements de type littéral connectés au type passé en paramètres (ex : Sculpture) au format string.
- resultQueryBuilder(type, filtersMap) => utilise le type de données souhaité en sortie et une map des filtres selectionnés dans le front-end au format (propriété : string -> valeurs : string[]) pour former une requête sparql permettant d'obtenir les résultats des filtres dans la base de données (equivalent d'une fonction search)
- getLabelFromUri(uri) => avec une uri au format string du type "http://patrimalp.org/brocarts/thesaurus#exemple", permet de récuperer le label exemple.
- getAllfilters(types) => asynchrone; prend en paramètres l'ensemble des types contenus dans la base de données, ceci étant configuré au préalable, puis formule une map (format décrit ci-après) contenant tout les types -> propriétés -> valeurs necessaires au fonctionnement des filtres. 


⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇\
FORMAT DE LA MAP DE SORTIE

```Map<type : string, properties : Map<property : string , values :{label : string, value : string}[]>>```

l'objectif est de stocker les données au format attendu par vueJS pour l'affichage dans le frontend (par exemple, un élément n-select de vue demande un object pour ses options, présent au plus bas de l'élément map)

plus visuellement : 
<pre>
map -> nom du type
    -> map des propriétés du type -> nom de la propriété
                                  -> tableau d'objets   -> label de la valeur
                                                        -> valeur (égale au  label pour le traitement)
</pre>
