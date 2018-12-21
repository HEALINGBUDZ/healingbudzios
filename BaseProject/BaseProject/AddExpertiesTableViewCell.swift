//
//  AddExpertiesTableViewCell.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AddExpertiesTableViewCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var warnView: UIView!
    @IBOutlet var warnButton: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var warnPopUP: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
