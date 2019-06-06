//
//  ViewController.swift
//  PIGS_Prototype
//
//  Created by apprenti on 09.05.19.
//  Copyright © 2019 pigs-corp. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

///////////////////////////////////////////////////////////////

// BALL
let BALL_PROJECTILE_NAME : String! = "ball"
let BALL_ROOT_NODE_NAME : String! = "Sphere"
let BALL_SCENE_NAME : String! = "art.scnassets/models/pink_ball.scn"
let BALL_SPEED : Float = 80
let BALL_SCALE : SCNVector3 = SCNVector3(1,1,1)

// LAUNCHER
let PITCH_LAUNCHER : Float = 0.1 // 0 is straight forward

// TARGET
let TARGET_SCENE_NAME : String! = "art.scnassets/models/target.scn"
let TARGET_SCALE : SCNVector3 = SCNVector3(3, 0.4, 3)
let TARGET_POSITION : SCNVector3 = SCNVector3(0, 0, -20)
let TARGET_ROOT_NODE_NAME : String! = "Target"

// GAMEZONE
let GAMEZONE_SCENE_NAME : String! = "art.scnassets/level/map.scn"
let GAMEZONE_SCALE : SCNVector3 = SCNVector3(0.5, 0.5, 0.5)
//let GAMEZONE_POSITION : SCNVector3 = SCNVector3(0, -5, -20)
let GAMEZONE_ROOT_NODE_NAME : String! = "root"

////////////////////////////////////////////////////////////
class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate {

    var score = 0
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    // When the Shoot button is pressed
    @IBAction func onShootButton(_ sender: Any) {
        debugPrint(Date().debugDescription + " : Shoot")
        fireProjectile(type: BALL_PROJECTILE_NAME)
    }
    
    // When the Done button is pressed
    @IBAction func onDoneButton(_ sender: UIButton) {
        
        
        // ...
    }
    // Variables utilisées pour le placement du terrain
    var trackerNode: SCNNode?
    var foundSurface = false
    var tracking = true
    
    var directionalLightNode: SCNNode?
    var ambientLightNode: SCNNode?
    var container: SCNNode!
    
    // Fonction popur placement du terrain
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard tracking else { return } //1
        let hitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint) //2
        guard let result = hitTest.first else { return }
        let translation = SCNMatrix4(result.worldTransform)
        let position = SCNVector3Make(translation.m41, translation.m42, translation.m43) //3
        
        if trackerNode == nil { //1
            let plane = SCNPlane(width: 1, height: 1)
            plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/img/app-icon.png")
            plane.firstMaterial?.isDoubleSided = true
            trackerNode = SCNNode(geometry: plane) //2
            trackerNode?.eulerAngles.x = -.pi * 0.5 //3
            self.sceneView.scene.rootNode.addChildNode(self.trackerNode!) //4
            foundSurface = true
        }
        self.trackerNode?.position = position //5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tracking {
            //Set up the scene
            guard foundSurface else { return } //1
            let trackingPosition = trackerNode!.position //2
            trackerNode?.removeFromParentNode()
            /*container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false)!
             container.position = trackingPosition
             container.isHidden = false //3*/
            createGameZone(position: trackingPosition)
            //ambientLightNode = container.childNode(withName: "ambientLight", recursively: false)
            //directionalLightNode = container.childNode(withName: "directionalLight", recursively: false)
            tracking = false //4
        } else {
            //
        }
        
    }
    
    // Get the user vector
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        // Get the current frame
        if let frame = self.sceneView.session.currentFrame {
            // 4x4  transform matrix describing camera in world space
            let mat = SCNMatrix4(frame.camera.transform)
            // orientation of camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32 + PITCH_LAUNCHER, -1 * mat.m33)
            // location of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    // Create the projectile
    func createProjectile(type : String)->SCNNode{
        var node = SCNNode()
        
        // Check the type of projectile
        switch(type) {
        case BALL_PROJECTILE_NAME:
            let scene = SCNScene(named: BALL_SCENE_NAME)!
            node = scene.rootNode.childNode(withName: BALL_ROOT_NODE_NAME, recursively: true)!
            // Adjust the size of the node
            node.scale = BALL_SCALE
            node.name = BALL_PROJECTILE_NAME
            
        default:
            node = SCNNode()
        }
        
        return node
    }
    
    // Create the target
    func createTarget() {
        var node = SCNNode()
        let scene = SCNScene(named: TARGET_SCENE_NAME)!
        node = scene.rootNode.childNode(withName: TARGET_ROOT_NODE_NAME, recursively: true)!
        node.scale = TARGET_SCALE
        node.name = TARGET_ROOT_NODE_NAME
        node.position = TARGET_POSITION
        node.rotation = SCNVector4(1, 0, 0, GLKMathDegreesToRadians(90))
        
        node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    // Create the game zone
    func createGameZone(position : SCNVector3) {
        var node = SCNNode()
        let scene = SCNScene(named: GAMEZONE_SCENE_NAME)!
        node = scene.rootNode.childNode(withName: GAMEZONE_ROOT_NODE_NAME, recursively: true)!
        //node.scale = GAMEZONE_SCALE
        node.name = GAMEZONE_ROOT_NODE_NAME
        node.position = position
        node.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(90))
        //node.rotation = SCNVector4(1, 0, 0, GLKMathDegreesToRadians(90))
        //node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        // Collision Detection
        sceneView.scene.physicsWorld.contactDelegate = self

    }
    
    // Fire a projectile
    func fireProjectile(type : String) {
        
        // Create the projectile node
        var node = SCNNode()
        node = createProjectile(type: type)
        
        // Get the user's position
        let (direction, position) = self.getUserVector()
        
        node.position = position
        
        var nodeDirection = SCNVector3()
        
        switch(type) {
        case "ball":
            // Set the direction of the projectile
            nodeDirection = SCNVector3(direction.x*BALL_SPEED, direction.y*BALL_SPEED, direction.z*BALL_SPEED)
            
            // Add a spin to the projectile
            node.physicsBody?.applyForce(nodeDirection, at: SCNVector3(0.1, 0, 0), asImpulse: true)
        default:
            nodeDirection = direction
        }
        
        // Launch the projectile
        node.physicsBody?.applyForce(nodeDirection, asImpulse: true)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    

    // Hides the game menu
    func hideGameMenu() {
        
    }


    // Register collision
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let ball = contact.nodeA.physicsBody!.contactTestBitMask == 3 ? contact.nodeA : contact.nodeB
        let explosion = SCNParticleSystem(named: "Explosion.scnp", inDirectory: nil)!
        let explosionNode = SCNNode()
        explosionNode.position = ball.presentation.position
        sceneView.scene.rootNode.addChildNode(explosionNode)
        explosionNode.addParticleSystem(explosion)
        ball.removeFromParentNode()
        score += 10
        self.scoreLabel.text = String(score)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        /// Debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
                                  ARSCNDebugOptions.showPhysicsShapes,
                                  ARSCNDebugOptions.showFeaturePoints
        ]
        // Enable antialiasing
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        //createTarget()
        //createGameZone()
        
        //self.scoreLabel.text = "0"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
