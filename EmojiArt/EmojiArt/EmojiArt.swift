//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by QDSG on 2019/12/11.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

struct EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension EmojiArt.EmojiInfo {
    init?(label: UILabel) {
        if let attributedText = label.attributedText, let font = attributedText.font {
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        } else {
            return nil
        }
    }
}
