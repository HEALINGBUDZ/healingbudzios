//
//  MedicalCell.swift
//  BaseProject
//
//  Created by Jawad on 6/14/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class MedicalCell: UITableViewCell {

    @IBOutlet weak var bottom_view_hight: NSLayoutConstraint!
    @IBOutlet weak var bottom_view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
