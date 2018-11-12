//
//  UIViewExtensions.swift
//  BaseProject
//
//  Created by MAC MINI on 28/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit
private var vBorderColour: UIColor = UIColor.white
private var vCornerRadius: CGFloat = 0.0
private var vBorderWidth: CGFloat = 0.0
private var vMasksToBounds: Bool = true
private var vMakeCircle: Bool = false
@IBDesignable
class GradientTopBottomView: UIView {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var leftGradientColor: UIColor = UIColor.clear {
        didSet {
            updateView()//setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
        }
    }
    
    @IBInspectable
    var rightGradientColor: UIColor = UIColor.clear {
        didSet {
            updateView()
            //setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    private func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [leftGradientColor.cgColor, rightGradientColor.cgColor]
        //layer.startPoint = CGPoint(x: 0, y: 0.5)
        //layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.locations = [0.5]
    }
    
    private func setGradient(leftGradientColor: UIColor?, rightGradientColor: UIColor?) {
        if let leftGradientColor = leftGradientColor, let rightGradientColor = rightGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [leftGradientColor.cgColor, rightGradientColor.cgColor]
            //            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            //            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

@IBDesignable class UIView_Category: UIView   {
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if makeCircle   {
            layer.cornerRadius = self.bounds.width / 2
        }
        else    {
            layer.cornerRadius = cornerRadius
        }
        layer.borderColor = vBorderColour.cgColor
        layer.borderWidth = vBorderWidth
        layer.masksToBounds = vMasksToBounds
        self.layoutIfNeeded()
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.layoutIfNeeded()
    }
    
    
}

extension UIView{
    
    func startShimmering(){
        let light = UIColor.black.cgColor
        let alpha = UIColor.black.withAlphaComponent(0.7).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha, alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        self.layer.mask = nil
    }
    
    func Blinking(duration: TimeInterval = 0.8) {
        let alpha = self.alpha
        if alpha == 1.0 {
            self.alpha = 1.0
        }else{
            self.alpha = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            if alpha == 1.0 {
                self.alpha = 0.8
            }else{
                self.alpha = 1.0
            }
        }) { (animationCompleted: Bool) -> Void in
            if !isProfileBlinkingClose && blinking_count < 8{
                blinking_count = blinking_count + 1
                self.Blinking()
            }else{
                self.layer.removeAllAnimations()
            }
        }
    }
    
    func bouncingAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.1)
        UIView.animate(withDuration: 1.0,delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0,options: .allowUserInteraction,animations: {
            [weak self] in
            self?.transform = .identity
            }, completion: nil)
    }
}


extension UIView    {    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return vCornerRadius
        }
        set {
            layer.cornerRadius = newValue
            vCornerRadius = newValue
            self.setNeedsLayout()
            
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return vBorderWidth
        }
        set {
            layer.borderWidth = newValue
            vBorderWidth = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return vMasksToBounds
        }
        set {
            layer.masksToBounds = newValue
            vMasksToBounds = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get{
            
            return vBorderColour
        }
        set {
            
            layer.borderColor = newValue.cgColor
            vBorderColour = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var makeCircle: Bool {
        get{
            
            return vMakeCircle
        }
        set {
            
            if newValue  {
                cornerRadius = frame.size.width / 2
                masksToBounds = true
            }
            else    {
                cornerRadius = vCornerRadius
                masksToBounds = vMakeCircle
            }
            vMakeCircle = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
                self.setNeedsLayout()
            }
        }
    }
    
    func centerInSuperview() {
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        self.setNeedsLayout()
        
    }
    func equalAndCenterToSupper() {
        
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        leadingInSuperview()
        trailingInSuperview()
        topInSuperview()
        bottomInSuperview()
        self.setNeedsLayout()
        
        
    }
    func centerHorizontallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func centerVerticallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func leadingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.leadingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func trailingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.trailingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func topInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.topMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func bottomInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.bottomMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    class func fromNib<T : UIView>() -> T {
        
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    
}

