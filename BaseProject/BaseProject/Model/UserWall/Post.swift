//
//  Post.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 15/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

enum PostType {
    case text
    case media
}

class Post: NSObject, NSCoding, Mappable {
    var id:NSNumber?
    var user_id:NSNumber?
    var sub_user_id:NSNumber?
    var discription:String?
    var repostDiscp:String?
    var json_data:String?
    var allow_repost:NSNumber?
    var shared_id:NSNumber?
    var shared_user_id:NSNumber?
    var original_name:String?
    var created_at:String?
    var updated_at:String?
    var liked_count:NSNumber?
    var likes_count:NSNumber?
    var shared_count:NSNumber?
    var flaged_count:NSNumber?
    var comments_count:NSNumber?
    var mute_post_by_user_count:NSNumber?
    var scraped_url:String?
    var shared_post:Post?
    var user:PostUser?
    var sub_user:BudzMap?
    var shared_user:PostUser?
    var files:[PostFile]?
    var tagged:[Tagged]?
    var likes:[PostLike]?
    var flags:[PostLike]?
    var comments:[PostComment]?
    var commeentsLoaded = false
    var imageU: String?
    var newAttachment: Attachment?
    var scrapedData: ScrapedPost?
    var scrapind_data : [String : Any]?
    var isLiked: Bool {
        if liked_count?.intValue == 1   {
            return true
        }
        return false
    }
    
    
    var postType = PostType.text
    func checkPostType()    {
        if let f = files, f.count > 0   {
            postType = .media
        }
    }
    
    var isReposted: Bool    {
        if shared_post != nil && shared_user != nil {
            return true
        }
        return false
    }
    
    var isPostedAs: Bool    {
        if sub_user != nil {
            return true
        }
        return false
    }
    
    required init?(map: Map){
        
    }
    
    override init() {
    }
    
    func mapping(map: Map){
        id <- map["id"]
        user_id <- map["user_id"]
        sub_user_id <- map["sub_user_id"]
        discription <- map["description"]
        repostDiscp <- map["post_added_comment"]
        discription = self.discription?.RemoveHTMLTag()
        json_data <- map["json_data"]
        allow_repost <- map["allow_repost"]
        shared_id <- map["shared_id"]
        shared_user_id <- map["shared_user_id"]
        original_name <- map["original_name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        liked_count <- map["liked_count"]
        likes_count <- map["likes_count"]
        shared_count <- map["shared_count"]
        flaged_count <- map["flaged_count"]
        comments_count <- map["comments_count"]
        mute_post_by_user_count <- map["mute_post_by_user_count"]
        user <- map["user"]
        shared_post <- map["shared_post"]
        shared_user <- map["shared_user"]
        scraped_url <- map["scraped_url"]
        tagged <- map["tagged"]
        likes <- map["likes"]
        files <- map["files"]
        flags <- map["flags"]
        scrapedData <- map["scraped_url"]
        scrapind_data <- map["scraped_url"]
        comments <- map["comments"]
        comments = comments?.sorted(by: {$0.dates.compare($1.dates) == .orderedDescending})
//        comments = comments?.reversed()
        
        if let subUserJson = map.JSON["sub_user"] as? [String: AnyObject]   {
            sub_user = BudzMap(json: subUserJson)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(sub_user_id, forKey: "sub_user_id")
        aCoder.encode(discription, forKey: "description")
        aCoder.encode(repostDiscp, forKey: "post_added_comment")
        aCoder.encode(json_data, forKey: "json_data")
        aCoder.encode(allow_repost, forKey: "allow_repost")
        aCoder.encode(shared_id, forKey: "shared_id")
        aCoder.encode(shared_user_id, forKey: "shared_user_id")
        aCoder.encode(original_name, forKey: "original_name")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(liked_count, forKey: "liked_count")
        aCoder.encode(likes_count, forKey: "likes_count")
        aCoder.encode(shared_count, forKey: "shared_count")
        aCoder.encode(flaged_count, forKey: "flaged_count")
        aCoder.encode(comments_count, forKey: "comments_count")
        aCoder.encode(mute_post_by_user_count, forKey: "mute_post_by_user_count")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(shared_post, forKey: "shared_post")
        aCoder.encode(shared_user, forKey: "shared_user")
        aCoder.encode(scraped_url, forKey: "scraped_url")
        aCoder.encode(tagged, forKey: "tagged")
        aCoder.encode(likes, forKey: "likes")
        aCoder.encode(files, forKey: "files")
        aCoder.encode(flags, forKey: "flags")
        aCoder.encode(comments, forKey: "comments")
        aCoder.encode(sub_user , forKey: "sub_user")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? NSNumber ?? 0
         self.user_id = aDecoder.decodeObject(forKey:"user_id") as? NSNumber  ?? 0
         self.sub_user_id = aDecoder.decodeObject(forKey:"sub_user_id") as? NSNumber  ?? 0
         self.discription = aDecoder.decodeObject(forKey:"description") as? String  ?? kEmptyString
         self.repostDiscp = aDecoder.decodeObject(forKey:"repostDiscp") as? String  ?? kEmptyString
         self.json_data = aDecoder.decodeObject(forKey:"json_data") as? String  ?? kEmptyString
         self.allow_repost = aDecoder.decodeObject(forKey:"allow_repost") as? NSNumber  ?? 0
         self.shared_id = aDecoder.decodeObject(forKey:"shared_id") as? NSNumber  ?? 0
         self.shared_user_id = aDecoder.decodeObject(forKey:"shared_user_id") as? NSNumber  ?? 0
         self.original_name = aDecoder.decodeObject(forKey:"original_name") as? String  ?? kEmptyString
         self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String  ?? kEmptyString
         self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String  ?? kEmptyString
        
         self.liked_count = aDecoder.decodeObject(forKey:"liked_count") as? NSNumber  ?? 0
         self.likes_count = aDecoder.decodeObject(forKey:"likes_count") as? NSNumber  ?? 0
         self.shared_count = aDecoder.decodeObject(forKey:"shared_count") as? NSNumber  ?? 0
         self.flaged_count = aDecoder.decodeObject(forKey:"flaged_count") as? NSNumber  ?? 0
         self.comments_count = aDecoder.decodeObject(forKey:"comments_count") as? NSNumber  ?? 0
         self.mute_post_by_user_count = aDecoder.decodeObject(forKey:"mute_post_by_user_count") as? NSNumber  ?? 0
         self.scraped_url = aDecoder.decodeObject(forKey:"scraped_url") as? String  ?? kEmptyString
         self.shared_post = aDecoder.decodeObject(forKey:"shared_post") as? Post  ?? Post()
         self.user = aDecoder.decodeObject(forKey:"user") as? PostUser ?? PostUser()
         self.sub_user = aDecoder.decodeObject(forKey:"sub_user") as? BudzMap ?? BudzMap()
         self.shared_user = aDecoder.decodeObject(forKey:"shared_user") as? PostUser ?? PostUser()
         self.files = aDecoder.decodeObject(forKey:"files") as? [PostFile] ?? [PostFile]()
         self.tagged = aDecoder.decodeObject(forKey:"tagged") as? [Tagged] ?? [Tagged]()
         self.likes = aDecoder.decodeObject(forKey:"likes") as? [PostLike] ?? [PostLike]()
         self.flags = aDecoder.decodeObject(forKey:"flags") as? [PostLike] ?? [PostLike]()
         self.comments = aDecoder.decodeObject(forKey:"comments") as? [PostComment]  ?? [PostComment]()
         self.commeentsLoaded = aDecoder.decodeObject(forKey:"commeentsLoaded") as? Bool ?? false
        
    }
      
}
