//
//  BudzReview.swift
//  BaseProject
//
//  Created by MN on 03/05/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class BudzReview: Mappable {
    
    var id: Int?
    var sub_user_id: Int?
    var reviewed_by: Int?
    var text: String?
    var rating: Float?
    var bud: BudzMap?
    var attached: Attachment?
    var created_at: String?
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        
        self.created_at<-map["created_at"]
        self.id<-map["id"]
        self.sub_user_id<-map["sub_user_id"]
        self.reviewed_by<-map["reviewed_by"]
        self.text<-map["text"]
        self.rating<-map["rating"]
    }
    
}
