//
//  DescriptionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class DescriptionController : UIViewController {
    
    @IBOutlet var timeLabel: UILabel
    @IBOutlet var questionCountLabel: UILabel
    @IBOutlet var playButton: UIButton
    @IBOutlet var highScoresButton: UIButton
    @IBOutlet var descriptionTextView: UITextView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = "30:00"
        questionCountLabel.text = "5"
        descriptionTextView.text = "game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test game description text test"
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
