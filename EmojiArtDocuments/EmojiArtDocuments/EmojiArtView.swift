//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by TT on 2019/10/19.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

protocol EmojiArtViewDelegate: NSObjectProtocol {
    func emojiArtViewDidChanged(_ emojiArtView: EmojiArtView)
}

extension Notification.Name {
    static let emojiArtViewDidChanged = Notification.Name("emojiArtViewDidChanged")
}

class EmojiArtView: UIView {
    
    weak var delegate: EmojiArtViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
    // KVO
    // 使用KVO来观察UILabels的center属性
    // 观察仅持续到堆中
    // 使用此字典将观察结果保留在堆中
    private var labelObservations = [UIView: NSKeyValueObservation]()
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if labelObservations[subview] != nil {
            labelObservations[subview] = nil
        }
    }

}

extension EmojiArtView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centerAt: dropPoint)
                self.delegate?.emojiArtViewDidChanged(self)
                NotificationCenter.default.post(name: .emojiArtViewDidChanged, object: self)
            }
        }
    }
    
    func addLabel(with attributedString: NSAttributedString, centerAt point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
        
        // 使用KVO观察表情符号标签中心属性的变化
        // 更改时（表情符号被移动或调整大小）
        labelObservations[label] = label.observe(\.center) { (label, change) in
            self.delegate?.emojiArtViewDidChanged(self)
            NotificationCenter.default.post(name: .emojiArtViewDidChanged, object: self)
        }
    }
}
