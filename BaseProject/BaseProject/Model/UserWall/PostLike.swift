//
//  PostLike.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostLike: NSObject, NSCoding, Mappable {

    var id:NSNumber?
    var user_id:NSNumber?
    var post_id:NSNumber?
    var is_like:NSNumber?
    var created_at:String?
    var updated_at:String?
    var reason:String?
    var user: PostUser?
    
    required init?(map: Map){
        
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(post_id, forKey: "post_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(is_like, forKey: "is_like")
        aCoder.encode(reason, forKey: "reason")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(user, forKey: "user")
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? NSNumber ?? 0
        self.post_id = aDecoder.decodeObject(forKey:"post_id") as? NSNumber ?? 0
        self.user_id = aDecoder.decodeObject(forKey:"user_id") as? NSNumber ?? 0
        self.is_like = aDecoder.decodeObject(forKey:"is_like") as? NSNumber ?? 0
        self.reason = aDecoder.decodeObject(forKey:"reason") as? String ?? ""
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? ""
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? ""
        self.user = aDecoder.decodeObject(forKey:"user") as? PostUser ?? PostUser()
    }
    
    
    func mapping(map: Map){
        
        id <- map["id"]
        user_id <- map["user_id"]
        post_id <- map["post_id"]
        is_like <- map["is_like"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        reason <- map["reason"]
        user <- map["user"]
    }
}

