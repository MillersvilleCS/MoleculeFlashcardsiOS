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
    
    @IBOutlet var imageView: UIImageView
    
    @IBOutlet var highScoresButton: UIButton
    @IBOutlet var playButton: UIButton
    
    @IBOutlet var timeLimitLabel: UILabel
    @IBOutlet var numberOfQuestionsLabel: UILabel
    @IBOutlet var gameDescriptionLabel: UILabel
    
    @IBOutlet var scroller: UIScrollView
    
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(game)
        assert(user)
        assert(requestURL)
        assert(mediaURL)
        
        imageView.image = ImageLoader.load(url: game!.imageURL)
        
        highScoresButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        playButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        timeLimitLabel.text = "\(game!.timeLimit)"
        numberOfQuestionsLabel.text = "\(game!.getNumberOfQuestions())"
        gameDescriptionLabel.text = game!.description
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton) {
            var gameTitle = navigationController.topViewController.title
            
            var controller = storyboard.instantiateViewControllerWithIdentifier("GameController") as GameController
            controller.game = game!
            controller.user = user!
            controller.requestURL = requestURL!
            controller.mediaURL = mediaURL!
            
            navigationController.pushViewController(controller, animated: true)
            navigationController.topViewController.title = gameTitle
        }
        else if sender.isEqual(highScoresButton) {
            println("high scores clicked")
        }
    }
}
