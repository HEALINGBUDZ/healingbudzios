//
//  StrainRating.swift
//  BaseProject
//
//  Created by Adnan Ahmad on 03/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class StrainRating: Mappable {

    var strain_id:NSNumber?
    var total:NSNumber?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
    print(map.JSON)
        if let  strain_idd  = map.JSON["strain_id"] as? Int {
            self.strain_id =  NSNumber(value: strain_idd)
        }else{
             self.strain_id =  0
        }
        if let  total  = map.JSON["total"] as? String {
            self.total =  NSNumber(value: Double(total)!)
        }else{
             self.total = 1
        }
        
    }
}
