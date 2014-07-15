//
//  User.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

class User {
    
    enum LoginStatus {
        case LOGGED_OUT, LOGGING_IN, LOGGED_IN, FAILED
    }
    
    var name: String?
    var id: String?
    var status = LoginStatus.LOGGED_OUT
    
    init() {
        
    }
    
    func login(#url: String, username: String, password: String, onComplete: (success: Bool) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "login")
        request.addParameter(key: "login", value: username)
        request.addParameter(key: "pass", value: password)
        self.status = LoginStatus.LOGGING_IN
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            println(response.description)
            
            if error {
                println("Failed to log in, \(error.description)")
                onComplete(success: false)
                self.status = LoginStatus.FAILED
            } else if response["success"] is String { // Server retuns String if failed int if succes. Someone needs to fix that
                println("Failed to log in,  invalid username or password")
                onComplete(success: false)
                self.status = LoginStatus.FAILED
            } else {
                println("Logged in successfully")
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
                self.status = LoginStatus.LOGGED_IN
                onComplete(success: true)
            }
            })
    }
    
    func register(#url: String, username: String, password: String, email: String, onComplete: (success: Bool) -> Void) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "register")
        request.addParameter(key: "username", value: username)
        request.addParameter(key: "password", value: password)
        request.addParameter(key: "email", value: email)
        self.status = LoginStatus.LOGGING_IN
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            println(response.description)
            if error {
                println("Failed to register, \(error.description)")
                self.status = LoginStatus.FAILED
                onComplete(success: false)
            } else if response["success"] is String {
                println("Failed to register")
                self.status = LoginStatus.FAILED
                onComplete(success: false)
            } else {
                println("registered successfully")
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
                self.status = LoginStatus.LOGGED_IN
                onComplete(success: true)
            }
            })
    }

}