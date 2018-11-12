//
//  BaseImageTextField.swift
//  SaveMe
//
//  Created by Vengile on 15/03/2017.
//  Copyright © 2017 Vengile. All rights reserved.
//

import UIKit

@IBDesignable
class BaseImageTextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leadingPadding
        return textRect
    }
    
    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leadingPadding
        return textRect
    }
    
    @IBInspectable var leadingImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    
//    @IBInspectable var Border_Width: CGFloat = 2.0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable var Border_Color: UIColor = UIColor.white {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
    
    
    @IBInspectable var borderRadious: CGFloat = 5.0 {
        didSet {
           layer.cornerRadius = borderRadious
        }
    }
    
    
    @IBInspectable var leadingPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = Constants.kBorderColor {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rtl: Bool = false {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        rightViewMode = UITextFieldViewMode.never
        rightView = nil
        leftViewMode = UITextFieldViewMode.never
        leftView = nil
        
        if let image = leadingImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            
            if rtl {
                rightViewMode = UITextFieldViewMode.always
                rightView = imageView
                contentVerticalAlignment = .center
            } else {
                leftViewMode = UITextFieldViewMode.always
                leftView = imageView
                contentVerticalAlignment = .center
            }
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : " ", attributes:[NSForegroundColorAttributeName: color])
    }
    
}
