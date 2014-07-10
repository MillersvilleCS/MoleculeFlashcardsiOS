//
//  User.swift
//  MoleculeFlashcardsIOS
//
//  Authored by Will Gervasio on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var id: String?
    var loggedIn = false
    
    init() {
        
    }
    
    func login(#url: String, username: String, password: String) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "login")
        request.addParameter(key: "login", value: username)
        request.addParameter(key: "pass", value: password)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error {
                println("Failed to log in, \(error.description)")
            } else if response["success"] as Int == 0 {
                println("Failed to log in,  invalid username or password")
            } else {
                println("Logged in successfully")
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
                self.loggedIn = true
            }
            })
    }
    
    func register(#url: String, username: String, password: String, email: String) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "register")
        request.addParameter(key: "username", value: username)
        request.addParameter(key: "password", value: password)
        request.addParameter(key: "email", value: email)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error {
                println("Failed to register, \(error.description)")
            } else if response["success"] as Int == 0 {
                println("Failed to register")
            } else {
                println("registered successfully")
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
                self.loggedIn = true
            }
            })
    }
}