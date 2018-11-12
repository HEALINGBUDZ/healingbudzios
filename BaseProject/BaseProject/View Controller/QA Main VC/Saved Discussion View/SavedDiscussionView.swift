//
//  SavedDiscussionView.swift
//  BaseProject
//
//  Created by macbook on 05/09/2017.
//  Copyright © 2017 SavedDiscussionView. All rights reserved.
//

import UIKit

class SavedDiscussionView: UIView {

    var parentViewMain : UIView!
    
   @IBOutlet var imgView_Main : UIImageView!
    
    class func loadFromXib() -> SavedDiscussionView {
        return Bundle.main.loadNibNamed("SavedDiscussionView", owner: self, options: nil)!.first as! SavedDiscussionView
    }


    func addInView(_ parentView: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false;
        parentView.addSubview(self)
        
        let constraint1 = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: parentView, attribute: .width, multiplier: 1, constant: 0)
        let constraint4 = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: parentView, attribute: .height, multiplier: 1, constant: 0)
        
        parentView.addConstraint(constraint1)
        parentView.addConstraint(constraint2)
        parentView.addConstraint(constraint3)
        parentView.addConstraint(constraint4)
        
        
    }
    
    
    @IBAction func Close(sender : UIButton){
        self.removeFromSuperview()
    }
    
    @IBAction func Check_Action(sender : UIButton){
    
        if sender.isSelected {
            sender.isSelected = false
            self.imgView_Main.image = UIImage.init(named: "checkE")
        }else {
            sender.isSelected = true
            self.imgView_Main.image = UIImage.init(named: "checkS")
        }
    }
}
