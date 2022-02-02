//
//  UIComponentsHelpers.swift
//  TheBest-iOS-Driver
//
//  Created by Sherif Darwish on 11/15/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var leftImageTintColor: UIColor?
    @IBInspectable var rightImageTintColor: UIColor?
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            if let image = leftImage {
                leftViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                imageView.tintColor = leftImageTintColor
                leftView = imageView
            } else {
                leftViewMode = UITextField.ViewMode.never
                leftView = nil
            }
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                imageView.tintColor = rightImageTintColor
                rightView = imageView
            } else {
                rightViewMode = UITextField.ViewMode.never
                rightView = nil
            }
        }
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
}

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
class TriangleView : UIView {
    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0

    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }


    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + _margin))
        context.closePath()

        context.setFillColor(_color.cgColor)
        context.fillPath()
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
class LocalizedSystemBtn: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        sharedInit()
    }

    func sharedInit() {
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
    }
}

extension UIButton{
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
    }
}

@IBDesignable
class SystemLocalizedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
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
    private func setupBorder() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
    private func setupCornerRadius() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        self.setupBorder()
        self.setupCornerRadius()
        self.setTitle(self.title(for: .normal)?.localized, for: .normal)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.sharedInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sharedInit()
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
