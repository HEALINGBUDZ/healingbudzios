//
//  ReceiverMediaMsgTVCell.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import FLAnimatedImage
class ReceiverMediaMsgTVCell: UITableViewCell {

    @IBOutlet weak var view_Scrapping: UIView!
    @IBOutlet weak var rece_name: UILabel!
    @IBOutlet weak var lbl_scrapping_source: UILabel!
    @IBOutlet weak var lbl_scrapping_discription: UILabel!
    @IBOutlet weak var lbl_scrapping: UILabel!
    @IBOutlet weak var Img_scrapping: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet var MSG_TEXT: ActiveLabel!
    @IBOutlet weak var MSG_IMG: FLAnimatedImageView!
    @IBOutlet weak var Video_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        MSG_TEXT.URLColor = UIColor(hex: "63A1C8")
        MSG_TEXT.handleURLTap({ url in
            var urlToCall = url
            if !url.absoluteString.hasPrefix("http"){
                urlToCall = URL(string: "http://" + url.absoluteString)!
            }
            if (urlToCall.absoluteString.contains("youtube.com")) || (urlToCall.absoluteString.contains("youtu.be")) {
                AppDelegate.appDelegate().active_navigation_controller?.present(YoutubePlayerVC.PlayerVC(url: urlToCall), animated: true, completion: nil)
            }else{
                UIApplication.shared.open(urlToCall)
            }
        })  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
