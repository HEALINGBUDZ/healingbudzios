//
//  RewarsDiscriptionCell.swift
//  BaseProject
//
//  Created by MAC MINI on 20/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class RewarsDiscriptionCell: UITableViewCell {

    @IBOutlet weak var LBL_Rewards_point: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.SetAttributedText(mainString: "GET 350 FREE REWARD POINTS", attributedStringsArray: ["350 FREE"], view: self.LBL_Rewards_point , color : UIColor.init(hexColor: "679C41"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
