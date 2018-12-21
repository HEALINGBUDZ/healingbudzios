//
//  ReceiverMsgTVCell.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class ReceiverMsgTVCell: UITableViewCell {
    @IBOutlet  var MSG_Text: ActiveLabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var rece_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MSG_Text.URLColor = UIColor(hex: "63A1C8")
        MSG_Text.handleURLTap({ url in
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

        // Configure the view for the selected state
    }
    
}
