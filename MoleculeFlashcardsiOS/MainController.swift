//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class MainController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x = UIBarButtonItem(title: "L", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = x
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        self.navigationController.pushViewController(self.storyboard.instantiateViewControllerWithIdentifier("GameSelection") as UIViewController, animated: true)
    }
}