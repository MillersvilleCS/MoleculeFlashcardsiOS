//
//  ErrorPrompt.swift
//  Flashcards
//
//  Created by exscitech on 7/28/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class ErrorPrompt {

    var message: String

    init(message: String) {
        self.message = message
    }
    
    func display(#controller: UIViewController, onComplete: () -> Void) {
        var  errorPrompt = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        errorPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            onComplete()
        }))
        controller.presentViewController(errorPrompt, animated: true, completion: nil)
    }
}