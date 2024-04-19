# Role et utilisation des scripts

**AVERTISSEMENT** Cette documentation reprend la documentation rédigée par Marine Troccaz dans le [wiki](https://gricad-gitlab.univ-grenoble-alpes.fr/patrimalp/patrimalp/-/wikis/Explication-des-scripts) pour le projet de M1-WIC mené lors de l'année 2021/2022. Cette documentation est très succinte, n'est pas nécessairement à jour. Elle devra être corrigée et complétée.


## Installations préliminaires 

Pour permettre l'utilisation des scripts de génération les outils suivants doivent être installés

- Installer le framework [apache jena](https://jena.apache.org/download/) pour avoir accès aux commandes `riot` (utilitaires Jena pour lecure/écriture de fichiers RDF)

- Installer [tarql](https://github.com/tarql/tarql/releases) pour avoir accès aux commandes Tarql permettant de construire les graphes RDF à partir de fichiers `.tsv`

- Les chemins d'accès doivent des binaires de Jena et Tarql être ajoutés au PATH

  Par exemple si Jena ont été installés sous le répertoire `tools` , sous Unix dans le fichier `.bashrc` (ou `.zshrc` sous MacOS) on aura

   ```
   export PATH=$PATH:$HOME/tools/apache-jena-4.4.0/bin:$HOME/tools/tarql-1.2/bin
   ``` 


## Organistation des répertoires

**TODO** expliquer l'organisation des répertoires `data`, `scripts` et `triple_store_data`


## Scripts utilitaires

### **ttl2trig**

Ce script transforme un fichier `.ttl` en fichier `.trig` 
```
ttl2trig <nom fichier turtle> <nom du graphe nommé> <nom fichier retourné>
```
```
./ttl2trig.sh <nom fichier turtle> <nom du graphe nommé> <nom fichier retourné>
```

## Génération des données sur les brocarts

Les fichiers `.tsv` et `.tarql` doivent avoir le même nom

### **generateData**

Le script **`generateData`** permet de générer un graphe de données RDF dans un graphe nommé (fichier `.trig`) en appliquant un script tarql à un fichier `.tsv`. Le graphe de données est créé dans un fichier `.trig` situé dans le répertoire `triple_store_data\data`

sous Windows :
```
generateData <nom du fichier .tsv sans l'extension> <nom du graph nommé>
```

sous Unix
```
./generateData.sh <nom du fichier .tsv sans l'extension> <nom du graph nommé>
```

Par exemple pour générer les données RDF des sites dans un graphe nommé `borcartsData`

sous Windosw :
```
generateData sites brocarsData
```

sous Unix
```
./generateData.sh sites brocartsData
```

Le graphe de données généré, `sites.trig` se trouve alors dans `triple_store_data/data`


### **generateAllData**

Ce script peremt de générer tous les fichiers `.trig` pour les données Brocarts. Pour chaque ficher `.tsv` file contenu dans le répertoire  `../inputData/data` un fichier
`.trig` correspondant est généré dans  le répertoire `../triple_store-data/data` et tous ces fichiers `.trig` sont fusionnés dans le fichier 
`../triple_store_data/brocartsData.trig` qui regroupe en un seul graphe toutes les donées des brocarts.

```
generateAllData (Windows)
```
```
./generateAllData.sh (Unix-like) 
```

## Génération des vocabulaires contrôlés (thesaurus SKOS)

Le nom du concept SKOS doit être significatif (exemple : si le fichier `.tsv` se nomme `qualification.tsv`, on attribuera `qualification` au nom du concept skos)

### **generateVoc**

générer un fichier SKOS à partir d'un fichier `.tsv` :
```
generateVoc <nom du fichier .tsv sans l'extension> <nom du concept skos>
```

```
./generateVoc.sh <nom du fichier .tsv sans l'extension> <nom du concept skos>
```

### **generateVoc**

générer tous les fichiers SKOS pour le thesaurus concernant les brocarts :
```
generateAllVoc
```
```
./generateAllVoc.sh
```


