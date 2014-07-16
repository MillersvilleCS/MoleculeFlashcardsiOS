//
//  LoginInfoManager.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/16/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct LoginInfoManager {
    
    static let file = "loginInfo.txt"
    
    static func writeInfo(#name: String, id: String) {
        var data: String = "\(name)\n\(id)"
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]

        if (dirs! != nil) {
            let directories:[String] = dirs!;
            let dir = directories[0]; //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            
            //writing
            data.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        }
    }
    
    static func getInfo() -> String? {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs! != nil) {
            let directories:[String] = dirs!;
            let dir = directories[0]; //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            
            return String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        }
        return nil
    }
    
    static func deleteInfo() {
        var data: String = ""
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs! != nil) {
            let directories:[String] = dirs!;
            let dir = directories[0]; //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            
            //writing
            data.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        }
    }
}