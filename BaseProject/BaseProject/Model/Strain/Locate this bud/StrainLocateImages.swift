//
//  Strain.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainLocateImages: Mappable {
    
    
    var id:NSNumber?
    var product_id:NSNumber?
    var user_id:NSNumber?

    var image: String?
    var created_at : String?
    var updated_at : String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        id <- map["id"]
        
        user_id <- map["user_id"]
        product_id <- map["product_id"]
        image <- map["image"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
    }
    
}
