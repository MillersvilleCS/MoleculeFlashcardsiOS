//
//  Score.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/11/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct Score {
    
    var rank: String
    var username: String
    var score : String
    
    init(rank: String, username: String, score: String) {
        self.rank = rank
        self.username = username
        self.score = score
    }
}