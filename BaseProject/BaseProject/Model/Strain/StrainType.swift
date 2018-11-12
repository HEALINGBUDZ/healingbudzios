//
//  StrainType.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainType: Mappable {

    
    var typeID:NSNumber?
    var title:String?
    var created_at:String?
    var updated_at:String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
    
        typeID <- map["id"]
        title <- map["title"]
        created_at <- map["created_at"]
        updated_at <- map ["updated_at"]
    }
}
