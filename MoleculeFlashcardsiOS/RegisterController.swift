//
//  RegisterController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet var registerButton: UIButton
    
    @IBOutlet var emailTextField: UITextField
    @IBOutlet var usernameTextField: UITextField
    @IBOutlet var passwordTextField: UITextField
    @IBOutlet var confirmPasswordTextField: UITextField
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user, "User must be set in RegisterController")
        registerButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        var email = emailTextField.text
        var username = usernameTextField.text
        var password = passwordTextField.text
        var passwordConfirm = confirmPasswordTextField.text
        
        if password.compare(passwordConfirm) == 0  {
            user!.register(url: GameConstants.REQUEST_HANDLER_URL, username: username, password: password, email: email,onComplete: {(success: Bool, error: String) in
                
                dispatch_async(dispatch_get_main_queue(), ({
                    if success {
                        var mainController = self.navigationController.viewControllers[0] as MainController
                        mainController.navigationItem.setRightBarButtonItem(mainController.logoutButton, animated: true)
                        self.navigationController.popToViewController(mainController, animated: true)
                    } else {
                        var  errorPrompt = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        errorPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                            self.passwordTextField.text = ""
                            self.confirmPasswordTextField.text = ""
                            }))
                        self.presentViewController(errorPrompt, animated: true, completion: nil)
                    }
                }))
            })
        } else {
            var  passwordErrorPrompt = UIAlertController(title: "Error", message: GameMessages.PASSWORD_ERROR, preferredStyle: UIAlertControllerStyle.Alert)
            
            passwordErrorPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                    self.passwordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                }))
            self.presentViewController(passwordErrorPrompt, animated: true, completion: nil)
        }
        
    }
}
