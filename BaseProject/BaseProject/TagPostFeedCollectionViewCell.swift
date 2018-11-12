//
//  tagPostFeedCollectionViewCell.swift
//  BaseProject
//
//  Created by MN on 19/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class TagPostFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var user_img: UIImageView!
    
    var removeTag: (() -> Void)?
    
    @IBAction func closeButtonTapped(sender: UIButton!){
        self.removeTag?()
    }
}
