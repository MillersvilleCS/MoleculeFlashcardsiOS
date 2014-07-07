//
//  Game.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class Game {
    
    enum GameState {
        case WAITING_TO_START, FAILED_TO_LOAD, READY, FINISHED
    }
    
    var id: String
    var name: String
    var description: String
    var timeLimit: Int
    var imageURL: String
    
    var questionIndex: Int = 0
    var sessionId: String?
    var questions: Question[]?
    
    var state: GameState
    
    init(id: String, name: String, description: String, timeLimit: Int, imageURL: String) {
        self.id = id
        self.name = name
        self.description = description
        self.timeLimit = timeLimit
        self.imageURL = imageURL
        self.state = GameState.WAITING_TO_START
    }
    
    func start(#url: String, user: User, onComplete: (questions: Question[]) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "load_flashcard_game")
        request.addParameter(key: "authenticator", value: !user.id)
        request.addParameter(key: "game_id", value: id)
        
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            
            if error != nil {
                EventLogger.logError("Could not load game: \(error.description)")
                self.state = GameState.FAILED_TO_LOAD
            } else {
                self.questionIndex = 0
                self.sessionId = response["game_session_id"]! as? String
                //load questions
                var newQuestions = Question[]()
                var questionsJSON : AnyObject = response["questions"]!
                for questionJSON : AnyObject in questionsJSON as AnyObject[] {
                    var questionId: Int = questionJSON["id"] as Int
                    var questionText: String = questionJSON["text"] as String
                    var answersJSON : AnyObject! = questionJSON["answers"]!
                    
                    var answerList = Answer[]()
                    //load answers
                    for answerJSON : AnyObject in answersJSON as AnyObject[] {
                        var answerId: Int = answerJSON["id"] as Int
                        var answerText: String = answerJSON["text"] as String
                        answerList.append(Answer(id: answerId, text: answerText))
                    }
                    newQuestions.append(Question(id: questionId, text: questionText, answers: answerList))
                }
                self.questions = newQuestions
                onComplete(questions: self.questions!)
            }
            
            self.state = GameState.READY

        })
    }
    
    
    func end(#url: String, user: User, gameTime: Int, onComplete: () -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "end_flashcard_game")
        request.addParameter(key: "authenticator", value: !user.id)
        request.addParameter(key: "game_session_id", value: sessionId!)
        request.addParameter(key: "game_time", value: gameTime)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error {
                EventLogger.logError("Failed to end Game \(error)")
            } else {
                EventLogger.log("game \(self.sessionId) has ended")
            }
        })

    }
    
    func submit(#url: String, user: User, answer: Answer, time: Int, onComplete: (isCorrect: Bool, scoreModifier: Int) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "submit_flashcard_answer")
        request.addParameter(key: "authenticator", value: !user.id)
        request.addParameter(key: "game_session_id", value: sessionId!)
        request.addParameter(key: "question_id", value: id)
        request.addParameter(key: "answer", value: answer.text)
        request.addParameter(key: "game_time", value: time)
        
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            if error != nil {
                EventLogger.logError("Could not submit answer '\(answer.text)': \(error.description)")
            } else {
                var isCorrect = response["correct"] as String
                var score = response["score"] as Int
                if isCorrect == "true" {
                    EventLogger.log("submitted answer \(answer.text) was correct")
                    if self.questionIndex < self.getNumberOfQuestions() - 1 {
                        ++self.questionIndex
                    } else {
                        self.state = GameState.FINISHED
                    }
                    onComplete(isCorrect: true, scoreModifier: score)
                } else {
                    EventLogger.log("submitted answer \(answer.text) was incorrect")
                    onComplete(isCorrect: false, scoreModifier: score)
                }
            }
        })
    }

    
    func getHighScores(#url: String, startingRank: Int, range: Int) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "get_high_scores")
        request.addParameter(key: "game_id", value: id)
        request.addParameter(key: "starting_rank", value: startingRank)
        request.addParameter(key: "range", value: range)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error != nil {
                
            } else {
                
            }
        })

    }
    
    func setGameState(state: GameState) {
        if(state != GameState.FINISHED) {
            self.state = state
        }
    }

    func getCurrentQuestion() -> Question {
        return questions![questionIndex]
    }
    
    func getCurrentMolecule() -> Molecule {
        var molecule = Molecule()
        return molecule
    }
    
    func getAvailableAnswers() -> Answer[] {
        return questions![questionIndex].answers
    }
    
    func getNumberOfQuestions() -> Int {
        return questions!.count
    }
}