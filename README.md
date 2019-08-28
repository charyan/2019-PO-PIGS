# PIGS
![logo](https://user-images.githubusercontent.com/43775161/58420616-0939b900-808e-11e9-8312-b0da9cbf21e5.png)

Figure 1 : Logo

## Introduction
### Présentation
PIGS est un jeu dans lequel deux joueurs s'affrontent dans un monde entre le réel et le virtuel. Ce monde est constitué d'obstacles destructibles plus originaux les uns que les autres. Chaque jour possède trois **lance-cochon**. Chaque joueur devra tenter de détruire les lanceurs de son adversaire afin de gagner la partie.
### Interaction
Chaque joueur disposera d'une tablette au travers de laquel il pourra voir et interagir avec le jeu.
### Plan du stand
![plan](https://user-images.githubusercontent.com/43775161/58421157-916c8e00-808f-11e9-9d4d-e0fb333a133e.png)

Figure 2 : Plan du stand

## Organisation
### Séances
Nous organisons une petite séance de 10-15min chaque matin pour regarder l'avancement de nos précédentes tâches et si celles-ci sont terminées, nous nous fixons de nouveaux objectifs pour la journée.
### Outils
#### Todoist
Nous utilisons Todoist pour lister toutes les choses à faire sur le projet, que ce soit de grandes tâches ou de toutes petites comme par exemple, remplacer l'image du placeholder. 
#### GitHub
Nous utilisons l'outil GitHub pour organiser les grandes tâches ainsi que connaître leurs états.
#### Framaboard
Au début, nous utilisions Framaboard mais nous avons décidé de ne plus utiliser cet outil car nous le trouvons peu pratique et que ça prend beaucoup de temps à utiliser.

## Fonctionnement
Le jeu utilise les bibliothèques ARKit, SceneKit et UIKit. Toutes ces bibliothèques sont développées par Apple. Nous utiliserons Xcode comme IDE et nous programmerons en Swift, version 5.
### Bibliothèques
#### ARKit
ARKit est une bibliothèque permettant de gérer l'expérience de réalité augmentée sur IOS. Cette bibliothèque permet de créer des session AR, de superposer une scène 3D SceneKit sur le flux vidéo de la caméra. Nous utiliserons cette bibliothèque afin de placer notre terrain de jeu virtuel sur une table réelle. 
#### SceneKit
SceneKit est une bibliothèque permettant de gérer un environnement 3D. On l'utilisera afin de gérer les collisions, la physique et les modèles 3D.
#### UIKit
Cette bibliothèque permet de gérer les éléments graphiques de l'application (boutons, labels, champs textes, etc...). Nous utiliserons cette bibliothèque afin de créer l'interface graphique de notre jeu.

## Placement de la zone de jeu
Pour placer la zone de jeu, nous commençons par détecter une zone plane, sur cette zone plane, placer un placeholder, éffectuer une rotation afin d'ajuster le placement du placeholder et enfin remplacer le placeholder par la map.
### Detection d'une zone plate
Pour détecter une zone plate, l'Ipad utilise des points de repères virtuels se fixant sur des imperfections de la surface réelle où nous voulons placer la zone de jeu. Plus cette surface contient des imperfections, plus elle sera utilisable pour la réalité augmentée. Une table couverte d'une couche de plastique ne sera pas adapté car elle contient très peu d'impérféctions et reflète énormément la lumière contrairement à une table en boit brut qui sera beaucoup plus intéressante dans notre cas.

![DetectionZonePlate](https://user-images.githubusercontent.com/43779006/60086632-be1dcf00-973b-11e9-9341-460c4b517711.jpg)

Figure 3 : Points de repère utilisés par l'iPad pour détecter une zone plate

### Placement du placeholder
Une fois qu'une zone plate a été détectée, le placeholer apparait automatiquement sur la zone plate. Si nous nous déplaçons avec l'Ipad, le placeholder va automatiquement se déplacer pour se fixer sur la nouvelle zone plate mise à disposition.

### Rotation du placeholder
Pour effectuer une rotation du placeholder, l'utilisateur peut utiliser deux boutons. Les bontons modifient la position du placeholder sur l'axe Y.

![RotationPlaceholder](https://user-images.githubusercontent.com/43779006/60091773-a51a1b80-9745-11e9-815c-3d998478c431.jpg)

Figure 4 : Boutons sur l'iPad pour modifier la position de l'écran

### Placement de la map
Une fois que le placeholder est à l'endroit où nous le souhaitons, il nous suffit de presser sur le bouton "Done" pour placer la map.

![PlacementMap](https://user-images.githubusercontent.com/43779006/60085878-6468d500-973a-11e9-94fc-f780bff341b4.jpg)

Figure 6 : Terrain de jeu

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
Figure 8 : Map


## Gestion des collision
La gestion des collision est gérée par rapport au category bitmask des objets en collision. Suivant le category bitmask des objets, on ajoute le nombre de points correspondants au score du joueur. Les balles lancées par le joueur ont un category bitmask de 2 et tous les objets rapportant des points disposent du category bitmask 3.

## Multijoueur
Pour développer le multijoueur, nous avons créé la branche **multiplayer** sur GitHub. De cette manière le développement du mode multijoueur ne perturbera pas le développement du reste du jeu. Nous avons créé une classe **MultipeerSession** permettant de gérer tous les aspects de connexion et de transfert d'informations entre iPads.

### Gestion des rôles
La gestion des rôles est organisées par la variable **isGameHost** qui permettera de déterminer le rôle de l'iPad. Cette méthode permet d'identifier uniquement deux rôles : **Game host** et **Guest**.

### Problème de merge
Lors d'une tentative de merge entre la branche **multiplayer** et la branche **master**, nous avons eu un problème de conflit avec le fichier **storyboard** de Xcode qui contient l'interface graphique de notre application dans un format **xml**. Git n'arrivant pas à merger les deux storyboard automatiquement, ce processus a dû être effectué manuellement. Après avoir manuellement combiné les deux fichiers, certains boutons avaient disparus et ont donc dû être recréé.  
Il est donc préférable d'éviter d'avoir à merge les fichiers **.storyboard** afin d'éviter ces complications.

## Problèmes rencontrés
### Blocs instables
Quand nous plaçons la map, tous les blocs se mettent à trembler et par conséquent, ils tombent tous de la map. Les blocs empilés bougent davantage que ceux qui sont juste placés sur le sol.

![Capture d’écran 2019-08-23 à 15 55 33](https://user-images.githubusercontent.com/43779006/63597768-7d68f780-c5be-11e9-931a-75f789cdc5e3.png)
Figure 9 : Blocs qui tombent de la map

Pour régler le problème, nous avons essayé de modifier la taille, la physique, la hitbox, la masse, la gravité, le type(plan, box, floor), l'emplacement des blocs et du sol.

Après de nombreuses recherches sur le web, plusieurs messages envoyés sur des forums et plus de trois jours de travaillent à deux dessus, nous avons résolu le problème en reconstruisant tous la map et les blocs.

![pyramid](../doc/images/pyramid.png)
Figure 10 : Blocs empilés en pyramide

## Gameplay
### Cibles
![targetBlocs](../doc/images/targetBlocs.png)
Figure 11 : 

### Points
