//
//  PostFeedOptionBarView.swift
//  BaseProject
//
//  Created by MAC MINI on 04/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//


import UIKit
class PostFeedOptionBarView: UIView  {
    
    @IBOutlet weak var iconImageView: UIImageView!
    var isSelected = false  {
        didSet  {
            //            let image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
            iconImageView.image = isSelected ? #imageLiteral(resourceName: "wall_new_post_repost_icon_selected") : #imageLiteral(resourceName: "wall_new_post_repost_icon")
            
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func toggleView(sender: UIButton!) {
        self.isSelected = !self.isSelected
    }
    
}
