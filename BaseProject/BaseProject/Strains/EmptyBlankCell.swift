//
//  EmptyCell.swift
//  BaseProject
//
//  Created by Abc on 9/7/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EmptyBlankCell: UITableViewCell {

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
