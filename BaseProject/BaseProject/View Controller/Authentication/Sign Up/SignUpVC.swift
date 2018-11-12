//
//  SignUpVC.swift
//  BaseProject
//
//  Created by Vengile on 14/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager

class SignUpVC: BaseViewController {

	@IBOutlet var TF_Email	: UITextField!
		
    override func viewDidLoad() {
        super.viewDidLoad()
        TF_Email.delegate = self
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func viewWillAppear(_ animated: Bool) {

	}

	
	@IBAction func BacktoLoginPage(sender : UIButton){
		_ = self.navigationController?.popViewController(animated: true)
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SigninPasswordVC") as! SigninPasswordVC
                    vc.UserEmail = self.TF_Email.text
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                   self.ShowErrorAlert(message:  "Invalid email address!")
                }
            }else {
                self.ShowSuccessAlertWithViewRemove(message: messageResponse)
            }
        }
        
    }
    @IBAction func showPassword(sender : UIButton){
        
        
        
        if(TF_Email.text != ""){
            if(self.EmailValidationOnstring(strEmail: TF_Email.text!)){
                self.EmailVerify()
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "SigninPasswordVC") as! SigninPasswordVC
//                vc.UserEmail = TF_Email.text
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            self.ShowErrorAlert(message: "Email Field Required!")
        }
    }
    
    
	
    
}
