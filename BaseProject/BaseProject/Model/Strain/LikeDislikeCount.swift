//
//  LikeDislikeCount.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class LikeDislikeCount: Mappable {
    var id:NSNumber?
    var user_id:NSNumber?
    var image_id:String?
    var is_liked:NSNumber?
    var is_disliked:NSNumber?
    var created_at:String?
    var updated_at:String?
    required init?(map: Map){
    }
    func mapping(map: Map){
    
        id <- map["id"]
        user_id <- map["user_id"]
        image_id <- map["image_id"]
        is_liked <- map["is_liked"]
        is_disliked <- map["is_disliked"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}
