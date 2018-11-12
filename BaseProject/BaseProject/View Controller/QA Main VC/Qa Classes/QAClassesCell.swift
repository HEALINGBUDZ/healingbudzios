//
//  QAClassesCell.swift
//  BaseProject
//
//  Created by waseem on 20/02/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

class QuestionMainCell: UITableViewCell {
    @IBOutlet var btn_user_profile : UIButton!
    @IBOutlet var btn_diccription : UIButton!
    @IBOutlet var btn_Like : UIButton!
    @IBOutlet var ImgView_Like : UIImageView!
    @IBOutlet var ImgView_User : UIImageView!
    @IBOutlet var ImgView_UserTop : UIImageView!
    @IBOutlet var btn_Report : UIButton!
    @IBOutlet var imgView_Report : UIImageView!
    @IBOutlet var btn_Share : UIButton!
    @IBOutlet var btn_Answer : UIButton!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet var lbl_Question : ActiveLabel!
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var imageButton2: UIButton!
    
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var videoIcon3: UIImageView!
    @IBOutlet weak var attachmentImage3: RoundImageView!
    @IBOutlet weak var videoIcon2: UIImageView!
    @IBOutlet weak var attachmentImage2: RoundImageView!
    @IBOutlet weak var videoIcon1: UIImageView!
    @IBOutlet weak var attachmentImage1: RoundImageView!
}

class QuestionwithAnswerCell: UITableViewCell {
     @IBOutlet var btn_user_profile : UIButton!
    @IBOutlet var btn_Like : UIButton!
    @IBOutlet var ImgView_Like : UIImageView!
    @IBOutlet var ImgView_User : UIImageView!
    @IBOutlet var ImgView_UserTop : UIImageView!
    @IBOutlet var btn_Report : UIButton!
    @IBOutlet var btn_Share : UIButton!
    @IBOutlet var imgView_Report : UIImageView!
    @IBOutlet var btn_Discuss : UIButton!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet var lbl_Question : ActiveLabel!
    @IBOutlet var lbl_totalAnswer : UILabel!
    @IBOutlet var btn_diccription : UIButton!
    
    @IBOutlet weak var img_featured: UIImageView!
    @IBOutlet weak var img_userAnswerd: UIImageView!
    
    
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var imageButton2: UIButton!
    
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var videoIcon3: UIImageView!
    @IBOutlet weak var attachmentImage3: RoundImageView!
    @IBOutlet weak var videoIcon2: UIImageView!
    @IBOutlet weak var attachmentImage2: RoundImageView!
    @IBOutlet weak var videoIcon1: UIImageView!
    @IBOutlet weak var attachmentImage1: RoundImageView!
}

class QAFilterCell: UITableViewCell {
    
    @IBOutlet weak var Img_clear_search: UIImageView!
    @IBOutlet weak var Btn_Clear_Selection: UIButton!
    @IBOutlet var imageView_Main : UIImageView!
    @IBOutlet var view_BG : UIView!
    @IBOutlet var view_BGColor : UIView!
    @IBOutlet var btn_Report : UIButton!
    @IBOutlet var lbl_Main : UILabel!
}


class QAReasonCell: UITableViewCell {
    
    @IBOutlet weak var selected_line: UIView!
    @IBOutlet var imageView_Main : UIImageView!
    @IBOutlet var view_BG : UIView!
    @IBOutlet var lbl_Main : UILabel!
}


class QASendButtonCell: UITableViewCell {
    
    @IBOutlet var btn_Send : UIButton!
}

class QAHeadingcell: UITableViewCell {
    
}
