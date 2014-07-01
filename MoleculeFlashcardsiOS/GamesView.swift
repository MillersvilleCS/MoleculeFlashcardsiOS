//
//  GamesView.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class GamesView : UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView : UITableView
    
    var games: String[] = ["One", "Two", "Three"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func prepareForSegue (segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Load View" {
            
            // Pass data to the next view
            
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    // Set the number of cells
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.games.count;
    }
    
    // Create the cells
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel.text = self.games[indexPath.row]
        
        return cell
    }

}