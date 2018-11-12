//
//  Strain.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainLocatePrice: Mappable {
    
    
    var id:NSNumber? 
    var product_id:NSNumber?
    var weight:NSNumber?
    var price:NSNumber?
    
    var created_at : String?
    var updated_at : String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        id <- map["id"]
        
        product_id <- map["product_id"]
        weight <- map["weight"]
        price <- map["price"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
    }
    
}
