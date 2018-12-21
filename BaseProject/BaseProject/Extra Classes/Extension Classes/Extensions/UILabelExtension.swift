//
//  UILabelExtension.swift
//  BaseProject
//
//  Created by MAC MINI on 18/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation
import ActiveLabel
extension ActiveLabel{
    func applyTag(baseVC  : BaseViewController , mainText : String = "") {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        var newArray = [Any]()
        var keywords_array = appdelegate.keywords
//        for obj in keywords_array{
//            keywords_array.append("#"+obj)
//            keywords_array.append("("+obj+")")
//            keywords_array.append("."+obj)
//            keywords_array.append(","+obj)
//            keywords_array.append(obj+",")
//            keywords_array.append(obj+" ")
//            keywords_array.append(" "+obj)
//        }
        // aply tag set fisrt text is init
        for indexObj in keywords_array {
            if mainText.lowercased().contains(indexObj.lowercased()){
                let customType = ActiveType.custom(pattern: String.init(format: "^%@\\b",indexObj))//\\s
                self.customColor[customType] = Constants.kTagColor
                newArray.append(customType)
                self.handleCustomTap(for: customType) {
                    baseVC.ShowKeywordPopUp(value: $0)
                }
                //|\\s%@\\b
                let customTypeT = ActiveType.custom(pattern: String.init(format: "\\s%@\\b",indexObj))//\\s
                self.customColor[customTypeT] = Constants.kTagColor
                newArray.append(customTypeT)
                self.handleCustomTap(for: customTypeT) {
                    baseVC.ShowKeywordPopUp(value: $0)
                }
                let customTypeST = ActiveType.custom(pattern: String.init(format: "^%@",indexObj))//\\s
                self.customColor[customTypeST] = Constants.kTagColor
                newArray.append(customTypeST)
                self.handleCustomTap(for: customTypeST) {
                    baseVC.ShowKeywordPopUp(value: $0)
                }
            }
            
        }
        newArray.append(ActiveType.url)
        self.customColor[ActiveType.url] = UIColor.init(hex: "808080")
        self.URLColor = Constants.kTagColor
        self.handleURLTap { (url) in
            if (url.absoluteString.contains("youtube.com")) || (url.absoluteString.contains("youtu.be")) {
                baseVC.present(YoutubePlayerVC.PlayerVC(url: url), animated: true, completion: nil)
            }
            else{
               baseVC.OpenUrl(webUrl: url)
            }
        }
        self.enabledTypes = newArray as! [ActiveType]
    }
    
    func createMentions(array : [String], color : UIColor ,complition : @escaping(_ word : String) -> Void) {
         var newArray = [Any]()
        for indexObj in  array{
            let customType = ActiveType.custom(pattern: indexObj)
            if indexObj == Constants.SeeMore{
                self.customColor[customType] = Constants.kTagColor
            }else{
               self.customColor[customType] = color
            }
            newArray.append(customType)
            self.handleCustomTap(for: customType) {
                complition($0)
            }
        }
        newArray.append(ActiveType.url)
        self.customColor[ActiveType.url] = UIColor.init(hex: "808080")
        self.URLColor = UIColor.init(hex: "808080")
        self.handleURLTap { (url) in
            var urlToCall = url
            if !url.absoluteString.hasPrefix("http"){
                urlToCall = URL(string: "http://" + url.absoluteString)!
            }
            if (urlToCall.absoluteString.contains("youtube.com")) || (urlToCall.absoluteString.contains("youtu.be")) {
                AppDelegate.appDelegate().active_navigation_controller?.present(YoutubePlayerVC.PlayerVC(url: urlToCall), animated: true, completion: nil)
            }else if (urlToCall.absoluteString.contains(Constants.ShareLinkConstant)) {
                AppDelegate.appDelegate().executeDeepLink(with: urlToCall)
            }else{
                UIApplication.shared.open(urlToCall)
            }
        }
        self.enabledTypes = newArray as! [ActiveType]
    }
    
    func createMentionsApplyTag(array : [String], color : UIColor ,complition : @escaping(_ word : String) -> Void) {
        var newArray = [Any]()
        for indexObj in  array{
            let customType = ActiveType.custom(pattern: indexObj)
            if indexObj == Constants.SeeMore{
                self.customColor[customType] = Constants.kTagColor
            }else{
                self.customColor[customType] = color
            }
            newArray.append(customType)
            self.handleCustomTap(for: customType) {
                complition($0)
            }
        }
        newArray.append(ActiveType.url)
        self.customColor[ActiveType.url] = color
        self.URLColor =  color
        self.handleURLTap { (url) in
            var urlToCall = url
            if !url.absoluteString.hasPrefix("http"){
                urlToCall = URL(string: "http://" + url.absoluteString)!
            }
            if (urlToCall.absoluteString.contains("youtube.com")) || (urlToCall.absoluteString.contains("youtu.be")) {
                AppDelegate.appDelegate().active_navigation_controller?.present(YoutubePlayerVC.PlayerVC(url: urlToCall), animated: true, completion: nil)
            }else if (urlToCall.absoluteString.contains(Constants.ShareLinkConstant)) {
                AppDelegate.appDelegate().executeDeepLink(with: urlToCall)
            }else{
                UIApplication.shared.open(urlToCall)
            }
        }
        self.enabledTypes = newArray as! [ActiveType]
    }
}

