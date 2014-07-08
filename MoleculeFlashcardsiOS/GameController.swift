//
//  GameController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit
import SceneKit

class GameController : UIViewController {
    
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    var questions: [Question]?
    var molecules: [SCNNode]?
    
    @IBOutlet var buttonController: ButtonCollectionController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(game)
        assert(user)
        assert(requestURL)
        assert(mediaURL)
        
        start()
        
        // Set the answer choices
        var buttonController = self.childViewControllers[1] as ButtonCollectionController
        buttonController.answerChoices = ["1", "2", "3", "4", "5", "6"]
    }
    
    func start() {
        game!.start(url: requestURL!, user: user!,{(questions: [Question]) in
            var nodeList = [SCNNode]()
            self.questions = questions

            for question in questions {
                var request = Request(url: "\(self.mediaURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                var convertedURL = NSURL.URLWithString("\(self.mediaURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                var err: NSError?
                var imageData :NSData = NSData.dataWithContentsOfURL(convertedURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
                var response: String = NSString(data: imageData, encoding: NSUTF8StringEncoding)
                
                var molecule = SDFParser.parse(sdfFileLines: response.componentsSeparatedByString("\n"))
                var node = MoleculeGeometry.constructWith(molecule)
                nodeList.append(node)
            }
            self.molecules = nodeList
            self.startQuestions()
            })
    }

    
    func startQuestions() {
        //println(self.questions![0].text)
        
        var moleculeController = self.childViewControllers[0] as MoleculeController
        println("number of controllers: \(self.childViewControllers.count)")
        println("controller: \(moleculeController.description)")
        println("number of molecules: \(molecules!.count)")
        
        var controller = self.storyboard.instantiateViewControllerWithIdentifier("MoleculeController") as MoleculeController
        controller.setMolecule(molecules![0])
        
        self.navigationItem.hidesBackButton = true
    }

}
