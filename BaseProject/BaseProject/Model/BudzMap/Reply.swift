//
//  Reply.swift
//  BaseProject
//
//  Created by MN on 23/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class Reply: Mappable {
    var id: NSNumber!
    var businessReviewId: NSNumber!
    var userId: NSNumber!
    var reply: String!
    var created_at: String!
    var updated_at: String!
    
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        id<-map["id"]
        businessReviewId<-map["business_review_id"]
        userId<-map["user_id"]
        reply<-map["reply"]
        created_at<-map["created_at"]
        updated_at<-map["updated_at"]
    }
    

}
