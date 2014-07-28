//
//  HighScores.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/14/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

typealias HighscoresRank = Int
typealias HighscoresScore = Int
typealias HighscoresUsername = String

typealias HighscoresEntry = HighScores.HighscoresEntry

class HighScores {
    
    struct HighscoresEntry {
        var rank: HighscoresRank
        var score: HighscoresScore
        var username: HighscoresUsername
        
        init(rank: HighscoresRank, score: HighscoresScore, username: HighscoresUsername) {
            self.rank = rank
            self.score = score
            self.username = username
        }
    }
    
    var entries: [HighscoresEntry] = [HighscoresEntry]()
    
    init(json: [AnyObject]) {
        
        for entryJson in json {
            var rank = entryJson["rank"] as HighscoresRank
            var score = entryJson["score"] as HighscoresScore
            var username = entryJson["username"] as HighscoresUsername
            
            entries.append(HighscoresEntry(rank: rank, score: score, username: username))
        }
    }
    
    func entryCount() -> Int {
        return entries.count
    }
}