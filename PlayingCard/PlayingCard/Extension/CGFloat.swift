//
//  CGFloat.swift
//  PlayingCard
//
//  Created by QDSG on 2019/10/16.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max))
    }
}
