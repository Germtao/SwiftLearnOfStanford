//
//  Concentration.swift
//  Concentration
//
//  Created by TT on 2019/10/13.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import Foundation

// 结构体 - 值类型，写时复制可变内容
struct Concentration {
    
    var cards = [Card]()
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        // 断言保护Api
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards.")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfTheOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration(\(numberOfPairsOfCards)): you must have at least one pair of cards.")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // TODO: 洗牌
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
