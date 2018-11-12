//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit

let kfrom_time                = "from_time"
let kto_time                = "to_time"
let ksub_user_id                = "sub_user_id"
let kdate                = "date"




class BudzEventTime: NSObject {
    
    var eventID = kEmptyString
    var dateMain = kEmptyString
    var fromTime = kEmptyString
    var toTime = kEmptyString
    var subUSerID = kEmptyString
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.eventID                       = String(json?[kID] as? Int ?? 0)
        self.subUSerID                       = String(json?[ksub_user_id] as? Int ?? 0)
        self.dateMain                       = json?[kdate] as? String ?? kEmptyString
        self.fromTime                       = json?[kfrom_time] as? String ?? kEmptyString
        self.toTime                       = json?[kto_time] as? String ?? kEmptyString
	}
}
