//
//  EventPurchaseTicketCell.swift
//  BaseProject
//
//  Created by Jawad on 8/16/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EventPurchaseTicketCell: UITableViewCell {
        var purchase:ProductHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickPurchase(_ sender: Any) {
        if self.purchase != nil {
            self.purchase!()
        }
    }
    
}
