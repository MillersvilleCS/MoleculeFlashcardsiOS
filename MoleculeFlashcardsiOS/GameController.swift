//
//  GameController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit
import SceneKit

class GameController : UIViewController, UIApplicationDelegate {
    
    let WAIT_PERIOD: Int64 = 3 * NSEC_PER_SEC.asSigned()
        
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    var moleculeController: MoleculeController?
    var buttonController: ButtonCollectionController?
    
    var molecules: [SCNNode]?
    
    var timeRemaing = 0
    
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: Selector("applicationWillResignActive:"), name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("applicationWillTerminate:"), name: UIApplicationWillTerminateNotification, object: nil)
        
        navigationItem.hidesBackButton = true
        
        assert(game, "'game' not set on GameController")
        assert(user, "'user' not set on GameController")
        assert(requestURL, "'requestURL' not set on GameController")
        assert(mediaURL, "'mediaURL' not set on GameController")
        
        var controller = self.childViewControllers[0] as UIViewController
        if controller.restorationIdentifier == "MoleculeController" {
            moleculeController = self.childViewControllers[0] as? MoleculeController
            buttonController = self.childViewControllers[1] as? ButtonCollectionController
        } else {
            buttonController = self.childViewControllers[0] as? ButtonCollectionController
            moleculeController = self.childViewControllers[1] as? MoleculeController
            println("Warning, this may cause layout issues! Fix the storyboard!")
        }
        
        assert(moleculeController, "'moleculeController' could not be found on GameController")
        assert(buttonController, "'buttonController' could not be found on GameController")
        
        moleculeController!.loadingView.startAnimating()
        
        self.start()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        var gameDescriptionController = navigationController.viewControllers[2] as UIViewController
        self.navigationController.popToViewController(gameDescriptionController, animated: false)
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        notificationCenter.removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func start() {
        //set time text and start timer (start here with 5 less seconds do to server timing glitch)
        self.timeRemaing = self.game!.timeLimit - 5000
        self.moleculeController!.timerLabel!.text = Time.formatTime(ms: self.timeRemaing)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0 as NSTimeInterval, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        //load SDF files
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
                //timer SHOULD be started here
                self.nextQuestion()
                
                self.moleculeController!.loadingView.stopAnimating()
            }))
        })
    }
    
    func decreaseTime() {
        if self.timeRemaing > 0 {
            self.timeRemaing -= 1000
            self.moleculeController!.timerLabel!.text = Time.formatTime(ms: self.timeRemaing)
            
            if self.timeRemaing == 0 {
                endGame()
            }
        }
    }
    
    func nextQuestion() {
        if game!.state == Game.GameState.FINISHED {
            endGame()
            return
        }
        
        moleculeController!.setQuestion(game!.getCurrentQuestion().text, molecule: molecules![game!.questionIndex])
        
        buttonController!.setButtonAnswers(game!.getAvailableAnswers())
    }
    
    func submitAnswer (response: Answer, buttonIndex: Int) {
        self.game!.submit(url: requestURL!, user: self.user!, answer: response, time: self.game!.timeLimit - self.timeRemaing, {(isCorrect: Bool, scoreModifier: Int) in
            
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
    
    func endGame() {
        var waitTime: Int64 = 0
        let gameTime = self.game!.timeLimit - self.timeRemaing
        
        //if we didn't run out of time, wait 3 seconds before ending game (last question)
        if self.timeRemaing != 0 {
            waitTime = self.WAIT_PERIOD
        }
        println("user: \(self.user!.id)")
        self.game!.end(url: requestURL!, user: self.user!, gameTime: gameTime, onComplete: {(rank: Int, finalScore: Int) in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitTime), dispatch_get_main_queue(), ({
                var finalController = self.storyboard.instantiateViewControllerWithIdentifier("FinalController") as FinalController
                finalController.rank = rank
                finalController.score = finalScore
                
                self.navigationController.pushViewController( finalController as UIViewController, animated: true)
            }))
        })
    }
}
