//
//  Question.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

typealias QuestionID = Int
typealias QuestionText = String

struct Question {
    
    var id: QuestionID
    var text: QuestionText
    var answers: [Answer]
    
    init(id: QuestionID, text: QuestionText, answers: [Answer]) {
        self.id = id
        self.text = text
        self.answers = answers
    }
}