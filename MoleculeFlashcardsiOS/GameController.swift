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
    
    var questions: [Question]?
    var molecules: [SCNNode]?
    var answerSet: [Answer]?
    var responseCorrect = false
    var questionIndex = 0

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
            
            //when doing UI updates you must be on the main thread - these async closures in the request API don't happen in the main thread
            //iOS global dispatch lets us put UI actions on the main thread again
            //tell it what thread queue to use (main), and what to do (closure)
            dispatch_async(dispatch_get_main_queue(), ({
                self.nextQuestion()
            }))
        })
    }
    
    func nextQuestion() {
        questionIndex++
        if questionIndex >= questions!.count {
            println("THE GAME IS OVER, THIS SHOULD LOAD A NEW SCREEN!")
            return
        }
        // Set the molecule to display
        var moleculeController = self.childViewControllers[0] as MoleculeController
        moleculeController.setQuestion(self.questions![questionIndex].text, molecule: molecules![questionIndex])
        
        // Set the answer choices
        answerSet = self.questions![questionIndex].answers
        var buttonController = self.childViewControllers[1] as ButtonCollectionController
        buttonController.setButtonAnswers(answerSet!)
    }
    
    func submitAnswer (response: Answer, buttonIndex: Int) {
        self.game!.submit(url: requestURL!, user: self.user!, questionId: questions![questionIndex].id, answer: response, time: 0,
            {(isCorrect: Bool, scoreModifier: Int) in
            
            //we need to update the button color in the main thread
            dispatch_async(dispatch_get_main_queue(), ({
                self.responseCorrect = isCorrect
                
                // Update the buttons to reflect correct/incorrect responses
                var buttonController = self.childViewControllers[1] as ButtonCollectionController
                buttonController.markAnswer(buttonIndex, correct: isCorrect)
                
                println("Chose \(response.text)")
                
                if isCorrect {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.WAIT_PERIOD), dispatch_get_main_queue(), ({
                        self.nextQuestion()
                    }))
                }
            }))
        })
    }
}
