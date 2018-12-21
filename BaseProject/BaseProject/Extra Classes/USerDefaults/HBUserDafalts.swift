//
//  UserDafalts.swift
//  BaseProject
//
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class HBUserDafalts: NSObject {
   let userDefaults = UserDefaults.standard
   static var sharedInstance  = HBUserDafalts()
    func saveKeywords(array : [String]) {
        userDefaults.set(array, forKey: "keywords")
    }
    
    func getKeyword() -> [String] {
        if let arr = userDefaults.array(forKey: "keywords") as? [String]{
            return arr
        }else{
            return [String]()
        }
    }
    
    
    func saveUserPost(posts : [Post]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: posts)
        userDefaults.set(encodedData, forKey: "user_defaults_posts")
        userDefaults.synchronize()
    }
    
    func getDefaultPosts() -> [Post] {
        if  let decoded  = userDefaults.object(forKey: "user_defaults_posts") as? Data{
            if let posts = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Post]{
                return posts
            }else{
                return [Post]()
            }
        }else{
          return [Post]()
        }
    }
}
