//
//  EmojiArtView+Gestures.swift
//  EmojiArt
//
//  Created by QDSG on 2019/10/25.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

extension EmojiArtView {
    
    var selectedSubView: UIView? {
        get {
            return subviews.filter { $0.layer.borderWidth > 0 }.first
        }
        set {
            subviews.forEach { $0.layer.borderWidth = 0 }
            newValue?.layer.borderWidth = 1
            if newValue != nil {
                enableRecognizers()
            } else {
                disableRecognizers()
            }
        }
    }
    
    func addEmojiArtGestureRecognizers(to view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSubView(by:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(selectAndMoveSubView(by:))))
    }
    
    @objc func selectSubView(by recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            print("\(recognizer.view!)")
            selectedSubView = recognizer.view
        }
    }
    
    @objc func selectAndMoveSubView(by recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if selectedSubView != nil, recognizer.view != nil {
                selectedSubView = recognizer.view
            }
        case .changed, .ended:
            if selectedSubView != nil {
                recognizer.view?.center = recognizer.view!.center.offset(by: recognizer.translation(in: self))
                recognizer.setTranslation(.zero, in: self)
                if recognizer.state == .ended {
                    delegate?.emojiArtViewDidChanged(self)
                }
            }
        default:
            break
        }
    }
    
    @objc func deselectSubView() {
        selectedSubView = nil
    }
    
    @objc func resizeSelectedLabel(by recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            if let label = selectedSubView as? UILabel {
                label.attributedText = label.attributedText?.withFontScaled(by: recognizer.scale)
                label.stretchToFit()
                recognizer.scale = 1.0
                if recognizer.state == .ended {
                    delegate?.emojiArtViewDidChanged(self)
                }
            }
        default:
            break
        }
    }
    
    func enableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        
        if gestureRecognizers == nil || gestureRecognizers!.count == 0 {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deselectSubView)))
            addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(resizeSelectedLabel(by:))))
        } else {
            gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    func disableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
        }
        
        gestureRecognizers?.forEach { $0.isEnabled = false }
    }
}
