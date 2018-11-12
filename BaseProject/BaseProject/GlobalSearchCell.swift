//
//  GlobalSearchCell.swift
//  BaseProject
//
//  Created by Syed Qasim on 03/05/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class GlobalSearchCell: UITableViewCell {

    @IBOutlet weak var ui_feature_for_adz: UIView!
    @IBOutlet weak var lblName: ActiveLabel!
    @IBOutlet weak var lblDescription: ActiveLabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setQAValues(qa: QA) {
        self.lblName.text = qa.user_name
        self.lblDescription.text = qa.Question_description
        self.imgView.sd_setImage(with: URL.init(string: qa.user_photo), placeholderImage : #imageLiteral(resourceName: "noimage") ,completed: { (image, error, chache, url) in
        })

    }
}
