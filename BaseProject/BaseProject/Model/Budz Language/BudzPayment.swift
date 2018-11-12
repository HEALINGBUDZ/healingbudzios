//
//  BudzPayment.swift
//  BaseProject
//
//  Created by MAC MINI on 08/05/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation
import UIKit


class BudzPayment: NSObject {
    
    var payment_ID = kEmptyString
    var payment_title = kEmptyString
    var payment_image = kEmptyString
    var selected = 0
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        
        
            self.payment_ID                       = String(json?["id"] as? Int ?? 0)
            self.payment_title                       = json?["title"] as? String ?? kEmptyString
            self.payment_image                       = json?["image"] as? String ?? kEmptyString
        
        
    }
}
