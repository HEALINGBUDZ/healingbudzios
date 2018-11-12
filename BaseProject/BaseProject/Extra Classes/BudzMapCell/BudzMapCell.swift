//
//  BudzMapCell.swift
//  BaseProject
//
//  Created by MAC MINI on 02/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class BudzMapCell: UITableViewCell {

    var section : Int  = 0
    @IBOutlet weak var EditWidth: NSLayoutConstraint!
    @IBOutlet weak var DeleteWidth: NSLayoutConstraint!
    @IBOutlet weak var view_featured: UIView!
    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var view_DottedLine: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblreview: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var imgviewType: UIImageView!
    @IBOutlet weak var imgviewDelivery: UIImageView!
    @IBOutlet weak var imgviewOrganic: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var view_Edit: UIView!
    @IBOutlet weak var view_Delete: UIView!
        
    @IBOutlet weak var imgviewStar1: UIImageView!
    @IBOutlet weak var imgviewStar2: UIImageView!
    @IBOutlet weak var imgviewStar3: UIImageView!
    @IBOutlet weak var imgviewStar4: UIImageView!
    @IBOutlet weak var imgviewStar5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgviewUser.CornerRadious()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func ShowDeleteOptions(value : Bool) {
        self.view_Delete.isHidden = value
        self.view_Edit.isHidden = value
        
        if value {
            self.EditWidth.constant = 0
            self.DeleteWidth.constant = 0
            
            self.imgviewDelivery.center = self.view_Delete.center
            self.imgviewOrganic.center = self.view_Edit.center
        }else {
            self.EditWidth.constant = 30
            self.DeleteWidth.constant = 30
        }
        
        
        self.layoutIfNeeded()
        
    }
    
}


class BudzMainMapCell: UITableViewCell {
    
    @IBOutlet weak var view_featured: UIView!
    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var view_DottedLine: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblreview: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var imgviewType: UIImageView!
    @IBOutlet weak var imgviewDelivery: UIImageView!
    @IBOutlet weak var imgviewOrganic: UIImageView!
    
    
    @IBOutlet weak var imgviewStar1: UIImageView!
    @IBOutlet weak var imgviewStar2: UIImageView!
    @IBOutlet weak var imgviewStar3: UIImageView!
    @IBOutlet weak var imgviewStar4: UIImageView!
    @IBOutlet weak var imgviewStar5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

    
}
