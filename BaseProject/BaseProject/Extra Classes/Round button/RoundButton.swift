//
//  RoundButton.swift
//  BaseProject
//
//  Created by Vengile on 16/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//custom logic goes here
		self.CornerRadious()
	}
	
	override func CornerRadious()  {
		self.layer.borderWidth = 1;
		self.layer.cornerRadius = 5
		self.layer.borderColor = UIColor.clear.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}


class CornerRoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CornerWithgrayRoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 8
        self.layer.borderColor =  UIColor.init(red: (107/255), green: (102/255), blue: (93/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
