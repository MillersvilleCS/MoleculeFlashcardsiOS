//
//  Bond.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

class Bond {
    
    var from, to, type: Int
    
    init(_ type: Int, _ from: Int, _ to: Int) {
        self.type = type
        self.from = from - 1
        self.to = to - 1
    }
}