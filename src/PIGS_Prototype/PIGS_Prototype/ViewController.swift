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

////////////////////////////////////////////////////////////

// BALL
let BALL_SPEED : Float = 75
let BALL_SCALE : SCNVector3 = SCNVector3(0.5,0.5,0.5)

// LAUNCHER
let PITCH_LAUNCHER : Float = 0.1

// TARGET
let TARGET_SCALE : SCNVector3 = SCNVector3(0.2, 0.025, 0.2)
let TARGET_POSITION : SCNVector3 = SCNVector3(0, 0, 0)

////////////////////////////////////////////////////////////

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // When the Shoot button is pressed
    @IBAction func onShootButton(_ sender: Any) {
        debugPrint(Date().debugDescription + " : Shoot")
        fireProjectile(type: "ball")
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
        case "ball":
            let scene = SCNScene(named: "art.scnassets/pink_ball.scn")
            node = (scene?.rootNode.childNode(withName: "Sphere", recursively: true)!)!
            // Adjust the size of the node
            node.scale = BALL_SCALE
            node.name = "ball"
        default:
            node = SCNNode()
        }
        
        return node
    }
    
    // Create the target
    func createTarget() {
        var node = SCNNode()
        let scene = SCNScene(named: "art.scnassets/target.dae")
        node = (scene?.rootNode.childNode(withName: "Cylinder", recursively: true)!)!
        node.scale = TARGET_SCALE
        node.name = "target"
        node.position = TARGET_POSITION
        sceneView.scene.rootNode.addChildNode(node)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Debug options
        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        
        // Enable antialiasing
        sceneView.antialiasingMode = .multisampling4X
        
        createTarget()
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
