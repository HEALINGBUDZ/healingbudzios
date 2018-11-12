//
//  ChangePasswordVCViewController.swift
//  BaseProject
//
//  Created by MN on 12/09/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager
class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var user_password: BaseImageTextField!
    @IBOutlet weak var user_confirm_password: BaseImageTextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var eyeConfirmButton: UIButton!
    var token = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user_confirm_password.delegate = self
        self.user_password.delegate = self
        self.user_password.tag = 100
    }
    
    @IBAction func showPasswordEyeClick(sender: UIButton!){
        if !((user_password.text?.isEmpty)!){
            if user_password.isSecureTextEntry{
                user_password.isSecureTextEntry = false
                sender.setImage(#imageLiteral(resourceName: "passwordEyeHide"), for: .normal)
            }else{
                user_password.isSecureTextEntry = true
                sender.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 100{
            textField.isSecureTextEntry = true
            eyeButton.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
        }else{
            textField.isSecureTextEntry = true
            eyeConfirmButton.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
        }
    }
    
    @IBAction func showConfirmPasswordEyeClick(sender: UIButton!){
        if !((user_confirm_password.text?.isEmpty)!){
            if user_confirm_password.isSecureTextEntry{
                user_confirm_password.isSecureTextEntry = false
                sender.setImage(#imageLiteral(resourceName: "passwordEyeHide"), for: .normal)
            }else{
                user_confirm_password.isSecureTextEntry = true
                sender.setImage(#imageLiteral(resourceName: "passwordEye"), for: .normal)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.delayWithSeconds(1) {
            IQKeyboardManager.shared().keyboardDistanceFromTextField = 150
        }
        
    }
    
    @IBAction func BacktoLoginPage(sender : UIButton){
        let next = self.GetView(nameViewController: "LoginVC", nameStoryBoard: "Main")
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func changePaswordAction(sender: UIButton!){
        if !((user_password.text?.isEmpty)!){
            if !((user_confirm_password.text?.isEmpty)!){
                if user_confirm_password.text == user_confirm_password.text{
                 self.showLoading()
                    var param = [String: AnyObject]()
                    if token != ""{
                        param["token"] = self.token as AnyObject
                    }else{
                    simpleCustomeAlert(title: "", discription: "something went wrong please try again")
                    return
                    }
                    param["password"] = self.user_password.text as AnyObject
                    NetworkManager.PostCall(UrlAPI: WebServiceName.update_password.rawValue, params: param, completion: {(success, message, response) in
                        self.hideLoading()
                        print(response)
                        if success{
                            if let status = response["status"] as? String{
                                if status == "success"{
                                    self.simpleCustomeAlert(title: "", discription: "password reset")
                                    let next = self.GetView(nameViewController: "LoginVC", nameStoryBoard: "Main")
                                    self.navigationController?.pushViewController(next, animated: true)
                                }else{
                                    self.simpleCustomeAlert(title: "", discription: message)
                                }
                            }else{
                                   self.simpleCustomeAlert(title: "", discription: message)
                            }
                        }else{
                               self.simpleCustomeAlert(title: "", discription: message)
                        }
                        
                    })
                }else{
                    simpleCustomeAlert(title: "", discription: "confirm password is different than password")
                }
            }else{
            simpleCustomeAlert(title: "", discription: "confirm password field is requierd")
            }
        }else{
            simpleCustomeAlert(title: "", discription: "password field is requierd")
        }
    }

}
