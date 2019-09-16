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
import MultipeerConnectivity

///////////////////////////////////////////////////////////////

let DEBUG_MODE : Bool = false // TRUE is ON

// BALL
let BALL_PROJECTILE_NAME : String! = "ball"
let BALL_ROOT_NODE_NAME : String! = "Sphere"
let BALL_SCENE_NAME : String! = "art.scnassets/models/pink_ball.scn"
let BALL_SPEED : Float = 3

// LAUNCHER
let PITCH_LAUNCHER : Float = 0.1 // 0 is straight forward
let LAUNCHER_COOLDOWN_MILLISECONDS : Int = 300

// TARGET
let TARGET_SCENE_NAME : String! = "art.scnassets/models/target.scn"
let TARGET_SCALE : SCNVector3 = SCNVector3(3, 0.4, 3)
let TARGET_POSITION : SCNVector3 = SCNVector3(0, 0, -20)
let TARGET_ROOT_NODE_NAME : String! = "Target"
// GAMEZONE
let GAMEZONE_SCENE_NAME : String! = "art.scnassets/level/pigsMap.scn"
let GAMEZONE_SCALE : SCNVector3 = SCNVector3(1, 1, 1)
let GAMEZONE_POSITION : SCNVector3 = SCNVector3(0, -0.5, -0.8)
let GAMEZONE_ROOT_NODE_NAME : String! = "root"

// PLACEHOLDER PLANE for gamezone placement
let PLACEHOLDER_PLANE_TRANSPARENCY : CGFloat = 0.5

// POINTS
let POINTS_DYNAMIC_BLOCKS : Int = 1
let POINTS_FURNITURE : Int = 25
let POINTS_TARGET : Int = 100
let POINTS_FLYING_TARGET : Int = 250
let POINTS_PIG : Int = 500
let POINTS_GOLDEN_SNITCH : Int = 3000

let POINTS_BOMB : Int = -300

// Default value rotation for the gamezone placement
let ROTATION_DEG : Float = 5;

// FONT
let FONT_NAME : String = "Skater Girls Rock"
let FONT_SIZE_BTN : CGFloat = 50
let FONT_SIZE_PTS : CGFloat = 50

let URL_POST : String = "http://192.168.1.1/pigs/input.php"

////////////////////////////////////////////////////////////

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, MCBrowserViewControllerDelegate {
    // Code used for communication between devices
    enum CODE : String {
        case READY = "1:" // Is the other player ready
        case SCORE = "2:" // What is the score of the other player
        case NAME  = "3:" // What is the name of the other player
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    var isGameHost: Bool = false
    var multipeerSession: MultipeerSession! = MultipeerSession()
    var isOtherPlayerReady: Bool = false
    var isSelfReady: Bool = false
    
    
    
    @IBOutlet weak var doneNetworkingButton: UIButton!
    @IBOutlet weak var networkingView: UIView!
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gamePlacementView: UIView!
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var CountDownView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var scoreLabelOtherPlayer: UILabel!
    
    @IBOutlet weak var crownPlayer: UIImageView!
    @IBOutlet weak var crownOtherPlayer: UIImageView!

    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var zeroLabel: UIImageView!
    
    @IBOutlet weak var twoLabel: UILabel!
    
    @IBAction func onDoneNetworkingButton(_ sender: Any) {
        networkingView.isHidden = true
        multipeerSession.setIsNetworkingViewEnabled(false)
        multipeerSession.setIsGamePlacementViewEnabled(true)
    }
    
    func displayWaitingView() {
        waitingView.isHidden = false
    }
    
    func hideWaitingView() {
        waitingView.isHidden = true
    }
    
    func hideNetworkingView() {
        networkingView.isHidden = true
    }
    
    func displayNetworkingView() {
        networkingView.isHidden = false
        showConnectionMenu()
        
    }
    
    func CountDown() {
        
        displayCountDownView()
        
        zeroLabel.isHidden = true
        oneLabel.isHidden = true
        twoLabel.isHidden = true
        threeLabel.isHidden = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // your code here
            debugPrint("1")
            self.threeLabel.isHidden = true
            self.twoLabel.isHidden = false
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // your code here
            debugPrint("2")
            self.twoLabel.isHidden = true
            self.oneLabel.isHidden = false
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // your code here
            debugPrint("3")
            self.oneLabel.isHidden = true
            self.zeroLabel.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // your code here
            self.hideCountDownView()
            self.playAnimation()
            self.displayGameMenu()
            self.runTimer()
        }
        
        
        
        
        
    }
    
    @IBAction func onConnectButton(_ sender: Any) {
        showConnectionMenu()
        debugPrint("Showing connection menu")
    }
    
    @IBAction func onSendButton(_ sender: Any) {
        multipeerSession.ping()
        print("Sent message")
    }
    
    @objc func showConnectionMenu() {
        let ac = UIAlertController(title: "Connection Menu", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        self.present(ac, animated: true)
    }
    
    func hostSession(action: UIAlertAction) {
       isGameHost = true
        multipeerSession.setMcAdvertiserAssistant(MCAdvertiserAssistant(serviceType: "pigs", discoveryInfo: nil, session: multipeerSession.session))
        multipeerSession.getMcAdvertiserAssistant().start()
    }
    
    func joinSession(action: UIAlertAction) {
        isGameHost = false
        let mcBrowser = MCBrowserViewController(serviceType: "pigs", session: multipeerSession.session)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    var score = 0
    var otherPlayerScore = 0
    var otherPlayerName : String = ""
    
    enum CATEGORY_BIT_MASK: Int {
        case BALL    = 2
        case TARGET  = 3 // A target is any object with which the collision give points to the player
    }

    func postPlayerRecord() {
        let url = URL(string: URL_POST)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let name = playerName.text
        let score = scoreLabel.text
        let playerLabel = "player="
        let scoreLabel = "&score="
        let goldensnitchLabel = "&goldensnitch="
        var goldenSnitchValue = "null"

        if goldenSnitch {
            goldenSnitchValue = "true"
        } else {
            goldenSnitchValue = "false"
        }
        
        let body = playerLabel + name! + scoreLabel + score! + goldensnitchLabel + goldenSnitchValue
        
        debugPrint(body)

        request.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // When the Shoot button is pressed
    @IBAction func onShootButton(_ sender: UIButton) {
        debugPrint(Date().debugDescription + " : Shoot")
        fireProjectile(type: BALL_PROJECTILE_NAME)
        self.shootButton.isEnabled = false
        self.shootButton.backgroundColor = UIColor.lightGray
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(LAUNCHER_COOLDOWN_MILLISECONDS), execute: {
            self.shootButton.backgroundColor = UIColor.green
            self.enableShootButton()
        })
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var crosshair: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var nameMenuTextField: UITextField!
    @IBOutlet weak var nameMenuError: UILabel!
    @IBOutlet weak var nameLengthError: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var HUD: UILabel!
    
    // View choose name menu
    @IBOutlet weak var Pseudo: UIView!
    
    @IBOutlet weak var goldenSnitchResults: UILabel!
    @IBOutlet weak var NameJoueur: UILabel!
    @IBOutlet weak var NumberPoints: UILabel!
    @IBOutlet weak var Results: UIView!
    @IBOutlet weak var goldenSnitchImage: UIImageView!
    
    @IBAction func SwipeGesture(_ sender: Any) {
        reset()
    }
    
    var trackingPosition: SCNVector3!

    // When the Done button (In the gameplacement view) is pressed
    @IBAction func onDoneButton(_ sender: Any) {
        if (tracking) {
            //Set up the scene
            guard foundSurface else { return }
            trackingPosition = trackerNode!.position
            trackerNode?.removeFromParentNode()
            /*container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false)!
             container.position = trackingPosition
             container.isHidden = false */
            createGameZone(position: trackingPosition)
            //ambientLightNode = container.childNode(withName: "ambientLight", recursively: false)
            //directionalLightNode = container.childNode(withName: "directionalLight", recursively: false)
            tracking = false
        }
        displayNameMenu()
        hideGamezonePlacementMenu()
        
        multipeerSession.setIsGamePlacementViewEnabled(false)
        multipeerSession.setIsNameViewEnabled(true)
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        if (nameMenuTextField.text!.isEmpty || nameMenuTextField.text!.count < 2) {
            displayNameMenuError()
        } else if (nameMenuTextField.text!.count > 20) {
            displayNameLengthError()
        } else { // Everything is ok
            hideNameMenuError()
            hideNameLengthError()
            playerName.text = nameMenuTextField.text
            DismissKeyboard()
            hideGamezonePlacementMenu()

            playAnimation()
            
            multipeerSession.setIsNameViewEnabled(false)
            multipeerSession.setIsGameViewEnabled(true)
            
            if(isOtherPlayerReady) {
                self.hideWaitingView()
                self.hideGameMenu()
                self.hideNameMenu()
                self.CountDown()

                /*
                hideNameMenu()
                hideGameMenu()
                CountDown()
                */
            } else {
                hideGameMenu()
                hideNameMenu()
                displayWaitingView()
            }
            
            multipeerSession.sendMessage(CODE.READY.rawValue)
            isSelfReady = true
            
            multipeerSession.sendMessage(CODE.NAME.rawValue + playerName.text!)
            
            //displayCountDownView()
            
        }
        
    }
    
    
    var rotationDeg: Float = 0
    
    @IBAction func onLeftButton(_ sender: Any) {
        self.trackerNode?.eulerAngles.y -= GLKMathDegreesToRadians(ROTATION_DEG)
        rotationDeg -= ROTATION_DEG
        print(rotationDeg)
    }
    
    
    @IBAction func onRightButton(_ sender: Any) {
        self.trackerNode?.eulerAngles.y += GLKMathDegreesToRadians(ROTATION_DEG)
        rotationDeg += ROTATION_DEG
        print(rotationDeg)
    }
    
    func displayCountDownView(){
        CountDownView.isHidden = false;
    }
    
    func hideCountDownView(){
        CountDownView.isHidden = true;
    }
    
    
    
    
    // Enable shoot button after cooldown
    func enableShootButton() {
        self.shootButton.isEnabled = true
        self.shootButton.backgroundColor = UIColor.white
    }
    
    // Reset
    func reset(){
        
        // Reset Variables
        seconds = 60
        nameMenuTextField.text = ""
        
        hideResultsView()
        displayNameMenu()
        
        goldenSnitchImage.isHidden = true
        goldenSnitchResults.isHidden = true
        
        score = 0
        scoreLabel.text = "0"
        goldenSnitch = false
        
        node.removeFromParentNode()
        createGameZone(position: trackingPosition)
    }
    
    // Display the game menu
    func displayGameMenu() {
        gameView.isHidden = false
        
        // TOCHECK
        playerName.isHidden = false
        HUD.isHidden = false
    }
    
    // Hide the game menu
    func hideGameMenu() {
        gameView.isHidden = true
        
        // TOCHECK
        playerName.isHidden = true
        HUD.isHidden = true
    }
    
    func hideResultsView() {
        Results.isHidden = true
    }
    
    // Display the gamezone placement menu
    func displayGamezonePlacementMenu() {
        gamePlacementView.isHidden = false
        
        if (self.sceneView.session.currentFrame?.rawFeaturePoints!.points.count)! > 50 || DEBUG_MODE {
            doneButton.isEnabled = true
            doneButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    // Hide the gamezone placement menu
    func hideGamezonePlacementMenu() {
        gamePlacementView.isHidden = true
    }
    
    func displayNameMenu() {
        self.Pseudo.isHidden = false
        self.nameMenuError.isHidden = true
        self.nameLengthError.isHidden = true
    }
    
    
    @IBOutlet weak var resultsViewTitle: UILabel!
    
    @IBOutlet weak var resultsViewPlayerName: UILabel!
    @IBOutlet weak var resultsViewPlayerScore: UILabel!
    
    @IBOutlet weak var resultsViewOtherPlayerName: UILabel!
    @IBOutlet weak var resultsViewOtherPlayerScore: UILabel!
    
    
    func displayResultsView() {
        self.Results.isHidden = false
        NumberPoints.text = scoreLabel.text
        
        resultsViewPlayerName.text = NameJoueur.text
        resultsViewPlayerScore.text = String(score) + " pts"
        
        if goldenSnitch {
            goldenSnitchImage.isHidden = false
            goldenSnitchResults.isHidden = false
        }
        
        resultsViewOtherPlayerName.text = otherPlayerName
        resultsViewOtherPlayerScore.text = String(otherPlayerScore) + " pts"
        
        if(self.score > Int(self.scoreLabelOtherPlayer.text!) ?? 0) {
            // Player is first
            resultsViewTitle.text = "GAGNÉ !"
            
        } else if(Int(self.scoreLabelOtherPlayer.text!) ?? 0 > self.score) {
            // Other player is first
            resultsViewTitle.text = "PERDU !"
            
        } else {
            // Draw
            resultsViewTitle.text = "ÉGALITÉ !"
        }
    }
    
    func hideNameMenu() {
        Pseudo.isHidden = true
    }
    
    func displayNameMenuError() {
        nameMenuError.isHidden = false
    }
    
    func hideNameMenuError() {
        nameMenuError.isHidden = true
    }
    
    func displayNameLengthError() {
        nameLengthError.isHidden = false
    }
    
    func hideNameLengthError() {
        nameLengthError.isHidden = true
    }
    
    // Variables for play zone
    var trackerNode: SCNNode?
    var foundSurface = false
    var tracking = true
    
    var directionalLightNode: SCNNode?
    var ambientLightNode: SCNNode?
    var container: SCNNode!
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard tracking else { return }
        let hitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint)
        guard let result = hitTest.first else { return }
        let translation = SCNMatrix4(result.worldTransform)
        let position = SCNVector3Make(translation.m41, translation.m42, translation.m43)
        
        if trackerNode == nil {
            let plane = SCNPlane(width: 1.6, height: 1.6)
            plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/img/app-icon.png")
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.transparency = CGFloat(PLACEHOLDER_PLANE_TRANSPARENCY)
            trackerNode = SCNNode(geometry: plane)
            trackerNode?.eulerAngles.x = -.pi * 0.5
            //self.trackerNode?.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(270))
            
            
            self.sceneView.scene.rootNode.addChildNode(self.trackerNode!)
            foundSurface = true
        }
        
        self.trackerNode?.position = position
        
        //self.trackerNode?.rotation.x = GLKMathDegreesToRadians(270)
        
        //self.trackerNode?.rotation = SCNVector4(0, 1, 0,GLKMathDegreesToRadians(Float(rotationDeg)))
        
        //self.trackerNode?.rotation =  SCNVector4(0, 1, 0,GLKMathDegreesToRadians(Float(rotationDeg)))
        //self.trackerNode?.rotation = SCNVector4(1, 0, 0, GLKMathDegreesToRadians(270))
        
        
        displayGamezonePlacementMenu()
    }
    
    
    // Get the user's direction and position
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
            //node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
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
       var node = SCNNode()
    
    // Create the game zone
    func createGameZone(position : SCNVector3) {
     
        let scene = SCNScene(named: GAMEZONE_SCENE_NAME)!
        node = scene.rootNode.childNode(withName: GAMEZONE_ROOT_NODE_NAME, recursively: true)!
        node.name = GAMEZONE_ROOT_NODE_NAME
        
        node.position = position
        node.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(Float(rotationDeg)))
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
        default:
            nodeDirection = direction
        }
        
        // Launch the projectile
        node.physicsBody?.applyForce(nodeDirection, asImpulse: true)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func scoreUpdate() {
        DispatchQueue.main.async {
            self.scoreLabel.text = String(self.score)
            self.scoreLabelOtherPlayer.text = String(self.otherPlayerScore)
            
            if(self.score > self.otherPlayerScore) {
                // Player is first
                self.crownPlayer.isHidden = false
                self.crownOtherPlayer.isHidden = true
            } else if(self.otherPlayerScore > self.score) {
                // Other player is first
                self.crownPlayer.isHidden = true
                self.crownOtherPlayer.isHidden = false
            } else {
                self.crownPlayer.isHidden = true
                self.crownOtherPlayer.isHidden = true
            }
        }
    }
    
    func scoreIncrement(points: Int) {
        score += points
        print("+" + String(points) + " points")
    }
    
    var seconds = 60
    
    var timer = Timer()
    var isTimerRunning = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        NameJoueur.text = nameMenuTextField.text
        
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            hideGameMenu()
            
            multipeerSession.setIsGameViewEnabled(false)
            multipeerSession.setIsResultsViewEnabled(true)
            
            displayResultsView()
            postPlayerRecord()
        } else {
            seconds -= 1
            timeLabel.text = "\(seconds)"
        }
        
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 60
        timeLabel.text = "\(seconds)"
    }
    
    func playAnimation() {
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            
            // Animation of flying target
            let moveY = SCNAction.moveBy(x: CGFloat.random(in: -0.2 ..< 0.2), y: CGFloat.random(in: -0.2 ..< 0.2), z: CGFloat.random(in: -0.2 ..< 0.2), duration: 0.6)
            let moveZ = SCNAction.moveBy(x: CGFloat.random(in: -0.2 ..< 0.2), y: CGFloat.random(in: -0.2 ..< 0.2), z: CGFloat.random(in: -0.2 ..< 0.2), duration: 0.6)
            let moveYZ = SCNAction.sequence([moveY, moveZ])
            
            let moveYZLoop = SCNAction.sequence([moveYZ, moveYZ.reversed()])
            
            let repeatForever = SCNAction.repeatForever(moveYZLoop)
            
            if node.name == "flying target" {
                node.runAction(repeatForever)
            }
            
            // Animation of golden snitch
            let boatMoveY1 = SCNAction.moveBy(x: CGFloat.random(in: -1 ..< 1), y: CGFloat.random(in: -1 ..< 1), z: CGFloat.random(in: -1 ..< 1), duration: 0.7)
            
            let boatMoveR1 = SCNAction.rotate(by: .pi, around: SCNVector3(0, CGFloat.random(in: -200 ..< 200), 0), duration: 0.5)
            
            let boatMoveZ1 = SCNAction.moveBy(x: CGFloat.random(in: -1 ..< 1), y: CGFloat.random(in: -1 ..< 1), z: CGFloat.random(in: -1 ..< 1), duration: 0.7)
            
            let boatMoveR2 = SCNAction.rotate(by: .pi, around: SCNVector3(0, CGFloat.random(in: -200 ..< 200), 0), duration: 0.5)
            
            let boatMoveY2 = SCNAction.moveBy(x: CGFloat.random(in: -1 ..< 1), y: CGFloat.random(in: -1 ..< 1), z: CGFloat.random(in: -1 ..< 1), duration: 0.7)
            
            let boatMoveR3 = SCNAction.rotate(by: .pi, around: SCNVector3(0, CGFloat.random(in: -200 ..< 200), 0), duration: 0.5)
            
            let boatMoveZ2 = SCNAction.moveBy(x: CGFloat.random(in: -1 ..< 1), y: CGFloat.random(in: -1 ..< 1), z: CGFloat.random(in: -1 ..< 1), duration: 0.7)
            
            let boatMoveR4 = SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 0), duration: 0.1)
            
            let boatMoveY1R1 = SCNAction.sequence([boatMoveY1, boatMoveR1])
            let boatMoveZ1R2 = SCNAction.sequence([boatMoveZ1, boatMoveR2])
            let boatMoveY2R3 = SCNAction.sequence([boatMoveY2, boatMoveR3])
            let boatMoveZ2R4 = SCNAction.sequence([boatMoveZ2, boatMoveR4])
            
            let boatMove1Loop = SCNAction.sequence([boatMoveY1R1, boatMoveZ1R2])
            let boatMove2Loop = SCNAction.sequence([boatMoveY2R3, boatMoveZ2R4])
            let boatMove3Loop = SCNAction.sequence([boatMoveY1R1.reversed(), boatMoveZ1R2.reversed()])
            let boatMove4Loop = SCNAction.sequence([boatMoveY2R3.reversed(), boatMoveZ2R4.reversed()])
            
            let boatMove12Loop = SCNAction.sequence([boatMove1Loop, boatMove2Loop])
            let boatMove34Loop = SCNAction.sequence([boatMove3Loop, boatMove4Loop])
            
            let boatMove1234Loop = SCNAction.sequence([boatMove12Loop, boatMove34Loop])
            
            let boatRepeatForever = SCNAction.repeatForever(boatMove1234Loop)
            
            if node.name == "golden_snitch" {
                node.runAction(boatRepeatForever)
            }
            
            // Animation of boat
            let action : SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 5)
            let forever = SCNAction.repeatForever(action)
            
            if node.name == "rotation" || node.name == "pig_rotation" {
                node.runAction(forever)
            }
        }
    }
    
    var goldenSnitch = false
    
    // Register collision
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let ball = contact.nodeA.physicsBody!.contactTestBitMask == 3 ? contact.nodeA : contact.nodeB
        
        var explosionType = "Target Explosion.scnp"
        
        if (contact.nodeA.name! == "pig" || contact.nodeB.name! == "pig"
            || contact.nodeA.name! == "golden_snitch" || contact.nodeB.name! == "golden_snitch"
            || contact.nodeA.name! == "pig_rotation" || contact.nodeB.name! == "pig_rotation") {
            
            explosionType = "Pig Explosion.scnp"
            
        } else if (contact.nodeA.name! == "flying target" || contact.nodeB.name! == "flying target") {
            
            explosionType = "Flying Target Explosion.scnp"
            
        } else if (contact.nodeA.name! == "door" || contact.nodeB.name! == "door") {
            
            explosionType = "Door Explosion.scnp"
            
        } else if (contact.nodeA.name! == "window" || contact.nodeB.name! == "window") {
            
            explosionType = "Window Explosion.scnp"
            
        } else if (contact.nodeA.name! == "bomb" || contact.nodeB.name! == "bomb") {
            
            explosionType = "Bomb Explosion.scnp"
        }
        
        let explosion = SCNParticleSystem(named: explosionType, inDirectory: nil)!
        
        // Make a target dissapear if there's a collision
        if (contact.nodeA.name! == "target" || contact.nodeB.name! == "target"
            || contact.nodeA.name! == "flying target" || contact.nodeB.name! == "flying target"
            || contact.nodeA.name! == "pig" || contact.nodeB.name! == "pig"
            || contact.nodeA.name! == "door" || contact.nodeB.name! == "door"
            || contact.nodeA.name! == "window" || contact.nodeB.name! == "window"
            || contact.nodeA.name! == "golden_snitch" || contact.nodeB.name! == "golden_snitch"
            || contact.nodeA.name! == "pig_rotation" || contact.nodeB.name! == "pig_rotation"
            || contact.nodeA.name! == "bomb" || contact.nodeB.name! == "bomb") {
            
            contact.nodeA.removeFromParentNode()
            if (contact.nodeA.name! == "golden_snitch" || contact.nodeB.name! == "golden_snitch"){
                goldenSnitch = true
            }
        }
        
        // Remove ball and generate particle only when there's a collision with a target.
        // Static nodes and boxes aren't affected
        if (contact.nodeA.name! == "box" || contact.nodeB.name! == "box"
            || contact.nodeA.name! == "small_rock" || contact.nodeB.name! == "small_rock") {
            print("Collision with box")
        } else if (contact.nodeA.name! == "house flatten" || contact.nodeB.name! == "house flatten") {
            print("Collision with house")
        } else {
            let explosionNode = SCNNode()
            explosionNode.position = ball.presentation.position
            sceneView.scene.rootNode.addChildNode(explosionNode)
            explosionNode.addParticleSystem(explosion)
            ball.removeFromParentNode()
        }
        
        // Update score on collision with target
        if(contact.nodeA.physicsBody!.categoryBitMask == CATEGORY_BIT_MASK.TARGET.rawValue ||
            contact.nodeB.physicsBody!.categoryBitMask == CATEGORY_BIT_MASK.TARGET.rawValue) {
            
            if (contact.nodeA.name! == BALL_ROOT_NODE_NAME && contact.nodeB.name! == BALL_ROOT_NODE_NAME) {
                print("Collision with ball")
            } else if (contact.nodeA.name! == "target" || contact.nodeB.name! == "target") {
                scoreIncrement(points: POINTS_TARGET)
                print("Collision with cubic target")
            } else if (contact.nodeA.name! == "flying target" || contact.nodeB.name! == "flying target") {
                scoreIncrement(points: POINTS_FLYING_TARGET)
                print("Collision with flying target")
            } else if (contact.nodeA.name! == "pig" || contact.nodeB.name! == "pig"
                || contact.nodeA.name! == "pig_rotation" || contact.nodeB.name! == "pig_rotation") {
                scoreIncrement(points: POINTS_PIG)
                print("Collision with pig")
            } else if (contact.nodeA.name! == "door" || contact.nodeB.name! == "door"
                || contact.nodeA.name! == "window" || contact.nodeB.name! == "window") {
                scoreIncrement(points: POINTS_FURNITURE)
            } else if (contact.nodeA.name! == "golden_snitch" || contact.nodeB.name! == "golden_snitch") {
                scoreIncrement(points: POINTS_GOLDEN_SNITCH)
            } else if (contact.nodeA.name! == "bomb" || contact.nodeB.name! == "bomb") {
                scoreIncrement(points: POINTS_BOMB)
            } else {
                scoreIncrement(points: POINTS_DYNAMIC_BLOCKS)
            }
        }
        
        scoreUpdate()
        multipeerSession.sendMessage(CODE.SCORE.rawValue + String(score))
    }
    
    
    @IBOutlet weak var gameViewTimeLabel: UILabel!
    
    override func viewDidLoad() {
        debugPrint("ViewDidLoad")
        super.viewDidLoad()
        hideResultsView()
        hideCountDownView()
        
        goldenSnitchImage.isHidden = true
        goldenSnitchResults.isHidden = true
        
        sceneView.scene.physicsWorld.timeStep = 1/200
        
        self.HideKeyboard()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        if(DEBUG_MODE) {
            // Show statistics such as fps and timing information
            sceneView.showsStatistics = true
            
            /// Debug options with physics fields
            //sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
            //                        ARSCNDebugOptions.showPhysicsShapes,
            //                      ARSCNDebugOptions.showFeaturePoints]
            
            /// Debug options without physics fields and origin
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            doneNetworkingButton.isEnabled = true
        }
        
        // Enable antialiasing
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        //        labelPoints.font = UIFont(name: FONT_NAME, size: FONT_SIZE_PTS)
        scoreLabel.font = UIFont(name: FONT_NAME, size: FONT_SIZE_PTS)
        
        // Hide the menus
        hideGameMenu()
        hideGamezonePlacementMenu()
        hideNameMenu()
        
        multipeerSession.delegate = self
        multipeerSession.setLogView(&debugTextView)
        multipeerSession.setDoneNetworkingButton(doneNetworkingButton)
        multipeerSession.setIsNetworkingViewEnabled(true)
        multipeerSession.setSceneView(&sceneView)
        
        gameViewTimeLabel.text = String(seconds)
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

        
    }
    
}

extension UIViewController {
    func HideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController : MultipeerSessionServiceDelegate {
    func messageReceived(manager: MultipeerSession, message: String) {
        OperationQueue.main.addOperation {
            let code = String(message.prefix(2))
            
            switch(code) {
            case CODE.READY.rawValue:
                if(self.isSelfReady) {
                    self.hideWaitingView()
                    self.hideGameMenu()
                    self.hideNameMenu()
                    self.CountDown()
                } else {
                    self.isOtherPlayerReady = true
                }
                break
            case CODE.SCORE.rawValue:
                let start = message.index(message.startIndex, offsetBy: 2)
                let range = start...
                
                let mySubstring = message[range]
                self.otherPlayerScore = Int(String(mySubstring)) ?? 0
                self.scoreUpdate()
                break
            case CODE.NAME.rawValue:
                let start = message.index(message.startIndex, offsetBy: 2)
                let range = start...
                
                let mySubstring = message[range]
                self.otherPlayerName = String(mySubstring)
                break
            default:
                self.debugTextView.text = self.debugTextView.text + message + "\n"
                break
            }
            
            debugPrint("Message received : " + message)
        }
    }
    
    func connectedDevicesChanged(manager: MultipeerSession, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
}
