//
//  ShoutOutDetailsVC.swift
//  BaseProject
//


//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import MapKit
import ActiveLabel
class ShoutOutDetailsVC: BaseViewController {
    var shoutOutObj = ShoutOut()
    var navigation : UINavigationController?
    @IBOutlet var lbl_PopUp_title : UILabel!
    @IBOutlet var lbl_PopUp_timeAgo : UILabel!
    @IBOutlet var lbl_PopUp_Description : ActiveLabel!
    @IBOutlet var lbl_PopUp_ValidUntil : UILabel!
    @IBOutlet var lbl_PopUp_MileAway : UILabel!
    @IBOutlet var lbl_PopUp_LikeCount : UILabel!
    @IBOutlet var lbl_PopUp_SharedCount : UILabel!
    
    @IBOutlet var imgview_PopUp_UserTop : UIImageView!
    @IBOutlet var imgview_PopUp_MainImage : UIImageView!
    @IBOutlet var imgview_PopUp_LocationImage : UIImageView!
    
    
    @IBOutlet var imgview_PopUp_LikeImage : UIImageView!
    @IBOutlet var imgview_PopUp_User : UIImageView!
    
    @IBOutlet weak var Image_Height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationShoutOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func notificationShoutOut(){
        self.lbl_PopUp_title.text = "Shout Out received from\n" + self.shoutOutObj.sub_user.title
        print(self.shoutOutObj.created_At)
        self.lbl_PopUp_timeAgo.text = self.shoutOutObj.created_At.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "yyyy-MM-dd HH:mm:ss").ShoutOutMonthCalculate()
        
        let dayremaining = self.shoutOutObj.validity_Date.GetDaysAgo(formate: "yyyy-MM-dd")
        if dayremaining < 0 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRED"
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else if dayremaining < 2 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRE SOON! "  + self.shoutOutObj.validity_Date.GetShoutout()
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else {
            self.lbl_PopUp_ValidUntil.text = "Valid until: "  + self.shoutOutObj.validity_Date.GetShoutout()
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }
        //e070e0
        self.lbl_PopUp_Description.applyTag(baseVC: self , mainText: self.shoutOutObj.shoutOut_message)
        self.lbl_PopUp_Description.text = self.shoutOutObj.shoutOut_message
        let newlat = Double(self.shoutOutObj.shoutOut_lat)!
        let newlng = Double(self.shoutOutObj.shoutOut_lng)!
        
        let url_lat = Double( (DataManager.sharedInstance.user_locaiton?.latitude)! )
        let user_lng = Double( (DataManager.sharedInstance.user_locaiton?.longitude)! )
        let location = CLLocation(latitude: newlat, longitude: newlng)
        let usr_location = CLLocation(latitude: url_lat, longitude: user_lng)
        let distance = (location.distance(from: usr_location)/1000)*0.621
        
        print(newlat)
        print(newlng)
        
        print(url_lat)
        print(user_lng)
        
        print(distance)
        self.lbl_PopUp_MileAway.text = "\(distance)".FloatValue() + " Miles away"
        self.lbl_PopUp_LikeCount.text = self.shoutOutObj.likes_count + " Likes"
        self.lbl_PopUp_SharedCount.text = "Shared"// + self.shoutOutObj.likes_count + " times"
        self.imgview_PopUp_LocationImage.moa.url = WebServiceName.GoogleImage_BaseURL.rawValue + self.shoutOutObj.shoutOut_lat + "," + self.shoutOutObj.shoutOut_lng + WebServiceName.GoogleImage_EndURL.rawValue.RemoveSpace()
        
        if self.shoutOutObj.mainUser.profilePictureURL.count > 0 {
            if self.shoutOutObj.mainUser.profilePictureURL.contains("facebook.com") || self.shoutOutObj.mainUser.profilePictureURL.contains("google.com") {
                self.imgview_PopUp_User.moa.url =  WebServiceName.images_baseurl.rawValue + self.shoutOutObj.shoutOutLogo.RemoveSpace()
            }else{
                self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.shoutOutObj.shoutOutLogo.RemoveSpace()
            }
            
        }else {
            self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.shoutOutObj.shoutOutLogo.RemoveSpace()
        }
        if self.shoutOutObj.mainUser.special_icon.characters.count > 6 {
            self.imgview_PopUp_UserTop.isHidden = true
            self.imgview_PopUp_UserTop.moa.url = WebServiceName.images_baseurl.rawValue + self.shoutOutObj.mainUser.special_icon.RemoveSpace()
        }else {
            self.imgview_PopUp_UserTop.isHidden = true
        }
        
        if  Int(self.shoutOutObj.userlike_count)! > 0  {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "shoot_out_like")
        }else {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "Qa_Like")
        }
        
        self.imgview_PopUp_User.RoundView()
        self.Image_Height.constant = 0.0
        if self.shoutOutObj.shoutOut_image.count > 0 {
            self.imgview_PopUp_MainImage.moa.url = WebServiceName.images_baseurl.rawValue + self.shoutOutObj.shoutOut_image.RemoveSpace()
            self.Image_Height.constant = 75.0
        }
    }
    
    
    @IBAction func onClickViewSpecial(_ sender: Any) {
        self.dismiss(animated: true) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewPush = mainStoryboard.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
            viewPush.isSpecialShown = true
            let  id = self.shoutOutObj.sub_user_id.intValue
            viewPush.budz_map_id = "\(id)"
            if self.shoutOutObj.budzSpecialId != -1{
                self.navigation?.pushViewController(viewPush, animated: true)
            }else {
                 self.navigation?.pushViewController(viewPush, animated: true)
//                self.ShowErrorAlert(message: "No special add!")
            }
        }
        
    }
    @IBAction func GoBack_Action(sender : UIButton){
        self.Dismiss()
    }
    
    @IBAction func Like_Action(sender : UIButton){
        var newParam = [String : AnyObject]()
        newParam["shout_out_id"] = self.shoutOutObj.ID as AnyObject
        
        if Int(self.shoutOutObj.userlike_count)! > 0 {
            newParam["is_liked"] = "0" as AnyObject
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "Qa_Like")
            self.shoutOutObj.userlike_count = "0"
            if Int(self.shoutOutObj.likes_count)! > 0 {
                self.shoutOutObj.likes_count = String(Int(self.shoutOutObj.likes_count)! - 1)
            }
        }else {
            newParam["is_liked"] = "1" as AnyObject
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "shoot_out_like")
            self.shoutOutObj.userlike_count = "1"
            self.shoutOutObj.likes_count = String(Int(self.shoutOutObj.likes_count)! + 1)
            
        }        
        self.lbl_PopUp_LikeCount.text = self.shoutOutObj.likes_count + " Likes"
        print(newParam)
        NetworkManager.PostCall(UrlAPI: WebServiceName.like_shout_out.rawValue, params: newParam) { (successResponse, messageResponse, dataResponse) in
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
//                   self.ShowSuccessAlertWithNoAction(message: "ShoutOut like successfully!")
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
    @IBAction func OpenShareShoutout(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.shoutOutObj.ID)"
        parmas["type"] = "Budz Special"
        let link : String = Constants.ShareLinkConstant + "get-shoutout/\(self.shoutOutObj.ID)"
        self.OpenShare(params:parmas,link: link, content:self.shoutOutObj.shoutOut_title)
    }
    
}
