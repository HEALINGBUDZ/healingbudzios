//
//  SignUpPasswordVC.swift
//  BaseProject
//
//  Created by Jawad ali on 1/2/18.
//  Copyright © 2018 Wave. All rights reserved.
//
import UIKit
import IQKeyboardManager
class SignUpPasswordVC: BaseViewController  {
     var UserEmail:String!
    @IBOutlet weak var user_confirm_password: BaseImageTextField!
    @IBOutlet weak var user_password: BaseImageTextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var eyeConfirmButton: UIButton!
    @IBOutlet weak var user_email: UILabel!
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
            self.user_email.text = UserEmail
    }
    
    @IBAction func BacktoLoginPage(sender : UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPassword(sender : UIButton){
        if(self.user_password.text != "" &&  self.user_confirm_password.text != ""){
            if (self.user_password.text?.characters.count)! >= 6{
            if(self.user_password.text == self.user_confirm_password.text){
                let user = DataManager.sharedInstance.user
                user?.password = user_password.text!
                DataManager.sharedInstance.user = user
              self.PushViewWithIdentifier(name: "ProfileDetailViewController")
            }else{
                  self.ShowErrorAlert(message: Alert.kPasswordNotMatch)
            }
        }
        }else{
            self.ShowErrorAlert(message: "Enter Password must be 6 character!")
        }
    }
}
