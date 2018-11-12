 //
//  NetworkManager.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import WebKit
import GCNetworkReachability
import CoreLocation
import Alamofire
 
class NetworkManager: NSObject {
    
    class func isNetworkReachable() -> Bool {
        let reachablity = GCNetworkReachability(internetAddressString: kBaseURLString)
        let reachable = reachablity?.isReachable()
        reachablity?.stopMonitoringNetworkReachability()
        return reachable!
    }
	
    
    private class func simpleURLRequest(path: String,method : String ,params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_ success: Bool, _ message: String, _ response: [String: AnyObject]?) -> Void) {
        if NetworkManager.isNetworkReachable() {
            var webserviceName =  path
            webserviceName = webserviceName.RemoveSpace()
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
            
            
            
            if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
                if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
                    request.addValue((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!, forHTTPHeaderField:"session_token" )
                    print("session_token \((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!)")
                }
            }
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
	
    //MARK:
    //MARK: Maps Google API
    
    
    class func getUserAddressFromZipCode(zipcode: String, completion: @escaping (_ success: Bool, _ message: String, _ response: [String: AnyObject]?) -> Void ) {
//        let path =  "https://maps.google.com/maps/api/geocode/json?key=AIzaSyAfFBUJJB6b40QkWOmlkCOCJGxWeU29hbE&&components=country%3a"+"USA"+"%7Cpostal_code:"+zipcode+"&sensor=true"
        
//          let path =  "https://maps.google.com/maps/api/geocode/json?key=AIzaSyB1v06JaOpoyATQJKGIu0lnQ5kfJ7bkaSc&&components=country%3a"+"USA"+"%7Cpostal_code:"+zipcode+"&sensor=true"
        let path =  "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCiDgdLD46NLVGAV3AKcEZt4DKTtCeprQE&&components=country%3a"+"USA"+"%7Cpostal_code:"+zipcode+"&sensor=true"
        self.simpleURLRequest(path:path, method: "POST", params: nil){ (success, message, response) -> Void in
            DispatchQueue.main.async {
                completion(success, message , response)
                
            }
        }
    }

    //MARK:
    //MARK: APIS

	
    class func PostCall(UrlAPI: String ,params: [String : AnyObject], completion: @escaping (_ success: Bool, _ message: String , _ response: [String: AnyObject]) -> Void ) {
        
        print(params)
        self.simpleURLRequest(path:(kBaseURLString + UrlAPI), method: "POST", params: params){ (success, message, response) -> Void in
            DispatchQueue.main.async {
                completion(success, message , response!)
            }
        }
	}
    
    
    class func GetCall(UrlAPI: String ,params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_ success: Bool, _ message: String , _ response: [String: AnyObject]) -> Void ) {
        
        
        
        self.simpleURLRequest(path:(kBaseURLString + UrlAPI), method: "GET", params: params){ (success, message, response) -> Void in
            DispatchQueue.main.async {
                completion(success, message , response!)
            }
        }
    }
    
    class func CallGetWithoutBaseURL(UrlAPI: String ,params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_ success: Bool, _ message: String , _ response: [String: AnyObject]) -> Void ) {
        
        
        self.simpleURLRequest(path: UrlAPI, method: "GET", params: params){ (success, message, response) -> Void in
            DispatchQueue.main.async {
                completion(success, message , response!)
            }
        }
    }
    
    
    class  func UploadFiles(_ URLString: String,image: UIImage, gif_url:URL? = nil, withParams parameters: Dictionary<String, AnyObject>? = nil , onView parentView: UIViewController, completion: @escaping ([AnyHashable: Any]!) -> Void)  {
        if NetworkManager.isNetworkReachable() {
            var headers = [String: String]()
            
            if let userSession = DataManager.sharedInstance.user?.sessionID {
                headers["session_token"] =  userSession
            }
            
            headers["app_key"] = "4m9Nv1nbyLoaZAMyAhQri9BUXBxlD3yQxbAiHsn2hwQ="
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if gif_url != nil {
                    if gif_url!.lastPathComponent.contains(".gif"){
                        multipartFormData.append(gif_url!, withName: "image", fileName: String(Date().millisecondsSince1970) + ".gif", mimeType: "image/gif")
                    }else{
                        multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "image", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
                    }
                }else{
                    multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "image", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
                }
                
                print(parameters)
                if parameters != nil {
                    if parameters!.keys.count > 0 {
                        for (key, value) in parameters! {
                            if let stringValue = value as? String{
                                multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                                
                            }else if let stringValue = value as? Double{
                                  multipartFormData.append(String(stringValue).data(using: String.Encoding.utf8)!, withName: key)
                            }else if let stringValue = value as? Int{
                                multipartFormData.append(String(stringValue).data(using: String.Encoding.utf8)!, withName: key)
                            }
                        }
                    }
                }
                
                
            }, to:URLString , headers: headers )
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
//                        print(response.response)
//                        print(response)
                        if response.result.value != nil {
                            var completionVarible = [NSObject : AnyObject]()
                            completionVarible = response.result.value as! [AnyHashable: Any]! as [NSObject : AnyObject]
                            print("Response: \(completionVarible)")
                            completion(completionVarible)
                        }
                    }
                case .failure( _):
                    let mainResponse = ["status" : "error" , "Message" : kServerNotReachableMessage] as [String : Any]
                    completion(mainResponse)
                    break
                    
                }
            }
        }else {
            let mainResponse = ["status" : "error" , "Message" : kServerNotReachableMessage] as [String : Any]
            completion(mainResponse)
        }
    }
    
    
    class  func Cancel(){
//        Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }
    
    class  func UploadVideo(_ URL: String, imageMain : UIImage? = nil, urlVideo: URL,  withParams parameters: Dictionary<String, AnyObject>? = nil, onView parentView: UIViewController, completion: @escaping ([AnyHashable: Any]!) -> Void)  {
        if NetworkManager.isNetworkReachable(){
            let URLString = kBaseURLString + URL
            
            var headers = [String: String]()
            
            if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
                if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
                    headers["session_token"] = (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)
                }
            }
            
            headers["app_key"] = "4m9Nv1nbyLoaZAMyAhQri9BUXBxlD3yQxbAiHsn2hwQ="
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if imageMain != nil{
                    multipartFormData.append(UIImageJPEGRepresentation(imageMain!, 0.5)!, withName: "poster", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
                }
                multipartFormData.append(urlVideo, withName: "video")
                if parameters != nil {
                    if parameters!.keys.count > 0 {
                        for (key, value) in parameters! {
                            let stringValue = value as! String
                            multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                }
                
            }, to:URLString , headers: headers )
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
//                        print(response.response)
//                        print(response)
                        if response.result.value != nil {
                            //                        self.hideLoadingView(parentView.view)
                            var completionVarible = [NSObject : AnyObject]()
                            completionVarible = response.result.value as! [AnyHashable: Any]! as [NSObject : AnyObject]
//                            print("Response: \(completionVarible)")
                            completion(completionVarible)
                        }
                    }
                case .failure( _):
                    completion(["status" : "failed" , "errorMessage" : "Server Time Out"])
                    print("failure")
                    break
                }
            }
        }else {
            let mainResponse = ["status" : "error" , "Message" : kServerNotReachableMessage] as [String : Any]
            completion(mainResponse)
        }
    }
}
 
 
 
