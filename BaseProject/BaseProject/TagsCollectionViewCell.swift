//
//  TagsCollectionViewCell.swift
//  BaseProject
//
//  Created by MN on 18/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var profileImageTop:UIImageView!
    @IBOutlet weak var removeTag: UIButton!
    @IBOutlet weak var nameuser: UILabel!
    var removeTagsButtonAction: (() -> Void)?
    @IBAction func removeTagTapped(sender: UIButton!){
        removeTagsButtonAction?()
    }
}
