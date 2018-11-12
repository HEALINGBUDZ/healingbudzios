//
//  PostMoreTableViewCell.swift
//  BaseProject
//
//  Created by MAC MINI on 28/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class PostMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var seperatorLine: UIView!
    
    var isLastCell = false  {
        didSet  {
            seperatorLine.isHidden = isLastCell
        }
    }
    
    var isFlagged = false   {
        didSet  {
            
            if isFlagged == true  && nameLabel.text == "Report"   {
                  nameLabel.textColor = UIColor(hex: "7CC244")
            }
            else
            {

                nameLabel.textColor = .black
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
