//
//  RegisterController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet var registerButton: UIButton?
    
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var usernameTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var confirmPasswordTextField: UITextField?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user, "User must be set in RegisterController")
        registerButton!.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        
        emailTextField!.delegate = self
        usernameTextField!.delegate = self
        passwordTextField!.delegate = self
        confirmPasswordTextField!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn (textField: UITextField) -> Bool {
        var nextTag: NSInteger = textField.tag + 1
        var nextResponder = textField.superview.viewWithTag(nextTag)
        if (nextResponder) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        var email = emailTextField!.text
        var username = usernameTextField!.text
        var password = passwordTextField!.text
        var passwordConfirm = confirmPasswordTextField!.text
        
        if password.compare(passwordConfirm) == 0  {
            user!.register(url: GameConstants.REQUEST_HANDLER_URL, username: username, password: password, email: email,onComplete: {(name: String, id: String, success: Bool, error: String) in
                
                dispatch_async(dispatch_get_main_queue(), ({
                    if success {
                        LoginInfoManager.writeInfo(name: name, id: id)
                        var mainController = self.navigationController.viewControllers[0] as MainController
                        mainController.navigationItem.setRightBarButtonItem(mainController.logoutButton, animated: true)
                        self.navigationController.popToViewController(mainController, animated: true)
                    } else {
                        var  errorPrompt = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        errorPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                            self.passwordTextField!.text = ""
                            self.confirmPasswordTextField!.text = ""
                            }))
                        self.presentViewController(errorPrompt, animated: true, completion: nil)
                    }
                }))
            })
        } else {
            var  passwordErrorPrompt = UIAlertController(title: "Error", message: GameConstants.PASSWORD_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
            
            passwordErrorPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                    self.passwordTextField!.text = ""
                    self.confirmPasswordTextField!.text = ""
                }))
            self.presentViewController(passwordErrorPrompt, animated: true, completion: nil)
        }
        
    }
}
