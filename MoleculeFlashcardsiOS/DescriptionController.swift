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
        
        self.timeLimitLabel.text = "\(game!.timeLimit)"
       // self. = "\(game!.timeLimit)"
        self.numberOfQuestionsLabel.text = "\(game!.getNumberOfQuestions())"
        self.gameDescriptionLabel.text = game!.description
        self.imageView.image = ImageLoader.load(url: game!.imageURL)
        
        scroller.scrollEnabled = true
        scroller.contentSize.height = 320
        scroller.contentSize.width = 200
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton)
        {
            var gameTitle = navigationController.topViewController.title
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("GameController") as GameController
            
            controller.game = game!
            controller.user = user!
            controller.requestURL = requestURL!
            controller.mediaURL = mediaURL!
            self.navigationController.pushViewController(controller, animated: true)

            //self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("Game") as UIViewController, animated: true)
            self.navigationController.topViewController.title = gameTitle
        }
        else if sender.isEqual(highScoresButton)
        {
            println("high scores clicked")
        }
    }
}
