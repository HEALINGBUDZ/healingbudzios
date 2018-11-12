//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit
import  SwiftyJSON
class SaveModel: NSObject {
    
    var created_at = kEmptyString
    var descriptionSave = kEmptyString
    var ID = kEmptyInt
    var model = kEmptyString
    var title = kEmptyString
   var type_id = kEmptyInt
   var type_sub_id = kEmptyInt
    var updated_at = kEmptyString
    var user_id = kEmptyInt
    var user = User()
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.created_at                       = json?[kcreated_at] as? String ?? kEmptyString
        self.descriptionSave                     = json?["description"] as? String ?? kEmptyString
        self.ID            = json?[kID] as? Int ?? 0
        self.model                     = json?["model"] as? String ?? kEmptyString
        self.title                     = json?["title"] as? String ?? kEmptyString
        self.title = self.title.RemoveHTMLTag()
        self.title = self.title.RemoveBRTag()
        self.type_id            = json?["type_id"] as? Int ?? 0
        self.type_sub_id            = json?["type_sub_id"] as? Int ?? 0
        self.updated_at                     = json?["updated_at"] as? String ?? kEmptyString
        self.user_id            =  json?["user_id"] as? Int ?? 0
        
        if self.type_id == 10 {
             let dis = self.descriptionSave
             var jsonObj = JSON.init(parseJSON: dis)
            print(jsonObj.dictionaryObject as Any)
            self.title = jsonObj.dictionary?["search_title"]?.rawValue as? String ?? ""
            print(self.title)
            self.descriptionSave = jsonObj.dictionary?["search_data"]?.rawValue as? String ?? ""
            print(self.descriptionSave)
        }else if self.type_id == 13 || self.type_id == 2{
            self.user = User.init(json: json?["user"] as! [String : AnyObject]) ?? User()
        }
       
        
	}
}
