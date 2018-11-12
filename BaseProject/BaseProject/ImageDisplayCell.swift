//
//  ImageDisplayCell.swift
//  BaseProject
//
//  Created by lucky on 10/8/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class ImageDisplayCell: UITableViewCell {

    @IBOutlet weak var others_image: UIImageView!
    @IBOutlet weak var lbl_image: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
