//
//  SequenceGenerator.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 9/1/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//
// * Note: this class is derived from the FibonacciGenerator found here:
// https://www.uraimo.com/2015/11/12/experimenting-with-swift-2-sequencetype-generatortype/

import Foundation

class SequenceGenerator {
    
    func createSequenceWithStartingPoint(startingPoint: Double, end: Double, numberOfSteps: Int) -> [Double] {
        let n = numberOfSteps
        let newArray = 0...n
        
        let step = (end - startingPoint) / Double(n)
        
        return newArray.map() {startingPoint + Double($0) * step}
    }
    
}