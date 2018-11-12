//
//  ScrapedPost.swift
//  BaseProject
//
//  Created by MN on 04/10/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class ScrapedPost: NSObject, Mappable {

    var id: Int?
    var postID: Int?
    var title: String?
    var content: String?
    var image: String?
    var source: String?
    
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        self.id <- map["id"]
        self.postID <- map["post_id"]
        self.title <- map["title"]
        self.content <- map["content"]
        self.source <- map["url"]
        self.image <- map["image"]
    }
}
