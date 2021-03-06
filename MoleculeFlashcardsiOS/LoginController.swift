//
//  LoginController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var registerButton: UIButton?
    
    @IBOutlet var usernameField: UITextField?
    @IBOutlet var passwordField: UITextField?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        loginButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        usernameField!.delegate = self
        passwordField!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Advances to the next text field when "Next" is pressed & changes "Next" to "Done" at the last field.
    func textFieldShouldReturn (textField: UITextField) -> Bool {
        var nextTag: NSInteger = textField.tag + 1
        var nextResponder = textField.superview?.viewWithTag(nextTag)
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

    @IBAction func buttonClicked (sender:UIButton) {
        if (sender.isEqual(registerButton)) {
            var controller = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterController") as RegisterController
            controller.user = user
            navigationController?.pushViewController(controller, animated: true)
        }
        if sender.isEqual(loginButton) {
            user!.login(url: GameConstants.REQUEST_HANDLER_URL, username: usernameField!.text, password: passwordField!.text, onComplete: {(name: String, id: String, success: Bool, error: String) in
                
                dispatch_async(dispatch_get_main_queue(), ({
                    if success {
                        LoginInfoManager.writeInfo(name: name, id: id)
                        // Update the button icon displayed on the navigation bar.
                        var mainController = self.navigationController?.viewControllers[0] as MainController
                        mainController.navigationItem.setRightBarButtonItem(mainController.logoutButton, animated: true)
                        self.navigationController?.popToViewController(mainController, animated: true)
                    } else {
                        var errorPrompt = ErrorPrompt(message: error)
                        errorPrompt.display(controller: self, onComplete: {() in
                          
                        })
                    }
                }))
            })
        }
    }
}