//
//  Request.swift
//  MoleculeFlashcardsIOS
//
//  Authored by exscitech on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

class Request {
    
    var url: NSURL
    var parameters = NSMutableDictionary();
    
    var data = NSMutableData()
    var finished = false
    
    init(url: String) {
        self.url = NSURL.URLWithString(url)
    }
    
    func performPost(#onComplete: (response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void) {
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        var data: NSData = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPBody = data
        var queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:onComplete)
    }
    
    func performGet() -> (NSURLResponse, NSErrorPointer) {
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        var data = NSData()
        request.HTTPBody = data
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Data: \(dataString)")
        return (response!, error)
    }
    
    func addParameter(#key: String, value: NSObject) {
        parameters[key] = value
    }
}