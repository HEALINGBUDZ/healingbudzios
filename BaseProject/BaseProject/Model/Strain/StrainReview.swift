//
//  Strain.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainReview: Mappable {

    var attachment : AttachmentMapper?
    var created_at: String?
    var get_user : UserMapper?
    var id:NSNumber?
    var is_user_flaged_count:Int?
    var rating:NSNumber?
    var review:String?
    var reviewed_by:NSNumber?
    var strain_id: NSNumber?
    var updated_at: NSNumber?
    var is_reviewed_count: String?
    var likes_count: Int?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        
        
        attachment <- map["attachment"]
        created_at <- map["created_at"]
        is_reviewed_count <- map["is_reviewed_count"]
        get_user <- map["get_user"]
        likes_count <- map["likes_count"]
        id <- map["id"]
        is_user_flaged_count <- map["is_user_flaged_count"]
        if(is_user_flaged_count == nil){
            if let varr = map["is_user_flaged_count"].currentValue as? String {
                is_user_flaged_count = Int(varr)
            }else  if let varr = map["is_user_flaged_count"].currentValue as? Int {
                is_user_flaged_count = varr
            }else {
                is_user_flaged_count = 0
            }
        }
        var rating_ob  = [String : Any]()
        rating_ob <- map["rating"]
        rating = rating_ob["rating"] as? NSNumber ?? 5
        print(rating_ob["rating"] as? Int ?? 1)
        review <- map["review"]
        
        if (review != nil) {
            if review!.characters.count > 0 {
                review = review?.RemoveBRTag()
                review = review?.RemoveHTMLTag()
            }
        }
        
        
        reviewed_by <- map["reviewed_by"]
        strain_id <- map["strain_id"]
        updated_at <- map["updated_at"]
    }
    
}
