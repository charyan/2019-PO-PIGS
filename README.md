# PIGS
![logo](https://user-images.githubusercontent.com/43775161/58420616-0939b900-808e-11e9-8312-b0da9cbf21e5.png)

## Introduction
### Présentation
PIGS est un jeu dans lequel deux joueurs s'affrontent dans un monde entre le réel et le virtuel. Ce monde est constitué d'obstacles destructibles plus originaux les uns que les autres. Chaque jour possède trois **lance-cochon**. Chaque joueur devra tenter de détruire les lanceurs de son adversaire afin de gagner la partie.
### Interaction
Chaque joueur disposera d'une tablette au travers de laquel il pourra voir et interagir avec le jeu.
### Plan du stand
![plan](https://user-images.githubusercontent.com/43775161/58421157-916c8e00-808f-11e9-9d4d-e0fb333a133e.png)

## Fonctionnement
Le jeu utilise les bibliothèques ARKit, SceneKit et UIKit. Toutes ces bibliothèques sont développées par Apple. Nous utiliserons Xcode comme IDE et nous programmerons en Swift, version 5.
### ARKit
ARKit est une bibliothèque permettant de gérer l'expérience de réalité augmentée sur IOS. Cette bibliothèque permet de créer des session AR, de superposer une scène 3D SceneKit sur le flux vidéo de la caméra. Nous utiliserons cette bibliothèque afin de placer notre terrain de jeu virtuel sur une table réelle. 
### SceneKit
SceneKit est une bibliothèque permettant de gérer un environnement 3D. On l'utilisera afin de gérer les collisions, la physique et les modèles 3D.
### UIKit
Cette bibliothèque permet de gérer les éléments graphiques de l'application (boutons, labels, champs textes, etc...). Nous utiliserons cette bibliothèque afin de créer l'interface graphique de notre jeu.
