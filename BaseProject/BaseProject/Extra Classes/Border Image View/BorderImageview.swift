//
//  BorderImageview.swift
//  BaseProject
//
//  Created by Vengile on 16/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

@IBDesignable
class BorderImageView: UIImageView {
	
//
//    @IBInspectable var borderWidth: CGFloat = 2.0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
	
//    @IBInspectable var borderColor: UIColor = UIColor.white {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//            updateView()
//        }
//    }
	
	@IBInspectable var borderRadious: CGFloat = 5.0 {
		didSet {
			layer.cornerRadius = borderRadious
		}
	}
	
	func updateView() {
	
		self.layer.borderWidth = borderWidth;
		self.layer.cornerRadius = borderRadious
		self.layer.borderColor = borderColor.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = true
		
	}
		
	
}

