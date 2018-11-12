//
//  DataManager.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import  CoreLocation
import OneSignal

class DataManager: NSObject {
    var user: User? {
        didSet {
            saveUserPermanentally()
        }
    }
    var gifArray = [GifPostModel]()
    var lastKnownAddress = kEmptyString
    static let sharedInstance = DataManager()
	var APIHitTry = 1


    var supportOptionsArray = [SubUser]()
    var supportSubID:String?
    func getQAPopupStatus()-> Bool{
        
        
        return UserDefaults.standard.bool(forKey: "QAPopup")
    }
    
    func logoutUser() {
//        var keys
        OneSignal.deleteTags(["user_id","device_type"])
//        OneSignal.deleteTag("user_id")
        user = nil
        lastKnownAddress = kEmptyString
		UserDefaults.standard.removeObject(forKey: "user")
        NetworkManager.PostCall(UrlAPI: "offline_user", params: [:]) { (isSuccess, responseString, data) in
            print(data)
        }
    }
    
    var user_locaiton : CLLocationCoordinate2D? = nil
    
    func setLocation(loaciton : CLLocationCoordinate2D )  {
        self.user_locaiton = loaciton
    }
    func saveUserPermanentally() {
        if user != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user!)
            UserDefaults.standard.set(encodedData, forKey: "user")
        }else {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
    func saveGiftData(gifDataArray: [GifPostModel]){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: gifDataArray)
        UserDefaults.standard.set(encodedData, forKey: "gifDataArray")
    }
    func getGiftArray() -> [GifPostModel]{
        if let data = UserDefaults.standard.data(forKey: "gifDataArray"),
            let giftData = NSKeyedUnarchiver.unarchiveObject(with: data) as?  [GifPostModel] {
            return giftData
        } else {
            return []
        }
    }
    
    var deviceToken:String = UIDevice.current.identifierForVendor!.uuidString
    
    func getPermanentlySavedUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: "user"),
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            self.user = userData
            return userData
        } else {
            return nil
        }
    }
}
