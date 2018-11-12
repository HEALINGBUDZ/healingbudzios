//
//  SaveMeView.swift
//  SaveMe
//
//  Created by Vengile on 20/03/2017.
//  Copyright © 2017 Vengile. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
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
		self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
