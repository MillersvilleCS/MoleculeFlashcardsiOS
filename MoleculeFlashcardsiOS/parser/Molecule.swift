//
//  Molecule.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/23/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

class Molecule {
    
    var atoms = [Atom]()
    var bonds = [Bond]()
    
    init() {
    
    }
    
    func add(atom: Atom) {
        atoms.append(atom)
    }
    
    func add(bond: Bond) {
        bonds.append(bond)
    }
}
