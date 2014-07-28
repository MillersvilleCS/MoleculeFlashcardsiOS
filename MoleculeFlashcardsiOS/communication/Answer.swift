//
//  Answer.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

typealias AnswerID = Int
typealias AnswerText = String

struct Answer {
    
    var id: AnswerID
    var text: AnswerText
    
    init(id: AnswerID, text: AnswerText) {
        self.id = id
        self.text = text
    }
}