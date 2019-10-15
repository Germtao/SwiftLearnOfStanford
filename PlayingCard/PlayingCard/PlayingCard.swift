//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by QDSG on 2019/10/15.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

struct PlayingCard {
    var suit: Suit
    var rank: Rank
    
    enum Suit: String {
        case spades   = "♠️"
        case hearts   = "❤️"
        case clubs    = "♣️"
        case diamonds = "♦️"
        
        static var all: [Suit] = [.spades, .hearts, .clubs, .diamonds]
    }
    
    enum Rank {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var ranks = [Rank.ace]
            for pips in 2...10 {
                ranks.append(numeric(pips))
            }
            ranks += [face("J"), face("Q"), face("K")]
            return ranks
        }
    }
}
