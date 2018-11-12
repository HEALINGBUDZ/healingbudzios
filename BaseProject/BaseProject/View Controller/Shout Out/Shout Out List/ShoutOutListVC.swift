//
//  ShoutOutListVC.swift
//  BaseProject
//
//  Created by macbook on 06/09/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import AAPickerView
import MapKit
import ActiveLabel
import Stripe

class ShoutOutListVC: BaseViewController, CameraDelegate, UITextViewDelegate, CLLocationManagerDelegate , refreshDataDelgate {
    
    @IBOutlet var tbleView_ShoutOut : UITableView!
    @IBOutlet var Shoutout_View : UIView!
    @IBOutlet var Shoutout_ViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet var New_Shoutout_View : UIView!
    
    @IBOutlet weak var Img_location_pin: UIImageView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var Image_Height: NSLayoutConstraint!
    @IBOutlet var imgView_zipCode : UIImageView!
    @IBOutlet var imgView_CurrentLocation : UIImageView!
    @IBOutlet var imgView_Image : UIImageView!
    @IBOutlet var imgView_ShareLocation : UIImageView!
    var notificationType = ""
     let constantCountString = "/140 characters"
    
    @IBOutlet var lbl_CharactersCount : UILabel!
    @IBOutlet var lbl_btnText : UILabel!
    @IBOutlet var lbl_RoundView : RoundView!
    @IBOutlet var lbl_PopUp_title : UILabel!
    @IBOutlet var lbl_PopUp_timeAgo : UILabel!
    @IBOutlet var lbl_PopUp_Description : ActiveLabel!
    @IBOutlet var lbl_PopUp_ValidUntil : UILabel!
    @IBOutlet var lbl_PopUp_MileAway : UILabel!
    @IBOutlet var lbl_PopUp_LikeCount : UILabel!
    @IBOutlet var lbl_PopUp_SharedCount : UILabel!
    
    @IBOutlet var imgview_PopUp_LikeImage : UIImageView!
    @IBOutlet var imgview_PopUp_User : UIImageView!
    @IBOutlet var imgview_PopUp_UserTop : UIImageView!
    @IBOutlet var imgview_PopUp_MainImage : UIImageView!
    @IBOutlet var imgview_PopUp_LocationImage : UIImageView!
    
    var array_ShoutOut = [ShoutOut]()
    var array_SubUser = [SubUser]()
    var choose_SubUser = SubUser()
    var choose_ShoutOut = ShoutOut()
    
    @IBOutlet var txtView_Description : UITextView!
    
    @IBOutlet var txtField_Link : AAPickerView!
    @IBOutlet var txtfield_Date : AAPickerView!
    
    var isCameraOpen = false
    var isImageAttach = false
    var isZipCodeChoose = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.txtfield_Date.pickerType = .DatePicker
        self.txtfield_Date.datePicker?.datePickerMode = .date
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if !isCameraOpen {
            self.lbl_CharactersCount.text = "0" + constantCountString
            self.Shoutout_View.isHidden = true
            self.New_Shoutout_View.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.GetAllShoutOut()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.locationServicesEnabled() {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
            
        }
        
        self.txtfield_Date.dateDidChange = { date in
            print("selectedDate ", date )
        }
        
        self.txtField_Link.stringDidChange = { value in
            print("value " , value)
            self.choose_SubUser = self.array_SubUser[value]
        }
        
        isCameraOpen = false
        
        self.disableMenu()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    func refreshData() {
         self.GetAllShoutOut()
    }
    
    @IBAction func onClickViewSpecial(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewPush = mainStoryboard.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
        viewPush.isSpecialShown = true
         let  id = self.choose_ShoutOut.sub_user_id.intValue
        viewPush.budz_map_id = "\(id)"
        self.navigationController?.pushViewController(viewPush, animated: true)
    }
    
    func GetAllShoutOut(){
        self.txtField_Link.pickerType = .StringPicker
        self.array_ShoutOut.removeAll()
        self.array_SubUser.removeAll()
        
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_shout_outs.rawValue) { (successResponse, messageReponse, dataResponse) in
            
            print(dataResponse)
            self.hideLoading()
            var newArray = [String]()
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    let mainData = dataResponse["successData"] as! [String : Any]
                    let subuserData = mainData["subusers"] as! [[String : Any]]
                    let shoutOutData = mainData["shout_outs"] as! [[String : Any]]
                    for indexObj in shoutOutData {
                        self.array_ShoutOut.append(ShoutOut.init(json: indexObj as [String : AnyObject]))
                    }
                    
                    for indexObj in subuserData {
                        let bud_map = SubUser.init(json: indexObj as [String : AnyObject])
                        if bud_map.business_type_id != "0" && bud_map.business_type_id != ""{
                            self.array_SubUser.append(bud_map)
                            newArray.append((self.array_SubUser.last?.title)!)
                        }
                    }
                    self.lbl_btnText.text = "SEND A SHOUT OUT"
//                    if self.array_SubUser.count > 0 {
//                        self.lbl_btnText.text = "SEND A SHOUT OUT"
//                    }else {
//                        self.lbl_btnText.text = "BUY SUBSCRIPTION"
//                    }
                    
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                        
                    }
                }
                
                if self.notificationType != ""{
                    self.lbl_RoundView.isHidden = true
                    self.Shoutout_ViewHeightConstraint.constant = 0
                    self.notificationShoutOut()
                }else {
                    self.lbl_RoundView.isHidden = false
                    self.Shoutout_ViewHeightConstraint.constant = 35
//                    self.array_ShoutOut.removeAll()
                }
            }else {
                self.ShowErrorAlert(message:messageReponse)
            }
            
            
            self.txtField_Link.stringPickerData = newArray
            
            
            if self.array_ShoutOut.count == 0
            {
                self.tbleView_ShoutOut.setEmptyMessage()
            }else {
                self.tbleView_ShoutOut.restore()
            }
            
            
            self.tbleView_ShoutOut.reloadData()
            
        }
    }
    
}


//MARK:
//MARK: Button Actions
extension ShoutOutListVC {

    @IBAction func GoBack_Action(sender : UIButton){
        self.Back()
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
    }
    
    
    
    @IBAction func ShowShouOut_Action(sender  : UIButton){
        if self.array_SubUser.count > 0 {
            let storyboard = UIStoryboard(name: "ShoutOut", bundle: nil)
            let customAlert = storyboard.instantiateViewController(withIdentifier: "NewShoutOutAlert") as! NewShoutOutAlert
            customAlert.delegate = self
            customAlert.subuser_id = nil
            customAlert.subuser_name = nil
            customAlert.array_SubUser = self.array_SubUser
            customAlert.choose_SubUser = self.array_SubUser.first!
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(customAlert, animated: false, completion: nil)  
//            if self.array_SubUser.count > 0 {
//                self.txtField_Link.text = self.array_SubUser.first?.title
//                self.choose_SubUser = (self.array_SubUser.first)!
//            }
//
//            self.txtView_Description.text = "Hey, What do you want to say?"
//            self.imgView_Image.image = #imageLiteral(resourceName: "Atachment_black")
//            self.txtfield_Date.text = "Valid Until..."
//            self.New_Shoutout_View.isHidden = false
        }else {
           self.ShowErrorAlert(message: "You can't create a shout out with pending paid business!", AlertTitle: "Error")
        }
        
    }
    
    @IBAction func HideShouOut_Action(sender  : UIButton){
        self.Shoutout_View.isHidden = true
    }
    
    @IBAction func HideNewShouOut_Action(sender  : UIButton){
        self.New_Shoutout_View.isHidden = true
    }
}


//MARK:
//MARK: Tableview Delegate

extension ShoutOutListVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func RegisterXib(){
        
        self.tbleView_ShoutOut.register(UINib(nibName: "ShoutOutListcell", bundle: nil), forCellReuseIdentifier: "ShoutOutListcell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_ShoutOut.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoutOutListcell") as? ShoutOutListcell
        
        cell?.lbl_Heading.text = self.array_ShoutOut[indexPath.row].shoutOut_text
        cell?.lbl_MonthAgo.text = self.GetTimeAgo(StringDate: self.array_ShoutOut[indexPath.row].created_At)
        
        let dayremaining = self.array_ShoutOut[indexPath.row].validity_Date.GetDaysAgo(formate: "yyyy-MM-dd")
        print("\(dayremaining)" + "  date = " + self.array_ShoutOut[indexPath.row].validity_Date )
        if dayremaining < 0 {
            cell?.lbl_TimeUntill.text = "EXPIRED"
            cell?.lbl_TimeUntill.textColor = UIColor.red
        }else if dayremaining < 2 {
            cell?.lbl_TimeUntill.text = "EXPIRE SOON!\n"  + self.array_ShoutOut[indexPath.row].validity_Date.GetShoutout()
             cell?.lbl_TimeUntill.textColor = UIColor.red
        }else {
            cell?.lbl_TimeUntill.text = "Valid until:" + self.array_ShoutOut[indexPath.row].validity_Date.GetShoutout()
             cell?.lbl_TimeUntill.textColor = UIColor.white
        }
    
        if self.array_ShoutOut[indexPath.row].shoutOut_image.characters.count > 0 {
            cell?.ImageView_Width.constant = 25.0
//            cell?.imgView_ImageIndicator.moa.url = WebServiceName.images_baseurl.rawValue + self.array_ShoutOut[indexPath.row].shoutOut_image.RemoveSpace()
        }else {
            cell?.ImageView_Width.constant = 0.0
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    func notificationShoutOut(){
        self.choose_ShoutOut = self.array_ShoutOut[self.array_ShoutOut.index(where: {$0.ID == self.notificationType})!]
        self.array_ShoutOut.removeAll()
        self.array_ShoutOut.append(self.choose_ShoutOut)
        self.tbleView_ShoutOut.reloadData()
        self.Shoutout_View.isHidden = false
        self.lbl_PopUp_title.text = "Shout Out received from\n" + self.choose_ShoutOut.sub_user.title
        print(self.choose_ShoutOut.created_At)
        self.lbl_PopUp_timeAgo.text = self.choose_ShoutOut.created_At.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "yyyy-MM-dd HH:mm:ss").ShoutOutMonthCalculate()
        
        let dayremaining = self.choose_ShoutOut.validity_Date.GetDaysAgo(formate: "yyyy-MM-dd")
        if dayremaining < 0 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRED"
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else if dayremaining < 2 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRE SOON! "  + self.choose_ShoutOut.validity_Date.GetShoutout()
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else {
            self.lbl_PopUp_ValidUntil.text = "Valid until: "  + self.choose_ShoutOut.validity_Date.GetShoutout()
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }
        //e070e0
        self.lbl_PopUp_Description.applyTag(baseVC: self , mainText: self.choose_ShoutOut.shoutOut_message)
        self.lbl_PopUp_Description.text = self.choose_ShoutOut.shoutOut_message
        let newlat = Double(self.choose_ShoutOut.shoutOut_lat)!
        let newlng = Double(self.choose_ShoutOut.shoutOut_lng)!
        
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
        self.lbl_PopUp_LikeCount.text = self.choose_ShoutOut.likes_count + " Likes"
        self.lbl_PopUp_SharedCount.text = "Shared"// + self.choose_ShoutOut.likes_count + " times"
        self.imgview_PopUp_LocationImage.moa.url = WebServiceName.GoogleImage_BaseURL.rawValue + self.choose_ShoutOut.shoutOut_lat + "," + self.choose_ShoutOut.shoutOut_lng + WebServiceName.GoogleImage_EndURL.rawValue.RemoveSpace()
        
//        if self.choose_ShoutOut.mainUser.profilePictureURL.count > 0 {
//            if self.choose_ShoutOut.mainUser.profilePictureURL.contains("facebook.com") || self.choose_ShoutOut.mainUser.profilePictureURL.contains("google.com") {
//                self.imgview_PopUp_User.moa.url =  WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.shoutOutLogo.RemoveSpace()
//            }else{
//                self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.shoutOutLogo.RemoveSpace()
//            }
//
//        }else {
//            self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.shoutOutLogo.RemoveSpace()
//        }
        self.imgview_PopUp_User.image = #imageLiteral(resourceName: "tab_map")
        if self.choose_ShoutOut.mainUser.special_icon.characters.count > 6 {
            self.imgview_PopUp_UserTop.isHidden = true
            self.imgview_PopUp_UserTop.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.mainUser.special_icon.RemoveSpace()
        }else {
            self.imgview_PopUp_UserTop.isHidden = true
        }
 
        if  Int(self.choose_ShoutOut.userlike_count)! > 0  {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "shoot_out_like")
        }else {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "Qa_Like")
        }
        
//        self.imgview_PopUp_User.RoundView()
        self.Image_Height.constant = 0.0
        if self.choose_ShoutOut.shoutOut_image.count > 0 {
            self.imgview_PopUp_MainImage.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.shoutOut_image.RemoveSpace()
            self.Image_Height.constant = 75.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.choose_ShoutOut = self.array_ShoutOut[indexPath.row]
        self.Shoutout_View.isHidden = false
        self.lbl_PopUp_title.text = "You have created Shout Out\n" + self.choose_ShoutOut.sub_user.title
        print(self.choose_ShoutOut.created_At)
        self.lbl_PopUp_timeAgo.text = self.choose_ShoutOut.created_At.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "yyyy-MM-dd HH:mm:ss").ShoutOutMonthCalculate()
        
        let dayremaining = self.choose_ShoutOut.validity_Date.GetDaysAgo(formate: "yyyy-MM-dd")
        if dayremaining < 0 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRED"
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else if dayremaining < 2 {
            self.lbl_PopUp_ValidUntil.text = "EXPIRE SOON! "  + self.choose_ShoutOut.validity_Date.GetShoutout()
              self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }else {
            self.lbl_PopUp_ValidUntil.text = "Valid until: "  + self.choose_ShoutOut.validity_Date.GetShoutout()
            self.lbl_PopUp_ValidUntil.textColor = UIColor.init(hex: "e070e0")
        }
        //e070e0
        self.lbl_PopUp_Description.applyTag(baseVC: self , mainText: self.choose_ShoutOut.shoutOut_message)
        self.lbl_PopUp_Description.text = self.choose_ShoutOut.shoutOut_message
        
        let newlat = Double(self.choose_ShoutOut.shoutOut_lat)!
        let newlng = Double(self.choose_ShoutOut.shoutOut_lng)!
        
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
        
        self.lbl_PopUp_MileAway.text =  "\(distance)".FloatValue() +  " Miles away"
        self.lbl_PopUp_LikeCount.text = self.choose_ShoutOut.likes_count + " Likes"
        self.lbl_PopUp_SharedCount.text = "Shared " + self.choose_ShoutOut.likes_count + " times"
        self.imgview_PopUp_LocationImage.moa.url = WebServiceName.GoogleImage_BaseURL.rawValue + self.choose_ShoutOut.shoutOut_lat + "," + self.choose_ShoutOut.shoutOut_lng + WebServiceName.GoogleImage_EndURL.rawValue.RemoveSpace()
//        if self.choose_ShoutOut.mainUser.profilePictureURL.count > 0 {
//            if self.choose_ShoutOut.mainUser.profilePictureURL.contains("facebook.com") || self.choose_ShoutOut.mainUser.profilePictureURL.contains("google.com") {
//                self.imgview_PopUp_User.moa.url =  self.choose_ShoutOut.mainUser.profilePictureURL.RemoveSpace()
//            }else{
//               self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.mainUser.profilePictureURL.RemoveSpace()
//            }
//
//        }else {
//            self.imgview_PopUp_User.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.mainUser.avatarImage.RemoveSpace()
//        }
        self.imgview_PopUp_User.image = #imageLiteral(resourceName: "leafCirclePink")
        if  Int(self.choose_ShoutOut.userlike_count)! > 0  {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "shoot_out_like")
        }else {
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "Qa_Like")
        }
        
//        self.imgview_PopUp_User.RoundView()
        self.Image_Height.constant = 0.0
        if self.choose_ShoutOut.shoutOut_image.count > 0 {
            self.imgview_PopUp_MainImage.moa.url = WebServiceName.images_baseurl.rawValue + self.choose_ShoutOut.shoutOut_image.RemoveSpace()
            self.Image_Height.constant = 75.0
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    func captured(image: UIImage) {
        isImageAttach = true
        self.imgView_Image.image = image
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        isImageAttach = true
        self.imgView_Image.image = image
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Hey, What do you want to say?" {
           textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Hey, What do you want to say?"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if self.txtView_Description.text.characters.count > 139 && text.characters.count > 0 {
            return false
        }
        
        if text.characters.count > 0 {
            self.lbl_CharactersCount.text = String(self.txtView_Description.text.characters.count + 1) + constantCountString
            
        }else if self.txtView_Description.text.characters.count < 2 {
            self.lbl_CharactersCount.text = "0" + constantCountString
        }else {
             self.lbl_CharactersCount.text = String(self.txtView_Description.text.characters.count - 1) + constantCountString
        }
        return true
    }
}


//MARK:
//MARK: Button Actions
//MARK:

extension ShoutOutListVC {
    @IBAction func Zip_Action(sender : UIButton){
        self.imgView_zipCode.image = #imageLiteral(resourceName: "Radio_Black_S")
        self.imgView_CurrentLocation.image = #imageLiteral(resourceName: "Radio_Black_U")
        self.isZipCodeChoose = true
    }
    
    @IBAction func Location_Action(sender : UIButton){
        self.imgView_CurrentLocation.image = #imageLiteral(resourceName: "Radio_Black_S")
        self.imgView_zipCode.image = #imageLiteral(resourceName: "Radio_Black_U")
        self.isZipCodeChoose = false
    }
    
    
    @IBAction func Share_Location_Action(sender : UIButton){
        if sender.isSelected {
           sender.isSelected = false
            self.imgView_ShareLocation.image = #imageLiteral(resourceName: "Check_Round_U")
        }else {
            sender.isSelected = true
            self.imgView_ShareLocation.image = #imageLiteral(resourceName: "Check_Round_S")
        }
    }
    
    
    @IBAction func OpenCamera_Action(sender : UIButton){
        isCameraOpen = true
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
        
    }
    
    
    @IBAction func Like_Action(sender : UIButton){
        var newParam = [String : AnyObject]()
        newParam["shout_out_id"] = self.choose_ShoutOut.ID as AnyObject
        
        if Int(self.choose_ShoutOut.userlike_count)! > 0 {
            newParam["is_liked"] = "0" as AnyObject
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "Qa_Like")
            self.choose_ShoutOut.userlike_count = "0"
            if Int(self.choose_ShoutOut.likes_count)! > 0 {
                self.choose_ShoutOut.likes_count = String(Int(self.choose_ShoutOut.likes_count)! - 1)
            }
        }else {
            newParam["is_liked"] = "1" as AnyObject
            self.imgview_PopUp_LikeImage.image = #imageLiteral(resourceName: "shoot_out_like")
            self.choose_ShoutOut.userlike_count = "1"
            self.choose_ShoutOut.likes_count = String(Int(self.choose_ShoutOut.likes_count)! + 1)
            
        }
        
        self.lbl_PopUp_LikeCount.text = self.choose_ShoutOut.likes_count + " Likes"
        NetworkManager.PostCall(UrlAPI: WebServiceName.like_shout_out.rawValue, params: newParam) { (successResponse, messageResponse, dataResponse) in
            
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    
                    if let index = self.array_ShoutOut.index(of: self.choose_ShoutOut) {

                        self.array_ShoutOut[index] = self.choose_ShoutOut
                    }
                
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
    
    @IBAction func Send_Action(sender : UIButton){
        
        
        if self.txtView_Description.text == "Hey, What do you want to say?" || self.txtView_Description.text.characters.count == 0 {
            self.ShowErrorAlert(message: "Please add description!")
            return
        }
        
        if self.choose_SubUser.id == "0" || self.choose_SubUser.id.characters.count == 0 || self.txtField_Link.text?.characters.count == 0 {
            self.ShowErrorAlert(message: "Please link budz adz!")
            return
        }
        
        if self.txtfield_Date.text! == "Valid Until..." || self.txtfield_Date.text?.characters.count == 0 {
            self.ShowErrorAlert(message: "Please add date!")
            return
        }
        
        
        var newParam = [String : AnyObject]()
        var valiDate = self.txtfield_Date.text
        valiDate = valiDate?.UTCToLocal(inputFormate: "MM/dd/yyyy", outputFormate: "yyyy-MM-dd")
        newParam["validity_date"] = valiDate as AnyObject
        newParam["message"] = self.txtView_Description.text as AnyObject
        
        if self.isZipCodeChoose {
            newParam["lat"] = DataManager.sharedInstance.user?.userlat as AnyObject
            newParam["lng"] = DataManager.sharedInstance.user?.userlng as AnyObject
        }else {
            newParam["lat"] = DataManager.sharedInstance.user_locaiton?.latitude as AnyObject
            newParam["lng"] = DataManager.sharedInstance.user_locaiton?.longitude as AnyObject
        }
        
        
        newParam["sub_user_id"] = self.choose_SubUser.id as AnyObject
        
        print(newParam)
        self.showLoading()
        
        if isImageAttach {
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_shout_out.rawValue, image: self.imgView_Image.image!, withParams: newParam, onView: self) { (MainResponse) in
                self.hideLoading()
                print(MainResponse)
                if (MainResponse["status"] as! String) == "success" {
                    if (MainResponse["status"] as! String) == "success" {
                        self.ShowErrorAlert(message: MainResponse["successMessage"] as! String , AlertTitle: "")
                        self.New_Shoutout_View.isHidden = true
                        
                    }else {
                        if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                            
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:"Server Error!")
                }
            }
        }else {
            NetworkManager.PostCall(UrlAPI: WebServiceName.add_shout_out.rawValue, params: newParam, completion: { (successResponse, messageResponse, mainResponse) in
                self.hideLoading()
                
                if successResponse {
                    if (mainResponse["status"] as! String) == "success" {
                        self.ShowErrorAlert(message: mainResponse["successMessage"] as! String , AlertTitle: "")
                       self.New_Shoutout_View.isHidden = true
                        
                    }else {
                        if (mainResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                            
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            })
        }
    }
    
    
    @IBAction func OpenShareShoutout(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.choose_ShoutOut.ID)"
        parmas["type"] = "Budz Special"
        let link : String = Constants.ShareLinkConstant + "get-shoutout/\(self.choose_ShoutOut.ID)"
        self.OpenShare(params:parmas,link: link, content:self.choose_ShoutOut.shoutOut_title)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DataManager.sharedInstance.user?.userCurrentlat = String(describing: locations.last!.coordinate.latitude)
        DataManager.sharedInstance.user?.userCurrentlng = String(describing: locations.last!.coordinate.longitude)
        DataManager.sharedInstance.saveUserPermanentally()
        self.locationManager.stopUpdatingLocation()        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}


//MARK:Stripe
extension ShoutOutListVC : STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        print(token)
        self.view.showLoading()
        NetworkManager.PostCall(UrlAPI:WebServiceName.add_subscription.rawValue, params: ["stripe_token" : token.tokenId as AnyObject]) { (isSuccess, StringResponse, ResponseObject) in
            self.view.hideLoading()
            print(ResponseObject)
            let new_vc = self.GetView(nameViewController: "NewBudzMapViewController", nameStoryBoard: "Main") as! NewBudzMapViewController
            new_vc.isSubscribed = true
            var data : [String : AnyObject] = ResponseObject["successData"] as! [String : AnyObject]
            new_vc.sub_user_id = "\(String(describing: (data["id"] as? NSNumber)!.intValue)))"
            self.navigationController?.pushViewController(new_vc, animated: false)
        }
    }
}

class ShoutOutListcell : UITableViewCell{
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var lbl_MonthAgo : UILabel!
    @IBOutlet var lbl_TimeUntill : UILabel!
    @IBOutlet var imgView_ImageIndicator : UIImageView!
    
    @IBOutlet weak var ImageView_Width: NSLayoutConstraint!
    
}
