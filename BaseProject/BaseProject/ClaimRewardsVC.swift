//
//  ClaimRewardsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class ClaimRewardsVC: BaseViewController {
    var data : [String : Any]?
    
    @IBOutlet weak var TF_City: UITextField!
    @IBOutlet weak var TF_State: UITextField!
    @IBOutlet weak var TF_Zipcode: UITextField!
    @IBOutlet weak var TF_Address: UITextField!
    @IBOutlet weak var TF_Name: UITextField!
    @IBOutlet weak var address_view: UIView!
    @IBOutlet weak var Lbl_Discription: UILabel!
    @IBOutlet weak var alert_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TF_City.delegate = self
        self.TF_State.delegate = self
        self.TF_Zipcode.delegate = self
        self.TF_Address.delegate = self
        self.TF_Name.delegate = self
        if let title = data!["name"] as? String , let points = data!["points"] as? NSNumber{
            self.SetAttributedText(mainString: "\"\(title)\" worth \(points.intValue) pts", attributedStringsArray: ["\(points.intValue)","pts"], view: self.Lbl_Discription, color: UIColor.init(hex: "679723"))
        }
        
    }

    @IBAction func onClickCrossAddress(_ sender: Any) {
         self.address_view.isHidden = true
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if  self.TF_Address.text!.isEmpty ||
            self.TF_Zipcode.text!.isEmpty
            {
                if  self.TF_Address.text!.isEmpty {
                     self.ShowErrorAlert(message: "Shipping Address is missing!")
                }else if  self.TF_Zipcode.text!.isEmpty{
                     self.ShowErrorAlert(message: "Zipcode is missing!")
                }
        }else{
             self.PurchaseProduct()
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alert_view.zoomIn()
       
    }
    @IBAction func OnClickCross(_ sender: Any) {
        self.alert_view.zoomOut()
        self.address_view.zoomOut()
        self.Dismiss()
    }
    @IBAction func OnClickClaimRewards(_ sender: Any) {
        self.alert_view.zoomOut()
        self.alert_view.isHidden = true
        self.address_view.isHidden = false
        self.address_view.zoomIn()
    }
    
    
    
    func PurchaseProduct(){
        self.view.showLoading()
        let mainUrl = WebServiceName.purchase_product.rawValue
        print(mainUrl)
        var param = [String : AnyObject]()
        param["product_id"] = data!["id"] as AnyObject
          param["product_points"] = data!["points"] as AnyObject
        param["name"] = self.TF_Name.text as AnyObject
        param["state"] = self.TF_State.text as AnyObject
        param["city"] = self.TF_City.text as AnyObject
        param["address"] = self.TF_Address.text as AnyObject
        param["zip"] = self.TF_Zipcode.text as AnyObject
        NetworkManager.PostCall(UrlAPI: mainUrl, params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    self.alert_view.zoomOut()
                    self.Dismiss()
                    let points = self.data!["points"] as? NSNumber
                    let remaining_points =  MyRewardsVC.total_points.intValue - (points?.intValue)!
                    MyRewardsVC.total_points = NSNumber(value: remaining_points)
                    NotificationCenter.default.post(name: Notification.Name("PurchasedRewardProduct"), object: nil, userInfo: self.data)
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        if let error_msg = dataResponse["errorMessage"] as? String{
                              self.ShowErrorAlert(message:error_msg)
                        }else{
                              self.ShowErrorAlert(message:"Try again later!")
                        }
                      
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
}
