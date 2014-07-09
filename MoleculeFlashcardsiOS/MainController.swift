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
        
        var x = UIBarButtonItem(title: "L", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = x
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        if sender.isEqual(playButton) {
            self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("GameSelectionController") as UIViewController, animated: true)
        } else if sender.isEqual(tutorialButton) {
            self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("TutorialController") as UIViewController, animated: true)
        } else {
            self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("CreditsController") as UIViewController, animated: true)
        }
    }
}