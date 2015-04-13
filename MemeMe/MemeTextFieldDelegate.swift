//
//  MemeTextFieldDelegate.swift
//  Image Picker
//
//  Created by Joshua Gan on 6/04/2015.
//  Copyright (c) 2015 Threefold Global Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    var edited: Bool = false

    func textFieldDidBeginEditing(textField: UITextField) {
        // Clear default if not edited previously
        if !edited {
            edited = true
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
}