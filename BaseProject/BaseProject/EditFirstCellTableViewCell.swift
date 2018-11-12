//
//  EditFirstCellTableViewCell.swift
//  BaseProject
//
//  Created by Abc on 9/12/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
class EditFirstCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_description: ActiveLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
