# PIGS
## Introduction
### Présentation
PIGS est un jeu dans lequel deux joueurs s'affrontent dans un monde entre le réel et le virtuel. Ce monde est constitué de différents objets: blocs, cibles volantes ou statiques, vif d'or, etc.

Le jeu se joue à 2, le but est de gagner le plus de points dans un temps imparti.

### Formation personnelle
N'ayant aucune connaissance dans le développement avec les produits Apple, nous avons appris les bases à l'aide de tutoriels en ligne. Le début du projet a été périlleux, puis les choses se sont améliorées avec l'expérience.

Jeu
:--------------------:
![gameView](https://user-images.githubusercontent.com/43775161/65329956-dc1f9200-dbb9-11e9-9736-a38a86f96e23.jpg)

### Interaction
Chaque joueur disposera d'une tablette au travers de laquelle il pourra voir et interagir avec le jeu. Chaque joueur peut lancer des balles afin de gagner des points.

### Guide de démarrage du stand
Le guide de démarrage permet de mettre en place toute l'infrastructure de PIGS et de former les apprentis chargés de présenter le projet. Le guide est disponible sur papier ou au format .txt [ici](https://github.com/charyan000/2019-PO-PIGS/blob/master/doc/PO2019-YTD-PIGS-Guide.txt).

Version papier du guide
:--------------------:
![Guide papier](https://user-images.githubusercontent.com/43779006/65152840-055ce880-da29-11e9-927c-35674c197cca.jpg)

### Logos
Nous disposons de trois logos. Le logo original a été créé par un assemblage d'images trouvées sur Internet. Le nouveau a été totalement créé à la main sur Inkscape. Le dernier est utilisé comme icône de notre application.

Logo original             |  Logo actuel
:-------------------------:|:-------------------------
<img src="https://user-images.githubusercontent.com/43775161/58420616-0939b900-808e-11e9-8312-b0da9cbf21e5.png" width="100%" />  |  <img src="https://user-images.githubusercontent.com/43779006/65151787-13116e80-da27-11e9-9e1f-f5a08df56d49.png" width="100%" />

Icône de l'application
:--------------------:
![pigs-logo 120](https://user-images.githubusercontent.com/43775161/65327312-eb9bdc80-dbb3-11e9-8c38-9c9d3ec12874.png)

### Plan du stand

Plan du stand
:--------------------:
![Plan du stand](https://user-images.githubusercontent.com/43775161/65313287-68b75980-db94-11e9-8f36-3b841ab1b73f.png)

### Affiche du stand
L'affiche du stand a été créé sur Visio à partir d'une affiche de référence.

Affiche du stand
:--------------------:
![Affiche](https://user-images.githubusercontent.com/43775161/65816289-190f0880-e1fa-11e9-9905-149b78726e1f.png)

## Organisation
### Séances
Nous organisons une petite séance de 10-15min chaque matin pour regarder l'avancement de nos précédentes tâches et si celles-ci sont terminées, nous nous fixons de nouveaux objectifs pour la journée.
### Outils
#### GitHub
Nous utilisons l'outil GitHub pour organiser les grandes tâches ainsi que connaître leurs états. Pour traquer l'état des tâches, nous utilisons la fonctionnalité de **Projects** de GitHub.

Gestion des tâches sur GitHub
:--------------------:
![Gestion des tâches sur GitHub](https://user-images.githubusercontent.com/43775161/65313613-ee3b0980-db94-11e9-922f-df4050e24f7e.png)

Nous utilisons GitHub également pour créer des versions (releases) de notre jeu.

Github Releases
:--------------------:
![Github releases](https://user-images.githubusercontent.com/43775161/65405058-60049480-dddb-11e9-88c5-1b8e34a790c5.png)

#### Framaboard
Au début, nous utilisions Framaboard mais nous avons décidé de ne plus utiliser cet outil, car nous le trouvions peu pratique et que ça prend beaucoup de temps à utiliser.

#### Todoist
Nous utilisons Todoist pour lister toutes les choses à faire sur le projet, que ce soit de grandes tâches ou de toutes petites par exemple, remplacer l'image du placeholder. Nous avons fini par arrêter de l'utiliser, car la gestion des tâches par GitHub est beaucoup plus pratique.

## Fonctionnement
Le jeu utilise les bibliothèques ARKit, SceneKit, UIKit et MultipeerConnectivity. Toutes ces bibliothèques sont développées par Apple. Nous utiliserons Xcode comme IDE et nous programmerons en Swift, version 5.

### Bibliothèques
#### ARKit
ARKit est une bibliothèque permettant de gérer l'expérience de réalité augmentée sur IOS. Cette bibliothèque permet de créer des sessions AR, de superposer une scène 3D SceneKit sur le flux vidéo de la caméra. Nous utiliserons cette bibliothèque afin de placer notre terrain de jeu virtuel sur une table réelle. 

#### SceneKit
SceneKit est une bibliothèque permettant de gérer un environnement 3D. On l'utilisera afin de gérer les collisions, la physique et les modèles 3D.

#### UIKit
Cette bibliothèque permet de gérer les éléments graphiques de l'application (boutons, labels, champs textes, etc.). Nous utiliserons cette bibliothèque afin de créer l'interface graphique de notre jeu.

#### MultipeerConnectivity
Cette bibliothèque permet de gérer la connexion entre les deux iPad et le transfert d'informations. Nous l'avons utilisée pour créer le mode **Duel**.

### Placement de la zone de jeu
#### Détection d'une zone plane
Pour détecter une zone plane, l'iPad utilise des points de repères virtuels se fixant sur des imperfections de la surface réelle où nous voulons placer la zone de jeu. Plus cette surface contient des imperfections, plus elle sera utilisable pour la réalité augmentée. Une table couverte d'une couche de plastique ne sera pas adaptée, car elle contient très peu d'imperfections et reflète énormément la lumière contrairement à une table en bois brut qui sera beaucoup plus intéressante dans notre cas.

Après avoir effectué plusieurs tests, nous avons choisi d'utiliser deux grandes feuilles de papier contenant des formes aléatoires à poser sur les tables. Ces formes aléatoires mettent à disposition beaucoup de points de tracking permettant aux iPad de détecter la zone plane. Nous avons profité de l'occasion pour ajouté le logo et la liste objets avec les points qu'ils attribuent.

Installation réelle
:--------------------:
![Installation réelle](https://user-images.githubusercontent.com/43779006/65587323-f7a5e680-df85-11e9-8b03-a411e0740b53.JPG)


#### Rotation du placeholder
Pour effectuer une rotation du placeholder, l'utilisateur peut utiliser deux boutons. Les boutons modifient la position du placeholder sur l'axe Y.

Rotation du placeholder
:--------------------:
![Rotation du placeholder](https://user-images.githubusercontent.com/43779006/65588942-93385680-df88-11e9-973f-2e547d9423d8.JPG)

#### Validation du placement
Une fois que le placeholder est à l'endroit où nous le souhaitons, il nous suffit de presser sur le bouton **Done** pour placer la map. Le bouton **Done** a une couleur rouge si le nombre de points de tracking est inférieur à **50**.

Nombre de points de tracking suffisant | Nombre de points de tracking insuffisant
:--------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/43775161/65329954-db86fb80-dbb9-11e9-9391-8971b8bfd1de.jpg" width="100%" />  |  <img src="https://user-images.githubusercontent.com/43775161/65329955-db86fb80-dbb9-11e9-860b-3a11460c6a5b.jpg" width="100%" />

#### Replacement de la zone de jeu
En testant le jeu, nous avons pu nous rendre compte que le placement de la zone de jeu n'était pas assez stable est devait être régulièrement refait. Nous avons donc implémenté deux actions permettant de stopper le jeu et de replacer la zone de jeu:  
* Lorsqu'un geste de rotation à 2 doigts est effectué sur la vue **Pseudo**, le jeu retourne au menu de placement de la zone.
* Lorsqu'un geste de rotation à 2 doigts est effectué sur la vue de jeu (**gameView**), le jeu retourne à la vue **Pseudo**.  

Nous pouvons donc désormais arrêter le jeu si la zone ne s'affiche pas et la replacer.


### Lanceur
Le lanceur permet de créer une balle à la position de l'iPad dans le monde virtuel et d'appliquer une force permettant de déplacer cette balle. Le lancement de la balle est déclenché par un appui sur l'écran. Le lanceur empêche l'utilisateur d'appuyer à répétition sur le bouton à l'aide d'un système de cooldown qui désactive le lanceur.

Après avoir discuté avec les deuxièmes années qui présentaient le stand le mardi des portes ouvertes et l'avis des utilisateurs, nous avons décidé de supprimer le bouton **Shoot** et permettre au joueur d'appuyer sur toute la surface de l'écran.

### Projectile
Le projectile est une sphère qui est lancée lors de la pression sur le bouton **Shoot**.
Elle affectée par la gravité et sa trajectoire sera en cloche.
Sa vitesse a aussi été réglée pour ajouter du réalisme.
À chaque fois qu'une balle est lancée, elle supprime la balle précédente. Cela assure de bonnes performances et évite de surcharger le terrain afin de conserver une bonne visibilité.

### Score
Différentes cibles sont placées sur la table, elles rapportent différentes quantités de points.

### Création des blocs
Les blocs sont directement créés dans **SceneKit** car nous avons trouvé que c'est la solution la plus simple. Nous leur appliquons ensuite leurs paramètres physiques et une texture.

Cube et ses propriétés physiques
:--------------------:
![création_cube](https://user-images.githubusercontent.com/43775161/63411909-ddad3d00-c3f6-11e9-80c4-76a0ddaa8bc8.png)

### Création de la map
Les blocs sont empilés sur la map. On a placé un cube invisible pour le sol. La map est enregistrée en format SceneKit (.scn).
Nous avons trouvé plusieurs modèles sur des sites dédiés à la 3D. Les modèles blender peuvent être convertis directement en format SceneKit.
Nous avons ajouté des arbres, des cailloux, des brins d'herbe. Les maisons ont été fabriquées à la main, bloc par bloc.

Map
:--------------------:
![map](https://user-images.githubusercontent.com/43775161/65330148-43d5dd00-dbba-11e9-88cc-1584a5f8a306.png)

### Gestion des collisions
La gestion des collisions est gérée par rapport aux catégories bitmask des objets en collision. Suivant la catégorie bitmask des objets, on ajoute le nombre de points correspondants au score du joueur. Les balles lancées par le joueur ont une catégorie bitmask de 2 et tous les objets rapportant des points disposent de la catégorie bitmask 3.

### Décompte
Une fois que les deux joueurs ont saisi leurs noms et ont pressé sur **Jouer**, une vue affichant un décompte laisse le temps aux joueurs de se préparer au début de la partie.

Décompte
:--------------------:
![countDown](https://user-images.githubusercontent.com/43779006/65583813-29b44a00-df80-11e9-9c74-54e5fcdc07f6.gif)

### Animations UI
Nous avons ajouté des animations pour le décompte et le timer par code.
Cela permet d'ajouter du dynamisme dans les interfaces.

### Diffusion en live d'un iPad sur une TV
Pour diffuser en live un iPad sur une TV, nous utilisons un Apple TV qui est connectée à notre réseau par wifi.

Diffusion en live
:--------------------:
![Diffusion en live](https://user-images.githubusercontent.com/43779006/65595132-5d996a80-df94-11e9-80ef-8e8532a02ee8.PNG)

### Focus clavier
Le clavier peut être automatiquement ouvert par code.

### Multijoueur
Pour développer le multijoueur, nous avons créé la branche **multiplayer** sur GitHub. De cette manière le développement du mode multijoueur ne perturbera pas le développement du reste du jeu. Nous avons créé une classe **MultipeerSession** permettant de gérer tous les aspects de connexion et de transfert d'informations entre iPad. Cette classe a été reprise d'un [projet démo d'Apple](https://developer.apple.com/documentation/arkit/creating_a_multiuser_ar_experience) et a été adaptée à notre jeu.

#### Idée originale
L'idée originale était d'avoir deux personnes jouées dans le même monde virtuel. Cette version du multijoueur étant trop dure à implémenter, nous avons décidé d'implémenter un nouveau mode de jeu.

#### Mode Duel
Dans le mode **Duel**, chaque joueur joue sur son propre monde virtuel. Le timer est partagé, chaque joueur voit son propre score et le score de son adversaire. Le but est de faire plus de points que l'autre joueur. Les scores individuels des joueurs seront ensuite ajoutés au classement. Une fois le timer terminé, chaque joueur est présenté à un écran de fin affichant son score et le score de son adversaire ainsi qu'un texte personnalisé.

#### Networking
La partie networking est gérée par la bibliothèque [MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity). Cette bibliothèque permet la configuration automatique de la connexion par WiFi, WiFi Peer-to-peer ou Bluetooth, elle permet également de transmettre des informations entre appareils connectés.

Lors du démarrage de l'application, la vue **networkingView** est affichée, elle permet de connecter les deux appareils ensemble et d'envoyer des messages de test.

Networking View | Envoi de messages
:--------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/43775161/65335378-9ddba000-dbc4-11e9-8e6c-6abc4c16029b.png" width="100%" />  |  <img src="https://user-images.githubusercontent.com/43775161/65335380-9e743680-dbc4-11e9-9aa0-a10c118efa33.png" width="100%" />

Une fois les appareils connectés, on appuie sur le bouton **Done**. Ensuite, la vue de placement du jeu est affichée.

#### Gestion des rôles
La gestion des rôles est organisée par la variable **isGameHost** qui permettra de déterminer le rôle de l'iPad. Cette méthode permet d'identifier uniquement deux rôles : **Game host** et **Guest**.

#### Communication
La communication entre les iPad se fait à l'aide de messages textes. Nous avons créé des codes pour définir le but de chaque message.

Schéma de communication
:--------------------:
![image](https://user-images.githubusercontent.com/43775161/65423360-13d04900-de09-11e9-8aee-ef9dd7abf26b.png)

Étape | Description
:--------------------:|:-------------------------:
1 | Lorsque le premier joueur appuie sur le bouton **Jouer**, son iPad envoie un message CODE.READY et CODE.NAME à l'autre iPad
2 | Lorsqu'un joueur appuie sur le bouton **Jouer** et que l'autre n'est pas prêt, on lui affiche une vue d'attente.
3 | Lorsque le deuxième joueur est prêt, son iPad envoie un message CODE.READY et CODE.NAME à l'autre iPad. Les deux iPad lancent alors un compte à rebours et le jeu commence.
4 | Pendant le jeu, à chaque collision, l'iPad envoie le score actuel du joueur à l'autre iPad, le joueur possédant le plus de points a une couronne au-dessus de son score.
5 | Une fois la partie terminée, la vue des résultats est affichée au joueur. Pour relancer la partie avec la même configuration réseau et le même placement de la map, il suffit d'effectuer un **swipe** n'importe où sur l'écran. L'iPad envoie ensuite un message CODE.RESET à l'autre iPad et réinitialise son jeu. L'autre iPad va également réinitialiser son jeu à la réception du message CODE.RESET, ce qui permet de réinitialiser le jeu sur les deux iPad avec une seule action.

##### Codes utilisés
Voici les codes utilisés lors de la communication entre iPad.

```swift
    // Code used for communication between devices
    enum CODE : String {
        case READY = "1:" // Is the other player ready
        case SCORE = "2:" // What is the score of the other player
        case NAME  = "3:" // What is the name of the other player
        case RESET = "4:" // Reset
    }
```

### Fin de partie
#### Minuteur
Notre minuteur utilise 2 fonctions. La première fonction **runTimer** démarre le minuteur. Elle est appelée dans la fonction **onPlayButton**  qui est exécutée après la saisie du nom de l'utilisateur. La seconde fonction **updateTimer** met à jour le label et vérifie que le minuteur a bien atteinte 0 seconde. Une fois que le minuteur atteint 0 seconde, il appelle automatiquement la dernière vue **Results** et envoie une requête **HTTP** méthode **POST** à notre serveur web.

#### Dernière vue **Results**
La dernière vue affiche le nom, le score et un message de remerciement pour l'utilisateur.

Vue gagnant             |  Vue perdant
:-------------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/43775161/65326807-98755a00-dbb2-11e9-8a95-c130d2d7cc08.png" width="100%" />  |  <img src="https://user-images.githubusercontent.com/43775161/65326805-98755a00-dbb2-11e9-97b4-5de5d04b5824.png" width="100%" />

## Réseau
Nous avons créée un réseau sans-fil avec un access point permettant de transférer des informations entre le serveur et les iPad.
Nos appareils ont tous une adresse fixe, le même masque et le même NetId.

Un schéma logique et une liste du matériel sont disponibles dans le dossier **charyan000/2019-PO-PIGS/doc**.

Schéma logique
:--------------------:
![Schéma logique](https://user-images.githubusercontent.com/43775161/65816124-3216ba00-e1f8-11e9-8d5d-5ecb85096360.png)

### Serveur
Nous utilisons un ordinateur Intel NUC sous Windows 10 Pro afin de proposer divers services nécessaires à notre projet : service Apache, MySQL, PHP. Nous utilisons XAMPP.  

Panneau de contrôle de XAMPP
:--------------------:
![Panneau de contrôle XAMPP](https://user-images.githubusercontent.com/43775161/64027001-26c06800-cb40-11e9-9130-cc560776a135.png)

### Wifi
| Propriété | Valeur |
| ----------- | ----------- |
| SSID | PIGS-WIFI |
| Security mode | WPA2-Personnal |
| MDP | Admlocal0 |

### Reset
Pour la réinitialisation, nous supprimons la map ainsi que toutes les variables tels que le score, le nom et toutes les variables utilisées pour la communication réseau.

## Classement des joueurs
### Traitement des données
Toute les données sont traitées par l'interpréteur PHP installé sur le serveur. Le projet PHP suit le modèle MVC.

Structure du projet PHP
:--------------------:
![Structure du projet PHP](https://user-images.githubusercontent.com/43775161/64113030-6fb72d00-cd89-11e9-904f-c9bc23f3f493.png)

### Base de données **utilisateur**
Nous avons créé une base de données pour gérer le classement des joueurs ainsi que leurs scores.
La gestion de la base de données se fait avec l'aide de **phpMyAdmin** qui est installé avec **XAMPP**.
Ce logiciel nous permet de manipuler notre base de données tout en utilisant l'interface adaptée.

| Nom | Type |
| ----------- | ----------- |
| ID_util | Int |
| NOM_util | Varchar |
| SCORE_util | Int |
| GOLDENSNITCH_util | Int

### Insertion de données
L'iPad utilise une requête HTTP (méthode POST) pour envoyer le nom et le score du joueur à une page PHP (**input.php**) qui va insérer les informations dans la base de données. Par exemple, pour le corps de la requête HTTP: `player=Théo&score=200&goldensnitch=false`.
Nous avons décidé d'utiliser cette manière de faire, car il n'existe pas de connecteur MySQL officiel pour SWIFT. Lorsque la page PHP reçoit les paramètres de la requête POST, il les récupère après les avoir assaini. La requête SQL INSERT est protégé des injections de code SQL en utilisant des [paramètres](https://www.w3schools.com/PHP/php_mysql_prepared_statements.asp).

### Affichage du classement
On accède à la page PHP **leaderboard.php** sur le NUC avec le navigateur **Google Chrome**.
La page PHP effectue une requête **SELECT** sur la base de donnée et retourne le nom et le score de tous les joueurs ainsi qu'un booléen pour confirmer si l'utilisateur a touché - ou non - le vif d'or. Il affiche ces informations dans un tableau. La page est rafraichie automatiquement chaque seconde par une extension appelée **[Auto Refresh](https://chrome.google.com/webstore/detail/auto-refresh/ifooldnmmcmlbdennkpdnlnbgbmfalko)**.

## Problèmes rencontrés
### Problème de merge
Lors d'une tentative de merge entre la branche **multiplayer** et la branche **master**, nous avons eu un problème de conflit avec le fichier **storyboard** de Xcode qui contient l'interface graphique de notre application dans un format **xml**. Git n'arrivant pas à merger les deux storyboard automatiquement, ce processus a dû être effectué manuellement. Après avoir manuellement combiné les deux fichiers, certains boutons avaient disparu et ont donc dû être recréés.  
Il est donc préférable d'éviter d'avoir à merge les fichiers **.storyboard** afin d'éviter ces complications.

### Problème de synchronisation de points en fin de partie
Un problème peut être remarqué en fin de partie sur la vue de résultat, le score du joueur adverse est plus petit que son score sur son iPad. Le problème est dû à un problème de synchronisation du lancement du timer entre les deux iPad. Le déclenchement du timer peut être légèrement différé. En fin de partie, quand le premier iPad termine, les scores sont figés, car la vue ne met pas à jour automatiquement la vue résultante lors de la réception du score mis à jour de l'autre joueur.  
Le problème a été réglé en mettant à jour le score affiché dans le label sur la vue de résultat depuis la fonction `scoreUpdate()`.

### Blocs instables
Lors du placement de la map, les blocs se mettent à trembler. Le problème est accru quand les blocs sont empilés les uns sur les autres.

Blocs qui tombent de la map
:--------------------:
![problèmeBlocks](https://user-images.githubusercontent.com/43775161/65590731-8e28d680-df8b-11e9-8bf4-8ce8b9561714.gif)

Pour régler le problème, nous avons essayé de modifier la taille, la physique, la hitbox, la masse, la gravité, le type(plan, box, floor), l'emplacement des blocs et du sol.

Après de nombreuses recherches sur le web, plusieurs messages envoyés sur des forums et plus de trois jours de travaillent à deux dessus, nous avons trouvé une manière de contourner le problème.
Les blocs empilés les uns sur les autres provoquent un tremblement faisant tomber la pile de cubes. Lorsque les blocs sont de taille réduite, la gravité agit plus **fortement**. Les blocs tombent beaucoup plus vite et la physique est approximative.

Nous avons remarqué que si nous empilions les cubes en pyramide et qu'il ont au moins un contact avec deux autres blocs, ils tombaient rarement.

Nous avons créé une map sur ce principe afin d'avoir un terrain de jeu stable.

## Cibles
### Statiques
Il existe plusieurs types d'éléments permettant de marquer des points.
Chacun d'eux détruit la balle au contact.
Les points sont définis dans le code et sont équilibrés.

### Dynamiques
Les blocs dynamiques sont différents des autres, car ils donnent un point à chaque collision. Comme ils ne détruisent pas la balle au contact, ils se font toucher plusieurs fois par un tir ce qui permet d'avoir du dynamisme dans les scores.

### Volantes
Quelques cibles se trouvent dans la partie aérienne du terrain. Elles bougent aléatoirement entre chaque partie.

### Cibles volantes
Nous avons intégré un système de déplacement automatique pour les cibles volantes.
Chaque cible bouge individuellement grâce à une génération de valeurs aléatoires.
Chaque cible a un pattern d'aller et retour se modifiant automatiquement à chaque trajet.
Pour pouvoir donner une animation à chaque cible, une fonction permet de lire tous les noeuds. À partir de ça nous avons fait un test pour savoir si le noeud actuel est nommé **flying target**.
Ensuite on joue l'animation pour chaque cible une par une.

### Bateau
Un bateau tourne autour de la map accompagnée de quatre cochons.
Ils sont liés à un noeud situé au centre de la map. On fait tourner ce noeud pour avoir une rotation fluide.
Nous avons tenté de donner une physique **concave** au bateau pour qu'elle l'enrobe. Cette opération a rendu la map illisible et inutilisable. La map a pu être récupérée grâce à l'archivage sur GitHub.

Pour la physique, nous avons créé des blocs invisibles ayant la même taille que le bateau et tournant en même temps.

### Vif d'or
Un élément permettant de marquer beaucoup de points et très difficile à toucher. Il se déplace aléatoirement et fait des rotations entre chaque mouvement.

### Nuages
Une partie des nuages fait une rotation dans le sens horaire et l'autre en fait une dans le sens antihoraire.
Ils se meuvent très lentement et sont esthétiques au jeu.
Les nuages peuvent cacher les cibles volantes et ainsi servir d'obstacle ajoutant une légère difficulté.

### Bombes
Elles enlèvent des points à la collision. Une animation a été créée pour correspondre avec la bombe.

### Tests utilisateur
Nous avons fait intervenir diverses personnes pour tester le jeu. En particulier pour améliorer le système de points. Cela nous a permis d'équilibrer les points en fonction des objets destructibles.

## Performances
À force d'ajouter des éléments dans le jeu, les iPad ne suivent plus. Il est arrivé que le processeur ait plus de 100% d'utilisation. Certaines structures sont composées de nombreux blocs.
Il est possible de rassembler plusieurs éléments en un seul puis lui donner une physique. Après avoir fait cela avec les ensembles de blocs, les performances sont à nouveau correctes et le jeu plus stable.

En procédant de cette manière, la physique devient instable sur certains points. Pour les brins d'herbe, ce n'est pas un problème, car ils ne disposent pas de physique.
Cependant, les maisons étant des éléments solides sont atteintes par ce problème. Les balles peuvent rester coincées dans certains blocs d'une maison.
Pour résoudre le problème, nous avons ajouté des murs invisibles autour des maisons pour donner l'impression de tirer sur leurs murs. Le problème persiste sur certaines parties des maisons, mais très rarement.

## Leçons à retenir
Ici se trouvent les leçons qu'on a retenues en réalisant ce projet.
- Éviter les plateformes propriétaires pour les raisons suivantes : Problèmes de certificats et technologies peu utilisées
- Vérifier que la technologie que l'on souhaite utiliser est bien documentée et largement utilisé
