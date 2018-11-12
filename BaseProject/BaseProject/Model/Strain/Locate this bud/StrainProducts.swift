//
//  Strain.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainProducts: Mappable {
    
    
    var id:NSNumber?
    var sub_user_id:NSNumber?
    var strain_id:NSNumber?
    var type_id:NSNumber?
    var thc:NSNumber?
    var cbd:NSNumber?

    var name: String?
    var created_at : String?
    var updated_at : String?
    
    var strainImageArray : [StrainLocateImages]?
    var straintype : StrainType?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        id <- map["id"]
        
        sub_user_id <- map["sub_user_id"]
        strain_id <- map["strain_id"]
        
        type_id <- map["type_id"]
        thc <- map["thc"]
        cbd <- map["cbd"]
        name <- map["name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        strainImageArray <- map["images"]
        straintype <- map["strain_type"]
        
    }
    
}
