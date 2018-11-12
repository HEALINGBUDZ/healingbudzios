//
//  StrainImage.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainImage: NSObject, Mappable {

    var id:NSNumber?
    var strain_id:NSNumber?
    var user_id:NSNumber?
    var image_path:String?
    var is_approved:NSNumber?
    var is_main:NSNumber?
    var created_at:String?
    var updated_at:String?
    var liked:NSNumber?
    var likeddata:[String : Any]?
    var disliked:NSNumber?
    var dislikeddata:[String : Any]?
    var flaggedObj: [String: Any]?
    var flagged = false
    var user:StrainUser?
    var like_count:[LikeDislikeCount]?
    var Image_like_count:String?
    var dis_like_count:[LikeDislikeCount]?
    var Image_Dilike_count:String?

    required init?(map: Map){
        
    }
    
    override init(){
        
    }
    
    func mapping(map: Map){
       
        
        id <- map["id"]
        strain_id <- map["strain_id"]
        user_id <- map["user_id"]
        is_approved <- map["is_approved"]
        image_path <- map["image_path"]
        is_main <- map["is_main"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        likeddata <- map["liked"]
        dislikeddata <- map["disliked"]
        
        if likeddata != nil {
            liked = 1
        }else {
            liked = 0
        }
       
        if dislikeddata != nil {
            disliked = 1
        }else {
            disliked = 0
        }
        
        flaggedObj <- map["flagged"]
        if flaggedObj != nil{
            flagged = true
        }else{
            flagged = false
        }
        user <- map["get_user"]
        like_count <- map["like_count"]
        dis_like_count <- map["dis_like_count"]
        if user_id == nil {
            user_id = -1
            user = StrainUser.init(map: map["get_user"])
            user?.first_name  = "Healing Budz"
            user?.points = 0
        }
        if like_count?.count != nil {
            Image_like_count = String(describing: like_count!.count)
            Image_Dilike_count = String(describing:dis_like_count!.count)
        }
        

        
    }
}
