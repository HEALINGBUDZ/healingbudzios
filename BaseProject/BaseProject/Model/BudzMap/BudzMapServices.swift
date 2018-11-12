//
//  BudzMapServices.swift
//  BaseProject
//
//  Created by waseem on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation

class BudzMapServices: NSObject {
    var  id = kEmptyInt
    var  charges = kEmptyString
    var created_at = kEmptyString
    var updated_at = kEmptyString
    var sub_user_id = kEmptyInt
    var image = kEmptyString
    var name = kEmptyString
    
 
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?["id"] as? Int ?? kEmptyInt
        if let ch = json?["charges"] as? Double {
             self.charges =  String (ch).FloatValue()
        }else if let ch = json?["charges"] as? Int {
            self.charges =  String(ch).FloatValue()
        }else {
             self.charges =  String(json?["charges"] as? String ?? "0").FloatValue()
        }
       
        self.sub_user_id =  json?["sub_user_id"] as? Int ?? kEmptyInt
        self.image =  json?["image"] as? String ?? kEmptyString
        self.name =  json?["name"] as? String ?? kEmptyString
        self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
        
    }
}
