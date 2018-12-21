//
//  StrainUser.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainUser: Mappable {

    
    var id:NSNumber?
    var first_name:String?
    var image_path:String?
    var special_icon:String?

    var avatar:String?
    var points:NSNumber?
        
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
    
        id <- map["id"]
        first_name <- map["first_name"]
        image_path <- map["image_path"]
        special_icon <- map["special_icon"]
        avatar <- map["avatar"]
        points <- map["points"]
        
        if self.image_path?.count == 0 {
            image_path = avatar
        }
        if special_icon != nil {
            if self.special_icon?.count == 0 {
                special_icon = ""
            }
        }else {
            special_icon = ""
        }
        
    }
    
}
