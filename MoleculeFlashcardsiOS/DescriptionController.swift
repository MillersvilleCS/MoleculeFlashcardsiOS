//
//  DescriptionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit
import Foundation

class DescriptionController : UIViewController {
    
    @IBOutlet var highScoresButton: UIButton
    @IBOutlet var playButton: UIButton
    
    @IBOutlet var timeLimit: UILabel
    @IBOutlet var numberOfQuestions: UILabel
    @IBOutlet var gameDescription: UILabel
    
    @IBOutlet var scroller: UIScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGameData(timeLimitText: "30:00", numberOfQuestionsText: "5", gameDescriptionText: "game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test")
        
        scroller.scrollEnabled = true
        scroller.contentSize.height = 420
        scroller.contentSize.width = 209
    }
    
    func setGameData(#timeLimitText: String, numberOfQuestionsText: String,gameDescriptionText: String) {
        
        self.timeLimit.text = timeLimitText
        self.numberOfQuestions.text = numberOfQuestionsText
        self.gameDescription.text = gameDescriptionText
    

    }
    
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton)
        {
            var gameTitle = navigationController.topViewController.title
        
            self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("Game") as UIViewController, animated: true)
            self.navigationController.topViewController.title = gameTitle
        }
        else if sender.isEqual(highScoresButton)
        {
            println("high scores clicked")
        }
    }
}
