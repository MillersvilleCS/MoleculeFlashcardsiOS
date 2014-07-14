//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class MainController : UIViewController {
    
    @IBOutlet var playButton: UIButton
    @IBOutlet var creditsButton: UIButton
    @IBOutlet var tutorialButton: UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x = UIBarButtonItem(title: "R", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerButtonClicked:"))
        self.navigationItem.rightBarButtonItem = x
        
        playButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        creditsButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        tutorialButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton) {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("GameSelectionController") as UIViewController, animated: true)
        } else if sender.isEqual(tutorialButton) {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("TutorialController") as UIViewController, animated: true)
        } else {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("CreditsController") as UIViewController, animated: true)
        }
    }
    
    @IBAction func registerButtonClicked (sender: UIBarButtonItem) {
        navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("LoginController") as UIViewController, animated: true)
    }
}