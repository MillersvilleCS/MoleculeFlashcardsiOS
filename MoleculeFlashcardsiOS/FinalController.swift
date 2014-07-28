//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class FinalController : UIViewController {
    
    @IBOutlet var backButton: UIButton?
    
    @IBOutlet var scoreLabel: UILabel?
    @IBOutlet var rankLabel: UILabel?
    
    var game: Game?
    var score: Int?
    var rank: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        backButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        scoreLabel!.text = "Score: \(score!)"
        rankLabel!.text = "Rank: #\(rank!)"
        
        var descriptionController = navigationController.viewControllers[2] as DescriptionController
        var username = descriptionController.user!.name
        
        if rank <= 10  && username != nil {
            updateHighScoresEntries(HighScores.Entry(rank: rank!, score: score!, username: username!))
        }
    }
    
    func updateHighScoresEntries(newHighScore: HighScores.Entry) {
        
        var descriptionController: DescriptionController = navigationController.viewControllers[2] as DescriptionController
        var entryToMove : HighScores.Entry?
        var newEntry = newHighScore
        
        for var entryIndex = newHighScore.rank - 1; entryIndex < descriptionController.game!.highscores.entryCount(); ++entryIndex {
            descriptionController.game!.highscores.entries[entryIndex].rank++
            
            entryToMove = descriptionController.game!.highscores.entries[entryIndex]
            descriptionController.game!.highscores.entries[entryIndex] = newEntry
            newEntry = entryToMove!
        }
    }
    
    // Return to the Game Description screen.
    @IBAction func buttonClicked(sender: UIButton) {
        navigationController.popToViewController(navigationController.viewControllers[2] as UIViewController, animated: true)
    }
}