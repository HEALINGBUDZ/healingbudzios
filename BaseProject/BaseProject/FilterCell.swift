//
//  FilterCell.swift
//  BaseProject
//
//  Created by MAC MINI on 02/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var crossImg: UIImageView!
    @IBOutlet weak var imgYellowSeprator: UIImageView!
    @IBOutlet weak var imgBackGroun: UIImageView!
    @IBOutlet weak var imgRadioIcon: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
