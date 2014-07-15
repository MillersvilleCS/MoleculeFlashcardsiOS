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
    
    var user = User()

    var loginImage = UIImage(named: "login.png")
    var logoutImage = UIImage(named: "logout.png")
    
    var loginButton: UIBarButtonItem?
    var logoutButton: UIBarButtonItem?
    
    var username : String?

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
            // Confirm to play without logging in
            var confirmNoScorePrompt = UIAlertController(title: "Warning!", message: GameMessages.CONFIRM_NO_SCORE, preferredStyle: UIAlertControllerStyle.Alert)
            
            confirmNoScorePrompt.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
                var controller = self.storyboard.instantiateViewControllerWithIdentifier("GameSelectionController") as GameSelectionController
                controller.user = self.user
                self.navigationController.pushViewController(controller, animated: true)
                }))
            confirmNoScorePrompt.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(confirmNoScorePrompt, animated: true, completion: nil)
            
        } else if sender.isEqual(tutorialButton) {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("TutorialController") as UIViewController, animated: true)
        } else {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("CreditsController") as UIViewController, animated: true)
        }
    }
    
    @IBAction func registerButtonClicked (sender: UIBarButtonItem) {
        if user.status == User.LoginStatus.LOGGED_IN {
            username = "Test"
            // Confirm logout
            var logoutPrompt = UIAlertController(title: "Logout", message: "\n\(username!) \(GameMessages.CONFIRM_LOGOUT)", preferredStyle: UIAlertControllerStyle.Alert)
            
            logoutPrompt.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
                self.navigationItem.setRightBarButtonItem(self.loginButton, animated: true)
                // Delete credentials
                }))
            logoutPrompt.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(logoutPrompt, animated: true, completion: nil)
        } else {
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("LoginController") as LoginController
            controller.user = user
            navigationController.pushViewController(controller, animated: true)
        }
    }
}