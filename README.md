# PIGS
## Introduction
### Présentation
PIGS est un jeu dans lequel deux joueurs s'affrontent dans un monde entre le réel et le virtuel. Ce monde est constitué de différents objects, blocs, cibles volantes ou statiques, vif d'or, etc.  

Le jeu se joue à 2, le but est de gagner le plus de points dans un temps imparti.
### Interaction
Chaque joueur disposera d'une tablette au travers de laquel il pourra voir et interagir avec le jeu. Chaque joueur peut lancer des balles afin de gagner des points.
### Guide de démarrage du stand
Le guide de démarrage permet de mettre en place toute l'infrastructure de PIGS et de former les apprentis chargés de présenter le projet. Le guide est disponible sur papier ou au format .txt à l'emplacement : https://github.com/charyan000/2019-PO-PIGS/blob/master/doc/PO2019-YTD-PIGS-Guide.txt.

![IMG_0817](https://user-images.githubusercontent.com/43779006/65152840-055ce880-da29-11e9-927c-35674c197cca.jpg)
Figure : Version papier du guide

### Logos
Nous disposons de trois logos. Le logo original a été crée par un assemblage d'images trouvés sur Internet. Le nouveau a été totalement créé à la main sur Inkscape. Le dernier est utilisé comme icone de notre application.


Logo original             |  Logo actuel
:-------------------------:|:-------------------------
![logo](https://user-images.githubusercontent.com/43775161/58420616-0939b900-808e-11e9-8312-b0da9cbf21e5.png)  |  ![pigs-logo v3](https://user-images.githubusercontent.com/43779006/65151787-13116e80-da27-11e9-9e1f-f5a08df56d49.png)

Icône de l'application
:--------------------:
![pigs-logo 120](https://user-images.githubusercontent.com/43775161/65327312-eb9bdc80-dbb3-11e9-8c38-9c9d3ec12874.png)

  
![pigs-logo 120](https://user-images.githubusercontent.com/43779006/65155918-6804b300-da2e-11e9-8a88-1ff1f7331227.png)
  
Figure : Logo utilisé pour l'icone de l'application

### Plan du stand
![Plan du stand](https://user-images.githubusercontent.com/43775161/65313287-68b75980-db94-11e9-8f36-3b841ab1b73f.png)
  
Figure : Plan du stand
  
  
  
## Organisation
### Séances
Nous organisons une petite séance de 10-15min chaque matin pour regarder l'avancement de nos précédentes tâches et si celles-ci sont terminées, nous nous fixons de nouveaux objectifs pour la journée.
### Outils
#### GitHub
Nous utilisons l'outil GitHub pour organiser les grandes tâches ainsi que connaître leurs états. Pour tracker l'état des tâches, nous utilisons la fonctionnalité de **Project** de GitHub.
![Gestion des tâches sur GitHub](https://user-images.githubusercontent.com/43775161/65313613-ee3b0980-db94-11e9-922f-df4050e24f7e.png)

#### Framaboard
Au début, nous utilisions Framaboard mais nous avons décidé de ne plus utiliser cet outil car nous le trouvons peu pratique et que ça prend beaucoup de temps à utiliser.
#### Todoist
Nous utilisons Todoist pour lister toutes les choses à faire sur le projet, que ce soit de grandes tâches ou de toutes petites comme par exemple, remplacer l'image du placeholder. Nous avons fini par arrêter de l'utiliser car la gestion des tâches par GitHub est beaucoup plus pratique.

## Fonctionnement
Le jeu utilise les bibliothèques ARKit, SceneKit, UIKit et MultipeerConnectivity. Toutes ces bibliothèques sont développées par Apple. Nous utiliserons Xcode comme IDE et nous programmerons en Swift, version 5.
### Bibliothèques
#### ARKit
ARKit est une bibliothèque permettant de gérer l'expérience de réalité augmentée sur IOS. Cette bibliothèque permet de créer des session AR, de superposer une scène 3D SceneKit sur le flux vidéo de la caméra. Nous utiliserons cette bibliothèque afin de placer notre terrain de jeu virtuel sur une table réelle. 
#### SceneKit
SceneKit est une bibliothèque permettant de gérer un environnement 3D. On l'utilisera afin de gérer les collisions, la physique et les modèles 3D.
#### UIKit
Cette bibliothèque permet de gérer les éléments graphiques de l'application (boutons, labels, champs textes, etc...). Nous utiliserons cette bibliothèque afin de créer l'interface graphique de notre jeu.

#### MultipeerConnectivity
Cette bibliothèque permet de gèrer la connexion entre les deux iPads et le transfert d'informations. Nous l'avons utilisé pour créer le mode **Duel**.

## Fin de partie
### Minuteur
Notre minuteur utilise 2 fonctions. La première fonction **runTimer** démarre le minuteur. Elle est appelée dans la fonction **onPlayButton**  qui est exécutée après la saisi du nom de l'utilisateur. La seconde fonction **updateTimer** met à jour le label et vérifie que le minuteur a bien atteint 0 seconde. Une fois que le minuteur atteint 0 seconde, il appelle automatiquement la dernière vue **Results**.

### Dernière vue "Results"
La dernière vue affiche le nom, le score et un message de remerciement pour l'utilisateur.

Vue gagnant             |  Vue perdant
:-------------------------:|:-------------------------:
![resultsView_win](https://user-images.githubusercontent.com/43775161/65326807-98755a00-dbb2-11e9-8a95-c130d2d7cc08.png)  |  ![resultsView_loose](https://user-images.githubusercontent.com/43775161/65326805-98755a00-dbb2-11e9-97b4-5de5d04b5824.png)

## Placement de la zone de jeu
Pour placer la zone de jeu, nous commençons par détecter une zone plane, sur cette zone plane, placer un placeholder, éffectuer une rotation afin d'ajuster le placement du placeholder et enfin remplacer le placeholder par la map.
### Detection d'une zone plate
Pour détecter une zone plate, l'Ipad utilise des points de repères virtuels se fixant sur des imperfections de la surface réelle où nous voulons placer la zone de jeu. Plus cette surface contient des imperfections, plus elle sera utilisable pour la réalité augmentée. Une table couverte d'une couche de plastique ne sera pas adapté car elle contient très peu d'impérféctions et reflète énormément la lumière contrairement à une table en boit brut qui sera beaucoup plus intéressante dans notre cas.

![DetectionZonePlate](https://user-images.githubusercontent.com/43779006/60086632-be1dcf00-973b-11e9-9341-460c4b517711.jpg)

Figure : Points de repère utilisés par l'iPad pour détecter une zone plate

### Placement du placeholder
Une fois qu'une zone plate a été détectée, le placeholer apparait automatiquement sur la zone plate. Si nous nous déplaçons avec l'Ipad, le placeholder va automatiquement se déplacer pour se fixer sur la nouvelle zone plate mise à disposition.

### Rotation du placeholder
Pour effectuer une rotation du placeholder, l'utilisateur peut utiliser deux boutons. Les bontons modifient la position du placeholder sur l'axe Y.

![RotationPlaceholder](https://user-images.githubusercontent.com/43779006/60091773-a51a1b80-9745-11e9-815c-3d998478c431.jpg)

Figure : Boutons sur l'iPad pour modifier la position de l'écran

### Placement de la map
Une fois que le placeholder est à l'endroit où nous le souhaitons, il nous suffit de presser sur le bouton "Done" pour placer la map.

![PlacementMap](https://user-images.githubusercontent.com/43779006/60085878-6468d500-973a-11e9-94fc-f780bff341b4.jpg)
Figure : Terrain de jeu

## Réseau
Nous avons créée un réseau sans-fil avec un access point permettant de transférer des informations entre le serveur et les iPad.
Nos appareils ont tous une adresse fixe, le même masque et le même NetId.

Un schéma logique et une liste du matériel sont disponibles dans le dossier "charyan000/2019-PO-PIGS/doc".
![PO2019-YTD-PIGD-SchemaLogique](https://user-images.githubusercontent.com/43779006/65156906-27a63480-da30-11e9-8ce8-e9816a95b3d9.JPG)
Figure : Schéma logique


### Serveur
Nous utilisons un ordinateur Intel NUC sous Windows 10 Pro afin de proposer divers services nécessaires à notre projet : service Apache, MySQL, PHP. Nous utilisons XAMPP.  
![Panneau de contrôle XAMPP](https://user-images.githubusercontent.com/43775161/64027001-26c06800-cb40-11e9-9130-cc560776a135.png)

Figure : Panneau de contrôle de XAMPP

### Wifi
| Propriété | Valeur |
| ----------- | ----------- |
| SSID | PIGS-WIFI |
| Security mode | WPA2-Personnal |
| MDP | Admlocal0 |

## Classement des joueurs
### Traitement des données
Toute les données sont traitées par l'interpréteur PHP installé sur le serveur. Le projet PHP suit le modèle MVC.
![Structure du projet PHP](https://user-images.githubusercontent.com/43775161/64113030-6fb72d00-cd89-11e9-904f-c9bc23f3f493.png)

Figure : Structure du projet PHP

### Base de données "utilisateur"
Nous avons créé une base de données pour gérer le classement des joueurs ainsi que leurs scores.
La gestion de la base de donnée se fait avec l'aide de **phpMyAdmin** qui est installé avec **XAMPP**.
Ce logiciel nous permet de manipuler notre base de donnée tout en utilisant l'interface adaptée.

| Nom | Type |
| ----------- | ----------- |
| ID_util | Int |
| NOM_util | Varchar |
| SCORE_util | Int |
| GOLDENSNITCH_util | Int

### Insertion de données
L'iPad utilise une requête HTTP (méthode POST) pour envoyer le nom et le score du joueur à une page PHP (**input.php**) qui va insérer les informations dans la base de données. Par exemple, pour le corps de la requête HTTP: `player=Théo&score=200`.
Nous avons décidé d'utiliser cette manière de faire car il n'existe pas de connecteur MySQL officiel pour SWIFT. Lorsque la page PHP reçoit les paramètres de la requête POST, il les récupère après les avoir assaini. La requête SQL INSERT est protégé des injections de code SQL en utilisant des [paramètres](https://www.w3schools.com/PHP/php_mysql_prepared_statements.asp).

### Affichage du classement
On accède à la page PHP **leaderboard.php** sur le NUC avec le navigateur **Google Chrome**.
La page PHP effectue une requête **SELECT** sur la base de donnée et retourne le nom et le score de tous les joueurs. Il affiche ces informations dans un tableau. La page est rafraichie automatiquement chaque seconde par une extension appellée **[Auto Refresh](https://chrome.google.com/webstore/detail/auto-refresh/ifooldnmmcmlbdennkpdnlnbgbmfalko)**.

## Lanceur
Le lanceur permet de créer une balle à la position de l'iPad dans le monde virtuel et d'appliquer une force permettant de déplacer cette balle. Le lancement de la balle est déclenché par l'appuis d'un bouton. Le lanceur empêche l'utilisateur d'appuyer à répétition sur le bouton à l'aide d'un système de cooldown qui désactive le bouton.

## Score
Différentes cibles sont placées sur la table, elles rapportent différentes quantités de points.

## Création des blocs
Les blocs sont directement créés dans SceneKit car nous avons trouvé que c'était la solution la plus simple. Nous leur application ensuite leurs paramètres physique et une texture.
![création_cube](https://user-images.githubusercontent.com/43775161/63411909-ddad3d00-c3f6-11e9-80c4-76a0ddaa8bc8.png)

Figure 7 : Cube et ses propriétés physiques

## Création de la map
Les blocs sont empilés sur la map. On a placé un cube invisible pour le sol. La map est enregistré en format SceneKit (.scn).
![map](https://user-images.githubusercontent.com/43775161/63411910-ddad3d00-c3f6-11e9-9af6-0fc7e93f9233.png)

Figure : Map

## Gestion des collision
La gestion des collision est gérée par rapport au category bitmask des objets en collision. Suivant le category bitmask des objets, on ajoute le nombre de points correspondants au score du joueur. Les balles lancées par le joueur ont un category bitmask de 2 et tous les objets rapportant des points disposent du category bitmask 3.

## Multijoueur
Pour développer le multijoueur, nous avons créé la branche **multiplayer** sur GitHub. De cette manière le développement du mode multijoueur ne perturbera pas le développement du reste du jeu. Nous avons créé une classe **MultipeerSession** permettant de gérer tous les aspects de connexion et de transfert d'informations entre iPads. Cette classe a été reprise d'un [projet démo d'Apple](https://developer.apple.com/documentation/arkit/creating_a_multiuser_ar_experience) et a été adapté à notre jeu.

### Idée originale
L'idée originale était d'avoir deux personnes jouer dans le même monde virtuel. Cette version du multijoueur étant trop dur à implémenter, nous avons décidé d'implémenter un nouveau mode de jeu.

### Mode Duel
Dans le mode **Duel**, chaque joueur joue sur son propre monde virtuel. Le timer est partagé, chaque joueur voit son propre score et le score de son adversaire. Le but est de faire plus de points que l'autre joueur. Les scores individuels des joueurs seront ensuite ajoutés au classement. Une fois le timer terminé, chaque joueur est présenté à un écran de fin affichant son score et le score de son adversaire ainsi qu'un texte personnalisé.

### Networking
La partie networking est géré par la bibliothèque [MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity). Cette bibliothèque permet la configuration automatique de la connexion par WiFi, WiFi Peer-to-peer ou Bluetooth, elle permet également de transmettre des informations entre appareils connectés.

### Gestion des rôles
La gestion des rôles est organisées par la variable **isGameHost** qui permettera de déterminer le rôle de l'iPad. Cette méthode permet d'identifier uniquement deux rôles : **Game host** et **Guest**.

## Problèmes rencontrés
### Problème de merge
Lors d'une tentative de merge entre la branche **multiplayer** et la branche **master**, nous avons eu un problème de conflit avec le fichier **storyboard** de Xcode qui contient l'interface graphique de notre application dans un format **xml**. Git n'arrivant pas à merger les deux storyboard automatiquement, ce processus a dû être effectué manuellement. Après avoir manuellement combiné les deux fichiers, certains boutons avaient disparus et ont donc dû être recréé.  
Il est donc préférable d'éviter d'avoir à merge les fichiers **.storyboard** afin d'éviter ces complications.

## Gameplay
### Cibles
![targetBlocs](https://raw.githubusercontent.com/charyan000/2019-PO-PIGS/master/doc/Images/targetBlocs.png?token=AKOAHSV3FPVIR75VNEC7AGK5MY7YY)

### Blocs instables
Lors du placement de la map, les blocs se mettent à trembler. Le problème est accru quand les blocs sont empilés les uns sur les autres.

![Blocs instables](https://user-images.githubusercontent.com/43779006/63597768-7d68f780-c5be-11e9-931a-75f789cdc5e3.png)

Figure : Blocs qui tombent de la map

Pour régler le problème, nous avons essayé de modifier la taille, la physique, la hitbox, la masse, la gravité, le type(plan, box, floor), l'emplacement des blocs et du sol.

Après de nombreuses recherches sur le web, plusieurs messages envoyés sur des forums et plus de trois jours de travaillent à deux dessus, nous avons trouvé une manière de contourner le problème.
Les blocs empilés les uns sur les autres provoque un tremblement faisant tomber la pile de cubes. Lorsque les blocs sont de taille réduite, la gravité agit plus "fortement". Les blocs tombent beaucoup plus vite et la physique est approximative.

Nous avons remarqué que si nous empilions les cubes en pyramide et qu'il ont au moins un contact avec deux autres blocs, ils tombaient rarement.

Nous allons créer un map sur ce principe afin d'avoir un terrain de jeu stable.

### Animations

#### Cibles volantes
Nous avons intégré un système de déplacement automatique pour les cibles volantes.
Chaque cible bouge individuellement grâce à une génération de valeurs aléatoires.
Chaque cible a un pattern d'aller et retour se modifiant automatiquement à chaque trajet.
Pour pouvoir donner une animation à chaque cible, une fonction permet de lire tous les noeuds. À partir de ça nous avons fait un test pour savoir si le noeud actuel est nommé "flying target".
Ensuite on joue l'animation pour chaque cible une par une.

#### Bateau
Un bateau tourne autour de la map accompagné de quatre cochons.
Ils sont liés à un noeud situé au centre de la map. On fait tourner ce noeud pour avoir une rotation fluide.
Nous avons tenté de donner une physique "concave" au bateau pour qu'elle l'enrobe. Cette opération à rendu la map illisible et inutilisable. La map a pu être récupérée grâce à l'archivage sur GitHub.

Pour la physique, nous avons créé des blocs invisibles ayant la même taille que le bateau et tournants en même temps.

#### Vif d'or
Un élément permettant de marquer beaucoup de points et très difficile à toucher. Il se déplace aléatoirement et fait des rotation entre chaque mouveemnt.

### Points

#### Bombes
Elles enlèvent des points à la collision. Une animation a été créée pour correspondre avec la bombe.

### Tests utilisateur
Nous avons fait intervenir diverses personnes pour tester le jeu. En particulier pour améliorer le système de points. Cela nous a permis d'équilibrer les points en fonction des objets destructibles.

### Performances
À force d'ajouter des éléments dans le jeu, les Ipad ne suivent plus. Il est arrivé que le processeur ait plus de 100% d'utilisation. Certaines structures sont composées de nombreux blocs.
Il est possible de rassembler plusieurs éléments en un seul puis lui donner une physique. Après avoir fait cela avec les ensembles de blocs, les performances sont à nouveau correct et le jeu plus stable.

## Leçons à retenir
Ici se trouvent les leçons qu'on a retenu en réalisant ce projet.
- Éviter les platformes propriétaires pour les raisons suivantes : Problèmes de certificats et technologies peu utilisée
- Vérifier que la technologie que l'on souhaite utiliser est bien documentée et largement utilisé
