//
//  ChooseProfileImageViewController.swift
//  BaseProject
//
//  Created by macbook on 05/12/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import moa
import OneSignal
import AlamofireImage
class ChooseProfileImageViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CameraDelegate
{
    @IBOutlet weak var avator_collection_view: UICollectionView!
    @IBOutlet weak var avatar_special_collection_view: UICollectionView!
    @IBOutlet weak var hello_title: UILabel!
    @IBOutlet weak var user_selected_img: CircularImageView!
    @IBOutlet weak var special_img: UIImageView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var isFromSocialSignupNickname : Bool = false
     var socialNickName : String = ""
    let user = DataManager.sharedInstance.user
    
    var avator_imgs = [[String : Any]]()
    var avator_special_imgs = [[String : Any]]()
    var avator_Selected_imgs = [String : Any]()
    
 override func viewDidLoad() {
        super.viewDidLoad()
    
    if special{
        collectionViewHeight.constant = 60
        self.special_img.isHidden = false
    }else{
        collectionViewHeight.constant = 0
        self.special_img.isHidden = true
    }
    let components : [String] = (user?.address.components(separatedBy: ","))!
    if isFromSocialSignupNickname{
         hello_title.text = "Hello, "+(socialNickName)
    }else{
         hello_title.text = "Hello, "+(user?.userFirstName)!+", from " + (components[0]) + "," + (components[1])
    }
   
        self.avator_collection_view.delegate = self
        self.avator_collection_view.dataSource = self
        self.avatar_special_collection_view.isScrollEnabled = true
        self.avator_collection_view.isScrollEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.avator_collection_view.register(UINib(nibName: "avator_cell", bundle: nil), forCellWithReuseIdentifier: "AvatorCollectionViewCell")
        self.avatar_special_collection_view.register(UINib(nibName: "avator_cell", bundle: nil), forCellWithReuseIdentifier: "AvatorCollectionViewCell")
        
        if self.avator_imgs.count == 0 {
            self.GetImages()
        }
        
    }
    
    
    
    func GetImages(){
        self.view.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_defaults.rawValue+"/"+(user?.email)!, params: nil) { (successResponse, messageResponse, MainResponse) in
            
            self.view.hideLoading()
            
            print("successResponse \(successResponse)")
            print("messageResponse \(messageResponse)")
            print("MainResponse \(MainResponse)")
            
            if successResponse {
                self.avator_imgs = (MainResponse["successData"] as! [String : AnyObject])["icons"] as! [[String : AnyObject]]
                self.avator_special_imgs = (MainResponse["successData"] as! [String : AnyObject])["specials_icons"] as! [[String : AnyObject]]
                print(self.avator_special_imgs.count)
                print(self.avator_imgs.count)
                if self.avator_imgs.count > 0 {
                    self.user?.avatarImage  = self.avator_imgs[0]["name"] as! String
                    self.avator_Selected_imgs = self.avator_imgs[0]
                    let mainUrl = WebServiceName.images_baseurl.rawValue + (self.avator_imgs[0]["name"] as! String)

                    
                    self.user_selected_img.moa.url = mainUrl.RemoveSpace()

                }
                
            }else {
                self.ShowErrorAlert(message: messageResponse)
            }
            self.avator_collection_view.reloadData()
            self.avatar_special_collection_view.reloadData()
            
        }
    }
    @IBAction func GotoNextScreen(sender : UIButton){
        
        if ((self.user?.profileImage) != nil) {
            print("IF")
            self.UploadImage()
        }else {
            print("Else")
            self.view.showLoading()
            self.SignupAPI()
        }
    }
    
    func UpdateAvater(){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_image.rawValue , image: (self.user_selected_img.image)!, withParams: ["avatar":DataManager.sharedInstance.user?.profilePictureURL as AnyObject], onView: self) { (responseMain) in
            print(responseMain)
            self.hideLoading()
            if (responseMain["status"] as! String) == "success"{
                 self.PushViewWithIdentifier(name: "HBCommunityMsgVC")
            }else {
                self.view.hideLoading()
            }
        }
        NetworkManager.PostCall(UrlAPI: WebServiceName.update_special_icon.rawValue, params: ["special_icon": (DataManager.sharedInstance.user?.special_icon)! as AnyObject], completion: {
            (success, message, responseMain) in
            print(responseMain)
            self.hideLoading()
            if (responseMain["status"] as! String) == "success"{
                
            }else {
                self.view.hideLoading()
            }
        })
    }
    
    
    func UploadImage(){
        self.view.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.upload_profile_img.rawValue , image: (self.user?.profileImage!)!, withParams: ["":"" as AnyObject], onView: self) { (responseMain) in
            print(responseMain)
            self.hideLoading()
            if (responseMain["status"] as! String) == "success"{
                self.user?.profilePictureURL = responseMain["successData"] as! String
                if self.isFromSocialSignupNickname{
                    DataManager.sharedInstance.user?.profilePictureURL = responseMain["successData"] as! String
                    DataManager.sharedInstance.saveUserPermanentally()
                    self.UpdateAvater()
                }else{
                     self.SignupAPI()
                }
            }else {
                self.view.hideLoading()
            }
        }
    }
    
    func SignupAPI(){
        if  isFromSocialSignupNickname {
            self.view.hideLoading()
            self.PushViewWithIdentifier(name: "HBCommunityMsgVC")
        }else{
            user?.userType = "1"
            user?.deviceID = DataManager.sharedInstance.deviceToken
            
            
            
            NetworkManager.PostCall(UrlAPI: WebServiceName.register.rawValue , params: (user?.toRegisterJSON())!) { (successResponse, messageResponse, mainResponse) in
                
                print("successResponse\(successResponse)")
                print("messageResponse\(messageResponse)")
                print("mainResponse\(mainResponse)")
                
                self.view.hideLoading()
                
                if successResponse {
                    
                    if (mainResponse["status"] as! String) == "success" {
                        let mainUser = (mainResponse["successData"] as! [String : Any])["user"] as! [String : Any]
                        let mainUserSession = (mainResponse["successData"] as! [String : Any])["session"] as! [String : Any]
                        
                        self.user?.ID = String(mainUser["id"] as! Int)
                        self.user?.sessionID = String(mainUserSession["session_key"] as! String)
                        DataManager.sharedInstance.user = self.user
                        DataManager.sharedInstance.saveUserPermanentally()
                        OneSignal.sendTags(["user_id" :  DataManager.sharedInstance.user!.ID , "device_type" : "ios"])
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue("0", forKey: "firstView")
                        self.PushViewWithIdentifier(name: "HBCommunityMsgVC")
                        let userDefaultsk = UserDefaults(suiteName: "group.com.healingbudz.ios")
                        userDefaultsk?.set(DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID ,forKey: "sskey")
                        userDefaultsk?.synchronize()
                    }else {
                        
                    }
                    
                    
                }else {
                    
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TakeImage(sender : UIButton){
        
        
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    func captured(image: UIImage) {
        self.user_selected_img.image = image
        user?.profileImage = image
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        self.user_selected_img.image = image
        user?.profileImage = image
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
    }
// Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == avatar_special_collection_view{
         return avator_special_imgs.count
        }else{
        return avator_imgs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == avator_collection_view{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatorCollectionViewCell", for: indexPath) as! AvatorCollectionViewCell
        
        let mainUrl = WebServiceName.images_baseurl.rawValue + (self.avator_imgs[indexPath.row]["name"] as! String)
        cell.avator_img.moa.url = mainUrl.RemoveSpace()
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatorCollectionViewCell", for: indexPath) as! AvatorCollectionViewCell
            
            let mainUrl = WebServiceName.images_baseurl.rawValue + (self.avator_special_imgs[indexPath.row]["name"] as! String)
            print(mainUrl.RemoveSpace())
            cell.avator_img.moa.url = mainUrl.RemoveSpace()
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
//        UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == avator_collection_view{
//        let totalCellWidth = 52 * avator_imgs.count
//        let totalSpacingWidth = 10 * (avator_imgs.count - 1)
//        let leftInset = (self.avator_collection_view.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
//        }else{
//            let totalCellWidth = 52 * avator_imgs.count
//            let totalSpacingWidth = 10 * (avator_imgs.count - 1)
//            let leftInset = (self.avator_collection_view.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//            let rightInset = leftInset
//            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == avator_collection_view{
        self.avator_Selected_imgs = self.avator_imgs[indexPath.row]
        let cellMain = collectionView.cellForItem(at: indexPath) as! AvatorCollectionViewCell
        self.user_selected_img.image = cellMain.avator_img.image
        user?.avatarImage = self.avator_imgs[indexPath.row]["name"] as! String
        }else{
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + (self.avator_special_imgs[indexPath.row]["name"] as! String)){
                self.special_img.af_setImage(withURL: url)
            }
            user?.special_icon = self.avator_special_imgs[indexPath.row]["name"] as! String
         }
        
        if isFromSocialSignupNickname {
             self.UpdateAvater()
        }
    }
}
