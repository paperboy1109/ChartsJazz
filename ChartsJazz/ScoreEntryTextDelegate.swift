//
//  ScoreEntryTextDelegate.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 9/2/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ScoreEntryTextDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //If this is the first time entering text, clear the text field
        if let text = textField.text where text.isEmpty
        {
            textField.placeholder = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }        
    
}
