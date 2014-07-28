//
//  GameSelectionController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class GameSelectionController: UITableViewController {
    
    var user: User?
    
    var loaded = false
    var games: [Game]?
    var reuseIdentifier = "gameCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(user, "user must be set in GameSelectionController")
        
        getGames(url: GameConstants.REQUEST_HANDLER_URL, user: user!)
        while !loaded {
            usleep(10)
        }
        
        // Adding a footer ensures the table does not display unneeded cells.
        self.tableView!.tableFooterView = UIView (frame: CGRectZero)
    }
    
    // Create a GameDescription controller for the selected game.
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var descriptionController = self.storyboard.instantiateViewControllerWithIdentifier("DescriptionController") as DescriptionController
        var game = self.games![indexPath.row]
        
        descriptionController.game = game
        descriptionController.user = user
        descriptionController.requestURL = GameConstants.REQUEST_HANDLER_URL
        descriptionController.mediaURL = GameConstants.GET_MEDIA_URL
        self.navigationController.pushViewController(descriptionController, animated: true)
        
        // Update the navigation bar's title to the selected game
        navigationController.topViewController.title = (tableView.cellForRowAtIndexPath(indexPath) as GameCell).gameLabel!.text
    }
    
    // Limit the number of rows to the number of games.
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.games!.count
    }

    // Create a cell consisting of a game name and its associated image.
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        var cell = self.tableView!.dequeueReusableCellWithIdentifier(reuseIdentifier) as GameCell
        
        var game = self.games![indexPath.row]
        cell.gameLabel!.text = game.name
        cell.gameImageView!.image = ImageLoader.load(url: game.imageURL)
        
        return cell
    }
    
    // Retrieve the games from the server.
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
                    var highScores = gameJSON["high_scores"] as [AnyObject]
                    
                    gameList.append(Game(id: id, name: name, description: description, timeLimit: timeLimit.toInt()!, questionCount: questionCount, imageURL: imageURL, highscores: HighScores(json: highScores)))
                }
                self.games = gameList
                self.loaded = true
            }
        })
    }
    
    // Change the transparency of play button in the main controller to indicate an unpressed state.
    override func viewWillDisappear(animated: Bool)  {
        var mainController = navigationController.viewControllers[0] as MainController
        mainController.playButton!.titleLabel.alpha = 1.0
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        //if iPad make cells taller
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 220
        } else {
            return 136
        }
    }
}