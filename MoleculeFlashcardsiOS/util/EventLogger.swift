//
//  EventLogger.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/24/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

struct EventLogger {
    
    static var events = [String]()
    
    static func log(event: String) {
        events.append(event)
    }
    
    static func logError(event: String) {
        events.append("Error: " + event);
    }
}