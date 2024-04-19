# Pour utiliser les scripts sous MacOS

Les scripts pour générer les fichiers **.trig** utilisent le programme de traitement de flux de texte en ligne de commande **sed** disponible en standard sous unix.

Cependant, si  **sed** est lui aussi fourni par défaut sur macOS, certaines fonctionnalités avancées de **sed** 
ne sont pas disponibles dans la version fournie avec macOS alors qu'elles sont présentes sur linux. Pour pallier cela, pour pouvoir utiliser les 
scripts sur macOS vous devez installer GNU sed (ou **gsed**) qui est une version étendue de **sed** avec des fonctionnalités supplémentaires.

Pour information, voici quelques différences notables entre **sed** et gsed sur macOS :

 - **Syntaxe étendue** : gsed prend en charge une syntaxe légèrement différente pour certaines commandes et options par rapport à sed. Par exemple, l'utilisation de l'option `-i`  pour modifier les fichiers en place nécessite un argument sur macOS sed (-i '')` alors que **gsed utilise** simplement `-i`.

 - **Commandes avancées** : **gsed** offre des fonctionnalités supplémentaires par rapport à **sed**. Par exemple, **gsed** permet l'utilisation d'expressions régulières étendues (ERE) avec l'option `-r` pour simplifier les motifs de recherche et de remplacement complexes.

 - **Syntaxe de l'adresse de plage** : **gsed** prend en charge une syntaxe alternative pour spécifier des adresses de plage, ce qui facilite la sélection de plusieurs lignes dans un fichier. Par exemple, `1,3d` supprime les lignes de 1 à 3 avec **gsed**, tandis que `1,3d` est interprété différemment par **sed** sur macOS.

Pour installer GNU sed (**gsed**) sur macOS, vous pouvez utiliser Homebrew, un gestionnaire de paquets populaire pour macOS. Voici comment l'installer :

Ouvrez Terminal, puis exécutez la commande suivante pour installer Homebrew :

```
bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Une fois Homebrew installé, exécutez la commande suivante pour installer gsed :
```
brew install gnu-sed
```

Une fois l'installation terminée, vous pouvez utiliser **gsed** comme une commande distincte pour bénéficier de ses fonctionnalités étendues.

# Problème pour utiliser les scripts sous WSL

En cas d'erreur dans l'exécution d'un script

```
------- [ generateAllVoc.sh] -------
---- Deleting old TriG files:
---- Currently modifying: appareilAnalyse
./generateAllVoc.sh: ./generateVoc.sh: /bin/bash^M: bad interpreter: No such file or directory
        Error: failed to generate data for appareilAnalyse
```
exécuter la commande 

```
dos2unix ./generateVoc.sh
dos2unix: converting file ./generateVoc.sh to Unix format...
```
Pour être sûr que tous le fichiers script sont au format Unix et non Windows

```
dos2unix *.sh
dos2unix: converting file ./generateVoc.sh to Unix format...
```
