//
//  QA.swift
//  BaseProject
//
//  Created by Incubasyss on 05/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import Foundation
let KQA_id                      = "id"
let KQA_user_name               = "first_name"
let KQA_user_nameid             = "id"
let KQA_Question                = "question"
let Kdescription    = "description"
let KQA_user_photo              = "image_path"
let KQA_user_avatar             = "avatar"
let KQA_user_points             = "points"
let KQA_AnswerCount             = "get_answers_count"
let KQA_get_user_likes_count    = "get_user_likes_count"
let KQA_get_user_flag_count     = "get_user_flag_count"
class QA: NSObject{
     var user_name    = kEmptyString
     var user_name_dscription    = kEmptyString
     var Question    = kEmptyString
     var Question_description    = kEmptyString
     var user_photo    = kEmptyString
    var special_icon    = kEmptyString
     var user_location    = kEmptyString
     var type    = kEmptyString
     var created_at    = kEmptyString
     var updated_at    = kEmptyString
     var user_points = kEmptyInt
     var AnswerCount = kEmptyInt
     var id = kEmptyInt
     var user_id = kEmptyInt
     var show_ads = kEmptyInt
     var get_user_likes_count = kEmptyInt
     var get_user_flag_count = kEmptyInt
     var isFavorite = kEmptyBoolean
    var questiontime = kEmptyString
    var attachments = [Attachment]()
    var user_notify = kEmptyString
    var icCurrentUserAnserd = false
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json ?? "")
        
        self.id =  json?[KQA_id] as? Int ?? 0
        print(self.id)
        
        if ((json?["get_user"]) != nil) {
//            if let val = json?["get_user"]!["user_notify"] as? Int {
//                   self.user_notify = String(val)
//            }else {
//                   self.user_notify = String(json?["get_user"]!["user_notify"] as? String ?? "0")
//            }
         
            
            self.user_id = json?["get_user"]![KQA_user_nameid] as? Int ?? 0
            self.user_name =  json?["get_user"]![KQA_user_name] as? String ?? kEmptyString
            if let path  =  json?["get_user"]![KQA_user_photo] as? String{
                if path.contains("facebook.com") || path.contains("google.com"){
                   self.user_photo =   path
                }else{
                     self.user_photo =  WebServiceName.images_baseurl.rawValue + path
                }
               
            }else {
                self.user_photo =  WebServiceName.images_baseurl.rawValue + (json?["get_user"]![KQA_user_avatar] as? String ?? kEmptyString)
            }
            if let att = json?["get_user"]!["special_icon"] as? String{
                self.special_icon = att
            }else {
                self.special_icon = ""
            }
            self.user_points = json?["get_user"]![KQA_user_points] as? Int ?? 0

        }
        if let val = json?["user_notify"] as? Int {
            self.user_notify = String(val)
        }else {
            self.user_notify = String(json?["user_notify"] as? String ?? "0")
        }
         self.Question_description =  json?[Kdescription] as? String ?? kEmptyString
        self.Question =  json?[KQA_Question] as? String ?? kEmptyString
       
        if let arrayAttachment = json?[kattachments] as? [[String : AnyObject]] {
            for indexObj in arrayAttachment{
                self.attachments.append(Attachment.init(json: indexObj))
            }
        }
        
        self.Question = self.Question.RemoveHTMLTag()
        self.Question = self.Question.RemoveBRTag()
        
        self.Question_description = self.Question_description.RemoveHTMLTag()
        self.Question_description = self.Question_description.RemoveBRTag()
        
       
        
         self.AnswerCount = json?[KQA_AnswerCount] as? Int ?? 0
         self.get_user_likes_count = json?[KQA_get_user_likes_count] as? Int ?? 0
        self.get_user_flag_count = json?[KQA_get_user_flag_count] as? Int ?? 0
        
        if let timeObj = json?[kupdated_at] as? String  {
            self.questiontime = timeObj
        }else if let timeObj = json?[kcreated_at] as? String {
            self.questiontime = timeObj
        }
        print(json)
        if self.AnswerCount == 0 {
            if let answerCount = json?["answers_sum"] as? [[String : AnyObject]]{
                if answerCount.count > 0 {
                    if let total = answerCount[0]["total"] as? String{
                        self.AnswerCount = Int(total)!
                    }else{
                         self.AnswerCount = 0
                    }
                   
                }else{
                    self.AnswerCount = 0
                }
            }else{
                self.AnswerCount = 0
            }
        }
        if let show_add = json?["show_ads"] as? String {
            self.show_ads  = Int(show_add)!
        }
       
        self.created_at = json?["created_at"] as? String ?? ""
        self.updated_at = json?["updated_at"] as? String ?? ""
        
        
        if let isAnswer =  json?["is_answered_count"] as? NSNumber {
            if isAnswer.intValue == 0 {
                self.icCurrentUserAnserd = false
            }else{
                 self.icCurrentUserAnserd = true
            }
        }else if let isAnswer =  json?["is_answered_count"] as? String {
            if isAnswer == "0" {
                  self.icCurrentUserAnserd = false
            }else{
                  self.icCurrentUserAnserd = true
            }
        }
    }
    
}
