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
    var answerSet: [Answer]?
    var responseCorrect = false
    var finished = false
    
    // Custom colors
    var buttonWrongColor = UIColor(red: CGFloat(1.0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
    var buttonGreenStartColor = UIColor(red: CGFloat(137/255.0), green: CGFloat(200/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0))
    var buttonGreenEndColor = UIColor(red: CGFloat(137/255.0), green: CGFloat(200/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        assert(game)
        assert(user)
        assert(requestURL)
        assert(mediaURL)
        
        start()
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
            self.startQuestions() // COMMENT OUT IF YOU CHANGE BELOW
            self.finished = true
            })
        
        //while(!finished) {} //   ADD THESE TO MAKE QUESTION APPEAR IMMEDIATELY
        //startQuestions()    // buttons then never appear?
        //the problem is that the setNeedsDisplay needs to be run in the main thread - if you call it from this asyc closure, it is NOT in the main thread
        //waiting then running it IS in the main thread
        //no idea why it makes buttons disappear though
        //this is according to this guy, on the answer you originally found: http://stackoverflow.com/a/4284340
    }
    
    func startQuestions() {
        
        // Set the molecule to display
        var moleculeController = self.childViewControllers[0] as MoleculeController
        moleculeController.setQuestion(self.questions![0].text, molecule: molecules![0])
        moleculeController.view.setNeedsDisplay()
        //moleculeController.view.setNeedsDisplayInRect(moleculeController.view.frame)
        
        // Set the answer choices
        answerSet = self.questions![0].answers
        var buttonController = self.childViewControllers[1] as ButtonCollectionController
        buttonController.setButtonAnswers(answerSet!)
        
        println("number of controllers: \(self.childViewControllers.count)")
        println("controller: \(moleculeController.description)")
        println("number of molecules: \(molecules!.count)")
        
        //buttonController.becomeFirstResponder()
        //buttonController.collectionView.becomeFirstResponder()
        println("button controller first responder? \(buttonController.isFirstResponder())")
        println("collection view first responder? \(buttonController.collectionView.isFirstResponder())")
        
        //buttonController.view.setNeedsDisplayInRect(buttonController.view.frame)
        //buttonController.view.reloadInputViews()
        
        //buttonController.collectionView.becomeFirstResponder()
        //buttonController.collectionView.reloadInputViews()
        //buttonController.collectionView.reloadData()
        //buttonController.collectionView.reloadItemsAtIndexPaths(buttonController.collectionView.indexPathsForVisibleItems())


        /*
        
        Right now updating is delayed. This might help later:

        The guaranteed, rock solid way to force a UIView to re-render is [myView setNeedsDisplay]. If you're having trouble with that, you're likely running into one of these issues:

        You're calling it before you actually have the data, or your -drawRect: is over-caching something.

        You're expecting the view to draw at the moment you call this method. There is intentionally no way to demand "draw right now this very second" using the Cocoa drawing system. That would disrupt the entire view compositing system, trash performance and likely create all kinds of artifacting. There are only ways to say "this needs to be drawn in the next draw cycle."

        If what you need is "some logic, draw, some more logic," then you need to put the "some more logic" in a separate method and invoke it using -performSelector:withObject:afterDelay: with a delay of 0. That will put "some more logic" after the next draw cycle. See this question for an example of that kind of code, and a case where it might be needed (though it's usually best to look for other solutions if possible since it complicates the code).

        If you don't think things are getting drawn, put a breakpoint in -drawRect: and see when you're getting called. If you're calling -setNeedsDisplay, but -drawRect: isn't getting called in the next event loop, then dig into your view hierarchy and make sure you're not trying to outsmart is somewhere. Over-cleverness is the #1 cause of bad drawing in my experience. When you think you know best how to trick the system into doing what you want, you usually get it doing exactly what you don't want.
        */
    }

    
    func submitAnswer (response: Answer, buttonId: Int) -> Bool {
        println("response is \(response.text)")
        self.game!.submit(url: requestURL!, user: self.user!, answer: response, time: 0, {(isCorrect: Bool, scoreModifier: Int) in
            self.responseCorrect = isCorrect
            println(isCorrect)
            println(scoreModifier)
            
            // Update the buttons to reflect correct/incorrect responses
            var buttonController = self.childViewControllers[1] as ButtonCollectionController
            if !isCorrect {
                buttonController.buttons[buttonId].backgroundColor = self.buttonWrongColor
            }
            else {
                buttonController.buttons[buttonId].backgroundColor = self.buttonGreenStartColor
            }
        })
        return responseCorrect
    }
}
