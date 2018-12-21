//
//  PostFile.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostFile: NSObject, NSCoding, Mappable {

    var id:NSNumber?
    var post_id:NSNumber?
    var original_name:String?
    var file:String?
    var poster:String?
    var thumnail:String?
    var type:String?
    var created_at:String?
    var updated_at:String?
    var image_ratio:Double = 1.0
    var image_ratio_str:String?
    required init?(map: Map){
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(post_id, forKey: "post_id")
        aCoder.encode(original_name, forKey: "original_name")
        aCoder.encode(file, forKey: "file")
        aCoder.encode(poster, forKey: "poster")
        aCoder.encode(thumnail, forKey: "thumnail")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(image_ratio, forKey: "image_ratio")
    }
    override init() {
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? NSNumber ?? 0
        self.post_id = aDecoder.decodeObject(forKey:"post_id") as? NSNumber ?? 0
        self.original_name = aDecoder.decodeObject(forKey:"original_name") as? String ?? ""
        self.file = aDecoder.decodeObject(forKey:"file") as? String ?? ""
        self.poster = aDecoder.decodeObject(forKey:"poster") as? String ?? ""
        self.thumnail = aDecoder.decodeObject(forKey:"thumnail") as? String ?? ""
        self.type = aDecoder.decodeObject(forKey:"type") as? String ?? ""
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? ""
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? ""
        self.image_ratio = aDecoder.decodeObject(forKey:"image_ratio") as? Double ?? 1.0
    }
    
    func mapping(map: Map){
        id <- map["id"]
        post_id <- map["post_id"]
        original_name <- map["original_name"]
        file <- map["file"]
        poster <- map["poster"]
        thumnail <- map["thumnail"]
        type <- map["type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        image_ratio <- map["ratio"]
        print(image_ratio)
        image_ratio_str <- map["ratio"]
        print(image_ratio_str)
        if image_ratio == 1.0 {
            if image_ratio_str != nil && image_ratio_str!.count > 3{
                if let ratio =  Double(image_ratio_str!) {
                     self.image_ratio = ratio
                }else{
                   self.image_ratio = 1.0
                }
            }
        }
         print(image_ratio)
    }
}



