//
//  DescriptionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class DescriptionController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        var gameTitle = navigationController.topViewController.title
        
        self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("Game") as UIViewController, animated: true)
        self.navigationController.topViewController.title = gameTitle
    }
}
