//
//  HBStoreHeaderCell.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class HBStoreHeaderCell: UITableViewCell {

    @IBOutlet var totalRewardLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var homesButtonAction: (() -> Void)?
    var backButtonAction: (() -> Void)?
    
    @IBAction func homeButtonClicked(sender: UIButton!){
        homesButtonAction?()
    }
    
    @IBAction func backButtonClicked(sender: UIButton!){
        backButtonAction?()
    }
    
}
