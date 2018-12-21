//
//  ShareViewController.swift
//  HealingBudz
//
//  Created by lucky on 11/12/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
//SLComposeServiceViewController
class ShareViewController: SLComposeServiceViewController {
    let sharedKey = "ImageSharePhotoKey"
    private var urlString: String?
    private var textString: String?
    var ssKey = ""
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
        ssKey = userDefaults?.object(forKey: "sskey") as! String
        userDefaults?.set(self.contentText, forKey: self.sharedKey)
        userDefaults?.synchronize()
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        let contentTypeText = kUTTypeText as String
        
        for attachment in extensionItem.attachments as! [NSItemProvider] {
            if attachment.isURL {
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    let url = results as! URL?
                    self.urlString = url!.absoluteString
//                    self.textView.text = self.urlString
                })
            }
            if attachment.isText {
                attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
                    let text = results as! String
                    self.textString = text
                    _ = self.isContentValid()
                })
            }
        }
//        var mainParam: [String : AnyObject]
//        mainParam = ["description": self.contentText as AnyObject,
//                     "images": "" as AnyObject,
//                     "video": "" as AnyObject,
//                     "poster": "" as AnyObject,
//                     "tagged": "" as AnyObject,
//                     "thumb": "" as AnyObject,
//                     "ratio": "" as AnyObject,
//                     "json_data": "" as AnyObject,
//                     "posting_user": "" as AnyObject,
//                     "repost_to_wall": 1 as AnyObject,
//                     "url": self.contentText as AnyObject]
//        ShareViewController.PostCall(ssKey: ssKey,UrlAPI:"save_post", params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
//            //                    print(responseData)
//            
//        } // api Succe
    }
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
        ssKey = userDefaults?.object(forKey: "sskey") as! String
        userDefaults?.set(self.contentText, forKey: self.sharedKey)
        userDefaults?.synchronize()
//        let url = URL(string: "applinks://dataUrl=\(sharedKey)")
//        var responder = self as UIResponder?
//        let selectorOpenURL = sel_registerName("openURL:")
//        while (responder != nil) {
//            if (responder?.responds(to: selectorOpenURL))! {
//                let _ = responder?.perform(selectorOpenURL, with: url)
//            }
//            responder = responder!.next
//        }
        var txt = self.contentText
        if ((self.urlString != nil) && (self.urlString?.count)! > 0 ){
            txt = self.urlString!
        }else {
            txt = self.contentText
        }
        if (self.contentText.contains("https") || self.contentText.contains("http")) {
            txt = self.contentText
        }
        var url = self.urlString
        if (self.contentText.contains("https") || self.contentText.contains("http")) {
            let desc = contentText
            // extract url
            do {
                
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: desc!, options: [], range: NSRange(location: 0, length: (desc?.utf16.count)!))
                
                if !matches.isEmpty {
                    let range = Range(matches.first!.range, in: desc!)!
                    url = String((desc?[range])!)
                    print(url)
                    if (url?.contains("Https"))!{
                        url = url?.stringByReplacingFirstOccurrenceOfString(target: "H", withString: "h")
                    }
                }
            }
            catch {
                print(error)
            }
        }else {
            url = self.urlString
        }
//        if (url != nil && (url?.count)! > 0 ){
//            if ((url?.contains("https"))! || (url?.contains("http"))!){
////              url = self.urlString
//            }else {
//              url = self.contentText
//            }
//        }else {
//            url = self.contentText
//        }
        
        var mainParam: [String : AnyObject]
            mainParam = ["description": txt as AnyObject,
                         "images": "" as AnyObject,
                         "video": "" as AnyObject,
                         "poster": "" as AnyObject,
                         "tagged": "" as AnyObject,
                         "thumb": "" as AnyObject,
                         "ratio": "" as AnyObject,
                         "json_data": "" as AnyObject,
                         "posting_user": "" as AnyObject,
                         "repost_to_wall": 1 as AnyObject,
                         "url": url as AnyObject]
        ShareViewController.PostCall(ssKey: ssKey,UrlAPI:"save_post", params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
                    //                    print(responseData)
            
        } // api Succe
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
extension ShareViewController {
    private class func simpleURLRequest(ssKey:String,path: String,method : String ,params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_ success: Bool, _ message: String, _ response: [String: AnyObject]?) -> Void) {
        if true{
            var webserviceName =  path
            webserviceName = webserviceName.replacingOccurrences(of: " ", with: "%20")
            webserviceName = webserviceName.replacingOccurrences(of: "£", with: "")
            webserviceName = webserviceName.replacingOccurrences(of: "‘", with: "")
            webserviceName = webserviceName.replacingOccurrences(of: "\'", with: "")
            webserviceName = webserviceName.replacingOccurrences(of: "\"", with: "")
            webserviceName = webserviceName.replacingOccurrences(of: "’", with: "")
            webserviceName = webserviceName.replacingOccurrences(of: "’", with: "")
            //’
            print(webserviceName)
            let request = NSMutableURLRequest(url: NSURL(string: webserviceName)! as URL)
            let session = URLSession.shared
            request.httpMethod = method
            if(params != nil){
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: params! as [String : AnyObject], options: [])
            }
            
            
            
            request.addValue(ssKey, forHTTPHeaderField:"session_token" )
            request.addValue("4m9Nv1nbyLoaZAMyAhQri9BUXBxlD3yQxbAiHsn2hwQ=", forHTTPHeaderField:"app_key" )
            
            
            print("URLMain \(webserviceName)")
            
            
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                if error == nil  && data != nil{
                    if let objectRecive = self.nsdataToJSON(data: (data)!) as? [String : Any]{
                        //                        print("Api Response \(objectRecive)")
                        completion(true, "", objectRecive as [String : AnyObject])
                    }else{
                        completion(false, kServerNotReachableMessage, ["":"" as AnyObject] )
                    }
                }else {
                    completion(false, kServerNotReachableMessage, ["":"" as AnyObject] )
                }
            }
            )
            
            task.resume()
        }else {
            
            completion(false, kServerNotReachableMessage, [:])
        }
    }
    
    class func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            
            
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            //            print(myJSONError)
        }
        return nil
    }
    class func PostCall(ssKey:String,UrlAPI: String ,params: [String : AnyObject], completion: @escaping (_ success: Bool, _ message: String , _ response: [String: AnyObject]) -> Void ) {
        
        print(params)
        self.simpleURLRequest(ssKey:ssKey,path:(kBaseURLString + UrlAPI), method: "POST", params: params){ (success, message, response) -> Void in
            DispatchQueue.main.async {
                completion(success, message , response!)
            }
        }
    }
}
extension NSItemProvider {
    
    var isURL: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }
    
    var isText: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeText as String)
    }
    
}
extension String
{
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}

