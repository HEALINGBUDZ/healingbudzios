//
//  SigninPasswordVC.swift
//  BaseProject
//
//  Created by macbook on 08/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import Crashlytics
import OneSignal
import IQKeyboardManager
class SigninPasswordVC: BaseViewController {
    var UserEmail:String!
    @IBOutlet var TF_Password	: UITextField!
    @IBOutlet weak var TF_user_email: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TF_user_email.text = UserEmail
        self.TF_Password.delegate = self
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
    }
    
    // For Text Crash
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //		UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.delayWithSeconds(1) {
            IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
        }
        
        
     }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
        eyeButton.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
    }
    
    @IBAction func showPasswordEyeClick(sender: UIButton!){
        if self.TF_Password.text != nil && self.TF_Password.text!.count > 0 {
            if TF_Password.isSecureTextEntry{
                TF_Password.isSecureTextEntry = false
                sender.setImage(#imageLiteral(resourceName: "passwordEyeHide"), for: .normal)
            }else{
                TF_Password.isSecureTextEntry = true
                sender.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
            }
        }  
    }
    
    @IBAction func BacktoLoginPage(sender : UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func GotoDashBoard(sender : UIButton){
        if(TF_Password.text != ""){
            if (TF_Password.text?.characters.count)! >= 6{
                self.view.showLoading()

            var paramMain = [String : AnyObject]()
            paramMain["email"] = TF_user_email.text as AnyObject
            paramMain["password"] = TF_Password.text as AnyObject
            paramMain["device_id"] = DataManager.sharedInstance.deviceToken as AnyObject
            paramMain["device_type"] = "ios" as AnyObject
            print(paramMain)
            NetworkManager.PostCall(UrlAPI: WebServiceName.login.rawValue, params: paramMain, completion: { (successMain, successMessage, successResponse) in
                self.view.hideLoading()
                print(successResponse)
                if successMain{
                    if (successResponse["status"] as! String) == "success" {
                        let mainUser = ((successResponse["successData"] as! [String : Any])["user"] as! [String : AnyObject])
                        let mainSession = ((successResponse["successData"] as! [String : Any])["session"] as! [String : AnyObject])
                        print(mainSession)
                        let userMain = User.init(json: mainUser)
                      
                        userMain.sessionID = mainSession["session_key"] as! String
                        userMain.userlng = String(mainUser["lng"] as? Double ?? 0.0)
                        userMain.userlat = String(mainUser["lat"] as? Double ?? 0.0)
                        
                        userMain.deviceType = mainSession["device_type"] as! String
                        userMain.deviceID = mainSession["device_id"] as? String ?? kEmptyString
                        userMain.isFBID = String(mainSession["fb_id"] as? Double ?? 0.0)
                        userMain.isGoogleID = String(mainSession["g_id"] as? Double ?? 0.0)
                        
                        print(userMain.userlat)
                        print(userMain.userlng)
                        DataManager.sharedInstance.user = userMain
                        print(DataManager.sharedInstance.user?.showBudzPopup)
                        DataManager.sharedInstance.saveUserPermanentally()
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue("0", forKey: "firstView")
                        OneSignal.sendTags(["user_id" :  DataManager.sharedInstance.user!.ID , "device_type" : "ios"])
                        
                        self.ShowMenuBaseView()
                    }else {
                        self.ShowErrorAlert(message: successResponse["errorMessage"] as! String)
                    }
                }else {
                    
                }
                
            })
            }else{
                self.ShowErrorAlert(message: "Enter Password must be 6 character!")
            }
        }
        
        
    }
}
