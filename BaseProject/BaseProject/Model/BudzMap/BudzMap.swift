//
//  BudzMap.swift
//  BaseProject
//
//  Created by MAC MINI on 30/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//
import UIKit

let kinsurance_accepted            = "insurance_accepted"
let koffice_policies            = "office_policies"
let kvisit_requirements             = "visit_requirements"
let kevents                     = "events"


class BudzMap: NSObject, NSCoding {
    var  id = kEmptyInt
    var is_organic = kEmptyString
    var is_delivery = kEmptyString
    var is_featured = kEmptyInt
    var user_id = kEmptyInt
    var business_type_id = kEmptyString
    var get_user_save_count = kEmptyInt
    var lat = kEmptyString
    var lng = kEmptyString
    var distance = kEmptyString
    var rating_sum  = kEmptyString
    var office_Policies  = kEmptyString
    var visit_Requirements  = kEmptyString
    var isFlagged = kEmptyInt
    var title  = kEmptyString
    var sub_user_id  = kEmptyString
    var logo  = kEmptyString
    var banner  = kEmptyString
    var budz_map_description  = kEmptyString
    var location  = kEmptyString
    var phon_number = kEmptyString
    var web = kEmptyString
    var facebook = kEmptyString
    var twitter = kEmptyString
    var email = kEmptyString
    var instagram = kEmptyString
    var created_at = kEmptyString
    var updated_at = kEmptyString
    var stripe_id = kEmptyString
    var card_brand = kEmptyString
    var card_last_four = kEmptyString
    var trial_ends_at = kEmptyString
    var zipCode = kEmptyString
    var reviews = [Reviews]()
    var images = [Images]()
    var textDisplay : String = ""
    var textNamePlan: String = ""
    var isCancled: Bool = false
    var endTime:String = ""
    var others_image:String = ""
    var EventTime  = [BudzEventTime]()
    var languageArray = [BudzLanguage]()
    var  timing =  Timing()
    var budzMapType = BudzMapType()
    var get_user_review_count: Int?
//    var innerBud = BudzMap()
    var Insurance_accepted = kEmptyInt
    var payments = [BudzPayment]()
    var timeStatus = kEmptyString
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(is_organic, forKey: "is_organic")
        aCoder.encode(is_delivery, forKey: "is_delivery")
        aCoder.encode(is_featured, forKey: "is_featured")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(business_type_id, forKey: "business_type_id")
        aCoder.encode(get_user_save_count, forKey: "get_user_save_count")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lng, forKey: "lng")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(rating_sum, forKey: "rating_sum")
        aCoder.encode(office_Policies, forKey: "office_Policies")
        aCoder.encode(visit_Requirements, forKey: "visit_Requirements")
        aCoder.encode(isFlagged, forKey: "isFlagged")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(sub_user_id, forKey: "sub_user_id")
        aCoder.encode(logo, forKey: "logo")
        aCoder.encode(banner, forKey: "banner")
        aCoder.encode(budz_map_description, forKey: "budz_map_description")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(phon_number, forKey: "phon_number")
        aCoder.encode(web, forKey: "web")
        aCoder.encode(facebook, forKey: "facebook")
        aCoder.encode(twitter, forKey: "twitter")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(created_at , forKey: "created_at")
        aCoder.encode(updated_at , forKey: "updated_at")
        aCoder.encode(stripe_id , forKey: "stripe_id")
        aCoder.encode(card_brand , forKey: "card_brand")
        aCoder.encode(card_last_four , forKey: "card_last_four")
        aCoder.encode(trial_ends_at , forKey: "trial_ends_at")
        aCoder.encode(zipCode , forKey: "zipCode")
        aCoder.encode(textDisplay , forKey: "textDisplay")
        aCoder.encode(textNamePlan , forKey: "textNamePlan")
        aCoder.encode(endTime , forKey: "endTime")
        aCoder.encode(get_user_review_count , forKey: "get_user_review_count")
        aCoder.encode(Insurance_accepted , forKey: "Insurance_accepted")
        aCoder.encode(timeStatus , forKey: "timeStatus")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey:"id") as? Int ?? 0
        self.is_organic = aDecoder.decodeObject(forKey:"is_organic") as? String ?? ""
        self.is_delivery = aDecoder.decodeObject(forKey:"is_delivery") as? String ?? ""
        self.is_featured = aDecoder.decodeObject(forKey:"is_featured") as? Int ?? 0
        self.user_id = aDecoder.decodeObject(forKey:"user_id") as? Int ?? 0
        self.business_type_id = aDecoder.decodeObject(forKey:"business_type_id") as? String ?? ""
        self.get_user_save_count = aDecoder.decodeObject(forKey:"get_user_save_count") as? Int ?? 0
        self.lat = aDecoder.decodeObject(forKey:"lat") as? String ?? ""
        self.lng = aDecoder.decodeObject(forKey:"lng") as? String ?? ""
        self.distance = aDecoder.decodeObject(forKey:"distance") as? String ?? ""
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? ""
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? ""
        self.rating_sum = aDecoder.decodeObject(forKey:"rating_sum") as? String ?? ""
        self.office_Policies = aDecoder.decodeObject(forKey:"office_Policies") as? String ?? ""
        self.visit_Requirements = aDecoder.decodeObject(forKey:"visit_Requirements") as? String ?? ""
        self.isFlagged = aDecoder.decodeObject(forKey:"isFlagged") as? Int ?? 0
        self.title = aDecoder.decodeObject(forKey:"title") as? String ?? ""
        self.sub_user_id = aDecoder.decodeObject(forKey:"sub_user_id") as? String ?? ""
        self.logo = aDecoder.decodeObject(forKey:"logo") as? String ?? ""
        self.banner = aDecoder.decodeObject(forKey:"banner") as? String ?? ""
        self.budz_map_description = aDecoder.decodeObject(forKey:"budz_map_description") as? String ?? ""
        self.location = aDecoder.decodeObject(forKey:"location") as? String ?? ""
        self.phon_number = aDecoder.decodeObject(forKey:"phon_number") as? String ?? ""
        self.web = aDecoder.decodeObject(forKey:"web") as? String ?? ""
        self.facebook = aDecoder.decodeObject(forKey:"facebook") as? String ?? ""
        self.twitter = aDecoder.decodeObject(forKey:"twitter") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey:"email") as? String ?? ""
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? ""
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? ""
        self.stripe_id = aDecoder.decodeObject(forKey:"stripe_id") as? String ?? ""
        self.card_brand = aDecoder.decodeObject(forKey:"card_brand") as? String ?? ""
        self.card_last_four = aDecoder.decodeObject(forKey:"card_last_four") as? String ?? ""
        self.trial_ends_at = aDecoder.decodeObject(forKey:"trial_ends_at") as? String ?? ""
        self.textDisplay = aDecoder.decodeObject(forKey:"textDisplay") as? String ?? ""
        self.textNamePlan = aDecoder.decodeObject(forKey:"textNamePlan") as? String ?? ""
        self.endTime = aDecoder.decodeObject(forKey:"endTime") as? String ?? ""
        self.get_user_review_count = aDecoder.decodeObject(forKey:"get_user_review_count") as? Int ?? 0
        self.Insurance_accepted = aDecoder.decodeObject(forKey:"Insurance_accepted") as? Int ?? 0
        self.timeStatus = aDecoder.decodeObject(forKey:"timeStatus") as? String ?? ""
       
        
    }
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        self.id =  json?[kID] as? Int ?? kEmptyInt
         self.is_organic =  String(json?[kis_organic] as? Int ?? 0)
        self.others_image = json?["others_image"] as? String ?? ""
        if let ins = json?[kinsurance_accepted] as? String {
            if(ins == "Yes" || ins == "YES"){
                self.Insurance_accepted = 1
            }else {
                self.Insurance_accepted = 0
            }
        }else {
            self.Insurance_accepted = 0
        }
        if let subs = json?["subscriptions"] as? [String: AnyObject]
        {
            if let endTime = subs["ends_at"] as? String {
                self.isCancled = true
                self.endTime = endTime ?? ""
            }else {
                self.endTime = "CANCEL"
                self.isCancled = false
            }
            if let namee = subs["name"] as? String {
                if namee == "healingbudz" {
                    self.textNamePlan = "Monthly"
                }else if namee == "monthly_plan" {
                    self.textNamePlan = "Monthly"
                }else if namee == "three_months" {
                    self.textNamePlan  = "3 Months"
                }else {
                    self.textNamePlan = "Annually"
                }
                
            }
        }
        
//        self.Insurance_accepted = json?[kinsurance_accepted] as? Int ?? 0
        self.is_delivery =  String(json?[kis_delivery] as? Int ?? 0)
        self.is_featured =  json?["is_featured"] as? Int ?? kEmptyInt
        if let textValue = json?["text"] as? String {
            self.textDisplay = textValue
        }else {
            self.textDisplay = ""
        }
        if let vat = json?[kuser_id] as? Int {
            self.user_id =  json?[kuser_id] as? Int ?? kEmptyInt
        }else {
            self.user_id =  Int(json?[kuser_id] as? String ?? "0")!// ?? kEmptyInt
        }
        
        self.business_type_id =  String(json?["business_type_id"] as? Int ?? 0)
        self.get_user_save_count =  json?["get_user_save_count"] as? Int ?? kEmptyInt
        self.get_user_review_count =  json?["get_user_review_count"] as? Int ?? 0
        self.lat =  String(json?[klat] as? Double ?? 0.0)
        self.lng =  String(json?[klng] as? Double ?? 0.0)
        
        self.sub_user_id =  String(json?["sub_user_id"] as? Int ?? 0)
        self.distance =  String(json?[kdistance] as? String ?? "0.0").FloatValue()
        if let ratingDic = json?["rating_sum"] as? [String : AnyObject] {
            self.rating_sum =  String((ratingDic["total"] as? String ?? "0.0")).FloatValue()
        } else {
            if let ratingDic = json?["rating"] as? String {
                self.rating_sum = ratingDic.FloatValue()                
            } else {
                self.rating_sum = "0.0"
            }
        }
        
        self.title =  json?[ktitle] as? String ?? kEmptyString
        self.email =  json?["email"] as? String ?? kEmptyString
        self.office_Policies =  json?[koffice_policies] as? String ?? kEmptyString
        self.visit_Requirements =  json?[kvisit_requirements] as? String ?? kEmptyString
        self.logo =  json?["logo"] as? String ?? kEmptyString
        self.banner =  json?["banner"] as? String ?? kEmptyString
        self.budz_map_description =  json?[Kdescription] as? String ?? kEmptyString
        self.location =  json?["location"] as? String ?? kEmptyString
        self.phon_number =  json?[kphone] as? String ?? kEmptyString
        self.web =  json?["web"] as? String ?? kEmptyString
        self.isFlagged = json?["is_flaged_count"] as? Int ?? kEmptyInt
        self.facebook =  json?["facebook"] as?String ?? kEmptyString
        self.zipCode =  json?["zip_code"] as?String ?? kEmptyString
        self.twitter =  json?["twitter"] as? String ?? kEmptyString
        self.instagram =  json?["instagram"] as? String ?? kEmptyString
        self.created_at =  json?[kcreated_at] as? String ?? kEmptyString
        self.updated_at =  json?[kupdated_at] as? String ?? kEmptyString
        self.stripe_id =  json?["stripe_id"] as? String ?? kEmptyString
        self.card_brand =  json?["card_brand"] as? String ?? kEmptyString
         self.card_brand =  json?["card_brand"] as? String ?? kEmptyString
        self.card_last_four =  json?["card_last_four"] as? String ?? kEmptyString
        self.trial_ends_at =  json?["trial_ends_at"] as? String ?? kEmptyString
        self.timing =  Timing.init(json: json?["timeing"] as? [String : AnyObject])
        self.budzMapType =  BudzMapType.init(json: json?["get_biz_type"] as? [String : AnyObject])
        
//        if let innBD = json?["bud"] as? [String : AnyObject] {
//            self.innerBud =  BudzMap.init(json: innBD)
//        }
        let reviewData =  json?["review"] as? [[String : AnyObject]]
        if reviewData != nil {
            for indexObj in reviewData! {
                self.reviews.append(Reviews.init(json: indexObj))
            }
        }
        let payment =  json?["paymant_methods"] as? [[String : AnyObject]]
        if payment != nil {
            for indexObj in payment! {
                let method = indexObj["method_detail"] as? [String : AnyObject]
                self.payments.append(BudzPayment.init(json: method))
            }
        }
        let eventTimeData =  json?[kevents] as? [[String : AnyObject]]
        if eventTimeData != nil {
            for indexObj in eventTimeData! {
                self.EventTime.append(BudzEventTime.init(json: indexObj))
            }
        }
        
        
        let imagesData = json?["get_images"] as? [[String : AnyObject]]
        
        if imagesData != nil {
            for indexObj in imagesData! {
                self.images.append(Images.init(json: indexObj))
            }
        }
        
        
        let languageData = json?[klanguages] as? [[String : AnyObject]]
        
        if languageData != nil {
            for indexObj in languageData! {
                self.languageArray.append(BudzLanguage.init(json: indexObj))
            }
        }
        
        
        if self.images.count > 0 {
            if self.banner.characters.count > 0 {
                
            }else {
                self.banner = self.images[0].image_path
            }
        }
        

        self.GetTimeStatus()
        
        
        
        
        if self.stripe_id.characters.count > 0 {
            self.is_featured = 1
        }
    }
    
    
    
    
    
    func GetTimeStatus(){
        let dayWeek = Date().dayNumberOfWeek()
        
        
        var startDate = ""
        var endDate = ""
        

        switch dayWeek! {
        case 0:
            startDate = self.timing.saturday
            endDate = self.timing.sat_end
            break
        case 1:
            startDate = self.timing.sunday
            endDate = self.timing.sun_end
            break
        case 2:
            startDate = self.timing.monday
            endDate = self.timing.mon_end
            break
        case 3:
            startDate = self.timing.tuesday
            endDate = self.timing.tue_end
            break
        case 4:
            
           startDate = self.timing.wednesday
           endDate = self.timing.wed_end
            
            break
        case 5:
            startDate = self.timing.thursday
            endDate = self.timing.thu_end
            break
        case 6:
            startDate = self.timing.friday
            endDate = self.timing.fri_end
            break
            
        default:
            startDate = self.timing.saturday
            endDate = self.timing.sat_end
            break
        }
        
        
        if startDate == "Closed"{
            self.timeStatus = "Closed"
        }else {
            let dateStart = startDate.GetDateObject(formate: "hh:mma")
            let dateEnd = endDate.GetDateObject(formate: "hh:mma")
            
            
            if dateStart > Date()
            {
                self.timeStatus = "Open at " + dateStart.toTimeString()
            }else if dateEnd < Date()
            {
                self.timeStatus = "Closed"
            }else {
                self.timeStatus = "Open until " + dateEnd.toTimeString()
            }
        }
    }
}


class BudzMapType: NSObject {
    var  idType = kEmptyInt
    var title = kEmptyString
    var createdAt = kEmptyString
    var updatedAt = kEmptyString

    
    convenience init(json: [String: AnyObject]?) {
        self.init()


        self.idType = json?[kID] as? Int ?? kEmptyInt
        self.title = json?[ktitle] as? String ?? kEmptyString
        self.createdAt = json?[kcreated_at] as? String ?? kEmptyString
        self.updatedAt = json?[kupdated_at] as? String ?? kEmptyString
        
    }
}
