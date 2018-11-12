//
//  ForgotPasswordViewController.swift
//  BaseProject
//
//  Created by Vengile on 23/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

	@IBOutlet var TF_Email	: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        TF_Email.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

	@IBAction func BacktoLoginPage(sender : UIButton){
		_ = self.navigationController?.popViewController(animated: true)
	}
	
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    
    @IBAction func ForgotPassword (sender : UIButton){
        if self.TF_Email.text?.characters.count == 0 {
            self.ShowErrorAlert(message: Alert.kWrongEmail)
        }else if(self.EmailValidation(textField: self.TF_Email)){
            
            self.showLoading()
            let user = User()
            user.email = self.TF_Email.text!
            
            
            
            print(user.toRegisterJSON())
            NetworkManager.PostCall(UrlAPI: WebServiceName.forget_password.rawValue, params: user.toRegisterJSON(), completion: { (successResponse, messageResponse, dataResponse) in
                
                self.hideLoading()
                
                if successResponse{
                    if (dataResponse["status"] as! String) == "success" {
                        
                        
                        self.ShowSuccessAlert(message: "An Email has been sent to your email address. Check your email for further process!")
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
