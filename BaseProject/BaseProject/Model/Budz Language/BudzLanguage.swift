//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit

let kISOName                = "iso_639-1"
let kGet_language            = "get_language"
let klanguages            = "languages"

class BudzLanguage: NSObject {
    
    var language_ID = kEmptyString
    var language_name = kEmptyString
    var ISOName = kEmptyString
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        
        
        if let languageObj = json?[kGet_language] as? [String : AnyObject] {
          self.language_ID                       = String(languageObj[kID] as? Int ?? 0)
            self.ISOName                       = languageObj[kISOName] as? String ?? kEmptyString
            self.language_name                       = languageObj[KGRP_Name] as? String ?? kEmptyString
        }else {
            self.language_ID                       = String(json?[kID] as? Int ?? 0)
            self.ISOName                       = json?[kISOName] as? String ?? kEmptyString
            self.language_name                       = json?[KGRP_Name] as? String ?? kEmptyString
        }
        
        print(self.language_ID)
	}
}
