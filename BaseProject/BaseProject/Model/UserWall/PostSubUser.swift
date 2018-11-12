//
//  PostSubUser.swift
//  BaseProject
//
//  Created by MN on 06/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostSubUser: NSObject, Mappable {
    var id:NSNumber?
    var title:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id<-map["id"]
        title<-map["title"]
    }
    
}
