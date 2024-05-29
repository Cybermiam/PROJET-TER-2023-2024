# Role et utilisation des scripts


## Installations préliminaires 

Pour permettre l'utilisation des scripts de génération les outils suivants doivent être installés

- Installer le framework [apache jena](https://jena.apache.org/download/) pour avoir accès aux commandes `riot` (utilitaires Jena pour lecture/écriture de fichiers RDF)

- Installer [tarql](https://github.com/tarql/tarql/releases) pour avoir accès aux commandes Tarql permettant de construire les graphes RDF à partir de fichiers `.tsv`

- Les chemins d'accès des binaires de Jena et Tarql doivent être ajoutés au PATH

  Par exemple si Jena ont été installés sous le répertoire `tools` , sous Unix dans le fichier `.bashrc` (ou `.zshrc` sous MacOS) on aura

   ```
   export PATH=$PATH:$HOME/tools/apache-jena-4.4.0/bin:$HOME/tools/tarql-1.2/bin
   ``` 


## Organistation des répertoires

**TODO** expliquer l'organisation des répertoires `data`, `scripts` et `triple_store_data`


## Scripts utilitaires

### **addNamedGraph.sh**

Ce script transforme un fichier `.ttl` (Turtle) en fichier `.trig` 
```
addNamedGraph <nom fichier turtle> <nom du graphe nommé> <nom fichier retourné>
```
```
./addNamedGraph.sh <nom fichier turtle> <nom du graphe nommé> <nom fichier retourné>
```

## Génération des données sur les brocarts

**ATTENTION** : Les fichiers `.tsv` et `.tarql` doivent avoir exactement le même nom.

### **generateData**

Le script **`generateData`** permet de générer un graphe de données RDF dans un graphe nommé (fichier `.trig`) en appliquant un script tarql à un fichier `.tsv`. Le graphe de données est créé dans un fichier `.trig` situé dans le répertoire `triple_store_data\data`


```
./generateData.sh <nom du fichier .tsv sans l'extension> <nom du graph nommé>
```

Par exemple pour générer les données RDF des sites dans un graphe nommé `borcartsData`

```
./generateData.sh sites brocartsData
```

Le graphe de données généré, `sites.trig` se trouve alors dans `triple_store_data/data`


### **generateAllData**

Ce script peremt de générer tous les fichiers `.trig` pour les données Brocarts. Pour chaque ficher `.tsv` file contenu dans le répertoire  `../inputData/data` un fichier
`.trig` correspondant est généré dans  le répertoire `../triple_store-data/data` et tous ces fichiers `.trig` sont fusionnés dans le fichier 
`../triple_store_data/brocartsData.trig` qui regroupe en un seul graphe toutes les donées des brocarts.

```
./generateAllData.sh  
```

## Génération des vocabulaires contrôlés (thesaurus SKOS)

Le nom du concept SKOS doit être significatif (exemple : si le fichier `.tsv` se nomme `qualification.tsv`, on attribuera `qualification` au nom du concept skos)

### **generateSKOS**

```
./generateVoc.sh <nom du fichier .tsv sans l'extension> <nom du concept skos>
```

### **generateThesaurus**

générer tous les fichiers SKOS pour le thesaurus concernant les brocarts et les regrouper dans un seul fichier :

```
./generateAllThesaurus.sh
```

trois fichiers sont générés dans le répertoire `triple_store_data/thesaurus directory` :
- brocartsThesaurus.ttl : un fichier turtle formatté
- brocartsThesaurus.trig : un fichier trig formatté avec `brocartsThesaurus` comme graphe nommé
- brocartsThesaurusOnto.ttl : un fichier turtle formatté sous la forme d'une ontologie OWL (ajout des triplets définissant l'ontologie)
ce fichier est aussi copié dans le répertoire `Ontologies`



