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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
        loginButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonClicked (sender:UIButton) {
        if (sender.isEqual(registerButton)) {
            var controller = self.storyboard.instantiateViewControllerWithIdentifier("RegisterController") as RegisterController
            navigationController.pushViewController(controller, animated: true)
        }
        if sender.isEqual(loginButton) {

        }
    }
}
