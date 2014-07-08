//
//  ButtonCollectionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/7/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class ButtonCollectionController: UICollectionViewController {
    
    var numbers = ["1","2","3","4","5","6"]
    var reuseIdentifier = "ButtonCell"
    
    var buttonGrayPressed = UIColor(red: CGFloat(158/255.0), green: CGFloat(158/255.0), blue: CGFloat(158/255.0), alpha: CGFloat(1.0))
    var buttonGrayDefault = UIColor(red: CGFloat(209/255.0), green: CGFloat(209/255.0), blue: CGFloat(209/255.0), alpha: CGFloat(1.0))
    var buttonCorrectDefault = UIColor(red: CGFloat(0/255.0), green: CGFloat(153/255.0), blue: CGFloat(0/255.0), alpha: CGFloat(1.0))
    
    


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
    
    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    override func collectionView(collectionView: UICollectionView?, cellForItemAtIndexPath indexPath: NSIndexPath?) -> UICollectionViewCell? {
        var myCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        // Configure the cell
        let row = indexPath?.row
        let testString = numbers[row!]
        
        var button = UIButton(frame: CGRectMake(0, 0, myCell.frame.width, myCell.frame.height))
        
        button.setTitle(testString, forState: UIControlState.Normal)
        button.backgroundColor = buttonGrayDefault
        
        button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
        button.tag = row!
        
        myCell.addSubview(button)
        return myCell
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        let answerIndex = sender.tag.description
        println(answerIndex)
    }
}
