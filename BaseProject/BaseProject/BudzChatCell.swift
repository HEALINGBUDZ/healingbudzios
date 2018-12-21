//
//  BudzChatCell.swift
//  BaseProject
//
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class BudzChatCell: UITableViewCell {

    @IBOutlet weak var indicator_unread: CircularImageView!
    @IBOutlet weak var lbl_unread: UILabel!
    @IBOutlet weak var lbl_type_name: UILabel!
    @IBOutlet weak var lbl_BudzName: UILabel!
    @IBOutlet weak var img_type: UIImageView!
    @IBOutlet weak var imd_budz: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
