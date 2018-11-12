//
//  Reviews.swift
//  BaseProject
//
//  Created by MAC MINI on 30/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

let kattachments                = "attachments"
let kattachment                = "attachment"

class Reviews: NSObject {
    var  id = kEmptyInt
    var sub_user_id = kEmptyInt
    var  reviewed_by = kEmptyInt
    var  text = kEmptyString
    var rating = 1.0
    var created_at = kEmptyString
    var updated_at = kEmptyString
    var userMain = User()
    var attachments = [Attachment]()
    var is_reviewed_count = kEmptyString
    var isFlag = kEmptyInt
    var reply: Reply!
    var likes_count: Int!
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?["id"] as? Int ?? kEmptyInt
        self.likes_count =  json?["likes_count"] as? Int ?? kEmptyInt
        self.sub_user_id =  json?["sub_user_id"] as? Int ?? kEmptyInt
        self.reviewed_by =  json?["reviewed_by"] as? Int ?? kEmptyInt
        self.text =  json?["text"] as? String ?? kEmptyString
        self.is_reviewed_count = json?["is_reviewed_count"] as? String ?? kEmptyString
        self.rating =  json?["rating"] as? Double ?? 1.0
        if  ((json?["is_flaged"] as? [String : Any]) != nil){
             self.isFlag =   1
        }else{
             self.isFlag =   0
        }
        self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
        if let getreply = (json?["reply"] as? [String: Any]){
           self.reply =  Reply(JSON: getreply)
        }
        
         self.text = self.text.RemoveHTMLTag()
         self.text = self.text.RemoveBRTag()
        
        self.userMain =  User.init(json: json?["user"] as? [String : AnyObject])
        
        if let arrayAttachment = json?[kattachments] as? [[String : AnyObject]] {
            for indexObj in arrayAttachment{
                self.attachments.append(Attachment.init(json: indexObj))
            }
        }
    }
}
