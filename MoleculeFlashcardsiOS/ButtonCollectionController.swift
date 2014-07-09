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
    
    var buttons = [UIButton(frame: CGRectMake(0, 0, 152, 50)), UIButton(frame: CGRectMake(0, 0, 152, 50)), UIButton(frame: CGRectMake(0, 0, 152, 50)), UIButton(frame: CGRectMake(0, 0, 152, 50)), UIButton(frame: CGRectMake(0, 0, 152, 50)), UIButton(frame: CGRectMake(0, 0, 152, 50))]
    
    var answerChoices = [String](count: 6, repeatedValue: "")
    
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
        
        // Configure the cell
        let row = indexPath?.row
        let answerChoice = self.answerChoices[row!]
        
        //buttons[row!].frame.width = myCell.frame.width
        buttons[row!].setTitle(answerChoice, forState: UIControlState.Normal)
        buttons[row!].backgroundColor = buttonGrayDefault
        
        buttons[row!].addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
        buttons[row!].tag = row!
        
        myCell.addSubview(buttons[row!])
        return myCell
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        let answerIndex = sender.tag.description
        println(answerIndex)
    }
}