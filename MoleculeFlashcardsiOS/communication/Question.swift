//
//  Question.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

struct Question {
    
    var id: Int
    var text: String
    var answers: [Answer]
    
    init(id: Int, text: String, answers: [Answer]) {
        self.id = id
        self.text = text
        self.answers = answers
    }
}