//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class FinalController : UIViewController {
    
    @IBOutlet var backButton: UIButton
    
    @IBOutlet var scoreLabel: UILabel
    @IBOutlet var rankLabel: UILabel
    
    var game: Game?
    var score: Int?
    var rank: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        backButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        scoreLabel.text = "Score: \(score!)"
        rankLabel.text = "Rank: #\(rank!)"
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        navigationController.popToViewController(navigationController.viewControllers[2] as UIViewController, animated: true)
    }
}