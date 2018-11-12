//
//  PostComment.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 15/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostComment: NSObject, NSCoding, Mappable {

    var id:NSNumber?
    
    var user_id:NSNumber?
    var post_id:NSNumber?
    var comment:String?
    var json_data:String?
    var created_at:String?
    var updated_at:String?
    var user:PostUser?
    var attachment:PostFile?
    var likesCount: Int?
    var likedCount: Int?
    var likes: [PostLike]?
    var dates = Date()
    required init?(map: Map){
        
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(post_id, forKey: "post_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(comment, forKey: "is_like")
        aCoder.encode(json_data, forKey: "reason")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(likesCount, forKey: "likesCount")
        aCoder.encode(likedCount, forKey: "likesCount")
        aCoder.encode(likes, forKey: "likes")
        
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? NSNumber ?? 0
        self.post_id = aDecoder.decodeObject(forKey:"post_id") as? NSNumber ?? 0
        self.user_id = aDecoder.decodeObject(forKey:"user_id") as? NSNumber ?? 0
        self.comment = aDecoder.decodeObject(forKey:"is_like") as? String ?? ""
        self.json_data = aDecoder.decodeObject(forKey:"reason") as? String ?? ""
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? ""
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? ""
        self.user = aDecoder.decodeObject(forKey:"user") as? PostUser ?? PostUser()
        self.likesCount = aDecoder.decodeObject(forKey:"likesCount") as? Int ?? 0
        self.likedCount = aDecoder.decodeObject(forKey:"likedCount") as? Int ?? 0
        self.likes = aDecoder.decodeObject(forKey:"likes") as? [PostLike] ?? [PostLike]()
    }
    
    
    func mapping(map: Map){
    
        id <- map["id"]
        user_id <- map["user_id"]
        post_id <- map["post_id"]
        comment <- map["comment"]
        json_data <- map["json_data"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
        attachment <- map["attachment"]
        likesCount <- map["likes_count"]
        likedCount <- map["liked_count"]
        likes <- map["likes"]
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let d = dateFormatter.date(from: self.created_at!)
            self.dates = d!
        }
        
    }
}
