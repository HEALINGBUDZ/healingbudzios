//
//  SenderMsgTVCell.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import Foundation
import ActiveLabel
class SenderMsgTVCell: UITableViewCell {

    @IBOutlet weak var sender_name: UILabel!
    @IBOutlet var MSG_TEXT: ActiveLabel!
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

        // Configure the view for the selected state
    }
    
}
