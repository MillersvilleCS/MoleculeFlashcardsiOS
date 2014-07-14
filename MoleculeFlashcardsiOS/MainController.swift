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
    
    var loggedIn = false

    var loginImage = UIImage(named: "login.png")
    var logoutImage = UIImage(named: "logout.png")
    
    var loginButton: UIBarButtonItem?
    var logoutButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        creditsButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        tutorialButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        loginButton = UIBarButtonItem(image: loginImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerButtonClicked:"))
        loginButton!.imageInsets = UIEdgeInsetsMake(15, 23, 7, 0)
        
        logoutButton = UIBarButtonItem(image: logoutImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerButtonClicked:"))
        logoutButton!.imageInsets = UIEdgeInsetsMake(5, 16, 7, 0)
        
        self.navigationItem.setRightBarButtonItem(loginButton, animated: true)
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
        if loggedIn {
            // Prompt to confirm logout
            var logout = true
            if logout {
                self.navigationItem.setRightBarButtonItem(self.loginButton, animated: true)
                loggedIn = false
            }
        } else {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("LoginController") as UIViewController, animated: true)
        }
    }
}