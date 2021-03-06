//
//  ButtonCollectionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/7/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class ButtonCollectionController: UIViewController {
    
    var buttons = [UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton()]
    var answerSet : [Answer]?
    var animationsRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // Create the buttons for displaying answers
    func createButtons() -> Void {
        
        let index = 0
        
        for button in buttons {
            buttons[index].addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
            buttons[index].layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
            buttons[index].titleLabel.adjustsFontSizeToFitWidth = true
            buttons[index].titleLabel.minimumScaleFactor = 0.5
            buttons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
    }
    
    func setButtonAnswers (answerSet: [Answer]) {
        animateButtonStopAll()
        self.answerSet = answerSet
        for var index = 0; index < answerSet.count; ++index {
            buttons[index].enabled = true;
            buttons[index].hidden = false;
            buttons[index].setTitle(answerSet[index].text, forState: UIControlState.Normal)
            buttons[index].tag = index
            buttons[index].backgroundColor = GameConstants.BUTTON_GRAY_DEFAULT_COLOR
            buttons[index].alpha = 1.0
            buttons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        // Hide extra buttons
        for var indexToHide = answerSet.count; indexToHide < buttons.count; ++indexToHide {
            buttons[indexToHide].enabled = false
            buttons[indexToHide].hidden = true;
        }
    }
    
    func markAnswer(buttonIndex: Int, correct: Bool) {
        
        if correct {
            buttons[buttonIndex].backgroundColor = GameConstants.BUTTON_GREEN_COLOR
            for button in buttons {
                if buttons[buttonIndex] != button {
                    button.alpha = 0.7
                }
                button.enabled = false
            }
        } else {
            animateButtonStopAll()
            buttons[buttonIndex].backgroundColor = GameConstants.BUTTON_WRONG_COLOR
        }
        buttons[buttonIndex].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttons[buttonIndex].enabled = false
        
    }
    
    func animateButton(button: UIButton) {
        self.animationsRunning = true
        self.animateLow(button: button)
    }
    
    func animateHigh(#button: UIButton) {
        UIView.animateWithDuration(0.5, animations: {() in
                button.alpha = 1
            }, completion:  { (finished: Bool) in
                if self.animationsRunning {
                    self.animateLow(button: button)
                }
            })
    }
    
    func animateLow(#button: UIButton) {
        UIView.animateWithDuration(0.5, animations: {() in
                button.alpha = 0.4
            }, completion:  { (finished: Bool) in
                if self.animationsRunning {
                    self.animateHigh(button: button)
                }
            })
    }
    
    func animateButtonStopAll() {
        self.animationsRunning = false
        for button in self.buttons {
            button.alpha = 1.0
        }
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        let answerIndex = sender.tag
        (navigationController.topViewController as GameController).submitAnswer(answerSet![answerIndex], buttonIndex: answerIndex)
        
        animateButton(sender)
    }
}