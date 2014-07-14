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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        
    }
}
