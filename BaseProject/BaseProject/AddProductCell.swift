//
//  AddProductCell.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

typealias ProductHandler = () -> Void


class AddProductCell: UITableViewCell {

    var productHandler:ProductHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickProduct(_ sender: Any) {
        if self.productHandler != nil {
            self.productHandler!()
        }
    }
}
