//
//  Timing.swift
//  BaseProject
//
//  Created by MAC MINI on 30/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class Timing: NSObject {
    var id = kEmptyInt
    var sub_user_id = kEmptyInt
    var monday = kEmptyString
    var tuesday  = kEmptyString
    var wednesday = kEmptyString
    var thursday = kEmptyString
    var friday = kEmptyString
    var saturday = kEmptyString
    var sunday = kEmptyString
    var mon_end = kEmptyString
    var tue_end = kEmptyString
    var wed_end = kEmptyString
    var thu_end = kEmptyString
    var fri_end = kEmptyString
    var sat_end = kEmptyString
    var sun_end = kEmptyString
    var created_at = kEmptyString
    var updated_at = kEmptyString
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?["id"] as? Int ?? kEmptyInt
         self.sub_user_id =  json?["sub_user_id"] as? Int ?? kEmptyInt
          self.monday =  json?["monday"] as? String ?? kEmptyString
         self.monday =  json?["monday"] as? String ?? kEmptyString
         self.tuesday =  json?["tuesday"] as? String ?? kEmptyString
         self.wednesday =  json?["wednesday"] as? String ?? kEmptyString
         self.thursday =  json?["thursday"] as? String ?? kEmptyString
         self.friday =  json?["friday"] as? String ?? kEmptyString
        self.sunday =  json?["sunday"] as? String ?? kEmptyString
         self.saturday =  json?["saturday"] as? String ?? kEmptyString
         self.mon_end =  json?["mon_end"] as? String ?? kEmptyString
         self.tue_end =  json?["tue_end"] as? String ?? kEmptyString
         self.tue_end =  json?["tue_end"] as? String ?? kEmptyString
         self.wed_end =  json?["wed_end"] as? String ?? kEmptyString
         self.thu_end =  json?["thu_end"] as? String ?? kEmptyString
         self.fri_end =  json?["fri_end"] as? String ?? kEmptyString
         self.sat_end =  json?["sat_end"] as? String ?? kEmptyString
         self.sun_end =  json?["sun_end"] as? String ?? kEmptyString
         self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
    }
}
