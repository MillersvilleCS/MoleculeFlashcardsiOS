//
//  ImageLoader.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/26/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

struct ImageLoader {
    static func load(#url: String) -> UIImage {
        var convertedURL = NSURL.URLWithString(url)
        var err: NSError?
        var imageData :NSData = NSData.dataWithContentsOfURL(convertedURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        return UIImage(data:imageData)
    }
}