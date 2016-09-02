//
//  DJJString.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 9/2/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//
// Note: this code is adaped for this app but orignially sourced from here:
// http://stackoverflow.com/questions/30315723/check-if-string-is-a-valid-double-value-in-swift

import Foundation

extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.numberFromString(self)?.doubleValue
    }
    var integerValue:Int? {
        return NumberFormatter.instance.numberFromString(self)?.integerValue
    }
}