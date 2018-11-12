//
//  Images.swift
//  BaseProject
//
//  Created by MAC MINI on 30/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class Images: NSObject {
    var id = kEmptyInt
    var strain_id = kEmptyInt
    var user_id = kEmptyInt
    var image_path = kEmptyString
    var is_approved = kEmptyInt
    var is_main = kEmptyInt
    var Name  = kEmptyString
    var created_at  = kEmptyString
    var updated_at  = kEmptyString
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?[kID] as? Int ?? kEmptyInt
        self.strain_id =  json?["strain_id"] as? Int ?? kEmptyInt
        self.user_id =  json?[kuser_id] as? Int ?? kEmptyInt
        self.image_path =  json?["image"] as? String ?? kEmptyString
        self.is_approved =  json?["is_approved"] as? Int ?? kEmptyInt
        self.is_main =  json?["is_main"] as? Int ?? kEmptyInt
        self.Name =  json?["Name"] as? String ?? kEmptyString
        self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
    }
}
