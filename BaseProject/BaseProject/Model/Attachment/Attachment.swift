//
//  Attachment.swift
//  BaseProject
//
//  Created by waseem on 20/02/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

let kupload_path = "upload_path"
let kposter = "poster"
let kanswer_attachments = "answer_attachments"
let kmedia_type = "media_type"


import Foundation
import UIKit

class Attachment : NSObject {
    
    var  ID = kEmptyString
    var v_pk = kEmptyString
    var  video_URL = kEmptyString
    var  image_URL = kEmptyString
    var  server_URL = kEmptyString
    var  image_Attachment = UIImage()
    var is_Video = false
    var thumb = kEmptyString
    var image_ratio : Double = 1.0
    convenience init(json: [String: AnyObject]?) {
        self.init()
        self.ID            = String(json?[kID] as? Int ?? 0)
        self.v_pk = String(json?["v_pk"] as? String ?? kEmptyString)
        var dataMainType            = json?[kmedia_type] as? String ?? kEmptyString
        
        if (json?[kmedia_type] as? String) != nil {
            dataMainType            = json?[kmedia_type] as? String ?? kEmptyString
        }else {
            dataMainType            = json?["type"] as? String ?? kEmptyString
        }
        if let thumb = json?["thumb"] as? String {
            self.thumb = thumb
        }
        if let urloadPath = json?[kupload_path] as? String {
            self.video_URL             = urloadPath
            if dataMainType == "video" {
                self.image_URL            = json?["poster"] as? String ?? kEmptyString
            }else {
                self.image_URL            = urloadPath
            }
        }else if let urloadPath = json?[kattachment] as? String {
            self.video_URL             = urloadPath
            
            if dataMainType == "video" {
                self.image_URL            = json?["poster"] as? String ?? kEmptyString
            }else {
                self.image_URL            = urloadPath
            }
            
            
            
        }else if let urloadPath = json?["path"] as? String {
            self.video_URL             = urloadPath
            if dataMainType == "video" {
                self.image_URL            = json?["poster"] as? String ?? kEmptyString
            }else {
                self.image_URL            = urloadPath
            }
        }
        
        self.server_URL = json?[kposter] as? String ?? kEmptyString
        
        if let ratio =  json?["ratio"] as? String{
            self.image_ratio = Double(ratio)!
        }else if let ratio_double =  json?["ratio"] as? NSNumber{
            self.image_ratio = ratio_double.doubleValue
        }
        if dataMainType == "video" {
            self.is_Video = true
        }else {
            self.is_Video = false
        }
    }
}
