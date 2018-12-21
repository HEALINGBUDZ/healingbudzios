//
//  PayBudzModel.swift
//  BaseProject
//
//  Created by lucky on 11/27/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class PayBudzModel: NSObject {
    var email:String = ""
    var cvc:String = ""
    var date:String = ""
    var card:String = ""
    required init(em:String,cardNum:String,dateCard:String,cvcCard:String) {
        self.email = em
        self.card = cardNum
        self.date = dateCard
        self.cvc = cvcCard
    }
}
