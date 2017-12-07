//
//  GradientColor.swift
//  FUPermissionManager
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad. All rights reserved.
//

import UIKit

@IBDesignable final class FUGradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    
    @IBInspectable var horizontal: Bool = false {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var addShadow: Bool = false {
        didSet {
            setup()
        }
    }
    
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        
        if horizontal {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        gradient.zPosition = -1
        layer.addSublayer(gradient)
        
        if addShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 3)
            layer.shadowRadius = 3
            layer.shadowOpacity = 0.5
            layer.masksToBounds = false
        }
    }
}
