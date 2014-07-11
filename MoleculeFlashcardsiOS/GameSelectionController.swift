//
//  GameSelectionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class GameSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView
    
    let user = User()
    
    var loaded = false
    var games: [Game]?
    var nib = UINib(nibName: "TableViewGameCell", bundle: nil)
    var reuseIdentifier = "gameCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerClass(TableViewGameCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        user.login(url: GameConstants.REQUEST_HANDLER_URL, username: "wpgervasio@gmail.com", password: "lol12345")
        while(!user.loggedIn) {
            usleep(10)
        }
        getGames(url: GameConstants.REQUEST_HANDLER_URL, user: user)
        while !loaded {
            usleep(10)
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var controller = self.storyboard.instantiateViewControllerWithIdentifier("DescriptionController") as DescriptionController
        var game = self.games![indexPath.row]
        
        controller.game = game
        controller.user = user
        controller.requestURL = GameConstants.REQUEST_HANDLER_URL
        controller.mediaURL = GameConstants.GET_MEDIA_URL
        self.navigationController.pushViewController(controller, animated: true)
        
        // Update the navigation bar's title to the selected game
        navigationController.topViewController.title = tableView.cellForRowAtIndexPath(indexPath).textLabel.text
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.games!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!, numberOfSectionsInTable: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:TableViewGameCell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as TableViewGameCell
        
        var game = self.games![indexPath.row]
        var cellText = game.name
        var cellImage = ImageLoader.load(url: game.imageURL)
        
        cell.textLabel!.text = cellText
        cell.imageView!.image = cellImage
        
        return cell
    }
    
    func getGames(#url: String, user: User) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "get_avail_flashcard_games")
        request.addParameter(key: "authenticator", value: !user.id)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error {
                println("Error loading games \(error.description)")
            } else {
                var gameList = [Game]()
                var gamesJSON : AnyObject = response["available_games"]!
                for gameJSON : AnyObject in gamesJSON as [AnyObject] {
                    var id = gameJSON["id"]! as String
                    var name = gameJSON["name"]! as String
                    var description = gameJSON["description"] as String
                    var questionCount = gameJSON["mol_count"] as Int
                    var timeLimit = gameJSON["time_limit"] as String
                    var imageURL = "https://exscitech.org" + gameJSON["image"].description
                    
                    gameList.append(Game(id: id, name: name, description: description, timeLimit: timeLimit.toInt()!, questionCount: questionCount, imageURL: imageURL))
                }
                self.games = gameList
                self.loaded = true
            }
            })
    }
}