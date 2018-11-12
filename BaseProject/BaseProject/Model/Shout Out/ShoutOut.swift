//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation


let kuser_id                = "user_id"
let kshout_out_id           = "shout_out_id"
let ktext = "text"
let kis_read = "is_read"
let kcreated_at = "created_at"
let kupdated_at = "updated_at"
let klikes_count = "likes_count"
let kuserlike_count = "userlike_count"
let ksub_user = "get_sub_user"
let kmessage = "message"
let ktitle = "title"
let kvalidity_date = "validity_date"
let kpublic_location = "public_location"
let kdistance = "distance"
let kget_user = "get_user"
let kshout_out = "shout_out"


class ShoutOut: NSObject {
    var ID = kEmptyString
    var distance_string = kEmptyString
    var shoutOut_ID = kEmptyString
    var shoutOut_text = kEmptyString
    var shoutOutLogo = ""
    var is_Read = kEmptyString
    var sub_user_id : NSNumber = 0
    var created_At = kEmptyString
    var updated_At = kEmptyString
    var likes_count = kEmptyString
    var userlike_count = kEmptyString
    var sub_user = User()
    var mainUser = User()
    var shoutOut_message = kEmptyString
    var shoutOut_title = kEmptyString
    var validity_Date = kEmptyString
    var shoutOut_image = kEmptyString
    var shoutOut_lat = kEmptyString
    var shoutOut_lng = kEmptyString
    var zipCode = kEmptyString
    var public_Location = kEmptyString
    var distance = kEmptyString
    var budzSpecialId:Int = -1

    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json!)
        if let IDT = json?[kshout_out_id] as? Int {
             self.shoutOut_ID            = String(json?[kshout_out_id] as? Int ?? 0)
        }else {
             self.shoutOut_ID            = String(json?[kshout_out_id] as? String ?? "0")
        }
        
        if let IDT = json?["id"] as? Int {
            self.ID            = String(json?["id"] as? Int ?? 0)
        }else {
            self.ID            = String(json?["id"] as? String ?? "0")
        }
        
        if let IDT = json?[klikes_count] as? Int {
           self.likes_count            = String(json?[klikes_count] as? Int ?? 0)
        }else {
           self.likes_count            = String(json?[klikes_count] as? String ?? "0")
        }
       
        self.shoutOut_text        = json?[kmessage] as? String ?? kEmptyString
        self.is_Read            = String(json?[kis_read] as? Int ?? 0)
        self.created_At        = json?[kcreated_at] as? String ?? kEmptyString
        self.updated_At        = json?[kupdated_at] as? String ?? kEmptyString
        if (json?[kuserlike_count] as? Int) != nil {
             self.userlike_count     = String(json?[kuserlike_count] as? Int ?? 0)
        }else {
           self.userlike_count     = String(json?[kuserlike_count] as? String ?? "0")
        }
        if let idSp = json?["budz_special_id"] as? Int{
            self.budzSpecialId = idSp
        }else  if let idSp = json?["budz_special_id"] as? String{
            self.budzSpecialId = Int(idSp)!
        }else {
            self.budzSpecialId = -1
        }
        self.sub_user            = User.init(json: json?[ksub_user] as? [String : AnyObject])
        
        if let shoout_out = json?[kshout_out] as? [String: Any]{
            if let sub_user_id = shoout_out["sub_user_id"] as? NSNumber{
                self.sub_user_id  = sub_user_id
            }
        }else {
            if let sub_user_id = json?["sub_user_id"] as? NSNumber{
                self.sub_user_id  = sub_user_id
            }
        }
        let abc = json?["get_sub_user"] as AnyObject
        self.shoutOutLogo =      abc["logo"] as? String ?? kEmptyString
        self.mainUser            = User.init(json: json?[kget_user] as? [String : AnyObject])
        self.shoutOut_message        = json?[kmessage] as? String ?? kEmptyString
        self.shoutOut_title        = json?[ktitle] as? String ?? kEmptyString
        self.validity_Date        = json?[kvalidity_date] as? String ?? kEmptyString
        self.shoutOut_image        = json?[kimage] as? String ?? kEmptyString
        self.shoutOut_lat        = String(json?[klat] as? Double ?? kEmptyDouble)
        self.shoutOut_lng        = String(json?[klng] as? Double ?? kEmptyDouble)
        self.zipCode        = String(json?[kzip_code] as? Int ?? 0)
        self.public_Location        = json?[kpublic_location] as? String ?? kEmptyString
        self.distance        = String(json?[kdistance] as? Double ?? kEmptyDouble).FloatValue()
        if self.distance.count == 0 {
            self.distance = (json?["distance"] as! String).FloatValue()
        }
        self.distance_string =  "\(distance)".FloatValue()
        print(distance)
	}
}
