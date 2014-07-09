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
        
        var moleculeController = self.childViewControllers[0] as MoleculeController
        moleculeController.setQuestion(self.questions![0].text)
        println(moleculeController.questionLabel!.text)

        println("number of controllers: \(self.childViewControllers.count)")
        println("controller: \(moleculeController.description)")
        println("number of molecules: \(molecules!.count)")
        
        moleculeController.setMolecule(molecules![0])
       // println(controller.questionLabel!.text)
        
        moleculeController.view.setNeedsDisplay()
        moleculeController.view.setNeedsDisplayInRect(moleculeController.view.frame)
    
        /*
        
        Right now updating is delayed. This might help later:

        The guaranteed, rock solid way to force a UIView to re-render is [myView setNeedsDisplay]. If you're having trouble with that, you're likely running into one of these issues:

        You're calling it before you actually have the data, or your -drawRect: is over-caching something.

        You're expecting the view to draw at the moment you call this method. There is intentionally no way to demand "draw right now this very second" using the Cocoa drawing system. That would disrupt the entire view compositing system, trash performance and likely create all kinds of artifacting. There are only ways to say "this needs to be drawn in the next draw cycle."

        If what you need is "some logic, draw, some more logic," then you need to put the "some more logic" in a separate method and invoke it using -performSelector:withObject:afterDelay: with a delay of 0. That will put "some more logic" after the next draw cycle. See this question for an example of that kind of code, and a case where it might be needed (though it's usually best to look for other solutions if possible since it complicates the code).

        If you don't think things are getting drawn, put a breakpoint in -drawRect: and see when you're getting called. If you're calling -setNeedsDisplay, but -drawRect: isn't getting called in the next event loop, then dig into your view hierarchy and make sure you're not trying to outsmart is somewhere. Over-cleverness is the #1 cause of bad drawing in my experience. When you think you know best how to trick the system into doing what you want, you usually get it doing exactly what you don't want.
        */

        self.navigationItem.hidesBackButton = true
    }
}
