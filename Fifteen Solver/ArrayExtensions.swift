//
//  ArrayExtensions.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 03/11/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation

extension Array {
    func all(predicate: Element -> Bool) -> Bool {
        for elem in self where !predicate(elem) { return false }
        return true
    }
    
}