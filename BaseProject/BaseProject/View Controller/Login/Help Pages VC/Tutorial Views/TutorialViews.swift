//
//  TutorialViews.swift
//  BaseProject
//
//  Created by macbook on 08/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import Foundation
import UIKit

class TutorialViews: UIView {

    
    @IBAction func HideView(sender : UIButton){
        let s = UIStoryboard.init(name: "BudzStoryBoard", bundle: nil)
        let next = s.instantiateViewController(withIdentifier: "TermsAndConditionPopUpVC")
        self.parentContainerViewController?.present(next, animated: false) {
            
        }
    }
}
