//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by QDSG on 2019/10/15.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {

    
}

extension PlayingCardView {
    
    override func draw(_ rect: CGRect) {
        // 1. 上下文绘制
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY),
//                           radius: 100.0,
//                           startAngle: 0,
//                           endAngle: CGFloat.pi * 2,
//                           clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath() // 使用了路径, 下行fillPath()无效
//            context.fillPath()
//        }
        
        // 2. 贝塞尔曲线
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                radius: 100.0,
                                startAngle: 0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        path.fill()
    }
}
