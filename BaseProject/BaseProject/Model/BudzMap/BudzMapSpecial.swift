//
//  BudzMapSpecial.swift
//  BaseProject
//
//  Created by waseem on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation


class BudzMapSpecial: NSObject {
    var  id = kEmptyInt
    var created_at = kEmptyString
    var updated_at = kEmptyString
    var image = kEmptyString
    var  lat = kEmptyDouble
    var  lng = kEmptyDouble
    var message = kEmptyString
    var public_location = kEmptyString
    var sub_user_id = kEmptyInt
    var title = kEmptyString
    var  user_id = kEmptyInt
    var validity_date = kEmptyString
    var name = kEmptyString
    var isSaved = false
    
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?["id"] as? Int ?? kEmptyInt
        self.lat =  json?["lat"] as? Double ?? kEmptyDouble
        self.lng =  json?["lng"] as? Double ?? kEmptyDouble
        self.user_id =  json?["user_id"] as? Int ?? kEmptyInt
        self.sub_user_id =  json?["sub_user_id"] as? Int ?? kEmptyInt
        self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
        self.image =  json?["image"] as? String ?? kEmptyString
        self.name =  json?["name"] as? String ?? kEmptyString
        self.validity_date =  json?["validity_date"] as? String ?? kEmptyString
        self.title =  json?["title"] as? String ?? kEmptyString
        self.public_location =  json?["public_location"] as? String ?? kEmptyString
        self.message =  json?["message"] as? String ?? kEmptyString
        if let array =  json?["user_like_count"] as? [[String : Any]]{
            if array.count > 0 {
                 self.isSaved = true
            }else{
                 self.isSaved = false
            }
           
        }else{
            self.isSaved = false
        }
    }
}

