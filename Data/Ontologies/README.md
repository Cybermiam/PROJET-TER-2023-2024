# Ontologies

Ce répertoire contient les différentes ontologies utilisées por modéliser les données des brocarts. 

**ATTENTION : c'est un travail en cours loin d'être finalisé.**

## Contenu du répertoire **ontologies**

Le contenu de ce répertoire est (dans l'ordre alphabétique)

- **brocartsonto.ttl** : une ontologie utilisée pour modéliser les brocarts dans le cadre du projet étudiants du M1 IC (Marine Troccaz, Nicolas Girardier et Zhenyu Liu). Cette ontologie n'est pas du tout complète.

l'ontologie **brocartsonto.ttl** utilise (importe) les ontologies suivantes

- **brocartsThesaurus.ttl** qui définit à l'aide SKOS un vocabulaire contrôlé dont les termes servent de valeurs à certaines des propriétés des entités (classes) définies dans l'ontologie **brocartsonto.ttl**

- **partimalpOnto.ttl** : une ontologie owl définissant le modèle de données général de partimalp et à laquelle on rattachera le modèle de données spécifique au brocarts (actuellement ce modèle est défini dans **brocartsonto.ttl**, le travail en cours avec Fatima va être de faire converger ces différentes ontologies en s'appuyant sur [FORT](https://github.com/DanashFatima/FORT/
)).

PagtrimalpOnto utilise les ontologies suivantes
- **geo.ttl** : l'ontologie [GeoSPARQL 1.1](https://opengeospatial.github.io/ogc-geosparql/geosparql11) sur laquelle on s'appuie pour modéliser les entités géographiques de patrimalp (site patrimoniaux : églises, musées, forts, sites archéologiques...).
- **simple_features_geometries.rdf** : ontologie utilisée en association avec GeoSPARL pour définir les géométries des entités géographiques. Elle se base sur la norme OGC-ISO 19125 [Simple Feature Access](https://www.ogc.org/standards/sfa).


## Préfixes utilisés

```
@prefix :            <http://patrimalp.org/graph/> .
@prefix brocartso:   <http://patrimalp.org/brocarts/onto#> .
@prefix brocartsr:   <http://patrimalp.org/brocarts/resource/> .
@prefix brocartsvoc: <http://patrimalp.org/brocarts/thesaurus#> .
@prefix geo:         <http://www.opengis.net/ont/geosparql#> .
@prefix owl:         <http://www.w3.org/2002/07/owl#> .
@prefix patrimalpo:  <http://patrimalp.org/ontologies/patrimalp#> .
@prefix patrimalpr:  <http://patrimalp.org/resource/> .
@prefix rdf:         <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .
@prefix wikidata:    <https://www.wikidata.org/entity/> .
@prefix xsd:         <http://www.w3.org/2001/XMLSchema#> .
```

- ****@prefix : <http://patrimalp.org/graph/>**** : préfixe utilisé pour les nom des graphes nommés 
     (**brocartsThesaurus** pour le thésaurus contrôlant le vocabulaire permettant des qualifier les brocarts ,
      **brocartsData** pour les données spécifiques aux brocarts)

- ****@prefix brocartso:   <http://patrimalp.org/brocarts/onto#>**** : préfixe utilisé pour les concepts (classes, propriétés) 
     définis dans l'ontologie OWL des brocarts (**brocartsonto.ttl**)

- ****@prefix brocartsr:   <http://patrimalp.org/brocarts/resource/>**** : préfixe utilisé pour les ressources concernant les brocarts

- ****@prefix patrimalpo:  <http://patrimalp.org/ontologies/patrimalp#>**** : préfixe utilisé pour les concepts (classes, propriétés) 
     définis dans l'ontologie générale (Top Level Ontology) OWL patrimalp (**patrimalpOnto.ttl**)

- ****@prefix patrimalpr:  <http://patrimalp.org/resource/>**** : préfixe utilisé pour les ressources pouvant être partagées dans différents sous projets de Patrimalp (par exemple les sites)

Les autres prefixes sont des préfixes standards (**geo:** pour les concepts de l'ontologie GeoSPARQL, **owl:** pour l'ontologie définissant le langage OWL, etc.')