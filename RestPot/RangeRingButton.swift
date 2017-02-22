//
//  RangeRingButton.swift
//  RestPot
//
//  Created by 松本拓真 on 2017/02/21.
//  Copyright © 2017年 TakumaMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable class RangeRingButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: CGColor = UIColor.white.cgColor
    @IBInspectable var masksToBounds: Bool = true

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.masksToBounds = masksToBounds
        
        super.draw(rect)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let range = self.bounds.height/2
        let center = CGPoint(x: range, y: range)
        let pointFromCenter = CGPoint(x: point.x - center.x, y: point.y - center.y)
        let pointRangePow = pow(pointFromCenter.x, 2) + pow(pointFromCenter.y, 2)
//        print(pointRangePow, pow(range, 2))
        return pointRangePow <= pow(range, 2)
    }
}
