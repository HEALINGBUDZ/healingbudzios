//
//  User.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//





import Foundation
import UIKit

let kbanner = "banner"
let kbusiness_type_id = "business_type_id"
let kcard_brand = "card_brand"
//let kvisit_requirements = "visit_requirements"
let kweb = "web"
let ktwitter = "twitter"
let ktrial_ends_at = "trial_ends_at"
let kstripe_id = "stripe_id"
let kpurchase_ticket_count = "purchase_ticket_count"
let kphone = "phone"
//let koffice_policies = "office_policies"
let kmenu_tab_count = "menu_tab_count"
let klogo = "logo"
let kis_organic = "is_organic"
let kis_delivery = "is_delivery"
//let kinsurance_accepted = "insurance_accepted"
let kinstagram = "instagram"
let kfacebook = "facebook"
let kcard_last_four = "card_last_four"


class SubUser: NSObject {
    
    
   var banner = kEmptyString
    var business_type_id = kEmptyString
    var card_brand = kEmptyString
    var card_last_four = kEmptyString
    var user_Description = kEmptyString
    var facebook = kEmptyString
     var id = kEmptyString
    var instagram = kEmptyString
    var insurance_accepted = kEmptyString
    var is_delivery = kEmptyString
    var is_organic = kEmptyString
    var lat = kEmptyString
    var lng = kEmptyString
    var location = kEmptyString
    var logo = kEmptyString
    var menu_tab_count = kEmptyString
    var office_policies = kEmptyString
    var phone = kEmptyString
    var purchase_ticket_count = kEmptyString
    var stripe_id = kEmptyString
    var title = kEmptyString
    var trial_ends_at = kEmptyString
    var twitter = kEmptyString
    var user_id = kEmptyString
    var visit_requirements = kEmptyString
    var web = kEmptyString
    var special = [Specials]()
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        print(json!)
        self.banner        = json?[kbanner] as? String ?? kEmptyString
        if let id_bu = json?[kbusiness_type_id] as? Int {
             self.business_type_id        = String(id_bu)
        }else {
             self.business_type_id        = kEmptyString
        }
       
        self.card_brand        = json?[kcard_brand] as? String ?? kEmptyString
        self.card_last_four        = json?[kcard_last_four] as? String ?? kEmptyString
        self.user_Description        = json?[Kdescription] as? String ?? kEmptyString
        self.facebook        = json?[kfacebook] as? String ?? kEmptyString
        self.id        = String(json?[kID] as? Int ?? 0)
        self.instagram        = json?[kinstagram] as? String ?? kEmptyString
        self.insurance_accepted        = json?[kinsurance_accepted] as? String ?? kEmptyString
        self.is_delivery        = json?[kis_delivery] as? String ?? kEmptyString
        self.is_organic        = json?[kis_organic] as? String ?? kEmptyString
        self.lat        = json?[klat] as? String ?? kEmptyString
        self.lng        = json?[klng] as? String ?? kEmptyString
        self.location        = json?[klocation] as? String ?? kEmptyString
        self.logo        = json?[klogo] as? String ?? kEmptyString
        self.menu_tab_count        = json?[kmenu_tab_count] as? String ?? kEmptyString
        self.office_policies        = json?[koffice_policies] as? String ?? kEmptyString
        self.phone        = json?[kphone] as? String ?? kEmptyString
        self.purchase_ticket_count        = json?[kpurchase_ticket_count] as? String ?? kEmptyString
        self.stripe_id        = json?[kstripe_id] as? String ?? kEmptyString
        self.title        = json?[ktitle] as? String ?? kEmptyString
        self.trial_ends_at        = json?[ktrial_ends_at] as? String ?? kEmptyString
        self.twitter        = json?[ktwitter] as? String ?? kEmptyString
        self.user_id        = json?[kuser_id] as? String ?? kEmptyString
        self.visit_requirements        = json?[kvisit_requirements] as? String ?? kEmptyString
        self.web        = json?[kweb] as? String ?? kEmptyString
        if let spl = json?["special"] as? [[String : AnyObject]] {
            for obj in spl {
                self.special.append(Specials.init(json: obj))
            }
        }
	}
}


class Specials: NSObject {
    var budz_id  = 0
    var created_at = kEmptyString
     var date = kEmptyString
     var discription = kEmptyString
     var id = 0
     var title = kEmptyString
    var updated_at = kEmptyString
    var user_id = 0
    convenience init(json: [String: AnyObject]?) {
        self.init()
        self.budz_id = json?["budz_id"] as? Int ?? 0
         self.created_at = json?["created_at"] as? String ?? kEmptyString
         self.date = json?["date"] as? String ?? kEmptyString
         self.discription = json?["description"] as? String ?? kEmptyString
         self.id = json?["id"] as? Int ?? 0
         self.title = json?["title"] as? String ?? kEmptyString
         self.updated_at = json?["updated_at"] as? String ?? kEmptyString
         self.user_id = json?["user_id"] as? Int ?? 0
    }
}


class Ticktes: NSObject {
    var created_at  = kEmptyString
    var id = 0
    var image = kEmptyString
    var price  = kEmptyString
    var purchase_ticket_url = kEmptyString
    var sub_user_id = 0
    var title  = kEmptyString
    var updated_at = kEmptyString
    convenience init(json: [String: AnyObject]?) {
        self.init()
        self.created_at = json?["created_at"] as? String ?? kEmptyString
        self.id = json?["id"] as? Int ?? 0
        self.image = json?["image"] as? String ?? kEmptyString
        self.price = json?["price"] as? String ?? kEmptyString
        self.purchase_ticket_url = json?["purchase_ticket_url"] as? String ?? kEmptyString
        self.sub_user_id = json?["sub_user_id"] as? Int ?? 0
        self.updated_at = json?["updated_at"] as? String ?? kEmptyString
        self.title = json?["title"] as? String ?? kEmptyString
    }
}
