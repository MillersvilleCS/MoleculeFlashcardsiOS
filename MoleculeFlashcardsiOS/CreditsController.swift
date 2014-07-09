//
//  MainController.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 6/30/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

class CreditsController : UIViewController {
    
    @IBOutlet var exscitechButton: UIButton
    @IBOutlet var connorButton: UIButton
    @IBOutlet var willButton: UIButton
    @IBOutlet var kimButton: UIButton
    @IBOutlet var samButton: UIButton
    @IBOutlet var michelaButton: UIButton
    @IBOutlet var nsfButton: UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        var url = NSURL(string: "")
        
        if sender.isEqual(exscitechButton) {
            url = NSURL(string: "https://exscitech.org/")
        } else if sender.isEqual(connorButton) {
            url = NSURL(string: "http://connormahaffey.com/")
        } else if sender.isEqual(willButton) {
            url = NSURL(string: "https://github.com/GameGeazer")
        } else if sender.isEqual(kimButton) {
            url = NSURL(string: "https://github.com/kbroskie")
        } else if sender.isEqual(samButton) {
            url = NSURL(string: "http://samschlachter.com")
        } else if sender.isEqual(michelaButton) {
            url = NSURL(string: "http://gcl.cis.udel.edu/personal/taufer/index.php")
        } else {
            url = NSURL(string: "http://www.nsf.gov/awardsearch/showAward?AWD_ID=0968350")
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
}