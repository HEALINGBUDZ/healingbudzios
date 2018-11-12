//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit


class ActivityLogModel: NSObject {
    
    var created_at = kEmptyString
    var Activitydescription = kEmptyString
    var id = kEmptyString
    var is_read = kEmptyString
    var model = kEmptyString
    var notification_text = kEmptyString
    var on_user = kEmptyString
    var type = kEmptyString
    var text = kEmptyString
    var type_id = kEmptyString
    var type_sub_id = kEmptyString
    var updated_at = kEmptyString
    var user_id = kEmptyString
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json ?? "")
        self.id                       = String(json?[kID] as? Int ?? 0)
        self.is_read                       = String(json?["is_read"] as? Int ?? 0)
        self.type                       = json?["type"] as? String ?? kEmptyString
        self.Activitydescription                       = json?["description"] as? String ?? kEmptyString
        self.Activitydescription = self.Activitydescription.RemoveHTMLTag()
        self.Activitydescription = self.Activitydescription.RemoveBRTag()
        self.created_at                       = json?[kcreated_at] as? String ?? kEmptyString
        self.model                       = json?["model"] as? String ?? kEmptyString
        self.notification_text                       = json?["notification_text"] as? String ?? kEmptyString
        self.text                       = json?["text"] as? String ?? kEmptyString
        self.updated_at                       = json?["updated_at"] as? String ?? kEmptyString
        self.on_user                       = String(json?["on_user"] as? Int ?? 0)
        self.type_id                       = String(json?["type_id"] as? Int ?? 0)
        if self.type_id == "0"{
            self.type_id = String(json?["type_id"] as? String ?? "0")
        }    
        self.type_sub_id                       = String(json?["type_sub_id"] as? Int ?? 0)
        self.user_id                       = String(json?["user_id"] as? Int ?? 0)
        
	}
}
