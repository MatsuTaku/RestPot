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
    @IBInspectable var mainColor: UIColor?
    @IBInspectable var ringWidth: CGFloat = 70

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.cornerRadius = rect.height / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        layer.masksToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        setBackgroundImage(image(filled: mainColor), for: .normal)
        setTitleColor(mainColor, for: .highlighted)
        
        super.draw(rect)
    }
    
    func image(filled color: UIColor?) -> UIImage? {
        if color == nil { return nil}
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color!.cgColor)
        context?.fill(self.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let range = self.bounds.height/2
        let center = CGPoint(x: range, y: range)
        let pointFromCenter = CGPoint(x: point.x - center.x, y: point.y - center.y)
        let pointRangePow = pow(pointFromCenter.x, 2) + pow(pointFromCenter.y, 2)
        let holeRange = range - ringWidth
        return pointRangePow <= pow(range, 2) && pointRangePow >= pow(holeRange, 2)
    }
    
}
