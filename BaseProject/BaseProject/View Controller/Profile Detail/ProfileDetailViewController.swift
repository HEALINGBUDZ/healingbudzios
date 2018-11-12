//
//  ProfileDetailViewController.swift
//  BaseProject
//
//  Created by macbook on 05/12/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager
class ProfileDetailViewController: BaseViewController {
 @IBOutlet var TF_nick_name    : UITextField!
     @IBOutlet var TF_zip_code  : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TF_nick_name.delegate = self
        self.TF_zip_code.delegate = self
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 150
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
    
    @IBAction func GotoNextScreen(sender : UIButton){
         if(TF_nick_name.text != "" && TF_zip_code.text != ""){
            self.showLoading()
            NetworkManager.getUserAddressFromZipCode(zipcode: TF_zip_code.text!, completion: { (success, message, response) in
                  self.hideLoading()
                print(message)
                print(response ?? "text" )
//                print(((response!["results"] as! [[String : Any]])[0])!["formatted_address"])
//                Clarksville, TX 75426, USA
                print(response!["results"] ?? "text")
                  if(success){
                    if( ((response!["results"] as! [[String : Any]]).count) > 0){
                        let user = DataManager.sharedInstance.user
                        user?.userFirstName = (self.TF_nick_name.text?.capitalizingFirstLetter())!
                        user?.zipcode = self.TF_zip_code.text!
                        var location : String =  (response!["results"] as! [[String : Any]])[0]["formatted_address"] as! String
                        user?.userlat = String((((response!["results"] as! [[String : Any]])[0]["geometry"] as! [String : AnyObject])["location"] as! [String : AnyObject])["lat"] as! Double)
                        user?.userlng = String((((response!["results"] as! [[String : Any]])[0]["geometry"] as! [String : AnyObject])["location"] as! [String : AnyObject])["lng"] as! Double)
                        
                         location = location.replacingOccurrences(of: (self.TF_zip_code.text!), with: "")
                        user?.address = location
                        DataManager.sharedInstance.user = user
                        self.PushViewWithIdentifier(name: "ChooseProfileImageViewController")
                    }else{
                      self.ShowErrorAlert(message: "Zip Code Not Found!")
                    }
                  }else{
                    self.ShowErrorAlert(message: message)
                }
            })
           
         }else{
            self.ShowErrorAlert(message: kInformationMissingTitle)
        }
       
    }
    
    
    @IBAction func GotoBAck(sender : UIButton){
     self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.TF_nick_name{
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
