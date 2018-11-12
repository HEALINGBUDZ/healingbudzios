//
//  Tagged.swift
//  BaseProject
//
//  Created by MN on 20/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class Tagged: NSObject, Mappable, NSCoding {
    

    var user: PostUser!
    
    required init?(map: Map){
        
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user, forKey: "user")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.user = aDecoder.decodeObject(forKey:"user") as? PostUser ?? PostUser()
    }
    
    func mapping(map: Map) {
        self.user<-map["user"]
    }
}
