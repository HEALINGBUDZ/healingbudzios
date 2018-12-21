//
//  PaymentPopupViewController.swift
//  BaseProject
//
//  Created by MN on 11/06/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import Stripe

import IQKeyboardManager
protocol makePremiumDelegate {
    func makePremium(isSubscribed : Bool ,sub_user_id : String)
}
class PaymentPopupViewController: UIViewController {

    @IBOutlet weak var header_title: UILabel!
    var isFromNewBudzScreen : Bool = false
    var payText = "PAY $19.95"
    var premiumDelegate  :makePremiumDelegate?
    @IBOutlet weak var dont_show_top: NSLayoutConstraint!
    @IBOutlet weak var dont_show_hight: NSLayoutConstraint!
    @IBOutlet var middlePaymentView: UIView!
    @IBOutlet var leftPaymentView: UIView!
    @IBOutlet var rightPaymentView: UIView!
    @IBOutlet var middlePaymentButton: UIButton!
    @IBOutlet var leftPaymentButton: UIButton!
    @IBOutlet var rightPaymentButton: UIButton!
    @IBOutlet var learnmoreButton: UIButton!
    @IBOutlet var subscribeNow: UIButton!
    @IBOutlet var noThanks: UIButton!
    @IBOutlet var dontShowAgainButton: UIButton!
    @IBOutlet var dontShowImage: UIImageView!
    @IBOutlet var dontShowAgainView: UIView!
    var NotAsPopUp = false
    var paymentType = 2
    var popupPresent = 0
    var updateBudId = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if NotAsPopUp{
            self.dontShowAgainView.isHidden = true
            self.dont_show_top.constant = 0
            self.dont_show_hight.constant = 0
            self.view.layoutIfNeeded()
        }
        
        self.dontShowAgainView.isHidden = true
        self.dont_show_top.constant = 0
        self.dont_show_hight.constant = 0
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if updateBudId == -1 {
        self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if updateBudId == -1 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    @IBAction func noThanksAction(sender: UIButton!){
        if popupPresent == 1{
            var params = [String: AnyObject]()
            params["show_budz_popup"] = 0 as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.update_pop_up.rawValue, params: params, completion: {(success, message, response) in
                if success{
                    
                }else{
//                    self.ShowErrorAlert(message: message)
                }
            })
        }
        
        if  self.isFromNewBudzScreen {
              self.dismiss(animated: true, completion: nil)
        }else{
             self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func middlePaymentButtonAction(sender: UIButton!){
        self.middlePaymentView.backgroundColor = UIColor.init(hex: "932a87")
        self.leftPaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.rightPaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.paymentType = 2
        self.header_title.text = "3 Month Paid Subscription"
        self.payText = "PAY $19.95"
//        self.dollarLabel.text = "19"
//        self.centsLabel.text = "95"
    }
    
    @IBAction func leftPaymentButtonAction(sender: UIButton!){
        self.middlePaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.leftPaymentView.backgroundColor = UIColor.init(hex: "932a87")
        self.rightPaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.paymentType = 1
        self.payText = "PAY $29.95"
        self.header_title.text = "Monthly Paid Subscription"
//        self.dollarLabel.text = "29"
//        self.centsLabel.text = "95"
    }
    
    @IBAction func rightPaymentButtonAction(sender: UIButton!){
        self.middlePaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.leftPaymentView.backgroundColor = UIColor.init(hex: "45c5e8")
        self.rightPaymentView.backgroundColor = UIColor.init(hex: "932a87")
        self.paymentType = 3
        self.payText = "PAY $15.95"
        self.header_title.text = "Annually Paid Subscription"
//        self.dollarLabel.text = "15"
//        self.centsLabel.text = "95"
    }
    
    var payMent:PayBudzModel?
    
    @IBAction func subscribeNowAction(sender: UIButton!){
        if popupPresent == 1{
            var params = [String: AnyObject]()
            params["show_budz_popup"] = 0 as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.update_pop_up.rawValue, params: params, completion: {(success, message, response) in
                let usr  = DataManager.sharedInstance.getPermanentlySavedUser()
                usr?.showBudzPopup = 0
                DataManager.sharedInstance.user = usr
                DataManager.sharedInstance.saveUserPermanentally()
                if success{ 
                }else{
                    self.ShowErrorAlert(message: message)
                }
            })
        }
        //FOR AUTHORIZE.NET
//        self.callNewPop()
        //FOR STRIPE
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        IQKeyboardManager.shared().isEnabled = false
        present(navigationController, animated: true)
    }
    
    @IBAction func dontShowThisAgainAction(sender: UIButton!){
        if popupPresent == 0{
            self.dontShowImage.image = #imageLiteral(resourceName: "pinkBoxS")
            popupPresent = 1
        }else{
            self.dontShowImage.image = #imageLiteral(resourceName: "pinkBoxU")
            popupPresent = 0
        }
    }
    
    @IBAction func learnMoreButtonAction(sender: UIButton!){
//        self.learnMorePopUp.isHidden = false
    }

    @IBAction func learnMorePopupHide(sender: UIButton!){
//        self.learnMorePopUp.isHidden = true
    }
}

extension PaymentPopupViewController : STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnabled = true
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnabled = true
        print(token)
        self.view.showLoading()
        if self.updateBudId == -1{
        NetworkManager.PostCall(UrlAPI:WebServiceName.add_subscription.rawValue, params: ["stripe_token" : token.tokenId as AnyObject, "plan_type": self.paymentType as AnyObject]) { (isSuccess, StringResponse, ResponseObject) in
            self.view.hideLoading()
            print(ResponseObject)
            if let status = ResponseObject["status"] as? String {
                if status  == "success" {
                     var data : [String : AnyObject] = ResponseObject["successData"] as! [String : AnyObject]
                    if  self.isFromNewBudzScreen {
                        self.dismiss(animated: true, completion: nil)
                        self.premiumDelegate?.makePremium(isSubscribed: true, sub_user_id: "\(String(describing: (data["id"] as? NSNumber)!.intValue)))")
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let new_vc = (storyboard.instantiateViewController(withIdentifier: "NewBudzMapViewController")) as! NewBudzMapViewController
                        new_vc.isSubscribed = true
                        new_vc.sub_user_id = "\(String(describing: (data["id"] as? NSNumber)!.intValue)))"
                        new_vc.fromPaymentPopUp = true
                        self.navigationController?.pushViewController(new_vc, animated: false)
                        self.dismiss(animated: true, completion: nil)
                    }
                   
                }else{

                    self.ShowErrorAlert(message: (ResponseObject["errorMessage"] as? String)!)
                }
            }else{

                self.ShowErrorAlert(message: (ResponseObject["errorMessage"] as? String)!)
            }
         }
        }else{
            NetworkManager.PostCall(UrlAPI:WebServiceName.update_subscription.rawValue, params: ["stripe_token" : token.tokenId as AnyObject, "plan_type": self.paymentType as AnyObject,"budz_id": self.updateBudId as AnyObject]) { (isSuccess, StringResponse, ResponseObject) in
                self.view.hideLoading()
                print(ResponseObject)
                if let status = ResponseObject["status"] as? String {
                    if status  == "success" {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "suscribedNow"), object: nil, userInfo: nil)
                    }else{

                        self.ShowErrorAlert(message: (ResponseObject["errorMessage"] as? String)!)
                    }
                }else{

                    self.ShowErrorAlert(message: (ResponseObject["errorMessage"] as? String)!)
                }
            }
        }
    }
    func callNewPop(){
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "BudzPaymentPopVC")) as! BudzPaymentPopVC
        viewObj.providesPresentationContextTransitionStyle = true
        viewObj.definesPresentationContext = true
        viewObj.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewObj.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewObj.txtPayText = self.payText
        if self.payMent != nil {
            viewObj.cardModel = self.payMent
        }
        viewObj.delegade = self
        self.present(viewObj, animated: true, completion: nil)
    }
}

extension PaymentPopupViewController : PaymentDelegate {
    func close() {
        
    }
    
    func done(obj: PayBudzModel) {
        self.payMent = obj
        var param = [String:AnyObject]()
        param["plan_type"] = self.paymentType as AnyObject
        //
        param["card"] = self.payMent?.card as AnyObject
        param["year"] = self.payMent?.date.GetDateWith(formate: "yy", inputFormat: "MM/yy") as AnyObject
        param["month"] = self.payMent?.date.GetDateWith(formate: "MM", inputFormat: "MM/yy") as AnyObject
        param["cvc"] = self.payMent?.cvc as AnyObject
        param["email"] = self.payMent?.email as AnyObject
        //
        self.view.showLoading()
        if self.updateBudId == -1{
            
            //["stripe_token" : token.tokenId as AnyObject, "plan_type": self.paymentType as AnyObject]
            NetworkManager.PostCall(UrlAPI:WebServiceName.add_subscription.rawValue, params:param ) { (isSuccess, StringResponse, ResponseObject) in
                self.view.hideLoading()
                print(ResponseObject)
                if let status = ResponseObject["status"] as? String {
                    if status  == "success" {
                        var data : [String : AnyObject] = ResponseObject["successData"] as! [String : AnyObject]
                        if  self.isFromNewBudzScreen {
                            self.dismiss(animated: true, completion: nil)
                            self.premiumDelegate?.makePremium(isSubscribed: true, sub_user_id: "\(String(describing: (data["id"] as? NSNumber)!.intValue)))")
                        }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let new_vc = (storyboard.instantiateViewController(withIdentifier: "NewBudzMapViewController")) as! NewBudzMapViewController
                            new_vc.isSubscribed = true
                            new_vc.sub_user_id = "\(String(describing: (data["id"] as? NSNumber)!.intValue)))"
                            new_vc.fromPaymentPopUp = true
                            self.navigationController?.pushViewController(new_vc, animated: false)
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else{
                        self.ShowAlertWithDim(message: (ResponseObject["errorMessage"] as? String)!, complition: { (Tst) in
                            self.callNewPop()
                        })
                    }
                }else{
                    self.ShowAlertWithDim(message: (ResponseObject["errorMessage"] as? String)!, complition: { (Tst) in
                        self.callNewPop()
                    })
                }
            }
        }else{

            //["stripe_token" : token.tokenId as AnyObject, "plan_type": self.paymentType as AnyObject,"budz_id": self.updateBudId as AnyObject]
            
            param["budz_id"] = self.updateBudId as AnyObject
            NetworkManager.PostCall(UrlAPI:WebServiceName.update_subscription.rawValue, params: param ) { (isSuccess, StringResponse, ResponseObject) in
                self.view.hideLoading()
                print(ResponseObject)
                if let status = ResponseObject["status"] as? String {
                    if status  == "success" {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "suscribedNow"), object: nil, userInfo: nil)
                    }else{
                        self.ShowAlertWithDim(message: (ResponseObject["errorMessage"] as? String)!, complition: { (Tst) in
                            self.callNewPop()
                        })
                    }
                }else{
                    self.ShowAlertWithDim(message: (ResponseObject["errorMessage"] as? String)!, complition: { (Tst) in
                        self.callNewPop()
                    })
                }
            }
        }
    }
    
    
}
