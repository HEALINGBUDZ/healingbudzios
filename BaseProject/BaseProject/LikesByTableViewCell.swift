//
//  LikesByTableViewCell.swift
//  BaseProject
//
//  Created by MN on 13/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class LikesByTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageTop: UIImageView!
    var userID: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var profileButtonAction: ((String) -> Void)?
    
    @IBAction func profileButtonTApped(sender: UIButton!){

        profileButtonAction?(self.userID)
    }

}
