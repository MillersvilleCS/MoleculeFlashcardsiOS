//
//  HighScoreControllerController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/11/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class HighScoreController: UITableViewController {
    
    let reuseIdentifier = "highScoreCell"
    
    var highScores: HighScores?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controller: DescriptionController = navigationController.viewControllers[2] as DescriptionController
        self.highScores = controller.game!.highscores
        
        // Adding a footer ensures the table does not display unneeded cells.
        self.tableView!.tableFooterView = UIView (frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.highScores!.entryCount()
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as HighScoreCell
        var highScore = self.highScores!.entries[indexPath.row]
        
        cell.rankLabel!.text = "#\(highScore.rank)"
        cell.nameLabel!.text = highScore.username
        cell.scoreLabel!.text = "\(highScore.score)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        //if iPad make cells taller
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 70
        } else {
            return 40
        }
    }
}