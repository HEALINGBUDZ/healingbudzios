//
//  PostUser.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class PostUser: NSObject, Mappable , NSCoding {
    

    var id:NSNumber?
    var first_name:String?
    var last_name:String?
    var email:String?
    var zip_code:NSNumber?
 
    var image_path:String?
    var user_type:NSNumber?
    var avatar:String?
    var special_icon:String?
    var cover:String?
    var bio:String?
    
    var location:String?
    var city:String?
    var state_id:NSNumber?
    var google_id:NSNumber?
    var fb_id:NSNumber?
    var is_web:NSNumber?
    var show_my_save:NSNumber?
    var points:NSNumber?
    var created_at:String?
    var updated_at:String?
    var title: String?
    
    var profilePictureURL: String?
    
    func prepareImageUrl()  {
        var url = kEmptyString
        if let image_url = image_path, !image_url.isEmpty, image_url != "null" {
            url = image_url
        } else if let avt = avatar {
            url = avt
        }
        
        
        if !url.isEmpty {
            if url.contains("facebook.com") || url.contains("google.com"){
                profilePictureURL =  url
            }else{
                profilePictureURL = WebServiceName.images_baseurl.rawValue + url
            }
            
            
        }else {
            profilePictureURL = ""
        }
    }
    func prepareImageUrlSpecial()  {
        var url = kEmptyString
        if let image_url = special_icon, !image_url.isEmpty, image_url != "null" {
            url = image_url
        } else {
            url = ""
        }
        
        
        if url.isEmpty {
            special_icon = ""
        }else {
            special_icon = url
        }
    }
    
    var pointsValue: String {
        if let p = points   {
            return String(describing: p)
        }
        return kEmptyString
    }
    
    var pointsColor: UIColor    {
        if self.points == nil{
            return ConstantsColor.kUnder100Color
        }else{
        if Int(self.points!) < 100 {
            return ConstantsColor.kUnder100Color
        }else if Int(self.points!) < 200 {
            return ConstantsColor.kUnder200Color
        }else if Int(self.points!) < 300 {
            return ConstantsColor.kUnder300Color
        }else if Int(self.points!) < 400 {
            return ConstantsColor.kUnder400Color
        }else {
            return ConstantsColor.kUnder500Color
        }
        }
    }

    var budType: String {
        if Int(self.points!) < 100 {
            return "Sprout"
        }else if Int(self.points!) < 200 {
            return "Seedling"
        }else if Int(self.points!) < 300 {
            return "Young Bud"
        }else if Int(self.points!) < 400 {
            return "Blooming Bud"
        }else {
            return "Best Bud"
        }
    }
    
    
    
    override init() {
    }
    
    required init?(map: Map){
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id , forKey:"id")
        aCoder.encode(first_name ,  forKey:"first_name")
        aCoder.encode(last_name ,  forKey:"last_name")
        aCoder.encode(email ,  forKey:"email")
        aCoder.encode(zip_code ,  forKey:"zip_code")
        aCoder.encode(image_path ,  forKey:"image_path")
        aCoder.encode(user_type ,  forKey:"user_type")
        aCoder.encode(avatar ,  forKey:"avatar")
        aCoder.encode(cover ,  forKey:"cover")
        aCoder.encode(bio ,  forKey:"bio")
        aCoder.encode(location ,  forKey:"location")
        aCoder.encode(city ,  forKey:"city")
        aCoder.encode(state_id ,  forKey:"state_id")
        aCoder.encode(google_id ,  forKey:"google_id")
        aCoder.encode(fb_id ,  forKey:"fb_id")
        aCoder.encode(is_web ,  forKey:"is_web")
        aCoder.encode(show_my_save ,  forKey:"show_my_save")
        aCoder.encode(points ,  forKey:"points")
        aCoder.encode(created_at ,  forKey:"created_at")
        aCoder.encode(updated_at ,  forKey:"updated_at")
        aCoder.encode(title ,  forKey:"title")
        aCoder.encode(special_icon ,  forKey:"special_icon")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? NSNumber ?? 0
         self.first_name = aDecoder.decodeObject(forKey:"first_name") as? String  ?? kEmptyString
         self.last_name = aDecoder.decodeObject(forKey:"last_name") as? String  ?? kEmptyString
         self.email = aDecoder.decodeObject(forKey:"email") as? String  ?? kEmptyString
         self.zip_code = aDecoder.decodeObject(forKey:"zip_code") as? NSNumber ?? 0
         self.image_path = aDecoder.decodeObject(forKey:"image_path") as? String  ?? kEmptyString
         self.user_type = aDecoder.decodeObject(forKey:"user_type") as? NSNumber ?? 0
        
        self.avatar = aDecoder.decodeObject(forKey:"avatar") as? String  ?? kEmptyString
        self.cover = aDecoder.decodeObject(forKey:"cover") as? String  ?? kEmptyString
        self.bio = aDecoder.decodeObject(forKey:"bio") as? String  ?? kEmptyString
        self.location = aDecoder.decodeObject(forKey:"location") as? String  ?? kEmptyString
        self.city = aDecoder.decodeObject(forKey:"city")  as? String  ?? kEmptyString
        self.state_id = aDecoder.decodeObject(forKey:"state_id") as? NSNumber ?? 0
        
        self.google_id = aDecoder.decodeObject(forKey:"google_id") as? NSNumber ?? 0
        self.fb_id = aDecoder.decodeObject(forKey:"fb_id") as? NSNumber ?? 0
        self.is_web = aDecoder.decodeObject(forKey:"is_web") as? NSNumber ?? 0
        self.show_my_save = aDecoder.decodeObject(forKey:"show_my_save") as? NSNumber ?? 0
        self.points = aDecoder.decodeObject(forKey:"points") as? NSNumber ?? 0
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String  ?? kEmptyString
        
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String  ?? kEmptyString
        self.title = aDecoder.decodeObject(forKey:"title") as? String  ?? kEmptyString
        self.special_icon = aDecoder.decodeObject(forKey:"special_icon") as? String  ?? kEmptyString
        
        
    }
    
    func mapping(map: Map){
        
        id <- map["id"]
        first_name <- map["first_name"]
        if first_name == nil{
            var f: Int?
            f  <- map["first_name"]
            first_name = String(f!)
            if first_name == nil {
                first_name = "Bud"
            }
        }
        last_name <- map["last_name"]
        email <- map["email"]
        zip_code <- map["zip_code"]
        image_path <- map["image_path"]
        user_type <- map["user_type"]
        avatar <- map["avatar"]
        cover <- map["cover"]
        bio <- map["bio"]
        location <- map["location"]
        city <- map["city"]
        state_id <- map["state_id"]
        google_id <- map["google_id"]
        fb_id <- map["fb_id"]
        is_web <- map["is_web"]
        show_my_save <- map["show_my_save"]
        points <- map["points"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        title <- map["title"]
        special_icon <- map["special_icon"]
        
        prepareImageUrl()
        prepareImageUrlSpecial()
    }
}

