//
//  StrainRating.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainSurvey: Mappable {

    var name:String?
    var result:NSNumber?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
    
        name <- map["name"]
        result <- map["result"]
    }
}



class StrainSurveyAnswers: Mappable { 
    
    var effect:String?
    var id:NSNumber?
    var is_approved:NSNumber?
    
    init() {
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map){
        
        
        effect <- map["effect"]
        if effect == nil {
            effect <- map["m_condition"]
        }
        
        if effect == nil {
            effect <- map["sensation"]
        }
        
        if effect == nil {
            effect <- map["prevention"]
        }
        
        if effect == nil {
            effect <- map["flavor"]
        }
        id <- map["id"]
        is_approved <- map["is_approved"]
        print(map.JSON)
        print(effect)
        
    }
}
