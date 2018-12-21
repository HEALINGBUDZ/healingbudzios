//
//  Strain.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class AttachmentMapper: Mappable {

    var attachment: String?
    var created_at : String?
    var poster : String?
    var id:NSNumber?
    var strain_id:NSNumber?
    var strain_review_id:NSNumber?
    var type:String?
    var updated_at:String?
    var user_id:NSNumber?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        attachment <- map["attachment"]
        created_at <- map["created_at"]
        id <- map["id"]
        poster <- map["poster"]
        strain_id <- map["strain_id"]
        strain_review_id <- map["strain_review_id"]
        type <- map["type"]
        updated_at <- map["updated_at"]
        user_id <- map["user_id"]
        
    }
    
}
