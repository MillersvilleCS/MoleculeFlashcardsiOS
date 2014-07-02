//
//  TableViewGameCell.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/1/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import Foundation
import UIKit

class TableViewGameCell : UITableViewCell {
    
    @IBOutlet var cellImageView : UIImageView
    @IBOutlet var cellLabel: UILabel
    
    func loadItem(#text: String, image: UIImage) {
        println(self.description)
        cellImageView.image = image
        cellLabel.text = text
    }
}