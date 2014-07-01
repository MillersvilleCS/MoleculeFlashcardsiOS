//
//  CategoriesView.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class CategoriesView : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView
    var categories: String[] = ["One", "Two", "Three"]
    
    var games: Game[]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func prepareForSegue (segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Load View" {
            
        // pass data to the next view
        
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }

    // Set the number of cells
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    // Create the cells
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel.text = self.categories[indexPath.row]
        
        return cell
    }
    
    func getGames(#url: String, user: User) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "get_avail_flashcard_games")
        request.addParameter(key: "authenticator", value: !user.id)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error {
                
            } else {
                
                var gamesJSON : AnyObject = response["questions"]!
                for gameJSON : AnyObject in gamesJSON as AnyObject[] {
                    var gameData = response["available_games"]![0]
                    var id = gameData!["id"]! as String
                    var name = gameData!["name"]! as String
                    var description = gameData!["description"] as String
                    var questionCount = gameData!["mol_count"] as Int
                    var timeLimit = gameData!["time_limit"] as String
                    var imageURL = "https://exscitech.org" + gameData!["image"].description
                    
                    self.game = Game(id: id, name: name, description: description, timeLimit: timeLimit.toInt()!, imageURL: imageURL)
                }
            }
        })
    }
}