//
//  SocialLoginNickNameViewController.swift
//  BaseProject
//
//  Created by MAC MINI on 06/06/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager
class SocialLoginNickNameViewController: BaseViewController {

    
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nickNameText.delegate = self
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipAction(sender: UIButton!){
        self.PushViewWithIdentifier(name: "HBCommunityMsgVC")
    }
    @IBAction func submitAction(sender: UIButton!){
        if self.nickNameText.text?.trimmingCharacters(in: .whitespaces) != "" && ((self.zipcode.text?.trimmingCharacters(in: .whitespaces)) != ""){
            self.showLoading()
            var params = [String: AnyObject]()
            params["name"] = self.nickNameText.text?.trimmingCharacters(in: .whitespaces) as AnyObject
            params["zip_code"] = self.zipcode.text?.trimmingCharacters(in: .whitespaces) as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.update_name.rawValue, params: params, completion: {(success, message, response) in
                self.hideLoading()
                print(response)
                if success{
                    self.PushViewWithIdentifier(name: "HBCommunityMsgVC")
//                    let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "ChooseProfileImageViewController") as! ChooseProfileImageViewController
//                    viewPush.isFromSocialSignupNickname = true
//                    viewPush.socialNickName = self.nickNameText.text!
//                    self.navigationController?.pushViewController(viewPush, animated: true)
                }else{
                    self.ShowErrorAlert(message: message)
                }
            })
            
        }else{
            if (self.nickNameText.text?.isEmpty)!{
                 ShowErrorAlert(message: "Enter Nick Name!")
            }else{
                 ShowErrorAlert(message: "Enter ZipCode!")
            }
           
        }
    }
    @IBAction func backAction(sender: UIButton!){
        DataManager.sharedInstance.logoutUser()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.nickNameText{
            if string.count > 0 {
                if ( (textField.text?.count)! + string.count ) > 20 {
                    return false
                }
            }else{
                if ( (textField.text?.count)!) > 20 {
                    return false
                }
            }
        }
        return true
    }
}
