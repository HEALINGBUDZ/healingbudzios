//
//  Message.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
let KMSG_id                  = "id"
let KMSG_sender_id           = "sender_id"
let KMSG_receiver_id           = "receiver_id"
let KMSG_last_message_id           = "last_message_id"
let KMSG_sender_deleted           = "sender_deleted"
let KMSG_receiver_deleted           = "receiver_deleted"
let KMSG_created_at          = "created_at"
let KMSG_updated_at           = "updated_at"
let KMSG_messages_count           = "messages_count"
let KMSG_sender_first_name           = "first_name"
let KMSG_sender_image_path          = "image_path"
let KMSG_sender_avatar          = "avatar"
let KMSG_receiver_avatar           = "avatar"
let KMSG_receiver_image_path          = "image_path"
let KMSG_receiver_first_name           = "first_name"
class Message: NSObject {
    var id  = kEmptyInt
    var sender_id  = kEmptyInt
    var sender_points  = kEmptyInt
    var receiver_id  = kEmptyInt
    var receiver_points  = kEmptyInt
    var last_message_id  = kEmptyInt
    var sender_deleted  = kEmptyInt
    var receiver_deleted  = kEmptyInt
 
    var created_at   = kEmptyString
    var updated_at   = kEmptyString
    var messages_count  = kEmptyInt
    var sender_first_name   = kEmptyString
    var sender_image_path   = kEmptyString
    var sender_special_icon = kEmptyString
    var sender_avatar   = kEmptyString
    var receiver_avatar   = kEmptyString
    var receiver_image_path   = kEmptyString
    var receiver_first_name   = kEmptyString
    var receiver_special_icon = kEmptyString
    var is_saved_count = kEmptyString
    var sender_is_online_count = kEmptyInt
    var receiver_is_online_count = kEmptyInt
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
        self.id =  json?[KMSG_id] as? Int ?? 0
        
       
        if let data = json?["sender"] as? [String : Any] {
            self.sender_id = data[kID] as? Int ?? 0
            self.sender_points = data[kpoints] as? Int ?? 0
            self.sender_first_name =  data[KMSG_sender_first_name] as? String ?? kEmptyString
            self.sender_image_path = data[KMSG_sender_image_path] as? String ?? kEmptyString
            self.sender_avatar =  data[KMSG_sender_avatar] as? String ?? kEmptyString
            self.sender_is_online_count = data["is_online_count"] as? Int ?? 0
            if self.sender_is_online_count == 0 {
                self.sender_is_online_count = Int(data["is_online_count"] as? String ?? "0")!
            }
            self.sender_special_icon = data["special_icon"] as? String ?? kEmptyString
        }
     
        
        if self.sender_image_path.characters.count == 0 {
           self.sender_image_path = self.sender_avatar
        }
        if let vari = json?["is_saved_count"] as? Int {
            self.is_saved_count = String(vari)
        }else if let vari = json?["is_saved_count"] as? String {
            self.is_saved_count = vari
        }else {
            self.is_saved_count = "0"
        }
        
        if let receiver  =  json?["receiver"] as? [String : Any] {
            self.receiver_id =  receiver[kID]  as? Int ?? 0
            self.receiver_is_online_count = receiver["is_online_count"] as? Int ?? 0
            if self.receiver_is_online_count == 0 {
                self.receiver_is_online_count = Int(receiver["is_online_count"] as? String ?? "0")!
            }
            self.receiver_avatar =  receiver[KMSG_receiver_avatar] as? String ?? kEmptyString
            self.receiver_image_path =  receiver[KMSG_receiver_image_path] as? String ?? kEmptyString
            self.receiver_first_name =  receiver[KMSG_receiver_first_name] as? String ?? kEmptyString
            self.receiver_points =   receiver[kpoints] as? Int ?? 0
            self.receiver_special_icon =  receiver["special_icon"] as? String ?? kEmptyString
        }
        if self.receiver_image_path.characters.count == 0 {
            self.receiver_image_path = self.receiver_avatar
        }
        
         self.last_message_id =  json?[KMSG_last_message_id] as? Int ?? 0
         self.sender_deleted =  json?[KMSG_sender_deleted] as? Int ?? 0
         self.receiver_deleted =  json?[KMSG_receiver_deleted] as? Int ?? 0
        self.messages_count =  json?[KMSG_messages_count] as? Int ?? 0
        
        self.created_at =  json?[KMSG_created_at] as? String ?? kEmptyString
        self.updated_at =  json?[KMSG_updated_at] as? String ?? kEmptyString
        
        print(updated_at)
        print("123123123")
        print(messages_count)
        print(last_message_id)
        print(sender_deleted)
        print(receiver_deleted)
        print(receiver_points)
        print(sender_avatar)
        print(sender_image_path)
        print(sender_first_name)
        print(sender_id)
        print(sender_points)
        print(sender_avatar)
        print(id)
    }
}
