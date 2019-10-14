//
//  Card.swift
//  Concentration
//
//  Created by TT on 2019/10/13.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import Foundation

struct Card {
    /// 是否翻开
    var isFaceUp = false
    /// 是否匹配
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}

extension Card: Hashable {
    
      // Swift5之前
//    var hashValue: Int {
//        return identifier
//    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
