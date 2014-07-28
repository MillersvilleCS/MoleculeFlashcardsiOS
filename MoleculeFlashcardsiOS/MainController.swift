//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class MainController : UIViewController {
    
    @IBOutlet var playButton: UIButton?
    @IBOutlet var creditsButton: UIButton?
    @IBOutlet var tutorialButton: UIButton?
    
    var user = User()

    var loginImage = UIImage(named: "login.png")
    var logoutImage = UIImage(named: "logout.png")
    
    var loginButton: UIBarButtonItem?
    var logoutButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        creditsButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        tutorialButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        loginButton = UIBarButtonItem(image: loginImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerButtonClicked:"))
        loginButton!.imageInsets = UIEdgeInsetsMake(15, 23, 7, 0)
        
        logoutButton = UIBarButtonItem(image: logoutImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("registerButtonClicked:"))
        logoutButton!.imageInsets = UIEdgeInsetsMake(5, 16, 7, 0)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Main Menu", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
        
        var loginInfo = LoginInfoManager.getInfo()?.componentsSeparatedByString("\n")
        
        // Ensure there is no extra whitespace.
        if loginInfo && loginInfo!.count == 2 {
            user.name = loginInfo![0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            user.id = loginInfo![1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            user.status = User.LoginStatus.LOGGED_IN
            navigationItem.setRightBarButtonItem(logoutButton, animated: true)
        } else {
            self.navigationItem.setRightBarButtonItem(loginButton, animated: true)
        }
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        // Play button clicked
        if sender.isEqual(playButton) {
            if user.status != User.LoginStatus.LOGGED_IN {
                // Display a dialog box warning the player if they aren't logged in
                dispatch_async(dispatch_get_main_queue(), ({
                    self.playButton!.titleLabel.alpha = 0.3

                    var confirmNoScorePrompt = UIAlertController(title: "Warning!", message: GameConstants.CONFIRM_NO_SCORE_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
                    confirmNoScorePrompt.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
                        self.playButton!.titleLabel.alpha = 1.0
                    }))
                    confirmNoScorePrompt.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
                        var controller = self.storyboard.instantiateViewControllerWithIdentifier("GameSelectionController") as GameSelectionController
                        controller.user = self.user
                        self.navigationController.pushViewController(controller, animated: true)
                    }))
                    self.presentViewController(confirmNoScorePrompt, animated: true, completion: nil)
                    }))
            } else {
                dispatch_async(dispatch_get_main_queue(), ({
                    self.playButton!.titleLabel.alpha = 0.3
                    var gameSelectionController = self.storyboard.instantiateViewControllerWithIdentifier("GameSelectionController") as GameSelectionController
                    gameSelectionController.user = self.user
                    self.navigationController.pushViewController(gameSelectionController, animated: true)
                }))
            }
        // Tutorial button clicked
        } else if sender.isEqual(tutorialButton) {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("TutorialController") as UIViewController, animated: true)
        // Credits button clicked
        } else {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("CreditsController") as UIViewController, animated: true)
        }
    }
    
    
    @IBAction func registerButtonClicked (sender: UIBarButtonItem) {
        if user.status == User.LoginStatus.LOGGED_IN {

            // Display lougout prompt
            dispatch_async(dispatch_get_main_queue(), ({
                var logoutPrompt = UIAlertController(title: "Logout", message: "\n\(self.user.name!)\(GameConstants.CONFIRM_LOGOUT_MESSAGE)", preferredStyle: UIAlertControllerStyle.Alert)
                logoutPrompt.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
                logoutPrompt.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
                    self.navigationItem.setRightBarButtonItem(self.loginButton, animated: true)
                    self.user = User()
                    LoginInfoManager.deleteInfo()
                }))
                
                self.presentViewController(logoutPrompt, animated: true, completion: nil)
            }))
        // Display login screen
        } else {
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("LoginController") as LoginController
            controller.user = user
            navigationController.pushViewController(controller, animated: true)
        }
    }
}