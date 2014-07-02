//
//  VecOp.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import SceneKit

struct VecOp {
    
    static let UP     = SCNVector3(x: 0, y: 1, z: 0),
    DOWN   = SCNVector3(x: 0, y: -1, z: 0),
    LEFT   = SCNVector3(x: -1, y: 0, z: 0),
    RIGHT  = SCNVector3(x: 1, y: 0, z: 0),
    
    ZERO   = SCNVector3(x: 0, y: 0, z: 0),
    X_AXIS = RIGHT,
    Y_AXIS = UP,
    Z_AXIS = SCNVector3(x: 0, y: 0, z: 1)
    
    static func sub(first: SCNVector3, _ second: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: first.x - second.x, y: first.y - second.y, z: first.z - second.z)
    }
    
    static func distance(first: SCNVector3, _ second: SCNVector3) -> Float {
        return sqrtf(powf((first.x - second.x), 2) + powf((first.y - second.y), 2) + powf((first.z - second.z), 2))
    }
    
    static func length(vector: SCNVector3) -> Float {
        return distance(vector, VecOp.ZERO)
    }
    
    static func normalize(vector: SCNVector3) -> SCNVector3 {
        var len = length(vector)
        let x = vector.x / len
        let y = vector.y / len
        let z = vector.z / len
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    static func cross(first: SCNVector3, _ second: SCNVector3) -> SCNVector3 {
        var x = first.y * second.z - first.z * second.y;
        var y = first.z * second.x - first.x * second.z;
        var z = first.x * second.y - first.y * second.x;
        return SCNVector3(x: x, y: y, z: z);
    }
    
    static func dot(first: SCNVector3, _ second: SCNVector3) -> Float {
        return (first.x * second.x) + (first.y * second.y) + (first.z * second.z)
    }
    
    static func translate(vector: SCNVector3, x: Float, y: Float, z: Float) -> SCNVector3 {
        return SCNVector3(x: vector.x + x, y: vector.y + y, z: vector.z + z)
    }
    
    static func translate(vector: SCNVector3, x: Float) -> SCNVector3 {
        return translate(vector, x: x, y: 0, z: 0)
    }
    
    static func translate(vector: SCNVector3, y: Float) -> SCNVector3 {
        return translate(vector, x: 0, y: y, z: 0)
    }
    
    static func translate(vector: SCNVector3, z: Float) -> SCNVector3 {
        return translate(vector, x: 0, y: 0, z: z)
    }
}