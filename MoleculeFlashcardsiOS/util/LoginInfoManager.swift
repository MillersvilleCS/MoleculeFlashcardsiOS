//
//  LoginInfoManager.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/16/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct LoginInfoManager {
    static func writeInfo(#name: String, id: String) {
        var userData: String = "\(name)\n\(id)"
        let userDirectories: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]

        if userDirectories {
            let directories:[String] = userDirectories!;
            let documentsDirectory = directories[0];
            let path = documentsDirectory.stringByAppendingPathComponent(GameConstants.LOGIN_INFO_FILE);
            
            userData.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        }
    }
    
    static func getInfo() -> String? {
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if dirs {
            let userDirectories:[String] = dirs!;
            let documentsDirectory = userDirectories[0];
            let path = documentsDirectory.stringByAppendingPathComponent(GameConstants.LOGIN_INFO_FILE);
            
            return String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        }
        return nil
    }
    
    static func deleteInfo() {
        var data: String = ""
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if dirs {
            let userDirectories:[String] = dirs!;
            let documentsDirectory = userDirectories[0];
            let path = documentsDirectory.stringByAppendingPathComponent(GameConstants.LOGIN_INFO_FILE);
            
            data.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        }
    }
}