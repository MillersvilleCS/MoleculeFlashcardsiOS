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
        
        if password == passwordConfirm {
            user!.register(url: GameConstants.REQUEST_HANDLER_URL, username: username, password: password, email: email)
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
