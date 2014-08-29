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
    
    var currentQuestionCount = 0
    var timer: NSTimer?
    var spinDirection: Float = 1
    
    @IBOutlet var scoreLabel: UILabel?
    @IBOutlet var timerLabel: UILabel?
    @IBOutlet var scoreChangeLabel: UILabel?
    @IBOutlet var questionWebView: UIWebView?
    
    @IBOutlet var questionProgressView: UIProgressView?
    @IBOutlet var loadingView: UIActivityIndicatorView?
    
    var questionFormatStartTags: NSString = "<p style=\"font-size: 15px; font-family: Helvetica; position: absolute; bottom: -10px;\"><b>"
    let questionFormatEndTags: NSString = "</b></p>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load bigger font for the iPad
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            questionFormatStartTags = "<p style=\"font-size: 25px; font-family: Helvetica; position: absolute; bottom: -10px;\"><b>"
        }
        
        var loadingString = "Loading..."
        self.questionWebView!.loadHTMLString("\(self.questionFormatStartTags)\(loadingString)\(self.questionFormatEndTags)", baseURL: nil)
        self.questionWebView!.scrollView.scrollEnabled = false;
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 22)
        
        // directional light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.light.color = GameConstants.LIGHT_NODE_COLOR
        lightNode.position = SCNVector3(x: -25, y: 0, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = GameConstants.AMBIENT_LIGHT_NODE_COLOR
        scene.rootNode.addChildNode(ambientLightNode)
        
        // set scene to view
        let sceneView = super.view as SCNView
        sceneView.scene = scene
        sceneView.backgroundColor = GameConstants.SCENE_VIEW_BACKGROUND_COLOR
        
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
        var gameController = navigationController.topViewController as GameController
        
        var questionCount = Float(gameController.game!.questionCount)
        var currentQuestion = Float(gameController.game!.questionIndex + 1)
        
        questionProgressView!.setProgress(currentQuestion / questionCount, animated: true)
        
        if question == nil {
           self.questionWebView!.loadHTMLString("\(questionFormatStartTags)\(questionFormatEndTags)", baseURL: nil)
        } else {
            self.questionWebView!.loadHTMLString("\(questionFormatStartTags)\(question)\(questionFormatEndTags)", baseURL: nil)
        }
        if self.molecule {
            self.molecule!.removeFromParentNode()
        }
        self.molecule = molecule
        scene.rootNode.addChildNode(molecule)
        
        if timer {
            timer!.invalidate()
        }
        // SHOULD BE DONE IN APP DELIGATE NOT HERE!
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    // Update the current score and display the score for the last response
    func setScore(score: Int) {
        var currentScore = scoreLabel!.text.toInt()
        var scoreChange: Int = score - currentScore!
        
        self.scoreLabel!.text = "\(score)"
        
        if scoreChange < 0 {
            scoreChangeLabel!.textColor = UIColor.redColor()
            self.scoreChangeLabel!.text = "\(scoreChange)"
        } else {
            scoreChangeLabel!.textColor = GameConstants.SCORE_COLOR
            self.scoreChangeLabel!.text = "+\(scoreChange)"
        }
        
        animateLabel(scoreChangeLabel!)
        
        if score >= 0 {
            self.scoreLabel!.textColor = GameConstants.SCORE_COLOR
        } else {
            self.scoreLabel!.textColor = UIColor.redColor()
        }
    }
    
    // Animate the score deducted/added for an answered question
    func animateLabel(label: UILabel) {
        label.alpha = 1
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveLinear,animations: {() in
            label.alpha = 0.0
        }, completion:  nil)
    }
    
    // Update the rotation speed of the molecule
    func update() {
        var spinAmount: Float = GameConstants.MOLECULE_SPIN_AMOUNT * self.spinDirection
        var m1  = SCNMatrix4MakeRotation(spinAmount, 0, 1, 0)
        
        self.molecule!.transform = SCNMatrix4Mult(self.molecule!.transform, m1)
    }
    
    func handleZoom(gestureRecognize: UIPinchGestureRecognizer) {
        var pos = self.cameraNode.position
        
        if gestureRecognize.velocity > 0 && pos.z > 10 {
            self.cameraNode.position = VecOp.translate(pos, z: -0.5)
        }
        if gestureRecognize.velocity < 0 && pos.z < 64 {
            self.cameraNode.position = VecOp.translate(pos, z: 0.5)
        }
    }
    
    func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        let sceneView = self.view as SCNView
        let velocity = gestureRecognize.velocityInView(sceneView)
        
        var m1     = SCNMatrix4MakeRotation(Float (velocity.x / 5000), 0, 1, 0)
        var m2     = SCNMatrix4MakeRotation(Float (velocity.y / 5000), 1, 0, 0)
        var result = SCNMatrix4Mult(m1, m2)
        
        self.molecule!.transform = SCNMatrix4Mult(self.molecule!.transform, result)
        if velocity.x > 1 {
            spinDirection = 1
        } else {
            spinDirection = -1
        }
    }
}
