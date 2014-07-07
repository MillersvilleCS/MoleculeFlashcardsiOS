//
//  EventLogger.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct EventLogger {
    
    static var events = [String]()
    
    static func log(event: String) {
        events.append(event)
    }
    
    static func logError(event: String) {
        events.append("Error: " + event);
    }
}