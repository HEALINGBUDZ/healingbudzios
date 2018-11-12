//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit

//{
//    "created_at" = "2018-03-23 16:24:24";
//    description = " test1 <span style=\"display:none\">171_152</span>";
//    id = 4437;
//    "is_read" = 1;
//    model = Question;
//    "notification_text" = "joy added a new question.";
//    "on_user" = 152;
//    text = "joy added a new question.";
//    type = Questions;
//    "type_id" = 171;
//    "type_sub_id" = 0;
//    "updated_at" = "2018-03-26 11:03:59";
//    "user_id" = 99;
//}

class BuzzFeedModel: NSObject {
    
    var created_at = kEmptyString
    var descriptionBuzzfeed = kEmptyString
    var ID = kEmptyInt
    var is_read = kEmptyInt
    var model = kEmptyString
    var notification_text = kEmptyString
    var on_user = kEmptyInt
    var text = kEmptyString
    var type = kEmptyString
   var type_id = kEmptyInt
   var type_sub_id = kEmptyInt
    var updated_at = kEmptyString
   var user_id = kEmptyInt
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        self.created_at                       = json?[kcreated_at] as? String ?? kEmptyString
        self.descriptionBuzzfeed                     = json?["description"] as? String ?? kEmptyString
        self.descriptionBuzzfeed = self.descriptionBuzzfeed.RemoveHTMLTag()
        self.descriptionBuzzfeed = self.descriptionBuzzfeed.RemoveBRTag()
        self.ID            = json?[kID] as? Int ?? 0
        self.is_read                           = json?["is_read"] as? Int ?? 0
        self.model                     = json?["model"] as? String ?? kEmptyString
        self.notification_text                     = json?["notification_text"] as? String ?? kEmptyString
        self.on_user            = json?["on_user"] as? Int ?? 0
        self.text                     = json?["text"] as? String ?? kEmptyString
        self.type                     = json?["type"] as? String ?? kEmptyString
        self.type_id            = json?["type_id"] as? Int ?? 0
        self.type_sub_id            = json?["type_sub_id"] as? Int ?? 0
        self.updated_at                     = json?["updated_at"] as? String ?? kEmptyString
        self.user_id            = json?["user_id"] as? Int ?? 0
        
	}
}
