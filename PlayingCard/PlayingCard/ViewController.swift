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
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(by:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        for _ in 1...(cardViews.count + 1) / 2 {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.description
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
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
    
    @objc private func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let cardView = sender.view as? PlayingCardView {
                // 添加过渡动画
                UIView.transition(
                    with: cardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        cardView.isFaceUp = !cardView.isFaceUp
                    },
                    completion: { finished in
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    self.faceUpCardViews.forEach {
                                        $0.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                                    }
                            }) { (position) in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.75,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.faceUpCardViews.forEach {
                                            $0.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                            $0.alpha = 0.0
                                        }
                                }) { (_) in
                                    self.faceUpCardViews.forEach {
                                        $0.isHidden = true
                                        $0.alpha = 1.0
                                        $0.transform = .identity
                                    }
                                }
                            }
                        } else if self.faceUpCardViews.count == 2 {
                            self.faceUpCardViews.forEach { cardView in
                                UIView.transition(
                                    with: cardView,
                                    duration: 0.6,
                                    options: [.transitionFlipFromRight],
                                    animations: {
                                        cardView.isFaceUp = false
                                    }
                                )
                            }
                        }
                    }
                )
            }
        default:
            break
        }
    }
}
