//
//  MoleculeController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/8/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit
import SceneKit

class MoleculeController: UIViewController {
    
    var scene = SCNScene()
    let cameraNode = SCNNode()
    var molecule: SCNNode?
    
    @IBOutlet var scoreLabel: UILabel?
    @IBOutlet var timerLabel: UILabel?
    @IBOutlet var questionLabel: UILabel?
    
    // Custom colors
    var scoreColor = UIColor(red: CGFloat(0), green: CGFloat(180/255.0), blue: CGFloat(0), alpha: CGFloat(1.0))

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 22)
        
        // directional light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.light.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        lightNode.position = SCNVector3(x: -25, y: 0, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // set scene to view
        let sceneView = super.view as SCNView
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
        
        // gesture recognizers
        let zoomGesture = UIPinchGestureRecognizer(target: self, action: "handleZoom:")
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGesture.maximumNumberOfTouches = 1
        
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(zoomGesture)
        gestureRecognizers.addObject(panGesture)
        gestureRecognizers.addObjectsFromArray(sceneView.gestureRecognizers)
        sceneView.gestureRecognizers = gestureRecognizers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    func setQuestion (question: String, molecule: SCNNode) {
        if question == nil {
            self.questionLabel!.text = ""
        }
        else {
            self.questionLabel!.text = question
        }
        if self.molecule {
            self.molecule!.removeFromParentNode()
        }
        self.molecule = molecule
        scene.rootNode.addChildNode(molecule)
    }
    
    func setScore(score: Int) {
        println(score)
        self.scoreLabel!.text = "\(score)"
        if score >= 0 {
            self.scoreLabel!.textColor = self.scoreColor
        } else {
            self.scoreLabel!.textColor = UIColor.redColor()
        }
    }
    
    func handleZoom(gestureRecognize: UIPinchGestureRecognizer) {
        var pos = self.cameraNode.position
        
        if gestureRecognize.velocity > 0 && pos.z > 10 {
            self.cameraNode.position = VecOp.translate(pos, z: -1.0)
        }
        if gestureRecognize.velocity < 0 && pos.z < 64 {
            self.cameraNode.position = VecOp.translate(pos, z: 1.0)
        }
    }
    
    func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        let sceneView = self.view as SCNView
        let velocity = gestureRecognize.velocityInView(sceneView)
        
        var m1     = SCNMatrix4MakeRotation(velocity.x / 1500, 0, 1, 0)
        var m2     = SCNMatrix4MakeRotation(velocity.y / 1500, 1, 0, 0)
        var result = SCNMatrix4Mult(m1, m2)
        
        self.molecule!.transform = SCNMatrix4Mult(self.molecule!.transform, result)
    }
}
