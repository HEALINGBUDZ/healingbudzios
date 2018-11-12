//
//  LoadingCell.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loading.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
