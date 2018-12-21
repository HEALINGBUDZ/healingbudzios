//
//  NetworkEngine.swift
//  BaseProject
//
//  Created by Ikarma Khan on 18/07/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MKNetworkKit

class NetworkEngine: Host {

    private struct Static {
        static let instance : NetworkEngine = NetworkEngine()  //static one instance only
    }
    
    class func shared() -> NetworkEngine {
        return Static.instance   // return the shared instance
    }
    
    init() {
        super.init(name: "http://ec2-52-37-222-254.us-west-2.compute.amazonaws.com:8898/")
//        super.init(name: "http://52.40.203.98:8898")

        defaultParameterEncoding = .JSON
    }
    
    func getServerRequest(isReponseinArray: Bool, jsonParam: [String: AnyObject]?, webserviceName: String ,completion: @escaping (_ success: Bool, _ message: String, _ response: [[String: AnyObject]]?) -> Void) {
        
        
        let json = jsonParam
        var headers = [String:String] ()
        headers["Content-Type"] = "application/json"
        if NetworkManager.isNetworkReachable() {
            let postURLString = kBaseURLString + webserviceName
            
            if let userSession = DataManager.sharedInstance.user?.sessionID {
                headers[kSessionKey] = "Bearer " + userSession
            }
            
            print(headers)
            self.request(.GET, withAbsoluteURLString: postURLString, parameters: json!, headers: headers, bodyData: nil)?.completion { completedRequest in
                DispatchQueue.main.async {
                 print(completedRequest.responseAsJSON ?? "Hello")
                    
                    if (completedRequest.error == nil) {
//                        print(isReponseinArray)
//                        print(completedRequest.responseAsJSON!)
                        
                        if isReponseinArray {
                            completion(true, "", completedRequest.responseAsJSON as? [[String : AnyObject]])
                        }else {
                            
                            var objectData = [[String : Any]]()
                            objectData.append(completedRequest.responseAsJSON as! [String : Any])
                            
                            completion(true, "", objectData as [[String : AnyObject]]?)
                        }
                        
                        
                    }
                    else {
//                        completion(false, kServerNotReachableMessage, nil)
                        completion(false, (completedRequest.error?.description)!, nil)
                    }
                    
                }
                
                }.run()
            
        }else {
            completion(false, kServerNotReachableMessage, nil)
        }

    }

    
    
    func PostServerRequest( isReponseinArray: Bool, jsonParam: [String: AnyObject]?, webserviceName: String ,completion: @escaping (_ success: Bool, _ message: String, _ response: [[String: AnyObject]]?) -> Void) {
        
        
        let json = jsonParam
        var headers = [String:String] ()
        headers["Content-Type"] = "application/json"
        if NetworkManager.isNetworkReachable() {
            let postURLString = kBaseURLString + webserviceName
            
            if let userSession = DataManager.sharedInstance.user?.sessionID {
                headers[kSessionKey] = "Bearer " + userSession
            }
            
            print(headers)
            self.request(.POST, withAbsoluteURLString: postURLString, parameters: json!, headers: headers, bodyData: nil)?.completion { completedRequest in
                DispatchQueue.main.async {
//                    print(completedRequest.responseAsJSON ?? "Hello")
                    
                    
                    if (completedRequest.error == nil) {
//                        print(isReponseinArray)
//                        print(completedRequest.responseAsJSON!)
                        
                        if isReponseinArray {
                            completion(true, "", completedRequest.responseAsJSON as? [[String : AnyObject]])
                        }else {
                            
                            var objectData = [[String : Any]]()
                            objectData.append(completedRequest.responseAsJSON as! [String : Any])
                            
                            completion(true, "", objectData as [[String : AnyObject]]?)
                        }
                        
                        
                    }
                    else {
//                        completion(false, kServerNotReachableMessage, nil)
                        completion(false, (completedRequest.error?.description)!, nil)
                    }
                    
                }
                
                }.run()
            
        }else {
            completion(false, kServerNotReachableMessage, nil)
        }
        
    }

    
    func PutServerRequest(isReponseinArray: Bool, jsonParam: [String: AnyObject]?, webserviceName: String ,completion: @escaping (_ success: Bool, _ message: String, _ response: [[String: AnyObject]]?) -> Void) {
        
        
        let json = jsonParam
        var headers = [String:String] ()
        headers["Content-Type"] = "application/json"
        if NetworkManager.isNetworkReachable() {
            let postURLString = kBaseURLString + webserviceName
            
            if let userSession = DataManager.sharedInstance.user?.sessionID {
                headers[kSessionKey] = "Bearer " + userSession
            }
            
            
            
            print(headers)
            print(json!)
            print(postURLString)
            self.request(.PUT, withAbsoluteURLString: postURLString, parameters: json!, headers: headers, bodyData: nil)?.completion { completedRequest in
                DispatchQueue.main.async {
                    print(completedRequest.responseAsJSON ?? "Hello")
                    
                    if (completedRequest.error == nil) {
//                        print(isReponseinArray)
//                        print(completedRequest.responseAsJSON!)
                        
                        if isReponseinArray {
                            completion(true, "", completedRequest.responseAsJSON as? [[String : AnyObject]])
                        }else {
                            
                            var objectData = [[String : Any]]()
                            objectData.append(completedRequest.responseAsJSON as! [String : Any])
                            
                            completion(true, "", objectData as [[String : AnyObject]]?)
                        }
                        
                        
                    }
                    else {
                        completion(false, (completedRequest.error?.description)!, nil)
                    }
                    
                }
                
                }.run()
            
        }else {
            completion(false, kServerNotReachableMessage, nil)
        }
        
    }
    
    
    
    func getServerImage( jsonParam: [String: AnyObject]?, webserviceName: String ,completion: @escaping (_ success: Bool, _ imageRecive : UIImage,_ message: String, _ response: [[String: AnyObject]]?) -> Void) {
        
        print("webserviceName")
        print(webserviceName)
        let json = jsonParam
        var headers = [String:String] ()
        headers["Content-Type"] = "image/jpeg"
        if NetworkManager.isNetworkReachable() {
            let postURLString =  webserviceName
            
            if let userSession = DataManager.sharedInstance.user?.sessionID {
                headers[kSessionKey] = "Bearer " + userSession
            }
            
            print(postURLString)
            print(headers)
            self.request(.GET, withAbsoluteURLString: postURLString, parameters: json!, headers: headers, bodyData: nil)?.completion { completedRequest in
                DispatchQueue.main.async {
//                    print(completedRequest.responseAsImage() ?? "Hello")
                    
                    if (completedRequest.error == nil) {
                        
                        
                        let imageMain = completedRequest.responseAsImage()
                        
                        
//                        if isReponseinArray {
                            completion(true,imageMain!, "", completedRequest.responseAsJSON as? [[String : AnyObject]])
//                        }else {
//                            
//                            var objectData = [[String : Any]]()
//                            objectData.append(completedRequest.responseAsJSON as! [String : Any])
//                            
//                            completion(true, "", objectData as [[String : AnyObject]]?)
//                        }
                        
                        
                    }
                    else {
                        //                        completion(false, kServerNotReachableMessage, nil)
                        completion(false, UIImage.init(named: "save")! , (completedRequest.error?.description)!, nil)
                    }
                    
                }
                
                }.run()
            
        }else {
            completion(false, UIImage.init(named: "save")!, kServerNotReachableMessage, nil)
        }
        
    }

}
