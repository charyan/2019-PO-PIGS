//
//  LSViewController.swift
//  PIGS_Prototype
//
//  Created by Apprenti on 25.06.19.
//  Copyright © 2019 pigs-corp. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class LSViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self
    }
}
