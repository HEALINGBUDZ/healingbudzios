//
//  AllBudzCell.swift
//  BaseProject
//
//  Created by lucky on 10/31/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AllBudzCell: UITableViewCell {

    @IBOutlet weak var imgFollow: CircularImageView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUserTopi: UIImageView!
    @IBOutlet weak var imgUser: CircularImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
