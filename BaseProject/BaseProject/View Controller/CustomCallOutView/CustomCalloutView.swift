//
//  CustomCalloutView.swift
//  BaseProject
//
//  Created by MAC MINI on 03/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    var index  :Int = 0
    var onAnnotaionClck: ((Int) -> Void)?
    @IBOutlet var btnNewScreen : UIButton!
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblTime : UILabel!
    
    @IBOutlet var imgViewMain : UIImageView!    
    @IBOutlet var imgViewStar1 : UIImageView!
    @IBOutlet var imgViewStar2 : UIImageView!
    @IBOutlet var imgViewStar3 : UIImageView!
    @IBOutlet var imgViewStar4 : UIImageView!
    @IBOutlet var imgViewStar5 : UIImageView!

    @IBAction func onClickAnnotaion(_ sender: UIButton) {
    }
}
