# Documentation interne - Module front-end SRC

## Objectifs

Ce module comprend l'ensemble du front-end de l'application, mais sert aussi à la récupération des données (voir dossier Modèle)

## Relations avec d'autres modules

- Récupère les données depuis le fichier "Model/sparqlJsQuery.js"

## Dépendances du module

!!! AVANT MISE A JOUR !!!

- Necessitait toute la partie back-end contenant les classes java, cette partie était l'ancienne api pour communiquer avec graphdb
- Necessitait de certaines parties du second projet PatrimalCoreExplorer (notamment pour l'installation)

!!! APRES MISE A JOUR !!!

- Necessite la base de donnée active et le ficher Modèle/sparqlJsQuery
- Necessite l'ensemble des fichiers de configuration créés par npm dans les dossiers ../node_modules et ../*
- Necessite le fichier ../index.html qui est le contenant principal de toutes les vues

## Sous modules 

Cette section contient la spécification des classes Vue / JS / TS codées, elle sera mise a jour au fur et a mesure des ajouts de fonctions dans les classes

Les classes vue sont des composants visuels,
Les classes ts sont les composants d'initialisation

### AffichageResultats.vue

Composant affichant la liste des résulats de requètes sparql dépendant des composants tels que Filters, Sparnatural ...

#### Variables

- Query : Objet pour l'execution de requêtes
- filtersMap : Map contenant tout les filtres selectionnés dans la vue Filters.vue
- firstType : variable correspondant au type de données a afficher (par exemple des sculptures)
- result : contient le resultat de la requête

#### Fonctions

- update() : génère la requête correspondat aux filtres présents dans filtersMap avec la classe query puis l'execute, associe le resultat a la variable result

- envoieAffichage(element) : element est un des label sur lequel l'utilisateur a cliqué, envoie a la classe supérieure un évenement avec cet élément qui sera affiché dans un autre composant

### App.vue

> [!NOTE]  
> Classe de l'ancienne version du logiciel, n'est plus utilisée.

### Carte.vue

> [!NOTE]  
> En cours de développement, a compléter

#### Types
- req permet de récupérer la requete getCoordonnees en elle même, il est de type any pour l'instant
- results permet de récupérer les résultats de la requête getCoordonnees, il est de type any pour l'instant
- tabPoints est définit d'abord comme un tableau vide qui doit contenir les attributs type, geometry et properties qui correspondent à la stucture de GeoJson. Cette variable correspondra à la structure de Geoson et sera envoyé directement au template pour faire afficher les points.
- chargement est un boolean qui permet d'afficher la carte seulement lorsque la fonction execution est terminé.


#### Fonctions
- execution est une fonction qui récupère et exécute la requête getCoordonnees. Les resulats sont ensuite transformer en map pour récupérer la valeur du label (nom du site) et la valeur des coordonnées en format geoJson. Ensuite, Tabpoints est définit pour permettre de construire concrètement la structure GeoJson. Dans les properties, on fixe l'attribut 'name' avec le label du site. Afin de récupérer par la suite d'autres propriétés du site, celles ci pourront être déclarer lors de la création de tabPoints.

- onReady est une fonction qui permet d'ajouter un pop lors du click sur le marqueur. Il permet d'afficher le nom du site grâce à layer.feature.properties.name. Lors du click, un évenement est aussi ajouter pour faire un emit de propertyChanged avec le nom du site. Ceci permet d'afficher directement les infos du site dans le composant InfoOeuvre.

### Filters.vue

Ce composant à pour rôle de présenter les différents types, propriétés et valeurs contenus dans la base de données sous forme de filtres a selectionner. Il constitue par la suite une map contenant les différents filtres selectionnés, envoyée aux autres composants à chaque mise a jour d'un filtre.  

#### Types

- query : Objet pour l'execution de requêtes
- types : Contient une liste de types, définie de manière fixe dans la classe mainTest.ts, avec leurs uri et leurs noms
- filtersDisplayMap : Contient l'ensemble des filtres selectionnés, utilisé pour les afficher et pour les transmettre aux autres composants
- testVisible : A vérifier, semble ne plus servir
- options : Contient les noms des types pour le selecteur de types
- allDataMap : Map contenant l'ensemble des données pour les filtres (types, propriétés, valeurs)
- firstType : variable correspondant au type de données a afficher (par exemple des sculptures)
- remainingTypes : liste des types excluant le premier selectionné, pour les requêtes multi types, non utilisé pour le moment
- isFirstTypeSelected : booléen indiquant si un type a été selectionné pour afficher le choix des filtres associés


#### Fonctions

- getAllFilters() : Cette fonction récupère tous les types dans un tableau de string et demande à la classe sparqlJsQuery une map contenant toutes les données pour les filtres, stockée dans la variable allDataMap.
- getTypesObjectsForFirstType() : Construit un tableau d'objets avec les types pour le selecteur du premier type.
- firstTypeSelected(value: string) : s'execute quand l'utilisateur choisis un premier type, fixe les types restants non selectionnés,  fixe le type selectionné, et envoie au compopsant SideMenu ce type.
- onPropertyUpdate(property: string, options : SelectOption[]) : exécuté lorsque l'utilisateur met a jour un filtre pour une propriété, met à jour la map filtersDisplayMap avec l'ensemble des filtres selectionnés, puis envoie au composant SideMenu cette map et le Type selectionné. 
- handleTypeCheckboxUpdate(value: string) : Fonction non utilisée pour le moment, permet de gérer les affichage des types restants, rend visible les propriétés des types selectionnés.

### Graphe.vue

> [!NOTE]  
> Partie non développée pour le moment, doc à mettre à jour.

#### Fonction


### Home.vue

Page d'acceuil, ne possède pas de types ou de fonctions


### InfoRessource.vue

Ce composant permet d'afficher les informations d'une seule ressource de manière claire.

#### Types

- query : Objet pour les requêtes sparql
- labelRecherche : Label de la ressource cherchée
- firstType : Type de la ressource
- result : Variable contenant le resultat de la requête sparql
- mapToDisplay : Map contenant les informations de la ressource demandée


#### Fonctions

- ressourceRequest() : Avec le label reçu de SideMenu lors d'evenements comme un clic sur une ressource dans la liste des résulats ou un clic sur une icone sur la carte, enregistrés avec watchEffect(), réalise la requête demandant les infos sur la ressource et les stocke dans mapToDisplay. 


### main.ts

> [!NOTE]  
> Classe de l'ancienne version du logiciel, n'est plus utilisée.

### Main.vue

Ce composant est le premier appelé par mainTest, il contient la définition de l'objet pour la bdd, et contient le composant SideMenu.

#### Types

explorer : ne plus utiliser
types : tableau contenant les types et leurs URI
query : Objet sparqlJsQuery permettant défini avec l'url de la base de données


### mainTest.ts

Ce composant est appelé par le fichier ../index.html et créé l'application avec les types passés en paramètre.

#### Types

explorer : ne plus utiliser
types : Définition des types utilisés dans l'application. Si des types sont ajoutés dans la base de données, il est nécessaire de mettre a jour cette liste.

#### Fonctions

createApp : créé l'application avec le composant Main, dans la div d'ID #app du fichier ../index.html.

### SideMenu.vue

#### Objectifs

Un composant sélectionné dans le menu est un composant qui est affiché sur le reste de l'écran. Plusieurs composants peuvent être affichés en même temps grâce aux Split mis en place. Chaque item du menu correspond à un composant Vue.


En premier lieu, l'item Accueil (ou home) est le seul sélectionné par défaut. Lorsqu'un item autre que home est cliqué, le composant Accueil est désélectionné. Ainsi, l'accueil est fermé et le composant sélectionné s'affiche sur l'écran.


On peut afficher jusqu'à 4 composants en même temps pour une question de lisibilité. Si on tente d'afficher un cinquième composant, un pop-up est déclenché pour indiquer à l'utilisateur qu'il faut désélectionner au moins un composant s'il veut afficher le composant sur lequel il a cliqué.


Si on clique sur Accueil alors que d'autres items sont sélectionnés dans le menu, ceux-ci sont désélectionnés afin de laisser seulement l'accueil sélectionné. De plus, si tous les composants sont désélectionnés dans le menu, alors l'item Accueil est sélectionné automatiquement pour ne pas laisser un écran vide.

#### Types

- visibleCompo est un objet réactif dont les attributs sont de type string : boolean. Sa clé doit être égale à la clé de son composant dans MenuOption. Celui-ci va servir à savoir quels sont les composants actifs ou non en fonction de true/false.

- visibleCount est une fonction réactive qui permet de compter le nombre de composants actifs (les valeurs de visibleCompo sont à true) à chaque fois que visibleCompo change.

- visibleCompoListe est une variable réactive qui retourne la liste des composants actifs. Pour ce faire, elle parcourt toutes les clés de visibleCompo qui sont true. En fonction de la clé, elle ajoute un objet qui contient trois éléments : compo, props et event. Compo est le composant (de type Composant), props et event sont des objets contenant plusieurs attributs. Props et event sont les propriétés et les événements transmis lors de la création du composant associé.

- MenuOptions est un tableau d'objets de type MenuOption. Chaque objet (item) comprend un label, une clé et une icône. L'icône et le label sont définis par les fonctions renderLabel et renderIcon afin de permettre une modification de style.

- updateMenu est une fonction qui permet de modifier le menu à chaque fois qu'il change. Il prend en paramètre la clé du composant cliqué. En fonction de l'item cliqué, cette fonction s'adapte selon les critères définis dans la rubrique 'Objectifs' ci-dessus.

#### Fonctions

- renderLabel est une fonction pour définir le label dans l'objet MenuOption. On utilise cette fonction afin d'adapter le style en fonction des items actifs. Lorsqu'un composant est actif, la couleur du label est vert foncé et en gras. Cette manipulation particulière est utile car le menu ne prend pas en charge la sélection multiple.

- renderIcon est une fonction pour définir l'icône dans l'objet MenuOption. On utilise cette fonction afin d'adapter le style en fonction des items actifs. Lorsqu'un composant est actif, la couleur de l'icône et son arrière-plan sont vert foncé. Cette manipulation particulière est utile car le menu ne prend pas en charge la sélection multiple.

- handlePropertyChanged est une fonction qui permet de mettre à jour filtersMap et firstType pour le composant affichage résultats. Cette fonction est appelé lorsqu'un filtre est mis à jour dans la vue Filters.

- handleAffichage est une fonction qui permet de mettre à jour le label de la ressource à afficher dans infoOeuvre. Cette fonction est appelé lorsqu'un clic est effectué dans la vue AffichageResultats.

- handleMapClick est une fonction qui permet de fixer firstType à 'site' lors de l'intéraction avec la carte. Cette fonction est appelé lorsqu'un clic est effectué dans la vue Carte.

#### Template

Les composants sont définis dynamiquement en fonction de visibleCompoListe grâce à la balise <component>. Chaque élément de visibleCompoListe contient le composant (compo), ses propriétés à transmettre (props) et ses événements (event).


Selon le nombre de composants sélectionnés ou actifs, différents n-split sont mis en place et les composants à l'intérieur sont ainsi définis pour les faire afficher en fonction de leurs positions dans la liste visibleCompoListe.


#### Pour ajouter un item dans le menu : 

- Ajout d'un item dans menuOption.
N'oubliez pas d'importer votre icône.

- Ajout d'attributs dans VisibleCompoType et visibleCompo.
Veuillez noter que votre clé d'attribut doit être la même que la clé que vous définissez dans menuOptions. Ne pas oublier d'ajouter l'attribut dans la redéfinition de visibleCompo située dans la fonction updateMenu.

- Ajout d'un 'case' lors du switch de visibleCompoListe.
Définissez les propriétés et les événements à passer lors de la définition du composant associé à votre item.


### Sparnatural.vue

> [!NOTE]  
> Partie non développée pour le moment, doc à mettre à jour.
