//
//  PostTags.swift
//  BaseProject
//
//  Created by MN on 17/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostTags: Mappable {
    

    var id:NSNumber?
    var title:String?
    var isApproved:NSNumber?
    var price:NSNumber?
    var onSale:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id<-map["id"]
        title<-map["title"]
        isApproved<-map["is_approved"]
        price<-map["price"]
        onSale<-map["on_sale"]
    }
}
