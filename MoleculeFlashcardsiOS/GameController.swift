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
    
    let WAIT_PERIOD: Int64 = 3000000000 // 3 billion nano seconds aka 3 seconds
        
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    var moleculeController: MoleculeController?
    var buttonController: ButtonViewController?
    
    var molecules: [SCNNode]?
    
    var timeRemaing = 0
    
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: Selector("applicationWillResignActive:"), name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("applicationWillTerminate:"), name: UIApplicationWillTerminateNotification, object: nil)
        
        navigationItem.hidesBackButton = true
        
        var controller = self.childViewControllers[0] as UIViewController
        if controller.restorationIdentifier == "MoleculeController" {
            moleculeController = self.childViewControllers[0] as? MoleculeController
            buttonController = self.childViewControllers[1] as? ButtonViewController
        } else {
            // This is just a precaution in case the storyboard has issues
            buttonController = self.childViewControllers[0] as? ButtonViewController
            moleculeController = self.childViewControllers[1] as? MoleculeController
            println("Warning, this may cause layout issues! Fix the storyboard!")
        }
        
        moleculeController!.loadingView!.startAnimating()

  
        // Keep the screen on while playing the game.
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        self.start()
    }
    
    // Returns to the Game Description screen if the user exits the app while a game is running.
    func applicationWillResignActive(application: UIApplication) {
        var gameDescriptionController = navigationController?.viewControllers[2] as UIViewController
        self.navigationController?.popToViewController(gameDescriptionController, animated: false)
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        notificationCenter.removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func start() {
        // Set time text and start timer (start here with 5 less seconds due to server timing glitch)
        self.timeRemaing = self.game!.timeLimit - 5000
        self.moleculeController!.timerLabel!.text = Time.formatTime(ms: self.timeRemaing)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0 as NSTimeInterval, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        // Load SDF files
        game!.start(url: requestURL!, user: user!,{(questions: [Question]) in
            var nodeList = [SCNNode]()

            for question in questions {
                var request = Request(url: "\(self.mediaURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                var convertedURL = NSURL.URLWithString("\(self.mediaURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                
                // Convert the response to a string
                var error: NSError?
                var gameData: NSData = NSData.dataWithContentsOfURL(convertedURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
                var response: String = NSString(data: gameData, encoding: NSUTF8StringEncoding)
                
                // Parse the data
                var molecule: Molecule = SDFParser.parse(sdfFileLines: response.componentsSeparatedByString("\n"))
                // Create the geometry
                var node = MoleculeGeometry.constructWith(molecule)
                // Add the geometry to the scene
                nodeList.append(node)
            }
            self.molecules = nodeList
            
            // When doing UI updates you must be on the main thread - these async closures in the request API don't happen in the main thread
            // iOS global dispatch lets us put UI actions on the main thread again
            // tell it what thread queue to use (main), and what to do (closure)
            dispatch_async(dispatch_get_main_queue(), ({
                // Timer SHOULD be started here
                self.nextQuestion()
                
                self.moleculeController!.loadingView!.stopAnimating()
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
        // If the game is finished end the game
        if game!.state == Game.GameState.FINISHED {
            endGame()
            return
        }
        
        moleculeController!.setQuestion(game!.getCurrentQuestion().text, molecule: molecules![game!.questionIndex])
        buttonController!.setButtonAnswers(game!.getAvailableAnswers())
    }
    
    func submitAnswer (response: Answer, buttonIndex: Int) {
        // If the game isn't loaded do nothing
        if game!.state == Game.GameState.WAITING_TO_START {
            return
        }
        
        self.game!.submit(url: requestURL!, user: self.user!, answer: response, time: self.game!.timeLimit - self.timeRemaing, {(isCorrect: Bool, scoreModifier: Int, error: String!) in
            if (error != nil) {
                // Display a dialog box and return to the description controller if there is an error
                dispatch_async(dispatch_get_main_queue(), ({
                    var errorPrompt = ErrorPrompt(message: error!)
                    errorPrompt.display(controller: self, onComplete: {() in
                        var gameDescriptionController = self.navigationController?.viewControllers[2] as UIViewController
                        self.navigationController?.popToViewController(gameDescriptionController, animated: false)
                    })
                }))
            } else {
                // Mark the question as either right or wrong and proceed to the next
                dispatch_async(dispatch_get_main_queue(), ({
                    self.buttonController!.markAnswer(buttonIndex, correct: isCorrect)
                    self.moleculeController!.setScore(scoreModifier)
                    
                    if isCorrect {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.WAIT_PERIOD), dispatch_get_main_queue(), ({
                            self.nextQuestion()
                        }))
                    }
                }))
            }
        })
    }
    
    func endGame() {
        var waitTime: Int64 = 0
        let gameTime = self.game!.timeLimit - self.timeRemaing
        
        // If we didn't run out of time, wait 3 seconds before ending game (last question)
        if self.timeRemaing != 0 {
            waitTime = self.WAIT_PERIOD
        }
        self.game!.end(url: requestURL!, user: self.user!, gameTime: gameTime, onComplete: {(rank: Int, finalScore: Int, error: String!) in
            
            if (error != nil) {
                // Display a dialog box and return to the description controller if there is an error
                dispatch_async(dispatch_get_main_queue(), ({
                    var errorPrompt = ErrorPrompt(message: error!)
                    errorPrompt.display(controller: self, onComplete: {() in
                        var gameDescriptionController = self.navigationController?.viewControllers[2] as UIViewController
                        self.navigationController?.popToViewController(gameDescriptionController, animated: false)
                    })
                }))
            } else {
                // End the game and go to the final controller
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitTime), dispatch_get_main_queue(), ({
                    var finalController = self.storyboard?.instantiateViewControllerWithIdentifier("FinalController") as FinalController
                    finalController.game = self.game
                    finalController.user = self.user
                    finalController.rank = rank
                    finalController.score = finalScore
                
                    self.navigationController?.pushViewController(finalController as UIViewController, animated: true)
                }))
            }
        })
    }
}
