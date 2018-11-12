//
//  StrainDetailViewController.swift
//  BaseProject
//
//  Created by macbook on 24/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import  KUIPopOver
import ObjectMapper
import ActiveLabel
import CoreLocation
//import AACarousel
import FLAnimatedImage
//import Kingfisher
import AVKit

enum StrainReport : String {
    case None = ""
    case Answer = "Report"
    case Spam = "Spam"
    case Unrelated = "Unrelated"
    case Nudity = "Nudity or sexual content"
    case harassment = "Harassment or hate spech"
    case violent = "Threatening, violent or concerning"
}

class MyTableView: UITableView {
    override func reloadData() {
        let offset = contentOffset
        super.reloadData()
        contentOffset = offset
    }
}

class StrainDetailViewController: BaseViewController ,UIPopoverPresentationControllerDelegate , CameraDelegate , UITextViewDelegate  {
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var view_green: UIView!
    var ScrollToPOs = IndexPath()
    var ScrollToEdits = IndexPath()
    var textToSet = ""
    var txtCommentText = ""
    var isAddStrainGalleryImg = false
    @IBOutlet weak var image_indicator: UIImageView!
    @IBOutlet var tbleView_Strain : MyTableView!
     @IBOutlet var tbleViewFilter: UITableView!
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet var view_Save : UIView!
    var firstStrainName = ""
    var secondStrainName = ""
    var deleteImageReview = 0
    var isHideTAbs = false
    var cellMain : StrainDetailHeadingCell!
//    var timer: Timer?
    
    var IDMain  = ""
    var IDMAINNAME = ""
    var indexPAthMain = 0
    var indexForScroll = 0
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    var newStrainIndex = 0
    var typeComment = "Type your comment here"
    
    @IBOutlet var imgView_Check : UIImageView!
    
    var array_tble = [[String : Any]]()
   
    var chooseStrain  = Strain()
    var DetailStrain  = Strain()
    var spamImageIndex = Int()
    var ischooseGallery = false
    
    var array_filter = [[String : String]]()
     var isShownLabel = false
    var array_Attachment = [Attachment]()
    var array_StrainUSers = [UserStrain]()
    var editAttachment = Attachment()
    var choose_StrainUSers = [UserStrain]()
    var editIndex = -1
    var productArray = [StrainProduct]()
    var editTableArray = [String]()
    var timer = Timer()
    var imgeIndex = 0
    var ratingCount  = 5
    
    var showTag = 0
    
    var surveyStartView = StrainSurveyViewController()

    var reportValue = StrainReport.Answer.rawValue
    
    var current_zipcode = ""
     var current_address = ""
    var isCurrentLocation = false
    var isFliterviewOpen = false
    var refreshControl: UIRefreshControl!
    var questionID = ""
    var refreshReload = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.editTableLoad()
        self.editTableView.separatorStyle = .none
        self.editView.isHidden = true
        self.tbleView_Strain.contentInset.top = -20
        self.image_indicator.image = #imageLiteral(resourceName: "QAMenuUp").withRenderingMode(.alwaysTemplate)
        self.image_indicator.tintColor = UIColor.init(hex: "F4B927")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.HideSurvey), name: NSNotification.Name(rawValue: "HideSurvey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backFormInfo), name: Notification.Name.init("backFrominfo"), object: nil)
        // Do any additional setup after loading the view.
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tbleView_Strain.addSubview(refreshControl)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFliterviewOpen {
                isFliterviewOpen = false
                self.tbleView_Strain.isScrollEnabled = true
                self.tbleView_Strain.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.tbleView_Strain.alpha = 1.0
                    self.FilterTopValue.constant = 10 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                })
            }
            
        }
        
    }
    @objc func RefreshAPICall(sender:AnyObject){
        //        self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        //        self.pageNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            //            self.APICAllForMyAnswers(page:  0)
//            self.isRefreshCall = true
//            self.getPosts()
            self.view_Save.isHidden = true
            self.GetDetailAPI()
            self.surveyStartView = self.GetView(nameViewController: "StrainSurveyViewController", nameStoryBoard: "SurveyStoryBoard") as! StrainSurveyViewController
        })
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFliterviewOpen {
                    isFliterviewOpen = false
                    self.tbleView_Strain.isScrollEnabled = true
                    self.tbleView_Strain.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                         self.tbleView_Strain.alpha = 1.0
                        self.FilterTopValue.constant = 10 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HideSurvey(){
        self.surveyStartView.view.removeFromSuperview()
        self.GetDetailAPI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        if isRefreshonWillAppear {
            self.view_Save.isHidden = true
            self.GetDetailAPI()
            self.surveyStartView = self.GetView(nameViewController: "StrainSurveyViewController", nameStoryBoard: "SurveyStoryBoard") as! StrainSurveyViewController
            
        }else if self.IDMain.count == 0 {
            self.ReloadData()
        }
        isRefreshonWillAppear = false
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.enableMenu()
    }
    @IBAction func closeEditView(sender: UIButton!){
        self.editView.isHidden = true
        self.txtCommentText = ""
    }
    
    func editTableLoad(){
        editTableArray.removeAll()
        editTableArray.append("TextView")
        if self.editAttachment.ID != "-1"{
            editTableArray.append("UploadButton")
        }else{
            editTableArray.append("Image")
        }
        editTableArray.append("AddRating")
        editTableArray.append("SubmitAction")
        
        editTableView.reloadData()
    }
    
    func backFormInfo() {
        self.view_green.isHidden = true
        self.SelectOptions(value: 1)
        self.GetStrainDetailAPI()
    }
    
    func GetDetailAPI(nameIndex: Int? = 0){
        self.showLoading()
        var mainUrl = WebServiceName.get_strain_detail.rawValue
        if nameIndex == 0{
            if IDMAINNAME.count > 0 {
                mainUrl = WebServiceName.strain_details_by_name.rawValue + "/\(IDMAINNAME.RemoveSpace())"
                IDMAINNAME = ""
            } else  if IDMain.count == 0 {
            mainUrl = WebServiceName.get_strain_detail.rawValue + String(describing: self.chooseStrain.strainID!.intValue)
        }else {
            mainUrl = WebServiceName.get_strain_detail.rawValue + IDMain
        }
        }else if IDMAINNAME.count > 0 {
             mainUrl = WebServiceName.strain_details_by_name.rawValue + "/\(IDMAINNAME.RemoveSpace())"
        } else{
            if nameIndex == 1{
                mainUrl = WebServiceName.strain_details_by_name.rawValue + "/\(firstStrainName.RemoveSpace())"
            }else if nameIndex == 2{
                mainUrl = WebServiceName.strain_details_by_name.rawValue + "/\(secondStrainName.RemoveSpace())"
            }
        }
        IDMain = ""
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (success, message, dataMain) in
            self.hideLoading()
//            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
//                    print(dataMain["successData"]! as! [String : Any])
                    if nameIndex != 0 {
                        self.showTag = 0
                        self.showLoading()
                        var succes_Data = dataMain["successData"]! as! [String : Any]
                        if let strain_id = succes_Data["id"] as? Int {
                            self.getStrainDetailId(id: "\(strain_id)")
                            return
                        }else{
                            self.oneBtnCustomeAlert(title: "Error!", discription: "Invalid Strain, plz try again later") { (isComp, btn) in
                                self.Back()
                            }
                            
                        }
                    }
                    self.DetailStrain = Mapper<Strain>().map(JSONObject: dataMain["successData"]! as! [String : Any])!
//                    print(self.DetailStrain)
                    if let strin : Strain =  self.DetailStrain.strain {
                        if let data = dataMain["successData"]! as? [String : Any] {
                            if let top_strain = data["top_strain"] as? [String : Any] {
                                if let coutLike = top_strain["get_likes_count"] as? Int {
                                    if coutLike > 4 {
                                        if let strain_dis = top_strain["description"] as? String {
                                            strin.overview = strain_dis
                                        }
                                    }
                                }else if let coutLike = top_strain["get_likes_count"] as? String {
                                    if Int(coutLike)! > 4 {
                                        if let strain_dis = top_strain["description"] as? String {
                                            strin.overview = strain_dis
                                        }
                                    }
                                }
                                
                            }
                        }
                        self.chooseStrain = strin
                        print(self.chooseStrain.images?.count as Any)
                        print(self.DetailStrain.images?.count as Any)
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                        
                        self.tbleView_Strain.setNeedsLayout()
                        self.tbleView_Strain.layoutIfNeeded()
                        self.refreshReload = true
                        self.ReloadData()
                        
                        
//                        self.ReloadData()
//                        self.ReloadData()
                        if self.timer == nil {
                            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
                        }
                    }
                }else {
                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
        }
    }
    
    func onClickShowImages(sender : UIButton)  {
        let product  = self.productArray[sender.tag].images
        var images_url : [String] =  [String]()
        for prdt in product {
            images_url.append(prdt.image)
        }
        if images_url.count > 0 {
            self.showImagess(attachments: images_url)
        }
    }
    
    func getStrainDetailId(id : String) {
        let mainUrl = WebServiceName.get_strain_detail.rawValue + id
        NetworkManager.GetCall(UrlAPI: mainUrl)
        { (success, message, dataMain) in
            self.hideLoading()
//            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
//                    print(dataMain["successData"]! as! [String : Any])
                    self.DetailStrain = Mapper<Strain>().map(JSONObject: dataMain["successData"]! as! [String : Any])!
//                    print(self.DetailStrain)
                    if let strin : Strain =  self.DetailStrain.strain {
                        if let data = dataMain["successData"]! as? [String : Any] {
                            if let top_strain = data["top_strain"] as? [String : Any] {
                                if let strain_dis = top_strain["description"] as? String {
                                    strin.overview = strain_dis
                                }
                            }
                        }
                        self.chooseStrain = strin
//                        print(self.chooseStrain.images?.count as Any)
//                        print(self.DetailStrain.images?.count as Any)
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                        
                        self.tbleView_Strain.setNeedsLayout()
                        self.tbleView_Strain.layoutIfNeeded()
                        self.ReloadData()
//                        self.ReloadData()
//                        self.ReloadData()
                        self.SelectOptions(value: 0)
                        if self.timer == nil {
                            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
                        }
                    }
                }else {
                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
        }
    }
    
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        self.showLoading()
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        let lon: Double = pdblLongitude
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                self.hideLoading()
                if (error != nil)
                {
                    self.ShowErrorAlert(message: "We are not able to find your current location!")
                    self.textToSet = ""
                    self.productArray.removeAll()
                    self.ReloadData()
                }else{
                    
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country ?? "")
                        print(pm.locality ?? "")
                        print(pm.subLocality ?? "")
                        print(pm.thoroughfare ?? "")
                        print(pm.postalCode ?? "")
                        print(pm.subThoroughfare ?? "")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                            self.current_zipcode = pm.postalCode!
                        }else{
                            self.current_zipcode = (DataManager.sharedInstance.user?.zipcode)!
                            self.textToSet = ""
                            self.productArray.removeAll()
                            self.ReloadData()
                            self.ShowErrorAlert(message: "We are not able to find your current location!")
                           
                        }
                        print(addressString)
                        self.GetLocateAPI(fromCurrentAction: true)
                        self.current_address = addressString
                        self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 2, section: 0)],with: .automatic)
                    }else{
                         self.textToSet = ""
                        self.productArray.removeAll()
                        self.ReloadData()
                        self.ShowErrorAlert(message: "We are not able to find your current location!")
                        
                       
                    }
                }
        })
    }
    
    
    func GetLocateAPI(fromCurrentAction:Bool){
        isCurrentLocation = fromCurrentAction
        self.showLoading()
        self.productArray.removeAll()
        var mainUrl = WebServiceName.locate_strain_budz.rawValue + String(describing: self.chooseStrain.strainID!)
        var zipp = self.current_zipcode
        if fromCurrentAction {
            mainUrl = mainUrl + "&lat=" + String(format:"%f", (DataManager.sharedInstance.user_locaiton?.latitude)!) + "&lng=" + String(format:"%f", (DataManager.sharedInstance.user_locaiton?.longitude)!) + "&skip=0"
            zipp = self.current_zipcode
        
        }
        else{
            zipp = (DataManager.sharedInstance.getPermanentlySavedUser()?.zipcode)!
            mainUrl = mainUrl + "&lat=" + (DataManager.sharedInstance.user?.userlat)! + "&lng=" + (DataManager.sharedInstance.user?.userlng)! + "&skip=0"
        }
        
        
        print(mainUrl)
        NetworkManager.getUserAddressFromZipCode(zipcode: zipp) { (isHas, isTrue, response) in
            //TODO FOR WORK

            if(isHas){
                if( ((response!["results"] as! [[String : Any]]).count) > 0){
                    let location =  (response!["results"] as! [[String : Any]])[0]["address_components"] as! [[String: AnyObject]]
                    var has = -1
                    for lct in location{
                        let st  = lct["long_name"] as! String
                        if self.states.contains(st){
                           has = 1
                            
                        }else {
                            
                        }
                    }
                    if(has == -1){
                        self.hideLoading()
                        self.textToSet = "Sorry we don't offer strains in illegal state"
                        self.productArray.removeAll()
                        self.ReloadData()
                    }else {
                        NetworkManager.GetCall(UrlAPI: mainUrl) { (success, message, dataMain) in
                            self.hideLoading()
                            print(dataMain)
                            if success {
                                if (dataMain["status"] as! String) == "success" {
                                    let mainSuccessData = dataMain["successData"] as! [String : Any]
                                    let mainBudz = mainSuccessData["budz"] as! [[String : Any]]
                                    
                                    for indexObj in mainBudz {
                                        print(indexObj)
                                        let productMain = StrainProduct.init(json: indexObj as [String : AnyObject])
                                        productMain.budzMap = BudzMap.init(json: indexObj as [String : AnyObject])
                                        self.productArray.append(productMain)
                                    }
                                    print(self.productArray.count)
                                    if(self.productArray.count > 0 ){
                                        self.textToSet = ""
                                    }else {
                                        self.textToSet = "Sorry there is no strain available in this state"
                                    }
                                }else {
                                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                                        DataManager.sharedInstance.logoutUser()
                                        self.ShowLogoutAlert()
                                    }
                                }
                            }else {
                                self.ShowErrorAlert(message:message)
                            }
                            self.ReloadData()
                        }
                        
                    }
                }else{
                    self.hideLoading()
                    self.textToSet = "Sorry we don't offer strains in illegal state"
                    self.productArray.removeAll()
                    self.ReloadData()
                }
            }
        }
       
    }
    
    func editAction(sender: UIButton!){
        if self.DetailStrain.strain?.strainReview![sender.tag].attachment?.attachment != nil{
            self.editAttachment.image_URL = (self.DetailStrain.strain?.strainReview![sender.tag].attachment?.attachment)!
            self.editAttachment.ID = "-1"
            
        }
        self.editView.isHidden = false
        self.editIndex = sender.tag
        editTableLoad()
    }
    
    func deleteAction(sender: UIButton!){
        self.txtCommentText = ""
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this review?") { (isComp, btnNum) in
            if isComp {
                self.deleteReview(index: sender.tag)
            }
        }
       
    }
    
    
    
    
    func deleteReview(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["strain_review_id"] = self.DetailStrain.strain?.strainReview![index].id as AnyObject
        
        
        print(newPAram)
        self.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_strain_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
            self.hideLoading()
            
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    
                    self.GetDetailAPI()
                    //                        if self.editedCellIndex != -1{
                    //                            self.editCommentView.isHidden = true
                    //                            self.editedCellIndex = -1
                    //                        }
                    self.ReloadData()
                    self.tbleView_Strain.reloadData()
                }else {
                    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        })
    }
    
    func GetStrainDetailAPI(){
        self.showLoading()
        self.array_StrainUSers.removeAll()
        let mainUrl = WebServiceName.get_user_strain.rawValue + String(describing: self.chooseStrain.strainID!)
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (success, message, dataMain) in
            self.hideLoading()
            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
                    
                    let mainSuccess = dataMain["successData"]! as! [String : Any]
                    self.array_StrainUSers = Mapper<UserStrain>().mapArray(JSONArray: mainSuccess["user_strains"] as! [[String : Any]])
                }else {
                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
            
            self.ReloadData()
        }
    }
}


extension StrainDetailViewController  : UITableViewDelegate , UITableViewDataSource {
    
    func ReloadData(newStrainIndex: Int? = 0){
        self.newStrainIndex = newStrainIndex!
        self.array_tble.removeAll()
          self.array_tble.append(["type" : StrainDataType.Header.rawValue])
          self.array_tble.append(["type" : StrainDataType.ButtonChoose.rawValue])
        print(self.showTag)
        switch  self.showTag {
        case 0:
            self.array_tble.append(["type" : StrainDataType.Description.rawValue])
            
            if self.DetailStrain.madical_conditions != nil {
                if self.DetailStrain.madical_conditions!.count > 0 {
                    self.array_tble.append(["type" : StrainDataType.SurveyResult.rawValue])
                    self.array_tble.append(["type" : StrainDataType.DetailSurvey.rawValue , "data" : StrainSurveyType.Medical.rawValue])
                    self.array_tble.append(["type" : StrainDataType.DetailSurvey.rawValue , "data" : StrainSurveyType.Disease.rawValue])
                    self.array_tble.append(["type" : StrainDataType.DetailSurvey.rawValue , "data" : StrainSurveyType.Mood.rawValue])
                    self.array_tble.append(["type" : StrainDataType.DetailSurvey.rawValue , "data" : StrainSurveyType.Negative.rawValue])
                    self.array_tble.append(["type" : StrainDataType.DetailSurvey.rawValue , "data" : StrainSurveyType.Flavor.rawValue])
                }else{
                    self.array_tble.append(["type" : StrainDataType.nosurvay.rawValue])
                }
            }else{
                self.array_tble.append(["type" : StrainDataType.nosurvay.rawValue])
            }
            
            print(self.chooseStrain.get_strain_survey_user_count?.intValue)
            if self.chooseStrain.get_strain_survey_user_count?.intValue == 0{
                 self.array_tble.append(["type" : StrainDataType.TellExperience.rawValue])
            }
//            self.array_tble.append(["type" : StrainDataType.addplace.rawValue])
            self.array_tble.append(["type" : StrainDataType.ReviewTotal.rawValue])
            
            
            if self.DetailStrain.strain != nil {
                if self.DetailStrain.strain!.strainReview != nil {
                    if self.DetailStrain.strain!.strainReview!.count > 1 {
                        self.array_tble.append(["type" : StrainDataType.CommentCell.rawValue , "index" : 0])
                        self.array_tble.append(["type" : StrainDataType.CommentCell.rawValue , "index" : 1])
                    }else if (self.chooseStrain.strainReview != nil) {
                        
                        if self.chooseStrain.strainReview!.count == 1 {
                            self.array_tble.append(["type" : StrainDataType.CommentCell.rawValue , "index" : 0])

                        }

                    }
                }
            }
           
            if DetailStrain.strain?.get_user_review_count == 0{
            self.array_tble.append(["type" : StrainDataType.AddYourcomment.rawValue])
            self.array_tble.append(["type" : StrainDataType.AddImage.rawValue])
            
            
            if self.array_Attachment.count > 0 {
              self.array_tble.append(["type" : StrainDataType.ShowImage.rawValue])
            }
//
            
            self.array_tble.append(["type" : StrainDataType.AddRating.rawValue])
            self.array_tble.append(["type" : StrainDataType.SubmitComment.rawValue])
            }
            break
            
        case 2:
            self.array_tble.append(["type" : StrainDataType.LocateThisBud.rawValue])
//            self.array_tble.append(["type" : StrainDataType.addplace.rawValue])
            self.array_tble.append(["type" : StrainDataType.NearStrain.rawValue])
            
            for indexObj in 0..<self.productArray.count {
                self.array_tble.append(["type" : StrainDataType.StrainBud.rawValue , "index" : indexObj])
            }
            
            
            break
        default:
            if self.choose_StrainUSers.count == 0 {
                self.array_tble.append(["type" : StrainDataType.StrainAddInfo.rawValue])
            }
            self.array_tble.append(["type" : StrainDataType.StrainShowDes.rawValue])
            if  self.self.array_StrainUSers.count > 0 && (self.array_StrainUSers.first?.get_likes_count?.intValue)! > 4 {
                self.isShownLabel = true
                if self.array_StrainUSers.count > 0 {
                    self.array_tble.append(["type" : StrainDataType.StrainShowType.rawValue])
                    if newStrainIndex == 0{
                        if self.array_StrainUSers[0].indica?.intValue != 100 && self.array_StrainUSers[0].sativa?.intValue != 100{
                            self.array_tble.append(["type" : StrainDataType.StrainShowCrossBreed.rawValue])
                        }
                    }else{
                        if (self.array_StrainUSers[newStrainIndex!].indica?.intValue)! != 100 && self.array_StrainUSers[newStrainIndex!].sativa?.intValue != 100{
                            self.array_tble.append(["type" : StrainDataType.StrainShowCrossBreed.rawValue])
                        }
                    }
                    self.array_tble.append(["type" : StrainDataType.chemistryCell.rawValue])
                    self.array_tble.append(["type" : StrainDataType.StrainShowCare.rawValue])
                    
                }
                
            }else if  self.isHideTAbs{
                self.isShownLabel = false
                if self.array_StrainUSers.count > 0 {
                    self.array_tble.append(["type" : StrainDataType.StrainShowType.rawValue])
                    if newStrainIndex == 0{
                        if self.array_StrainUSers[0].indica?.intValue != 100 && self.array_StrainUSers[0].sativa?.intValue != 100{
                            self.array_tble.append(["type" : StrainDataType.StrainShowCrossBreed.rawValue])
                        }
                    }else{
                        if (self.array_StrainUSers[newStrainIndex!].indica?.intValue)! != 100 && self.array_StrainUSers[newStrainIndex!].sativa?.intValue != 100{
                            self.array_tble.append(["type" : StrainDataType.StrainShowCrossBreed.rawValue])
                        }
                    }
                    self.array_tble.append(["type" : StrainDataType.chemistryCell.rawValue])
                    self.array_tble.append(["type" : StrainDataType.StrainShowCare.rawValue])
                    
                }
            }
            
            if self.choose_StrainUSers.count == 0 && self.array_StrainUSers.count > 0 {
                self.array_tble.append(["type" : StrainDataType.StrainShowEditHeading.rawValue])
                for index in 0..<(self.array_StrainUSers.count){//+(Int(self.array_StrainUSers.count/10))
                    if (false) {//index % 10 == 0 && index > 8
                         self.array_tble.append(["type" : StrainDataType.googleAdd.rawValue , "index" : index])
                    }else{
//                        let decreased_index = (Int(index/10))
                        let ind = index //- //decreased_index
                         self.array_tble.append(["type" : StrainDataType.StrainShowUserEdit.rawValue , "index" : ind])
                    }
                }
            }else {
               
            }
            if(self.array_StrainUSers.count == 0){
                 self.array_tble.append(["type" : StrainDataType.EmptyBlankCell.rawValue])
                 self.array_tble.append(["type" : StrainDataType.StrainAddInfo.rawValue])
            }
            break
        }
        self.tbleView_Strain.reloadData()
        
    }
    
    
    func RegisterXib(){
        
        
         self.tbleView_Strain.register(UINib(nibName: "NoSucravyCell", bundle: nil), forCellReuseIdentifier: "NoSucravyCell")
        
        self.tbleView_Strain.register(UINib(nibName: "AddPlacmentCell", bundle: nil), forCellReuseIdentifier: "AddPlacmentCell")
        
        self.tbleView_Strain.register(UINib(nibName: "StrainDetailHeadingCell", bundle: nil), forCellReuseIdentifier: "StrainDetailHeadingCell")
        self.tbleView_Strain.register(UINib(nibName: "strainDetailButoonChooseView", bundle: nil), forCellReuseIdentifier: "strainDetailButoonChooseView")
        self.tbleView_Strain.register(UINib(nibName: "StrainDescriptionCell", bundle: nil), forCellReuseIdentifier: "StrainDescriptionCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainTopCell", bundle: nil), forCellReuseIdentifier: "StrainTopCell")
        self.tbleView_Strain.register(UINib(nibName: "SurveyInfoCell", bundle: nil), forCellReuseIdentifier: "SurveyInfoCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainTellExperienceCell", bundle: nil), forCellReuseIdentifier: "StrainTellExperienceCell")
        self.tbleView_Strain.register(UINib(nibName: "AddcommentCell", bundle: nil), forCellReuseIdentifier: "AddcommentCell")
        self.tbleView_Strain.register(UINib(nibName: "Commentcell", bundle: nil), forCellReuseIdentifier: "Commentcell")
        self.tbleView_Strain.register(UINib(nibName: "TypeCommectStrainCell", bundle: nil), forCellReuseIdentifier: "TypeCommectStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "AddImageStrainCell", bundle: nil), forCellReuseIdentifier: "AddImageStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainRatingcell", bundle: nil), forCellReuseIdentifier: "StrainRatingcell")
        self.tbleView_Strain.register(UINib(nibName: "SubmitcommentStrainCell", bundle: nil), forCellReuseIdentifier: "SubmitcommentStrainCell")

        self.tbleView_Strain.register(UINib(nibName: "StrainLocationCell", bundle: nil), forCellReuseIdentifier: "StrainLocationCell")
        self.tbleView_Strain.register(UINib(nibName: "NearStrainCell", bundle: nil), forCellReuseIdentifier: "NearStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainBudCell", bundle: nil), forCellReuseIdentifier: "StrainBudCell")
        self.tbleView_Strain.register(UINib(nibName: "EmptyBlankCell", bundle: nil), forCellReuseIdentifier: "EmptyBlankCell")

        self.tbleView_Strain.register(UINib(nibName: "AddMoreStrinInfoCell", bundle: nil), forCellReuseIdentifier: "AddMoreStrinInfoCell")
        self.tbleView_Strain.register(UINib(nibName: "FullDescriptionStrainCEll", bundle: nil), forCellReuseIdentifier: "FullDescriptionStrainCEll")
        self.tbleView_Strain.register(UINib(nibName: "StrainTypeShowCell", bundle: nil), forCellReuseIdentifier: "StrainTypeShowCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainBreedCell", bundle: nil), forCellReuseIdentifier: "StrainBreedCell")
        self.tbleView_Strain.register(UINib(nibName: "chemistryShowCell", bundle: nil), forCellReuseIdentifier: "chemistryShowCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainCareShowCell", bundle: nil), forCellReuseIdentifier: "StrainCareShowCell")
        self.tbleView_Strain.register(UINib(nibName: "StrainEditcountCell", bundle: nil), forCellReuseIdentifier: "StrainEditcountCell")
        self.tbleView_Strain.register(UINib(nibName: "UserEditInfoStrainCell", bundle: nil), forCellReuseIdentifier: "UserEditInfoStrainCell")
        
        self.tbleView_Strain.register(UINib(nibName: "GoogleAddCell", bundle: nil), forCellReuseIdentifier: "GoogleAddCell")

        self.tbleViewFilter.register(UINib(nibName: "QAFilterCell", bundle: nil), forCellReuseIdentifier: "QAFilterCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        
        
        self.editTableView.register(UINib(nibName: "TypeCommectStrainCell", bundle: nil), forCellReuseIdentifier: "TypeCommectStrainCell")
        self.editTableView.register(UINib(nibName: "AddImageStrainCell", bundle: nil), forCellReuseIdentifier: "AddImageStrainCell")
        self.editTableView.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.editTableView.register(UINib(nibName: "StrainRatingcell", bundle: nil), forCellReuseIdentifier: "StrainRatingcell")
        self.editTableView.register(UINib(nibName: "SubmitcommentStrainCell", bundle: nil), forCellReuseIdentifier: "SubmitcommentStrainCell")
       
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isHideTAbs {
            if indexPath.row == 0 {
                return 80
            }else if indexPath.row == 1 {
                return 0
            }
        }
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.array_tble.count)
        if tableView == editTableView{
            return editTableArray.count
        }else if tableView.tag == 100 {
            return self.array_filter.count
        }
        
        return self.array_tble.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == editTableView{
             self.view_green.isHidden = true
            switch editTableArray[indexPath.row] {
            case "TextView":
                return CommentAddCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "UploadButton":
                return AddImageCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "Image":
                return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "AddRating":
                return AddStrainRatingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "SubmitAction":
                return SubmitStrainComment(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitStrainComment(tableView:tableView  ,cellForRowAt:indexPath)
            }
        }else if tableView.tag == 100 {
            self.view_green.isHidden = true
                if indexPath.row == 0 {
                    return self.ReportHeadingCell(tableView, cellForRowAt: indexPath)
                }else if indexPath.row == self.array_filter.count - 1 {
                    
                    return self.SendButtonCell(tableView, cellForRowAt: indexPath)
                    
                }else {
                    return self.ReportOptionCell(tableView, cellForRowAt: indexPath)
                }
                
           
        }else {
            
            let DataElement = self.array_tble[indexPath.row]
            
            let dataType = DataElement["type"] as! String
            
            switch dataType {
            case StrainDataType.nosurvay.rawValue:
                let cellHeading = tableView.dequeueReusableCell(withIdentifier: "NoSucravyCell") as! NoSucravyCell
                cellHeading.selectionStyle = .none
                return cellHeading
                
           case StrainDataType.addplace.rawValue:
                let cellHeading = tableView.dequeueReusableCell(withIdentifier: "AddPlacmentCell") as! AddPlacmentCell
                cellHeading.selectionStyle = .none
                return cellHeading
            case StrainDataType.ButtonChoose.rawValue:
                return HeadingButtonxell(tableView:tableView  ,cellForRowAt:indexPath)
            case StrainDataType.Description.rawValue :
                return DescriptionMainCell(tableView:tableView  ,cellForRowAt:indexPath)
            case StrainDataType.SurveyResult.rawValue :
                return SurveyResultTop(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.DetailSurvey.rawValue :
                return SurveyInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.TellExperience.rawValue :
                return TellExperienceCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.ReviewTotal.rawValue :
                return TotalReviewCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.CommentCell.rawValue :
                return CommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.AddYourcomment.rawValue :
                return CommentAddCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.AddImage.rawValue :
                return AddImageCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.ShowImage.rawValue :
                return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.AddRating.rawValue :
                return AddStrainRatingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.SubmitComment.rawValue :
                return SubmitStrainComment(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.LocateThisBud.rawValue :
                return LocateThisBudMainCell(tableView:tableView  ,cellForRowAt:indexPath)
                
                
            case StrainDataType.NearStrain.rawValue :
                return NEarStrainCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainBud.rawValue :
                return StrainBud(tableView:tableView  ,cellForRowAt:indexPath)
                
                
            case StrainDataType.StrainAddInfo.rawValue :
                return MoreStrainInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainShowDes.rawValue :
                return ShowDescriptionStrain(tableView:tableView  ,cellForRowAt:indexPath)
                
                
            case StrainDataType.StrainShowType.rawValue :
                return StrainTypeshow(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainShowCrossBreed.rawValue :
                return BreedShowCell(tableView:tableView  ,cellForRowAt:indexPath)
             
            case StrainDataType.chemistryCell.rawValue :
                return AddChemistryCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainShowCare.rawValue :
                return CareShowCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainShowEditHeading.rawValue :
                return EditHEadingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case StrainDataType.StrainShowUserEdit.rawValue :
                return UserEditInfoStrain(tableView:tableView  ,cellForRowAt:indexPath)
            case StrainDataType.EmptyBlankCell.rawValue:
                return EmptyBlankCell(tableView:tableView  ,cellForRowAt:indexPath)
            case StrainDataType.googleAdd.rawValue :
                let add_cell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddCell") as! GoogleAddCell
                self.addBannerViewToView(add_cell.add_view)
                add_cell.selectionStyle = .none
                return add_cell
            default:
                return StrainHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            
            
            print(indexPath)
            if indexPath.row == 0 || indexPath.row == self.array_filter.count - 1 {
                
            }else {
                for index in 1..<self.array_filter.count - 1 {
                    
                    if indexPath.row == index {
                        let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleS")
                        tbleviewCell.view_BG.isHidden = false
                        self.ChooseReportOption(value: index)
                        
                    }else {
                        let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleE")
                        tbleviewCell.view_BG.isHidden = true
                    }
                }
                
            }
        }else {
            
//            let cellMain = self.tbleView_Strain.cellForRow(at: indexPath)
            
            if (self.tbleView_Strain.cellForRow(at: indexPath) as? StrainBudCell) != nil {
                let mainBud = self.array_tble[indexPath.row]
                let index = mainBud["index"] as! Int
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                viewPush.budz_map_id = self.productArray[index].sub_user_id
                self.navigationController?.pushViewController(viewPush, animated: true)
            }
        }
    }

    func ChooseReportOption(value : Int){
        
        print("value \(value)")
        switch value {
        case 1:
            self.reportValue = StrainReport.Nudity.rawValue
            break
        case 2:
            self.reportValue = StrainReport.harassment.rawValue
            break
        case 3:
            self.reportValue = StrainReport.violent.rawValue
            break
        case 4:
            self.reportValue = StrainReport.Answer.rawValue
            break
        case 5:
            self.reportValue = StrainReport.Spam.rawValue
            break
        case 6:
            self.reportValue = StrainReport.Unrelated.rawValue
            break
            
        default:
            break;
        }
    }
}

//MARK:
//MARK: Cell

extension StrainDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.chooseStrain.images != nil {
            if self.chooseStrain.images?.count == 0 {
                if let cell_tbl = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell {
                    cell_tbl.img_user_view.isHidden = true
                }
            }
            return self.chooseStrain.images!.count
        }
        if let cell_tbl = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell {
            cell_tbl.img_user_view.isHidden = true
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.imgViewMain.backgroundColor = UIColor.init(hex: "232323")
        cell.imgViewMain.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseStrain.images![indexPath.row].image_path!)!)
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
      
        if let cell_tbl = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell {
            cell_tbl.lbl_Image_UploaderName.text = self.chooseStrain.images![indexPath.row].user?.first_name
            let points  = self.chooseStrain.images![indexPath.row].user?.points?.intValue
            cell_tbl.lbl_Image_UploaderName.textColor = self.getColor(point: points!)
            cell_tbl.lbl_Image_Date.text = self.getDateWithTh(date: self.chooseStrain.images![indexPath.row].created_at!)//self.chooseStrain.images![indexPath.row].created_at?.GetDateWith(formate: "MMMM dd, yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                
            cell_tbl.lbl_UpVote.text = self.chooseStrain.images![indexPath.row].Image_like_count
            cell_tbl.lbl_DownVote.text = self.chooseStrain.images![indexPath.row].Image_Dilike_count
            cell_tbl.btn_likeUp.tag = indexPath.row
            
            if self.chooseStrain.images![indexPath.row].flagged{
                
                    cell_tbl.imgView_flag.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                    cell_tbl.imgView_flag.tintColor = UIColor.init(hex: "F4B927")
                
            }else{
                    cell_tbl.imgView_flag.image = #imageLiteral(resourceName: "flag_white")
            }
            if self.chooseStrain.strain?.type_id == 1 {
//                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainGreenColor)
//                    strainCell.lblType.textColor = ConstantsColor.kStrainGreenColor
//                    strainCell.lblType.text = "H"
                cell_tbl.imgView_type.image = #imageLiteral(resourceName: "ic_hyb")
            }else if self.chooseStrain.strain?.type_id == 2 {
//                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainPurpleColor)
//                    strainCell.lblType.textColor = ConstantsColor.kStrainPurpleColor
//                    strainCell.lblType.text = "I"
                cell_tbl.imgView_type.image = #imageLiteral(resourceName: "ic_ind")
            }else {
                cell_tbl.imgView_type.image = #imageLiteral(resourceName: "ic_sti")
//                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainRedColor)
//                    strainCell.lblType.textColor = ConstantsColor.kStrainRedColor
//                    strainCell.lblType.text = "S"
            }
            cell_tbl.userViewButton.tag = indexPath.row
            cell_tbl.userViewButton.addTarget(self, action: #selector(self.OpenUserProfile), for: .touchUpInside)
            cell_tbl.btn_flag.tag = indexPath.row
            cell_tbl.btn_flag.addTarget(self, action: #selector(self.ShowFilterViewforStrain), for: UIControlEvents.touchUpInside)
            cell_tbl.btn_likeUp.addTarget(self, action: #selector(self.GoUpAction), for: UIControlEvents.touchUpInside)
            cell_tbl.btn_likeDown.tag = indexPath.row
            cell_tbl.btn_likeDown.addTarget(self, action: #selector(self.GodownAction), for: UIControlEvents.touchUpInside)
            if self.chooseStrain.images![indexPath.row].liked == 1{
                cell_tbl.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
                cell_tbl.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_Green").withRenderingMode(.alwaysTemplate)
                cell_tbl.imgView_likeUp.tintColor = UIColor.init(hex: "f4c42f")
            }else if self.chooseStrain.images![indexPath.row].disliked == 1{
                cell_tbl.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
                cell_tbl.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_Green").withRenderingMode(.alwaysTemplate)
                cell_tbl.imgView_likeDown.tintColor = UIColor.init(hex: "f4c42f")
            }else {
                cell_tbl.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
                cell_tbl.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
            }
            })
        }
    }

    @IBAction func OpenUserProfile(sender : UIButton){
        var name = self.chooseStrain.images![sender.tag].user?.first_name
        if name != "Healing Budz"{
            let id = self.chooseStrain.images![sender.tag].user_id
            self.OpenProfileVC(id: String(id!.intValue))
        }
        
    }
    func loop() {
        if self.chooseStrain.images == nil {
            return
        }
        if indexPAthMain > ((self.chooseStrain.images?.count)! - 2) {
            indexPAthMain = 0
        }else {
            indexPAthMain = indexPAthMain + 1
        }
        
        print(indexPAthMain)
        if choose_StrainUSers.count == 0{
        if (self.chooseStrain.images?.count)! > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30, execute: {
                
                if self.cellMain.collectionView.numberOfItems(inSection: 0) > self.indexPAthMain && self.indexPAthMain < self.chooseStrain.images!.count  {
                    self.cellMain.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                }
                if  let cell = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell{
                    cell.lbl_Image_UploaderName.text = self.chooseStrain.images![self.indexPAthMain].user?.first_name
                    if let points  = self.chooseStrain.images![self.indexPAthMain].user?.points?.intValue {
                        cell.lbl_Image_UploaderName.textColor = self.getColor(point: points)
                    }else {
                        cell.lbl_Image_UploaderName.textColor = self.getColor(point: Int((DataManager.sharedInstance.user?.Points)!)!)
                    }
                    cell.lblReward.text = String((self.chooseStrain.get_likes_count?.intValue)!)
                    cell.lbl_Image_Date.text = self.getDateWithTh(date: self.chooseStrain.images![self.indexPAthMain].created_at!)// self.chooseStrain.images![self.indexPAthMain].created_at?.GetDateWith(formate: "MMMM dd, yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
                    cell.lbl_UpVote.text = self.chooseStrain.images![self.indexPAthMain].Image_like_count
                    cell.lbl_DownVote.text = self.chooseStrain.images![self.indexPAthMain].Image_Dilike_count
                    cell.btn_likeUp.tag = self.indexPAthMain
                    
                    if self.chooseStrain.images![self.indexPAthMain].flagged{
                        
                        cell.imgView_flag.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                        cell.imgView_flag.tintColor = UIColor.init(hex: "F4B927")
                        
                    }else{
                        cell.imgView_flag.image = #imageLiteral(resourceName: "flag_white")
                    }
                    cell.userViewButton.tag = self.indexPAthMain
                    cell.userViewButton.addTarget(self, action: #selector(self.OpenUserProfile), for: .touchUpInside)
                    cell.btn_flag.tag = self.indexPAthMain
                    cell.btn_flag.addTarget(self, action: #selector(self.ShowFilterViewforStrain), for: UIControlEvents.touchUpInside)
                    cell.btn_likeUp.addTarget(self, action: #selector(self.GoUpAction), for: UIControlEvents.touchUpInside)
                    cell.btn_likeDown.tag = self.indexPAthMain
                    cell.btn_likeDown.addTarget(self, action: #selector(self.GodownAction), for: UIControlEvents.touchUpInside)
                    if self.chooseStrain.images![self.indexPAthMain].liked == 1 && self.chooseStrain.images![self.indexPAthMain].disliked == 0 {
                        cell.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
                        cell.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_Green").withRenderingMode(.alwaysTemplate)
                        cell.imgView_likeUp.tintColor = UIColor.init(hex: "f4c42f")
                    }else if self.chooseStrain.images![self.indexPAthMain].disliked == 1 && self.chooseStrain.images![self.indexPAthMain].liked == 0{
                        cell.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
                        cell.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_Green").withRenderingMode(.alwaysTemplate)
                        cell.imgView_likeDown.tintColor = UIColor.init(hex: "f4c42f")
                    }else {
                        cell.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
                        cell.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
                    }
                }
            })
        }
    }
    }
}


extension StrainDetailViewController {
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? StrainDetailHeadingCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        if refreshReload{
        refreshReload = false
        self.tbleView_Strain.reloadData()
        }
        
    }
    
    func StrainHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeading = tableView.dequeueReusableCell(withIdentifier: "StrainDetailHeadingCell") as! StrainDetailHeadingCell
        
        self.cellMain = cellHeading
        if self.chooseStrain.type_id! == 1 {
            //                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainGreenColor)
            //                    strainCell.lblType.textColor = ConstantsColor.kStrainGreenColor
            //                    strainCell.lblType.text = "H"
            cellHeading.imgView_type.image = #imageLiteral(resourceName: "ic_hyb")
        }else if self.chooseStrain.type_id! == 2 {
            //                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainPurpleColor)
            //                    strainCell.lblType.textColor = ConstantsColor.kStrainPurpleColor
            //                    strainCell.lblType.text = "I"
            cellHeading.imgView_type.image = #imageLiteral(resourceName: "ic_ind")
        }else {
            cellHeading.imgView_type.image = #imageLiteral(resourceName: "ic_sti")
            //                    strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainRedColor)
            //                    strainCell.lblType.textColor = ConstantsColor.kStrainRedColor
            //                    strainCell.lblType.text = "S"
        }
        if (self.chooseStrain.images?.count)! > 0{
        if self.chooseStrain.images![0].flagged{
            
                cellHeading.imgView_flag.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                cellHeading.imgView_flag.tintColor = UIColor.init(hex: "F4B927")
            
        }else{
              cellHeading.imgView_flag.image = #imageLiteral(resourceName: "flag_white")
        }
        }
        
        if (self.chooseStrain.images?.count)! > 1{
        cellHeading.arrow1View.isHidden = false
        cellHeading.arrow2View.isHidden = false
            
        }else{
            cellHeading.arrow1View.isHidden = true
            cellHeading.arrow2View.isHidden = true
        }
        
        if (self.chooseStrain.images?.count)! > 0{
            cellHeading.viewFlag.isHidden = false
            cellHeading.viewLikeUp.isHidden = false
            cellHeading.viewLikeDown.isHidden = false
            if self.chooseStrain.images![0].liked == 1{
                cellHeading.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_Green").withRenderingMode(.alwaysTemplate)
                cellHeading.imgView_likeUp.tintColor = UIColor.init(hex: "f4c42f")
                cellHeading.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
            }else  if self.chooseStrain.images![indexPath.row].disliked == 1{
                cellHeading.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
                cellHeading.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_Green").withRenderingMode(.alwaysTemplate)
                cellHeading.imgView_likeDown.tintColor = UIColor.init(hex: "f4c42f")
            }else {
                cellHeading.imgView_likeDown.image = #imageLiteral(resourceName: "like_Down_White")
                cellHeading.imgView_likeUp.image = #imageLiteral(resourceName: "like_Up_White")
            }
            cellHeading.lbl_UpVote.text = self.chooseStrain.images![0].Image_like_count
            cellHeading.lbl_DownVote.text = self.chooseStrain.images![0].Image_Dilike_count
            cellHeading.imgTopShow.isHidden = true
        }else{
            cellHeading.imgTopShow.isHidden = false
            cellHeading.viewFlag.isHidden = true
            cellHeading.viewLikeUp.isHidden = true
            cellHeading.viewLikeDown.isHidden = true
        }
        
        
        cellHeading.btn_Back.addTarget(self, action: #selector(self.GO_Back_ACtion), for: UIControlEvents.touchUpInside)
        
        cellHeading.btn_Share.addTarget(self, action: #selector(self.ShareAction), for: UIControlEvents.touchUpInside)
        cellHeading.btn_Share.tag = indexPath.row
        
        cellHeading.btn_Upload.addTarget(self, action: #selector(self.UPloadImage), for: UIControlEvents.touchUpInside)
        
        
        cellHeading.btn_Home.addTarget(self, action: #selector(self.GO_Home_ACtion), for: UIControlEvents.touchUpInside)
        
        cellHeading.btn_like.addTarget(self, action: #selector(self.GO_Like_ACtion), for: UIControlEvents.touchUpInside)

        

        cellHeading.btn_Gallery.addTarget(self, action: #selector(self.GoToGallery), for: UIControlEvents.touchUpInside)
        
        cellHeading.btn_like.addTarget(self, action: #selector(self.SaveAction), for: UIControlEvents.touchUpInside)

        cellHeading.btn_Next.addTarget(self, action: #selector(self.nextsliderImage), for: UIControlEvents.touchUpInside)
        
        cellHeading.btn_Previous.addTarget(self, action: #selector(self.previousSliderImage), for: UIControlEvents.touchUpInside)
        
        if self.showTag == 0{
        cellHeading.btn_Review.addTarget(self, action: #selector(self.addNewComment), for: UIControlEvents.touchUpInside)
        }
        
        if self.chooseStrain.is_saved_count?.intValue == 0 {
            cellHeading.imgView_like.image = #imageLiteral(resourceName: "Heart_White")
        }else {
            cellHeading.imgView_like.image = #imageLiteral(resourceName: "Heart_Filled")
        }
        
        cellHeading.lbl_Name.text = self.chooseStrain.title
        cellHeading.lbl_Type.text = self.chooseStrain.strainType?.title
        
        print(self.DetailStrain.strain?.get_review_count)
        if self.chooseStrain.get_review_count != nil {
            cellHeading.lbl_Review.text = String(format:"%d", (self.chooseStrain.get_review_count!.intValue)) + " Reviews"
            if self.chooseStrain.rating?.total != nil {
                cellHeading.lbl_rating.text  = String(format:"%.1f", (self.chooseStrain.rating?.total!.doubleValue)!)
            }else {
                cellHeading.lbl_rating.text  = "0.0"
            }
        }
        cellHeading.btn_likeUp.tag = 0
       
        cellHeading.userViewButton.tag = 0
        cellHeading.userViewButton.addTarget(self, action: #selector(self.OpenUserProfile), for: .touchUpInside)
        cellHeading.btn_flag.tag = 0
        cellHeading.btn_flag.addTarget(self, action: #selector(self.ShowFilterViewforStrain), for: UIControlEvents.touchUpInside)
        cellHeading.btn_likeUp.addTarget(self, action: #selector(self.GoUpAction), for: UIControlEvents.touchUpInside)
        cellHeading.btn_likeDown.tag = 0
        cellHeading.btn_likeDown.addTarget(self, action: #selector(self.GodownAction), for: UIControlEvents.touchUpInside)
        if Double(cellHeading.lbl_rating.text!)! < 1.0 {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain1B")
        }else if Double(cellHeading.lbl_rating.text!)! < 2.0 {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain1B")
        }else if Double(cellHeading.lbl_rating.text!)! < 3.0 {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain2B")
        }else if Double(cellHeading.lbl_rating.text!)! < 4.0 {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain3B")
        }else if Double(cellHeading.lbl_rating.text!)! < 5.0 {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain4B")
        }else {
            cellHeading.imgView_Rating.image = #imageLiteral(resourceName: "Strain5B")
        }
        
//        if let points  = self.chooseStrain.get_likes_count?.intValue {
//             cellHeading.lbl_UpVote.text = String(describing: points)
//        }else{
//             cellHeading.lbl_UpVote.text =  ""
//        }
       
//        cellHeading.lbl_DownVote.text = String(describing: self.chooseStrain.get_dislikes_count!)
        
        
        
        if self.choose_StrainUSers.count == 0 {
            cellHeading.view_Upper.isHidden = true
        }else {
            cellHeading.view_Upper.isHidden = false
            cellHeading.lbl_UpperTime.text = self.GetTimeAgo(StringDate: self.choose_StrainUSers[0].updated_at!)
            cellHeading.lbl_UpperUserName.text = self.choose_StrainUSers[0].user?.first_name
            cellHeading.lbl_like_header.text  = String(describing:(self.choose_StrainUSers[0].get_likes_count?.intValue)!)
            if (self.choose_StrainUSers[0].get_user_like_count?.intValue)! > 0{
                cellHeading.strainDetailLikeImg.image = #imageLiteral(resourceName: "like_Up_Green").withRenderingMode(.alwaysTemplate)
                cellHeading.strainDetailLikeImg.tintColor = UIColor.init(hex: "f4c42f")
            }else{
                cellHeading.strainDetailLikeImg.image = #imageLiteral(resourceName: "like_Up_White")
            }
            cellHeading.strainDetailLike.tag = 0
            cellHeading.strainDetailLike.addTarget(self, action: #selector(self.LikeComment), for: .touchUpInside)
        }
        
        if self.chooseStrain.images != nil && self.chooseStrain.images!.count > 0 {
            cellHeading.lbl_Image_UploaderName.text = self.chooseStrain.images![indexPAthMain].user?.first_name
            if let points  = self.chooseStrain.images![indexPath.row].user?.points?.intValue{
                cellHeading.lbl_Image_UploaderName.textColor = self.getColor(point: points)
            }else{
                cellHeading.lbl_Image_UploaderName.textColor = self.getColor(point: Int((DataManager.sharedInstance.user?.Points)!)!)
            }
            cellHeading.lbl_Image_Date.text = self.getDateWithTh(date: self.chooseStrain.images![indexPath.row].created_at!)//self.chooseStrain.images![indexPath.row].created_at?.GetDateWith(formate: "MMMM dd, yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
            cellHeading.btn_Next.isHidden = false
            cellHeading.btn_Previous.isHidden = false
        }else{
            cellHeading.lbl_Image_UploaderName.text = ""
            cellHeading.lbl_Image_Date.text = ""
            cellHeading.btn_Next.isHidden = true
            cellHeading.btn_Previous.isHidden = true
        }
      
        cellHeading.btn_BackUpper.addTarget(self, action: #selector(self.BacktoReload), for: UIControlEvents.touchUpInside)

        var pathArray = [String]()
        var titleArray = [String]()

        if self.chooseStrain.images != nil {
            for indexObj in self.chooseStrain.images! {
                pathArray.append(WebServiceName.images_baseurl.rawValue + indexObj.image_path!)
                titleArray.append("")
            }
            if self.chooseStrain.images?.count == 0{
                cellHeading.img_user_view.isHidden = true
            }else{
                cellHeading.img_user_view.isHidden = false
            }
        }else{
         cellHeading.img_user_view.isHidden = true
        }
        cellHeading.selectionStyle = .none
        return cellHeading
    }
    
    func nextsliderImage()  {
        if indexPAthMain > ((self.chooseStrain.images?.count)! - 2) {
            indexPAthMain = 0
        }else {
            indexPAthMain = indexPAthMain + 1
        }
        print(indexPAthMain)
        self.cellMain.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    func previousSliderImage()  {
        if indexPAthMain > 0 {
           indexPAthMain = indexPAthMain - 1
        }else {
            indexPAthMain = ((self.chooseStrain.images?.count)! - 1)
        }
        print(indexPAthMain)
        self.cellMain.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
    func UPloadImage(){
        self.isAddStrainGalleryImg = true
        ischooseGallery = true
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    func BacktoReload(sender : UIButton){
        self.isHideTAbs = false
        self.view_green.isHidden = true
        self.choose_StrainUSers.removeAll()
        if  let cell = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell{
            cell.collectionView.reloadData()
        }
        self.cellMain.collectionView.reloadData()
        self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
        self.ReloadData()
    }
    
   
    func HeadingButtonxell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellBtnHeading = tableView.dequeueReusableCell(withIdentifier: "strainDetailButoonChooseView") as! strainDetailButoonChooseView
        cellBtnHeading.lblLeft.text = "Strain Overview"
        cellBtnHeading.lblMiddel.text = "Strain Details"
        cellBtnHeading.lblRight.text = "Locate This"
        
        
        cellBtnHeading.btnLeft.addTarget(self, action: #selector(LeftButtonAction), for: UIControlEvents.touchUpInside)
        
        cellBtnHeading.btnRight.addTarget(self, action: #selector(RightButtonAction), for: UIControlEvents.touchUpInside)
        
        
        cellBtnHeading.btnMiddel.addTarget(self, action: #selector(MiddelButtonAction), for: UIControlEvents.touchUpInside)
        
        
        cellBtnHeading.selectionStyle = .none
        return cellBtnHeading
    }
    
    func DescriptionMainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellDescription = tableView.dequeueReusableCell(withIdentifier: "StrainDescriptionCell") as! StrainDescriptionCell
        if self.array_StrainUSers.count == 0  && self.showTag == 1{
            cellDescription.lbl_title.text  = "Full Description:"
            cellDescription.line.isHidden = true
            if let discription = self.chooseStrain.overview?.RemoveHTMLTag().trimmingCharacters(in: .whitespaces), discription != "" {
                cellDescription.constraint_height.constant = 0
                cellDescription.btn_full_discription.isHidden = true
                cellDescription.lblDescription.text = discription
            }else{
                cellDescription.constraint_height.constant = 0
                cellDescription.btn_full_discription.isHidden = true
                cellDescription.lblDescription.text = "No Description Added"
            }
        }else{
            cellDescription.lbl_title.text  = "Short Description:"
            cellDescription.line.isHidden = false
            if let discription = self.chooseStrain.overview?.RemoveHTMLTag().trimmingCharacters(in: .whitespaces), discription != "" {
                if discription.count > 100 {
                    cellDescription.constraint_height.constant = 18
                    cellDescription.btn_full_discription.isHidden = false
                    let str : String =  discription.RemoveHTMLTag()
                    cellDescription.lblDescription.applyTag(baseVC: self , mainText:String(str[0...99]) )
                    cellDescription.lblDescription.text  = String(str[0...99])
                    
                }else{
                    cellDescription.constraint_height.constant = 0
                    cellDescription.btn_full_discription.isHidden = true
                     cellDescription.lblDescription.applyTag(baseVC: self , mainText:discription )
                    cellDescription.lblDescription.text = discription
                }
            }else{
                cellDescription.constraint_height.constant = 0
                cellDescription.btn_full_discription.isHidden = true
                cellDescription.lblDescription.applyTag(baseVC: self , mainText:"No description added." )
                cellDescription.lblDescription.text = "No description added."
            }
        }
        cellDescription.btn_full_discription.addTarget(self, action: #selector(MiddelButtonAction), for: UIControlEvents.touchUpInside)
        cellDescription.selectionStyle = .none
        return cellDescription
    }

    
    func SurveyResultTop(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellSurveyTop = tableView.dequeueReusableCell(withIdentifier: "StrainTopCell") as! StrainTopCell
//        cellSurveyTop.Btn_Info.addTarget(self, action: #selector(self.showFirstPopup), for: UIControlEvents.touchUpInside)
        cellSurveyTop.Btn_Info.addTarget(self, action: #selector(self.InfoTypeBottomLeft(sender:)), for: UIControlEvents.touchUpInside)
        
        cellSurveyTop.lbl_Count.text = String(self.DetailStrain.survey_budz_count!.intValue)
        cellSurveyTop.selectionStyle = .none
        return cellSurveyTop
    }
    
    
    func SurveyInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellSurveyInfo = tableView.dequeueReusableCell(withIdentifier: "SurveyInfoCell") as! SurveyInfoCell
        cellSurveyInfo.top_View.constant = -800
        cellSurveyInfo.Bottom_View.constant = -800
        cellSurveyInfo.Center_View.constant = -800
        cellSurveyInfo.top_ViewHi.constant = 35
        cellSurveyInfo.Bottom_ViewHi.constant = 35
        cellSurveyInfo.Center_ViewHi.constant = 35
        let dataMain = self.array_tble[indexPath.row]
        
        let typeMain = dataMain["data"] as! String
        
        switch typeMain {
        case StrainSurveyType.Disease.rawValue:
            cellSurveyInfo.imgView_Main.image = UIImage.init(named: "strain_disease_icon")
            cellSurveyInfo.lbl_Main.text = "DISEASE PREVENTION"
            cellSurveyInfo.lbl_Top.text = ""
            cellSurveyInfo.lbl_Center.text = ""
            cellSurveyInfo.lbl_Bottom.text = ""
            
            if self.DetailStrain.preventions!.count == 0 {
                cellSurveyInfo.top_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
                
                
            }else  if self.DetailStrain.preventions!.count == 1 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.preventions?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.preventions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                cellSurveyInfo.Center_ViewHi.constant = 0
            }else  if self.DetailStrain.preventions!.count == 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.preventions?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.preventions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
   
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.preventions?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.preventions![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
            }else  if self.DetailStrain.preventions!.count > 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.preventions?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.preventions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.preventions?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.preventions![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Bottom.text = self.DetailStrain.preventions?[2].name
                cellSurveyInfo.Bottom_View.constant = CGFloat((self.DetailStrain.preventions![2].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
            }
            
            break;
            
        case StrainSurveyType.Flavor.rawValue:
            cellSurveyInfo.imgView_Main.image = UIImage.init(named: "strain_flavour_icon")
            cellSurveyInfo.lbl_Main.text = "FLAVOR PROFILES"
            
            cellSurveyInfo.lbl_Top.text = ""
            cellSurveyInfo.lbl_Center.text = ""
            cellSurveyInfo.lbl_Bottom.text = ""
            
            
            if self.DetailStrain.survey_flavors!.count == 0 {
                cellSurveyInfo.top_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
            }else if self.DetailStrain.survey_flavors!.count == 1 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.survey_flavors?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.survey_flavors![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                cellSurveyInfo.Center_ViewHi.constant = 0
            }else if self.DetailStrain.survey_flavors!.count == 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.survey_flavors?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.survey_flavors![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.survey_flavors?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.survey_flavors![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                 cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
            }else if self.DetailStrain.survey_flavors!.count > 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.survey_flavors?[0].name
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.survey_flavors![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.survey_flavors?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.survey_flavors![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Bottom.text = self.DetailStrain.survey_flavors?[2].name
                cellSurveyInfo.Bottom_View.constant = CGFloat((self.DetailStrain.survey_flavors![2].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
            }
            break;
        case StrainSurveyType.Medical.rawValue:
            cellSurveyInfo.imgView_Main.image = UIImage.init(named: "starin_medical_icon")
            cellSurveyInfo.lbl_Main.text = "MEDICAL USES"
            
            
            cellSurveyInfo.lbl_Top.text = ""
            cellSurveyInfo.lbl_Center.text = ""
            cellSurveyInfo.lbl_Bottom.text = ""
            
            if self.DetailStrain.madical_conditions!.count == 0 {
                cellSurveyInfo.top_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
            }else if self.DetailStrain.madical_conditions!.count == 1 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.madical_conditions?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.madical_conditions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                 cellSurveyInfo.Bottom_View.constant = -800
                 cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                cellSurveyInfo.Center_ViewHi.constant = 0
            }else if self.DetailStrain.madical_conditions!.count == 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.madical_conditions?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.madical_conditions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
               
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.madical_conditions?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.madical_conditions![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                 cellSurveyInfo.Bottom_View.constant = -800
            }else if self.DetailStrain.madical_conditions!.count > 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.madical_conditions?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.madical_conditions![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.madical_conditions?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.madical_conditions![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Bottom.text = self.DetailStrain.madical_conditions?[2].name
                
                cellSurveyInfo.Bottom_View.constant = CGFloat((self.DetailStrain.madical_conditions![2].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
            }
            break;
            
            
        case StrainSurveyType.Mood.rawValue:
            cellSurveyInfo.imgView_Main.image = UIImage.init(named: "strain_modes_icon")
            cellSurveyInfo.lbl_Main.text = "MOODS & SENSATIONS"
            
            cellSurveyInfo.lbl_Top.text = ""
            cellSurveyInfo.lbl_Center.text = ""
            cellSurveyInfo.lbl_Bottom.text = ""
            
            
            if self.DetailStrain.sensations!.count == 0{
                cellSurveyInfo.top_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                
            }else if self.DetailStrain.sensations!.count == 1{
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.sensations?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.sensations![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Center_View.constant = -800
                
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                cellSurveyInfo.Center_ViewHi.constant = 0
            }else if self.DetailStrain.sensations!.count == 2{
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.sensations?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.sensations![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
               
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.sensations?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.sensations![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
            }else if self.DetailStrain.sensations!.count > 2{
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.sensations?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.sensations![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.sensations?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.sensations![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                cellSurveyInfo.lbl_Bottom.text = self.DetailStrain.sensations?[2].name
                
                cellSurveyInfo.Bottom_View.constant = CGFloat((self.DetailStrain.sensations![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
            }
            
            break;
            
        default:
            cellSurveyInfo.imgView_Main.image = UIImage.init(named: "strain_negative_icon")
            cellSurveyInfo.lbl_Main.text = "NEGATIVE EFFECTS"
            
            cellSurveyInfo.lbl_Top.text = ""
            cellSurveyInfo.lbl_Center.text = ""
            cellSurveyInfo.lbl_Bottom.text = ""
            
            if self.DetailStrain.negative_effects!.count == 0{
                cellSurveyInfo.top_View.constant = -800
                cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                
            }else if self.DetailStrain.negative_effects!.count == 1 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.negative_effects?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.negative_effects![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Center_View.constant = -800
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
                cellSurveyInfo.Center_ViewHi.constant = 0
            }else if self.DetailStrain.negative_effects!.count == 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.negative_effects?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.negative_effects![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.negative_effects?[1].name
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.negative_effects![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.Bottom_View.constant = -800
                cellSurveyInfo.Bottom_ViewHi.constant = 0
            
            }else if self.DetailStrain.negative_effects!.count > 2 {
                cellSurveyInfo.lbl_Top.text = self.DetailStrain.negative_effects?[0].name
                
                cellSurveyInfo.top_View.constant = CGFloat((self.DetailStrain.negative_effects![0].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                cellSurveyInfo.lbl_Center.text = self.DetailStrain.negative_effects?[1].name
                
                
                cellSurveyInfo.Center_View.constant = CGFloat((self.DetailStrain.negative_effects![1].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
                
                
                cellSurveyInfo.lbl_Bottom.text = self.DetailStrain.negative_effects?[2].name
                cellSurveyInfo.Bottom_View.constant = CGFloat((self.DetailStrain.negative_effects![2].result!.doubleValue - 100) * Double(cellSurveyInfo.lbl_Top.frame.size.width/100))
            }
            break
        }
        cellSurveyInfo.selectionStyle = .none
        return cellSurveyInfo
    }

    
    func TellExperienceCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellExperience = tableView.dequeueReusableCell(withIdentifier: "StrainTellExperienceCell") as! StrainTellExperienceCell
        cellExperience.btn_Experience.addTarget(self, action: #selector(self.SurveyStart), for: .touchUpInside)
        
        cellExperience.selectionStyle = .none
        return cellExperience
    }
    
    func SurveyStart(sender : UIButton){
        self.surveyStartView.chooseStrain = self.DetailStrain
        self.view.addSubview(self.surveyStartView.view)
    }
    
    func TotalReviewCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellExperience = tableView.dequeueReusableCell(withIdentifier: "AddcommentCell") as! AddcommentCell
        self.ScrollToPOs = indexPath
        cellExperience.btn_AddComment.addTarget(self, action: #selector(self.addNewComment), for: .touchUpInside)

        cellExperience.btn_ShowComment.addTarget(self, action: #selector(self.ShowComment), for: .touchUpInside)

        
        if self.chooseStrain.get_review_count != nil {
            cellExperience.lblReviewCount.text = String(format:"%d", (self.chooseStrain.get_review_count!.intValue)) + " Reviews"
        }
        
        
        cellExperience.selectionStyle = .none
        return cellExperience
    }
    
    func ShowComment(sender : UIButton) {
        let viewReview = self.GetView(nameViewController: "StrainReviewViewController", nameStoryBoard: "SurveyStoryBoard") as! StrainReviewViewController
        viewReview.delegate = self
        viewReview.chooseStrain = self.chooseStrain
        viewReview.DetailStrain = self.DetailStrain
        self.navigationController?.pushViewController(viewReview, animated: true)
    }
    
    func addNewComment(sender : UIButton){
        let lastIndex = IndexPath(row: self.array_tble.count - 1, section: 0)
        self.tbleView_Strain.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    func CommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "Commentcell") as! Commentcell
        
        let indexData = self.array_tble[indexPath.row]
        let indexCount  = indexData["index"] as! Int
        
        cellCommentHeader.lbl_Name.text = self.DetailStrain.strain!.strainReview![indexCount].get_user!.first_name
        
        if(self.DetailStrain.strain!.strainReview![indexCount].attachment == nil){
            cellCommentHeader.attachmentViewHeight.constant = 0
        }else{
            cellCommentHeader.attachmentViewHeight.constant = 56
        }
        
        if(self.DetailStrain.strain!.strainReview![indexCount].is_reviewed_count == "0"){
            cellCommentHeader.reveiwLikeBtn.isSelected = false
            cellCommentHeader.reveiwLikeBtn.setImage(#imageLiteral(resourceName: "like_Up_White"), for: .normal)
        }else{
            cellCommentHeader.reveiwLikeBtn.isSelected = true
            cellCommentHeader.reveiwLikeBtn.setImage(#imageLiteral(resourceName: "like_Up_White").withRenderingMode(.alwaysTemplate), for: .selected)
            cellCommentHeader.reveiwLikeBtn.tintColor = UIColor.init(hex: "f4c42f")
        }
        cellCommentHeader.likesCount.text = String(self.DetailStrain.strain!.strainReview![indexCount].likes_count!)
        cellCommentHeader.reveiwLikeBtn.tag = indexCount
        cellCommentHeader.reveiwLikeBtn.addTarget(self, action: #selector(self.Likereview), for: .touchUpInside)
        if  self.DetailStrain.strain != nil {
            if  self.DetailStrain.strain!.strainReview != nil {
                if ((self.DetailStrain.strain!.strainReview![indexCount].get_user?.image_path) != nil) {
                    if((self.DetailStrain.strain!.strainReview![indexCount].get_user?.image_path?.contains("facebook.com"))! || (self.DetailStrain.strain!.strainReview![indexCount].get_user?.image_path?.contains("google.com"))!) || (self.DetailStrain.strain!.strainReview![indexCount].get_user?.image_path?.contains("googleusercontent.com"))!{
                        cellCommentHeader.ImgView_User.moa.url = self.DetailStrain.strain!.strainReview![indexCount].get_user!.image_path!.RemoveSpace()
                    }else {
                        cellCommentHeader.ImgView_User.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![indexCount].get_user!.image_path!.RemoveSpace()
                    }
                    
                }else {
                    if let url = self.DetailStrain.strain!.strainReview![indexCount].get_user!.avatar{
                    cellCommentHeader.ImgView_User.moa.url = WebServiceName.images_baseurl.rawValue + url.RemoveSpace()
                    }
                }
            }
        }
        if (self.DetailStrain.strain!.strainReview![indexCount].get_user!.special_icon?.characters.count)! > 6 {
            cellCommentHeader.ImgView_UserTop.isHidden = false
            cellCommentHeader.ImgView_UserTop.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![indexCount].get_user!.special_icon!.RemoveSpace()
        }else {
            cellCommentHeader.ImgView_UserTop.isHidden = true
        }
        
        cellCommentHeader.lbl_Message.applyTag(baseVC: self , mainText: self.DetailStrain.strain!.strainReview![indexCount].review!)
        cellCommentHeader.lbl_Message.text = self.DetailStrain.strain!.strainReview![indexCount].review
        if self.DetailStrain.strain!.strainReview![indexCount].rating != nil {
            cellCommentHeader.Lbl_Rating.text =  "\(self.DetailStrain.strain!.strainReview![indexCount].rating?.intValue ?? 1)"
        }else {
            cellCommentHeader.Lbl_Rating.text = "1"
        }
        
        cellCommentHeader.Lbl_Time.text = self.getDateWithTh(date: self.DetailStrain.strain!.strainReview![indexCount].created_at!)// self.DetailStrain.strain!.strainReview![indexCount].created_at?.UTCToLocal(inputFormate: Constants.defaultDateFormate, outputFormate: "dd MMM yyyy")
        if Double(cellCommentHeader.Lbl_Rating.text!)! < 1.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain1B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 2.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain1B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 3.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain2B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 4.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain3B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 5.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain4B")
        }else {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain5B")
        }
        
        cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "QAReport")
        cellCommentHeader.lbl_title_report.textColor = UIColor.init(hex: "7D7D7D")
        if self.DetailStrain.strain!.strainReview![indexCount].is_user_flaged_count != nil {
            if self.DetailStrain.strain!.strainReview![indexCount].is_user_flaged_count == 1 {
                 cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                 cellCommentHeader.ImgView_Flag.tintColor = UIColor.init(hex: "F4B927")
                 cellCommentHeader.lbl_title_report.textColor = UIColor.init(hex: "F4B927")
            }
        }
        var iD = Int((DataManager.sharedInstance.user?.ID)!)
        if self.DetailStrain.strain!.strainReview![indexCount].get_user?.id?.intValue == iD{
            cellCommentHeader.commentDeleteView.isHidden = false
            cellCommentHeader.commentEditView.isHidden = false
            cellCommentHeader.flagView.isHidden = true
            cellCommentHeader.flagViewWidth.constant = 0
            cellCommentHeader.commentDeleteViewWidth.constant = 30
            cellCommentHeader.commentEditViewWidth.constant = 30
        }else{
            cellCommentHeader.commentDeleteView.isHidden = true
            cellCommentHeader.commentEditView.isHidden = true
            cellCommentHeader.flagView.isHidden = false
            cellCommentHeader.flagViewWidth.constant = 108
            cellCommentHeader.commentDeleteViewWidth.constant = 0
            cellCommentHeader.commentEditViewWidth.constant = 0
        }
        
        cellCommentHeader.commentEditButton.tag = indexCount
        cellCommentHeader.commentEditButton.addTarget(self, action: #selector(self.editAction), for: .touchUpInside)
        cellCommentHeader.commentDeleteButton.tag = indexCount
        cellCommentHeader.commentDeleteButton.addTarget(self, action: #selector(self.deleteAction), for: .touchUpInside)
        cellCommentHeader.Btn_Flag.addTarget(self, action: #selector(self.CommentFlag), for: .touchUpInside)
        cellCommentHeader.Btn_Flag.tag = indexCount
        cellCommentHeader.Btn_share.addTarget(self, action: #selector(self.ShareActionRewiew), for: .touchUpInside)
        
        cellCommentHeader.Btn_UserProfile.addTarget(self, action: #selector(self.USerProfile), for: .touchUpInside)
        
        cellCommentHeader.Btn_share.tag = indexCount
        cellCommentHeader.Btn_Attachment.tag = indexCount
        cellCommentHeader.Btn_UserProfile.tag = indexCount
        
        cellCommentHeader.view_Attachment.isHidden = true
        cellCommentHeader.ImgView_Video.isHidden = true
        
        if self.DetailStrain.strain!.strainReview![indexCount].attachment != nil {
            if self.DetailStrain.strain!.strainReview![indexCount].attachment!.id!.intValue > 0 {
                cellCommentHeader.view_Attachment.isHidden = false
                if self.DetailStrain.strain!.strainReview![indexCount].attachment!.type == "video" {
                    if let vall = self.DetailStrain.strain!.strainReview![indexCount].attachment!.poster {
                        cellCommentHeader.ImgView_Attachment.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![indexCount].attachment!.poster!.RemoveSpace()
                    }
                    cellCommentHeader.ImgView_Video.image = #imageLiteral(resourceName: "Video_play_icon_White")
                    cellCommentHeader.ImgView_Video.isHidden = false
                }else {
                    cellCommentHeader.ImgView_Attachment.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![indexCount].attachment!.attachment!.RemoveSpace()
                     cellCommentHeader.ImgView_Video.image =  #imageLiteral(resourceName: "Gallery_White")
                }
               cellCommentHeader.Btn_Attachment.addTarget(self, action: #selector(self.OpenAttachment), for: .touchUpInside)
            }
        }
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    
    func USerProfile(sender : UIButton){
      self.OpenProfileVC(id: "\(self.DetailStrain.strain!.strainReview![sender.tag].get_user!.id!.intValue)")
    }
    func Likereview(sender : UIButton){
        var test = self.DetailStrain.strain!.strainReview![sender.tag]
        var param = [String : Any] ()
        if(test.is_reviewed_count == "0"){
            //TODO FOR LIKE
            self.DetailStrain.strain!.strainReview![sender.tag].is_reviewed_count = "1"
            self.DetailStrain.strain!.strainReview![sender.tag].likes_count = self.DetailStrain.strain!.strainReview![sender.tag].likes_count! + 1
            param["like_val"] = "1" as AnyObject
        }else {
            self.DetailStrain.strain!.strainReview![sender.tag].is_reviewed_count = "0"
            self.DetailStrain.strain!.strainReview![sender.tag].likes_count = self.DetailStrain.strain!.strainReview![sender.tag].likes_count! - 1
            param["like_val"] = "0" as AnyObject
            //TODO FOR DISLIKE
        }
        param["review_id"] = test.id as AnyObject
        param["strain_id"] = test.strain_id as AnyObject
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: "add_strain_review_like", params: param as [String:AnyObject]) { (success, message, response) in
            self.hideLoading()
            print(success)
            
              print(message)
              print(response)
            if(success){
                self.ReloadData()
            }
        }
    }
//
    func OpenAttachment(sender : UIButton){
        
        if self.DetailStrain.strain!.strainReview![sender.tag].attachment!.id!.intValue > 0 {
            if self.DetailStrain.strain!.strainReview![sender.tag].attachment?.type == "video" {
                let video_path =  WebServiceName.videos_baseurl.rawValue + (self.DetailStrain.strain!.strainReview![sender.tag].attachment?.attachment)!
                let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else {
                let image_path =  self.DetailStrain.strain!.strainReview![sender.tag].attachment?.attachment
                self.showImagess(attachments: [image_path!])
                
                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
//                vc.urlMain = image_path
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
//    func PreviewAttachments(index : Int , attachmnet_no : Int) {
//    }
    
    func CommentFlag(sender : UIButton){
        if (self.DetailStrain.strain!.strainReview![sender.tag].get_user?.id?.intValue)! != Int((DataManager.sharedInstance.user?.ID)!) {
            if self.DetailStrain.strain!.strainReview![sender.tag].is_user_flaged_count != nil {
                if self.DetailStrain.strain!.strainReview![sender.tag].is_user_flaged_count == 1 {
                   self.ShowErrorAlert(message: "Review already reported!")
                    return
                }
            }
            self.questionID = String((self.DetailStrain.strain!.strainReview![sender.tag].id?.intValue)!)
            self.ShowFilterView(sender: UIButton.init())
            
        }else {
            self.ShowErrorAlert(message: "You can't report your own review!")
        }
    }
    
    func CommentAddCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentAdd = tableView.dequeueReusableCell(withIdentifier: "TypeCommectStrainCell") as! TypeCommectStrainCell
        cellCommentAdd.txtViewMain.tag = indexPath.row
        cellCommentAdd.txtViewMain.delegate = self as? UITextViewDelegate
        if editIndex != -1{
            cellCommentAdd.txtViewMain.text = self.DetailStrain.strain?.strainReview![editIndex].review
        }
            if self.txtCommentText != "" {
                cellCommentAdd.txtViewMain.text = self.txtCommentText
            }
        cellCommentAdd.selectionStyle = .none
        return cellCommentAdd
    }
    
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == typeComment {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = typeComment
        }else{
         self.txtCommentText = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(textView.text.characters.count)
        self.txtCommentText = textView.text
        var cell: TypeCommectStrainCell!
        let index = IndexPath.init(row: textView.tag, section: 0)
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        if self.editIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. 500 Characters"
            }else{
                cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }else{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. 500 Characters"
            }else{
                cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text =  "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }
        var textTemp = textView.text.count + text.count
        if textTemp > 499 {
            return false
        }
        return true
    }
    
    func AddImageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "AddImageStrainCell") as! AddImageStrainCell
        
        cellAddImage.btnUploadNew.addTarget(self, action: #selector(self.addImage), for: .touchUpInside)
        cellAddImage.selectionStyle = .none
        return cellAddImage
    }
    
    func addImage(sender : UIButton){
         self.isAddStrainGalleryImg = false
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        self.array_Attachment.removeAll()
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        if editIndex != -1{
            self.editAttachment = newAttachment
            self.editTableLoad()
        }else{
        self.array_Attachment.append(newAttachment)
        self.ReloadData()
        }
        ischooseGallery = false
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        if self.isAddStrainGalleryImg {
            self.UploadImageOnGallery(image: image,gif_url:gifURL)
        }else{
            self.array_Attachment.removeAll()
            let newAttachment = Attachment()
            newAttachment.is_Video = false
            newAttachment.image_Attachment = image
            newAttachment.video_URL = gifURL.absoluteString
            newAttachment.ID = "-1"
            if editIndex != -1{
                self.editAttachment = newAttachment
                self.editTableLoad()
            }else{
                self.array_Attachment.append(newAttachment)
                self.ReloadData()
            }
        }
        ischooseGallery = false
        self.disableMenu()
    }
    func captured(image: UIImage) {
        if self.isAddStrainGalleryImg {
             self.UploadImageOnGallery(image: image)
        }else{
            self.array_Attachment.removeAll()
            let newAttachment = Attachment()
            newAttachment.is_Video = false
            newAttachment.image_Attachment = image
            newAttachment.ID = "-1"
            if editIndex != -1{
                self.editAttachment = newAttachment
                self.editTableLoad()
            }else{
                self.array_Attachment.append(newAttachment)
                self.ReloadData()
            }
        } 
        ischooseGallery = false
        self.disableMenu()
    }
    
    func UploadImageOnGallery(image: UIImage,gif_url:URL? = nil){
        self.showLoading()
        var newPAram = [String : AnyObject]()
        newPAram["strain_id"] = self.chooseStrain.strainID?.stringValue as AnyObject
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.upload_strain_image.rawValue, image: image,gif_url:gif_url, withParams: newPAram, onView: self) { (MainData) in
            print(MainData)
            self.hideLoading()
            self.ShowSuccessAlertWithNoAction(message: "Thanks bud! Your image has been submitted for approval.")
//            if MainData["status"] as! String == "success" {
//                let newImage = StrainImage()
//                let dataMain = MainData["successData"] as! [String : AnyObject]
//                newImage.id = dataMain["id"] as? NSNumber
//                newImage.image_path = dataMain["image_path"] as? String
//                newImage.liked = 0
//                newImage.disliked = 0
//                newImage.dis_like_count = [LikeDislikeCount]()
//                newImage.like_count = [LikeDislikeCount]()
//                newImage.Image_like_count = "0"
//                newImage.Image_Dilike_count = "0"
//                newImage.created_at = dataMain["created_at"] as! String
//                var map = [String: AnyObject]()
//
//                map["id"] = NSNumber(value:Int((DataManager.sharedInstance.user?.ID)!)!)
//                map["first_name"] = DataManager.sharedInstance.user?.userFirstName as AnyObject
//                map["image_path"] = DataManager.sharedInstance.user?.profileImage
//
//                map["avatar"] = DataManager.sharedInstance.user?.avatarImage as AnyObject
//                map["points"] = NSNumber(value:Int((DataManager.sharedInstance.user?.Points)!)!)
//                newImage.user = StrainUser(JSON: map)
//                let pot = Int((DataManager.sharedInstance.user?.Points)!)
//                newImage.user!.points =  NSNumber(value:pot!)
//                newImage.user!.first_name = DataManager.sharedInstance.user?.userFirstName
//                self.chooseStrain.images?.append(newImage)
//                self.DetailStrain.images?.append(newImage)
//            }
        }
    }
    
    func MediaChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "ShoeMediaCell") as! ShoeMediaCell
        
        var mianAttachment = Attachment()
        if tableView == editTableView{
        mianAttachment = self.editAttachment
        }else{
        mianAttachment = self.array_Attachment[0]
        }
        if editIndex != -1 && editAttachment.image_URL != ""{
         cellMedia.imgViewImage.moa.url = WebServiceName.images_baseurl.rawValue + editAttachment.image_URL
        }else{
        cellMedia.imgViewImage.image = mianAttachment.image_Attachment
        }
        cellMedia.imgViewVideo.isHidden = true
        if mianAttachment.is_Video {
            cellMedia.imgViewVideo.isHidden = false
        }
        self.deleteImageReview = 0
        cellMedia.btnDelete.tag = 0
        cellMedia.btnDelete.addTarget(self, action: #selector(self.DeleteImageAction), for: .touchUpInside)

        
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    func DeleteImageAction(sender : UIButton){
        if editIndex == -1{
            self.array_Attachment.remove(at: sender.tag)
            self.ReloadData()
        }else{
            self.deleteImageReview  = 1
            self.editAttachment = Attachment()
            self.array_Attachment.removeAll()
            
            self.editTableLoad()
        }
    }
    
    
    func AddStrainRatingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "StrainRatingcell") as! StrainRatingcell
        if editIndex != -1{
            cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star5.image = #imageLiteral(resourceName: "Strain0B")
            let rating = self.DetailStrain.strain?.strainReview![editIndex].rating?.doubleValue
            ratingCount  = Int(rating!)
            if rating == 1 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
            }else if rating == 2 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
            }else if rating == 3 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
            }else if rating == 4 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
            }else if rating == 5 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                cellMedia.imgview_Star5.image = #imageLiteral(resourceName: "Strain5B")
            }
        }
        cellMedia.btn_Star1.tag = 1
        cellMedia.btn_Star2.tag = 2
        cellMedia.btn_Star3.tag = 3
        cellMedia.btn_Star4.tag = 4
        cellMedia.btn_Star5.tag = 5
        cellMedia.btn_Star1.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star2.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star3.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star4.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star5.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    func RateImageTap(sender : UIButton){
        var tableSubviews: [UIView]
        if editIndex != -1{
           tableSubviews =  self.editTableView.subviews
        }else{
        tableSubviews =       self.tbleView_Strain.subviews
        }
        self.ratingCount = sender.tag
        
        for indexObj in tableSubviews{
            if let cellMain = indexObj as? StrainRatingcell {
                
                cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star5.image = #imageLiteral(resourceName: "Strain0B")
                
                
                if sender.tag == 1 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                }else if sender.tag == 2 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                }else if sender.tag == 3 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                }else if sender.tag == 4 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                    cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                }else {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                    cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                    cellMain.imgview_Star5.image = #imageLiteral(resourceName: "Strain5B")
                }
            }
        }
    }
    
    func SubmitStrainComment(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "SubmitcommentStrainCell") as! SubmitcommentStrainCell
        cellMedia.btnSubmit.addTarget(self, action: #selector(self.submitAction), for: .touchUpInside)
        if editIndex != -1{
            cellMedia.btnSubmit.setTitle("UPDATE COMMENT", for: .normal)
        }else {
            cellMedia.btnSubmit.setTitle("SUBMIT COMMENT", for: .normal)
        }
        
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    func submitAction(sender : UIButton){
        var textviewText = ""
        self.txtCommentText = ""
        var findRow = -1
        
        for index in 0..<self.array_tble.count {
            var cellMain: UITableViewCell!
            if editIndex != -1{
             cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
            }else{
             cellMain  = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: index, section: 0))
            }
            if cellMain is TypeCommectStrainCell {
                findRow = index
                let cellNew = cellMain as! TypeCommectStrainCell
                textviewText = cellNew.txtViewMain.text!
            }
        }
                
        if textviewText == "Type your comment here" {
            self.ShowErrorAlert(message: "Enter comment!")
            return
        }
        if textviewText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            self.ShowErrorAlert(message: "Enter comment!")
            return
        }
        
        
        var newPAram = [String : AnyObject]()
        newPAram["strain_id"] = String(self.chooseStrain.strainID!.intValue) as AnyObject
        newPAram["review"] = textviewText as AnyObject
        newPAram["rating"] = String(ratingCount) as AnyObject
        if editIndex != -1{
            var reviewID = self.DetailStrain.strain?.strainReview![editIndex].id!.intValue
            newPAram["strain_review_id"] = String(reviewID!) as AnyObject
            if deleteImageReview == 1{
                newPAram["delete_attachment"] = deleteImageReview as AnyObject
            }
        }
        
        if editIndex != -1 && editAttachment.ID == "-1" && editAttachment.image_URL == "" {
            self.array_Attachment.removeAll()
            self.array_Attachment.append(editAttachment)
        }
        if self.array_Attachment.count == 0 {
            self.showLoading()
            print(newPAram)
            NetworkManager.PostCall(UrlAPI: WebServiceName.add_strain_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
                self.hideLoading()
                print(DataResponse)
                if successResponse {
                    if (DataResponse["status"] as! String) == "success" {
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex != -1{
                        cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                        cellMain  = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                         }
                        
                        cellMain.txtViewMain.text = ""
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        self.array_Attachment.removeAll()
                        self.GetDetailAPI()
                        self.ratingCount = 5
                    }else {
                        if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            })
        }else {
            if self.array_Attachment[0].is_Video {
                self.showLoading()
                print(newPAram)
                NetworkManager.UploadVideo( WebServiceName.add_strain_review.rawValue, imageMain: self.array_Attachment[0].image_Attachment, urlVideo: (URL.init(string: self.array_Attachment[0].video_URL)!), withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    print(MainData)
                    if (MainData["status"] as! String) == "success" {
                        
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex != -1{
                            cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                            cellMain  = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }
                        self.array_Attachment.removeAll()
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        
                        cellMain.txtViewMain.text = ""
                        
                        
                        self.GetDetailAPI()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                })
            }else {
                self.showLoading()
                print(newPAram)
                var gifDataUrl : URL? = nil
                if let gif_url = URL.init(string: (self.array_Attachment[0].video_URL)){
                    gifDataUrl = gif_url
                }
                NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_strain_review.rawValue, image: self.array_Attachment[0].image_Attachment,gif_url:gifDataUrl, withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    print(MainData)
                    
                    if (MainData["status"] as! String) == "success" {
                        
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex != -1{
                            cellMain = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                            cellMain = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }
                        self.array_Attachment.removeAll()
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        
                        cellMain.txtViewMain.text = ""
                        
                            self.GetDetailAPI()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                    
                })
            }
        }
        
    }
    
    func locateBudCurrentLocationAction() {
        if (DataManager.sharedInstance.user_locaiton?.latitude) == nil {
            self.ShowErrorAlert(message: "Unable to find location in your device!")
        }else{
            self.getAddressFromLatLon(pdblLatitude: (DataManager.sharedInstance.user_locaiton?.latitude)!,
                                      withLongitude: (DataManager.sharedInstance.user_locaiton?.longitude)! )
        }
    }
    func gotoProfUser() {
        self.OpenProfileVC(id:  (DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)
    }
    func LocateThisBudMainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "StrainLocationCell") as! StrainLocationCell
        var path = ""
        cellMedia.btnUser.addTarget(self, action: #selector(gotoProfUser), for: .touchUpInside)
        if (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL.contains("facebook.com"))! || (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL.contains("google.com"))! || (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL.contains("https"))! || (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL.contains("http"))!{
            path =  (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL)!
        }else{
            path = WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.getPermanentlySavedUser()?.profilePictureURL)!
        }
        cellMedia.userImg.sd_setImage(with: URL.init(string: path), completed: nil)
        if (DataManager.sharedInstance.getPermanentlySavedUser()?.special_icon.count)! > 6 {
          cellMedia.userImgCell.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.getPermanentlySavedUser()?.special_icon.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            
             cellMedia.userImgCell.sd_setImage(with: linked, completed: nil)
        }else {
             cellMedia.userImgCell.isHidden = true
        }
       
        if isCurrentLocation{
              cellMedia.lblZipCode.text = current_zipcode
              cellMedia.lblAddress.text = current_address
        }else{
             cellMedia.lblZipCode.text = DataManager.sharedInstance.user?.zipcode
             cellMedia.lblAddress.text = DataManager.sharedInstance.user?.address
        }
       
        cellMedia.btnCurrentLocation.addTarget(self, action: #selector(locateBudCurrentLocationAction), for: .touchUpInside)
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    
    func NEarStrainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellNearStrain = tableView.dequeueReusableCell(withIdentifier: "NearStrainCell") as! NearStrainCell
        if(self.textToSet.count > 0){
            cellNearStrain.hideGreenView.isHidden = true
            cellNearStrain.topText.text = self.textToSet
            cellNearStrain._15MilesText.text = ""
            cellNearStrain.ofyourlocationText.text = ""
            cellNearStrain.withText.text = ""
        }else {
            cellNearStrain.hideGreenView.isHidden = false
        }
        cellNearStrain.selectionStyle = .none
        return cellNearStrain
    }
    
    func EmptyBlankCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellNearStrain = tableView.dequeueReusableCell(withIdentifier: "EmptyBlankCell") as! EmptyBlankCell
        cellNearStrain.selectionStyle = .none
        cellNearStrain.imageButton.addTarget(self, action: #selector(self.AddNewInfo(sender:)), for: .touchUpInside)
        return cellNearStrain
    }
    func StrainBud(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrainBud = tableView.dequeueReusableCell(withIdentifier: "StrainBudCell") as! StrainBudCell
        
        let mainBud = self.array_tble[indexPath.row]
        let index = mainBud["index"] as! Int
        cellStrainBud.lblCBD.text = self.productArray[index].cbd + "% CBD | "
        cellStrainBud.lblName.text = self.productArray[index].name
        cellStrainBud.lblTHC.text = self.productArray[index].thc + "% THC"
        
        print("Title ===> " + self.productArray[index].budzMap.title)
        print(self.productArray[index].priceArray.count)
        if self.productArray[index].images.count > 0 {
            cellStrainBud.imgViewMain.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.productArray[index].images.first!.image)!)
                //.moa.url = WebServiceName.images_baseurl.rawValue +  self.productArray[index].images.first!.image
//            print(WebServiceName.images_baseurl.rawValue +  self.productArray[index].images.first!.image)
        }
        if self.productArray[index].images.count > 0{
        cellStrainBud.lblCount.isHidden = false
        cellStrainBud.imageCountView.isHidden = false
        }else{
            cellStrainBud.lblCount.isHidden = true
            cellStrainBud.imageCountView.isHidden = true
        }
        cellStrainBud.lblCount.text = "\((self.productArray[index].images.count))"
        cellStrainBud.lblType.text = self.productArray[index].straintype?.title
        cellStrainBud.lblDistance.text = self.productArray[index].distance.round2digit() + " mi"
        
        
        cellStrainBud.btnShare.tag = index
        cellStrainBud.btnShare.addTarget(self, action: #selector(self.ShareActionProduct), for: .touchUpInside)
        
        cellStrainBud.btn_img.tag = index
        cellStrainBud.btn_img.addTarget(self, action: #selector(self.onClickShowImages(sender:)), for: .touchUpInside)
        
        cellStrainBud.viewFirst.isHidden = true
        cellStrainBud.viewSecond.isHidden = true
        cellStrainBud.viewThird.isHidden = true
        cellStrainBud.viewFourth.isHidden = true

        
        
        
        if self.productArray[index].priceArray.count > 0 {
            cellStrainBud.viewFirst.isHidden = false
            cellStrainBud.lblPrice_1.text = "$" + self.productArray[index].priceArray[0].price
            cellStrainBud.lblWeight_1.text = self.productArray[index].priceArray[0].weight
        }
        
        if self.productArray[index].priceArray.count > 1 {
            cellStrainBud.viewSecond.isHidden = false
            cellStrainBud.lblPrice_2.text = "$" +  self.productArray[index].priceArray[1].price
            cellStrainBud.lblWeight_2.text = self.productArray[index].priceArray[1].weight
        }
        
        if self.productArray[index].priceArray.count > 2 {
            cellStrainBud.viewThird.isHidden = false
            cellStrainBud.lblPrice_3.text = "$" +  self.productArray[index].priceArray[2].price
            cellStrainBud.lblWeight_3.text = self.productArray[index].priceArray[2].weight
        }
        
        if self.productArray[index].priceArray.count > 3 {
            cellStrainBud.viewFourth.isHidden = false
            cellStrainBud.lblPrice_4.text = "$" +  self.productArray[index].priceArray[3].price
            cellStrainBud.lblWeight_4.text = self.productArray[index].priceArray[3].weight
        }
        
        
        
        cellStrainBud.selectionStyle = .none
        return cellStrainBud
    }
    
    
    func ShareAction(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.chooseStrain.strainID ?? 0)"
        parmas["type"] = "Strain"
        let link : String = Constants.ShareLinkConstant + "strain-details/\((self.chooseStrain.strainID!.intValue))"
        self.OpenShare(params:parmas,link: link, content:self.chooseStrain.title!)
    }
    func ShareActionProduct(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.productArray[sender.tag].strain_id)"
        parmas["type"] = "Strain"//\(self.productArray[sender.tag].strain_id)" + "/" + "
        let link : String = Constants.ShareLinkConstant + "strain-details/\((self.chooseStrain.strainID!.intValue))"
        self.OpenShare(params:parmas,link: link, content:self.chooseStrain.title!)
    }
    func ShareActionRewiew(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.DetailStrain.strain!.strainReview![sender.tag].id?.intValue)"
        parmas["type"] = "Strain"//\(self.DetailStrain.strain!.strainReview![sender.tag].id!.intValue)" + "/" + "
        let link : String = Constants.ShareLinkConstant + "strain-details/\((self.chooseStrain.strainID!.intValue))"
        self.OpenShare(params:parmas,link: link, content:self.chooseStrain.title!)
    }

    
    func MoreStrainInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMoreInfo = tableView.dequeueReusableCell(withIdentifier: "AddMoreStrinInfoCell") as! AddMoreStrinInfoCell
        
        cellMoreInfo.btn_AddMoreInfo.addTarget(self, action: #selector(self.AddNewInfo), for: UIControlEvents.touchUpInside)
        cellMoreInfo.selectionStyle = .none
        return cellMoreInfo
    }
    
    
    func ShowDescriptionStrain(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "FullDescriptionStrainCEll") as! FullDescriptionStrainCEll
        if self.choose_StrainUSers.count > 0 {
            if self.choose_StrainUSers.first?.description!.trimmingCharacters(in: .whitespaces) == ""{
                cellStrain.lblDescription.text = "No description added."
            }else{
                cellStrain.lblDescription.text = self.choose_StrainUSers.first?.description?.RemoveBRTag()
                cellStrain.lblDescription.text = cellStrain.lblDescription.text?.RemoveHTMLTag()
            }
        }else {
            if let discription = self.chooseStrain.overview?.RemoveHTMLTag().trimmingCharacters(in: .whitespaces), discription != "" {
                 cellStrain.lblDescription.applyTag(baseVC: self , mainText: discription)
                cellStrain.lblDescription.text = discription
                cellStrain.lblDescription.text = cellStrain.lblDescription.text?.RemoveHTMLTag()
            }else{
                cellStrain.lblDescription.applyTag(baseVC: self , mainText: "No description added.")
                cellStrain.lblDescription.text = "No description added."
            }
            if self.array_StrainUSers.count > 0 &&  (self.array_StrainUSers.first?.get_likes_count?.intValue)! > 4 {
                if self.array_StrainUSers.first?.description!.trimmingCharacters(in: .whitespaces) == ""{
                    cellStrain.lblDescription.text = "No description added."
                }else{
                    cellStrain.lblDescription.text = self.array_StrainUSers.first?.description?.RemoveBRTag()
                    cellStrain.lblDescription.text = cellStrain.lblDescription.text?.RemoveHTMLTag()
                }
            }
        }
        if self.choose_StrainUSers.count > 0 {
            cellStrain.btnScrollDown.isHidden = true
             cellStrain.lblReward.isHidden = true
            cellStrain.lbRewardImage.isHidden = true
            cellStrain.lblReward.text  = String(describing:(self.choose_StrainUSers[0].get_likes_count?.intValue)!)
        } else{
            if self.array_StrainUSers.count > 0 &&  (self.array_StrainUSers.first?.get_likes_count?.intValue)! > 4 {
                cellStrain.lbRewardImage.isHidden = false
                cellStrain.btnScrollDown.isHidden = false
                cellStrain.lblReward.isHidden = false
            }else {
                cellStrain.lbRewardImage.isHidden = true
                cellStrain.btnScrollDown.isHidden = true
                cellStrain.lblReward.isHidden = true
            }
            cellStrain.btnScrollDown.addTarget(self, action: #selector(self.scrollDown), for: UIControlEvents.touchUpInside)
            if let point = self.array_StrainUSers.first?.get_likes_count?.intValue {
                cellStrain.lblReward.text = "\(point)"
            }else{
                cellStrain.lblReward.text = "\(0)"
            }
        }
       
        
        cellStrain.selectionStyle = .none
        return cellStrain
    }
    
    
    
    func StrainTypeshow(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "StrainTypeShowCell") as! StrainTypeShowCell
        cellStrain.btn_Type.addTarget(self, action: #selector(self.StrainTypeInfo), for: UIControlEvents.touchUpInside)
        cellStrain.btn_BottomLeft.addTarget(self, action: #selector(self.StrainTypeBottomLeft), for: UIControlEvents.touchUpInside)
        cellStrain.btn_BottomRight.addTarget(self, action: #selector(self.StrainTypeBottomRight), for: UIControlEvents.touchUpInside)
        print(self.choose_StrainUSers.count)
        
        if self.choose_StrainUSers.count > 0 {
            print(self.choose_StrainUSers.first?.indica)
            if self.choose_StrainUSers.first!.indica?.intValue == 100 {
                cellStrain.lbl_hybrid_type.text = "Indica"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "AE59C2")
                
            }else if self.choose_StrainUSers.first!.indica?.intValue == 0{
                cellStrain.lbl_hybrid_type.text = "Sativa"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "C24462")
            }else{
                cellStrain.lbl_hybrid_type.text = "Hybrid"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "7cc244")
            }
            if self.choose_StrainUSers.first!.indica?.intValue == 100 {
                cellStrain.ValueChange(senderValue: Float(0))
            } else{
                cellStrain.ValueChange(senderValue: Float(100 - (self.choose_StrainUSers.first!.indica?.intValue)!))
            }
        }else if self.array_StrainUSers.count > 0 {
            cellStrain.imageViewForThumb?.image = nil
            print(self.array_StrainUSers.first?.indica! as Any ?? 0)
            if self.array_StrainUSers.first!.indica?.intValue == 100 {
                cellStrain.lbl_hybrid_type.text = "Indica"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "AE59C2")
            }else if self.array_StrainUSers.first!.indica?.intValue == 0{
                cellStrain.lbl_hybrid_type.text = "Sativa"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "C24462")
            }else{
                cellStrain.lbl_hybrid_type.text = "Hybrid"
                cellStrain.lbl_hybrid_type.textColor = UIColor.init(hex: "7cc244")
            }
            if self.array_StrainUSers.first!.indica?.intValue == 100 {
                cellStrain.ValueChange(senderValue: Float(0))
            } else{
                cellStrain.ValueChange(senderValue: Float(100 - (self.array_StrainUSers.first!.indica?.intValue)!))
            }
        }else {
            cellStrain.ValueChange(senderValue: 0.0)
            cellStrain.Lbl_leftPercentage.text = "0 %"
            cellStrain.Lbl_rightPercentage.text =   "0 %"
        }
        
        
       
        cellStrain.selectionStyle = .none
        return cellStrain
    }
    
    func BreedShowCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "StrainBreedCell") as! StrainBreedCell
        var strainUsers = [UserStrain]()
        if self.choose_StrainUSers.count > 0 {
            strainUsers = self.choose_StrainUSers
        }
        else{
            strainUsers = self.array_StrainUSers
        }
        
        if let cross_breed = strainUsers.first?.cross_breed{
            if cross_breed.contains(","){
                cellStrain.lblFirstName.text =  strainUsers.first?.cross_breed?.components(separatedBy: ",").first
                self.firstStrainName = cellStrain.lblFirstName.text!
                cellStrain.buttonFirstName.tag = 1
                cellStrain.buttonFirstName.addTarget(self, action: #selector(self.LeftButtonAction), for: UIControlEvents.touchUpInside)
                cellStrain.lblSecondName.text  = strainUsers.first?.cross_breed?.components(separatedBy: ",").last
                self.secondStrainName = cellStrain.lblSecondName.text!
                cellStrain.buttonSecondName.tag = 2
                cellStrain.buttonSecondName.addTarget(self, action: #selector(self.LeftButtonAction), for: UIControlEvents.touchUpInside)
            }else{
                cellStrain.lblFirstName.text = cross_breed
                 cellStrain.lblSecondName.text  = ""
                self.firstStrainName = cross_breed
                cellStrain.buttonFirstName.tag = 1
                cellStrain.buttonFirstName.addTarget(self, action: #selector(self.LeftButtonAction), for: UIControlEvents.touchUpInside)
            }
        }else{
            self.firstStrainName = ""
            self.secondStrainName = ""
            cellStrain.lblFirstName.text  = ""
            cellStrain.lblSecondName.text  = ""
        }
        
        
        cellStrain.selectionStyle = .none
        return cellStrain
    }
    
    func AddChemistryCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "chemistryShowCell") as! ChemistryshowCell
        if self.choose_StrainUSers.count > 0{
            if let percent = self.array_StrainUSers.first!.minCBD?.stringValue {
                 if percent.contains(".") {
                cellStrain.minCBD.text = (percent) + "%"
                 }else {
                      cellStrain.minCBD.text = (percent) + ".0%"
                }
            }else{
                cellStrain.minCBD.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.maxCBD?.stringValue {
                  if percent.contains(".") {
                cellStrain.maxCBD.text = (percent) + "%"
                  }else {
                     cellStrain.maxCBD.text = (percent) + ".0%"
                }
            }else{
                cellStrain.maxCBD.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.minTHC?.stringValue {
                if percent.contains(".") {
                    cellStrain.minTHC.text = (percent) + "%"
                    
                }else {
                    cellStrain.minTHC.text = (percent) + ".0%"
                    
                }
            }else{
                cellStrain.minTHC.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.maxTHC?.stringValue {
                if percent.contains(".") {
                cellStrain.maxTHC.text = (percent) + "%"
                }else {
                    cellStrain.maxTHC.text = (percent) + ".0%"
                }
            }else{
                cellStrain.maxTHC.text = "0.0%"
            }
        }else{
            if let percent = self.array_StrainUSers.first!.minCBD?.stringValue {
                 if percent.contains(".") {
                 cellStrain.minCBD.text = (percent) + "%"
                 }else {
                     cellStrain.minCBD.text = (percent) + ".0%"
                }
            }else{
                 cellStrain.minCBD.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.maxCBD?.stringValue {
                if percent.contains(".") {
                cellStrain.maxCBD.text = (percent) + "%"
                }else {
                     cellStrain.maxCBD.text = (percent) + ".0%"
                }
            }else{
                cellStrain.maxCBD.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.minTHC?.stringValue {
                 if percent.contains(".") {
                cellStrain.minTHC.text = (percent) + "%"
                 }else {
                     cellStrain.minTHC.text = (percent) + ".0%"
                }
            }else{
                cellStrain.minTHC.text = "0.0%"
            }
            
            if let percent = self.array_StrainUSers.first!.maxTHC?.stringValue {
                 if percent.contains(".") {
                cellStrain.maxTHC.text = (percent) + "%"
                 }else {
                    cellStrain.maxTHC.text = (percent) + ".0%"
                }
            }else{
                cellStrain.maxTHC.text = "0.0%"
            }
        }
        cellStrain.selectionStyle = .none
        return cellStrain
    }
    
    
    func CareShowCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "StrainCareShowCell") as! StrainCareShowCell
        
        
        if self.choose_StrainUSers.count > 0 {
            if self.choose_StrainUSers.first!.note != nil{
            cellStrain.lbl_Note.text = self.choose_StrainUSers.first!.note
            }else{
                cellStrain.lbl_Note.text = "No notes added."
            }
            
            cellStrain.lbl_DifficultyLevel.text = self.choose_StrainUSers.first!.growing?.capitalizingFirstLetter()
            cellStrain.lbl_MatureHeight.text = (self.choose_StrainUSers.first!.plant_height?.stringValue)! + "\""
            cellStrain.lbl_Time.text = (self.choose_StrainUSers.first!.flowering_time?.stringValue)!
            cellStrain.lbl_TempFUp.text = (self.choose_StrainUSers.first!.max_fahren_temp?.stringValue)! + "℉"
            cellStrain.lbl_TempFDown.text = (self.choose_StrainUSers.first!.min_fahren_temp?.stringValue)! + "℉"
            cellStrain.lbl_TempCDown.text = (self.choose_StrainUSers.first!.min_celsius_temp?.stringValue)! + "℃ - " + (self.choose_StrainUSers.first!.max_celsius_temp?.stringValue)! + "℃"
            cellStrain.lbl_Yeild.text = self.choose_StrainUSers.first!.yeild?.capitalizingFirstLetter()
            cellStrain.lbl_Climate.text = self.choose_StrainUSers.first!.climate?.capitalizingFirstLetter()
            self.setDifficultylevel(image_view: cellStrain.imgview_DifficultyLevel, level: self.choose_StrainUSers.first!.growing!)
            
        }else {
            if array_StrainUSers.count > 0 {
                if self.array_StrainUSers.first!.note != nil{
                    cellStrain.lbl_Note.text = self.array_StrainUSers.first!.note
                }else{
                    cellStrain.lbl_Note.text = "No notes added."
                }
                cellStrain.lbl_DifficultyLevel.text = self.array_StrainUSers.first!.growing?.capitalizingFirstLetter()
                cellStrain.lbl_MatureHeight.text = (self.array_StrainUSers.first!.plant_height?.stringValue)! + "\""
                cellStrain.lbl_Time.text = (self.array_StrainUSers.first!.flowering_time?.stringValue)!
                cellStrain.lbl_TempFUp.text = (self.array_StrainUSers.first!.max_fahren_temp?.stringValue)!  + "℉"
                cellStrain.lbl_TempFDown.text = (self.array_StrainUSers.first!.min_fahren_temp?.stringValue)!  + "℉"
                cellStrain.lbl_TempCDown.text = self.array_StrainUSers.first!.min_celsius_temp!.stringValue + "℃ - " + self.array_StrainUSers.first!.max_celsius_temp!.stringValue + "℃"
                cellStrain.lbl_Yeild.text = self.array_StrainUSers.first!.yeild?.capitalizingFirstLetter()
                cellStrain.lbl_Climate.text = self.array_StrainUSers.first!.climate?.capitalizingFirstLetter()
                self.setDifficultylevel(image_view: cellStrain.imgview_DifficultyLevel, level: self.array_StrainUSers.first!.growing!)
            }
        }
        
        cellStrain.selectionStyle = .none
        return cellStrain
    }
    
    func setDifficultylevel(image_view : UIImageView , level : String) {
        switch level {
        case "easy":
            image_view.image = #imageLiteral(resourceName: "easy_dft")
            break
        case "moderate":
             image_view.image = #imageLiteral(resourceName: "mid_dft")
            break
        case "hard":
             image_view.image = #imageLiteral(resourceName: "hard_dft")
            break
        default:
            break
        }
    }
    func EditHEadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "StrainEditcountCell") as! StrainEditcountCell
        cellStrain.lblTotalCount.text = String(self.array_StrainUSers.count) + " Edits"
        cellStrain.buttonPopup.addTarget(self, action: #selector(self.StrainEditBottom), for: UIControlEvents.touchUpInside)
        cellStrain.selectionStyle = .none
        if(self.isShownLabel){
            cellStrain.textConstant.constant =  21
            cellStrain.textDislpay.text = "Strain details will be replaced by user strain detail \n with minimum of 5 likes"
        }else{
            cellStrain.textDislpay.text = ""
             cellStrain.textConstant.constant = 0
        }
        return cellStrain
    }
    
    
    func UserEditInfoStrain(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrain = tableView.dequeueReusableCell(withIdentifier: "UserEditInfoStrainCell") as! UserEditInfoStrainCell
        
        if indexForScroll == 0{
            indexForScroll = indexPath.row
            self.ScrollToEdits = indexPath
        }
        
        
        let mainData = self.array_tble[indexPath.row]
        let index = mainData["index"] as! Int
        cellStrain.imgViewUser.RoundView()
        cellStrain.imgViewReward.isHidden = true
        cellStrain.viewYourVote.isHidden = true
        cellStrain.viewVoteHeight.constant = 0
        cellStrain.btn_UserGotoProfile.tag = index
        cellStrain.btn_UserGotoProfile.addTarget(self, action: #selector(self.GoToProf), for: .touchUpInside)
        
        cellStrain.lbl_TimeAgo.text =  self.GetTimeAgo(StringDate: self.array_StrainUSers[index].updated_at!)
        cellStrain.lbl_Name.text =  self.array_StrainUSers[index].user?.first_name
        if let point = self.array_StrainUSers[index].get_likes_count?.intValue {
            cellStrain.lbl_Points.text = "\(point)"
        }else{
            cellStrain.lbl_Points.text = "\(0)"
        }
       
        if self.array_StrainUSers[index].description! != " "{
            cellStrain.lbl_Notes.applyTag(baseVC: self , mainText: self.array_StrainUSers [index].description!)
            cellStrain.lbl_Notes.text =  self.array_StrainUSers [index].description
        }else{
            cellStrain.lbl_Notes.text =  "No description added."
        }
        cellStrain.btnUserInfo.tag = index
//        cellStrain.btnUserInfo.addTarget(self, action: #selector(self.ChooseNewStrain), for: .touchUpInside)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aVariable = appDelegate.isIphoneX
        if(aVariable) {
        let long = UILongPressGestureRecognizer(target: self, action: #selector(self.StrainViewEdit))
        cellStrain.btnUserInfo.addGestureRecognizer(long)
        }
//            else {
            cellStrain.btnUserInfo.addTarget(self, action: #selector(self.ChooseNewStrain), for: .touchUpInside)
//        }
    
//        cellStrain.btnUserInfo.addTarget(self, action: #selector(self.StrainViewEdit(sender:)), for: .touchUpInside)
        cellStrain.btnLike.tag = index
        cellStrain.btnLike.addTarget(self, action: #selector(self.LikeComment), for: .touchUpInside)
        if self.array_StrainUSers[index].get_user_like_count == 1 {
            cellStrain.imgViewReward.isHidden = false
            cellStrain.imgViewLike.image = #imageLiteral(resourceName: "like_Up_White").withRenderingMode(.alwaysTemplate)
            cellStrain.imgViewLike.tintColor = UIColor.init(hex: "f4c42f")
            cellStrain.viewYourVote.isHidden = false
            cellStrain.viewVoteHeight.constant = 100
            
        }else {
            cellStrain.imgViewReward.isHidden = true
            cellStrain.imgViewLike.image = #imageLiteral(resourceName: "like_Up_White")
            cellStrain.viewYourVote.isHidden = true
            cellStrain.viewVoteHeight.constant = 0
        }
        cellStrain.imgViewUser.image = #imageLiteral(resourceName: "ic_discuss_question_profile")
        if let path = self.array_StrainUSers[index].user?.image_path {
            print(path)
            if((self.array_StrainUSers[index].user?.image_path!.count)! > 4){
               
                if path.contains("facebook.com") || path.contains("google.com"){
                   cellStrain.imgViewUser.sd_setImage(with: URL.init(string: path.RemoveSpace()),placeholderImage :#imageLiteral(resourceName: "ic_discuss_question_profile") ,  completed: nil)
                }else{
                    cellStrain.imgViewUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + path.RemoveSpace()),placeholderImage :#imageLiteral(resourceName: "ic_discuss_question_profile") , completed: nil)
                }
            }else {
               
                if let path = self.array_StrainUSers[index].user?.avatar {
                    print(path)
                    cellStrain.imgViewUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + path.RemoveSpace()),placeholderImage :#imageLiteral(resourceName: "ic_discuss_question_profile") , completed: nil)
                }else{
                    cellStrain.imgViewUser.image = #imageLiteral(resourceName: "ic_discuss_question_profile")
                }
            }
        }else if let path = self.array_StrainUSers[index].user?.avatar {
            cellStrain.imgViewUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + path.RemoveSpace()),placeholderImage :#imageLiteral(resourceName: "ic_discuss_question_profile") , completed: nil)
        }else{
             cellStrain.imgViewUser.image = #imageLiteral(resourceName: "ic_discuss_question_profile")
        }
        if (self.array_StrainUSers[index].user!.special_icon?.characters.count)! > 6 {
            cellStrain.imgViewUserTop.isHidden = false
            cellStrain.imgViewUserTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (self.array_StrainUSers[index].user!.special_icon?.RemoveSpace())!),placeholderImage :#imageLiteral(resourceName: "topi_ic") , completed: nil)
        }else {
            cellStrain.imgViewUserTop.isHidden = true
        }
        
        cellStrain.selectionStyle = .none
        return cellStrain
    }
   
    func LikeComment(sender : UIButton){
        if self.choose_StrainUSers.count == 0{
        if (self.array_StrainUSers[sender.tag].user_id?.intValue)! != Int((DataManager.sharedInstance.user?.ID)!){
        var newparam = [String : AnyObject]()
        newparam["user_strain_id"] = self.array_StrainUSers[sender.tag].id?.stringValue as AnyObject
        newparam["strain_id"] = self.array_StrainUSers[sender.tag].strain_id?.intValue as AnyObject
        if self.array_StrainUSers[sender.tag].get_user_like_count == 1 {
            newparam["is_like"] = "0" as AnyObject
            self.array_StrainUSers[sender.tag].get_user_like_count = 0
            self.array_StrainUSers[sender.tag].get_likes_count = NSNumber(integerLiteral: (self.array_StrainUSers[sender.tag].get_likes_count?.intValue)! - 1)
        }else {
            newparam["is_like"] = "1" as AnyObject
            self.array_StrainUSers[sender.tag].get_user_like_count = 1
            self.array_StrainUSers[sender.tag].get_likes_count = NSNumber(integerLiteral: (self.array_StrainUSers[sender.tag].get_likes_count?.intValue)! + 1)
        }
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_strain_like.rawValue, params: newparam) { (success, message, dataMain) in
            self.hideLoading()
            self.GetStrainDetailAPI()
        }
        }else{
            simpleCustomeAlert(title: "", discription: "You can't like your own info")
        }
        }else{
            if (self.choose_StrainUSers[sender.tag].user_id?.intValue)! != Int((DataManager.sharedInstance.user?.ID)!){
                var newparam = [String : AnyObject]()
                newparam["user_strain_id"] = self.choose_StrainUSers[sender.tag].id?.stringValue as AnyObject
                newparam["strain_id"] = self.choose_StrainUSers[sender.tag].strain_id?.intValue as AnyObject
                if self.choose_StrainUSers[sender.tag].get_user_like_count == 1 {
                    newparam["is_like"] = "0" as AnyObject
                    self.choose_StrainUSers[sender.tag].get_user_like_count = 0
                    self.choose_StrainUSers[sender.tag].get_likes_count = NSNumber(integerLiteral: (self.choose_StrainUSers[sender.tag].get_likes_count?.intValue)! - 1)
                }else {
                    newparam["is_like"] = "1" as AnyObject
                    self.choose_StrainUSers[sender.tag].get_user_like_count = 1
                    self.choose_StrainUSers[sender.tag].get_likes_count = NSNumber(integerLiteral: (self.choose_StrainUSers[sender.tag].get_likes_count?.intValue)! + 1)
                }
                self.showLoading()
                NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_strain_like.rawValue, params: newparam) { (success, message, dataMain) in
                    self.hideLoading()
                    self.GetStrainDetailAPI()
                }
            }else{
                simpleCustomeAlert(title: "", discription: "You can't like your own info")
            }
        }
    }
    func GoToProf(sender : UIButton){
       self.OpenProfileVC(id: String(self.array_StrainUSers[sender.tag].user_id!.intValue))
        
    }
    
    func ChooseNewStrain(sender : UIButton){
        self.isHideTAbs = true
        if appdelegate.isIphoneX {
             self.view_green.isHidden = false
        }else{
             self.view_green.isHidden = true
        }
        self.choose_StrainUSers.removeAll()
        self.choose_StrainUSers.append(self.array_StrainUSers[sender.tag])
        self.tbleView_Strain.setContentOffset(CGPoint.zero, animated:true)
        self.tbleView_Strain.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
        self.ReloadData(newStrainIndex: sender.tag)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if appdelegate.isIphoneX {
             self.view_green.isHidden = true
        } 
    }
}


extension StrainDetailViewController
{
    func LeftButtonAction(sender : UIButton){
        self.view_green.isHidden = true
        if sender.tag == 1{
            if self.firstStrainName.trimmingCharacters(in: .whitespaces).count > 1  {
                self.array_tble.removeAll()
                chooseStrain = Strain()
                DetailStrain =  Strain()
                array_filter.removeAll()
                array_Attachment.removeAll()
                array_StrainUSers.removeAll()
                editAttachment = Attachment()
                choose_StrainUSers.removeAll()
                productArray.removeAll()
                editTableArray.removeAll()
                self.tbleView_Strain.reloadData()
                self.view_green.isHidden = true
                self.choose_StrainUSers.removeAll()
                self.GetDetailAPI(nameIndex: 1)
            }
        }else if sender.tag == 2{
            if self.secondStrainName.trimmingCharacters(in: .whitespaces).count > 1 {
                self.array_tble.removeAll()
                chooseStrain = Strain()
                DetailStrain =  Strain()
                array_filter.removeAll()
                array_Attachment.removeAll()
                array_StrainUSers.removeAll()
                editAttachment = Attachment()
                choose_StrainUSers.removeAll()
                productArray.removeAll()
                editTableArray.removeAll()
                self.tbleView_Strain.reloadData()
                self.isHideTAbs = false
                self.view_green.isHidden = true
                self.choose_StrainUSers.removeAll()
                self.GetDetailAPI(nameIndex: 2)
            }
        }else{
            self.SelectOptions(value: 0)
            self.GetDetailAPI()
        }
        
    }
    
    func RightButtonAction(sender : UIButton){
         self.view_green.isHidden = true
        self.SelectOptions(value: 2)
        self.GetLocateAPI(fromCurrentAction: false)
    }
    
    func MiddelButtonAction(sender : UIButton){
         self.view_green.isHidden = true
        self.SelectOptions(value: 1)
        self.GetStrainDetailAPI()
    }
    
    
    func SelectOptions(value : Int){
        self.showTag = value
        self.choose_StrainUSers.removeAll()
        if let cellHeadingButton = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 1, section: 0) as IndexPath) as? strainDetailButoonChooseView{
            cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzUnselectColor
            cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
            cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
            
            switch value {
            case 0:
                cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kStrainSelectColor
                break
                
            case 1:
                cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kStrainSelectColor
                break;
                
                
            default:
                cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kStrainSelectColor
            }
        } 
        
    }
}


//MARK:
//MARK: Buttons Actions
extension StrainDetailViewController {
    
    
    func ChangeImage(){
//
//        if let cellHEading = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? StrainDetailHeadingCell {
//            switch imgeIndex {
//            case 0:
//                cellHEading.imgView_Main.image = UIImage.init(named: "bgImage1")
//                break
//            case 1:
//                cellHEading.imgView_Main.image = UIImage.init(named: "bgImage2")
//                break
//            default:
//                cellHEading.imgView_Main.image = UIImage.init(named: "bgImage3")
//                break
//
//            }
//
//            if imgeIndex > 2 {
//                imgeIndex = 0
//            }else {
//                imgeIndex = imgeIndex + 1
//            }
//
//        }
        
        
    }
    func AddNewInfo(sender : UIButton){
        let addStrain = self.storyboard?.instantiateViewController(withIdentifier: "AddStrainInfoViewController") as! AddStrainInfoViewController
        addStrain.chooseStrain = self.chooseStrain
        self.navigationController?.pushViewController(addStrain, animated: true)
    }
    
    func GoToGallery(sender : UIButton){
        isRefreshonWillAppear = true
        let galleryView = self.storyboard?.instantiateViewController(withIdentifier: "StrainImageGalleryViewController") as! StrainImageGalleryViewController
        galleryView.StrainMain = self.chooseStrain
        self.navigationController?.pushViewController(galleryView, animated: true)
    }
    
    func GO_Back_ACtion(sender : UIButton){
        self.Back()
    }
    
    func GO_Home_ACtion(sender : UIButton){
        self.GotoHome()
    }

    func GoUpAction(sender : UIButton){
        
//        var newParam = [String : AnyObject]()
//        if self.chooseStrain.get_user_like_count == 0 {
//            newParam["is_like"] = "1" as AnyObject
//        }else {
//            newParam["is_like"] = "0" as AnyObject
//        }
//        newParam["is_dislike"] = "0" as AnyObject
//        newParam["strain_id"] = self.chooseStrain.strainID
//
//        print(newParam)
//        NetworkManager.PostCall(UrlAPI: WebServiceName.strain_like_dislike.rawValue, params: newParam) { (success, message, datamain) in
//            print(datamain)
//
//            if self.chooseStrain.get_user_like_count == 0 {
//               self.chooseStrain.get_user_like_count = 1
//
//                self.chooseStrain.get_likes_count = self.chooseStrain.get_likes_count!.intValue + 1 as NSNumber
//
//
//                if self.chooseStrain.get_user_dislike_count == 1 {
//                    self.chooseStrain.get_dislikes_count = self.chooseStrain.get_dislikes_count!.intValue - 1 as NSNumber
//                }
//
//                self.chooseStrain.get_user_dislike_count = 0
//
//            }else {
//               self.chooseStrain.get_user_like_count = 0
//                self.chooseStrain.get_likes_count = self.chooseStrain.get_likes_count!.intValue - 1 as NSNumber
//
//            }
//
//            self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
//        }

        var newparam = [String : AnyObject]()
        var isLikedImage = 0
        var chooseImage = self.chooseStrain.images![sender.tag]
        if (chooseImage.liked != nil) {
            if chooseImage.liked!.intValue == 0 {
                newparam["is_like"] = "1" as AnyObject
                isLikedImage = 1
            }else {
                newparam["is_like"] = "0" as AnyObject
                isLikedImage = 0
            }
        }else {
            newparam["is_like"] = "1" as AnyObject
        }
        newparam["strain_image_id"] = chooseImage.id?.stringValue as AnyObject
        
        
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_image_strain_like.rawValue, params: newparam) { (successMain, messageResponse, successResponse) in
            
            self.hideLoading()
            
            
            
            if (chooseImage.disliked != nil) {
                if chooseImage.disliked!.intValue == 1 {
                    chooseImage.disliked = 0
                    chooseImage.Image_Dilike_count = String(Int(chooseImage.Image_Dilike_count!)! - 1)
                }
            }
            print(chooseImage.Image_Dilike_count)
            
            if successMain{
                if (successResponse["status"] as! String) == "success" {
                    var successDataMain = successResponse["successData"] as! [String : Any]
                    
                    let likeCount = successDataMain["is_liked"] as! Int
                    
                    if (chooseImage.liked != nil)
                    {
                        if likeCount > 0
                        {
                            chooseImage.liked = 1
                            chooseImage.Image_like_count = String(Int(chooseImage.Image_like_count!)! + 1)
                        }else
                        {
                            chooseImage.liked = 0
                            chooseImage.Image_like_count = String(Int(chooseImage.Image_like_count!)! - 1)
                        }
                    }else {
                        chooseImage.liked = 1
                        chooseImage.Image_like_count = String(Int(chooseImage.Image_like_count!)! + 1)
                        
                    }
                }else {
                    if (successResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        if let error_msg = successResponse["errorMessage"] as? String{
                            self.ShowErrorAlert(message:error_msg)
                        }else{
                            self.ShowErrorAlert(message:"Try again later!")
                        }
                        
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            self.chooseStrain.images![sender.tag] = chooseImage
            self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            
        }
    }
    
    func SaveAction(sender : UIButton){
        
        
        var isStrainPopShown:Bool = false
        
        
        var newParam = [String : AnyObject]()
        if self.chooseStrain.is_saved_count!.intValue == 0 {
            
            isStrainPopShown = true
            newParam["is_favorit"] = "1" as AnyObject
        }else {
            newParam["is_favorit"] = "0" as AnyObject
        }
        newParam["strain_id"] = self.chooseStrain.strainID
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_favorit_strain.rawValue, params: newParam) { (success, message, datamain) in
            print(datamain)
            
            if self.chooseStrain.is_saved_count!.intValue == 0 {
               self.chooseStrain.is_saved_count = 1
            }else {
                self.chooseStrain.is_saved_count = 0
            }
            
            if isStrainPopShown {
                
                if !UserDefaults.standard.bool(forKey: "StrainPopup") {
                
                    self.view_Save.isHidden = false
                }
            }
            
            self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
        
    }
    
    func GodownAction(sender : UIButton){
        
//        var newParam = [String : AnyObject]()
//        if self.chooseStrain.get_user_dislike_count == 0 {
//            newParam["is_dislike"] = "1" as AnyObject
//        }else {
//            newParam["is_dislike"] = "0" as AnyObject
//        }
//        newParam["is_like"] = "0" as AnyObject
//        newParam["strain_id"] = self.chooseStrain.strainID
//
//        NetworkManager.PostCall(UrlAPI: WebServiceName.strain_like_dislike.rawValue, params: newParam) { (success, message, datamain) in
//            print(datamain)
//
//            if self.chooseStrain.get_user_dislike_count == 0 {
//                self.chooseStrain.get_user_dislike_count = 1
//
//                self.chooseStrain.get_dislikes_count = self.chooseStrain.get_dislikes_count!.intValue + 1 as NSNumber
//
//
//                  if self.chooseStrain.get_user_like_count == 1 {
//                    self.chooseStrain.get_likes_count = self.chooseStrain.get_likes_count!.intValue - 1 as NSNumber
//
//                    }
//                 self.chooseStrain.get_user_like_count = 0
//            }else {
//                self.chooseStrain.get_user_dislike_count = 0
//                self.chooseStrain.get_dislikes_count = self.chooseStrain.get_dislikes_count!.intValue - 1 as NSNumber
//            }
//
//            self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
//        }
        var newparam = [String : AnyObject]()
        var chooseImage = self.chooseStrain.images![sender.tag]
        if (chooseImage.disliked != nil) {
            if chooseImage.disliked!.intValue == 0 {
                newparam["is_disliked"] = "1" as AnyObject
            }else {
                newparam["is_disliked"] = "0" as AnyObject
            }
        }else {
            newparam["is_disliked"] = "1" as AnyObject
        }
        newparam["strain_image_id"] = chooseImage.id?.stringValue as AnyObject
        
        
        self.showLoading()
    
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_image_strain_dislike.rawValue, params: newparam) { (successMain, messageResponse, successResponse) in
            
            self.hideLoading()
            
            if (chooseImage.liked != nil) {
                if chooseImage.liked!.intValue == 1 {
                    chooseImage.liked = 0
                    chooseImage.Image_like_count = String(Int(chooseImage.Image_like_count!)! - 1)
                }
            }
            
            
            print(chooseImage.Image_Dilike_count)
            
            if successMain{
                if (successResponse["status"] as! String) == "success" {
                    var successDataMain = successResponse["successData"] as! [String : Any]
                    
                    let likeCount = successDataMain["is_disliked"] as! Int
                    
                    if (chooseImage.disliked != nil)
                    {
                        if likeCount > 0
                        {
                            chooseImage.disliked = 1
                            chooseImage.Image_Dilike_count = String(Int(chooseImage.Image_Dilike_count!)! + 1)
                        }else
                        {
                            chooseImage.disliked = 0
                            chooseImage.Image_Dilike_count = String(Int(chooseImage.Image_Dilike_count!)! - 1)
                        }
                    }else {
                        chooseImage.disliked = 1
                        chooseImage.Image_Dilike_count = String(Int(chooseImage.Image_Dilike_count!)! + 1)
                        
                    }
                }else {
                    if (successResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        if let error_msg = successResponse["errorMessage"] as? String{
                            self.ShowErrorAlert(message:error_msg)
                        }else{
                            self.ShowErrorAlert(message:"Try again later!")
                        }
                        
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            self.chooseStrain.images![sender.tag] = chooseImage
            self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            
        }
        
    }
    

    func GO_Like_ACtion(sender : UIButton){
//        self.view_Save.isHidden = false
        
        
    }
    
    @IBAction func Hide_Like_Action(sender : UIButton){
        self.view_Save.isHidden = true
    }

    @IBAction func CheckLike_Action(sender : UIButton){
        
        sender.isSelected =  !sender.isSelected
        
        if sender.isSelected {
            
        
            self.imgView_Check.image = UIImage.init(named: "Check_Round_S")
            UserDefaults.standard.set(true, forKey: "StrainPopup")

            UserDefaults.standard.synchronize()
            
        }else {
            
            UserDefaults.standard.set(false, forKey: "StrainPopup")
            UserDefaults.standard.synchronize()
            self.imgView_Check.image = UIImage.init(named: "Check_Round_U")
        }
    }
    
    func showFirstPopup(sender : UIButton){
        self.tbleView_Strain.scrollToRow(at:  self.ScrollToPOs, at: .bottom, animated: true)
//        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
//
//        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
//        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)

    }
    func scrollDown(sender : UIButton){
         self.tbleView_Strain.contentOffset = CGPoint(x: 0, y: 0)
        self.tbleView_Strain.scrollToRow(at:  self.ScrollToEdits, at: .bottom, animated: true)
    }
    
    func StrainViewEdit(sender : UIGestureRecognizer!){
        //self.array_StrainUSers [index]
        if sender.state == UIGestureRecognizerState.began{
        if let btn = sender.view as? UIButton{
       let viewMain = self.GetView(nameViewController: "PopViewForEditVC", nameStoryBoard: "SurveyStoryBoard") as! PopViewForEditVC
        viewMain.userObjectEditInfo = self.array_StrainUSers[btn.tag]
//        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "PopViewForEditVC") as! PopViewForEditVC
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        
        viewMain.showPopover(withNavigationController: btn, sourceRect: btn.bounds)
        }
        }
    }
    func StrainTypeInfo(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
        viewMain.text = "Hybrid strains are a cross-breed of Indica and Sativa strains. Due to the plethora of possible combinations, the medical benefits, effects and sensations vary greatly.\n\nHybrids are most commonly created to target and treat specific medical conditions and illnesses."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
    }
    func StrainTypeBottomLeft(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
        viewMain.text = "Indica plants typically grow short and wide which makes them better suited for indoor growing. Indica-dominant strains tend to have a strong sweet/sour odor.\n\nIndicas are very effective for overall pain relief and helpful in treating general anxiety, body pain, and sleeping disorders. It is commonly used in the evening or even right before bed due to it’s relaxing effects.\nMost Commonly Known Benefits:\n1.\tRelieves body pain\n2.\tRelaxes muscles\n3.\tRelieves spasms, reduces seizures\n4.\tRelieves headaches and migraines\n5.\tRelieves anxiety or stress\n"
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    
    func InfoTypeBottomLeft(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
        viewMain.text = "Our metrics are calculated from experiences submitted by the users of the Healing Budz community - not a laboratory."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func StrainEditBottom(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
        viewMain.text = "Your Vote Counts! \n\nBy up-voting a user submitted description, you are endorsing that the information provided is the best among other user submissions.\n\nThe highest voted description becomes the featured description for this strain."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func StrainTypeBottomRight(sender : UIButton){
        let viewMain = self.storyboard?.instantiateViewController(withIdentifier: "TypeStrainViewController") as! TypeStrainViewController
        viewMain.text = "Sativa plants grow tall and thin, making them better suited for outdoor growing- some strains can reach over 25 ft. in height. Sativa-dominant strains tend to have a more grassy-type odor.\n\nSativa effects are known to spark creativity and produce energetic and uplifting sensations. It is commonly used in the daytime due to its cerebral stimulation.\n\nMost Commonly Known Benefits:\n1.\tProduces feelings of well-being\n2.\tUplifting and cerebral thoughts\n3.\tStimulates and energizes\n4.\tIncreases focus and creativity\n5.\tFights depression"
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        print("dismissed")
    }
}


//MARK: View Filter
extension StrainDetailViewController {
    func RefreshFilterArray(){
        self.array_filter.removeAll()
        
        
        
            var dataDict = [String : String]()
            dataDict["image"] = "CircleE"
            dataDict["name"] = "Report Abused"
            
            var dataDict2 = [String : String]()
            dataDict2["image"] = "CircleE"
            dataDict2["name"] = "Spam"
            
            var dataDict3 = [String : String]()
            dataDict3["image"] = "CircleE"
            dataDict3["name"] = "Unrelated"
        
        
        var dataDict4 = [String : String]()
        dataDict4["image"] = "CircleE"
        dataDict4["name"] = "Nudity or sexual content"
        
        var dataDict7 = [String : String]()
        dataDict7["image"] = "CircleE"
        dataDict7["name"] = "Harssment or hate speech"
        
        var dataDict6 = [String : String]()
        dataDict6["image"] = "CircleE"
        dataDict6["name"] = "Threatening, violent or concerning"
            
            
            
            
            var dataDict5 = [String : String]()
            dataDict5["image"] = ""
            dataDict5["name"] = ""
            
            self.array_filter.append(dataDict)
        self.array_filter.append(dataDict4)
        self.array_filter.append(dataDict7)
        self.array_filter.append(dataDict6)
            self.array_filter.append(dataDict2)
            self.array_filter.append(dataDict)
            self.array_filter.append(dataDict3)
            self.array_filter.append(dataDict5)
        
        
        self.tbleViewFilter.reloadData()
    }
    
    @IBAction func ShowFilterViewforStrain(sender : UIButton){
        var chooseImage = self.chooseStrain.images![sender.tag]
        self.spamImageIndex = sender.tag
        if !chooseImage.flagged{
            self.ShowFilterView(sender: sender)
        }else{
            self.ShowErrorAlert(message: "Photo already reported!")
        }
    }
    
    @IBAction func ShowFilterView(sender : UIButton){
        self.RefreshFilterArray()
        isFliterviewOpen = true
        self.tbleView_Strain.isScrollEnabled = false
        self.tbleView_Strain.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.tbleView_Strain.alpha = 0.2
            self.FilterTopValue.constant = -420 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func HideFilterView(sender : UIButton){
        isFliterviewOpen = false
        self.tbleView_Strain.isScrollEnabled = true
        self.tbleView_Strain.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
             self.tbleView_Strain.alpha = 1.0
            self.FilterTopValue.constant = 10 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        
        })
    }
    func ReportHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAHeadingcell") as! QAHeadingcell
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func SendButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QASendButtonCell") as! QASendButtonCell
        cellFilter.btn_Send.backgroundColor = UIColor.init(hex: "F4B927")
        cellFilter.btn_Send.tag = spamImageIndex
        cellFilter.btn_Send.addTarget(self, action:#selector(self.APICAllForFlag), for: UIControlEvents.touchUpInside)
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    
    func ReportOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAReasonCell") as! QAReasonCell
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"]
        cellFilter.selected_line.backgroundColor = UIColor.init(hex: "F4B927")
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
        cellFilter.selectionStyle = .none
        if indexPath.row == 1 {
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
            cellFilter.view_BG.isHidden = false
        }else{
             cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
            cellFilter.view_BG.isHidden = true
        }
        return cellFilter
    }
    
    func APICAllForFlag(sender: UIButton!){
        
        if self.questionID.characters.count > 0 {
            if reportValue.count == 0 {
                self.ShowErrorAlert(message: "Please choose reason for reporting.")
                return
            }
        var mainUrl = String()
        var param = [String: AnyObject]()
        mainUrl = WebServiceName.flag_strain_review.rawValue
        param["strain_review_id"] = self.questionID as AnyObject
        param["strain_id"] = self.chooseStrain.strainID as AnyObject
        param["is_flaged"] = "1" as AnyObject
        param["reason"] = reportValue as AnyObject
        self.view.showLoading()
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            
            if successRespons {
                if let successMessage = dataResponse["successMessage"] as? String {
                    
                    if  self.questionID.characters.count > 0 {
                        let arrayReview = (self.DetailStrain.strain?.strainReview)!
                        var index = 0
                        for indexObj in arrayReview {
                            if indexObj.id?.stringValue == self.questionID {
                                indexObj.is_user_flaged_count = 1
                                self.DetailStrain.strain?.strainReview![index] = indexObj
                                break
                            }
                            index = index + 1
                        }
                    }else {
                        self.chooseStrain.get_user_flag_count = 1
                    }
                    
                    self.HideFilterView(sender: UIButton.init())
                    self.tbleView_Strain.reloadData()
                    
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                    DataManager.sharedInstance.logoutUser()
                    self.ShowLogoutAlert()
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.questionID = ""
            self.tbleView_Strain.reloadData()
        }
    }else{
        
        if reportValue.count == 0 {
            self.ShowErrorAlert(message: "Please choose reason for reporting.")
            return
        }
        
        self.view.showLoading()
        var chooseImage = self.chooseStrain.images![sender.tag]
        var param = [String : AnyObject]()
        param["strain_image_id"] = chooseImage.id as AnyObject
        param["is_flagged"] = "1" as AnyObject
        param["reason"] = reportValue as AnyObject
        
        let mainUrl = WebServiceName.save_user_image_strain_flag.rawValue
        
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            
            if successRespons {
                if let successMessage = dataResponse["successMessage"] as? String {
                    
                    self.HideFilterView(sender: UIButton.init())
                    
                    
                    self.chooseStrain.images![sender.tag].flagged = true
                    
//                    self.imgViewFlagImage.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
//                    self.imgViewFlagImage.tintColor = UIColor.init(hex: "F4B927")
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                    DataManager.sharedInstance.logoutUser()
                    self.ShowLogoutAlert()
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            
        }
        
        self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
    }
}
}

class StrainDetailHeadingCell: UITableViewCell {
    
//    @IBOutlet var slider          : AACarousel!
    
    @IBOutlet weak var img_user_view: UIView!
    
    @IBOutlet  weak var collectionView: UICollectionView!
    @IBOutlet  weak var imgTopShow: UIImageView!
    
    @IBOutlet weak var lbl_like_header: UILabel!
    @IBOutlet var btn_Back          : UIButton!
    @IBOutlet var btn_Home          : UIButton!
    @IBOutlet var btn_Gallery       : UIButton!
    @IBOutlet var btn_Share         : UIButton!
    @IBOutlet var btn_like          : UIButton!
    @IBOutlet var btn_Zoom          : UIButton!
    @IBOutlet var btn_Next          : UIButton!
    @IBOutlet var btn_Previous      : UIButton!
    @IBOutlet var btn_Review        : UIButton!
    @IBOutlet var btn_Upload        : UIButton!
    @IBOutlet var btn_likeUp        : UIButton!
    @IBOutlet var btn_likeDown        : UIButton!
    @IBOutlet var btn_flag        : UIButton!
    @IBOutlet var lblReward: UILabel!
    @IBOutlet var lbl_Name              : UILabel!
    @IBOutlet var lbl_Type              :   UILabel!
    @IBOutlet var lbl_rating            : UILabel!
    @IBOutlet var lbl_Review            : UILabel!
    @IBOutlet var lbl_UpVote            : UILabel!
    @IBOutlet var lbl_DownVote          : UILabel!
    @IBOutlet var lbl_Image_Date        : UILabel!
    @IBOutlet var lbl_Image_UploaderName  : UILabel!
    @IBOutlet weak var arrow1View: UIView!
    @IBOutlet weak var arrow2View: UIView!
    @IBOutlet weak var userViewButton: UIButton!
    @IBOutlet var imgView_type  : UIImageView!
    @IBOutlet var imgView_Rating  : UIImageView!
    @IBOutlet var imgView_like  : UIImageView!
    @IBOutlet var imgView_likeUp  : UIImageView!
    @IBOutlet var imgView_likeDown  : UIImageView!
    @IBOutlet var imgView_flag  : UIImageView!
    
    @IBOutlet var btn_BackUpper        : UIButton!
    @IBOutlet var lbl_UpperUserName          : UILabel!
    @IBOutlet var lbl_UpperTime          : UILabel!
    @IBOutlet var view_Upper  : UIView!
    @IBOutlet var viewLikeUp: UIView!
    @IBOutlet var viewLikeDown: UIView!
    @IBOutlet var viewFlag: UIView!
    @IBOutlet var strainDetailLike: UIButton!
    @IBOutlet var strainDetailLikeImg: UIImageView!
}


extension StrainDetailHeadingCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        //        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    
}

class strainDetailButoonChooseView : UITableViewCell{
    @IBOutlet var lblLeft   : UILabel!
    @IBOutlet var lblMiddel : UILabel!
    @IBOutlet var lblRight  : UILabel!
    
    @IBOutlet var viewLeft  : UIView!
    @IBOutlet var viewMiddel : UIView!
    @IBOutlet var viewRight : UIView!
    
    @IBOutlet var btnLeft  : UIButton!
    @IBOutlet var btnMiddel : UIButton!
    @IBOutlet var btnRight : UIButton!

}

class StrainDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_full_discription: UIButton!
    @IBOutlet weak var constraint_height: NSLayoutConstraint!
    @IBOutlet var lblDescription   : ActiveLabel!
}


class StrainTopCell: UITableViewCell {
    @IBOutlet var Btn_Info : UIButton!
    @IBOutlet var lbl_Count : UILabel!
    
}


class SurveyInfoCell: UITableViewCell {
    @IBOutlet var imgView_Main : UIImageView!
    
    @IBOutlet var view_Top : UIView!
    
    @IBOutlet var lbl_Main : UILabel!
    @IBOutlet var lbl_Top : UILabel!
    @IBOutlet var lbl_Center : UILabel!
    @IBOutlet var lbl_Bottom : UILabel!
    
    @IBOutlet weak var top_View: NSLayoutConstraint!
    @IBOutlet weak var Bottom_View: NSLayoutConstraint!
    @IBOutlet weak var Center_View: NSLayoutConstraint!
    @IBOutlet weak var top_ViewHi: NSLayoutConstraint!
    @IBOutlet weak var Bottom_ViewHi: NSLayoutConstraint!
    @IBOutlet weak var Center_ViewHi: NSLayoutConstraint!
}



class StrainTellExperienceCell: UITableViewCell {
    @IBOutlet var btn_Experience : UIButton!
    
}


class AddcommentCell: UITableViewCell {
    @IBOutlet var btn_AddComment : UIButton!
    @IBOutlet var lblReviewCount : UILabel!
    @IBOutlet var btn_ShowComment : UIButton!
}


class Commentcell: UITableViewCell {
    
    @IBOutlet weak var lbl_title_report: UILabel!
    @IBOutlet weak var ImgView_Star: UIImageView!
    @IBOutlet weak var ImgView_Flag: UIImageView!
    @IBOutlet weak var ImgView_Attachment: UIImageView!
    @IBOutlet weak var ImgView_Video: UIImageView!
    @IBOutlet weak var ImgView_User : UIImageView!
    @IBOutlet weak var ImgView_UserTop : UIImageView!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var flagViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var view_Attachment: UIView!
    
    @IBOutlet weak var reveiwLikeBtn: UIButton!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var Btn_Rate: UIButton!
    @IBOutlet weak var Btn_share: UIButton!
    @IBOutlet weak var Btn_Flag: UIButton!
    @IBOutlet weak var Btn_Attachment: UIButton!
    @IBOutlet weak var Btn_UserProfile: UIButton!
    
    @IBOutlet weak var Lbl_Rating: UILabel!
    @IBOutlet weak var Lbl_Time: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Message: ActiveLabel!
    
    @IBOutlet weak var commentEditView: UIView!
    @IBOutlet weak var commentEditButton: UIButton!
    @IBOutlet weak var commentEditViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentDeleteView: UIView!
    @IBOutlet weak var commentDeleteButton: UIButton!
    @IBOutlet weak var commentDeleteViewWidth: NSLayoutConstraint!
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    
}


class TypeCommectStrainCell: UITableViewCell {
    @IBOutlet var txtViewMain : UITextView!
    @IBOutlet var lblcont : UILabel!
    override func awakeFromNib() {
        
    }
}


class AddImageStrainCell: UITableViewCell {
    @IBOutlet var btnUploadNew : UIButton!
}

class StrainRatingcell: UITableViewCell {
    @IBOutlet var imgview_Star1 : UIImageView!
    @IBOutlet var imgview_Star2 : UIImageView!
    @IBOutlet var imgview_Star3 : UIImageView!
    @IBOutlet var imgview_Star4 : UIImageView!
    @IBOutlet var imgview_Star5 : UIImageView!
    
    
    @IBOutlet var btn_Star1 : UIButton!
    @IBOutlet var btn_Star2 : UIButton!
    @IBOutlet var btn_Star3 : UIButton!
    @IBOutlet var btn_Star4 : UIButton!
    @IBOutlet var btn_Star5 : UIButton!
    
}


class SubmitcommentStrainCell: UITableViewCell {
    @IBOutlet var btnSubmit : UIButton!
}


class StrainLocationCell: UITableViewCell {
    @IBOutlet var lblZipCode : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var userImg : CircularImageView!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var userImgCell: UIImageView!
    @IBOutlet var btnCurrentLocation : UIButton!
}

class NearStrainCell: UITableViewCell {
    
    @IBOutlet weak var hideGreenView: UIView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var withText: UILabel!
    @IBOutlet weak var _15MilesText: UILabel!
    @IBOutlet weak var ofyourlocationText: UILabel!
}

class StrainBudCell: UITableViewCell {
    @IBOutlet var lblName        : UILabel!
    @IBOutlet var lblCBD         : UILabel!
    @IBOutlet var lblTHC         : UILabel!
    @IBOutlet var lblDistance    : UILabel!
    @IBOutlet var lblCount      : UILabel!
    @IBOutlet var lblType      : UILabel!
    @IBOutlet var imageCountView: UIImageView!
    @IBOutlet weak var btn_img: UIButton!
    @IBOutlet var viewFirst     : UIView!
    @IBOutlet var viewSecond    : UIView!
    @IBOutlet var viewThird     : UIView!
    @IBOutlet var viewFourth    : UIView!
    
    @IBOutlet var imgViewMain    : FLAnimatedImageView!
    
    @IBOutlet var lblWeight_1  : UILabel!
    @IBOutlet var lblWeight_2  : UILabel!
    @IBOutlet var lblWeight_3  : UILabel!
    @IBOutlet var lblWeight_4  : UILabel!
    
    @IBOutlet var lblPrice_1  : UILabel!
    @IBOutlet var lblPrice_2  : UILabel!
    @IBOutlet var lblPrice_3  : UILabel!
    @IBOutlet var lblPrice_4  : UILabel!
    
    @IBOutlet var btnShare  : UIButton!
    
}

class AddMoreStrinInfoCell: UITableViewCell {
    
    @IBOutlet var btn_AddMoreInfo : UIButton!
}


class FullDescriptionStrainCEll: UITableViewCell {
    @IBOutlet var lblDescription : ActiveLabel!
    @IBOutlet var lblReward : UILabel!
     @IBOutlet var btnScrollDown  : UIButton!
    @IBOutlet var lbRewardImage : UIImageView!
}

class StrainTypeShowCell: UITableViewCell {
    @IBOutlet var btn_Type : UIButton!
    @IBOutlet var btn_BottomLeft : UIButton!
    @IBOutlet var btn_BottomRight : UIButton!
    @IBOutlet weak var gradView: UIView!
    @IBOutlet weak var gradParent: UIView!
    @IBOutlet weak var Lbl_leftPercentage: UILabel!
    @IBOutlet weak var Lbl_rightPercentage: UILabel!
   @IBOutlet weak var lbl_hybrid_type: UILabel!
    
    
  var imageViewForThumb:UIImageView?
  var gradientLayer: CAGradientLayer!
    override func awakeFromNib() {
     self.gradView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - ((gradParent?.frame.origin.x)! * 2), height: gradParent.frame.size.height)
        imageViewForThumb = UIImageView(frame: CGRect(x: self.gradView.frame.origin.x+70, y: self.gradView.frame.origin.y-10, width: 14, height: self.gradView.frame.size.height+20))
        imageViewForThumb?.image = #imageLiteral(resourceName: "thumb")
//        gradParent.addSubview(imageViewForThumb!)
//        gradParent.bringSubview(toFront: imageViewForThumb!)
        gradParent.bringSubview(toFront: Lbl_leftPercentage)
        gradParent.bringSubview(toFront: Lbl_rightPercentage)
        gradView.backgroundColor = UIColor.blue
        self.createGradientLayer()
    }
   
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradView.frame
        
        gradientLayer.colors = [UIColor(red:1.000, green:0.694, blue:0.212, alpha:1.000).cgColor,UIColor(red:0.965, green:0.000, blue:0.216, alpha:1.000).cgColor]
        gradientLayer.locations = [0.2, 0.45]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        
        self.gradView.layer.addSublayer(gradientLayer)
    }
    
    
    func ValueChange(senderValue: Float) {
        
        var x = Double(Float(self.gradView.frame.width/100) * senderValue) - 9
        if x <= Double(self.gradView.frame.origin.x) {
            x = Double(self.gradView.frame.origin.x) - 8
        }else if x >= Double((self.gradView.frame.origin.x + self.gradView.frame.size.width)){
             x = Double((self.gradView.frame.origin.x + self.gradView.frame.size.width))
        }
        
        if senderValue < 50{
            self.Lbl_rightPercentage.text = String(format: "%.0f",senderValue) + " %"
            self.Lbl_leftPercentage.text = String(format: "%.0f",(100 - senderValue)) + " %"
        }
        else if senderValue >= 50{
            self.Lbl_rightPercentage.text = String(format: "%.0f",senderValue) + " %"
            self.Lbl_leftPercentage.text = String(format: "%.0f",(100 - senderValue)) + " %"
            
        }
        
        self.imageViewForThumb?.frame = CGRect.init(x: x, y: Double(self.gradView.frame.origin.y-10), width: Double(14), height: Double(self.gradView.frame.size.height+20))
        
        gradientLayer.colors = [ConstantsColor.gradiant_first_colro, ConstantsColor.gradiant_second_colro]
        switch (senderValue/100) {
        case 0...0.05:
            gradientLayer.locations = [1.0, 1.0]
        case 0.05...0.10:
            gradientLayer.locations = [0.9, 0.95]
        case 0.10...0.15:
            gradientLayer.locations = [0.85, 0.90]
        case 0.15...0.20:
            gradientLayer.locations = [0.80, 0.85]
        case 0.20...0.25:
            gradientLayer.locations = [0.75, 0.80]
        case 0.25...0.30:
            gradientLayer.locations = [0.70, 0.75]
        case 0.30...0.35:
            gradientLayer.locations = [0.65, 0.70]
        case 0.35...0.40:
            gradientLayer.locations = [0.60, 0.65]
        case 0.40...0.45:
            gradientLayer.locations = [0.55, 0.60]
        case 0.45...0.50:
            gradientLayer.locations = [0.50, 0.55]
            
        case 0.50...0.55:
            gradientLayer.locations = [0.45, 0.50]
        case 0.55...0.60:
            gradientLayer.locations = [0.40, 0.45]
        case 0.60...0.65:
            gradientLayer.locations = [0.35, 0.40]
        case 0.65...0.70:
            gradientLayer.locations = [0.30, 0.35]
        case 0.70...0.75:
            gradientLayer.locations = [0.25, 0.30]
        case 0.75...0.80:
            gradientLayer.locations = [0.20, 0.25]
        case 0.80...0.85:
            gradientLayer.locations = [0.15, 0.20]
        case 0.85...0.90:
            gradientLayer.locations = [0.10, 0.15]
        case 0.90...0.95:
            gradientLayer.locations = [0.05, 0.10]
        case 0.95...1.0:
            gradientLayer.locations = [0.0, 0.0]
        default:
            break
        }
    }
}


class StrainBreedCell : UITableViewCell {
    @IBOutlet var lblFirstName : UILabel!
    @IBOutlet var lblSecondName : UILabel!
    @IBOutlet weak var buttonFirstName: UIButton!
    @IBOutlet weak var buttonSecondName: UIButton!
}

class StrainCareShowCell : UITableViewCell {
    @IBOutlet var lbl_DifficultyLevel : UILabel!
    @IBOutlet var lbl_MatureHeight : UILabel!
    @IBOutlet var lbl_Time : UILabel!
    @IBOutlet var lbl_TempFUp : UILabel!
    @IBOutlet var lbl_TempFDown : UILabel!
    @IBOutlet var lbl_TempCDown : UILabel!
    @IBOutlet var lbl_Yeild : UILabel!
    @IBOutlet var lbl_Climate : UILabel!
    @IBOutlet var lbl_Note : UILabel!
    
    @IBOutlet var imgview_DifficultyLevel : UIImageView!
}

class StrainEditcountCell : UITableViewCell {
    @IBOutlet var lblTotalCount : UILabel!
    @IBOutlet weak var textDislpay: UILabel!
    @IBOutlet weak var textConstant: NSLayoutConstraint!//21
    @IBOutlet var buttonPopup: UIButton!
}

class ChemistryshowCell: UITableViewCell{
    @IBOutlet var minCBD: UILabel!
    @IBOutlet var maxCBD: UILabel!
    @IBOutlet var minTHC: UILabel!
    @IBOutlet var maxTHC: UILabel!
}


class UserEditInfoStrainCell : UITableViewCell {
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Points : UILabel!
    @IBOutlet var lbl_Notes : ActiveLabel!
    @IBOutlet var lbl_TimeAgo : UILabel!
    
    @IBOutlet weak var btn_UserGotoProfile: UIButton!
    @IBOutlet var viewYourVote : UIView!
    
    @IBOutlet var imgViewUser : UIImageView!
    @IBOutlet var imgViewUserTop : UIImageView!
    @IBOutlet var imgViewReward : UIImageView!
    @IBOutlet var imgViewLike : UIImageView!
    @IBOutlet weak var viewVoteHeight: NSLayoutConstraint!
    
    @IBOutlet var btnUserInfo : UIButton!
    @IBOutlet var btnLike : UIButton!
}

