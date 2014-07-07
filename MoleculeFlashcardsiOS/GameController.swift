//
//  GameController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/2/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class GameController : UIViewController {
    
    var game: Game?
    var user: User?
    var requestURL: String?
    var mediaURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        game!.start(url: requestURL!, user: user!,{(questions: Question[]) in
            for question in questions {
                var request = Request(url: "\(self.requestURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                // println("\(self.GET_MEDIA_URL)?gsi=\(game.sessionId!)&mt=0&qid=\(question.id)")
                request.performGet(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
                    
                    // var content:String = NSString(bytes:responseData, length: encoding:NSUTF8StringEncoding)
                    var content:String =  NSString(bytes: responseData.bytes, length: responseData.length, encoding: NSUTF8StringEncoding)
                    println(content)
                    if error != nil {
                        // println("error: \(error.description)")
                    } else {
                        //  println("success")
                    }
                })
            }
        })
    }
}
