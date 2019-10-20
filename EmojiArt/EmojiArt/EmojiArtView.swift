//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by TT on 2019/10/19.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
