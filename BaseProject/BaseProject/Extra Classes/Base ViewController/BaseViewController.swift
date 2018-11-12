//
//  BaseViewController.swift
//  Wave
//
//  Created by Vengile on 07/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MessageUI
import AVKit
import IQKeyboardManager
import ADEmailAndPassword
import AudioToolbox
import GrowingTextView
import AVFoundation
import INSPhotoGallery
import GoogleMobileAds


class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate ,ChooseOpenOptions , MFMailComposeViewControllerDelegate{
	let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var afterCompletionBase = 0
    
//    var states = [ "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Hawaii", "Illinois", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Montana", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Dakota", "Ohio", "Oregon", "Pennsylvania", "Rhode Island", "Vermont", "Washington", "Washington, DC","West Virginia" ]
    var states = ["Idaho",
                  "Wyoming",
                  "Utah",
                  "South Dakota",
                  "Nebraska",
                  "Kansas",
                  "Oklahoma",
                  "Texas",
                  "Missouri",
                  "Iowa", "Wisconsin", "Indiana", "Kentucky", "Tennessee" , "Mississippi" , "Alabama", "Virginia", "Georgia", "North Carolina", "South Carolina"]
    var stateInitial = ["ID", "WY", "UT", "NE", "KS", "OK", "TX", "MO", "IA", "WI", "IN", "KY", "TN", "MS", "AL", "VA", "GA", "NC", "SC" , "SD"];
//    ["AK", "AZ",    "AR",    "CA",
//    "CO",    "CT",    "DE",    "FL",   "HI",    "IL",    "ME",    "MD",
//    "MA",    "MI",    "MN",    "MT",    "NV",    "NH",    "NJ",    "NM",
//    "NY",    "ND",    "OH",    "OR",    "PA",    "RI",    "VT",    "VA",    "WA",    "WV"]
    
    var isRefreshonWillAppear = true
    var player:AVAudioPlayer = AVAudioPlayer()
    @discardableResult func playSound(named soundName: String) -> AVAudioPlayer {
        let audioPath = Bundle.main.path(forResource: soundName, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        player.play()
        return player
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        for view in self.getSubviewsOfView(view: self.view){
            if view.isKind(of: UITextField.self){
                if let tf_tv = view as? UITextField{
                    tf_tv.autocorrectionType = .no
                }
            }
        }
	}
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func reload(tableView: UITableView) {
        let lastScrollOffset = tableView.contentOffset
        tableView.reloadData()
//        tableView.beginUpdates()
//        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
//        tableView.endUpdates()
        tableView.layer.removeAllAnimations()
        tableView.setContentOffset(lastScrollOffset, animated: false)
    }
    
    func reloadTableview(tbleViewMain : UITableView) {
        UIView.setAnimationsEnabled(false)
        tbleViewMain.beginUpdates()
        tbleViewMain.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        tbleViewMain.endUpdates()
    }
    
    func saveVideo(path : String)  {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path){
            self.confirmationCustomeAlert(title: "Are you sure?", discription: "You want to save this Video in your device gallery.", btnTitle1: "Cancel", btnTitle2: "Save") { (isConfirm, btn_nmbr) in
                if isConfirm {
                     UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                }else{
                    
                }
            }
        }else{
          self.ShowErrorAlert(message: "Invalid Vidoe Path!")
        }
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject)
    {
        if let _ = error {
            print("Error,Video failed to save")
        }else{
            print("Successfully,Video was saved")
        }
    }
    func saveImageInGallery(img : UIImage) {
        self.confirmationCustomeAlert(title: "Are you sure?", discription: "You want to save this Image in your device gallery.", btnTitle1: "Cancel", btnTitle2: "Save") { (isConfirm, btn_nmbr) in
            if isConfirm {
                UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                
            }
        }
       
    }
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print(error.debugDescription)
    }
    
    override func deleteCustomeAlert(title : String , discription : String , btnTitle1 : String = "Close!" , btnTitle2 : String = "Yes, delete it!" ,complition : @escaping(Bool,Int) -> Void) {
       SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.warning, buttonTitle:btnTitle1, buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle2, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(false,2)
            }  else {
                 complition(true,1)
            }
        }
    }
    
    func confirmationCustomeAlert(title : String , discription : String , btnTitle1 : String = "NO!" , btnTitle2 : String = "YES" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none, buttonTitle:btnTitle1, buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle2, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(false,2)
            }  else {
                complition(true,1)
            }
        }
    }
    
    override func oneBtnCustomeAlert(title : String , discription : String  , btnTitle : String = "OK" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none, buttonTitle:"", buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(true,1)
            }  else {
                complition(false,2)
            }
        }
    }
    
    override func simpleCustomeAlert(title : String , discription : String) {
        _ = SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none)
    }
    
    func addNewShoutOutAler(subusers : [SubUser] , id : Int , sub_userTitle : String , delegate : refreshDataDelgate , specials : [Specials]) {
        let storyboard = UIStoryboard(name: "ShoutOut", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "NewShoutOutAlert") as! NewShoutOutAlert
        customAlert.delegate = delegate
        customAlert.subuser_id = id
        customAlert.subuser_name = sub_userTitle
        customAlert.selected_specials = specials
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    func getSubviewsOfView(view: UIView) -> [UIView] {
        var subviewArray = [UIView]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview)
            subviewArray.append(subview)
        }
        return subviewArray
    }
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    
    func addBannerViewToView(_ view: UIView) {
        var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [
//            NSLayoutConstraint(item: bannerView,
//                                attribute: .bottom,
//                                relatedBy: .equal,
//                                toItem: bottomLayoutGuide,
//                                attribute: .top,
//                                multiplier: 1,
//                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    
    
    var photoINS = [INSPhotoViewable]()
    
    func ShowImageQA(attachments: [Attachment] , index : Int = 0 ) {
        photoINS.removeAll()
        for attach in attachments{
            if !attach.is_Video{
                let stringMain = attach.image_URL
                let urlImage = WebServiceName.images_baseurl.rawValue + stringMain //kImagePath + stringMain
                photoINS.append(INSPhoto(imageURL: NSURL(string: urlImage)! as URL, thumbnailImage: nil))
            }
        }
        var currentPhoto = photoINS[0]
        if index < photoINS.count {
            currentPhoto = photoINS[index]
        }else {
            currentPhoto = photoINS[1]
        }
        
        let galleryPreview = INSPhotosViewController(photos: photoINS, initialPhoto: currentPhoto)
        present(galleryPreview, animated: true, completion: nil)
    }
    
    func showImagess(attachments: [String]) {
        photoINS.removeAll()
        for attach in attachments{
                let urlImage = WebServiceName.images_baseurl.rawValue + attach
            photoINS.append(INSPhoto(imageURL:URL(string: attach), thumbnailImage: nil))
        }
        let currentPhoto = photoINS[0]
        let galleryPreview = INSPhotosViewController(photos: photoINS, initialPhoto: currentPhoto)
        present(galleryPreview, animated: true, completion: nil)
        
    }
    func showImageFromImage(attachments: UIImage) {
        photoINS.removeAll()
         photoINS.append(INSPhoto.init(image: attachments, thumbnailImage: nil))
        let currentPhoto = photoINS[0]
        let galleryPreview = INSPhotosViewController(photos: photoINS, initialPhoto: currentPhoto)
        present(galleryPreview, animated: true, completion: nil)
        
    }
    
    func SetRatingImage(image_view : UIImageView ,point : Int){
        image_view.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        if point < 100 {
            image_view.tintColor = ConstantsColor.kUnder100Color
        }else  if point > 99 && point < 200 {
            image_view.tintColor = ConstantsColor.kUnder200Color
        }else  if point > 199 && point < 300 {
            image_view.tintColor = ConstantsColor.kUnder300Color
        }else  if point > 299 && point < 400 {
            image_view.tintColor = ConstantsColor.kUnder400Color
        }else  if point > 399{
            image_view.tintColor = ConstantsColor.kUnder500Color
        }
    }
    
    func sendEmail(email : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true)
        } else {
            let url = URL(string: "mailto:\(email)")
            if self.verifyUrl(urlString: url?.absoluteString) {
                self.OpenUrl(webUrl: url!)
            }else{
                self.ShowErrorAlert(message: "No Email Account found!")
            }
        }
    }
    
    func openPost(index: String!){
        let feedDetail = self.GetView(nameViewController: "FeedDetail", nameStoryBoard: "Wall") as! FeedDetailViewController
        feedDetail.fromActivityLog = true
        feedDetail.fromActivityID = Int(index!)
        self.navigationController?.pushViewController(feedDetail, animated: true)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    func openStrainFlag() {
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "StrainReportAlertVC") as! StrainReportAlertVC
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    func  getColor (point : Int) -> UIColor {
        if point < 100 {
            return ConstantsColor.kUnder100Color
        }else  if point > 99 && point < 200 {
            return ConstantsColor.kUnder200Color
        }else  if point > 199 && point < 300 {
           return  ConstantsColor.kUnder300Color
        }else  if point > 299 && point < 400 {
            return  ConstantsColor.kUnder400Color
        }else  if point > 399{
           return ConstantsColor.kUnder500Color
        }else{
            return ConstantsColor.kUnder100Color
        }
    }
	//MARK: Navigation Actions
	//MARK:
	func AddBackButton() {
		let navigation = self.navigationController as! BaseNavigationController
		navigation.addBackButtonOn(self, selector: #selector(BaseViewController.Back))
	}
	
    func openDeleteAlert(text : String ,complition : @escaping() -> Void) {
        self.deleteCustomeAlert(title: "Are you sure?", discription: text) { (isConfirm, btn_nmbr) in
            if isConfirm{
                complition()
            }else{
                
            }
        }
    }
    func openSaveAlert(text : String ,complition : @escaping() -> Void) {
        self.deleteCustomeAlert(title: "Are you sure?", discription: text, btnTitle1: "No!", btnTitle2: "Yes!") { (isConfirm, btn_nmbr) in
            if isConfirm{
                complition()
            }else{
                
            }
        }
        
    }
    func openFlagAlert(id : String) {
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "ReportAlertVC") as! ReportAlertVC
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.review_id = id
        self.present(customAlert, animated: true, completion: nil)
    }
    func openFlagAlert(id : String , isBudz: Bool) {
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "ReportAlertVC") as! ReportAlertVC
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.isBudzFlag = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.review_id = id
        self.present(customAlert, animated: true, completion: nil)
    }
	func AddCrossButton(){
		let navigation = self.navigationController as! BaseNavigationController
		let image = UIImage.init(named: "Cross")
		navigation.addRLeftButton(self, selector: #selector(BaseViewController.Dismiss), image:image!.imageResize(sizeChange: CGSize.init(width: 53, height: 25)))

	}
	
	func Back(){
        if appdelegate.isBaseNavigation{
            appdelegate.isBaseNavigation = false
            self.GotoHome()
        }
		_ = self.navigationController?.popViewController(animated: true)
    }
	
	func Dismiss(){
		self.dismiss(animated: true) {
		}
	}
    
    
    func GotoQuestionMain(){
        let QAView = self.GetView(nameViewController: "QAMainVC", nameStoryBoard: StoryBoardConstant.Main) as! QAMainVC
        
        self.navigationController?.pushViewController(QAView, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        textField.endEditing(true)
        return true
    }
	
    func addRightButtonWithtext(selector: Selector , lblText : String , widthValue : Double = 100){
		
		let navigation = self.navigationController as! BaseNavigationController
        navigation.addRightButtonWithTitle(self, selector: selector, lblText: lblText , widthValue : widthValue)
	}
    
    
    func addRightButtonWithImage(selector: Selector , imageMain : UIImage){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.addRightButton(self, selector: selector, image: imageMain)
    }
    
    
    func RemoveRigtButton(){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveRightButton(self)
    }
    
    
    
	func UpdateTitle(title : String) {
		
		self.UpdateNavigationColor()
	}
	
	func UpdateNavigationColor() {
		let navigation = self.navigationController as! BaseNavigationController
		navigation.AddBackGroundImage()
	}
	
	func AddMenuButton() {
		let navigation = self.navigationController as! BaseNavigationController
		navigation.addMenuButtonOn(self, selector: #selector(self.openMenu))
	}
	
	
    func openBudzMap(id : String, new: Bool = false, fiveBack: Bool = false) {
        let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
        viewpush.budz_map_id = id
        viewpush.fromNew = new
        viewpush.fiveBack = fiveBack
        self.navigationController?.pushViewController(viewpush, animated: true)
    }
    func OpenProfileVC(id : String, feedDataController: FeedDataController? = nil) {
        let profile_vc = self.GetView(nameViewController: "UserProfileViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserProfileViewController
        profile_vc.user_id = id
        if afterCompletionBase == 1{
            profile_vc.afterCompletion = 1
        }
        if let fdc = feedDataController {
            profile_vc.feedDataController = fdc
        }
        self.navigationController?.pushViewController(profile_vc, animated: true)
    }
	func openMenu(){
        
		if(self.menuContainerViewController.menuState == MFSideMenuStateLeftMenuOpen)
		{
			self.menuContainerViewController.setMenuState(MFSideMenuStateClosed) { () -> Void in
			}
		}else{
			self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen) { () -> Void in
				
			}
		}
	}

    func disableMenu() {
        if !appdelegate.isBaseNavigation{
            appdelegate.isSideMenudisabled = true
            self.menuContainerViewController.leftMenuViewController = nil
        } 
    }
    
    func enableMenu() {
        if !appdelegate.isBaseNavigation && appdelegate.isSideMenudisabled{
          let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
          let menuSide = mainStoryBoard.instantiateViewController(withIdentifier: "MainMenu")
          self.menuContainerViewController.leftMenuViewController = menuSide
           appdelegate.isSideMenudisabled = false
        }
    }
    
    //Rewards Alert
    func  OpenClaimRewardAlert(reward_data : [String : Any]) {
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "ClaimRewardsVC") as! ClaimRewardsVC
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.data = reward_data
        self.present(customAlert, animated: true, completion: nil)
    }
    
    //Rewards Alert
    func  OpenRedeemCompleteAlert(reward_data : [String : Any]) {
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "RedeemCompleteAlertVC") as! RedeemCompleteAlertVC
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.data = reward_data
        self.present(customAlert, animated: true, completion: nil)
    }
   	
	//MARK: Alert Messge
	//MARK:
//    func ShowErrorAlert(message : String , AlertTitle : String = kErrorTitle) {
//        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
//            alert.dismiss(animated: true, completion: nil)
//        })
//        self.present(alert, animated: true, completion: nil)
//    }
//
	func ShowSuccessAlert(message : String ) {
        self.oneBtnCustomeAlert(title: "", discription: message) { (isComp, btn) in
          _ = self.navigationController?.popViewController(animated: true)
        }
	
	}
    func ShowSuccessAlert(message : String , completion: @escaping () -> () ) {
        self.oneBtnCustomeAlert(title: "", discription: message) { (isComp, btn) in
            completion()
        }
        
    }
    
    func ShowSuccessAlertWithNoAction(message : String ) {
        self.oneBtnCustomeAlert(title: "", discription: message) { (isComp, btn) in
           
        }
     
    }
	
	
	func ShowSuccessAlertWithrootView(message : String ) {
        self.oneBtnCustomeAlert(title: "", discription: message) { (isComp, btn) in
           _ = self.navigationController?.popToRootViewController(animated: true)
        }
	
	}
    
    

    
	
	func ShowSuccessAlertWithViewRemove(message : String ) {
        self.oneBtnCustomeAlert(title: "", discription: message) { (isComp, btn) in
        }
	
	}
	
	func GetViewcontrollerWithName(nameViewController : String) -> UIViewController {
		let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as UIViewController
		return viewObj
	}
	
	
	
	func GetNavigationcontrollerWithName(nameViewController : String) -> BaseNavigationController {
		let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as! BaseNavigationController
		return viewObj
	}
	
	func PushViewWithIdentifier(name : String ) {
		//print(name)
		let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
		self.navigationController?.pushViewController(viewPush!, animated: true)
	}
	
   	func ShowViewWithIdentifier(name : String ) {
		let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
		self.present(viewPush!, animated: true) {
			
		}
	}
    
    
    func ShowTutorialPages(){
        let helppages = self.storyboard?.instantiateViewController(withIdentifier: "HelpPagesVC")
        self.present(helppages!, animated: false) {
            
        }
    }
    
    

	
	// MARK:
	// MARK: Email Validation
	func EmailValidation(textField  : UITextField) -> Bool  {

        
      return  self.EmailValidationOnstring(strEmail: textField.text!)
	}
    
    
    func EmailValidationOnstring(strEmail  : String) -> Bool  {
        
        if strEmail.characters.count == 0 {
            self.ShowErrorAlert(message: Alert.kEmptyCredentails)
            return false
        }else {
            if ADEmailAndPassword.validateEmail(emailId: strEmail) {
                return true
            }else {
                self.ShowErrorAlert(message: Alert.kWrongEmail)
                return false
            }
        }
    }
    func offlineUser() {
        NetworkManager.PostCall(UrlAPI: "offline_user", params: [:]) { (isSuccess, responseString, data) in
            print(data)
        }
    }
    
    //MARK: get keywords
    func GetKeywords(completion: @escaping () -> Void){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.getKeywords.rawValue) { (successResponse, successMessage, successData) in
            print("successResponse\(successResponse)")
            print("successMessage\(successMessage)")
            print("successData\(successData)")
            self.view.hideLoading()
            if successResponse {
                if (successData["status"] as! String) == "success" {
                    let mainResponse = successData["successData"] as! [[String : Any]]
                    print(mainResponse)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.keywords.removeAll()
                    appDelegate.orignalkeywords.removeAll()
                    for mainIndex in mainResponse {
                        if let obj = mainIndex["title"] as? String{
                            appDelegate.keywords.append(obj)
                            appDelegate.orignalkeywords.append(obj)
                            appDelegate.keywords.append("#"+obj)
                            appDelegate.keywords.append("("+obj+")")
                            appDelegate.keywords.append("."+obj)
                            appDelegate.keywords.append(","+obj)
                            appDelegate.keywords.append(obj+",")
                        } 
                    }
                    HBUserDafalts.sharedInstance.saveKeywords(array: appDelegate.keywords)
                    print(appDelegate.keywords)
                }
            }
            completion()
        }  
    }
	
	// MARK:
	// MARK:Add Menu
	func ShowMenuBaseView(){
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMainView"), object: nil)
	}
    func RefreshData(completion: @escaping () -> Void ) {
        var param = [String : AnyObject]()
        param["device_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.deviceID as AnyObject
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.ID as AnyObject
        print(param)
        NetworkManager.PostCall(UrlAPI: WebServiceName.refresh_user_data.rawValue, params: param) { (successMain, successMessage, successResponse) in
            print(successResponse)
            if successMain{
                if (successResponse["status"] as! String) == "success" {
                    print(successResponse["successData"] as! [String : Any])
                    if let mainUser = ((successResponse["successData"] as! [String : Any])["user"] as? [String : AnyObject]),
                        let mainSession = ((successResponse["successData"] as! [String : Any])["session"] as? [String : AnyObject]) {
                    print(mainSession)
                    let userMain = User.init(json: mainUser)
                    userMain.sessionID = mainSession["session_key"] as! String
                        userMain.userlng = String(mainUser["lng"] as? Double ?? 0.0)
                        userMain.userlat = String(mainUser["lat"] as? Double ?? 0.0)
                    userMain.deviceType = mainSession["device_type"] as! String
                    userMain.deviceID = mainSession["device_id"] as? String ?? kEmptyString
                    userMain.isFBID = String(mainSession["fb_id"] as? Double ?? 0.0)
                    userMain.isGoogleID = String(mainSession["g_id"] as? Double ?? 0.0)
                    print(userMain.userlat)
                    print(userMain.userlng)
                    userMain.shout_outs_count = (successResponse["successData"] as! [String : Any])["shout_outs_count"] as? NSNumber ?? 0
                    userMain.notifications_count = (successResponse["successData"] as! [String : Any])["notifications_count"] as? NSNumber ?? 0
                      userMain.subUserCount = (successResponse["successData"] as! [String : Any])["sub_user"] as? NSNumber ?? 0
                    DataManager.sharedInstance.user = userMain
                    DataManager.sharedInstance.saveUserPermanentally()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateUI"), object: nil)
                    }
                    completion()
                }
            }
        }
    }
	
	//MARK:- Custom methods
	
    override func hideLoading() {
		self.view.hideLoading()
	}
    func TableViewNoDataAvailabl(tableview : UITableView) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
        noDataLabel.text          = "No data available"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableview.backgroundView  = noDataLabel
        tableview.separatorStyle  = .none
    }
    
    func TableViewNoDataAvailabl(tableview : UITableView , text : String) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
        noDataLabel.text          = text
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        tableview.backgroundView  = noDataLabel
        tableview.separatorStyle  = .none
    }
    func Vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    func CollectionviewNoDataAvailabl(collection_view : UICollectionView) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collection_view.bounds.size.width, height: collection_view.bounds.size.height))
        noDataLabel.text          = "No data available"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        collection_view.backgroundView  = noDataLabel
    }
    
    func CollectionviewNoDataAvailabl(collection_view : UICollectionView , text : String) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collection_view.bounds.size.width, height: collection_view.bounds.size.height))
        noDataLabel.text          = text
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        collection_view.backgroundView  = noDataLabel
    }
    
    func TableViewRemoveNoDataLable(tableview : UITableView ) {
        tableview.backgroundView  = nil
    }
    
    func CollectionViewRemoveNoDataLable(collection_view : UICollectionView ) {
        collection_view.backgroundView  = nil
    }
    
    //MARK: Delay
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    

	
	//MARK: Show Media Options
	//MARK:
	func showMediaChoosingOptions() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = false
       
		let photoOptionMenu = UIAlertController(title: "Choose source", message: kEmptyString, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "View Phone Gallery", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			imagePicker.sourceType = .photoLibrary
			//            imagePicker.mediaTypes =  kUTTypeImage as! [String]
			
			self.present(imagePicker, animated: true, completion: nil)
		})
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
				imagePicker.sourceType = .camera
				
				self.present(imagePicker, animated: true, completion: nil)
			}
			else {
				self.ShowErrorAlert(message:"Your camera is not accessible. Please check your device settings and then try again.")
			}
		})
        
       		let cancelAction = UIAlertAction(title: kCancelBtnTitle, style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
		})
		
		photoOptionMenu.addAction(cameraAction)
        photoOptionMenu.addAction(libraryAction)
        
		photoOptionMenu.addAction(cancelAction)
		self.present(photoOptionMenu, animated: true, completion: nil)
	}
	
	func GetEmptyView(viewP : UIView)-> UILabel{
		let messageLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: viewP.bounds.size.width, height: viewP.bounds.size.height))
		messageLabel.text = "No Record Found"
		messageLabel.textColor = UIColor.black
		messageLabel.numberOfLines = 0;
		messageLabel.textAlignment = .center;
		messageLabel.font = UIFont(name: "TrebuchetMS", size: 17)
		messageLabel.sizeToFit()
		
		return messageLabel
	}
	
	func BorderView(viewMain : UIView , borderColor : UIColor){
		viewMain.layer.borderWidth = 1;
		viewMain.layer.cornerRadius = 10
		viewMain.layer.borderColor = borderColor.cgColor
		viewMain.clipsToBounds = true
		viewMain.layer.masksToBounds = true

	}

}




// MARK:
// MARK: Project Bottom Cell
extension BaseViewController {
	
	
    func GetTodaydate() -> String{
        let datetoday = Date()
        return datetoday.GetString(dateFormate: "YYYY-MM-dd")
    }

    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    func reloadMainTable(tableView: UITableView) {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }

    
    func ShakeView(viewMain : UIView){
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( caTransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( caTransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        viewMain.layer.add( anim, forKey:nil )
    }
    
    func DialNumber(PhoneNumber : String){
           var phone = PhoneNumber.replacingOccurrences(of: "(", with: "")
           phone = phone.replacingOccurrences(of: ")", with: "")
           phone = phone.replacingOccurrences(of: " ", with: "")
          phone = phone.replacingOccurrences(of: "-", with: "")
        if let url = URL(string: "tel://001\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else{
            self.ShowErrorAlert(message: "Invalid Phone Number!")
        }
    }
    func OpenLink(webUrl:String){
        var url = webUrl
         if url.contains("https") == false && url.contains("http") == false{
            if url.contains("www"){
                url = "https://" + url
            }else{
                url = "https://www." + url
            }
        }
        if self.verifyUrl(urlString: url) {
            let url = URL(string: url)
            if (url?.absoluteString.contains("youtube.com"))! || (url?.absoluteString.contains("youtu.be"))! {
               self.navigationController?.present(YoutubePlayerVC.PlayerVC(url: url!), animated: true, completion: nil)
            }else if (url?.absoluteString.contains(Constants.ShareLinkConstant))! {
                appdelegate.executeDeepLink(with: url!)
            }
            else{
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }else{
            self.ShowErrorAlert(message: "Invalid URL!", AlertTitle: "Error!")
        }
        
    }
    func OpenUrl(webUrl:URL){
        
        if self.verifyUrl(urlString: webUrl.absoluteString) {
            if (webUrl.absoluteString.contains("youtube.com")) || (webUrl.absoluteString.contains("youtu.be")) {
                self.navigationController?.present(YoutubePlayerVC.PlayerVC(url: webUrl), animated: true, completion: nil)
            }else if (webUrl.absoluteString.contains(Constants.ShareLinkConstant)) {
                appdelegate.executeDeepLink(with: webUrl)
            }
            else{
                 UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            }
          
        }else{
            var url = webUrl.absoluteString
            if url.contains("https") == false && url.contains("http") == false{
                
                if url.contains("www"){
                    url = "https://" + url
                }else{
                    url = "https://www." + url
                }
            }
            if self.verifyUrl(urlString: url) {
                let url = URL(string: url)
                if (url?.absoluteString.contains("youtube.com"))! || (url?.absoluteString.contains("youtu.be"))! {
                    self.navigationController?.present(YoutubePlayerVC.PlayerVC(url: url!), animated: true, completion: nil)
                }else if (url?.absoluteString.contains(Constants.ShareLinkConstant))! {
                    appdelegate.executeDeepLink(with: url!)
                }
                else{
                   UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
               
            }else{
                self.ShowErrorAlert(message: "Invalid URL!", AlertTitle: "Error!")
            }
        }
    }
    func GotoHome(){
        self.GetKeywords(completion: {
//            print(appDelegate.keywords)
        })
        self.ShowMenuBaseView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)

    }
    
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
        
    }
    
    
    func PushViewWithStoryBoard(nameViewController : String , nameStoryBoard : String) {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController  
        self.navigationController?.pushViewController(viewObj, animated: true)
    }
    
    func UTCToLocal(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let dt = dateFormatter.date(from: date)
        return dt!
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
//        return dateFormatter.string(from: dt!)
    }
    
    func getDateWithTh(date : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dt = dateFormatter.date(from: date)
        if dt != nil{
            var str = "th"
            let dayOfMonth = Calendar.current.component(.day, from: dt!)
            switch dayOfMonth {
            case 1, 21, 31:
                 str = "st"
            case 2, 22:
                str =  "nd"
            case 3, 23:
                str =  "rd"
            default:
                str =  "th"
            }
            
            let formatter = DateFormatter();
            formatter.dateFormat = "MMM"
            let mnth_name =  formatter.string(from: dt!)
            
            let formatter_year = DateFormatter();
            formatter_year.dateFormat = "yyyy"
            let year_name =  formatter_year.string(from: dt!)
            
            return mnth_name+" \(dayOfMonth)\(str), \(year_name)"
        }
           return  "June 21st, 2018"
    }
    func  GetDate(date : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let dt = dateFormatter.date(from: date)
        let date_frmt = DateFormatter()
         date_frmt.dateFormat = "MM-dd-yyyy"
        return date_frmt.string(from: dt!)
    }
    func  GetDateBudz(date : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: date)
        let date_frmt = DateFormatter()
        date_frmt.dateFormat = "MM/dd/yyyy"
        return date_frmt.string(from: dt!)
    }
    func GetTimeAgoWall(StringDate : String) -> String{
        let dateRangeStart = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dt = dateFormatter.date(from: StringDate)
        dt = dt?.toLocalTime()
        let date_frmt = DateFormatter()
        date_frmt.dateFormat = "MMM dd"
        print(date_frmt.string(from: dt!))
        let date_frmt2 = DateFormatter()
        date_frmt2.dateFormat = "hh:mm a"
        let date_string  = date_frmt2.string(from: dt!)
        print(date_string)
        
        let dateRangeEnd = self.UTCToLocal(date: StringDate)
        print(dateRangeEnd)
        let components = Calendar.current.dateComponents([.month , .day ,.hour ,.minute], from: dateRangeEnd, to: dateRangeStart)
        print(components)
        var stringReturn = ""
        if components.hour! < 12 && components.day! == 0{
            stringReturn = "Today at " + date_string
        }else if (components.hour! > 12 && components.day! == 0) || (components.day! == 1 && components.hour! < 6 ){
            //(components.hour! > 12 && components.day! == 0) ||
            stringReturn = "Yesterday at " + date_string
        }else{
            stringReturn = date_frmt.string(from: dt!) + " at " + date_string
        }
        return stringReturn
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if !( (view.isKind(of: UITextField.self) || view.isKind(of: UITextView.self))  ){
                    view.resignFirstResponder()
                    view.endEditing(true)
            }
        }
    }
    func GetTimeAgo(StringDate : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date  = dateFormatter.date(from: StringDate)
        date = date?.toLocalTime()
        return date!.timeAgo
        
        /*let dateRangeStart = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateFormatter.timeZone = NSTimeZone.default
        let dateRangeEnd = dateFormatter.date(from: StringDate.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "yyyy-MM-dd HH:mm:ss"))
        print(dateRangeEnd ?? "test")
        print(dateRangeEnd!.timeAgo)
        return dateRangeEnd!.timeAgo
        let components = Calendar.current.dateComponents([.month , .day ,.hour ,.minute ,.second], from: dateRangeEnd!, to: dateRangeStart)
        print(components)
        var stringReturn = ""
        if components.month! > 0 {
           stringReturn = String(components.month!) + " month ago"
        }else if components.day! > 0 {
            if components.day! >= 7 && components.day! < 11 {
                stringReturn = "1 week ago"
            }else if components.day! >= 11 && components.day! < 17 {
                stringReturn = "2 weeks ago"
            }else if components.day! >= 17 && components.day! < 28 {
                stringReturn = "3 weeks ago"
            }else if components.day! >= 28 && components.day! < 31 {
                stringReturn = "4 weeks ago"
            }else {
                if(components.day! == 1){
                    stringReturn = String(components.day!) + " day ago"
                }else {
                     stringReturn = String(components.day!) + " days ago"
                    
                }
                
            }
        }else if components.hour! > 0 {
            if components.minute! >= 30 {
                let vale = components.hour! + 1
                stringReturn = String(vale) + " hours ago"
            }else {
                stringReturn = String(components.hour!) + " hours ago"
            }
            
        }else if components.minute! > 0 {
            if components.second! >= 30 {
                let vale = components.minute! + 1
                stringReturn = String(vale) + " minutes ago"
            }else {
                stringReturn = String(components.minute!) + " minutes ago"
            }
//            stringReturn = String(components.minute!) + " minutes ago"
        }
        else if components.second! > 0 {
            stringReturn = String(components.second!) + " seconds ago"
        }
        return stringReturn */

    }

    func GetTimeForMatter()-> DateFormatter{
        let timeFormate = DateFormatter()
        timeFormate.dateFormat = "h:mm a"
        return timeFormate
    }
    
    func GetDateForMatter()-> DateFormatter{
        let timeFormate = DateFormatter()
        timeFormate.dateFormat = "MM/dd/yyyy"
        return timeFormate
    }
    
    func OpenShare(){
        
        let text = "Healing Bud"
        let link = URL.init(string:Constants.ShareLinkConstant)
        let shareAll = [ text , link! ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.confirmationCustomeAlert(title: "Share In The Buzz", discription: text, btnTitle1: "Social Share", btnTitle2: "Share In App") { (isInAp, bac) in
            if(isInAp){
                var prms = [String: Any]()
                prms["url"] = link as AnyObject
                prms["content"] = text as AnyObject
                self.showLoading()
                NetworkManager.PostCall(UrlAPI: "share_post_in_app", params: prms as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
                    print(dataResponse)
                    self.hideLoading()
                    self.ShowSuccessAlertWithNoAction(message: "Shared Successfully")
                }
            }else {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func OpenShare(params: [String: Any], link: String){
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_share.rawValue, params: params as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
        }
        var activityItems: [AnyObject]?
        let text = "Check out Healing Budz for your smartphone: \n"
        let url = URL.init(string: link)
          activityItems = [text as AnyObject , url! as AnyObject]
        let activityController = UIActivityViewController(activityItems:
            activityItems!, applicationActivities: nil)
        self.present(activityController, animated: true,
                     completion: nil)
    }
    func OpenShare(params: [String: Any], link: String,content: String){
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_share.rawValue, params: params as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
        }
        var activityItems: [AnyObject]?
        let text = "Check out Healing Budz for your smartphone: \n"
        let url = URL.init(string: link)
        activityItems = [text as AnyObject , url! as AnyObject]
        let activityController = UIActivityViewController(activityItems:
            activityItems!, applicationActivities: nil)
        if (params["budzNotSahre"] as? String) == nil{
            self.confirmationCustomeAlert(title: "Share In The Buzz", discription: content,btnTitle1: "Social Share", btnTitle2: "Share In App") { (isInAp, bac) in
                if(isInAp){
                    var prms = [String: Any]()
                    prms["url"] = link as AnyObject
                    prms["content"] = content as AnyObject
                    self.showLoading()
                    NetworkManager.PostCall(UrlAPI: "share_post_in_app", params: prms as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
                        print(dataResponse)
                        self.hideLoading()
                        self.ShowSuccessAlertWithNoAction(message: "Shared Successfully")
                    }
                }else {
                    self.present(activityController, animated: true,
                                 completion: nil)
                }
            }
        }else{
            self.present(activityController, animated: true,
                         completion: nil)
        }
        
       
    }
    
    
    //MARK: ATTRIBUTED TEXT
    func  SetAttributedText(mainString : String , attributedStringsArray : [String] , view : Any , color : UIColor) {
        let attribute = NSMutableAttributedString(string: mainString)
        attribute.addAttribute( NSForegroundColorAttributeName,value: UIColor.white,
            range: NSMakeRange(0, attribute.length)
        )
        let attribute_font = [NSFontAttributeName: UIFont(name: "Lato-Regular", size: 16.0)! ]
        attribute.addAttributes(attribute_font, range:  NSMakeRange(0, attribute.length))
        var orignal_str = mainString
        for str in attributedStringsArray {
            let range = (orignal_str as NSString).range(of: str)
            print(range.location)
            attribute.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            orignal_str = self.replace(myString: orignal_str, range.location, "!")
        }
        if let LBL = view as? UILabel {
            LBL.attributedText = attribute
            LBL.textColor = UIColor.white
        }else if  let TXT_view = view as? UITextView {
            TXT_view.textColor = UIColor.white
            TXT_view.attributedText = attribute
        }else if let TF = view as? UITextField {
            TF.attributedText = attribute
        }else if let TF = view as? GrowingTextView {
              TF.textColor = UIColor.white
              TF.attributedText = attribute
            
        }
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)
        if chars.count > index{
           chars[index] = newChar
        }
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func ShowKeywordPopUp(value : String){
        let storyboard = UIStoryboard(name: "Rewards", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "ShowKeywordPopUpVC") as! ShowKeywordPopUpVC
        customAlert.delegate = self
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.newValue = value
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func ChooseOpenOptions(index : Int , value : String){
        print("ChooseOpenOptions")
        print(index)
        print(value)
        
        if index == 0 || index == 1 {
                let mainQA = self.GetView(nameViewController: "QAMainVC", nameStoryBoard: StoryBoardConstant.Main) as! QAMainVC
            
            if(index == 1){
                mainQA.tagSearch = value + "&type=answer"
               mainQA.isFromAnswerTap = true
            }else {
                mainQA.tagSearch = value + "&type=question"
            }
            self.navigationController?.pushViewController(mainQA, animated: true)
        }else if index == 2 {
            let mainStrain = self.GetView(nameViewController: "StrainsListingViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainsListingViewController
            mainStrain.tagSearch = value
            self.navigationController?.pushViewController(mainStrain, animated: true)
        }else if index == 3 {
            let mainBudz = self.GetView(nameViewController: "EditProfileViewController", nameStoryBoard: StoryBoardConstant.Main) as! BudzMainVC
            mainBudz.tagSearch = value
            self.navigationController?.pushViewController(mainBudz, animated: true)
        }
        
        
        
    }
}

extension UITableViewCell{
    //MARK: ATTRIBUTED TEXT
    func  SetAttributedText(mainString : String , attributedStringsArray : [String] , view : Any , color : UIColor) {
//        var orignal_str = mainString
//        let attribute = NSMutableAttributedString.init(string: mainString)
//        for str in attributedStringsArray {
//            let range = (orignal_str as NSString).range(of: str)
//            print(range.location)
//            attribute.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
//            orignal_str = self.replace(myString: orignal_str, range.location, "!")
//        }
//        if let LBL = view as? UILabel {
//            LBL.attributedText = attribute
//            LBL.textColor = UIColor.white
//        }else if  let TXT_view = view as? UITextView {
//            TXT_view.attributedText = attribute
//            TXT_view.textColor = UIColor.white
//        }else if let TF = view as? UITextField {
//            TF.attributedText = attribute
//            TF.textColor = UIColor.white
//        }
        let attribute = NSMutableAttributedString(string: mainString)
        attribute.addAttribute( NSForegroundColorAttributeName,value: UIColor.white,
                                range: NSMakeRange(0, attribute.length)
        )
        let attribute_font = [NSFontAttributeName: UIFont(name: "Lato-Regular", size: 16.0)! ]
        attribute.addAttributes(attribute_font, range:  NSMakeRange(0, attribute.length))
        var orignal_str = mainString
        for str in attributedStringsArray {
            let range = (orignal_str as NSString).range(of: str)
            print(range.location)
            attribute.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            orignal_str = self.replace(myString: orignal_str, range.location, "!")
        }
        if let LBL = view as? UILabel {
            LBL.attributedText = attribute
            LBL.textColor = UIColor.white
        }else if  let TXT_view = view as? UITextView {
            TXT_view.textColor = UIColor.white
            TXT_view.attributedText = attribute
        }else if let TF = view as? UITextField {
            TF.attributedText = attribute
        }else if let TF = view as? GrowingTextView {
            TF.textColor = UIColor.white
            TF.attributedText = attribute
            
        }
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)
        if chars.count > index{
            chars[index] = newChar
        }
        let modifiedString = String(chars)
        return modifiedString
    }
}
//extension UIColor {
//    
//    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
//        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
//    }
//    
//    convenience init(hexColor: String) {
//        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
//        
//        let hex = hexColor as NSString
//        Scanner(string: hex.substring(with: NSRange(location: 0, length: 2))).scanHexInt32(&red)
//        Scanner(string: hex.substring(with: NSRange(location: 2, length: 2))).scanHexInt32(&green)
//        Scanner(string: hex.substring(with: NSRange(location: 4, length: 2))).scanHexInt32(&blue)
//        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
//    }
//    
//}
extension UIView {
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
            self.isHidden = true
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}



private struct Helper {
    
    static let bundle: Bundle? = {
        let resourcePath: String?
        if let frameworkBundle = Bundle(identifier: "com.kevinlawler.NSDateTimeAgo") {
            // Load from Framework
            resourcePath = frameworkBundle.resourcePath
        } else {
            // Load from Main Bundle
            resourcePath = Bundle.main.resourcePath
        }
        guard let pathString = resourcePath else {
            return nil
        }
        let path = URL(fileURLWithPath: pathString).appendingPathComponent("NSDateTimeAgo.bundle")
        return Bundle(url: path)
    }()
    
    static func localizedStrings(for key: String) -> String {
        guard let bundle = bundle else {
            return key
        }
        return NSLocalizedString(key, tableName: "NSDateTimeAgo", bundle: bundle, comment: "")
    }
    
    static func string(from format: String, with value: Int) -> String {
        let localeFormat = String(format: format, localeFormatUnderscores(with: Double(value)))
        return String(format: localizedStrings(for: localeFormat), value)
    }
    
    static func localeFormatUnderscores(with value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode.hasPrefix("ru") || localeCode.hasPrefix("uk") {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
}

extension Date {
    
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        let components = self.dateComponents()
        if let year = components.year, year > 0 {
            return Helper.string(from: "%%d%@yr", with: year)
        }
        
        if let month = components.month, month > 0 {
            return Helper.string(from: "%%d%@mo", with: month)
        }
        // TODO: localize for other calanders
        if let day = components.day  {
            if day >= 7 {
                let value = day / 7
                return Helper.string(from: "%%d%@w", with: value)
            } else if day > 0 {
                return Helper.string(from: "%%d%@d", with: day)
            }
        }
        
        if let hour = components.hour, hour > 0 {
            return Helper.string(from: "%%d%@h", with: hour)
        }
        
        if let minute = components.minute, minute > 0 {
            return Helper.string(from: "%%d%@m", with: minute)
        }
        
        if let second = components.second, second > 0 {
            return Helper.string(from: "%%d%@s", with: second)
        }
        
        return ""
    }
    
    public var timeAgo: String {
        let components = self.dateComponents()
        if let year = components.year, year > 0 {
            if year < 2 {
                return Helper.localizedStrings(for: "Last year")
            } else {
                return Helper.string(from: "%%d %@years ago", with: year)
            }
        }
        if let month = components.month, month > 0 {
            if month < 2 {
                return Helper.localizedStrings(for: "Last month")
            } else {
                return Helper.string(from: "%%d %@months ago", with: month)
            }
        }
        if let day = components.day {
            if day >= 7 {
                let week = day / 7
                if week < 2 {
                    return Helper.localizedStrings(for: "1 week ago")
                } else {
                    return Helper.string(from: "%%d %@weeks ago", with: week)
                }
            } else if day > 0  {
                if let hour = components.hour , hour > 0 {
                    if hour > 15 {
                        if day + 1 == 7{
                             return Helper.localizedStrings(for: "1 week ago")
                        }
                        return Helper.string(from: "%%d %@days ago", with: day + 1)
                    }
                }
                 return Helper.string(from: "%%d %@days ago", with: day)
            }
        }
        if let hour = components.hour , hour > 0 {
            if let minute = components.minute, minute > 0 {
                if minute > 33 {
                    if hour + 1 == 24 {
                        return Helper.string(from: "%%d %@days ago", with: 1)
                    }else{
                        return Helper.string(from: "%%d %@hours ago", with: hour + 1)
                    }
                }
            }
            if hour < 2 {
                return Helper.localizedStrings(for: "An hour ago")
            } else  {
                return Helper.string(from: "%%d %@hours ago", with: hour)
            }
        }
        
        if let minute = components.minute, minute > 0 {
            if minute < 2 {
                return Helper.localizedStrings(for: "A minute ago")
            } else {
                return Helper.string(from: "%%d %@minutes ago", with: minute)
            }
        }
        
        if let second = components.second, second > 0 {
            return Helper.localizedStrings(for: "Just now")
        }
        return ""
    }
    
    fileprivate func dateComponents() -> DateComponents {
        let UTCDate = Date()
        return   Calendar.current.dateComponents([.second, .minute, .hour , .day, .month, .year], from: self, to: UTCDate)
    }

    func converMinuteToTimeAgo(minut : Int) -> String {
        if minut < 60 {
             return Helper.string(from: "%%d %@minutes ago", with: minut)
        }else if minut > 59 && minut < 1140 {
            let hours  = minut / 60
            if hours < 2 {
                return Helper.localizedStrings(for: "An hour ago")
            } else  {
                return Helper.string(from: "%%d %@hours ago", with: hours)
            }
        }else if minut > 1139 && minut < 10080 {
            let days  = ( minut / 60 ) / 24
            return Helper.string(from: "%%d %@days ago", with: days)
        }else if minut > 10079 && minut < 40320 {
            let weeks  = (( minut / 60 ) / 24) /  7
           return Helper.string(from: "%%d %@weeks ago", with: weeks)
        }else {
            return "Long Time Ago"
        }
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}



extension UIViewController{
    
    func deleteCustomeAlert(title : String , discription : String , btnTitle1 : String = "Close!" , btnTitle2 : String = "Yes, delete it!" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.warning, buttonTitle:btnTitle1, buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle2, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(false,2)
            }  else {
                complition(true,1)
            }
        }
    }
    
    func oneBtnCustomeAlert(title : String , discription : String  , btnTitle : String = "OK" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.warning, buttonTitle:"", buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(true,1)
            }  else {
                complition(false,2)
            }
        }
    }
    
    func simpleCustomeAlert(title : String , discription : String) {
        _ = SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none)
    }
}


extension UIView{
    
    func deleteCustomeAlert(title : String , discription : String , btnTitle1 : String = "Close!" , btnTitle2 : String = "Yes, delete it!" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.warning, buttonTitle:btnTitle1, buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle2, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(false,2)
            }  else {
                complition(true,1)
            }
        }
    }
    
    func oneBtnCustomeAlert(title : String , discription : String  , btnTitle : String = "OK" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.warning, buttonTitle:"", buttonColor:UIColor.colorFromRGB(0xFFFFFF) , otherButtonTitle:  btnTitle, otherButtonColor: UIColor.colorFromRGB(0x000000)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(true,1)
            }  else {
                complition(false,2)
            }
        }
    }
    
    func simpleCustomeAlert(title : String , discription : String) {
        _ = SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none)
    }
}
