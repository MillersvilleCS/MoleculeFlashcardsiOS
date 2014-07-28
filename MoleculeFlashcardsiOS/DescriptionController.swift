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
    
    @IBOutlet var imageView: UIImageView?
    
    @IBOutlet var highScoresButton: UIButton?
    @IBOutlet var playButton: UIButton?
    
    @IBOutlet var timeLimitLabel: UILabel?
    @IBOutlet var numberOfQuestionsLabel: UILabel?
    @IBOutlet var gameDescriptionTextView: UITextView?
    
    @IBOutlet var scroller: UIScrollView?
    
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
        
        imageView!.image = ImageLoader.load(url: game!.imageURL)
        
        highScoresButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        playButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        timeLimitLabel!.text = Time.formatTime(ms: game!.timeLimit)
        numberOfQuestionsLabel!.text = "\(game!.getNumberOfQuestions())"
        gameDescriptionTextView!.text = game!.description
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton) {
            var gameController = storyboard.instantiateViewControllerWithIdentifier("GameController") as GameController
            gameController.game = game!
            gameController.user = user!
            gameController.requestURL = requestURL!
            gameController.mediaURL = mediaURL!
            
            navigationController.pushViewController(gameController, animated: true)
            navigationController.topViewController.title = game!.name
        } else if sender.isEqual(highScoresButton) {
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("HighScoreController") as HighScoreController
            
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
}