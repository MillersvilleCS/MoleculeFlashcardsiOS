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
    @IBOutlet var scoreChangeLabel: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 22)
        
        // directional light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.light.color = GameColors.LIGHT_NODE
        lightNode.position = SCNVector3(x: -25, y: 0, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = GameColors.AMBIENT_LIGHT_NODE
        scene.rootNode.addChildNode(ambientLightNode)
        
        // set scene to view
        let sceneView = super.view as SCNView
        sceneView.scene = scene
        sceneView.backgroundColor = GameColors.SCENE_VIEW_BACKGROUND
        
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
        var currentScore = scoreLabel!.text.toInt()
        var scoreChange: Int = score - currentScore!
        
        self.scoreLabel!.text = "\(score)"
        
        if scoreChange < 0 {
            scoreChangeLabel!.textColor = UIColor.redColor()
            self.scoreChangeLabel!.text = "\(scoreChange)"
        } else {
            scoreChangeLabel!.textColor = GameColors.SCORE_COLOR
            self.scoreChangeLabel!.text = "+\(scoreChange)"
        }
        
        animateLabel(scoreChangeLabel!)
        
        if score >= 0 {
            self.scoreLabel!.textColor = GameColors.SCORE_COLOR
        } else {
            self.scoreLabel!.textColor = UIColor.redColor()
        }
    }
    
    func animateLabel(label: UILabel) {
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveLinear,animations: {() in
            label.alpha = 0.1
            }, completion:  { (finished: Bool) in
                label.text = ""
                label.alpha = 1
            })
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
