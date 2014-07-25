//
//  HighScoreControllerController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/11/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class HighScoreController: UITableViewController {
    
    
    var nib = UINib(nibName: "UITableViewCell", bundle: nil)
    var reuseIdentifier = "scoreCell"
    
    var highScores: HighScores?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as UITableViewCell
        
        var highScore = self.highScores!.entries[indexPath.row]
        
        var rank = highScore.rank
        var username = highScore.username
        var score = highScore.score
        
        var cellFrame = cell.contentView.frame
        
        cell.textLabel!.text = "#\(rank)"
        
        var usernameLabel = UILabel(frame: CGRectMake(CGFloat(cellFrame.width * 0.25), 0, cellFrame.width * 0.5, cellFrame.height))
        
        usernameLabel.text = username
        cell.addSubview(usernameLabel)
        
        var scoreLabel = UILabel(frame: CGRectMake(CGFloat(cellFrame.width * 0.75), 0, cellFrame.width * 0.25, cellFrame.height))
        scoreLabel.text = "\(score)"
        cell.addSubview(scoreLabel)
        
        return cell
    }
}