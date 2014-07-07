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
        
        assert(game)
        assert(user)
        assert(requestURL)
        assert(mediaURL)
        
       // start()
        
        self.navigationItem.hidesBackButton = true

    }
    
    func start() {
        game!.start(url: requestURL!, user: user!,{(questions: [Question]) in
            for question in questions {
                var request = Request(url: "\(self.requestURL!)?gsi=\(self.game!.sessionId!)&mt=0&qid=\(question.id)")
                
                request.performGet(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
                    
                    var response: String =  NSString(bytes: responseData.bytes, length: responseData.length, encoding: NSUTF8StringEncoding)
                    if error {
                        
                    } else {
                        println(response)
                        println(response.componentsSeparatedByString("\n"))
                        var molecule = SDFParser.parse(sdfFileLines: response.componentsSeparatedByString("\n"))
                        println(molecule.atoms)
                    }
                })
            }
        })
    }
}
