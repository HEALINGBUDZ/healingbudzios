//
//  BaseBlackCornerTextField.swift
//  BaseProject
//
//  Created by Vengile on 14/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class BaseBlackCornerTextField: UITextField {

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//custom logic goes here
		self.CornerRadious()
	}
	
	override func CornerRadious()  {
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = Constants.kCornerRaious
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 1
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
