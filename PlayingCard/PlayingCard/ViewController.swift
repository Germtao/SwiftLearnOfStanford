//
//  ViewController.swift
//  PlayingCard
//
//  Created by QDSG on 2019/10/15.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(by:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action
extension ViewController {
    @objc private func nextCard() {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.description
        }
    }
    
    @IBAction private func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
    }
}
