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
    var user: User?
    var score: Int?
    var rank: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        scoreLabel!.text = "Score: \(score!)"
        rankLabel!.text = "Rank: #\(rank!)"
        
        if rank <= GameConstants.HIGHSCORE_ENTRIES_TO_SHOW  && user!.status == LoginStatus.LOGGED_IN {
            updateHighScoresEntries(HighscoresEntry(rank: rank!, score: score!, username: user!.name!))
        }
        
        navigationItem.hidesBackButton = true
    }
    
    func updateHighScoresEntries(newHighScore: HighscoresEntry) {
        
        var newEntry = newHighScore
        let highscores = game!.highscores
        
        for var entryIndex = newHighScore.rank - 1; entryIndex < highscores.entryCount(); ++entryIndex {
            highscores.entries[entryIndex].rank++
            
            var entryToMove = highscores.entries[entryIndex]
            highscores.entries[entryIndex] = newEntry
            newEntry = entryToMove
        }
    }
    
    // Return to the Game Description screen.
    @IBAction func buttonClicked(sender: UIButton) {
        var descriptionController = navigationController?.viewControllers[2] as DescriptionController
        navigationController?.popToViewController(descriptionController, animated: true)
    }
}