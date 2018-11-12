//
//  HBCommunityMsgVC.swift
//  BaseProject
//
//  Created by Jawad ali on 1/3/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class HBCommunityMsgVC: BaseViewController  {

    @IBOutlet weak var dialog_view: UIView!
    @IBOutlet weak var TF_days: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        TF_days.delegate = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func Add_Experties(_ sender: Any) {
       self.PushViewWithIdentifier(name: "AddYourEpertiesVC")
    }
    @IBAction func Remember_Me(_ sender: Any) {
        self.dialog_view.isHidden = false
        self.dialog_view.zoomIn()
    }
    @IBAction func onClickCrossDialog(_ sender: Any) {
        self.dialog_view.isHidden = true
        self.dialog_view.zoomOut()
    }
    @IBAction func onClickDone(_ sender: Any) {
        if self.TF_days.text!.isEmpty || self.TF_days.text! == "0"{
            self.ShowErrorAlert(message: "Enter Days!")
        }else{
            self.showLoading()
            var paramaMain = [String : AnyObject]()
            paramaMain["days"] = self.TF_days.text as AnyObject
            NetworkManager.PostCall(UrlAPI: "job_remaind_later", params: paramaMain, completion: { (SuccessResponse, MessageResponse, DataResponse) in
                 self.hideLoading()
                 self.ShowMenuBaseView()
               })
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        if !string.isEmpty {
            return text.count < 2
            
        }
        else {
            return true
        }
    }
}
