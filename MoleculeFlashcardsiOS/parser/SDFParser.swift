//
//  SDFParser.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation

struct SDFParser {
    
    static let HEADER_INDEX = 4 as Int
    
    // Note: Input passed here should only contain text before "M  END"
    static func parse(sdfFileLines content: [String]) -> Molecule {
        var index = HEADER_INDEX
        var molecule = Molecule()
        
        var line = content[index]
        while(line.hasPrefix("   ")) {
            molecule.add(parseAtom(line))
            index++
            line = content[index]
        }
        
        while(index < content.count && (content[index] as NSString).substringToIndex(6) != "M  END" && (content[index] as NSString).substringToIndex(6) != "M  CHG") {
            line = content[index]
            molecule.add(parseBond(line))
            index++
        }
        
        return molecule
    }
    
    static func parseAtom(line: String) -> Atom {
        var scanner = NSScanner(string: line)
        
        var x:Float = 0.0, y:Float = 0.0, z:Float = 0.0
        scanner.scanFloat(&x)
        scanner.scanFloat(&y)
        scanner.scanFloat(&z)
        
        var rest:NSString?
        scanner.scanUpToString("\n", intoString: &rest)
        
        if let type = rest {
            return Atom(x, y, z, type: type.substringToIndex(2).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString)
        } else {
            return Atom(x, y, z, type: "ERR")
        }
    }
    
    static func parseBond(line: String) -> Bond {
        var scanner = NSScanner(string: line)
        
        var from:CInt = 0, to:CInt = 0, type:CInt = 0
        scanner.scanInt(&from)
        scanner.scanInt(&to)
        scanner.scanInt(&type)
        
        return Bond(Int(type), Int(from), Int(to))
    }
}

