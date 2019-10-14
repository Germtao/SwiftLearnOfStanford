//
//  ViewController.swift
//  Concentration
//
//  Created by TT on 2019/10/13.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 多少对卡牌
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: self.numberOfPairsOfCards)
    
    private(set) var flipCount: Int = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
//    private var emojiChoices = ["👻", "😈", "🎃", "👹", "🤡", "👽"]
    private var emojiChoices = "👻😈🎃👹🤡👽"
    
    private var emoji = [Card: String]()
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Action
extension ViewController {
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
}

private extension ViewController {
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStingIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
//            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStingIndex))
        }
        return emoji[card] ?? "?"
    }
    
    func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.systemOrange
        ]
        let attributedString = NSAttributedString(string: "翻牌：\(flipCount)次", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
}

