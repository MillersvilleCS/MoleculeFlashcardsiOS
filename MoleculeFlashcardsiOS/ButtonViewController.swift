//
//  ButtonViewController.swift
//  Flashcards
//
//  Created by exscitech on 7/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit
import QuartzCore

class ButtonViewController: UIViewController {

    @IBOutlet var button1: UIButton?
    @IBOutlet var button2: UIButton?
    @IBOutlet var button3: UIButton?
    @IBOutlet var button4: UIButton?
    @IBOutlet var button5: UIButton?
    @IBOutlet var button6: UIButton?
        
    var buttons: [UIButton]?
    var answerSet: [Answer]?
    var animationsRunning = false
    var timeOfLastAnswer = NSNumber?()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button1!, button2!, button3!, button4!, button5!, button6!]
        createButtons()
        view.exclusiveTouch = true
        timeOfLastAnswer = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Create the buttons for displaying answers
    func createButtons() -> Void {
        for button in buttons! {
            button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = GameConstants.BUTTON_ROUNDNESS
            button.titleLabel.adjustsFontSizeToFitWidth = true
            button.titleLabel.minimumScaleFactor = 0.5
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
    }
    
    func setButtonAnswers (answerSet: [Answer]) {
        animateButtonStopAll()
        self.answerSet = answerSet
        for var index = 0; index < answerSet.count; ++index {
            buttons![index].enabled = true;
            buttons![index].userInteractionEnabled = true;
            buttons![index].hidden = false;
            buttons![index].setTitle(answerSet[index].text, forState: UIControlState.Normal)
            buttons![index].tag = index
            buttons![index].backgroundColor = GameConstants.BUTTON_GRAY_DEFAULT_COLOR
            buttons![index].alpha = 1.0
            buttons![index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        // Hide extra buttons
        for var indexToHide = answerSet.count; indexToHide < buttons!.count; ++indexToHide {
            buttons![indexToHide].enabled = false
            buttons![indexToHide].userInteractionEnabled = false
            buttons![indexToHide].hidden = true;
        }
    }
    
    func markAnswer(buttonIndex: Int, correct: Bool) {
        
        if correct {
            buttons![buttonIndex].backgroundColor = GameConstants.BUTTON_GREEN_COLOR
            for button in buttons! {
                if buttons![buttonIndex] != button {
                    button.alpha = 0.7
                }
                button.enabled = false
                button.userInteractionEnabled = false
            }
        } else {
            animateButtonStopAll()
            buttons![buttonIndex].backgroundColor = GameConstants.BUTTON_WRONG_COLOR
            buttons![buttonIndex].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            buttons![buttonIndex].enabled = false
            buttons![buttonIndex].userInteractionEnabled = false
        }
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
        for button in self.buttons! {
            button.alpha = 1.0
        }
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        var timeOfCurrentAnswer = CACurrentMediaTime()
        if (timeOfCurrentAnswer - timeOfLastAnswer!) >= 0.31459 {
            timeOfLastAnswer = timeOfCurrentAnswer
            
            let answerIndex = sender.tag
            (navigationController.topViewController as GameController).submitAnswer(answerSet![answerIndex], buttonIndex: answerIndex)
            animateButton(sender)
        }
    }
}