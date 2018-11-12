//
//  MessageChat.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
let KMSG_CHAT_isTimeItem                  = "isTimeItem"
let KMSG_CHAT_isVideoMsg           = "isVideoMsg"
let KMSG_CHAT_isImageMsg           = "isImageMsg"
let KMSG_CHAT_userImg          = "userImg"
let KMSG_CHAT_media_resourse           = "media_resourse"
let KMSG_CHAT_Msg_Text           = "Msg_Text"
let KMSG_CHAT_isAddNewMemberMSg          = "isAddNewMemberMSg"
let KMSG_CHAT_added_date           = "added_date"
let KMSG_CHAT_image_Path           = "image_Path"
let KMSG_CHAT_video_path           = "video_path"
let KMSG_CHAT_video_thumbnil         = "video_thumbnil"
let KMSG_CHAT_local_video_thumbnil         = "local_video_thumbnil"
let KMSG_CHAT_isUploadinStart          = "isUploadinStart"
let KMSG_CHAT_loacal_image_drawable          = "loacal_image_drawable"
let KMSG_CHAT_Local_video_path          = "Local_video_path"
let KMSG_CHAT_Local_image_path          = "Local_image_path"
let KMSG_CHAT_receiver_id      = "receiver_id"
class MessageChat: NSObject {
    
    
    
//    var isTimeItem = kEmptyBoolean
//    var isVideoMsg = kEmptyBoolean
//    var isImageMsg = kEmptyBoolean
//    var userImg  = kEmptyInt
//    var media_resourse   = kEmptyString
//    var Msg_Text   = kEmptyString
//    var isAddNewMemberMSg  = kEmptyBoolean
//    var added_date   = kEmptyString
//    var  image_Path   = kEmptyString
//    var video_path   = kEmptyString
//    var video_thumbnil   = kEmptyString
//    var isUploadinStart = kEmptyBoolean
//    var loacal_image_drawable   = kEmptyString
//    var local_video_thumbnil  = kEmptyString
//    var Local_video_path  = kEmptyString
//    var Local_image_path  = kEmptyString
//    var receiver_id  = kEmptyInt
    
    var chat_id  = kEmptyInt
    var poster   = kEmptyString
    var updated_at   = kEmptyString
    var receiver_deleted  = kEmptyInt
    var receiver_id  = kEmptyInt
    var file_type   = kEmptyString
    var file_path   = kEmptyString
    var sender_id  = kEmptyInt
    var is_read  = kEmptyInt
    var created_at   = kEmptyString
    var sender_avatar   = kEmptyString
    var sender_special_icon   = kEmptyString
    var sender_first_name   = kEmptyString
    var sender_sender_id   = kEmptyInt
    var sender_image_path   = kEmptyString
    var sender_points   = kEmptyInt
    var message   = kEmptyString
    var sender_deleted   = kEmptyInt
    
    var receiver_avatar   = kEmptyString
    var receiver_special_icon   = kEmptyString
    var receiver_first_name   = kEmptyString
    var receiver_receiver_id   = kEmptyInt
    var receiver_image_path   = kEmptyString
    var receiver_points   = kEmptyInt
    
    var imageMain  = UIImage.init(named: "")
    var VideoUrl  = ""
    var site_url = kEmptyString
    var url = kEmptyString
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
        self.chat_id = json?["chat_id"] as? Int ?? 0
        self.poster =  json?["poster"] as? String ?? kEmptyString
        self.updated_at =  json?["updated_at"] as? String ?? kEmptyString
        self.receiver_deleted = json?["receiver_deleted"] as? Int ?? 0
        self.receiver_id = json?["receiver_id"] as? Int ?? 0
        self.file_type =  json?["file_type"] as? String ?? kEmptyString
        self.file_path =  json?["file_path"] as? String ?? kEmptyString
        self.VideoUrl =  json?["file_path"] as? String ?? kEmptyString
        self.sender_id = json?["sender_id"] as? Int ?? 0
        self.is_read = json?["is_read"] as? Int ?? 0
        self.created_at =  json?["created_at"] as? String ?? kEmptyString
        self.site_url =  json?["site_url"] as? String ?? kEmptyString
        self.url = json?["url"] as? String ?? kEmptyString
        if json?["sender"] != nil {
            self.sender_avatar =  json?["sender"]!["avatar"] as? String ?? kEmptyString
            self.sender_special_icon =  json?["sender"]!["special_icon"] as? String ?? kEmptyString
            self.sender_first_name =  json?["sender"]!["first_name"] as? String ?? kEmptyString
            self.sender_sender_id = json?["sender"]!["id"] as? Int ?? 0
            self.sender_image_path =  json?["sender"]!["image_path"] as? String ?? kEmptyString
            self.sender_points = json?["sender"]!["points"] as? Int ?? 0
        }
        
        if json?["receiver"] != nil {
            self.receiver_avatar =  json?["receiver"]!["avatar"] as? String ?? kEmptyString
            self.receiver_special_icon =  json?["receiver"]!["special_icon"] as? String ?? kEmptyString
            
            self.receiver_first_name =  json?["receiver"]!["first_name"] as? String ?? kEmptyString
            self.receiver_receiver_id = json?["receiver"]!["id"] as? Int ?? 0
            self.receiver_image_path =  json?["receiver"]!["image_path"] as? String ?? kEmptyString
            self.receiver_points = json?["receiver"]!["points"] as? Int ?? 0
        }
        
        self.message =  json?["message"] as? String ?? kEmptyString
          self.message =  self.message.RemoveHTMLTag()
        self.sender_deleted = json?["sender_deleted"] as? Int ?? 0
        self.receiver_id =  json?[KMSG_CHAT_receiver_id]as? Int ?? 0
    }
}
