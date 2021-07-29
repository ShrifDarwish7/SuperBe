//
//  UIComponentsHelpers.swift
//  TheBest-iOS-Driver
//
//  Created by Sherif Darwish on 11/15/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import UIKit

@IBDesignable
class LocalizedBtn: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reload()
    }
    
    private func reload() {
        if "lang".localized == "ar" {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}

@IBDesignable
class CircluarImage: UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
    }
}

@IBDesignable
class LocalizedImg: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reload()
    }
    
    private func reload() {
        if "lang".localized == "ar" {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.round()
        self.setupBorder()
        self.setupCornerRadius()
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
       // self.round()
        self.setupBorder()
        self.setupCornerRadius()
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
    }
    
    private func setupBorder() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
    private func setupCornerRadius() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}

@IBDesignable
class RoundedLabel: UILabel {
    
    @IBInspectable var cornerRaduis: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reload()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.reload()
    }
    
    private func reload() {
        self.layer.cornerRadius = cornerRaduis
        
        if isCircle { self.round() }
        self.clipsToBounds = true
    }
}
class LocalizedLabel: UILabel{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reload()
    }
    
    private func reload() {
        self.text = self.text?.localized
    }
}

@IBDesignable
class ViewCorners: UIView {
    
    @IBInspectable var roundedTopLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var roundedTopRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var roundedBottomLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var roundedBottomRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRaduis: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var singleCornerRaduis: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        
        super.layoutSubviews()
        self.reload()
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.reload()
    }
    
    private func reload() {
        
        if isCircle { self.round() }
        self.clipsToBounds = true
        
        var corners = CACornerMask()
        
        if roundedTopLeft{
            corners.insert("lang".localized == "en" ? .layerMinXMinYCorner : .layerMaxXMinYCorner)
        }
        if roundedTopRight{
            corners.insert("lang".localized == "en" ? .layerMaxXMinYCorner : .layerMinXMinYCorner)
        }
        if roundedBottomLeft{
            corners.insert("lang".localized == "en" ? .layerMinXMaxYCorner : .layerMaxXMaxYCorner)
        }
        if roundedBottomRight{
            corners.insert("lang".localized == "en" ? .layerMaxXMaxYCorner : .layerMinXMaxYCorner)
        }
        
        if !corners.isEmpty{
            self.roundCorners(corners, radius: singleCornerRaduis)
        }
        
        if self.cornerRaduis != 0.0{
            self.layer.cornerRadius = cornerRaduis
        }
        
        if isShadow { self.setupShadow() }
        
    }
}
