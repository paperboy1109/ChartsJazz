//
//  File.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 8/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Foundation

class DataGenerator {
    
    static var randomizedSale: Double {
        return Double(arc4random_uniform(10000) + 1) / 10
    }
    
    static func data() -> [Sale] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var sales = [Sale]()
        
        for month in months {
            let sale = Sale(month: month, value: randomizedSale)
            sales.append(sale)
        }
        
        return sales
    }
}