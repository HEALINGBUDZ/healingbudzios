//
//  NewShoutOutAlert.swift
//  BaseProject
//
//  Created by Jawad on 8/9/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AAPickerView
import MapKit
import Stripe

@objc protocol refreshDataDelgate {
    func refreshData()
    @objc optional func refreshTabs()
    
}
class NewShoutOutAlert: BaseViewController , CameraDelegate , UITextViewDelegate, CLLocationManagerDelegate{

    @IBOutlet var imgView_zipCode : UIImageView!
    @IBOutlet var imgView_CurrentLocation : UIImageView!
    @IBOutlet var imgView_ShareLocation : UIImageView!
    @IBOutlet var imgView_Image : UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    let locationManager = CLLocationManager()
    var notificationType = ""
    let constantCountString = "/140 characters"
    
    var delegate : refreshDataDelgate?
    @IBOutlet var lbl_CharactersCount : UILabel!
    var array_ShoutOut = [ShoutOut]()
    var array_SubUser = [SubUser]()
    var choose_SubUser = SubUser()
    var choose_ShoutOut = ShoutOut()
    var specials_Array  = [String]()
    var selected_specials = [Specials]()
    var choosed_sepcail = Specials()
    @IBOutlet var txtView_Description : UITextView!
    @IBOutlet var txtField_Link : AAPickerView!
    @IBOutlet var txtField_Special : AAPickerView!
    @IBOutlet var txtfield_Date : AAPickerView!
    
    var isCameraOpen = false
    var isImageAttach = false
    var isZipCodeChoose = true
    
    
    var subuser_id : Int?
    var subuser_name : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView_Description.delegate = self
        self.txtfield_Date.pickerType = .DatePicker
        self.txtfield_Date.datePicker?.datePickerMode = .date
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        if self.subuser_name != nil {
            if self.subuser_name!.count > 0 {
                self.txtField_Link.text = self.subuser_name
                self.txtField_Link.isUserInteractionEnabled = false
            }
            print(self.selected_specials.count)
            if self.selected_specials.count > 0 {
                self.specials_Array.removeAll()
                for indexObj in selected_specials {
                    if indexObj.id != 0 {
                        self.specials_Array.append((indexObj.title))
                    }
                }
                if self.specials_Array.count > 0 {
                    self.choosed_sepcail = selected_specials.first!
//                    self.txtField_Special.text = self.specials_Array.first
                    self.txtField_Special.pickerType = .StringPicker
                    self.txtField_Special.stringPickerData = specials_Array
                    self.txtField_Special.isUserInteractionEnabled = true
                }else{
                    self.choosed_sepcail = Specials()
                    self.txtField_Special.isUserInteractionEnabled = false
                }
            }
        }else{
            self.choose_SubUser = self.array_SubUser.first!
            
            self.selected_specials = self.choose_SubUser.special
            self.specials_Array.removeAll()
            for indexObj in selected_specials {
                if indexObj.id != 0{
                    self.specials_Array.append((indexObj.title))
                }
            }
            if self.specials_Array.count > 0 {
                self.choosed_sepcail = selected_specials.first!
//                self.txtField_Special.text = self.specials_Array.first
                self.txtField_Special.pickerType = .StringPicker
                self.txtField_Special.stringPickerData = specials_Array
                self.txtField_Special.isUserInteractionEnabled = true
            }else{
                self.choosed_sepcail = Specials()
                self.txtField_Special.isUserInteractionEnabled = false
            }
            
            self.txtField_Link.isUserInteractionEnabled = true
            self.txtField_Link.text = self.choose_SubUser.title
            var newArray = [String]()
            for indexObj in array_SubUser {
                if indexObj.business_type_id != "0" && indexObj.business_type_id != ""{
                    newArray.append((indexObj.title))
                }
            }
 
             self.txtField_Link.pickerType = .StringPicker
             self.txtField_Link.stringPickerData = newArray
        }
       
        self.txtfield_Date.dateDidChange = { date in
            print("selectedDate ", date )
        }
        
       
        self.txtField_Link.stringDidChange = { value in
            print("value " , value)
            self.choose_SubUser = self.array_SubUser[value]
            self.selected_specials = self.choose_SubUser.special
            self.specials_Array.removeAll()
            for indexObj in self.selected_specials {
                if indexObj.id != 0{
                    self.specials_Array.append((indexObj.title))
                }
            }
            if self.specials_Array.count > 0 {
                self.choosed_sepcail = self.selected_specials.first!
                self.txtField_Special.text = self.specials_Array.first
                self.txtField_Special.pickerType = .StringPicker
                self.txtField_Special.stringPickerData = self.specials_Array
                self.txtField_Special.isUserInteractionEnabled = true
            }else{
                  self.txtField_Special.text = ""
                self.choosed_sepcail = Specials()
                self.txtField_Special.isUserInteractionEnabled = false
            }
        }
        
        self.txtField_Special.stringDidChange = { value in
            print("value " , value)
            self.choosed_sepcail = self.selected_specials[value]
        }
        
        isCameraOpen = false  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainView.zoomIn()
    }
    
    @IBAction func HideNewShouOut_Action(sender  : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
extension NewShoutOutAlert {
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
        vcCamera.isViewPresent  = true
        self.present(vcCamera, animated: true, completion: nil)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
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
    
    @IBAction func Send_Action(sender : UIButton){
        
        
        if self.txtView_Description.text == "Hey, What do you want to say?" || self.txtView_Description.text.count == 0 {
            self.ShowErrorAlert(message: "Please add description!")
            return
        }
        
        if self.subuser_id == nil {
            if self.subuser_name == nil || self.subuser_name?.count == 0 {
                if self.choose_SubUser.id == "0" || self.choose_SubUser.id.count == 0 || self.txtField_Link.text?.count == 0 {
                    self.ShowErrorAlert(message: "Please link budz adz!")
                    return
                }
            }else{
                self.ShowErrorAlert(message: "Please link budz adz!")
                return
            }
        }
        
        if self.txtfield_Date.text! == "Valid Until..." || self.txtfield_Date.text?.count == 0 {
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
        
        if self.subuser_id == nil || (self.subuser_name?.isEmpty)! {
             newParam["sub_user_id"] = self.choose_SubUser.id as AnyObject
        }else{
            newParam["sub_user_id"] = self.subuser_id  as AnyObject
        }
        
        if self.choosed_sepcail != nil {
            if self.choosed_sepcail.id != 0 {
                newParam["budz_special_id"] = self.choosed_sepcail.id  as AnyObject
            }
        }
        
        
        print(newParam)
        self.showLoading()
        
        if isImageAttach {
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_shout_out.rawValue, image: self.imgView_Image.image!, withParams: newParam, onView: self) { (MainResponse) in
                self.hideLoading()
                print(MainResponse)
                if (MainResponse["status"] as! String) == "success" {
                    if (MainResponse["status"] as! String) == "success" {
                        self.ShowErrorAlert(message: MainResponse["successMessage"] as! String , AlertTitle: "")
                        self.delegate?.refreshData()
                        self.dismiss(animated: true, completion: {
                            
                        })
                        
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
                        self.dismiss(animated: true, completion: {
                            self.delegate?.refreshData()
                        })
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DataManager.sharedInstance.user?.userCurrentlat = String(describing: locations.last!.coordinate.latitude)
        DataManager.sharedInstance.user?.userCurrentlng = String(describing: locations.last!.coordinate.longitude)
        DataManager.sharedInstance.saveUserPermanentally()
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
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
