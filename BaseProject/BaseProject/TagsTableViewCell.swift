//
//  TagsTableViewCell.swift
//  BaseProject
//
//  Created by MN on 18/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageTop: UIImageView!
    @IBOutlet weak var addTag: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var addTagsButtonAction: (() -> Void)?
    
    @IBAction func addTagTapped(sender: UIButton!){
        self.addTagsButtonAction?()
    }
}
