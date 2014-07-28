//
//  GameConstants.swift
//  MoleculeFlashcardsiOS
//
//  Created by exscitech on 7/10/14.
//  Copyright (c) 2014 exscitech. All rights reserved.
//

import UIKit

struct GameConstants {
    // URL constants
    static let REQUEST_HANDLER_URL = "https://exscitech.org/request_handler.php"
    static let GET_MEDIA_URL = "https://exscitech.org/get_media.php"
    
    // Button constants
    static let BUTTON_ROUNDNESS: CGFloat = 4.0

    static let SCORE_COLOR = UIColor(red: 0.0, green: 0.71, blue: 0, alpha: 1.0)
    static let BUTTON_GRAY_PRESSED_COLOR = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
    static let BUTTON_GRAY_DEFAULT_COLOR = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
    static let BUTTON_CORRECT_DEFAULT_COLOR = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    static let BUTTON_WRONG_COLOR = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let BUTTON_GREEN_COLOR = UIColor(red: 0.54, green: 0.78, blue: 0.24, alpha: 1.0)
    
    // Molecule constants
    static let LIGHT_NODE_COLOR = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    static let AMBIENT_LIGHT_NODE_COLOR = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    static let SCENE_VIEW_BACKGROUND_COLOR = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
    
    static let MOLECULE_SPIN_AMOUNT: Float = 0.01
    
    // Message constants
    static let WELCOME_MESSAGE = "Thanks for downloading our app! Remember to log in or register by clicking the icon in the upper right-hand corner of the screen."
                                 + "If you would like to add your own question sets, just register, then visit the ExSciTecH website and use our question set editor. Have fun!"
    static let CONFIRM_NO_SCORE_MESSAGE = "\nYour scores will not be saved unless you register. Play anyway?"
    static let CONFIRM_LOGOUT_MESSAGE = ", are you sure you want to log out?"
    static let PASSWORD_ERROR_MESSAGE = "Password's do not match!"
}