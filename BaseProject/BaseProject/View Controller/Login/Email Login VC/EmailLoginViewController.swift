 //
//  EmailLoginViewController.swift
//  BaseProject
//
//  Created by macbook on 08/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import OneSignal
import CoreLocation
class EmailLoginViewController: BaseViewController , GIDSignInUIDelegate  , GIDSignInDelegate, CLLocationManagerDelegate  {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        print(user.description)
//        print(error.localizedDescription)
//        print(signIn.clientID)
        if error == nil && user != nil {
            signUpGoogleuser(objGoogle:user)
        }else{
            self.ShowErrorAlert(message: "Unable to Login with your Google Account, please try again later!")
        }
        
    }
    
    
    @IBOutlet var TF_Name		: UITextField!
    @IBOutlet var TF_Password : UITextField!
    var current_zipcode: String!
    var lat: Double!
    var lng: Double!
    var locationManager: CLLocationManager!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lng = locValue.longitude
        DataManager.sharedInstance.setLocation(loaciton: locValue)
       self.getAddressFromLatLon(pdblLatitude: self.lat,pdblLongitude: self.lng )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.HideHelpPage), name: NSNotification.Name(rawValue: "HideHelpPage"), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: Notifications.googleSignInNotification),
                                               object: nil)
        
        
        
        GIDSignIn.sharedInstance().uiDelegate = self

        
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.value(forKey: "firstView") != nil) {

            if  ((userDefaults.value(forKey: "firstView") as! String) == "0") {
                self.dismiss(animated: false) {
                }
            }else {
                self.ShowTutorialPages()
            }
        }else {
            self.ShowTutorialPages()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = nil

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
            if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
                let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
                userDefaults?.set(DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID ,forKey: "sskey")
                userDefaults?.synchronize()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if (appDelegate.keywords.count == 0 ){
                    self.GetKeywords(completion: {
                        print(appDelegate.keywords)
                    })
                }
                if DataManager.sharedInstance.getPermanentlySavedUser()?.userFirstName == "" {
                    let next = self.GetView(nameViewController: "SocialLoginNickNameViewController", nameStoryBoard: "ProfileView") as! SocialLoginNickNameViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }else {
                    self.ShowMenuBaseView()
                }
                
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receiveAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == Notifications.googleSignInNotification {
          //  self.toggleAuthUI()
            if notification.object != nil {
                guard let userInfo = notification.object  else { return }

                signUpGoogleuser(objGoogle:userInfo as! GIDGoogleUser)
            }
        }
    }
    
    @IBAction func GotoSignupPage(sender : UIButton){
        
        let MainView = self.GetView(nameViewController: "SignUpEmailViewController", nameStoryBoard: "ProfileView")
        
        self.navigationController?.pushViewController(MainView, animated: true)
    }
    
    @IBAction func GotoForgotPasswordPage(sender : UIButton){
        self.PushViewWithIdentifier(name: "ForgotPasswordViewController")
    }
    
    @IBAction func LoginAction(sender : UIButton){
        
        self.PushViewWithIdentifier(name: "SignUpVC")
    }
    
    
    func HideHelpPage(){
        self.dismiss(animated: true) {
            
        }
        
    }
    
    
    func signUpGoogleuser(objGoogle:GIDGoogleUser)
    {
        
        let user = User()
        user.userFirstName = ""//objGoogle.profile.givenName//responseDictionary["name"] as! String
        user.isGoogleID = objGoogle.userID
        if objGoogle.profile.email.isEmpty{
            user.email = objGoogle.userID + "@healingbud.com"
        }else{
            user.email =  objGoogle.profile.email
        }
        let pictureUrl = objGoogle.profile.imageURL(withDimension: 400)
        user.profilePictureURL = (pictureUrl?.absoluteString)!
        
        user.deviceID = DataManager.sharedInstance.deviceToken
        user.deviceType = "ios"
        if self.current_zipcode != nil{
            user.zipcode = self.current_zipcode
        }else{
            user.zipcode = "54000"
        }
        self.view.showLoading()
        
        print(user.toRegisterJSON())
        NetworkManager.PostCall(UrlAPI: WebServiceName.social_login.rawValue, params: user.toRegisterJSON(), completion: { (successResponse, messageResponse, dataResponse) in
            
            self.view.hideLoading()
            print(dataResponse)
            if successResponse{
                if (dataResponse["status"] as! String) == "success" {
                    let is_login = ((dataResponse["successData"] as! [String : Any])["is_new_login"] as! Int)
                    let mainUser = ((dataResponse["successData"] as! [String : Any])["user"] as! [String : AnyObject])
                    
                    let mainSession = ((dataResponse["successData"] as! [String : Any])["session"] as! [String : AnyObject])
                    
                    
                    let userMain = User.init(json: mainUser)
                    userMain.sessionID = mainSession["session_key"] as! String
                    userMain.userlng = String(mainUser["lng"] as? Double ?? 0.0)
                    userMain.userlat = String(mainUser["lat"] as? Double ?? 0.0)
                    
                    userMain.deviceType = mainSession["device_type"] as! String
                    userMain.deviceID = mainSession["device_id"] as? String ?? kEmptyString
                    userMain.isFBID = String(mainSession["fb_id"] as? Double ?? 0.0)
                    userMain.isGoogleID = String(mainSession["g_id"] as? Double ?? 0.0)
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue("0", forKey: "firstView")
                    DataManager.sharedInstance.user = userMain
                    DataManager.sharedInstance.saveUserPermanentally()
                    OneSignal.sendTags(["user_id" :  DataManager.sharedInstance.user!.ID , "device_type" : "ios"])
                    let userDefaultsk = UserDefaults(suiteName: "group.com.healingbudz.ios")
                    userDefaultsk?.set(DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID ,forKey: "sskey")
                    userDefaultsk?.synchronize()
                    if is_login == 0{
                        if user.userFirstName == "" {
                            let next = self.GetView(nameViewController: "SocialLoginNickNameViewController", nameStoryBoard: "ProfileView") as! SocialLoginNickNameViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }else {
                            self.ShowMenuBaseView()
                        }
                        
                    }else{
                        let next = self.GetView(nameViewController: "SocialLoginNickNameViewController", nameStoryBoard: "ProfileView") as! SocialLoginNickNameViewController
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                }else {
                    self.ShowErrorAlert(message: dataResponse["errorMessage"] as! String)
                }
            }else {
                self.ShowErrorAlert(message: messageResponse)
            }
          
            
          
        })
    }
    
    @IBAction func onClickGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
          let googleUser =   GIDSignIn.sharedInstance().currentUser
            if googleUser != nil {
                signUpGoogleuser(objGoogle: GIDSignIn.sharedInstance().currentUser)
                return
            }
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, pdblLongitude: Double) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        let lon: Double = pdblLongitude
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
        
                if (error != nil)
                {
                    
                }else{
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country ?? "")
                        print(pm.locality ?? "")
                        print(pm.subLocality ?? "")
                        print(pm.thoroughfare ?? "")
                        print(pm.postalCode ?? "")
                        print(pm.subThoroughfare ?? "")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                            self.current_zipcode = pm.postalCode!
                        }else{
                            self.current_zipcode = ""
//                            self.ShowErrorAlert(message: "We are not able to find your current location!!")
                        }
                        print(addressString)
                    }else{
//                        self.ShowErrorAlert(message: "We are not able to find your current location!!")
                    }
                }
        })
    }
    
    
    @IBAction func loginWithFacebook(sernder : UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions:[ .publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error): break
            case .cancelled:
                print("User cancelled login.")
            case .success(grantedPermissions: _, declinedPermissions:  _, token:  _):
                let params: [String : Any]? = ["fields": "id, name, email"]
                let graphRequest = GraphRequest(graphPath: "/me", parameters: params!)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {

                            self.showLoading()
                            
                            let user = User()
                            
                            
                            user.isFBID = responseDictionary["id"] as! String
                            user.userFirstName = ""// responseDictionary["name"] as! String
                            if let email =  responseDictionary["email"] as? String{
                                 user.email = email
                            }else{
                                user.email =  String(user.isFBID)// + "@healingbud.com"
                            }
                            
                            
                            if self.current_zipcode != nil{
                                user.zipcode = self.current_zipcode
                            }else{
                                user.zipcode = "54000"
                            }
                            
                            
                            let pictureUrlString = "https://graph.facebook.com/\(user.isFBID)/picture?type=large&return_ssl_resources=1"
                            print(pictureUrlString)
                            user.deviceID = DataManager.sharedInstance.deviceToken
                            user.deviceType = "ios"
                            user.profilePictureURL = pictureUrlString
                            NetworkManager.PostCall(UrlAPI: WebServiceName.social_login.rawValue, params: user.toRegisterJSON(), completion: { (successResponse, messageResponse, dataResponse) in
                                print(dataResponse)
                                self.HideHelpPage()
                                if successResponse{
                                    if (dataResponse["status"] as! String) == "success" {
                                        
                                        let is_login = ((dataResponse["successData"] as! [String : Any])["is_new_login"] as! Int)
                                        let mainUser = ((dataResponse["successData"] as! [String : Any])["user"] as! [String : AnyObject])
                                        
                                        let mainSession = ((dataResponse["successData"] as! [String : Any])["session"] as! [String : AnyObject])
                                        

                                        let userMain = User.init(json: mainUser)
                                        userMain.sessionID = mainSession["session_key"] as! String
                                        userMain.userlng = String(mainUser["lng"] as? Double ?? 0.0)
                                        userMain.userlat = String(mainUser["lat"] as? Double ?? 0.0)
                                        
                                        userMain.deviceType = mainSession["device_type"] as! String
                                        userMain.deviceID = mainSession["device_id"] as? String ?? kEmptyString
                                        userMain.isFBID = String(mainSession["fb_id"] as? Double ?? 0.0)
                                        userMain.isGoogleID = String(mainSession["g_id"] as? Double ?? 0.0)
                                        
                                        DataManager.sharedInstance.user = userMain
                                        DataManager.sharedInstance.saveUserPermanentally()
                                        OneSignal.sendTags(["user_id" :  DataManager.sharedInstance.user!.ID , "device_type" : "ios"])
                                        
                                        let userDefaults = UserDefaults.standard
                                        userDefaults.setValue("0", forKey: "firstView")
                                        
                                        let userDefaultsk = UserDefaults(suiteName: "group.com.healingbudz.ios")
                                        userDefaultsk?.set(DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID ,forKey: "sskey")
                                        userDefaultsk?.synchronize()
                                        if is_login == 0{
                                            if user.userFirstName == "" {
                                                let next = self.GetView(nameViewController: "SocialLoginNickNameViewController", nameStoryBoard: "ProfileView") as! SocialLoginNickNameViewController
                                                self.navigationController?.pushViewController(next, animated: true)
                                            }else {
                                                self.ShowMenuBaseView()
                                            }
                                        }else{
                                            let next = self.GetView(nameViewController: "SocialLoginNickNameViewController", nameStoryBoard: "ProfileView") as! SocialLoginNickNameViewController
                                            self.navigationController?.pushViewController(next, animated: true)
                                        }
                                    }else {
                                        self.ShowErrorAlert(message: dataResponse["errorMessage"] as! String)
                                    }
                                }else {
                                    self.ShowErrorAlert(message: messageResponse)
                                }
                                
                            })

                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    
}

