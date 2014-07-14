//
//  HighScores.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//


import Foundation

class HighScores {
    
    struct Entry {
        var rank: Int
        var score: Int
        var username: String
        
        init(rank: Int, score: Int, username: String) {
            self.rank = rank
            self.score = score
            self.username = username
        }
    }
    
    var entries: [Entry] = [Entry]()
    
    init(json: [AnyObject]) {
        
        for entryJson in json {
            
            var rank = entryJson["rank"] as Int
            var score = entryJson["score"] as Int
            var username = entryJson["username"] as String
            entries.append(Entry(rank: rank, score: score, username: username))
        }
    }
    
    func entryCount() -> Int {
        return entries.count
    }
}