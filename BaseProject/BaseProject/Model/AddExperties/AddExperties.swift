//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//


import Foundation
import UIKit



class AddExperties: NSObject {
    
    var created_at = kEmptyString
    var id = kEmptyInt
    var title = kEmptyString
    var updated_at = kEmptyString
    var warnpopup = 0
    var suggestion = false
    var is_approved = 2
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json)
        self.created_at                       = json?[kcreated_at] as? String ?? kEmptyString
        self.id                           = json?[kID] as? Int ?? 0
        self.title                     = json?["m_condition"] as? String ?? kEmptyString
        self.updated_at                     = json?[kupdated_at] as? String ?? kEmptyString
        self.is_approved                = json?["is_approved"] as? Int ?? 2
        
        suggestionINIT()
	}
    
    func suggestionINIT(){
        if is_approved == 0{
            self.suggestion = true
        }else{
            self.suggestion = false
        }
    }
}
