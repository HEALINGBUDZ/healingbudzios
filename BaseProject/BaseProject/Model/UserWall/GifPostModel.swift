//
//  GifPostModel.swift
//  BaseProject
//
//  Created by lucky on 10/8/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class GifPostModel: NSObject ,NSCoding{
    var url:String?
    var gifData : Data?
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(gifData, forKey: "gifData")
    }
    required convenience init?(coder aDecoder: NSCoder) {
            self.init()
            self.url = aDecoder.decodeObject(forKey:"url") as? String ?? nil
            self.gifData = aDecoder.decodeObject(forKey:"gifData") as? Data ?? nil
    }
}
