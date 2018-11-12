//
//  SignUpEmailViewController.swift
//  BaseProject
//
//  Created by macbook on 05/12/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager

class SignUpEmailViewController: BaseViewController {
    @IBOutlet var TF_Email	: UITextField!
    var textFieldRealYPosition: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User()
        TF_Email.delegate = self
        DataManager.sharedInstance.user = user
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldRealYPosition = textField.frame.origin.y + textField.frame.height
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TF_Email.keyboardType = .emailAddress
        self.delayWithSeconds(1) {
           IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
        }
    }
    
    
    @IBAction func BacktoLoginPage(sender : UIButton){
         IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPassword(sender : UIButton){
        if(TF_Email.text != ""){
            if(self.EmailValidationOnstring(strEmail: TF_Email.text!)){
                self.EmailVerify()
            }
        }else {
            self.ShowErrorAlert(message: "Email Field Required!")
        }
    }
    
    func EmailVerify(){
        
        var paramMain = [String : AnyObject]()
        paramMain["email"] = self.TF_Email.text as AnyObject
        
        self.view.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.check_email_availablity.rawValue, params: paramMain) { (success, messageResponse, mainResponse) in
        
            self.view.hideLoading()
            print("success\(success)")
            print("messageResponse\(messageResponse)")
            print("mainResponse\(mainResponse)")
            
            if success {
                if (mainResponse["status"] as! String == "error") {
                    self.ShowErrorAlert(message:  mainResponse["errorMessage"] as! String)
                }else {
                    NetworkManager.PostCall(UrlAPI: WebServiceName.check_special_email.rawValue, params: paramMain, completion: {(success, messageResponse, mainResponse) in
                        if success {
                            if (mainResponse["status"] as! String == "error") {
                                special = false
                            }else {
                                special = true
                            }
                        }
                    })
                    self.GotoNextView()
                }
            }else {
                self.ShowSuccessAlertWithViewRemove(message: messageResponse)
            }
        }
        
    }
    
    
    func GotoNextView(){
        let user = DataManager.sharedInstance.user
        user?.email = TF_Email.text!
        DataManager.sharedInstance.user = user
        let storyboard = UIStoryboard(name: "ProfileView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpPassword") as! SignUpPasswordVC
        vc.UserEmail = TF_Email.text
        self.navigationController?.pushViewController(vc, animated: true)

    }
  
    
}

public var special = false

