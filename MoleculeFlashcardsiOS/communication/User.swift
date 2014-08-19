//
//  User.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

typealias Username = String
typealias UserId = String

typealias LoginStatus = User.LoginStatus

class User {
    
    enum LoginStatus {
        case LOGGED_OUT, LOGGING_IN, LOGGED_IN, FAILED
    }
    
    var name: Username?
    var id: UserId?
    var status = LoginStatus.LOGGED_OUT
    
    init() {
        self.id = ""
    }
    
    func login(#url: String, username: String, password: String, onComplete: (name: String, id: String, success: Bool, error: String) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "login")
        request.addParameter(key: "login", value: username)
        request.addParameter(key: "pass", value: password)
        self.status = LoginStatus.LOGGING_IN
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            
            if error {
                onComplete(name: "", id: "", success: false, error: error.description)
                self.status = LoginStatus.FAILED
            } else if !response["success"] { // Server returns String if failed int if succes. Someone needs to fix that
                onComplete(name: "", id: "",success: false, error: response["error"] as String)
                self.status = LoginStatus.FAILED
            } else {
                self.name = response["username"] as? Username
                self.id = response["auth"] as? UserId
                self.status = LoginStatus.LOGGED_IN
                onComplete(name: self.name!, id: self.id!, success: true, error: "")
            }
        })
    }
    
    func register(#url: String, username: String, password: String, email: String, onComplete: (name: String, id: String,success: Bool, error: String) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "register")
        request.addParameter(key: "username", value: username)
        request.addParameter(key: "password", value: password)
        request.addParameter(key: "email", value: email)
        self.status = LoginStatus.LOGGING_IN
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            
            if error {
                self.status = LoginStatus.FAILED
                onComplete(name: "", id: "", success: false, error: error.description)
            } else if !response["success"] {
                self.status = LoginStatus.FAILED
                var errorString = response["error"] as String
                onComplete(name: "", id: "", success: false, error: errorString)
            } else {
                self.name = response["username"] as? Username
                self.id = response["auth"] as? UserId
                self.status = LoginStatus.LOGGED_IN
                onComplete(name: self.name!, id: self.id!, success: true, error: "")
            }
        })
    }
}