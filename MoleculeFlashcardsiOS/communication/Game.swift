//
//  Game.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//
import UIKit

typealias GameState = Game.GameState

class Game {
    
    enum GameState {
        case WAITING_TO_START, FAILED_TO_LOAD, READY, FINISHED
    }
    
    var id: String
    var name: String
    var description: String
    var timeLimit: Int
    var questionCount: Int
    var imageURL: String
    var highscores: HighScores
    
    var questionIndex: Int = 0
    var sessionId: String?
    var questions: [Question]?
    
    var state: GameState
    
    init(id: String, name: String, description: String, timeLimit: Int, questionCount: Int, imageURL: String, highscores: HighScores) {
        self.id = id
        self.name = name
        self.description = description
        self.timeLimit = timeLimit
        self.questionCount = questionCount
        self.imageURL = imageURL
        self.state = GameState.WAITING_TO_START
        self.highscores = highscores
    }
    
    
    func start(#url: String, user: User, onComplete: (questions: [Question]) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "load_flashcard_game")
        request.addParameter(key: "authenticator", value: user.id!)
        request.addParameter(key: "game_id", value: id)
        
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            
            if !error {
                self.questionIndex = 0
                self.sessionId = response["game_session_id"]! as? String
                
                // Load questions
                var newQuestions = [Question]()
                var questionsJSON : AnyObject = response["questions"]!
                
                for questionJSON : AnyObject in questionsJSON as [AnyObject] {
                    
                    var questionId: QuestionID = questionJSON["id"] as QuestionID
                    var questionText: QuestionText = questionJSON["text"] as QuestionText
                    
                    var answersJSON: AnyObject! = questionJSON["answers"]!
                    var answerList = [Answer]()
                    
                    // Load answers
                    for answerJSON : AnyObject in answersJSON as [AnyObject] {
                        var answerId: AnswerID = answerJSON["id"] as AnswerID
                        var answerText: AnswerText = answerJSON["text"] as AnswerText
                        
                        answerList.append(Answer(id: answerId, text: answerText))
                    }
                    newQuestions.append(Question(id: questionId, text: questionText, answers: answerList))
                }
                self.questions = newQuestions
                onComplete(questions: self.questions!)
            } else {
                self.state = GameState.FAILED_TO_LOAD
            }
            
            self.state = GameState.READY
        })
    }
    
    func end(#url: String, user: User, gameTime: Int, onComplete: (rank: Int, finalScore: Int, error: String!) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "end_flashcard_game")
        request.addParameter(key: "authenticator", value: user.id!)
        request.addParameter(key: "game_session_id", value: sessionId!)
        request.addParameter(key: "game_time", value: gameTime)
        
        // End the game and perfom the on complete closure
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            if !responseData {
                onComplete(rank: 0, finalScore: 0, error: "Response data was not returned")
            }
            var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            
            if !error {
                var rank = responseDict["rank"] as HighscoresRank
                var score = responseDict["final_score"] as HighscoresScore
                
                onComplete(rank: rank, finalScore: score, error: nil)
            } else {
                onComplete(rank: 0, finalScore: 0, error: error.description)
            }
        })
    }
    
    func submit(#url: String, user: User, answer: Answer, time: Int, onComplete: (isCorrect: Bool, scoreModifier: Int, error: String!) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "submit_flashcard_answer")
        request.addParameter(key: "authenticator", value: user.id!)
        request.addParameter(key: "game_session_id", value: sessionId!)
        request.addParameter(key: "question_id", value: questions![questionIndex].id)
        request.addParameter(key: "answer", value: answer.id)
        request.addParameter(key: "game_time", value: time)
        
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            if !responseData {
                onComplete(isCorrect: false, scoreModifier: 0, error: "Response data was not returned")
            }
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            
            
            //if there isnt an error proceed
            if !error {
                var isCorrect: String = response["correct"] as String
                var score: Int = response["score"] as Int
                
                if isCorrect == "true" {
                    //answer was correct
                    self.nextQuestion()
                    onComplete(isCorrect: true, scoreModifier: score, error: nil)
                } else {
                    //answer was incorrect
                    onComplete(isCorrect: false, scoreModifier: score, error: nil)
                }
            } else {
                onComplete(isCorrect: false, scoreModifier: 0, error: error.description)
            }
        })
    }
    
    func nextQuestion() {
        ++self.questionIndex
        if self.questionIndex >= self.getNumberOfQuestions() {
            self.state = GameState.FINISHED
        }
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
    
    func getAvailableAnswers() -> [Answer] {
        return questions![questionIndex].answers
    }
    
    func getNumberOfQuestions() -> Int {
        return questionCount
    }
}
