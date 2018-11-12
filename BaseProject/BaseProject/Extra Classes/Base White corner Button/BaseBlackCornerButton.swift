//
//  File.swift
//  Wave
//
//  Created by Vengile on 08/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import Foundation
import UIKit

class BaseBlackCornerButton: UIButton {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//custom logic goes here
		self.CornerRadious()
	}
	
	override func CornerRadious()  {
		self.backgroundColor = UIColor.black
		self.layer.cornerRadius = Constants.kCornerRaious
		self.layer.borderColor = UIColor.clear.cgColor
		self.layer.borderWidth = 10
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
