//
//  profileSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 22/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import  AlamofireImage
class profileSettingsVC: BaseViewController ,ChangeEpertiesDelegate, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , CameraDelegate , UITextViewDelegate {
    @IBOutlet weak var tableView_settings: UITableView!
    @IBOutlet weak var blinking_image: UIImageView!
    @IBOutlet var view_AboutMe : UIView!
    @IBOutlet var view_Email : UIView!
    @IBOutlet var view_Password : UIView!
    @IBOutlet var view_ZipCode : UIView!
    @IBOutlet var view_Name : UIView!
    @IBOutlet var view_UploadImage : UIView!
    
    var isCoverChoose = false
    @IBOutlet var txtView_AboutMe : UITextView!
    var isCoverUpdateLocally : Bool = false
    var coverImage : UIImage = UIImage()
    @IBOutlet var txtField_OldEmail : UITextField!
    @IBOutlet var txtField_NewEmail : UITextField!
    @IBOutlet var txtField_Password : UITextField!
    @IBOutlet var txtField_ConfirmPassword : UITextField!
    @IBOutlet var txtField_ZipCode : UITextField!
    @IBOutlet var txtField_Name : UITextField!
    
    @IBOutlet var imgView_ChangeProfile : UIImageView!
    @IBOutlet var imgCollectionView : UICollectionView!
    @IBOutlet var specialCollectionView: UICollectionView!
    @IBOutlet var collectionViewHieght: NSLayoutConstraint!
    @IBOutlet var specialImage: UIImageView!
    @IBOutlet var popUpHeight: NSLayoutConstraint!
    
     var array_Attachment = [Attachment]()
    
    var expery_One = ""
    var expery_Two = ""
    
    
    var experty1  = [AddExperties]()
    var experty2  = [AddExperites2]()
    
    var avator_imgs = [[String : Any]]()
    var avator_special_imgs = [[String : Any]]()
    
    var mainFollowers = UIViewController()
    
     var mainArray =  [[String : Any]]()
    
    var userMain = DataManager.sharedInstance.user as! User
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userMain = DataManager.sharedInstance.getPermanentlySavedUser
        self.disableMenu()
        self.txtView_AboutMe.delegate = self
        self.txtField_Name.delegate = self
        self.txtField_OldEmail.delegate = self
        self.txtField_NewEmail.delegate = self
        
        self.tableView_settings.contentInset.top = -20
        self.imgCollectionView.register(UINib(nibName: "avator_cell", bundle: nil), forCellWithReuseIdentifier: "AvatorCollectionViewCell")
        self.specialCollectionView.register(UINib(nibName: "avator_cell", bundle: nil), forCellWithReuseIdentifier: "AvatorCollectionViewCell")
        self.RegisterXib()
        self.ReloadData()
        self.view_UploadImage.isHidden = true
        if userMain.special_icon.count > 6{
            collectionViewHieght.constant = 60
//          popUpHeight.constant = 400
            specialImage.isHidden = false
        }else{
            collectionViewHieght.constant = 0
//            popUpHeight.constant = 320
            specialImage.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtField_Name {
            if string.count > 0 {
                if ((textField.text?.count)! + string.count ) > 20 {
                    return  false
                }
            }else{
                if (textField.text?.count)! > 20 {
                    return  false
                }
            }
        }else if textField == self.txtField_NewEmail ||  textField == self.txtField_OldEmail {
            if string.count > 0 {
                if ((textField.text?.count)! + string.count ) > 40 {
                    return  false
                }
            }else{
                if (textField.text?.count)! > 40 {
                    return  false
                }
            }
        }
         return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.txtView_AboutMe {
            if text.count > 0 {
                if (textView.text.count + text.count ) > 500 {
                    return  false
                }
            }else{
                if (textView.text.count) > 500 {
                    return  false
                }
            }
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.blinking_image.isHidden = true
        self.view_AboutMe.isHidden = true
        self.view_Email.isHidden = true
        self.view_Password.isHidden = true
        self.view_ZipCode.isHidden = true
        self.view_Name.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadFollowersData(notification:)), name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil)
        self.disableMenu()
        let urlMain = WebServiceName.get_user_profile.rawValue + (DataManager.sharedInstance.user?.ID)! + "?time_zone=+05:00&skip=0&lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        print(urlMain)
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: urlMain) { (successMain, message, MainData) in
            print(MainData)
            self.hideLoading()
            self.blinking_image.isHidden = true
            let userDict = MainData["successData"] as? [String : Any]
            let userArray = userDict!["user_data"] as? [[String : Any]]
            if (userArray?.count)! > 0 {
                UserProfileViewController.userMain = User.init(json: userArray?.first as [String : AnyObject]?)
                self.userMain = UserProfileViewController.userMain
                let experties = userArray?.first!["get_expertise"] as! [[String : Any]]
                self.experty1.removeAll()
                self.experty2.removeAll()
                self.expery_One = ""
                self.expery_Two = ""
                for indexObj in experties {
                    if let m = indexObj["medical"] as? [String: Any]{
                        self.experty1.append(AddExperties.init(json: indexObj["medical"] as? [String : AnyObject]))
                        if self.expery_One.characters.count == 0 {
                            self.expery_One = (indexObj["medical"] as! [String : Any])["m_condition"] as! String
                        }else {
                            self.expery_One =  self.expery_One + "\n" + ((indexObj["medical"] as! [String : Any])["m_condition"] as! String)
                        }
                    }else {
                        self.experty2.append(AddExperites2.init(json: indexObj["strain"] as! [String : AnyObject]))
                        
                        
                        if self.expery_Two.characters.count == 0 {
                            self.expery_Two = (indexObj["strain"] as! [String : Any])["title"] as! String
                        }else {
                            self.expery_Two =  self.expery_Two + "\n" + ((indexObj["strain"] as! [String : Any])["title"] as! String)
                        }
                    }
                }
                self.ReloadData()
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil)
        self.enableMenu()
    }

    func GetImages(){
        self.view.showLoading()
        NetworkManager.GetCall(UrlAPI:WebServiceName.get_defaults.rawValue+"/"+(userMain.email), params: nil) { (successResponse, messageResponse, MainResponse) in
            self.view.hideLoading()
            print("successResponse \(successResponse)")
            print("messageResponse \(messageResponse)")
            print("MainResponse \(MainResponse)")
            
            if successResponse {
                self.avator_imgs = (MainResponse["successData"] as! [String : AnyObject])["icons"] as! [[String : AnyObject]]
                 self.avator_special_imgs = (MainResponse["successData"] as! [String : AnyObject])["specials_icons"] as! [[String : AnyObject]]
//                if self.avator_imgs.count > 0 {
//                    self.user?.avatarImage  = self.avator_imgs[0]["name"] as! String
//                    self.avator_Selected_imgs = self.avator_imgs[0]
//                    let mainUrl = WebServiceName.icons_baseurl.rawValue + (self.avator_imgs[0]["name"] as! String)
//                    self.user_selected_img.moa.url = mainUrl
                    
//                }
                
            }else {
                self.ShowErrorAlert(message: messageResponse)
            }
            self.imgCollectionView.reloadData()
            self.specialCollectionView.reloadData()
            
        }
    }
    

}
extension profileSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : profileSettings.profileSettingsUserInfo.rawValue])

        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsDetailCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
       self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsMedicalConditionsCell.rawValue])
      
        self.reloadTableview(tbleViewMain: self.tableView_settings)
        
    }
    
    func RegisterXib(){
        self.tableView_settings.register(UINib(nibName: "profileSettingsTitleCell", bundle: nil), forCellReuseIdentifier: "profileSettingsTitleCell")
        self.tableView_settings.register(UINib(nibName: "profileSettingUserInfoCell", bundle: nil), forCellReuseIdentifier: "profileSettingUserInfoCell")
        self.tableView_settings.register(UINib(nibName: "profileSettingsDetailCell", bundle: nil), forCellReuseIdentifier: "profileSettingsDetailCell")
        self.tableView_settings.register(UINib(nibName: "profileSettingsEmailCel", bundle: nil), forCellReuseIdentifier: "profileSettingsEmailCel")
        self.tableView_settings.register(UINib(nibName: "profileSettingsEmailCell", bundle: nil), forCellReuseIdentifier: "profileSettingsEmailCell")
        self.tableView_settings.register(UINib(nibName: "profileSettingsMedicalConditionsCell", bundle: nil), forCellReuseIdentifier: "profileSettingsMedicalConditionsCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let DataElement = self.mainArray[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        switch dataType {
        case profileSettings.profileSettingsTitleCell.rawValue:
            return profileSettingsTitleCell(tableView:tableView  ,cellForRowAt:indexPath)
        case profileSettings.profileSettingsUserInfo.rawValue:
            return profileInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.profileSettingsDetailCell.rawValue:
            return profileSettingsDetailCell(tableView:tableView  ,cellForRowAt:indexPath)
        case profileSettings.profileSettingsEmailCell.rawValue:
            return profileSettingsEmailCell(tableView:tableView  ,cellForRowAt:indexPath)
        case profileSettings.profileSettingsMedicalConditionsCell.rawValue:
            return profileSettingsMedicalConditionsCell(tableView:tableView  ,cellForRowAt:indexPath)
        default:
            return profileSettingsMedicalConditionsCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }

    //MARK: settingCell0
    func profileInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingUserInfoCell") as? profileSettingUserInfoCell
        
        
        cell?.btn_UploadImage.addTarget(self, action: #selector(self.ShowUploadImage), for: UIControlEvents.touchUpInside)
        
        cell?.btn_Followers.addTarget(self, action: #selector(self.ShowFollowers), for: UIControlEvents.touchUpInside)

        cell?.btn_Following.addTarget(self, action: #selector(self.ShowFollowing), for: UIControlEvents.touchUpInside)

        
        cell?.btn_Back.addTarget(self, action: #selector(self.BackAction), for: UIControlEvents.touchUpInside)

        cell?.btn_Home.addTarget(self, action: #selector(self.HomeAction), for: UIControlEvents.touchUpInside)

        cell?.btn_EditCoverPhoto.addTarget(self, action: #selector(self.EditoverPhotoAction), for: UIControlEvents.touchUpInside)
        
        cell?.btn_EditName.addTarget(self, action: #selector(self.EditName), for: UIControlEvents.touchUpInside)

        cell?.btn_BoomingBud.addTarget(self, action: #selector(self.BloomingBud), for: UIControlEvents.touchUpInside)

        cell?.btn_Gallery.addTarget(self, action: #selector(self.ShowGallery), for: UIControlEvents.touchUpInside)

        
   
        
        cell?.lblName.text = self.userMain.userFirstName
        cell?.lblName.textColor = UserProfileViewController.userMain.colorMAin
        cell?.lblBloomingBud.text = self.userMain.bloomingBudText
        cell?.lblBloomingBud.textColor = UserProfileViewController.userMain.colorMAin
        cell?.lblPoints.text = self.userMain.Points
        cell?.lblPoints.textColor = UserProfileViewController.userMain.colorMAin
        cell?.lblFollowers.text = self.userMain.followers_count
        cell?.lblFollowing.text = self.userMain.followings_count
        if (self.userMain.profilePictureURL).contains("facebook.com") || (self.userMain.profilePictureURL).contains("google.com"){
             cell?.imgViewUser.moa.url = (self.userMain.profilePictureURL).RemoveSpace()
        }else{
             cell?.imgViewUser.moa.url = WebServiceName.images_baseurl.rawValue + (self.userMain.profilePictureURL).RemoveSpace()
        }
        if self.userMain.special_icon.count > 6 {
            cell?.imgViewUserTop.isHidden = false
            cell?.imgViewUserTop.moa.url = WebServiceName.images_baseurl.rawValue +  (self.userMain.special_icon).RemoveSpace()
        }else {
            cell?.imgViewUserTop.isHidden = true
        }
        
        cell?.img_indicator_line.backgroundColor = UserProfileViewController.userMain.colorMAin
        cell?.img_user_point_rating.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        cell?.img_user_point_rating.tintColor = UserProfileViewController.userMain.colorMAin
        print(WebServiceName.images_baseurl.rawValue + (self.userMain.profilePictureURL))
        print( WebServiceName.images_baseurl.rawValue + (self.userMain.coverPhoto).RemoveSpace())
        cell?.imgViewBG.image = nil
        if isCoverUpdateLocally {
           cell?.imgViewBG.image  = self.coverImage
        }else{
             cell?.imgViewBG.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.coverPhoto.RemoveSpace()), completed: nil)
        }
       
        cell?.selectionStyle = .none
        return cell!
    }

    func ShowGallery(sender : UIButton){
        
        
        let viewMain = self.GetView(nameViewController: "UserGalleryViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserGalleryViewController
        viewMain.userID = self.userMain.ID
        self.navigationController?.pushViewController(viewMain, animated: true)
        
        
    }
    
    
    func BloomingBud(sender : UIButton){
        
        let viewMain = self.GetView(nameViewController: "BloomingBudViewController", nameStoryBoard: StoryBoardConstant.Profile) as! BloomingBudViewController
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    
    func EditName(){
        self.view_Name.isHidden = false
//        self.txtField_Name.becomeFirstResponder()
        self.txtField_Name.text = self.userMain.userFirstName
    }
    
    //MARK: settingCell1
    func profileSettingsTitleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsTitleCell") as? profileSettingsTitleCell
         cell?.viewBG.backgroundColor =  UIColor.gray
        if indexPath.row == 1 {
            cell?.lblMainHeading.text = "About Me"
            cell?.btnMAin.addTarget(self, action: #selector(self.ShowAboutMe), for: UIControlEvents.touchUpInside)
        }else {
            cell?.lblMainHeading.text = "My Experience"
            cell?.btnMAin.addTarget(self, action: #selector(self.AddExpertiesAction), for: UIControlEvents.touchUpInside)

            
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func AddExpertiesAction(sender : UIButton){

        let expertiesView = self.GetView(nameViewController: "AddYourEpertiesVC", nameStoryBoard: "ProfileView") as! AddYourEpertiesVC
        expertiesView.isShowComplete = true
        expertiesView.Choose1 = self.experty1
        expertiesView.Choose2 = self.experty2
        expertiesView.ispopView = true
        
        expertiesView.ChangeEpertiesDelegate = self as! ChangeEpertiesDelegate
        self.navigationController?.pushViewController(expertiesView, animated: true)
        
        
    }
    
    func NewExperties(experties : [AddExperties] , experties2 :[AddExperites2]){
        if experties.count == 0 && experties2.count == 0 {
           if  let cell = self.tableView_settings.cellForRow(at: IndexPath.init(row: 7, section: 0)) as? profileSettingsMedicalConditionsCell {
            // By default Hide
            cell.medicalExpertyWarnView1.isHidden = true
            cell.medicalExpertyWarnView2.isHidden = true
            cell.medicalExpertyWarnView3.isHidden = true
            cell.medicalExpertyWarnView4.isHidden = true
            cell.medicalExpertyWarnView5.isHidden = true
            
            cell.strainExpertyWarnView1.isHidden = true
            cell.strainExpertyWarnView2.isHidden = true
            cell.strainExpertyWarnView3.isHidden = true
            cell.strainExpertyWarnView4.isHidden = true
            cell.strainExpertyWarnView5.isHidden = true
            
            
            // hide vies
            cell.medicalExpertyView1.isHidden = true
            cell.medicalExpertyView2.isHidden = true
            cell.medicalExpertyView3.isHidden = true
            cell.medicalExpertyView4.isHidden = true
            cell.medicalExpertyView5.isHidden = true
            cell.medicalExpertyView1.isHidden = true
            cell.stackView1Height.constant = 0
            
            
            cell.strainExpertyView1.isHidden = true
            cell.strainExpertyView2.isHidden = true
            cell.srainExpertyView3.isHidden = true
            cell.strainExpertyView4.isHidden = true
            cell.strainExpertyView5.isHidden = true
            cell.stackView2Height.constant = 0
            cell.strainExpertyView1.isHidden = true
            
            
            cell.lblMedicalConditions.isHidden = false
            cell.lblMedicalConditions.text = "None Listed"
             cell.lblStrains.isHidden = false
            cell.lblStrains.text = "None Listed"
            }       
//            return
        }
        self.mainArray.removeAll()
        self.tableView_settings.reloadData()
        self.showLoading()
        self.blinking_image.isHidden = false
        let urlMain = WebServiceName.get_user_profile.rawValue + (DataManager.sharedInstance.user?.ID)! + "?time_zone=+05:00&skip=0&lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        print(urlMain)
        NetworkManager.GetCall(UrlAPI: urlMain) { (successMain, message, MainData) in
            print(MainData)
            self.hideLoading()
            self.blinking_image.isHidden = true
            let userDict = MainData["successData"] as? [String : Any]
            let userArray = userDict!["user_data"] as? [[String : Any]]
            if (userArray?.count)! > 0 {
                UserProfileViewController.userMain = User.init(json: userArray?.first as [String : AnyObject]?)
                let experties = userArray?.first!["get_expertise"] as! [[String : Any]]
                self.experty1.removeAll()
                self.experty2.removeAll()
                self.expery_One = ""
                self.expery_Two = ""
                    for indexObj in experties {
                        if let m = indexObj["medical"] as? [String: Any]{
                            self.experty1.append(AddExperties.init(json: indexObj["medical"] as? [String : AnyObject]))
                            if self.expery_One.characters.count == 0 {
                                self.expery_One = (indexObj["medical"] as! [String : Any])["m_condition"] as! String
                            }else {
                                self.expery_One =  self.expery_One + "\n" + ((indexObj["medical"] as! [String : Any])["m_condition"] as! String)
                            }
                        }else {
                            self.experty2.append(AddExperites2.init(json: indexObj["strain"] as! [String : AnyObject]))
                            
                            
                            if self.expery_Two.characters.count == 0 {
                                self.expery_Two = (indexObj["strain"] as! [String : Any])["title"] as! String
                            }else {
                                self.expery_Two =  self.expery_Two + "\n" + ((indexObj["strain"] as! [String : Any])["title"] as! String)
                            }
                        }
                    }
                self.ReloadData()
            }
        }
//        self.experty1 = experties
//        self.experty2 = experties2
//        self.expery_One = ""
//        self.expery_Two = ""
//
//        for indexObj in self.experty1 {
//            if self.expery_One.characters.count == 0 {
//                self.expery_One = indexObj.title
//            }else {
//                self.expery_One = self.expery_One + "\n" + indexObj.title
//            }
//        }
//
//        for indexObj in self.experty2 {
//            if self.expery_Two.characters.count == 0 {
//                self.expery_Two = indexObj.title
//            }else {
//                self.expery_Two = self.expery_Two + "\n" + indexObj.title
//            }
//        }
//
    }
    
    //MARK: settingCell2
    func profileSettingsDetailCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsDetailCell") as? profileSettingsDetailCell
        if self.userMain.Bio.isEmpty{
            cell?.lblText.text = "No biography available."
            cell?.lblText.textAlignment = .center
        }else{
            cell?.lblText.textAlignment = .left
             cell?.lblText.text = self.userMain.Bio
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func profileSettingsEmailCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsEmailCell") as? profileSettingsEmailCell
        
        if indexPath.row == 3 {
            cell?.lbl_Heading.text = "Email"
            cell?.lbl_info.text = self.userMain.email
        }else if indexPath.row == 4 {
            cell?.lbl_Heading.text = "Password"
            cell?.lbl_info.text = "*******"
        }else  {
            cell?.lbl_Heading.text = "Zipcode"
            if self.userMain.zipcode == "0" {
                 cell?.lbl_info.text = ""
            }else{
                 cell?.lbl_info.text = self.userMain.zipcode
            }
           
        }
        
        cell?.btnMAin.addTarget(self, action: #selector(self.ShowEmail), for: UIControlEvents.touchUpInside)
        cell?.btnMAin.tag = indexPath.row
        
        cell?.selectionStyle = .none
        return cell!
    }
    func profileSettingsMedicalConditionsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsMedicalConditionsCell") as? profileSettingsMedicalConditionsCell
        cell?.lblStrains.text = self.expery_Two
        cell?.lblMedicalConditions.text = self.expery_One
        
        // By default Hide
        cell?.medicalExpertyWarnView1.isHidden = true
        cell?.medicalExpertyWarnView2.isHidden = true
        cell?.medicalExpertyWarnView3.isHidden = true
        cell?.medicalExpertyWarnView4.isHidden = true
        cell?.medicalExpertyWarnView5.isHidden = true
        
        cell?.strainExpertyWarnView1.isHidden = true
        cell?.strainExpertyWarnView2.isHidden = true
        cell?.strainExpertyWarnView3.isHidden = true
        cell?.strainExpertyWarnView4.isHidden = true
        cell?.strainExpertyWarnView5.isHidden = true

        
        // hide vies
        cell?.medicalExpertyView1.isHidden = true
        cell?.medicalExpertyView2.isHidden = true
        cell?.medicalExpertyView3.isHidden = true
        cell?.medicalExpertyView4.isHidden = true
        cell?.medicalExpertyView5.isHidden = true
        cell?.medicalExpertyView1.isHidden = true
        cell?.stackView1Height.constant = 0
        
        
        cell?.strainExpertyView1.isHidden = true
        cell?.strainExpertyView2.isHidden = true
        cell?.srainExpertyView3.isHidden = true
        cell?.strainExpertyView4.isHidden = true
        cell?.strainExpertyView5.isHidden = true
        cell?.stackView2Height.constant = 0
        cell?.strainExpertyView1.isHidden = true
        cell?.lblMedicalConditions.isHidden = false
         cell?.lblStrains.isHidden = false
        if expery_Two == ""{
            cell?.lblStrains.text = "None Listed"
        }else{
            cell?.lblStrains.text = self.expery_Two
        }
        if expery_One == ""{
            cell?.lblMedicalConditions.text = "None Listed"
        }else{
            cell?.lblMedicalConditions.text = self.expery_One
        }
//        if experty1.count > 0{
//            for i in 0...self.experty1.count-1{
//                switch i{
//                case 0:
//                    cell?.stackView1Height.constant = 25
//                    cell?.medicalExpertyView1.isHidden = false
//                    cell?.medicalExpertyLabel1.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0 {
//                        cell?.medicalExpertyWarnView1.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView1.isHidden = true
//                    }
//                case 1:
//                    cell?.stackView1Height.constant = 50
//                    cell?.medicalExpertyView2.isHidden = false
//                    cell?.medicalExpertyLabel2.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0 {
//                        cell?.medicalExpertyWarnView2.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView2.isHidden = true
//                    }
//                case 2:
//                    cell?.stackView1Height.constant = 75
//                    cell?.medicalExpertyView3.isHidden = false
//                    cell?.medicalExpertyLabel3.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0 {
//                        cell?.medicalExpertyWarnView3.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView3.isHidden = true
//                    }
//
//                case 3:
//                    cell?.stackView1Height.constant = 100
//                    cell?.medicalExpertyView4.isHidden = false
//                    cell?.medicalExpertyLabel4.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0 {
//                        cell?.medicalExpertyWarnView4.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView4.isHidden = true
//                    }
//
//                case 4:
//                    cell?.stackView1Height.constant = 125
//                    cell?.medicalExpertyView5.isHidden = false
//                    cell?.medicalExpertyLabel5.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0{
//                        cell?.medicalExpertyWarnView5.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView5.isHidden = true
//                    }
//
//
//                default:
//                    cell?.stackView1Height.constant = 0
//                    cell?.medicalExpertyView1.isHidden = false
//                    cell?.medicalExpertyLabel1.text = self.experty1[i].title
//                    if self.experty1[i].is_approved == 0 {
//                        cell?.medicalExpertyWarnView1.isHidden = false
//                    }else{
//                        cell?.medicalExpertyWarnView1.isHidden = true
//                    }
//
//                }
//            }
//        }else {
//            cell?.lblMedicalConditions.text = "None Listed"
//            cell?.lblMedicalConditions.isHidden = false
//        }
        
//        if experty2.count > 0{
//            for i in 0...self.experty2.count-1{
//                switch i{
//                case 0:
//                    cell?.stackView2Height.constant = 25
//                    cell?.strainExpertyView1.isHidden = false
//                    cell?.strainExpertyLabel1.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView1.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView1.isHidden = true
//                    }
//
//                case 1:
//                    cell?.stackView2Height.constant = 50
//                    cell?.strainExpertyView2.isHidden = false
//                    cell?.strainExpertyLabel2.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView2.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView2.isHidden = true
//                    }
//
//                case 2:
//                    cell?.stackView2Height.constant = 75
//                    cell?.srainExpertyView3.isHidden = false
//                    cell?.strainExpertyLabel3.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView3.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView3.isHidden = true
//                    }
//
//                case 3:
//                    cell?.stackView2Height.constant = 100
//                    cell?.strainExpertyView4.isHidden = false
//                    cell?.strainExpertyLabel4.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView4.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView4.isHidden = true
//                    }
//
//                case 4:
//                    cell?.stackView2Height.constant = 125
//                    cell?.strainExpertyView5.isHidden = false
//                    cell?.strainExpertyLabel5.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView5.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView5.isHidden = true
//                    }
//
//
//                default:
//                    cell?.stackView2Height.constant = 0
//                    cell?.strainExpertyView1.isHidden = false
//                    cell?.strainExpertyLabel1.text = self.experty2[i].title
//                    if self.experty2[i].is_approved == 0 {
//                        cell?.strainExpertyWarnView1.isHidden = false
//                    }else{
//                        cell?.strainExpertyWarnView1.isHidden = true
//                    }
//
//                }
//            }
//        }else{
//            cell?.lblStrains.text = "None Listed"
//            cell?.lblStrains.isHidden = false
//        }

        cell?.setMedicalLayout(numbr: self.experty1.count)
        cell?.setStrainLayout(numbr: self.experty2.count)
        cell?.selectionStyle = .none
        return cell!
    }
}

//MARK:
//MARK: Button Actions
extension profileSettingsVC {
    func ShowAboutMe(sender : UIButton){
    
        self.view_AboutMe.isHidden = false
        self.txtView_AboutMe.text = self.userMain.Bio
    
    }
    
    @IBAction func HideAboutMe(sender :UIButton){
        self.view_AboutMe.isHidden = true
    }
    
    func ShowEmail(sender : UIButton){
        
        if sender.tag == 3 {
            self.view_Email.isHidden = false
            self.txtField_NewEmail.text = ""
            self.txtField_OldEmail.text = ""
        }else if sender.tag == 4 {
            self.view_Password.isHidden = false
            self.txtField_Password.text = ""
            self.txtField_ConfirmPassword.text = ""
        }else {
            self.view_ZipCode.isHidden = false
            self.txtField_ZipCode.text = self.userMain.zipcode
        }
    }
    
    @IBAction func DoneNameAction(sender : UIButton){
//        self.HideAllValues()
        self.UpdateName()
    }
    @IBAction func CrossNameAction(sender : UIButton){
        self.HideAllValues()
        //        self.UpdateName()
    }

    func UpdateName(){
       
        if self.txtField_Name.text!.characters.count > 1 {
            var newParam = [String : AnyObject]()
            if self.txtField_Name.text?.trimmingCharacters(in: .whitespaces) != ""{
            newParam["name"] = self.txtField_Name.text?.trimmingCharacters(in: .whitespaces) as AnyObject
            self.showLoading()
            NetworkManager.PostCall(UrlAPI: WebServiceName.update_name.rawValue, params: newParam) { (successMain, successMessage, DataMain) in
                self.view.hideLoading()
                if successMain {
                    if (DataMain["successMessage"] as? String) != nil {
                        self.HideAllValues()
                        self.userMain.userFirstName = self.txtField_Name.text!.trimmingCharacters(in: .whitespaces)
                        self.ReloadData()
                    }else if (DataMain["errorMessage"] as! String) == "Session Expired" {
                        
                    }else {
                        self.ShowErrorAlert(message: DataMain["errorMessage"] as! String)
                    }
                }else {
                    self.ShowErrorAlert(message:successMessage)
                }
            }
            
            
            }else{
                self.ShowErrorAlert(message: "Please enter a valid username!")
            }
        }
    }
    
    @IBAction func UpdatePasswordAction(sender : UIButton){
        
        self.UpdatePassword()
        
        self.HideAllValues()
    }
    
    
    func UpdatePassword(){
        if self.txtField_Password.text == self.txtField_ConfirmPassword.text{
        if self.txtField_Password.text!.characters.count >= 6 {
            var newParam = [String : AnyObject]()
            newParam["password"] = self.txtField_Password.text as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.change_password.rawValue, params: newParam) { (successMain, successMessage, DataMain) in
                if successMain{
                    self.ShowSuccessAlertWithNoAction(message: "Password updated successfully!")
                }else{
                    self.ShowErrorAlert(message: successMessage)
                }
            }
            
            self.userMain.password = self.txtField_Password.text!
            self.ReloadData()
        }else{
            self.ShowErrorAlert(message: "Enter Password must be 6 character!")
        }
        }else{
            self.ShowErrorAlert(message: "Password not match!")
        }
    }
    
    @IBAction func UpdateZipAction(sender : UIButton){
        
        self.UpdateZip()
        
        self.HideAllValues()
    }
    
    
    func UpdateZip(){
        
        if self.txtField_ZipCode.text!.characters.count > 1
        {
            
            self.showLoading()
            NetworkManager.getUserAddressFromZipCode(zipcode: self.txtField_ZipCode.text!, completion: { (success, message, response) in
                self.hideLoading()
                print(message)
                print(response ?? "text" )
                print(response!["results"] ?? "text")
                if(success){
                    if( ((response!["results"] as! [[String : Any]]).count) > 0){
                        let user = DataManager.sharedInstance.user
                        user?.zipcode = self.txtField_ZipCode.text!
                        var location : String =  (response!["results"] as! [[String : Any]])[0]["formatted_address"] as! String
                        user?.userlat = String((((response!["results"] as! [[String : Any]])[0]["geometry"] as! [String : AnyObject])["location"] as! [String : AnyObject])["lat"] as! Double)
                        user?.userlng = String((((response!["results"] as! [[String : Any]])[0]["geometry"] as! [String : AnyObject])["location"] as! [String : AnyObject])["lng"] as! Double)
                        
                        location = location.replacingOccurrences(of: (self.txtField_ZipCode.text!), with: "")
                        print("Lng ====> ")
                        print(user?.userlng)
                        print("Lat ====> ")
                        print(user?.userlat)
                        
                        user?.address = location
                        DataManager.sharedInstance.user = user
                        
                        
                        
                        print(DataManager.sharedInstance.user?.userlat )
                        print(DataManager.sharedInstance.user?.userCurrentlat)
                        
                        print(DataManager.sharedInstance.user?.userlng)
                        print(DataManager.sharedInstance.user?.userCurrentlng)
                        
                        
                        
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userlat )
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userCurrentlat)
                        
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userlng)
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userCurrentlng)
                        
                        
                        
                        DataManager.sharedInstance.saveUserPermanentally()
                        
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userlat )
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userCurrentlat)
                        
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userlng)
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.userCurrentlng)
                        
                        
                        var newParam = [String : AnyObject]()
                        newParam["zip"] = self.txtField_ZipCode.text as AnyObject
                        newParam["lat"]  =  user?.userlat as AnyObject
                        newParam["lng"]  = user?.userlng as AnyObject
                        NetworkManager.PostCall(UrlAPI: WebServiceName.update_zip.rawValue, params: newParam) { (successMain, successMessage, DataMain) in
                            
                        }
                        
                        self.userMain.zipcode = self.txtField_ZipCode.text!
                        self.ReloadData()
                        
                        
//                        self.PushViewWithIdentifier(name: "ChooseProfileImageViewController")
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
//        }
    }
    
    @IBAction func UpdateBioAction(sender : UIButton){
        
        
        if self.txtView_AboutMe.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            self.ShowErrorAlert(message: "Enter Bio!")
            return
        }
        
        
        
        self.UpdateBio()
        
        self.HideAllValues()
    }
    
    
    func UpdateBio(){
        
        if self.txtView_AboutMe.text!.characters.count > 1 {
            var newParam = [String : AnyObject]()
            newParam["bio"] = self.txtView_AboutMe.text as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.update_bio.rawValue, params: newParam) { (successMain, successMessage, DataMain) in
                
            }
            self.userMain.Bio = self.txtView_AboutMe.text!
            self.ReloadData()
        }
    }
    
    
    func UpdateEmail(){
        
        if self.txtField_OldEmail.text!.characters.count > 1 {
            
            if self.txtField_OldEmail.text == self.txtField_NewEmail.text {
                if self.EmailValidation(textField: self.txtField_OldEmail){
                    var newParam = [String : AnyObject]()
                    newParam["email"] = self.txtField_NewEmail.text as AnyObject
                    NetworkManager.PostCall(UrlAPI: WebServiceName.update_email.rawValue, params: newParam) { (successMain, successMessage, DataMain) in
                        print(DataMain)
                        if successMain{
                            self.ShowSuccessAlertWithNoAction(message: "Email updated successfully!")
                        }else{
                            self.ShowErrorAlert(message: successMessage)
                        }
                    }
                    
                    self.userMain.email = self.txtField_OldEmail.text!
                    self.ReloadData()
                }
            }else {
                self.ShowErrorAlert(message: "Email not match!")
            }
        }else {
            self.ShowErrorAlert(message: "Enter email address!")
        }
    }
    @IBAction func HideEmailView(sender : UIButton){
        
        self.UpdateEmail()

        self.HideAllValues()
    }
    
    @IBAction func HideAllView(sender : UIButton){
        
        
        
        self.HideAllValues()
    }
    
    func HideAllValues()
    {
        self.view_Email.isHidden = true
        self.view_Password.isHidden = true
        self.view_ZipCode.isHidden = true
        self.view_UploadImage.isHidden = true
        self.view_Name.isHidden = true
        self.view_AboutMe.isHidden = true
        
        self.txtField_Name.resignFirstResponder()
        self.txtField_ConfirmPassword.resignFirstResponder()
        self.txtField_Password.resignFirstResponder()
        self.txtField_OldEmail.resignFirstResponder()
        self.txtField_NewEmail.resignFirstResponder()
        self.txtField_ZipCode.resignFirstResponder()
        self.txtView_AboutMe.resignFirstResponder()
    }
    
    func ShowUploadImage(sender : UIButton){
        self.GetImages()
        if (self.userMain.profilePictureURL).contains("facebook.com") || (self.userMain.profilePictureURL).contains("google.com"){
           self.imgView_ChangeProfile.moa.url =  self.userMain.profilePictureURL.RemoveSpace()
        }else{
           self.imgView_ChangeProfile.moa.url = WebServiceName.images_baseurl.rawValue + self.userMain.profilePictureURL.RemoveSpace()
        }
        self.specialImage.moa.url = WebServiceName.images_baseurl.rawValue + self.userMain.special_icon.RemoveSpace()
        self.view_UploadImage.isHidden = false
    }

    @IBAction func ChangeImage(sender : UIButton){
        
        self.UploadImage()
    }
    
    func UploadImage(){
        self.view.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.upload_profile_img.rawValue , image: (self.imgView_ChangeProfile.image)!, withParams: ["":"" as AnyObject], onView: self) { (responseMain) in
            print(responseMain)
            
            self.view_UploadImage.isHidden = true
            if (responseMain["status"] as! String) == "success"{
                DataManager.sharedInstance.user?.profilePictureURL = responseMain["successData"] as! String
                self.userMain.profilePictureURL = responseMain["successData"] as! String
                DataManager.sharedInstance.saveUserPermanentally()
                self.UpdateAvater()
                
            }else {
                self.hideLoading()
                self.view.hideLoading()
            }
           
        }
    }
    
    
    func UpdateAvater(){

        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_image.rawValue , image: (self.imgView_ChangeProfile.image)!, withParams: ["avatar":DataManager.sharedInstance.user?.profilePictureURL as AnyObject], onView: self) { (responseMain) in
            print(responseMain)
            self.hideLoading()
            if (responseMain["status"] as! String) == "success"{
                
            }else {
                self.view.hideLoading()
            }
            self.tableView_settings.reloadData()
        }
        NetworkManager.PostCall(UrlAPI: WebServiceName.update_special_icon.rawValue, params: ["special_icon": (DataManager.sharedInstance.user?.special_icon)! as AnyObject], completion: {
            (success, message, responseMain) in
            print(responseMain)
            self.hideLoading()
            if (responseMain["status"] as! String) == "success"{
                
            }else {
                self.view.hideLoading()
            }
            self.tableView_settings.reloadData()
        })
    }
    
    
    
    @IBAction func OpenCamera(sender : UIButton){
         self.isCoverChoose = false
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
    }
    func captured(image: UIImage) {
        if self.isCoverChoose {
            let mycell = self.tableView_settings.cellForRow(at: IndexPath.init(row: 0, section: 0   )) as! profileSettingUserInfoCell
            mycell.imgViewBG.image = image
            self.coverImage = image
            isCoverUpdateLocally = true
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_cover.rawValue, image: image, onView: self, completion: { (MainResponse) in
                print(MainResponse)
            })
        }else{
            let newAttachment = Attachment()
            newAttachment.is_Video = false
            newAttachment.image_Attachment = image
            newAttachment.ID = "-1"
            self.imgView_ChangeProfile.image = image
            self.array_Attachment.append(newAttachment)
        }
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        if self.isCoverChoose {
            let mycell = self.tableView_settings.cellForRow(at: IndexPath.init(row: 0, section: 0   )) as! profileSettingUserInfoCell
            mycell.imgViewBG.image = image
            self.coverImage = image
            isCoverUpdateLocally = true
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_cover.rawValue, image: image, onView: self, completion: { (MainResponse) in
                print(MainResponse)
            })
        }else{
            let newAttachment = Attachment()
            newAttachment.is_Video = false
            newAttachment.image_Attachment = image
            newAttachment.ID = "-1"
            self.imgView_ChangeProfile.image = image
            self.array_Attachment.append(newAttachment)
        }
    }
    
    
    
    func ShowFollowers(sender : UIButton){
        mainFollowers = self.GetView(nameViewController: "FollowersViewController", nameStoryBoard: "ProfileView") as! FollowersViewController
        (mainFollowers as! FollowersViewController).delegate2 = self
        (mainFollowers as! FollowersViewController).isFollower = true
        (mainFollowers as! FollowersViewController).UserID = (DataManager.sharedInstance.user?.ID)!
            self.view.addSubview(mainFollowers.view)
    }

    func ShowFollowing(sender : UIButton){
        mainFollowers = self.GetView(nameViewController: "FollowersViewController", nameStoryBoard: "ProfileView") as! FollowersViewController
        (mainFollowers as! FollowersViewController).isFollower = false
        (mainFollowers as! FollowersViewController).delegate2 = self
        (mainFollowers as! FollowersViewController).UserID = (DataManager.sharedInstance.user?.ID)!
        self.view.addSubview(mainFollowers.view)
    }
    
    func BackAction(sender : UIButton){
        UserProfileViewController.userMain = self.userMain
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func HomeAction(sender : UIButton){
//        self.navigationController?.popViewController(animated: true)
        self.GotoHome()
    }
    
    
    func EditoverPhotoAction(sender : UIButton){
        self.isCoverChoose = true
//        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
//        vcCamera.delegate = self
//        vcCamera.isOnlyImage = true
//        self.navigationController?.pushViewController(vcCamera, animated: true)
        let storyboard = UIStoryboard(name: "ProfileView", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "EditCoverPhotoVC")) as! EditCoverPhotoVC
//        viewObj.userMain = self.userMain
        self.navigationController?.pushViewController(viewObj, animated: true)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtField_Name {
//            self.UpdateName()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == specialCollectionView{
         return avator_special_imgs.count
        }else{
        return avator_imgs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == specialCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatorCollectionViewCell", for: indexPath) as! AvatorCollectionViewCell
            
            let mainUrl = WebServiceName.images_baseurl.rawValue + (self.avator_special_imgs[indexPath.row]["name"] as! String)
            cell.avator_img.moa.url = mainUrl.RemoveSpace()
            return cell
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatorCollectionViewCell", for: indexPath) as! AvatorCollectionViewCell
        
        let mainUrl = WebServiceName.images_baseurl.rawValue + (self.avator_imgs[indexPath.row]["name"] as! String)
        cell.avator_img.moa.url = mainUrl.RemoveSpace()
        return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.avator_Selected_imgs = self.avator_imgs[indexPath.row]
        if collectionView == specialCollectionView{
            let cellMain = collectionView.cellForItem(at: indexPath) as! AvatorCollectionViewCell
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + (self.avator_special_imgs[indexPath.row]["name"] as! String)){
                self.specialImage.af_setImage(withURL: url)
            }
            DataManager.sharedInstance.user?.special_icon = self.avator_special_imgs[indexPath.row]["name"] as! String
            self.userMain.special_icon = self.avator_special_imgs[indexPath.row]["name"] as! String
        
        }else{
        let cellMain = collectionView.cellForItem(at: indexPath) as! AvatorCollectionViewCell
        self.imgView_ChangeProfile.image = cellMain.avator_img.image
        self.userMain.avatarImage = self.avator_imgs[indexPath.row]["name"] as! String
        }
    }
    
    
    
    func ReloadFollowersData(notification: NSNotification){
        
        if let count = notification.userInfo?["count"] as? String {
            let cellMain = self.tableView_settings.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! profileSettingUserInfoCell
            self.userMain.followings_count = String(Int(self.userMain.followings_count)! + Int(count)!)
            cellMain.lblFollowing.text = self.userMain.followings_count
            //            }
        }
    }
    
   
}


class profileSettingsTitleCell:UITableViewCell{
    @IBOutlet var lblMainHeading : UILabel!
    @IBOutlet var viewEdit : UIView!
    @IBOutlet var viewBG : UIView!
    
    @IBOutlet weak var btn_see_all: UIButton!
    @IBOutlet var btnMAin : UIButton!
}
class profileSettingsDetailCell:UITableViewCell{
    @IBOutlet var lblText : UILabel!
    
    @IBOutlet var imgViewLine : UIImageView!
}
class profileSettingsEmailCell:UITableViewCell{
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var lbl_info : UILabel!
    
    @IBOutlet var btnMAin : UIButton!
}
class profileSettingsMedicalConditionsCell:UITableViewCell{
    @IBOutlet weak var md1hightcnst: NSLayoutConstraint!
    @IBOutlet weak var md2hightcnst: NSLayoutConstraint!
    @IBOutlet weak var md3hightcnst: NSLayoutConstraint!
    @IBOutlet weak var md4hightcnst: NSLayoutConstraint!
    @IBOutlet weak var md5hightcnst: NSLayoutConstraint!
    
    
    @IBOutlet weak var st1hightcnst: NSLayoutConstraint!
    @IBOutlet weak var st2hightcnst: NSLayoutConstraint!
    @IBOutlet weak var st3hightcnst: NSLayoutConstraint!
    @IBOutlet weak var st4hightcnst: NSLayoutConstraint!
    @IBOutlet weak var st5hightcnst: NSLayoutConstraint!
    func setStrainLayout(numbr : Int) {
        switch numbr {
        case 1:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 0
            self.st3hightcnst.constant = 0
            self.st4hightcnst.constant = 0
            self.st5hightcnst.constant = 0
            break;
        case 2:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 24
            self.st3hightcnst.constant = 0
            self.st4hightcnst.constant = 0
            self.st5hightcnst.constant = 0
            break;
        case 3:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 24
            self.st3hightcnst.constant = 24
            self.st4hightcnst.constant = 0
            self.st5hightcnst.constant = 0
            break;
        case 4:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 24
            self.st3hightcnst.constant = 24
            self.st4hightcnst.constant = 24
            self.st5hightcnst.constant = 0
            break;
        case 5:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 24
            self.st3hightcnst.constant = 24
            self.st4hightcnst.constant = 24
            self.st5hightcnst.constant = 24
            break;
        default:
            self.st1hightcnst.constant = 24
            self.st2hightcnst.constant = 0
            self.st3hightcnst.constant = 0
            self.st4hightcnst.constant = 0
            self.st5hightcnst.constant = 0
            break;
        }
    }
    
    func setMedicalLayout(numbr : Int) {
        switch numbr {
        case 1:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 0
            self.md3hightcnst.constant = 0
            self.md4hightcnst.constant = 0
            self.md5hightcnst.constant = 0
            break;
        case 2:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 24
            self.md3hightcnst.constant = 0
            self.md4hightcnst.constant = 0
            self.md5hightcnst.constant = 0
            break;
        case 3:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 24
            self.md3hightcnst.constant = 24
            self.md4hightcnst.constant = 0
            self.md5hightcnst.constant = 0
            break;
        case 4:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 24
            self.md3hightcnst.constant = 24
            self.md4hightcnst.constant = 24
            self.md5hightcnst.constant = 0
            break;
        case 5:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 24
            self.md3hightcnst.constant = 24
            self.md4hightcnst.constant = 24
            self.md5hightcnst.constant = 24
            break;
        default:
            self.md1hightcnst.constant = 24
            self.md2hightcnst.constant = 0
            self.md3hightcnst.constant = 0
            self.md4hightcnst.constant = 0
            self.md5hightcnst.constant = 0
            break;
        }
    }
    
    @IBOutlet var lblStrains             : UILabel!
    @IBOutlet var lblMedicalConditions  : UILabel!
    @IBOutlet var medicalExpertyView1: UIView!
    @IBOutlet var medicalExpertyWarnView1: UIView!
    @IBOutlet var medicalExpertyWarnPopUp1: UIView!
    @IBOutlet var medicalExpertyLabel1: UILabel!
    @IBOutlet var medicalExpertyView2: UIView!
    @IBOutlet var medicalExpertyWarnView2: UIView!
    @IBOutlet var medicalExpertyWarnPopUp2: UIView!
    @IBOutlet var medicalExpertyLabel2: UILabel!
    @IBOutlet var medicalExpertyView3: UIView!
    @IBOutlet var medicalExpertyWarnView3: UIView!
    @IBOutlet var medicalExpertyWarnPopUp3: UIView!
    @IBOutlet var medicalExpertyLabel3: UILabel!
    @IBOutlet var medicalExpertyView4: UIView!
    @IBOutlet var medicalExpertyWarnView4: UIView!
    @IBOutlet var medicalExpertyWarnPopUp4: UIView!
    @IBOutlet var medicalExpertyLabel4: UILabel!
    @IBOutlet var medicalExpertyView5: UIView!
    @IBOutlet var medicalExpertyWarnView5: UIView!
    @IBOutlet var medicalExpertyWarnPopUp5: UIView!
    @IBOutlet var medicalExpertyLabel5: UILabel!
    @IBOutlet var strainExpertyView1: UIView!
    @IBOutlet var strainExpertyWarnView1: UIView!
    @IBOutlet var strainExpertyWarnPopUp1: UIView!
    @IBOutlet var strainExpertyLabel1: UILabel!
    @IBOutlet var strainExpertyView2: UIView!
    @IBOutlet var strainExpertyWarnView2: UIView!
    @IBOutlet var strainExpertyWarnPopUp2: UIView!
    @IBOutlet var strainExpertyLabel2: UILabel!
    @IBOutlet var srainExpertyView3: UIView!
    @IBOutlet var strainExpertyWarnView3: UIView!
    @IBOutlet var strainExpertyWarnPopUp3: UIView!
    @IBOutlet var strainExpertyLabel3: UILabel!
    @IBOutlet var strainExpertyView4: UIView!
    @IBOutlet var strainExpertyWarnView4: UIView!
    @IBOutlet var strainExpertyWarnPopUp4: UIView!
    @IBOutlet var strainExpertyLabel4: UILabel!
    @IBOutlet var strainExpertyView5: UIView!
    @IBOutlet var strainExpertyWarnView5: UIView!
    @IBOutlet var strainExpertyWarnPopUp5: UIView!
    @IBOutlet var strainExpertyLabel5: UILabel!
    @IBOutlet var stackView1Height: NSLayoutConstraint!
    @IBOutlet var stackView2Height: NSLayoutConstraint!
}


class profileSettingUserInfoCell : UITableViewCell {
    @IBOutlet var btn_UploadImage : UIButton!
    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Gallery : UIButton!
    @IBOutlet var btn_Home : UIButton!
    @IBOutlet var btn_Followers : UIButton!
    @IBOutlet var btn_Following : UIButton!
    @IBOutlet var btn_EditCoverPhoto : UIButton!
    @IBOutlet var btn_BoomingBud : UIButton!
    @IBOutlet var btn_EditName : UIButton!
    @IBOutlet weak var img_user_point_rating: UIImageView!
    @IBOutlet weak var img_indicator_line: UIImageView!
    @IBOutlet var lblFollowers : UILabel!
    @IBOutlet var lblFollowing : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblPoints : UILabel!
    @IBOutlet var imgViewUser : UIImageView!
    @IBOutlet var imgViewUserTop : UIImageView!
    @IBOutlet var imgViewBG : UIImageView!
    @IBOutlet var imgViewReview : UIImageView!
    
    @IBOutlet var lblBloomingBud : UILabel!
}


