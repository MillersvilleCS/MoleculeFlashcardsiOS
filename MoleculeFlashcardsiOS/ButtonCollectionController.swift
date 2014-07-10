//
//  ButtonCollectionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/7/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class ButtonCollectionController: UICollectionViewController {
    
    var reuseIdentifier = "ButtonCell"
    var buttons = [UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton()]
    var answerSet : [Answer]?
    
    // Custom colors
    var buttonGrayPressed = UIColor(red: CGFloat(158/255.0), green: CGFloat(158/255.0), blue: CGFloat(158/255.0), alpha: CGFloat(1.0))
    var buttonGrayDefault = UIColor(red: CGFloat(209/255.0), green: CGFloat(209/255.0), blue: CGFloat(209/255.0), alpha: CGFloat(1.0))
    var buttonCorrectDefault = UIColor(red: CGFloat(0), green: CGFloat(153/255.0), blue: CGFloat(0), alpha: CGFloat(1.0))
    
    var buttonWrongColor = UIColor(red: CGFloat(1.0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
    var buttonGreenStartColor = UIColor(red: CGFloat(137/255.0), green: CGFloat(200/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0))
    var buttonGreenEndColor = UIColor(red: CGFloat(137/255.0), green: CGFloat(200/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0))
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView?) -> Int {
        return 1
    }
    
    // Set the initial cell display to the maximum number of answers
    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    override func collectionView(collectionView: UICollectionView?, cellForItemAtIndexPath indexPath: NSIndexPath?) -> UICollectionViewCell? {
        
        var myCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        let cellRow = indexPath?.row
        
        // Construct a cell with a button
        buttons[cellRow!].frame = CGRect(x: 0, y: 0, width: myCell.frame.width, height: myCell.frame.height)
        buttons[cellRow!].backgroundColor = buttonGrayDefault
        buttons[cellRow!].addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
        myCell.addSubview(buttons[cellRow!])
        
        return myCell
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func setButtonAnswers (answerSet: [Answer]) {
        self.answerSet = answerSet
        for var index = 0; index < answerSet.count; ++index {
            buttons[index].enabled = true;
            buttons[index].hidden = false;
            buttons[index].setTitle(answerSet[index].text, forState: UIControlState.Normal)
            buttons[index].tag = index
            buttons[index].backgroundColor = buttonGrayDefault
            buttons[index].alpha = 1.0
        }
        
        // Hide extra buttons
        for var indexToHide = answerSet.count; indexToHide < buttons.count; ++indexToHide {
            buttons[indexToHide].enabled = false
            buttons[indexToHide].hidden = true;
        }
    }
    
    func markAnswer(buttonIndex: Int, correct: Bool) {
        if correct {
            buttons[buttonIndex].backgroundColor = self.buttonGreenStartColor
            for button in buttons {
                if buttons[buttonIndex] != button {
                    button.enabled = false
                    button.alpha = 0.7
                }
            }
        } else {
            buttons[buttonIndex].backgroundColor = self.buttonWrongColor
        }
        buttons[buttonIndex].enabled = false
        
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        let answerIndex = sender.tag
        (navigationController.topViewController as GameController).submitAnswer(answerSet![answerIndex], buttonIndex: answerIndex)
    }
}