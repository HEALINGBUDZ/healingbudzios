//
//  PointsLogCell.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class PointsLogCell: UITableViewCell {
    @IBOutlet weak var Lbl_points: UILabel!
    @IBOutlet weak var LBL_discription: UILabel!
    @IBOutlet weak var LBL_date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
