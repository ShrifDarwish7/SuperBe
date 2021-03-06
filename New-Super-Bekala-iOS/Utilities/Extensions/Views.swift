//
//  Views.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setupShadow(){
        //self.layer.cornerRadius = 10
        //self.backgroundColor = UIColor.white
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
    }
      
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
    }
    
    func round() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func roundCorners(_ value: CGFloat = 10.0) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    
    func shake(_ viberation: Vibration? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        if let viberation = viberation{
            viberation.vibrate()
        }
    }
    
}

