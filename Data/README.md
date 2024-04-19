## Brocarts Graph

Ce répertoire contient différents outils pour générer les graphes de données pour les brocarts appliqués. Le contenus de ce répertoire est le suivant (dans l'ordre alphabétique) :

- `input_data` ce repertoire contient les fichiers `.tsv` (fichiers excel avec des tabulations comme séparateur) utilisés pour générer les graphes de données. Il est décomposé en deux sous répertoires :
  - `data` : ce répertorie contient les données concernant les brocarts et issues du catalogue établi par Florian.
  - `thesaurus` : ce répertoire contient les différents vocabulaires controlés (vocabulaires SKOS) qui permettent de qualifier les données. Ces vocabulaires ont été élaborés à partir d'un glossaire construit en collaboration avec Florain et Arianne. Ce [glossaire](https://docs.google.com/document/d/1joUeRk7WDs4kMArM69eCwlnpXMuNmPDObUsoyNhZf1k/edit?usp=sharing) est un document de travail (draft) sur google drive définissant les concepts et le vocabulaire associés aux brocarts.
- `ontologies` : ce répertoire regroupe les différentes ontologies utilisées pour définir un modèle de données pour les brocarts.
- `scripts` ce répertoire contient les scripts de génération des données. Ces scripts utilisent:
  - [**tarql**](https://tarql.github.io/) pour générer un fichier turtle à partir des fichiers **.tsv**,
  - **sed** pour générer les fichiers **.trig** à partir des fichiers turtle,
  - [**riot**](https://jena.apache.org/documentation/io/#command-line-tools) du framework [Apache Jena](https://jena.apache.org/) pour concatener les fichiers **.trig** en un seul fichier
- `tarql` ce répertoire contient les scripts tarql pour la génération des données.
- `triple_store_data` ce répertoire contient les fichiers **.trig** générés à importer dans le triple store (GraphDB). Ce répertoire contient :
  - un répertoire `data` qui contient les fichiers **.trig** correspondant aux données,




