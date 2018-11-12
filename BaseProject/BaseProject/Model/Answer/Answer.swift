//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit

let kquestion_id                = "question_id"
let kanswer                = "answer"
let kanswer_like_count                = "answer_like_count"
let kanswer_user_like_count                = "answer_user_like_count"
let kflag_by_user_count                = "flag_by_user_count"
let kget_attachments                = "get_attachments"

class Answer: NSObject {
    
    var answer = kEmptyString
    var answer_like_count = kEmptyString
    var answer_user_like_count = kEmptyString
    var flag_by_user_count = kEmptyString
    var attachments = [Attachment]()
    var userMain = User()
    var answer_ID = kEmptyString
    var question_ID = kEmptyString
    var answertime = kEmptyString
    var updated_time = kEmptyString
    var is_following_count = kEmptyString
    var mainQuestion = QA()
    var isEditCount:Bool = false
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.answer                       = json?[kanswer] as? String ?? kEmptyString
        self.answer_like_count            = String(json?[kanswer_like_count] as? Int ?? 0)
        self.is_following_count            = String(json?["is_following_count"] as? Int ?? 0)
        self.answer_user_like_count        = String(json?[kanswer_user_like_count] as? Int ?? 0)
        self.flag_by_user_count            = String(json?[kflag_by_user_count] as? Int ?? 0)
        print(flag_by_user_count)
        self.answer_ID                    = String(json?[kID] as? Int ?? 0)
        self.question_ID                  = json?[kquestion_id] as? String ?? kEmptyString
        if let ct = json?["get_edit_count"] as? Int {
            if(ct > 0){
                self.isEditCount = true
            }else {
                self.isEditCount = false
            }
        }else if let ct = json?["get_edit_count"] as? String{
            if ct == "0" {
                self.isEditCount = false
            }else {
                self.isEditCount = true
            }
        }
        if self.question_ID.count == 0 {
            self.question_ID  = String(json?[kquestion_id] as? Int ?? 0)
        }
        self.answer = self.answer.RemoveHTMLTag()
        self.answer = self.answer.RemoveBRTag()
        
        if let arrayAttachment = json?[kattachments] as? [[String : AnyObject]] {
            for indexObj in arrayAttachment{
                self.attachments.append(Attachment.init(json: indexObj))
            }
        }
                
        if let timeObj = json?[kupdated_at] as? String  {
            self.updated_time = timeObj
        }
        
        if let timeObj = json?[kcreated_at] as? String {
            self.answertime = timeObj
        }
        
        print(self.answertime)
        
        self.userMain = User.init(json: json?[kget_user] as? [String : AnyObject])
        self.mainQuestion = QA.init(json: json?["get_question"] as? [String : AnyObject])
	}
}
