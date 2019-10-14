//
//  Int.swift
//  Concentration
//
//  Created by QDSG on 2019/10/14.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import Foundation

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
