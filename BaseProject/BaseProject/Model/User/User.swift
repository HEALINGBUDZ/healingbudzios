//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit


let knick_name = "nick_name"
let kemail = "email"
let kpassword = "password"
let kzip_code = "zip_code"
let kuser_type = "user_type"
let kdevice_type = "device_type"
let kdevice_id = "device_id"
let kavatar = "avatar"
let klat = "lat"
let klng = "lng"
let kfb_id = "fb_id"
let kg_id = "g_id"
let kID = "id"
let ktimezone = "timezone"
let kimage = "image"
let klocation = "location"
let kfirst_name = "first_name"
let klast_name = "last_name"
let kpoints = "points"
let kimage_path = "image_path"
let kcover = "cover"
let kbio = "bio"
let kcity = "city"
//let special_icon = ""
let kstate_id = "state_id"
let kgoogle_id = "google_id"
let kis_web = "is_web"
let kshow_my_save = "show_my_save"
let kfollowers_count = "followers_count"
let kfollowings_count = "followings_count"
let kMessage = "message"
let kSub_user_id = "sub_user_id"
let kSubUserCount = "sub_user"


class User: NSObject, NSCoding {
    
    var phone = kEmptyString
     var special_icon = ""
    var email        = kEmptyString
    var title       = kEmptyString
    var followed_id        = kEmptyString
    var password    = kEmptyString
    var userFirstName    = kEmptyString
    var userLastName    = kEmptyString
    var ID            = kEmptyString
    var Points            = kEmptyString
    var zipcode        = kEmptyString
    var avatarImage = kEmptyString
    var profilePictureURL = kEmptyString
    var coverPhoto = kEmptyString
    var Bio            = kEmptyString
    var address     = kEmptyString
    var userType            = kEmptyString
    var deviceID	= kEmptyString
    var deviceType	= "ios"
    var sessionID	= kEmptyString
    var profileImage : UIImage!
    var userlat    = kEmptyString
    var userlng    = kEmptyString
    var userCurrentlat    = kEmptyString
    var userCurrentlng    = kEmptyString
    var show_my_save            = kEmptyString
    var isWeb            = kEmptyString
    var isFBID            = kEmptyString
    var isGoogleID            = kEmptyString
    var statedID            = kEmptyString
    var cityName            = kEmptyString
    var colorMAin            = UIColor.white
    var followers_count            = kEmptyString
    var followings_count            = kEmptyString
    var is_following_count            = kEmptyString
    var bloomingBudText            = kEmptyString
    var subUserCount                : NSNumber = 0
    var showBudzPopup              : Int?
    
    var shout_outs_count : NSNumber   =   0
    var notifications_count : NSNumber   =   0
    
    var message = kEmptyString
    var sub_user_id  = kEmptyString
    
    var pointsColor: UIColor    {
        if Int(self.Points)! < 100 {
            return ConstantsColor.kUnder100Color
        }else if Int(self.Points)! < 200 {
            return ConstantsColor.kUnder200Color
        }else if Int(self.Points)! < 300 {
            return ConstantsColor.kUnder300Color
        }else if Int(self.Points)! < 400 {
            return ConstantsColor.kUnder400Color
        }else {
            return ConstantsColor.kUnder500Color
        }
    }
    
    var budType: String {
        if Int(self.Points)! < 100 {
            return "Sprout"
        }else if Int(self.Points)! < 200 {
            return "Seedling"
        }else if Int(self.Points)! < 300 {
            return "Young Bud"
        }else if Int(self.Points)! < 400 {
            return "Blooming Bud"
        }else {
            return "Best Bud"
        }
    }
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.email        = json?[kemail] as? String ?? kEmptyString
        self.password        = ""
        if let tit = json?["title"] as? String {
                self.title = tit
        }
         else {
             self.title = kEmptyString
        }
        self.special_icon = json?["special_icon"] as? String ?? kEmptyString
        self.avatarImage        = json?[kavatar] as? String ?? kEmptyString
        if let  first_name =  json?[kfirst_name] as? String{
             self.userFirstName        =  first_name
        }else if let first_name_digit = json?[kfirst_name] as? NSNumber {
             self.userFirstName        = "\(first_name_digit.intValue)"
        }
       
        self.userLastName = json?[klast_name] as? String ?? kEmptyString
        self.cityName = json?[kcity] as? String ?? kEmptyString
        self.statedID            = String(json?[kstate_id] as? Int ?? 0)
        self.followers_count            = String(json?[kfollowers_count] as? Int ?? 0)
        self.followings_count            = String(json?[kfollowings_count] as? Int ?? 0)
        self.isGoogleID            = String(json?[kgoogle_id] as? Int ?? 0)
        self.isFBID            = String(json?[kfb_id] as? Int ?? 0)
        self.isWeb            = String(json?[kis_web] as? Int ?? 0)
        self.ID            = String(json?[kID] as? Int ?? 0)
        self.Points            = String(json?[kpoints] as? Int ?? 0)
        self.userType            = String(json?[kuser_type] as? Int ?? 0)
        
        if let is_f_count = json?["is_following_count"] as? Int {
             self.is_following_count            = String(json?["is_following_count"] as? Int ?? 0)
        }else {
             self.is_following_count            = String(json?["is_following_count"] as? String ?? "0")
        }
//        self.is_following_count            = String(json?["is_following_count"] as? Int ?? 0)
        self.show_my_save            = String(json?[kshow_my_save] as? Int ?? 0)
        self.zipcode            = String(json?[kzip_code] as? Int ?? 0)
        if self.zipcode    == "0" {
            self.zipcode = ""
        }
        self.userlat            = String(json?[klat] as? Double ?? 0.0)
        self.userlng            = String(json?[klng] as? Double ?? 0.0)
        self.profilePictureURL = json?[kimage_path] as? String ?? kEmptyString
        self.shout_outs_count  = json?["shout_outs_count"] as? NSNumber ?? 0
        self.notifications_count  = json?["notifications_count"] as? NSNumber ?? 0
        self.subUserCount  = json?["sub_user"] as? NSNumber ?? 0
        self.showBudzPopup = json?["show_budz_popup"] as? Int ?? 0
        
//        if let s = json?["sub_user"] as? NSNumber{
//            self.subUserCount  = json?["sub_user"] as? NSNumber ?? 0
//        }else{
//            self.subUserCount  = NSNumber(value: Int(json?["sub_user"] as? String ?? "0")!)
//        }
        if self.profilePictureURL.characters.count < 5 {
            self.profilePictureURL = self.avatarImage
        }
        
        self.coverPhoto    = json?[kcover] as? String ?? kEmptyString
        self.Bio    = json?[kbio] as? String ?? kEmptyString
        self.address    = json?[klocation] as? String ?? kEmptyString
     
        if self.Points.characters.count > 0 {
            if Int(self.Points)! < 100 {
                self.bloomingBudText = "Sprout"
                self.colorMAin = ConstantsColor.kUnder100Color
            }else if Int(self.Points)! < 200 {
                self.bloomingBudText = "Seedling"
                self.colorMAin = ConstantsColor.kUnder200Color
            }else if Int(self.Points)! < 300 {
                self.bloomingBudText = "Young Bud"
                self.colorMAin = ConstantsColor.kUnder300Color
            }else if Int(self.Points)! < 400 {
                self.bloomingBudText = "Blooming Bud"
                self.colorMAin = ConstantsColor.kUnder400Color
            }else {
                self.bloomingBudText = "Best Bud"
                self.colorMAin = ConstantsColor.kUnder500Color
            }
        }
        
	}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: kuser_id)
        aCoder.encode(email, forKey: kemail)
        aCoder.encode(password, forKey: kpassword)
        aCoder.encode(avatarImage, forKey: kavatar)
        aCoder.encode(userFirstName, forKey: kfirst_name)
        aCoder.encode(userLastName, forKey: klast_name)
        aCoder.encode(cityName, forKey: kcity)
        aCoder.encode(statedID, forKey: kstate_id)
        aCoder.encode(isGoogleID, forKey: kgoogle_id)
        aCoder.encode(isFBID, forKey: isFBID)
        aCoder.encode(isWeb, forKey: kis_web)
        aCoder.encode(Points, forKey: kpoints)
        aCoder.encode(userType, forKey: userType)
        aCoder.encode(show_my_save, forKey: show_my_save)
        aCoder.encode(zipcode, forKey: kzip_code)
        aCoder.encode(userlat, forKey: klat)
        aCoder.encode(userlng, forKey: klng)
        aCoder.encode(profilePictureURL, forKey: kimage)
        aCoder.encode(coverPhoto, forKey: kcover)
        aCoder.encode(Bio, forKey: kbio)
        aCoder.encode(address, forKey: klocation)
        aCoder.encode(deviceID, forKey: kdevice_id)
        aCoder.encode(deviceType, forKey: kdevice_type)
        aCoder.encode(sessionID, forKey: kSessionKey)
        aCoder.encode(followers_count, forKey: kfollowers_count)
        aCoder.encode(followings_count, forKey: kfollowings_count)
        aCoder.encode(userCurrentlat, forKey: "userCurrentlat")
        aCoder.encode(userCurrentlng, forKey: "userCurrentlng")
        aCoder.encode(shout_outs_count, forKey: "shout_outs_count")
         aCoder.encode(notifications_count, forKey: "notifications_count")
        aCoder.encode(subUserCount, forKey: "sub_user")
        aCoder.encode(showBudzPopup, forKey: "show_budz_popup")
        aCoder.encode(special_icon, forKey: "special_icon")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.userCurrentlat = aDecoder.decodeObject(forKey:"userCurrentlat") as? String ?? kEmptyString
        self.special_icon = aDecoder.decodeObject(forKey:"special_icon") as? String ?? kEmptyString
        self.userCurrentlng = aDecoder.decodeObject(forKey:"userCurrentlng") as? String ?? kEmptyString
        self.email = aDecoder.decodeObject(forKey:kemail) as? String ?? kEmptyString
        self.password = aDecoder.decodeObject(forKey:kpassword) as? String ?? kEmptyString
        self.avatarImage = aDecoder.decodeObject(forKey:kavatar) as? String ?? kEmptyString
        self.userFirstName = aDecoder.decodeObject(forKey:kfirst_name) as? String ?? kEmptyString
        self.userLastName = aDecoder.decodeObject(forKey:klast_name) as? String ?? kEmptyString
        self.cityName = aDecoder.decodeObject(forKey:kcity) as? String ?? kEmptyString
        self.statedID = aDecoder.decodeObject(forKey:kstate_id) as? String ?? kEmptyString
        self.isGoogleID = aDecoder.decodeObject(forKey:kgoogle_id) as? String ?? kEmptyString
        self.isFBID = aDecoder.decodeObject(forKey:kfb_id) as? String ?? kEmptyString
        self.isWeb = aDecoder.decodeObject(forKey:kis_web) as? String ?? kEmptyString
        self.Points = aDecoder.decodeObject(forKey:kpoints) as? String ?? kEmptyString
        self.userType = aDecoder.decodeObject(forKey:kuser_type) as? String ?? kEmptyString
        self.show_my_save = aDecoder.decodeObject(forKey:kshow_my_save) as? String ?? kEmptyString
        self.userlat = aDecoder.decodeObject(forKey:klat) as? String ?? kEmptyString
        self.userlng = aDecoder.decodeObject(forKey:klng) as? String ?? kEmptyString
        self.coverPhoto = aDecoder.decodeObject(forKey:kcover) as? String ?? kEmptyString
        self.Bio = aDecoder.decodeObject(forKey:kbio) as? String ?? kEmptyString
        self.ID = aDecoder.decodeObject(forKey:kuser_id) as? String ?? kEmptyString
        self.deviceID = aDecoder.decodeObject(forKey:kdevice_id) as? String ?? kEmptyString
        self.deviceType = aDecoder.decodeObject(forKey:kdevice_type) as? String ?? kEmptyString
        self.sessionID = aDecoder.decodeObject(forKey:kSessionKey) as? String ?? kEmptyString
        self.profilePictureURL = aDecoder.decodeObject(forKey:kimage) as? String ?? kEmptyString
        self.address = aDecoder.decodeObject(forKey:klocation) as? String ?? kEmptyString

        self.followings_count = aDecoder.decodeObject(forKey:kfollowings_count) as? String ?? kEmptyString
        self.followers_count = aDecoder.decodeObject(forKey:kfollowers_count) as? String ?? kEmptyString
        
        self.zipcode = aDecoder.decodeObject(forKey:kzip_code) as? String ?? kEmptyString
        
         self.shout_outs_count = aDecoder.decodeObject(forKey:"shout_outs_count") as? NSNumber ?? 0
         self.notifications_count = aDecoder.decodeObject(forKey:"notifications_count") as? NSNumber ?? 0
        self.subUserCount = aDecoder.decodeObject(forKey:"sub_user") as? NSNumber ?? 0
        self.showBudzPopup = aDecoder.decodeObject(forKey:"show_budz_popup") as? Int ?? 0
    }
	
    func toRegisterJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        
        json[kemail] = self.email as AnyObject?
        json[kpassword] = self.password as AnyObject?
        json[kzip_code] = self.zipcode as AnyObject?
        json[kuser_type] = self.userType as AnyObject?
        json[knick_name] = self.userFirstName as AnyObject?
        json[kavatar] = self.avatarImage as AnyObject?
        json[kdevice_id] = self.deviceID as AnyObject?
        json[kdevice_type] = self.deviceType as AnyObject?
        if self.profilePictureURL.count > 0 {
            json[kimage] = self.profilePictureURL as AnyObject?
        }
        if self.special_icon.count > 0 {
            json["special_icon"] = self.special_icon as AnyObject?
        }
        if self.isFBID.count > 0 {
            json[kfb_id] = self.isFBID as AnyObject?
        }
        if self.isGoogleID.count > 0 {
            json[kg_id] = self.isGoogleID as AnyObject?
        }
        json[klat] = self.userlat as AnyObject?
        json[klng] = self.userlng as AnyObject?
        json[klocation] = self.address as AnyObject?
        
        json[kMessage] = self.message as AnyObject?
      
        json[kSub_user_id] = self.sub_user_id as AnyObject?
        
        print(json)
        return json
    }
    
    func toRegisterJSONSupport() -> [String: AnyObject] {
        var json = [String: AnyObject]()
//
//        json[kemail] = self.email as AnyObject?
//        json[kpassword] = self.password as AnyObject?
//        json[kzip_code] = self.zipcode as AnyObject?
//        json[kuser_type] = self.userType as AnyObject?
//        json[knick_name] = self.userFirstName as AnyObject?
//        json[kavatar] = self.avatarImage as AnyObject?
//        json[kdevice_id] = self.deviceID as AnyObject?
//        json[kdevice_type] = self.deviceType as AnyObject?
//        if self.profilePictureURL.characters.count > 0 {
//            json[kimage] = self.profilePictureURL as AnyObject?
//        }
//        if self.isFBID.characters.count > 0 {
//            json[kfb_id] = self.isFBID as AnyObject?
//        }
//        if self.isGoogleID.characters.count > 0 {
//            json[kg_id] = self.isGoogleID as AnyObject?
//        }
//        json[klat] = self.userlat as AnyObject?
//        json[klng] = self.userlng as AnyObject?
//        json[klocation] = self.address as AnyObject?
        
        json[kMessage] = self.message as AnyObject?
        if(self.sub_user_id == DataManager.sharedInstance.user?.ID){
            json[kSub_user_id] = "" as AnyObject
        } else {
            json[kSub_user_id] = self.sub_user_id as AnyObject?
        }
        print(json)
        return json
    }


}
