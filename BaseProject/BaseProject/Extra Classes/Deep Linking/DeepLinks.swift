//
//  DeepLinks.swift
//  DeepLinking
//
//  Created by Joshua Smith on 5/18/17.
//  Copyright © 2017 iJoshSmith. All rights reserved.
//

/// Represents presenting an image to the user.
/// Example - demoapp://show/photo?name=cat
struct ShowPhotoDeepLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term("show")
        .term("photo")
        .queryStringParameters([
            .requiredString(named: "name")
            ])
    
    init(values: DeepLinkValues) {
        imageName = values.query["name"] as! String
    }
    
    let imageName: String
}

/// Represents selecting a tab in the tab bar controller.
/// Example - demoapp://select/tab/1
struct openChat: DeepLink {
    static let template = DeepLinkTemplate()
        .term("select")
        .term("tab")
        .int(named: "index")  
    
    init(values: DeepLinkValues) {
        tabIndex = values.path["index"] as! Int
    }
    let tabIndex: Int
}

/// hbscheme://139.162.37.73/healingbudz_live/get-question-answers/{ID}
struct openQuestionDetail: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
//        .term("healingbudz_live")
        .term("get-question-answers")
        .int(named: "question_id")
    
    init(values: DeepLinkValues) {
        question_id = values.path["question_id"] as! Int
    }
    
    let question_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-shout-out/{ID}
struct openShoutOut: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        //        .term("healingbudz_live")
        .term("get-shout-out")
        .int(named: "shout_out_id")
    
    init(values: DeepLinkValues) {
        shout_out_id = values.path["shout_out_id"] as! Int
    }
    
    let shout_out_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-budz-special/{ID}/{ID}
struct openBudzSpecial: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-budz-special")
        .int(named: "special_id")
        .int(named: "budz_map_id")
    
    init(values: DeepLinkValues) {
        budz_map_id = values.path["budz_map_id"] as! Int
        special_id = values.path["special_id"] as! Int
    }
    
    let budz_map_id: Int
     let special_id: Int
}


//hbscheme://139.162.37.73/healingbudz_live/get-budz-service/{ID}/{ID}
struct openBudzServices: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-budz-service")
        .int(named: "services_id")
        .int(named: "budz_map_id")
    
    init(values: DeepLinkValues) {
        budz_map_id = values.path["budz_map_id"] as! Int
        services_id = values.path["services_id"] as! Int
    }
    
    let budz_map_id: Int
    let services_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-budz-product/{ID}/{ID}
struct openBudzProduct: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-budz-product")
        .int(named: "budz_map_product_id")
        .int(named: "budz_map_id")
    
    init(values: DeepLinkValues) {
        budz_map_id = values.path["budz_map_id"] as! Int
         budz_map_product_id = values.path["budz_map_product_id"] as! Int
    }
    
    let budz_map_id: Int
    let budz_map_product_id : Int
}

//hbscheme://139.162.37.73/healingbudz_live/changepassword?token={token_password}
struct openForgetPassword: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("changepassword")
        .string(named: "token")
    init(values: DeepLinkValues) {
        token = values.path["token"] as! String
    }
    
    let token: String
    

}

//hbscheme://139.162.37.73/healingbudz_live/get-budz-review/{ID}?budz_map_id={ID}
struct openBudzReview: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-budz-review")
         .int(named: "budz_map_review_id")
        .int(named: "budz_map_id")
    
    init(values: DeepLinkValues) {
        budz_map_id = values.path["budz_map_id"] as! Int
        budz_map_review_id = values.path["budz_map_review_id"] as! Int
    }
    
    let budz_map_id: Int
    let budz_map_review_id : Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-budz/{ID}
struct openBudzMapLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-budz")
        .int(named: "budz_map_id")
    
    init(values: DeepLinkValues) {
        budz_map_id = values.path["budz_map_id"] as! Int
    }
    
    let budz_map_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-strain-review/{ID}/{ID}
struct openStrainReview: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-strain-review")
        .int(named: "strain_review_id")
        .int(named: "strain_id")
    
    init(values: DeepLinkValues) {
        strain_review_id = values.path["strain_review_id"] as! Int
        strain_id = values.path["strain_id"] as! Int
    }
    
    let strain_review_id: Int
    let strain_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-strain-product/{ID}/{ID}
struct openStrainProduct: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-strain-product")
        .int(named: "strain_product_id")
        .int(named: "strain_id")
    
    init(values: DeepLinkValues) {
        strain_product_id = values.path["strain_product_id"] as! Int
        strain_id = values.path["strain_id"] as! Int
    }
    
    let strain_product_id: Int
    let strain_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-strain/{ID}
struct openStrainDetail: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-strain")
        .int(named: "strain_id")
    
    init(values: DeepLinkValues) {
        strain_id = values.path["strain_id"] as! Int
    }
    
    let strain_id: Int
}
struct openStrainDetailShow: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("strain-details")
        .int(named: "strain_id")
    
    init(values: DeepLinkValues) {
        strain_id = values.path["strain_id"] as! Int
    }
    
    let strain_id: Int
}

//hbscheme://139.162.37.73/healingbudz_live/get-post/{ID}
struct openPostLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term(Constants.DeepLinkConstant)
        .term("get-post")
        .int(named: "post_id")
    
    init(values: DeepLinkValues) {
        post_id = values.path["post_id"] as! Int
    }
    
    let post_id: Int
}


