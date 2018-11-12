//
//  SaveMeImage.swift
//  SaveMe
//
//  Created by Vengile on 20/03/2017.
//  Copyright © 2017 Vengile. All rights reserved.
//

import UIKit

class BaseImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    
    override func CornerRadious()  {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
}
