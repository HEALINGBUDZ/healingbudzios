//
//  Attachment.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

//let kupload_path = "upload_path"
//let kposter = "poster"
//let kanswer_attachments = "answer_attachments"
//let kmedia_type = "media_type"


//{
//    "id": 9,
//    "sub_user_id": "41",
//    "strain_id": "3",
//    "type_id": "2",
//    "name": "test",
//    "thc": "1.25",
//    "cbd": "2.25",
//    "created_at": "2018-01-10 14:05:57",
//    "updated_at": "2018-01-10 14:05:57",
//    "images": [
//    {
//    "id": 2,
//    "product_id": "9",
//    "image": "/product_images/product_pqEPA3gSgbQG1lf.jpg",
//    "user_id": "47",
//    "created_at": "2018-01-10 14:05:57",
//    "updated_at": "2018-01-10 14:05:57"
//    }
//    ],
//    "strain_type": {
//        "id": 2,
//        "title": "Indica",
//        "created_at": "2017-11-02 09:24:23",
//        "updated_at": "2017-11-02 10:19:20"
//    },
//    "pricing": [
//    {
//    "id": 5,
//    "product_id": "9",
//    "weight": "2.5",
//    "price": "55.00",
//    "created_at": "2018-01-10 14:05:57",
//    "updated_at": "2018-01-10 14:05:57"
//    }
//    ]
//}


import Foundation
import UIKit

class StrainProduct : NSObject {
    var  ID = kEmptyString
    var  sub_user_id = kEmptyString
    var  strain_id = kEmptyString
    var  type_id = kEmptyString
    var  name = kEmptyString
    var  thc = kEmptyString
    var  cbd = kEmptyString
    var  created_at = kEmptyString
    var  updated_at = kEmptyString
    var budzMap = BudzMap()
    var straintype: StrainTypeMAin?
    var strainCategory: StrainTypeCategory?
    var priceArray = [ProductPrice]()
    var isTitle:Bool  = false
    var titleDisplay:String  = "Others"
    var images = [StrainProductImages]()
    var isAlsoStrain:Bool = false
    var distance = 0.0
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json!)
        self.ID            = String(json?[kID] as? Int ?? 0)
                
        let priceData = json?["pricing"] as? [[String : AnyObject]]
        
        if priceData != nil {
            for indexObj in priceData! {
                self.priceArray.append(ProductPrice.init(json: indexObj))
            }
        }
        if let art = json?["distance"] as? Double {
        self.distance =  json?["distance"] as? Double ?? 0.0
        }else {
            self.distance =  Double(json?["distance"] as? String ?? "0.0")!
        }
        
        self.straintype = StrainTypeMAin.init(json: (json?["strain_type"] as? [String : AnyObject]) )
        self.strainCategory = StrainTypeCategory.init(json: (json?["category"] as? [String : AnyObject]) )
        
//        if strainCategory == nil && straintype == nil{
//            self.straintype?.title = "Others"
//        }
        if (strainCategory?.title)!.count > 0 && (straintype?.title)!.count > 0{
            isAlsoStrain = true
            if (strainCategory?.title)!.count > 0 {
                isAlsoStrain = true
                self.titleDisplay = (strainCategory?.title)!
            }else {
                if (straintype?.title)!.count > 0 {
                    isAlsoStrain = true
                    self.titleDisplay = "Others"
                }else {
                    isAlsoStrain = false
                    self.titleDisplay = "Others"
                }
            }
            
        }else if (strainCategory?.title)!.count > 0{
            isAlsoStrain = false
            if (strainCategory?.title)!.count > 0 {
                isAlsoStrain = false
                self.titleDisplay = (strainCategory?.title)!
            }else {
                if straintype != nil{
                    if (straintype?.title)!.count > 0 {
                        isAlsoStrain = true
                        self.titleDisplay = "Others"
                    }else {
                        isAlsoStrain = false
                        self.titleDisplay = "Others"
                    }
                }else {
                    isAlsoStrain = false
                    self.titleDisplay = "Others"
                }
            }
        }else if (straintype?.title)!.count > 0{
            isAlsoStrain = true
            if (straintype?.title)!.count > 0 {
                isAlsoStrain = true
                self.titleDisplay = "Others"
            }else {
                isAlsoStrain = false
                self.titleDisplay = "Others"
            }
        }else {
            isAlsoStrain = false
            self.titleDisplay = "Others"
        }
        self.sub_user_id            =  json?["sub_user_id"] as? String ?? kEmptyString
        if self.sub_user_id.isEmpty{
             self.sub_user_id            =  String(json?["sub_user_id"] as? Int ?? 0)
        }
         self.strain_id            = String(json?["strain_id"] as? Int ?? 0)
        self.type_id            = String(json?["type_id"] as? Int ?? 0)
        self.name            = json?["name"] as? String ?? kEmptyString
        if let vart = json?["thc"] as? Double {
            self.thc            = String(json?["thc"] as? Double ?? 0)
            if(self.thc == "0"){
                self.thc = ""
            }
        }else {
             self.thc            = String(json?["thc"] as? String ?? "")
        }
        if let vart = json?["cbd"] as? Double {
            self.cbd            =  String(json?["cbd"] as? Double ?? 0)
            if(self.cbd == "0"){
                self.cbd = ""
            }
        }else {
            self.cbd            =  String(json?["cbd"] as? String ?? "")
        }
        self.created_at            = json?["created_at"] as? String ?? kEmptyString
        self.updated_at            = json?["updated_at"] as? String ?? kEmptyString
        
        
        let images_array = json?["images"] as? [[String : AnyObject]]
        
        if images_array != nil {
            for indexObj in images_array! {
                self.images.append(StrainProductImages.init(json: indexObj))
            }
        } 
    }
}

//
class ProductPrice : NSObject {

    var  ID = kEmptyString
    var  product_id = kEmptyString
    var  weight = kEmptyString
    var  price = kEmptyString
    var  created_at = kEmptyString
    var  updated_at = kEmptyString

    convenience init(json: [String: AnyObject]?) {
        self.init()

        print(json!)
        self.ID            = String(json?[kID] as? Int ?? 0)
        self.weight            = json?["weight"] as? String ?? "1"
//        if self.weight == "1" {
//            let double = json?["weight"] as? Double ?? 0.0
//            self.weight = double.round2digit()
//        }
        self.price            = String(json?["price"] as? Double ?? 0.0)
        
        self.created_at            = json?["created_at"] as? String ?? kEmptyString
        self.updated_at            = json?["updated_at"] as? String ?? kEmptyString

    }
}



class StrainTypeMAin: NSObject {
    
    
    var typeID = kEmptyString
    var title = kEmptyString
    var created_at = kEmptyString
    var updated_at = kEmptyString
    
    
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        typeID = String(json?[kID] as? Int ?? 0)
        title = json?["title"] as? String ?? kEmptyString
        created_at  = json?["created_at"] as? String ?? kEmptyString
        updated_at  = json?["updated_at"] as? String ?? kEmptyString
    }
}

class StrainTypeCategory: NSObject {
    
    
    var typeID = kEmptyString
    var title = kEmptyString
    var created_at = kEmptyString
    var updated_at = kEmptyString
    
    
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        typeID = String(json?[kID] as? Int ?? 0)
        title = json?["title"] as? String ?? kEmptyString
        created_at  = json?["created_at"] as? String ?? kEmptyString
        updated_at  = json?["updated_at"] as? String ?? kEmptyString
    }
}



class StrainProductImages: NSObject {
    var image = kEmptyString
    convenience init(json: [String: AnyObject]?) {
        self.init()
        image = json?["image"] as? String ?? kEmptyString
    }
}

