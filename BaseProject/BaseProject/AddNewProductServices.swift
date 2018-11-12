//
//  AddNewProductServices.swift
//  BaseProject
//
//  Created by Jawad on 10/4/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AddNewProductServices: UITableViewCell {
    var productHandler:ProductHandler?
    var servicesHandler:ProductHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickAddServices(_ sender: Any) {
        if self.servicesHandler != nil {
            self.servicesHandler!()
        }
    }
    @IBAction func onClickAddProduct(_ sender: Any) {
        if self.productHandler != nil {
            self.productHandler!()
        }
    }
}
