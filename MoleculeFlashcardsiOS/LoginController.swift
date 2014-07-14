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
    }
    
    @IBAction func buttonClicked (sender:UIButton) {
        if (sender.isEqual(registerButton)) {
            navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("RegisterController") as UIViewController, animated: true)
        }
    }
}
