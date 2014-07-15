//
//  LoginController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet var loginButton: UIButton
    @IBOutlet var registerButton: UIButton
    
    @IBOutlet var usernameField: UITextField
    @IBOutlet var passwordField: UITextField
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user, "User must be set in LoginController")
        registerButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        loginButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonClicked (sender:UIButton) {
        if (sender.isEqual(registerButton)) {
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("RegisterController") as RegisterController
            controller.user = user
            navigationController.pushViewController(controller, animated: true)
        }
        if sender.isEqual(loginButton) {
            user!.login(url: GameConstants.REQUEST_HANDLER_URL, username: usernameField.text, password: passwordField.text, onComplete: {(success: Bool) in
                
                dispatch_async(dispatch_get_main_queue(), ({
                    if success {
                        var mainController = self.navigationController.viewControllers[0] as UIViewController
                        self.navigationController.popToViewController(mainController, animated: true)
                    }
                    
                }))
            })
        }
    }
}
