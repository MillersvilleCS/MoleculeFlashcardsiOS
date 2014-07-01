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
    
    init() {
        
    }
    
    func login(#url: String, username: String, password: String) {
        var request = Request(url: url)
        request.addParameter(key: "request_type", value: "login")
        request.addParameter(key: "login", value: username)
        request.addParameter(key: "pass", value: password)
        request.performPost(onComplete:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) in
            
            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            if error { //Failed
                println(error.description)
            } else if response["success"] as Int == 0 { //Failed
                println("Could not log on: invalid username or password")
            } else { //Success
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
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
            if error { //Failed
                println(error.description)
            } else if response["success"] as Int == 0 { //Failed
                println("Could not log on: invalid username or password")
            } else { //Success
                self.name = response["username"] as NSString
                self.id = response["auth"] as NSString
            }
        })
    }
}