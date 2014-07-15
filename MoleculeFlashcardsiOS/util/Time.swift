//
//  Time.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/15/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct Time {
    
    static let MS_IN_SEC: Int = 1000
    static let SEC_IN_MIN: Int = 60
    
    static func formatTime(#ms: Int) -> String {
        
        var time: Int = ms / MS_IN_SEC
        var seconds = time % 60
        time /= SEC_IN_MIN
        if seconds < 10 {
            return "\(time):0\(seconds)"
        } else {
            return "\(time):\(seconds)"
        }
    }
}