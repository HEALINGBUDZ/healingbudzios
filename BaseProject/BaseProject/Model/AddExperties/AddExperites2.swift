//
//  AddExperites2.swift
//  BaseProject
//
//  Created by MN on 06/09/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AddExperites2: NSObject {
    var created_at = kEmptyString
    var id = kEmptyInt
    var title = kEmptyString
    var updated_at = kEmptyString
    var warnpopup = 0
    var suggestion = false
    var approved = 2
    var overView = kEmptyString
    var typeId = kEmptyInt
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.created_at                       = json?[kcreated_at] as? String ?? kEmptyString
        self.id                           = json?[kID] as? Int ?? 0
        self.title                     = json?["title"] as? String ?? kEmptyString
        self.updated_at                     = json?[kupdated_at] as? String ?? kEmptyString
        self.approved                = json?["approved"] as? Int ?? kEmptyInt
        self.overView                = json?["overview"] as? String ?? kEmptyString
        self.typeId                = json?["type_id"] as? Int ?? 2
        
    }
}
