//
//  Strain.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class Strain:NSObject, Mappable {

    var strainID: NSNumber?
    var type_id: NSNumber?
    var title: String?
    var overview:String? = kEmptyString
    var approved:NSNumber?
    var created_at:String?
    var updated_at:String?
    var get_review_count:NSNumber?
    var get_likes_count: NSNumber?
    var get_dislikes_count: NSNumber?
    var get_user_like_count: NSNumber?
    var get_user_dislike_count:NSNumber?
    var get_user_flag_count:NSNumber?
    var is_saved_count:NSNumber?
    var strain_id:NSNumber?
    var type_sub_id : NSNumber?
    var get_user_review_count: Int?
    var strainType:StrainType?
    var rating:StrainRating?
    var images:[StrainImage]?
    var get_strain_survey_user_count : NSNumber?
    var madical_conditions : [StrainSurvey]?
    var negative_effects : [StrainSurvey]?
    var preventions : [StrainSurvey]?
    var sensations : [StrainSurvey]?
    var survey_flavors : [StrainSurvey]?
    var strainReview : [StrainReview]?
    
    
    var ans_Madical_conditions : [StrainSurveyAnswers]?
    var ans_Negative_effects : [StrainSurveyAnswers]?
    var ans_Preventions : [StrainSurveyAnswers]?
    var ans_Sensations : [StrainSurveyAnswers]?
    var ans_Survey_flavors : [StrainSurveyAnswers]?
    var matched : Int?
   
    var survey_budz_count : NSNumber?
    
    var strain :Strain?
    
    required init?(map: Map){
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map){
        
        print(map.JSON)
        
        strainID <- map["id"]
        type_id <- map["type_id"]
        type_sub_id <- map["type_sub_id"]
        title <- map["title"]
        overview <- map["overview"]
        approved <- map["approved"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        get_review_count <- map["get_review_count"]
        get_strain_survey_user_count <- map["get_strain_survey_user_count"]
        get_user_review_count<-map["get_user_review_count"]
        if get_review_count == nil {
            
            var newValue : String?
            newValue <- map["get_review_count"]
            
            if  newValue != nil {
                get_review_count = Int(newValue!)! as? NSNumber
            }else {
                get_review_count = 0
            }
            
            
        }
        
        survey_budz_count <- map["survey_budz_count"]
        get_likes_count <- map["get_likes_count"]
        get_dislikes_count <- map["get_dislikes_count"]

        
        if get_likes_count == nil
        {
           get_likes_count = 0
        }
        
        if get_dislikes_count == nil
        {
            get_dislikes_count = 0
        }
        
        if get_user_review_count == nil
        {
            get_user_review_count = 0
        }
        
        get_user_like_count <- map["get_user_like_count"]
        get_user_dislike_count <- map["get_user_dislike_count"]
        get_user_flag_count <- map["get_user_flag_count"]
        is_saved_count <- map["is_saved_count"]
    
        strainType <- map["get_type"]
        rating <- map["rating_sum"]
        
        images <- map["get_images"]
        
        strainReview <- map["get_review"]
        
        
        madical_conditions <- map["madical_conditions"]
        negative_effects <- map["negative_effects"]
        preventions <- map["preventions"]
        sensations <- map["sensations"]
        survey_flavors <- map["survey_flavors"]
        
        ans_Sensations <- map["sensation_answers"]
        ans_Preventions <- map["prevention_answers"]
        ans_Survey_flavors <- map["survey_flavor_answers"]
        ans_Negative_effects <- map["negative_effect_answers"]
        ans_Madical_conditions <- map["madical_condition_answers"]
                
        strain <- map["strain"]
        if  strain?.strainID !=  nil {
            
        }else {
            strain <- map["get_strain"]
        }

    }
    
}
