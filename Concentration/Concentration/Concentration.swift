//
//  Concentration.swift
//  Concentration
//
//  Created by TT on 2019/10/13.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfTheOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                indexOfTheOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for identifier in 0..<numberOfPairsOfCards {
            let card = Card(identifier: identifier)
            cards += [card, card]
        }
        
        // TODO: 洗牌
    }
}
