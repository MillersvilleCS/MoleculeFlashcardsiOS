//
//  Answer.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct Answer {
    
    var id: Int
    var text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}