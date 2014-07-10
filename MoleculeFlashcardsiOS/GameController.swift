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
    
    let WAIT_PERIOD: Int64 = 3 * NSEC_PER_SEC.asSigned()
        
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    var moleculeController: MoleculeController?
    var buttonController: ButtonCollectionController?
    
    var molecules: [SCNNode]?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        assert(game, "'game' not set on GameController")
        assert(user, "'user' not set on GameController")
        assert(requestURL, "'requestURL' not set on GameController")
        assert(mediaURL, "'mediaURL' not set on GameController")
        
        moleculeController = self.childViewControllers[0] as? MoleculeController
        buttonController = self.childViewControllers[1] as? ButtonCollectionController
        
        assert(moleculeController, "'moleculeController' could not be found on GameController")
        assert(buttonController, "'buttonController' could not be found on GameController")
        
        start()
    }
    
    func start() {
        game!.start(url: requestURL!, user: user!,{(questions: [Question]) in
            var nodeList = [SCNNode]()

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
            
            //when doing UI updates you must be on the main thread - these async closures in the request API don't happen in the main thread
            //iOS global dispatch lets us put UI actions on the main thread again
            //tell it what thread queue to use (main), and what to do (closure)
            dispatch_async(dispatch_get_main_queue(), ({
                self.nextQuestion()
            }))
        })
    }
    
    func nextQuestion() {
        if game!.state == Game.GameState.FINISHED {
            println("THE GAME IS OVER, THIS SHOULD LOAD A NEW SCREEN!")
            return
        }
        
        moleculeController!.setQuestion(game!.getCurrentQuestion().text, molecule: molecules![game!.questionIndex])
        
        buttonController!.setButtonAnswers(game!.getAvailableAnswers())
    }
    
    func submitAnswer (response: Answer, buttonIndex: Int) {
        self.game!.submit(url: requestURL!, user: self.user!, answer: response, time: 0, {(isCorrect: Bool, scoreModifier: Int) in
            
            //we need to update the button color in the main thread
            dispatch_async(dispatch_get_main_queue(), ({
  
                self.buttonController!.markAnswer(buttonIndex, correct: isCorrect)
   
                self.moleculeController!.setScore(scoreModifier)
                
                if isCorrect {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.WAIT_PERIOD), dispatch_get_main_queue(), ({
                        self.nextQuestion()
                    }))
                }
            }))
        })
    }
}
