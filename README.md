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

Figure 2 :

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

Figure 5 : Terrain de jeu

## Lanceur
Le lanceur permet de créer une balle à la position de l'iPad dans le monde virtuel et d'appliquer une force permettant de déplacer cette balle. Le lancement de la balle est déclenché par l'appuis d'un bouton. Le lanceur empêche l'utilisateur d'appuyer à répétition sur le bouton à l'aide d'un système de cooldown qui désactive le bouton.

## Score
Différentes cibles sont placées sur la table, elles rapportent différentes quantités de points.

