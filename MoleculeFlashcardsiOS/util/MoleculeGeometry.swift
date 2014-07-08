//
//  MoleculeGeometry.swift
//  HelloWorldSwift
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import SceneKit

struct MoleculeGeometry {
    
    static func constructWith(molecule: Molecule) -> SCNNode {
        var moleculeData = _loadMoleculeData()
        var rootMolecule = SCNNode()
        var add = rootMolecule.addChildNode //shorthand
        
        for atom in molecule.atoms {
            add(_buildAtom(atom, withColors: moleculeData.0, withSizes: moleculeData.1))
        }
        
        for bond in molecule.bonds {
            switch bond.type {
            case 1:
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: 0))
            case 2:
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: -0.20))
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: 0.20))
            default:
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: -0.3))
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: 0))
                add(_buildBond(bond, withAtoms: molecule.atoms, withColors: moleculeData.0, xOffset: 0.3))
            }
        }
        
        return rootMolecule
    }
    
    static func _buildAtom(atom: Atom, withColors colors: NSDictionary, withSizes sizes: NSDictionary) -> SCNNode {
        let sphereNode = SCNNode()
        var color = colors[atom.type] as [CGFloat]
        var size = sizes[atom.type] as CGFloat
        
        var sphere = SCNSphere(radius: (size * 0.25))
        sphere.segmentCount = 12
        sphereNode.geometry = sphere
        sphereNode.position = atom.position
        
        let material = SCNMaterial()
        
        var rgb = CGColorSpaceCreateDeviceRGB()
        var colors: [CGFloat] = [color[0], color[1], color[2], 1.0]
        material.diffuse.contents = CGColorCreate(rgb, colors)
        //CGColorSpaceRelease(rgb)
        sphereNode.geometry.firstMaterial = material
        
        return sphereNode
    }
    
    static func _buildBond(bond: Bond, withAtoms atoms: [Atom], withColors colors: NSDictionary, xOffset: Float)-> SCNNode {
        let bondNode = SCNNode()
        let cylinder = SCNCylinder(radius: 0.07, height: 1.0)
        cylinder.radialSegmentCount = 6
        cylinder.heightSegmentCount = 2
        
        var fromAtom = atoms[bond.from]
        var toAtom   = atoms[bond.to]
        var fromPos  = fromAtom.position
        var toPos    = toAtom.position
        
        cylinder.height    = VecOp.distance(fromPos, toPos)
        bondNode.position  = fromPos
        bondNode.geometry  = cylinder
        //translate rotation point from middle of model to bottom of model
        bondNode.pivot = SCNMatrix4Translate(bondNode.pivot, xOffset, cylinder.height / 2, 0)
        
        var down  = VecOp.UP
        var dir   = VecOp.normalize(VecOp.sub(fromPos, toPos))
        var angle = acosf(VecOp.dot(down, dir)) //radians
        var rot   = VecOp.normalize(VecOp.cross(down, dir))
        
        var rMatrix = SCNMatrix4MakeRotation(angle, rot.x, rot.y, rot.z)
        bondNode.transform  = SCNMatrix4Mult(rMatrix, bondNode.transform)
        
        //temporarily set all bonds to the color of the atom they are going towards
        var color1 = colors[fromAtom.type] as [Float]
        var color2 = colors[toAtom.type] as [Float]
        var materials = [SCNMaterial]()
        materials.append(SCNMaterial())
        
        var rgb = CGColorSpaceCreateDeviceRGB()
        var colors: [CGFloat] = [color2[0], color2[1], color2[2], 1.0]
        materials[0].diffuse.contents = CGColorCreate(rgb, colors)
        //  CGColorSpaceRelease(rgb)
        //  materials[0].diffuse.contents = CGColorCreateGenericRGB(color2[0], color2[1], color2[2], 1.0)
        
        bondNode.geometry.materials = materials
        
        return bondNode
    }
    
    static func _loadMoleculeData() -> (NSDictionary, NSDictionary) {
        var path = NSBundle.mainBundle().pathForResource("moleculeData", ofType: ".txt")
        var moleculeText: String = NSString.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        
        var lines = moleculeText.componentsSeparatedByString("\n")
        var keys = [String]()
        var colors = [[Float]]()
        var sizes = [Float]()
        
        for line in lines {
            var item = line.componentsSeparatedByString(":")
            var values: [NSString] = item[1].componentsSeparatedByString(",")
            
            var r    = values[0].floatValue / 255
            var g    = values[1].floatValue / 255
            var b    = values[2].floatValue / 255
            var size = values[3].floatValue
            
            keys.append(item[0])
            colors.append([r, g, b])
            sizes.append(size)
        }
        
        var colorDict = NSDictionary(objects: colors, forKeys: keys)
        var sizeDict  = NSDictionary(objects: sizes, forKeys: keys)
        
        return (colorDict, sizeDict)
        
    }
}