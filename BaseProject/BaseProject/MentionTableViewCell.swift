//
//  MentionTableViewCell.swift
//  MentionTextView
//
//  Created by Incubasyss on 20/04/2018.
//  Copyright © 2018 Incubasyss. All rights reserved.
//

import UIKit
import MJAutoComplete

class MentionTableViewCell: MJAutoCompleteCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageViewTop: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var autoCompleteItem: MJAutoCompleteItem!{
        didSet {
            super.autoCompleteItem = autoCompleteItem
            
            print(autoCompleteItem)
        }
    }
    
}
