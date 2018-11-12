//
//  Strain.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class UserMapper: Mappable {

    var avatar: String?
    var special_icon: String?
    var image_path : String?
    var id:NSNumber?
    var points:NSNumber?
    var first_name:String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        avatar <- map["avatar"]
        image_path <- map["image_path"]
        special_icon <- map["special_icon"]
        
        if (image_path != nil) {
            if image_path!.characters.count > 0 {
                
            }else {
                image_path = avatar
            }
        }else {
            image_path = avatar
        }
        if (special_icon != nil) {
            if special_icon!.characters.count > 0 {
                
            }else {
                special_icon = ""
            }
        }else {
            special_icon = ""
        }
        
        
        id <- map["id"]
        points <- map["points"]
        first_name <- map["first_name"]
    }
    
}
