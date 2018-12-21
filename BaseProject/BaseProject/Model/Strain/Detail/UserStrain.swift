//
//  Strain.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class UserStrain: Mappable {
    
    var id:NSNumber?
    var strain_id:NSNumber?
    var user_id:NSNumber?
    var indica:NSNumber?
    var sativa:NSNumber?
    
    var plant_height:NSNumber?
    var flowering_time:NSNumber?
    var min_fahren_temp:NSNumber?
    var max_fahren_temp:NSNumber?
    var min_celsius_temp:NSNumber?
    var max_celsius_temp:NSNumber?
    var get_likes_count:NSNumber?
    var get_user_like_count:NSNumber?
    
    var genetics: String?
    var asd: String?
    var cross_breed : String?
    var growing : String?
    var yeild : String?
    var climate : String?
    var note : String?
    var description : String?
    var user : StrainUser?
    
    var minCBD: NSNumber?
    var maxCBD: NSNumber?
    var minTHC: NSNumber?
    var maxTHC: NSNumber?
    
    var updated_at : String?
    var created_at : String?
    var rating: StrainCommentRating?
    
    required init?(map: Map){
        
    }
    
    
    
    
    func mapping(map: Map){
        
        print(map.JSON)
        id <- map["id"]
        user_id <- map["user_id"]
        strain_id <- map["strain_id"]
        indica <- map["indica"]
        sativa <- map["sativa"]
        
        genetics <- map["genetics"]
        cross_breed <- map["cross_breed"]
        growing <- map["growing"]
        plant_height <- map["plant_height"]
        flowering_time <- map["flowering_time"]
        min_fahren_temp <- map["min_fahren_temp"]
        max_fahren_temp <- map["max_fahren_temp"]
        min_celsius_temp <- map["min_celsius_temp"]
        max_celsius_temp <- map["max_celsius_temp"]
        yeild <- map["yeild"]
        climate <- map["climate"]
        minCBD <- map["min_CBD"]
        maxCBD <- map["max_CBD"]
        minTHC <- map["min_THC"]
        maxTHC <- map["max_THC"]
        note <- map["note"]
        self.note = self.note?.RemoveHTMLTag()
        description <- map["description"]
        self.description = self.description?.RemoveHTMLTag()
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        get_likes_count <- map["get_likes_count"]
        get_user_like_count <- map["get_user_like_count"]
        min_fahren_temp <- map["min_fahren_temp"]
        user <- map["get_user"]
        rating <- map["rating"]
    }
}


class StrainCommentRating: Mappable {

    var created_at : String?
    var id:NSNumber?
    var rated_by:NSNumber?
    var rating:NSNumber?
    var strain_id:NSNumber?
    var strain_review_id:NSNumber?
    var updated_at: String?
   
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        print(map.JSON)
        created_at <- map["created_at"]
        id <- map["id"]
        rated_by <- map["rated_by"]
        rating <- map["rating"]
        strain_id <- map["strain_id"]
        
        strain_review_id <- map["strain_review_id"]
        updated_at <- map["updated_at"]
    }
}

