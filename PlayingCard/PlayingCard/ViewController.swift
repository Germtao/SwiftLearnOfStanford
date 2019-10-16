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
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {
            $0.isFaceUp &&
            !$0.isHidden &&
            $0.transform != CGAffineTransform(scaleX: 3.0, y: 3.0) &&
            $0.alpha == 1.0
        }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    private var lastChosenCardView: PlayingCardView?
    
    // MARK: - 动态动画
    // 1.
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    // 2.
    private lazy var cardBehavior = CardBehavior(in: animator)
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
            
            // 3.
            cardBehavior.addItem(cardView)
        }
    }
}

// MARK: - Action
extension ViewController {
    @objc private func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            // faceUpCardViews.count < 2 确保成对处理
            if let cardView = sender.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = cardView
                // behavior移除item
                cardBehavior.removeItem(cardView)
                
                // 添加过渡动画
                UIView.transition(
                    with: cardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        cardView.isFaceUp = !cardView.isFaceUp
                    },
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                                    }
                            }) { (position) in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.75,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        cardsToAnimate.forEach {
                                            $0.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                            $0.alpha = 0.0
                                        }
                                }) { (_) in
                                    cardsToAnimate.forEach {
                                        $0.isHidden = true
                                        $0.alpha = 1.0
                                        $0.transform = .identity
                                    }
                                }
                            }
                        } else if cardsToAnimate.count == 2 {
                            if cardView == self.lastChosenCardView {
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromRight],
                                        animations: {
                                            cardView.isFaceUp = false
                                    }) { _ in
                                        self.cardBehavior.addItem(cardView)
                                    }
                                }
                            }
                        } else {
                            if !cardView.isFaceUp {
                                self.cardBehavior.addItem(cardView)
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
