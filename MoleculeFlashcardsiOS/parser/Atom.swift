//
//  Atom.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import SceneKit

class Atom {
    
    var position: SCNVector3
    var type: String
    
    init(_ x: Float, _ y: Float, _ z: Float, type: String) {
        position = SCNVector3(x: x, y: y, z: z)
        self.type = type
    }
}