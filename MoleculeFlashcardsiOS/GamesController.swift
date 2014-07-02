//
//  GamesController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class GamesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView
    
    var games: Game[]?
    var nib = UINib(nibName: "TableViewGameCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "gameCell")
        self.tableView.registerClass(TableViewGameCell.self, forCellReuseIdentifier: "gameCell")
        
        let REQUEST_HANDLER_URL = "https://exscitech.org/request_handler.php"
        let GET_MEDIA_URL = "https://exscitech.org/get_media.php"
        var will = User()
        will.login(url: REQUEST_HANDLER_URL, username: "wpgervasio@gmail.com", password: "lol12345")
        getGames(url: REQUEST_HANDLER_URL, user: will)
        while !games {
            
        }
    }
    
    override func prepareForSegue (segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Load View" {
            
            // Pass data to the next view
            
        }
    }
    
    // Load the selected game.
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("You selected cell #\(indexPath.row)!")
    }
    
    // Set the number of cells
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.games!.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!, numberOfSectionsInTable: Int) -> Int {
        return 1;
    }
    
    // Create the cells
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:TableViewGameCell = self.tableView.dequeueReusableCellWithIdentifier("gameCell") as TableViewGameCell
        
        var game = self.games![indexPath.row]
        var cellText = game.name
        var cellImage = ImageLoader.load(url: game.imageURL)

        cell.textLabel!.text = cellText
        cell.imageView!.image = cellImage
        //cell.loadItem(text: cellText, image: cellImage)
        
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
                var newGames = Game[]()
                var gamesJSON : AnyObject = response["available_games"]!
                for gameJSON : AnyObject in gamesJSON as AnyObject[] {
                    var id = gameJSON["id"]! as String
                    var name = gameJSON["name"]! as String
                    var description = gameJSON["description"] as String
                    var questionCount = gameJSON["mol_count"] as Int
                    var timeLimit = gameJSON["time_limit"] as String
                    var imageURL = "https://exscitech.org" + gameJSON["image"].description
                    
                    newGames.append(Game(id: id, name: name, description: description, timeLimit: timeLimit.toInt()!, imageURL: imageURL))
                }
                self.games = newGames
            }
        })
    }
}