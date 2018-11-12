//
//  PostFeedOptionView.swift
//  BaseProject
//
//  Created by Yasir Ali on 02/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class PostFeedOptionView: UIView  {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isSelected = false  {
        didSet  {
//            let image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
            iconImageView.image = isSelected ? #imageLiteral(resourceName: "wall_new_post_repost_icon_selected") : #imageLiteral(resourceName: "wall_new_post_repost_icon")
            let check_color:UIColor! = UIColor(red:0.00, green:0.51, blue:0.79, alpha:1.0)
            let color = isSelected ? check_color : UIColor.gray
            titleLabel.textColor = UIColor.init(hex: "b9b9b9")
            descriptionLabel.textColor = UIColor.init(hex: "757575")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


