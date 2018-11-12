//
//  DispensaryDetailVC.swift
//  BaseProject
//
//  Created by macbook on 04/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import Cosmos
import ActiveLabel
import ObjectMapper
import AVKit
import SwiftyJSON
import FLAnimatedImage
var isProductAdded : Bool = false
class DispensaryDetailVC: BaseViewController , CameraDelegate , UITextViewDelegate , refreshDataDelgate{

    @IBOutlet var tbleViewMain : MyTableView!
    var state = ""
    var isRefreshDataOnWillAppear = true
    var txtCommentTxt = ""
    var typeComment = "Type your comment here..."
    var sendValueKey = ""
    var searched_keyword = ""
    var strain_Array : [[String : Any]] = [[String : Any]]()
    @IBOutlet weak var addProductView: UIView!
    var cellMain : BudzHeaderCell?
    var isPopShown:Bool = false
    var isSpecailTapped:Bool = false
    var timer: Timer?
    var indexPAthMain = 0
    var editedCellIndex = -1
    var replyEditIndex = -1
    var chooseBudzMap = BudzMap()
    var headerBudzMap = BudzMap()
    var rating = 1.0
    var paymentMethodsArray = [String]()
    var array_table = [[String: Any]]()
    var showTag = 0
    var array_Attachment = [Attachment]()
    var array_Product = [StrainProduct]()
    var category_array_product = [StrainProduct]()
    var strainType_array_product = [StrainProduct]()
    var other_array_product = [StrainProduct]()
    var budz_map_id : String =  ""
    var isSpecialShown : Bool = false
    var array_Special = [BudzMapSpecial]()
    var budz_specials = [Specials]()
    var budz_tickets = [Ticktes]()
    var array_Services = [BudzMapServices]()
    var refreshControl: UIRefreshControl!
    var editAttachment = Attachment()
    var deleteImageReview = 0
    @IBOutlet weak var editCommentView: UIView!
    @IBOutlet weak var editCommentTableView: UITableView!
    var editTableArray = [String]()
    var replyEditTableArray = [String]()
    var isBtnClicked = false
    @IBOutlet weak var replyEditView: UIView!
    @IBOutlet weak var replyEditTableView: UITableView!
    @IBOutlet weak var saveView: UIView!
    var isFromMyBudzMap:Bool = false
    var tabsRefreshed = false
    var replyUpdating = false
    var fromNew = false
    var fiveBack = false
    var categoryCount = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
//        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action: #selector(self.refreshTabs), for: .valueChanged)
        tbleViewMain.addSubview(refreshControl)
//        tbleViewMain.refreshControl = refreshControl
       self.RegisterXib()
        self.disableMenu()
        editTableLoad()
        editCommentTableView.separatorStyle = .none
        editCommentView.isHidden = true
        replyEditTableLoad()
        replyEditView.isHidden = true
        replyEditTableView.separatorStyle = .none
        self.tbleViewMain.contentInset.top = -20
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reportReview), name: NSNotification.Name(rawValue: "BudzFlagReview"), object: nil)
        // Do any additional setup after loading the view.
            NotificationCenter.default.addObserver(self, selector: #selector(self.doneSubscribing), name:NSNotification.Name(rawValue: "suscribedNow"), object: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkState() -> Bool{
        if states.contains(self.state){
            return true
        }else{
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if isRefreshDataOnWillAppear{
            if  isProductAdded {
                self.showTag = 1
                self.SelectOptions(value: 1)
            }else if isSpecialShown{
                self.showTag = 2
            }else{
                self.SelectOptions(value: 0)
            }
            self.getStateFromZip()
            self.addProductView.isHidden = true
        }else{
            isRefreshDataOnWillAppear = true
        }
        isRefreshonWillAppear = false
        self.saveView.isHidden = true
        self.disableMenu()

    }
    
    func refreshData() {
        self.isSpecialShown = true
        if  isProductAdded {
            self.showTag = 1
        }else if isSpecialShown{
            self.showTag = 2
        }else{
            self.SelectOptions(value: 0)
        }
        self.getStateFromZip()
        self.addProductView.isHidden = true
        isRefreshonWillAppear = false
        self.saveView.isHidden = true
        self.disableMenu()
    }
    
    func refreshTabs(isSound : Bool = true){
        if isSound {
             self.playSound(named: "refresh")
        }
        refreshControl.endRefreshing()
        tabsRefreshed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        self.getStateFromZip()
//        self.SelectOptions(value: self.showTag)
        })
    }
    
   
    deinit {
     
    }
    
    func doneSubscribing(){
        self.ShowErrorAlert(message: "Your business is now paid", AlertTitle: "Congratulations!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !fromNew{
        self.enableMenu()
        }
     }
    
    
    @IBAction func onClickCross(_ sender: Any) {
        
        self.addProductView.isHidden = true
    }
    func GetBudzMapDetail(){
        self.showLoading()
        self.array_Special.removeAll()
        self.array_Services.removeAll()
        self.array_Product.removeAll()

        var newURL : String = ""
        if self.budz_map_id.count == 0 {
            newURL =  WebServiceName.get_budz_profile.rawValue + String(self.chooseBudzMap.id)
        }else{
            newURL =  WebServiceName.get_budz_profile.rawValue + String(self.budz_map_id)
        }
        if sendValueKey.count > 1 {
            
            newURL = newURL + "?keyword=" + sendValueKey
            searched_keyword = sendValueKey
            sendValueKey = ""
        }
        
        print(newURL)
        NetworkManager.GetCall(UrlAPI: newURL.RemoveSpace()) { (successResponse, MessageResponse, DataResponse) in

            self.hideLoading()
            if successResponse {
                print(DataResponse )
                if  let strain = DataResponse["strains"] as? [[String : Any]]{
                    self.strain_Array = strain
                }
                if (DataResponse["status"] as! String) == "success" {
                    let mainData = DataResponse["successData"] as! [String : AnyObject]
                    self.chooseBudzMap = BudzMap.init(json: mainData)
                    
                    let cat = DataResponse["successMessage"] as? NSArray ?? []
                    if cat.count != 0{
                    self.categoryCount = cat.count
                    }else{
                    self.categoryCount = -1
                    }
                    print(mainData)
                    let productsData = mainData["products"] as! [[String : AnyObject]]
                    //TODO FOR SECTION WORK
                    var array_Product_lc = [StrainProduct]()
                    var array_Product_lc_cc = [StrainProduct]()
                    var product_title = [String]()
                    for indexobj in productsData {
                        array_Product_lc_cc.append(StrainProduct.init(json: indexobj))
                        
                    }
                    for n in 0..<array_Product_lc_cc.count {
                        if(self.chooseBudzMap.budzMapType.idType == 3){
                            if(array_Product_lc_cc[n].titleDisplay == "Indica" || array_Product_lc_cc[n].titleDisplay == "Hybrid" || array_Product_lc_cc[n].titleDisplay == "Sativa"){
                                array_Product_lc_cc[n].titleDisplay = "Others"
                                
                            }
                        }
                    }
                    for indexobj in array_Product_lc_cc {
                        array_Product_lc.append(indexobj)
                    }
                    for indexobj in array_Product_lc {
                        if(!product_title.contains(indexobj.titleDisplay)){
                            product_title.append(indexobj.titleDisplay)
                        }
                    }
                    var isDelete:Bool = false
                    if(product_title.contains("Others")){
                        isDelete = true
                        product_title.remove(at: product_title.index(where: {$0 == "Others"})!)
                    }
                    product_title = product_title.sorted(by: {$0 < $1})
                    if(isDelete){
                        product_title.append("Others")
                    }
                    var count:Int = 12
                    
                    for indexobj in product_title {
                        for indexobjProduct in array_Product_lc {
                            if(indexobj == indexobjProduct.titleDisplay){
                                if(count == 12){
                                    indexobjProduct.isTitle = true
                                    self.array_Product.append(indexobjProduct)
                                    count = 13
                                }else {
                                    indexobjProduct.isTitle = false
                                    self.array_Product.append(indexobjProduct)
                                }
                            }
                        }
                        count = 12
                    }
                    
                    //array_Product
                    let servicesData = mainData["services"] as! [[String : AnyObject]]
                    
                    for indexobj in servicesData {
                        self.array_Services.append(BudzMapServices.init(json: indexobj))
                    }
                    
                    let specialsData = mainData["specials"] as! [[String : AnyObject]]
                    
                    for indexobj in specialsData {
                        self.array_Special.append(BudzMapSpecial.init(json: indexobj))
                    }
                    
                    let budz_spl = mainData["special"] as! [[String : AnyObject]]
                    self.budz_specials.removeAll()
                    for indexobj in budz_spl {
                        self.budz_specials.append(Specials.init(json: indexobj))
                    }
                    
                    if let ticktes = mainData["tickets"] as? [[String : AnyObject]] {
                        self.budz_tickets.removeAll()
                        for indexobj in ticktes {
                            self.budz_tickets.append(Ticktes.init(json: indexobj))
                        }
                    }
                    
                    if let paymant_methods = mainData["paymant_methods"] as? [[String : AnyObject]] {
                        self.paymentMethodsArray.removeAll()
                        for indexobj in paymant_methods {
                            if let method_detail = indexobj["method_detail"] as? [String : AnyObject] {
                                if let  url = method_detail["image"] as? String {
                                     self.paymentMethodsArray.append(WebServiceName.images_baseurl.rawValue + url)
                                }
                            }
                        }
                    }
                }else {
                    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:MessageResponse)
            }
            if isProductAdded {
                self.SelectOptions(value: 1)
            }else{
                  self.RefreshTableView()
            }
          
            
        }
    }
    
    
    func GetBudzMapInfo(){
        self.showLoading()
        var newURL = ""
        if self.budz_map_id.count == 0 {
            newURL = WebServiceName.get_budz.rawValue + String(self.chooseBudzMap.id) + "?lat="
            newURL = newURL + (DataManager.sharedInstance.user?.userlat)! + "&lng=" + (DataManager.sharedInstance.user?.userlng)!
        }else{
            newURL = WebServiceName.get_budz.rawValue + String(self.budz_map_id) + "?lat="
            newURL = newURL + (DataManager.sharedInstance.user?.userlat)! + "&lng=" + (DataManager.sharedInstance.user?.userlng)!
        }
      
        
        print(newURL)
        NetworkManager.GetCall(UrlAPI: newURL) { (successResponse, MessageResponse, DataResponse) in
            self.hideLoading()
            print(DataResponse)
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    let mainData = DataResponse["successData"] as! [String : AnyObject]
                    
                    self.headerBudzMap = BudzMap.init(json: mainData)
                    self.GetBudzMapDetail()
                }else {
                    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:MessageResponse)
            }
            if self.chooseBudzMap.budzMapType.idType == 2 || self.chooseBudzMap.budzMapType.idType == 6 || self.chooseBudzMap.budzMapType.idType == 7{
                if !self.checkState(){
                    self.ShowSuccessAlert(message: "You can't view this type of business in your area.")
                }else{
                    self.RefreshTableView()
                }
            }else{
//                self.RefreshTableView()
            }
            
        }
    }
    
    
    
    func RefreshTableView(){
        array_table.removeAll()
        if self.chooseBudzMap.budzMapType.idType == 1 {
            self.DispensaryDataload()
        }else if self.chooseBudzMap.budzMapType.idType == 2 || self.chooseBudzMap.budzMapType.idType == 6 || self.chooseBudzMap.budzMapType.idType == 7 {
            self.MedicalDataload()
        }else if self.chooseBudzMap.budzMapType.idType == 3 {
            self.CannabitesDataload()
        }else if self.chooseBudzMap.budzMapType.idType == 4 {
            self.EntertainmentDataload()
        }else if self.chooseBudzMap.budzMapType.idType == 5 {
            self.EventDataload()
        }else if self.chooseBudzMap.budzMapType.idType == 9 {
            self.OthersDataLaod()
        }else {
             self.DispensaryDataload()
        }
        self.tbleViewMain.reloadData()
        if isSpecialShown || tabsRefreshed || isProductAdded{
            self.SelectOptions(value: self.showTag)
        }
    }
    func editTableLoad(){
        editTableArray.removeAll()
        editTableArray.append("CommentHeader")
        editTableArray.append("TextView")
        if self.editAttachment.ID != "-1"{
            editTableArray.append("UploadButton")
        }else{
            editTableArray.append("Image")
        }
         editTableArray.append("AddRating")
         editTableArray.append("SubmitAction")
        
        editCommentTableView.reloadData()
    }
    
    func replyEditTableLoad(){
        replyEditTableArray.removeAll()
        replyEditTableArray.append("CommentHeader")
        replyEditTableArray.append("TextView")
        replyEditTableArray.append("SubmitAction")
        
        replyEditTableView.reloadData()
        
    }
    
    func DispensaryDataload(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])
        if self.chooseBudzMap.timing.friday == "Closed" && self.chooseBudzMap.timing.monday == "Closed" && self.chooseBudzMap.timing.tuesday == "Closed" && self.chooseBudzMap.timing.wednesday == "Closed" && self.chooseBudzMap.timing.thursday == "Closed" && self.chooseBudzMap.timing.saturday == "Closed" && self.chooseBudzMap.timing.sunday == "Closed"{
        if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
        array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
        }
        }else{
        array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
        }
        array_table.append(["type" : BudzMapDataType.WebsiteLinks.rawValue ])
        array_table.append(["type" : BudzMapDataType.PaymentMethods.rawValue ])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        
        for _ in self.chooseBudzMap.reviews {
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
//            array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            indexMain = indexMain + 1
        }
        
//        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
            if chooseBudzMap.get_user_review_count == 0{
            array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
            array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
            
            if self.array_Attachment.count < 1 {
                array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
            }
            
            indexMain = 0
            
            for _ in self.array_Attachment{
                array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
                indexMain = indexMain + 1
            }
            
             array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
             array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
            }
            
        }
            
    }
    
    func OthersDataLaod(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])
        array_table.append(["type" : BudzMapDataType.othersImage.rawValue ])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        
        for _ in self.chooseBudzMap.reviews {
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
            //            array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            indexMain = indexMain + 1
        }
        
        //        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
            if chooseBudzMap.get_user_review_count == 0{
                array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
                array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
                
                if self.array_Attachment.count < 1 {
                    array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
                }
                
                indexMain = 0
                
                for _ in self.array_Attachment{
                    array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
                    indexMain = indexMain + 1
                }
                
                array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
                array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
            }
            
        }
    }
    
    func MedicalDataload(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
        array_table.append(["type" : BudzMapDataType.Languages.rawValue ])
         array_table.append(["type" : BudzMapDataType.PaymentMethods.rawValue ])
        array_table.append(["type" : BudzMapDataType.HeadingWithText.rawValue , "index" : 1])
        array_table.append(["type" : BudzMapDataType.HeadingWithText.rawValue , "index" : 2])
        if self.chooseBudzMap.timing.friday == "Closed" && self.chooseBudzMap.timing.monday == "Closed" && self.chooseBudzMap.timing.tuesday == "Closed" && self.chooseBudzMap.timing.wednesday == "Closed" && self.chooseBudzMap.timing.thursday == "Closed" && self.chooseBudzMap.timing.saturday == "Closed" && self.chooseBudzMap.timing.sunday == "Closed"{
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
                array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
            }
        }else{
            array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
        }
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])
        
         array_table.append(["type" : BudzMapDataType.WebsiteLinks.rawValue ])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        for _ in self.chooseBudzMap.reviews {
//            array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
            indexMain = indexMain + 1
        }
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
            if chooseBudzMap.get_user_review_count == 0{
                array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
            array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
            if self.array_Attachment.count < 1 {
                array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
            }

            indexMain = 0
            
            for _ in self.array_Attachment{
                array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
                indexMain = indexMain + 1
            }
            
            array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
            array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
            }
        }
    }
    
    
    func CannabitesDataload(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
        if self.chooseBudzMap.timing.friday == "Closed" && self.chooseBudzMap.timing.monday == "Closed" && self.chooseBudzMap.timing.tuesday == "Closed" && self.chooseBudzMap.timing.wednesday == "Closed" && self.chooseBudzMap.timing.thursday == "Closed" && self.chooseBudzMap.timing.saturday == "Closed" && self.chooseBudzMap.timing.sunday == "Closed"{
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
                array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
            }
        }else{
            array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
        }
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])
        array_table.append(["type" : BudzMapDataType.WebsiteLinks.rawValue ])
        array_table.append(["type" : BudzMapDataType.PaymentMethods.rawValue ])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        for _ in self.chooseBudzMap.reviews {
//            array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
            indexMain = indexMain + 1
        }
        
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
        if chooseBudzMap.get_user_review_count == 0{
            array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
        array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
        if self.array_Attachment.count < 1 {
            array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
        }
        
        indexMain = 0
        
        for _ in self.array_Attachment{
            array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
            indexMain = indexMain + 1
        }
        
        array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
        array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
        }
        }
    }
    
    
    func EntertainmentDataload(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])
        if self.chooseBudzMap.timing.friday == "Closed" && self.chooseBudzMap.timing.monday == "Closed" && self.chooseBudzMap.timing.tuesday == "Closed" && self.chooseBudzMap.timing.wednesday == "Closed" && self.chooseBudzMap.timing.thursday == "Closed" && self.chooseBudzMap.timing.saturday == "Closed" && self.chooseBudzMap.timing.sunday == "Closed"{
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
                array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
            }
        }else{
            array_table.append(["type" : BudzMapDataType.WeekHours.rawValue ])
        }
        array_table.append(["type" : BudzMapDataType.WebsiteLinks.rawValue ])
        array_table.append(["type" : BudzMapDataType.PaymentMethods.rawValue ])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        for _ in self.chooseBudzMap.reviews {
            
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
            indexMain = indexMain + 1
        }
        
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
        if chooseBudzMap.get_user_review_count == 0{
            array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
        array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
        if self.array_Attachment.count < 1 {
            array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
        }
        
        indexMain = 0
        
        for _ in self.array_Attachment{
            array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
            indexMain = indexMain + 1
        }
        
        array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
        array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
        }
        }
    }
    
    func EventDataload(){
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : BudzMapDataType.BudzDescription.rawValue ])
         array_table.append(["type" : BudzMapDataType.BudzEventTime.rawValue ])
        array_table.append(["type" : BudzMapDataType.Location.rawValue ])

        array_table.append(["type" : BudzMapDataType.WebsiteLinks.rawValue ])
        array_table.append(["type" : BudzMapDataType.eventPaymentMethods.rawValue])
        array_table.append(["type" : BudzMapDataType.TotalReviews.rawValue ])
        
        var indexMain = 0
        for _ in self.chooseBudzMap.reviews {
            if indexMain < 2 {
                array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            }
//            array_table.append(["type" : BudzMapDataType.UserReview.rawValue , "index" : indexMain])
            indexMain = indexMain + 1
        }
        
        if chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)! {
            
        }else {
        if chooseBudzMap.get_user_review_count == 0{
            array_table.append(["type" : BudzMapDataType.addYourComment.rawValue ])
        array_table.append(["type" : BudzMapDataType.AddReviewTextview.rawValue ])
        if self.array_Attachment.count < 1 {
            array_table.append(["type" : BudzMapDataType.AddReviewImage.rawValue ])
        }
        
        indexMain = 0
        
        for _ in self.array_Attachment{
            array_table.append(["type" : BudzMapDataType.ImageView.rawValue , "index" : indexMain ])
            indexMain = indexMain + 1
        }
        
        array_table.append(["type" : BudzMapDataType.AddRating.rawValue ])
        array_table.append(["type" : BudzMapDataType.SubmitActionButton.rawValue ])
        }
        }
    }
    
    
    @IBAction func onClickDontShow(_ sender: UIButton) {
  
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            sender.setImage(UIImage(named: "Check_Round_S"), for: UIControlState.normal)
            UserDefaults.standard.set(true, forKey: "BudzPopup")
            UserDefaults.standard.synchronize()
        }
        else{
            sender.setImage(UIImage(named: "Check_Round_U"), for: UIControlState.normal)
            UserDefaults.standard.set(false, forKey: "BudzPopup")
            UserDefaults.standard.synchronize()
        }

    
    }
    func getStateFromZip() {
        self.showLoading()
        NetworkManager.getUserAddressFromZipCode(zipcode: (DataManager.sharedInstance.user?.zipcode)!, completion: { (success, message, response) in
            self.hideLoading()
            self.GetBudzMapInfo()
            print(message)
            print(response ?? "text" )
            print(response!["results"] ?? "text")
            if(success){
                if( ((response!["results"] as! [[String : Any]]).count) > 0){
                    let location =  (response!["results"] as! [[String : Any]])[0]["address_components"] as! [[String: AnyObject]]
                    for lct in location{
                        let st  = lct["long_name"] as! String
                        if self.states.contains(st){
                            self.state = st
                            return
                        }
                    }
                    print(self.state)
                }
            }else{
            }
        })
        
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        
        self.saveView.isHidden = true
    }
    
    @IBAction func closeEditReview(sender: UIButton!){
        if !self.editCommentView.isHidden{
           self.editCommentView.isHidden = true
        }else  if !self.replyEditView.isHidden{
            self.replyEditView.isHidden = true
        }
        
        self.txtCommentTxt = ""
    }
}


extension DispensaryDetailVC  : UITableViewDelegate , UITableViewDataSource {
    
    func RegisterXib(){
        self.tbleViewMain.register(UINib(nibName: "BudzHeaderCell", bundle: nil), forCellReuseIdentifier: "BudzHeaderCell")
        self.tbleViewMain.register(UINib(nibName: "HeaderButtonCell", bundle: nil), forCellReuseIdentifier: "HeaderButtonCell")
        self.tbleViewMain.register(UINib(nibName: "BudzServiceCell", bundle: nil), forCellReuseIdentifier: "BudzServiceCell")
        
        self.tbleViewMain.register(UINib(nibName: "AddSpecialCell", bundle: nil), forCellReuseIdentifier: "AddSpecialCell")
        
        self.tbleViewMain.register(UINib(nibName: "EvnetPaymentMethodsCell", bundle: nil), forCellReuseIdentifier: "EvnetPaymentMethodsCell")
        
        self.tbleViewMain.register(UINib(nibName: "EventPurchaseTicketCell", bundle: nil), forCellReuseIdentifier: "EventPurchaseTicketCell")
        
         self.tbleViewMain.register(UINib(nibName: "EventTicktesCell", bundle: nil), forCellReuseIdentifier: "EventTicktesCell")
        
        
        self.tbleViewMain.register(UINib(nibName: "TextDetailCell", bundle: nil), forCellReuseIdentifier: "TextDetailCell")
        self.tbleViewMain.register(UINib(nibName: "ImageDisplayCell", bundle: nil), forCellReuseIdentifier: "ImageDisplayCell")
        self.tbleViewMain.register(UINib(nibName: "LocationBudzCell", bundle: nil), forCellReuseIdentifier: "LocationBudzCell")
        self.tbleViewMain.register(UINib(nibName: "TimingofOpreationsCell", bundle: nil), forCellReuseIdentifier: "TimingofOpreationsCell")
        self.tbleViewMain.register(UINib(nibName: "SocialMediaLinkCell", bundle: nil), forCellReuseIdentifier: "SocialMediaLinkCell")
        self.tbleViewMain.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        self.tbleViewMain.register(UINib(nibName: "AddCommentHeaderCell", bundle: nil), forCellReuseIdentifier: "AddCommentHeaderCell")
        self.tbleViewMain.register(UINib(nibName: "BudzCommentcell", bundle: nil), forCellReuseIdentifier: "BudzCommentcell")
        self.tbleViewMain.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
        self.tbleViewMain.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.tbleViewMain.register(UINib(nibName: "UploadBudzCell", bundle: nil), forCellReuseIdentifier: "UploadBudzCell")
        self.tbleViewMain.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.tbleViewMain.register(UINib(nibName: "AddRatingcell", bundle: nil), forCellReuseIdentifier: "AddRatingcell")
        self.tbleViewMain.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        self.tbleViewMain.register(UINib(nibName: "BudzProductCell", bundle: nil), forCellReuseIdentifier: "BudzProductCell")
         self.tbleViewMain.register(UINib(nibName: "AddProductCell", bundle: nil), forCellReuseIdentifier: "AddProductCell")

        self.tbleViewMain.register(UINib(nibName: "SpecialBudzCell", bundle: nil), forCellReuseIdentifier: "SpecialBudzCell")

        self.tbleViewMain.register(UINib(nibName: "MedicalLanguagesCell", bundle: nil), forCellReuseIdentifier: "MedicalLanguagesCell")
        
        self.tbleViewMain.register(UINib(nibName: "BudzHeadingWithTextcell", bundle: nil), forCellReuseIdentifier: "BudzHeadingWithTextcell")
     
        
        self.tbleViewMain.register(UINib(nibName: "EventTimingCell", bundle: nil), forCellReuseIdentifier: "EventTimingCell")
           self.tbleViewMain.register(UINib(nibName: "AddNewProductServices", bundle: nil), forCellReuseIdentifier:
            "AddNewProductServices")

        
        self.editCommentTableView.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
        self.editCommentTableView.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.editCommentTableView.register(UINib(nibName: "UploadBudzCell", bundle: nil), forCellReuseIdentifier: "UploadBudzCell")
        self.editCommentTableView.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.editCommentTableView.register(UINib(nibName: "AddRatingcell", bundle: nil), forCellReuseIdentifier: "AddRatingcell")
        self.editCommentTableView.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        
        self.replyEditTableView.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
         self.replyEditTableView.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.replyEditTableView.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        
        self.tbleViewMain.register(UINib(nibName: "NoRecordFoundCell", bundle: nil), forCellReuseIdentifier: "NoRecordFoundCell")

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == editCommentTableView{
            return editTableArray.count
        }else if tableView == replyEditTableView{
            return replyEditTableArray.count
        }else{
            return self.array_table.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? BudzHeaderCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        if tableView == editCommentTableView{
            switch editTableArray[indexPath.row] {
            case "CommentHeader":
                return YourCommentHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "TextView":
                return EnterCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "UploadButton":
                 return UPloadBudzButtonCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "Image":
                return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "AddRating":
                return RatingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "SubmitAction":
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            }

        }else if tableView == replyEditTableView{
            switch replyEditTableArray[indexPath.row] {
            case "CommentHeader":
                return YourCommentHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "TextView":
                return EnterCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "SubmitAction":
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            }
        }else{
        let dictValue = array_table[indexPath.row]
        let dataType = dictValue["type"] as! String
        
        switch dataType  {
            
            
        
        case BudzMapDataType.BudzService.rawValue:
            return BudzServiceCel(tableView:tableView  ,cellForRowAt:indexPath)
            
        
        case BudzMapDataType.BudzProduct.rawValue:
            return StrainProductCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.BudzSpecial.rawValue:
            return SpecialBudzCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.Header.rawValue:
            return Headingxell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.MenuButton.rawValue:
             return HeadingButtonxell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.BudzDescription.rawValue:
            return textDetailCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case BudzMapDataType.Location.rawValue:
            return LcoationCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.addYourComment.rawValue:
            return YourCommentHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case BudzMapDataType.othersImage.rawValue:
            return OtherImageCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.WeekHours.rawValue:
            return TimeCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.WebsiteLinks.rawValue:
            return SocialMediaLinkCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.PaymentMethods.rawValue:
            return PaymentMthodCell(tableView:tableView  ,cellForRowAt:indexPath)

        case BudzMapDataType.TotalReviews.rawValue:
             return CommentHeaderCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.ReviewHeading.rawValue:
            return BudzCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.AddReviewTextview.rawValue:
            return EnterCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.AddReviewImage.rawValue:
            return UPloadBudzButtonCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.ImageView.rawValue:
            return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.AddRating.rawValue:
            return RatingCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.SubmitActionButton.rawValue:
            return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.Languages.rawValue:
            return MedicalLanguagesCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.HeadingWithText.rawValue:
            return BudzHeadingWithTextcell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.BudzEventTime.rawValue:
            return EventTimingcell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.addSpecial.rawValue:
            return AddSpecialCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.NoRecord.rawValue:
            return NoRecodFoundCell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.addProductServices.rawValue:
            return addNewProductServices(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.NoRecordtext.rawValue:
            return NoRecodFoundCellText(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.eventPaymentMethods.rawValue:
            return EventTicketPaymentMethods(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.evnetPurchaseTicketCell.rawValue:
            return EventPurchaseTicketCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.eventTicktes.rawValue:
            return EventTicktesCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        default: //BudzMapDataType.UserReview.rawValue
            return BudzCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        }
    }
    
    func EventTicktesCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTicktesCell") as! EventTicktesCell
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        cell.baseVc = self
        cell.chooseBudzMap = self.chooseBudzMap
        if indexMain == 0 {
            cell.heading.isHidden = false
            cell.heading_hight.constant = 21
            cell.image_top.constant = 10
            cell.layoutIfNeeded()
        }else{
            cell.heading.isHidden = true
            cell.heading_hight.constant = 0
            cell.image_top.constant = 10
            cell.layoutIfNeeded()
        }
        cell.tickt = self.budz_tickets[indexMain]
        cell.setData()
        cell.btn_delete.tag = indexMain
        cell.btn_delete.addTarget(self, action: #selector(self.deleteTicket), for: .touchUpInside)
        cell.btn_edit.tag = indexMain
        cell.btn_edit.addTarget(self, action: #selector(self.editTicke), for: .touchUpInside)
        cell.selectionStyle  = .none
        return cell
    }
    @objc func deleteTicket(sender: UIButton){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this ticket?") { (isDel, test) in
            if(isDel){
                let id  =  self.budz_tickets[sender.tag].id
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: "delete_budz_ticket/\(id)", completion: { (successResponse, messageResponse, DataResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (DataResponse["status"] as! String) == "success" {
                            isProductAdded = true
                            self.refreshTabs(isSound: false)
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
                
            }
        }
    }
    @objc func editTicke(sender: UIButton){
        self.onClickUpdateTicket(ticket: self.budz_tickets[sender.tag])
        
    }
    func EventPurchaseTicketCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventPurchaseTicketCell") as! EventPurchaseTicketCell
        cell.purchase = {
            self.onClickAddNewEvent()
        }
        cell.selectionStyle  = .none
        return cell
    }
    func EventTicketPaymentMethods(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvnetPaymentMethodsCell") as! EvnetPaymentMethodsCell
        print(self.paymentMethodsArray)
        if self.paymentMethodsArray.count == 0{
         cell.noPaymentLabel.isHidden = false
         cell.collection_view.isHidden = true
        }else{
        cell.noPaymentLabel.isHidden = true
        cell.collection_view.isHidden = false
        cell.array = self.paymentMethodsArray
        cell.collection_view.reloadData()
        cell.selectionStyle  = .none
        }
        return cell
    }
    
    func AddSpecialCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSpecialCell") as! AddSpecialCell
        cell.add_btn.addTarget(self, action: #selector(onClickAddNewSpeical), for: UIControlEvents.touchUpInside)
        cell.selectionStyle  = .none
        return cell
    }
    
    func onClickAddNewSpeical(sender:UIButton){
        let storyboard = UIStoryboard(name: "ShoutOut", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "AddNewSpecialVC") as! AddNewSpecialVC
        customAlert.delegate = self
        customAlert.budz_id = "\(self.chooseBudzMap.id)"
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    func NoRecodFoundCellText(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordFoundCell") as! NoRecordFoundCell
        if(self.showTag == 1) {
            cell.textDisplay.text = "No Prodcuts Found!"
        }else {
            cell.textDisplay.text = "No Record Found!"
        }
        return cell
    }
    func NoRecodFoundCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
//        if self.isFromMyBudzMap{
//            if  !self.isSpecailTapped {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductCell") as! AddProductCell
//                    cell.productHandler = {
//                        self.addProductView.isHidden = false
//                    }
//                    return cell
//                } else {
//
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordFoundCell") as! NoRecordFoundCell
//
//                }
//        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordFoundCell") as! NoRecordFoundCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductCell") as! AddProductCell
        cell.productHandler = {
            self.onClickAddNewProduct()

        }
        return cell
    
    }
    func addNewProductServices(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewProductServices") as! AddNewProductServices
        cell.productHandler = {
            self.onClickAddNewProduct()
        }
        cell.servicesHandler = {
            self.onClickAddNewServices()
        }
        return cell
    }
    func onClickAddNewServices(){
        let customAlert = AddNewServicesVC.addNewService(id  : self.chooseBudzMap.id , delegate: self)
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    
    func onClickAUpdateServices(selected_service : BudzMapServices){
        let customAlert = AddNewServicesVC.updateData(id:  self.chooseBudzMap.id, services: selected_service, delegate: self)
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    
    func onClickAddNewProduct(){
        let customAlert = AddNewProductVC.addNewProduct(strains: self.strain_Array , id  : self.chooseBudzMap.id , delegate: self)
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    
    func onClickUpdateProduct(product  : StrainProduct){
        let customAlert = AddNewProductVC.updateData(strains:  self.strain_Array, id: self.chooseBudzMap.id, product: product, delegate: self)
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    
    
    
    func onClickAddNewEvent(){
        let customAlert = AddNewEventVC.addNewEvent(id : self.chooseBudzMap.id , delegate: self)
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    
    func onClickUpdateTicket(ticket  : Ticktes){
        let customAlert = AddNewEventVC.updateData(id: self.chooseBudzMap.id, ticket: ticket, delegate: self)
        
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    //MARK:
    //MARK: Headingxell
    func Headingxell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeading = tableView.dequeueReusableCell(withIdentifier: "BudzHeaderCell") as! BudzHeaderCell
        
        self.cellMain = cellHeading
        cellHeading.view_Edit.isHidden = true
        if  self.headerBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!) {
            cellHeading.view_Edit.isHidden = false
            cellHeading.view_Message.isHidden = true
        }else{
             cellHeading.view_Message.isHidden = false
            if (self.headerBudzMap.isFlagged > 0){
               cellHeading.imgView_Flag.image = #imageLiteral(resourceName: "ic_flag_budz")
            }else {
                cellHeading.imgView_Flag.image = #imageLiteral(resourceName: "flag_white")
               

            }
        }
        if(self.chooseBudzMap.budzMapType.idType == 9){
            cellHeading.btnGalleryView.isHidden = true
        }else {
            cellHeading.btnGalleryView.isHidden = false
        }
        cellHeading.btnReviewBottom.addTarget(self, action: #selector(GoBottom), for: UIControlEvents.touchUpInside)
        cellHeading.btnFlag.addTarget(self, action: #selector(ReportBudz(sender:)), for: UIControlEvents.touchUpInside)
        cellHeading.btnMessage.addTarget(self, action: #selector(onClickStartChat), for: UIControlEvents.touchUpInside)
        cellHeading.btnLike.tag = indexPath.row
       cellHeading.btnLike.addTarget(self, action: #selector(like_bud), for: UIControlEvents.touchUpInside)

        if self.headerBudzMap.get_user_save_count == 0 {
            cellHeading.btnLike.isSelected = false
            cellHeading.imgView_Like.image = UIImage.init(named: "Heart_White")
        }else {
            cellHeading.btnLike.isSelected = true
            cellHeading.imgView_Like.image = UIImage.init(named: "Heart_Filled")
        }
        
        cellHeading.btnBack.addTarget(self, action: #selector(BackAction), for: UIControlEvents.touchUpInside)
         cellHeading.btnHome.addTarget(self, action: #selector(GO_Home_ACtion), for: UIControlEvents.touchUpInside)
         cellHeading.btnGallery.addTarget(self, action: #selector(OpenGallery), for: UIControlEvents.touchUpInside)
        
        cellHeading.btnEdit.isHidden = false
        cellHeading.btnEdit.addTarget(self, action: #selector(EditBudzMAp), for: UIControlEvents.touchUpInside)
        
        cellHeading.btnShare.addTarget(self, action: #selector(self.shareActionMainBudz), for: UIControlEvents.touchUpInside)
        
        cellHeading.lblName.text = self.headerBudzMap.title
        if self.headerBudzMap.banner.count > 2
        {
            cellHeading.imgView_BG.moa.url = WebServiceName.images_baseurl.rawValue + self.headerBudzMap.banner.RemoveSpace()
        }else {
            cellHeading.imgView_BG.image = #imageLiteral(resourceName: "budz_bg_df")
        }
        if self.chooseBudzMap.banner.count > 2 || self.chooseBudzMap.images.count > 0 {
            cellHeading.collectionView.isHidden = false
        }else {
            cellHeading.collectionView.isHidden = true
        }
        
        
        if self.headerBudzMap.logo.count > 2 {
            cellHeading.imgView_Logo.moa.url = WebServiceName.images_baseurl.rawValue + self.headerBudzMap.logo.RemoveSpace()
        }else {
            switch Int(self.headerBudzMap.business_type_id)! {
            case 1 ,2:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
                break
                
            case 3:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
                break
            case 4:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
                break
            case 5:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Event.rawValue)
                break
            case 6:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Medical.rawValue)
                break
            case 7:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Medical.rawValue)
                break
            case 9:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Others.rawValue)
                break
            default:
                cellHeading.imgView_Logo.image = UIImage.init(named: BudzIcon.Medical.rawValue)
                break
                
            }
        }
        
        cellHeading.btn_Next.addTarget(self, action: #selector(self.nextsliderImage), for: UIControlEvents.touchUpInside)
        cellHeading.btn_Previous.addTarget(self, action: #selector(self.previousSliderImage), for: UIControlEvents.touchUpInside)
        cellHeading.lblReview.text = String(self.headerBudzMap.reviews.count) + " Reviews"
        cellHeading.view_Organic.isHidden = false
        cellHeading.view_Delivery.isHidden = false
        
        if self.headerBudzMap.is_organic == "0" {
            cellHeading.view_Organic.isHidden = true
        }
        
        if self.headerBudzMap.is_delivery == "0" {
            cellHeading.view_Delivery.isHidden = true
        }
        if self.chooseBudzMap.images.count == 0 {
            cellHeading.btn_Next.isHidden = true
            cellHeading.btn_Previous.isHidden = true
        }else{
            cellHeading.btn_Next.isHidden = false
            cellHeading.btn_Previous.isHidden = false
        }
        cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starUnfilled")
        cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "starUnfilled")
        cellHeading.imgView_Star3.image = #imageLiteral(resourceName: "starUnfilled")
        cellHeading.imgView_Star4.image = #imageLiteral(resourceName: "starUnfilled")
        cellHeading.imgView_Star5.image = #imageLiteral(resourceName: "starUnfilled")

        
        print(self.chooseBudzMap.rating_sum)
        
        if self.chooseBudzMap.rating_sum == nil {
            self.chooseBudzMap.rating_sum = "1.0"
        }else if self.chooseBudzMap.rating_sum.characters.count == 0 {
            self.chooseBudzMap.rating_sum = "1.0"
        }
        

        if let ratingSum = Double(self.chooseBudzMap.rating_sum)    {

            
            if ratingSum < 1    {
                if ratingSum > 0 {
                    cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "half_star")
                }
            }
            else if ratingSum < 2   {
                cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starFilled")
                if ratingSum >= 1.1 {
                    cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "half_star")
                    
                }
            }
            else if ratingSum < 3   {
                cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "starFilled")
                if ratingSum >= 2.1 {
                    cellHeading.imgView_Star3.image = #imageLiteral(resourceName: "half_star")
                    
                }
            }
            else if ratingSum < 4   {
                cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star3.image = #imageLiteral(resourceName: "starFilled")
                if ratingSum >= 3.1 {
                    cellHeading.imgView_Star4.image = #imageLiteral(resourceName: "half_star")
                    
                }
            }
            else if ratingSum < 5   {
                cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star3.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star4.image = #imageLiteral(resourceName: "starFilled")
                if ratingSum >= 4.1 {
                    cellHeading.imgView_Star5.image = #imageLiteral(resourceName: "half_star")
                    
                }
            }
            else {
                cellHeading.imgView_Star1.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star2.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star3.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star4.image = #imageLiteral(resourceName: "starFilled")
                cellHeading.imgView_Star5.image = #imageLiteral(resourceName: "starFilled")
            }
        }
       
        cellHeading.selectionStyle = .none
        return cellHeading
    }
    
    
    func shareActionMainBudz(sender : UIButton){
        var parmas = [String: Any]()
          parmas["sub_user_id"] = "\(self.chooseBudzMap.id)"
        //sub_user_id
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_budzmap_share.rawValue, params: parmas as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            
        }
        parmas["id"] = "\(self.chooseBudzMap.id)"
        parmas["type"] = "Budz"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    func ShareActionReview(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.chooseBudzMap.reviews[sender.tag].id)"
        parmas["type"] = "Budz Reviews"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"//"get-budz-review/\(self.chooseBudzMap.reviews[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    @objc func deleteProduct(sender: UIButton){
//        /array_Product
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this product?") { (isDel, test) in
            if(isDel){
                let id  =  self.array_Product[sender.tag].ID
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: "delete_product/\(id)", completion: { (successResponse, messageResponse, DataResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (DataResponse["status"] as! String) == "success" {
                            isProductAdded = true
                             self.refreshTabs(isSound: false)
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
                
            }
        }
    }
    @objc func editProduct(sender: UIButton){
        isProductAdded = true
        self.onClickUpdateProduct(product: self.array_Product[sender.tag])
    }
    func StrainProductCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellStrainBud = tableView.dequeueReusableCell(withIdentifier: "BudzProductCell") as! BudzProductCell
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int

        
        if self.array_Product[indexMain].isTitle {
            cellStrainBud.lblSectionName.text = self.array_Product[indexMain].titleDisplay

            cellStrainBud.lblSectionName.isHidden = false
            cellStrainBud.lblSectionNameConstraint.constant = 20
            cellStrainBud.lblConstraintView.constant = 30
//            cellStrainBud.lblConstraintViewMain.constant = 152
        }else {

            cellStrainBud.lblSectionName.text = self.array_Product[indexMain].titleDisplay
            cellStrainBud.lblSectionName.isHidden = true
            cellStrainBud.lblSectionNameConstraint.constant = 0
            cellStrainBud.lblConstraintView.constant = 10
//            cellStrainBud.lblConstraintViewMain.constant = 121
//           let previous_product = self.array_Product[indexMain -  1]
//            if self.array_Product[indexMain].straintype?.title != previous_product.straintype?.title{
//                cellStrainBud.lblSectionName.text = self.array_Product[indexMain].straintype?.title
//                cellStrainBud.lblSectionName.isHidden = false
//                cellStrainBud.lblSectionNameConstraint.constant = 20
//                cellStrainBud.lblConstraintView.constant = 30
//                cellStrainBud.lblConstraintViewMain.constant = 152
//            }else{
//                cellStrainBud.lblSectionName.isHidden = true
//                cellStrainBud.lblSectionNameConstraint.constant = 0
//                cellStrainBud.lblConstraintView.constant = 10
//                cellStrainBud.lblConstraintViewMain.constant = 121
//            }

           
        }
        cellStrainBud.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellStrainBud.img_edit.image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
        cellStrainBud.img_edit.tintColor = .white
        if(self.chooseBudzMap.user_id != Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!){
            cellStrainBud.edit_height.constant = 0
            cellStrainBud.edit_display.isHidden = true
        }else {
            cellStrainBud.edit_height.constant = 40
            cellStrainBud.edit_display.isHidden = false
        }
        
        cellStrainBud.btn_delete_product.tag = indexMain
        cellStrainBud.btn_delete_product.addTarget(self, action: #selector(self.deleteProduct), for: .touchUpInside)
        cellStrainBud.btn_edit_product.tag = indexMain
        cellStrainBud.btn_edit_product.addTarget(self, action: #selector(self.editProduct), for: .touchUpInside)
        if self.array_Product[indexMain].isAlsoStrain && (self.array_Product[indexMain].straintype?.title.count)! > 0{
            cellStrainBud.btnDetail.isHidden = false
            cellStrainBud.strainLeaf.isHidden = false
            cellStrainBud.strainArrow.isHidden = false
        }else{
            cellStrainBud.btnDetail.isHidden = true
            cellStrainBud.strainLeaf.isHidden = true
            cellStrainBud.strainArrow.isHidden = true
        }
//        if self.array_Product[indexMain].titleDisplay == "Indica" || self.array_Product[indexMain].titleDisplay == "Hybrid" || self.array_Product[indexMain].titleDisplay == "Sativa"{
//            cellStrainBud.btnDetail.isHidden = false
//            cellStrainBud.strainLeaf.isHidden = false
//            cellStrainBud.strainArrow.isHidden = false
//        }else{
//            cellStrainBud.btnDetail.isHidden = true
//            cellStrainBud.strainLeaf.isHidden = true
//            cellStrainBud.strainArrow.isHidden = true
//        }
        if (self.array_Product[indexMain].cbd.count > 0 && self.array_Product[indexMain].thc.count > 0){
            cellStrainBud.lblCBD.text = self.array_Product[indexMain].cbd + "% CBD | "
            cellStrainBud.lblTHC.text = self.array_Product[indexMain].thc + "% THC"
        }else {
            if (self.array_Product[indexMain].cbd.count > 0) {
                if (self.array_Product[indexMain].thc.count > 0) {
                cellStrainBud.lblCBD.text = self.array_Product[indexMain].cbd + "% CBD |"
                }else{
                cellStrainBud.lblCBD.text = self.array_Product[indexMain].cbd + "% CBD  "
                }
            }else {
                cellStrainBud.lblCBD.text = self.array_Product[indexMain].cbd
            }
            if (self.array_Product[indexMain].thc.count > 0) {
                cellStrainBud.lblTHC.text = self.array_Product[indexMain].thc + "% THC"
            }else {
                cellStrainBud.lblTHC.text = self.array_Product[indexMain].thc
            }
            
            
            
        }
        cellStrainBud.lblName.text = self.array_Product[indexMain].name
        print(self.array_Product[indexMain].images.count)
         cellStrainBud.imageCountImage.image = #imageLiteral(resourceName: "budz_map_images_counter_bg").withRenderingMode(.alwaysTemplate)
        cellStrainBud.imageCountImage.tintColor = UIColor.white
        if self.array_Product[indexMain].images.count > 1{
            if self.array_Product[indexMain].images.count > 1 && self.array_Product[indexMain].images.count <= 3{
                cellStrainBud.lblCount.text = "1+"
            }else if self.array_Product[indexMain].images.count > 3{
                cellStrainBud.lblCount.text = "3+"
            }else{
                cellStrainBud.lblCount.text = String(self.array_Product[indexMain].images.count)
            }
        cellStrainBud.imageCountImage.isHidden = false
        cellStrainBud.lblCount.isHidden = false
        }else{
        cellStrainBud.lblCount.isHidden = true
        cellStrainBud.imageCountImage.isHidden = true
        }
//        cellStrainBud.lblCount.text = "1"
        //&& self.array_Product[indexMain].titleDisplay != "Others"
        if (self.array_Product[indexMain].straintype?.title.count)! > 2 {
            cellStrainBud.lblType.text = self.array_Product[indexMain].straintype?.title
            
        }else{
            cellStrainBud.lblType.text = ""
        }
        
        if cellStrainBud.lblType.text == "Hybrid"{
        cellStrainBud.strainTypeView.isHidden = false
        cellStrainBud.hybridViewWidth.constant = 17
        cellStrainBud.strainTypeView.borderWidth = 1
        cellStrainBud.strainTypeView.borderColor = UIColor.init(hex: "7cc244")
        cellStrainBud.strainTypeLabel.textColor = UIColor.init(hex: "7cc244")
        cellStrainBud.strainTypeLabel.text = "H"
        }else if cellStrainBud.lblType.text == "Indica"{
            cellStrainBud.strainTypeView.isHidden = false
            cellStrainBud.hybridViewWidth.constant = 17
            cellStrainBud.strainTypeView.borderWidth = 1
            cellStrainBud.strainTypeView.borderColor = UIColor.init(hex: "ae59c2")
            cellStrainBud.strainTypeLabel.textColor = UIColor.init(hex: "ae59c2")
            cellStrainBud.strainTypeLabel.text = "I"
        }else if cellStrainBud.lblType.text == "Sativa"{
            cellStrainBud.strainTypeView.isHidden = false
            cellStrainBud.hybridViewWidth.constant = 17
            cellStrainBud.strainTypeView.borderWidth = 1
            cellStrainBud.strainTypeView.borderColor = UIColor.init(hex: "c24462")
            cellStrainBud.strainTypeLabel.textColor = UIColor.init(hex: "c24462")
            cellStrainBud.strainTypeLabel.text = "S"
        }else{
        cellStrainBud.strainTypeView.isHidden = true
        cellStrainBud.hybridViewWidth.constant = 0
        }
         cellStrainBud.lblDistance.text = ""
        cellStrainBud.imgViewMain.image = #imageLiteral(resourceName: "pictureplaceholder")
        if self.array_Product[indexMain].images.count > 0 {
            let img_url = WebServiceName.images_baseurl.rawValue + (self.array_Product[indexMain].images.first?.image)!
            print(img_url)
            cellStrainBud.imgViewMain.sd_setImage(with: URL.init(string: img_url), completed: nil)
            
        }else{
           cellStrainBud.imgViewMain.image = #imageLiteral(resourceName: "pictureplaceholder")
        }
        //pictureplaceholder
        cellStrainBud.btnShare.tag = indexMain
        cellStrainBud.btnShare.addTarget(self, action: #selector(self.ShareActionProduct), for: .touchUpInside)
        
        cellStrainBud.btnDetail.tag = indexMain
        cellStrainBud.btnDetail.addTarget(self, action: #selector(self.DetailAction), for: .touchUpInside)
        cellStrainBud.btn_image.tag = indexMain
        cellStrainBud.btn_image.addTarget(self, action: #selector(self.onClickShowImages(sender:)), for: .touchUpInside)
        
        cellStrainBud.viewFirst.isHidden = true
        cellStrainBud.viewSecond.isHidden = true
        cellStrainBud.viewThird.isHidden = true
        cellStrainBud.viewFourth.isHidden = true
        
        
        
        
        if self.array_Product[indexMain].priceArray.count > 0 {
            cellStrainBud.viewFirst.isHidden = false
            cellStrainBud.lblPrice_1.text = "$" + self.array_Product[indexMain].priceArray[0].price
            cellStrainBud.lblWeight_1.text = self.array_Product[indexMain].priceArray[0].weight
        }
        
        if self.array_Product[indexMain].priceArray.count > 1 {
            cellStrainBud.viewSecond.isHidden = false
            cellStrainBud.lblPrice_2.text = "$" + self.array_Product[indexMain].priceArray[1].price
            cellStrainBud.lblWeight_2.text = self.array_Product[indexMain].priceArray[1].weight
        }
        
        if self.array_Product[indexMain].priceArray.count > 2 {
            cellStrainBud.viewThird.isHidden = false
            cellStrainBud.lblPrice_3.text = "$" + self.array_Product[indexMain].priceArray[2].price
            cellStrainBud.lblWeight_3.text = self.array_Product[indexMain].priceArray[2].weight
        }
        
        if self.array_Product[indexMain].priceArray.count > 3 {
            cellStrainBud.viewFourth.isHidden = false
            cellStrainBud.lblPrice_4.text = "$" + self.array_Product[indexMain].priceArray[3].price
            cellStrainBud.lblWeight_4.text = self.array_Product[indexMain].priceArray[3].weight
        }
        
        cellStrainBud.selectionStyle = .none
        return cellStrainBud
    }
    
    func onClickShowImages(sender : UIButton)  {
        let product  = self.array_Product[sender.tag].images
        var images_url : [String] =  [String]()
        for prdt in product {
            images_url.append(prdt.image)
        }
        if images_url.count > 0 {
             self.showImagess(attachments: images_url)
        }
    }
    
    func Likereview(sender : UIButton){
        var test = self.chooseBudzMap.reviews[sender.tag]
        var param = [String : Any] ()
        if(test.is_reviewed_count == "0"){
            //TODO FOR LIKE
            self.chooseBudzMap.reviews[sender.tag].is_reviewed_count = "1"
            self.chooseBudzMap.reviews[sender.tag].likes_count = self.chooseBudzMap.reviews[sender.tag].likes_count + 1
            param["like_val"] = "1" as AnyObject
        }else {
            self.chooseBudzMap.reviews[sender.tag].is_reviewed_count = "0"
            self.chooseBudzMap.reviews[sender.tag].likes_count = self.chooseBudzMap.reviews[sender.tag].likes_count - 1
            param["like_val"] = "0" as AnyObject
            //TODO FOR DISLIKE
        }
        param["review_id"] = test.id as AnyObject
        param["budz_id"] = self.chooseBudzMap.id as AnyObject
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: "add_budz_review_like", params: param as [String:AnyObject]) { (success, message, response) in
            self.hideLoading()
            print(success)
            
            print(message)
            print(response)
            if(success){
                self.tbleViewMain.reloadData()
            }
        }
    }
    
    
    func onClickShowImagesServices(sender : UIButton)  {
        var images_url : [String] =  [String]()
         images_url.append(self.array_Services[sender.tag].image)
        if images_url.count > 0 {
            self.showImagess(attachments: images_url)
        }
    }
    
    
    func DetailAction(sender : UIButton){
        isRefreshDataOnWillAppear = false
        self.showLoading()
        let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_strain_detail.rawValue + self.array_Product[sender.tag].strain_id) { (success, message, dataMain) in
            self.hideLoading()
            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
                    if  let chooseStrain = Mapper<Strain>().map(JSONObject: dataMain["successData"]! as? [String : Any]){
                        if let strain = chooseStrain.strain{
                             detailView.chooseStrain = strain
                            print(NSNumber.init(value: Int(self.array_Product[sender.tag].ID)!))
                            self.navigationController?.pushViewController(detailView, animated: true)
                        }else{
                            self.ShowErrorAlert(message:"Invalid Response Received From Server!")
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
    
    //MARK:
    //MARK: HeadingButtonxell
    func HeadingButtonxell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellBtnHeading = tableView.dequeueReusableCell(withIdentifier: "HeaderButtonCell") as! HeaderButtonCell
        
        cellBtnHeading.lblLeft.text = "Business Info"
        cellBtnHeading.lblMiddel.text = "Product/Services"
        cellBtnHeading.lblRight.text = "Specials"
        cellBtnHeading.btnLeft.addTarget(self, action: #selector(LeftButtonAction), for: UIControlEvents.touchUpInside)
        if self.chooseBudzMap.is_featured != 1{
            if (self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!) {
                cellBtnHeading.viewMiddel.isUserInteractionEnabled = true
                cellBtnHeading.viewRight.isUserInteractionEnabled = true
                cellBtnHeading.lblMiddel.isHidden = false
                cellBtnHeading.line.isHidden = false
                cellBtnHeading.lblRight.isHidden = false
            }else{
                cellBtnHeading.viewMiddel.isUserInteractionEnabled = false
                cellBtnHeading.viewRight.isUserInteractionEnabled = false
                cellBtnHeading.lblMiddel.isHidden = true
                cellBtnHeading.lblRight.isHidden = true
                cellBtnHeading.line.isHidden = true
                cellBtnHeading.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
                cellBtnHeading.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
            }
        }else{
           
            cellBtnHeading.viewMiddel.isUserInteractionEnabled = true
            cellBtnHeading.viewRight.isUserInteractionEnabled = true
            cellBtnHeading.lblMiddel.isHidden = false
             cellBtnHeading.line.isHidden = false
            cellBtnHeading.lblRight.isHidden = false
        }
        
        cellBtnHeading.btnRight.addTarget(self, action: #selector(RightButtonAction), for: UIControlEvents.touchUpInside)

        cellBtnHeading.btnMiddel.addTarget(self, action: #selector(MiddelButtonAction), for: UIControlEvents.touchUpInside)
        if self.chooseBudzMap.budzMapType.idType == 3 {
              cellBtnHeading.lblMiddel.text = "Menu"
            }else if self.chooseBudzMap.budzMapType.idType == 5 {
              cellBtnHeading.lblMiddel.text = "Price/Tickets"
        }else {
              cellBtnHeading.lblMiddel.text = "Product/Services"
        }
        cellBtnHeading.selectionStyle = .none
        return cellBtnHeading
    }
    
    
    //MARK:
    //MARK: Detail Text
    func textDetailCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellTextDetail = tableView.dequeueReusableCell(withIdentifier: "TextDetailCell") as! TextDetailCell
        let disc = self.chooseBudzMap.budz_map_description.RemoveHTMLTag()
         cellTextDetail.lblDetailText.applyTag(baseVC: self , mainText:  disc)
         cellTextDetail.lblDetailText.text = disc
         cellTextDetail.selectionStyle = .none
        return cellTextDetail
    }
    
    
    
    func BudzServiceCel(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellService = tableView.dequeueReusableCell(withIdentifier: "BudzServiceCell") as! BudzServiceCell
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        if indexMain == 0 {
            cellService.lblSectionName.isHidden = false
            cellService.lblSectionNameConstraint.constant = 20
//            cellService.lblConstraintViewMain.constant = 137
        }else {
            cellService.lblSectionName.isHidden = true
            cellService.lblSectionNameConstraint.constant = 0
//            cellService.lblConstraintViewMain.constant = 137
        }
        cellService.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellService.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellService.img_edit.image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
        cellService.img_edit.tintColor = .white
        if(self.chooseBudzMap.user_id != Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!){
            cellService.edit_height.constant = 0
            cellService.edit_diplsay.isHidden = true
        }else {
            cellService.edit_height.constant = 40
            cellService.edit_diplsay.isHidden = false
        }
        cellService.btn_delete.tag = indexMain
        cellService.btn_delete.addTarget(self, action: #selector(self.deleteService), for: .touchUpInside)
        cellService.btn_edit.tag = indexMain
        cellService.btn_edit.addTarget(self, action: #selector(self.editService), for: .touchUpInside)
        cellService.lblName.text = self.array_Services[indexMain].name
        cellService.lblDescription.text = "$" + String(self.array_Services[indexMain].charges)
        cellService.btnShare.tag = indexMain
        cellService.btnShare.addTarget(self, action:  #selector(ShareActionService(sender:)), for: UIControlEvents.touchUpInside)
           cellService.imgViewMain.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Services[indexMain].image.RemoveSpace()

        cellService.btn_img.tag = indexMain
        cellService.btn_img.addTarget(self, action: #selector(self.onClickShowImagesServices(sender:)), for: .touchUpInside)
        
        cellService.selectionStyle = .none
        return cellService
    }
    
    @objc func deleteService(sender:UIButton){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this service?") { (isDel, test) in
            if(isDel){
                let id  =  self.array_Services[sender.tag].id
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: "delete_budz_service/\(id)", completion: { (successResponse, messageResponse, DataResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (DataResponse["status"] as! String) == "success" {
                            isProductAdded = true
                            self.refreshTabs(isSound: false)
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
                
            }
        }
    }
    @objc func editService(sender:UIButton){
        self.onClickAUpdateServices(selected_service: self.array_Services[sender.tag])
    }
    //MARK:
    //MARK: Detail Text
    func MedicalLanguagesCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellTextDetail = tableView.dequeueReusableCell(withIdentifier: "MedicalLanguagesCell") as! MedicalLanguagesCell
        
        
        cellTextDetail.lblLanguage.text = ""
        
        var language = ""
        for indexObj in self.chooseBudzMap.languageArray {
            
            if language == "" {
                language =  indexObj.language_name
            }else {
                language = language  + " , " + indexObj.language_name
            }
            
        }
        
        cellTextDetail.lblLanguage.text = language
        
        if self.chooseBudzMap.Insurance_accepted == 1 {
            cellTextDetail.lblInsuranceAccepted.text = "Yes"
        }else {
            cellTextDetail.lblInsuranceAccepted.text = "No"
        }
        
        cellTextDetail.selectionStyle = .none
        return cellTextDetail
    }
    
    
    func BudzHeadingWithTextcell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellTextDetail = tableView.dequeueReusableCell(withIdentifier: "BudzHeadingWithTextcell") as! BudzHeadingWithTextcell
        
        
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        if indexMain == 1 {
            cellTextDetail.lblHeading.text = "Office Policies & Information"
            cellTextDetail.lblDescription.text = self.chooseBudzMap.office_Policies
        }else {
            cellTextDetail.lblHeading.text = "Pre-Visit Requirements"
            cellTextDetail.lblDescription.text = self.chooseBudzMap.visit_Requirements
        }
        
        cellTextDetail.selectionStyle = .none
        return cellTextDetail
    }
    
    //MARK:
    //MARK: Budz Event Cell
    func EventTimingcell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellTextDetail = tableView.dequeueReusableCell(withIdentifier: "EventTimingCell") as! EventTimingCell
        
        cellTextDetail.lblDate.text = ""
        for indexObj in self.chooseBudzMap.EventTime{
            cellTextDetail.lblDate.text = indexObj.dateMain.GetDateWith(formate: "EEEE, MMMM d,yyyy", inputFormat: "yyyy-MM-dd") + "\n"
             cellTextDetail.lblTime.text = indexObj.fromTime + " - " + indexObj.toTime + "\n"
        }
        
//        let dictValue = array_table[indexPath.row]
//        let indexMain = dictValue["index"] as! Int
//
//        if indexMain == 1 {
//            cellTextDetail.lblHeading.text = "Office Policies & Information"
//            cellTextDetail.lblDescription.text = self.chooseBudzMap.office_Policies
//        }else {
//            cellTextDetail.lblHeading.text = "Pre-Visit Requirements"
//            cellTextDetail.lblDescription.text = self.chooseBudzMap.visit_Requirements
//        }
        
        cellTextDetail.selectionStyle = .none
        return cellTextDetail
    }
    
    
    //MARK:
    //MARK: Location Cell
    func LcoationCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let celllocation = tableView.dequeueReusableCell(withIdentifier: "LocationBudzCell") as! LocationBudzCell
        
        celllocation.LblLocation.text = self.chooseBudzMap.location
        if self.chooseBudzMap.email.count > 0 {
            celllocation.LblWebsite.applyTag(baseVC: self , mainText:self.chooseBudzMap.email )
            celllocation.LblWebsite.text = self.chooseBudzMap.email
        }else {
            celllocation.LblWebsite.text = "Not Available"
        }
       
        if self.chooseBudzMap.phon_number.count > 0 {
          celllocation.lblPhone.text = self.chooseBudzMap.phon_number
        }else {
            celllocation.lblPhone.text = "No phone number added."
        }
       
        celllocation.LblWebsite.attributedText = celllocation.LblWebsite.text?.setUnderline()
        celllocation.btnWebsite.tag = 1
        celllocation.btnCall.addTarget(self, action: #selector(CallPhoneNumber), for: UIControlEvents.touchUpInside)
        
         celllocation.btnLocation.addTarget(self, action: #selector(openMap), for: UIControlEvents.touchUpInside)
        
       
        
        if self.chooseBudzMap.budzMapType.idType == 2 {
            celllocation.btnProducts.isHidden = true
            celllocation.btnProductHeight.constant = 0
        } else {
            if self.chooseBudzMap.is_featured == 1 {
                celllocation.btnProductHeight.constant = 30
                celllocation.btnProducts.isHidden = false
                
            }else {
                celllocation.btnProducts.isHidden = true
                celllocation.btnProductHeight.constant = 0
            }
        }
        
        
        if self.chooseBudzMap.budzMapType.idType == 3 {
          celllocation.btnProducts.setTitle("View Menu", for: .normal)
            
        }
        if self.chooseBudzMap.budzMapType.idType == 5 {
            celllocation.btnProducts.setTitle("View Prices & Tickets", for: .normal)
        }
        
         celllocation.btnProducts.addTarget(self, action: #selector(showProducts), for: UIControlEvents.touchUpInside)
        celllocation.viewLocationIcon.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
        celllocation.btnWebsite.addTarget(self, action: #selector(openEmail), for: UIControlEvents.touchUpInside)
        celllocation.btnWebsite.isHidden = false
        celllocation.selectionStyle = .none
        return celllocation
    }
    
    
    func openEmail()  {
        print(self.chooseBudzMap.email)
        if(self.chooseBudzMap.email.count>0){
            self.sendEmail(email: self.chooseBudzMap.email)
        }
    }
    
    
    func openMap()  {
        let address = self.chooseBudzMap.location
        let url_string = "http://maps.apple.com/maps?address=\(address.replacingOccurrences(of: " ", with: "") )"
        if let url = URL(string: url_string) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //MARK:
    //MARK: Timing of Opreations Cell
    
    func TimeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellTime = tableView.dequeueReusableCell(withIdentifier: "TimingofOpreationsCell") as! TimingofOpreationsCell
        
        var weeksCheck = 0
        
        
        if self.chooseBudzMap.timing.saturday == "Closed" {
            cellTime.lblSaturday_Time.text = "Closed"
            cellTime.lblSaturdayHeight.constant = 0
            cellTime.lblSaturdayHeight_time.constant = 0
            cellTime.satTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblSaturday_Time.text = self.chooseBudzMap.timing.saturday + " - " + self.chooseBudzMap.timing.sat_end
        }
        
        if self.chooseBudzMap.timing.sunday == "Closed" {
            cellTime.lblSunday_Time.text = "Closed"
            cellTime.lblSundayHeight.constant = 0
            cellTime.lblSundayHeight_time.constant = 0
            cellTime.sunTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblSunday_Time.text = self.chooseBudzMap.timing.sunday + " - " + self.chooseBudzMap.timing.sun_end
        }
        
        if self.chooseBudzMap.timing.monday == "Closed" {
            cellTime.lblMonday_Time.text = "Closed"
            cellTime.lblMondayHeight.constant = 0
            cellTime.lblMondayHeight_time.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblMonday_Time.text = self.chooseBudzMap.timing.monday + " - " + self.chooseBudzMap.timing.mon_end
        }
        
        
        if self.chooseBudzMap.timing.tuesday == "Closed" {
            cellTime.lblTuesday_Time.text = "Closed"
            cellTime.lblTuesdayHeight.constant = 0
            cellTime.lblTuesdayHeight_time.constant = 0
            cellTime.tueTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblTuesday_Time.text = self.chooseBudzMap.timing.tuesday + " - " + self.chooseBudzMap.timing.tue_end
        }
        
        if self.chooseBudzMap.timing.wednesday == "Closed" {
            cellTime.lblWednesday_Time.text = "Closed"
            cellTime.lblWednesdayHeight.constant = 0
            cellTime.lblWednesdayHeight_time.constant = 0
            cellTime.wedTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblWednesday_Time.text = self.chooseBudzMap.timing.wednesday + " - " + self.chooseBudzMap.timing.wed_end
        }
        
        if self.chooseBudzMap.timing.thursday == "Closed" {
            cellTime.lblThursday_Time.text = "Closed"
            cellTime.lblThursdayHeight.constant = 0
            cellTime.lblThursdayHeight_time.constant = 0
            cellTime.thuTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblThursday_Time.text = self.chooseBudzMap.timing.thursday + " - " + self.chooseBudzMap.timing.thu_end
        }
        
        if self.chooseBudzMap.timing.friday == "Closed" {
            cellTime.lblFriday_Time.text = "Closed"
            cellTime.lblFridayHeight.constant = 0
            cellTime.lblFridayHeight_time.constant = 0
            cellTime.friTop.constant = 0
            weeksCheck = weeksCheck + 1
        }else {
            cellTime.lblFriday_Time.text = self.chooseBudzMap.timing.friday + " - " + self.chooseBudzMap.timing.fri_end
        }
        
        if weeksCheck == 7{
            cellTime.noHoursLbl.isHidden = false
        }else{
            cellTime.noHoursLbl.isHidden = true
        }
        
        
        
        let dayWeek = Date().dayNumberOfWeek()
        switch dayWeek! {
        case 0:
            cellTime.lblSaturday.text = "Today:"
            cellTime.lblSaturday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblSaturday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 1:
            cellTime.lblSunday.text = "Today:"
            cellTime.lblSunday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblSunday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 2:
            cellTime.lblMonday.text = "Today:"
            cellTime.lblMonday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblMonday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 3:
            cellTime.lblTuesday.text = "Today:"
            cellTime.lblTuesday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblTuesday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 4:
            cellTime.lblWednesday.text = "Today:"
            cellTime.lblWednesday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblWednesday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 5:
            cellTime.lblThursday.text = "Today:"
            cellTime.lblThursday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblThursday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        case 6:
            cellTime.lblFriday.text = "Today:"
            cellTime.lblFriday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblFriday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
            
        default:
            cellTime.lblFriday.text = "Today:"
            cellTime.lblFriday.textColor = ConstantsColor.kBudzSelectColor
            cellTime.lblFriday_Time.textColor = ConstantsColor.kBudzSelectColor
            break
        }
        
        cellTime.selectionStyle = .none
        return cellTime
    }
    
    //MARK:
    //MARK: Social Media Link Cell
    
    func SocialMediaLinkCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMediaLink = tableView.dequeueReusableCell(withIdentifier: "SocialMediaLinkCell") as! SocialMediaLinkCell
        cellMediaLink.lblZipCode.text = self.chooseBudzMap.zipCode
        cellMediaLink.lblWebsite.text = self.chooseBudzMap.web
        cellMediaLink.lblFacebook.text = self.chooseBudzMap.facebook
        cellMediaLink.lblTwitter.text = self.chooseBudzMap.twitter
        cellMediaLink.lblInstagram.text = self.chooseBudzMap.instagram

        if cellMediaLink.lblWebsite.text!.characters.count < 3 {
            cellMediaLink.lblWebsite.text = "Not Available"
        }
        
        if cellMediaLink.lblZipCode.text!.characters.count < 3 {
            cellMediaLink.lblZipCode.text = "Not Available"
        }
        
        if cellMediaLink.lblFacebook.text!.characters.count < 3 {
            cellMediaLink.lblFacebook.text = "Not Available"
        }
        
        if cellMediaLink.lblTwitter.text!.characters.count < 3 {
            cellMediaLink.lblTwitter.text = "Not Available"
        }
        
        if cellMediaLink.lblInstagram.text!.characters.count < 3 {
            cellMediaLink.lblInstagram.text = "Not Available"
        }
        
       
         cellMediaLink.lblZipCode.attributedText = cellMediaLink.lblZipCode.text?.setUnderline()
        cellMediaLink.lblWebsite.attributedText = cellMediaLink.lblWebsite.text?.setUnderline()
        cellMediaLink.lblFacebook.attributedText = cellMediaLink.lblFacebook.text?.setUnderline()
        cellMediaLink.lblTwitter.attributedText = cellMediaLink.lblTwitter.text?.setUnderline()
        cellMediaLink.lblInstagram.attributedText = cellMediaLink.lblInstagram.text?.setUnderline()

        cellMediaLink.BtnGoogle.tag = 1
        cellMediaLink.BtnGoogle.addTarget(self, action: #selector(openSite), for: UIControlEvents.touchUpInside)
        cellMediaLink.BtnFacebook.tag = 2
        cellMediaLink.BtnFacebook.addTarget(self, action: #selector(openSite), for: UIControlEvents.touchUpInside)
        cellMediaLink.BtnTwitter.tag = 3
        cellMediaLink.BtnTwitter.addTarget(self, action: #selector(openSite), for: UIControlEvents.touchUpInside)
        cellMediaLink.BtnInstagram.tag = 4
        cellMediaLink.BtnInstagram.addTarget(self, action: #selector(openSite), for: UIControlEvents.touchUpInside)
        cellMediaLink.selectionStyle = .none
        return cellMediaLink
    }
    
    //MARK:
    //MARK: Payment Method Cell
    
    func PaymentMthodCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellPayment = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
        for pay in chooseBudzMap.payments{
            pay.selected = 1
        }
        cellPayment.array = chooseBudzMap.payments
        if chooseBudzMap.payments.count == 0{
            cellPayment.collectionView.isHidden = true
            cellPayment.noDataLabel.isHidden = false
        }else{
            cellPayment.collectionView.isHidden = false
            cellPayment.noDataLabel.isHidden = true
        }
        cellPayment.collectionView.reloadData()
        cellPayment.selectionStyle = .none
        return cellPayment
    }
    
    //MARK:
    //MARK: Payment Method Cell
    
    func CommentHeaderCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "AddCommentHeaderCell") as! AddCommentHeaderCell
        cellCommentHeader.lblTotalComments.text = String(self.chooseBudzMap.reviews.count) + " Reviews"
         cellCommentHeader.Btn_AddComment.addTarget(self, action: #selector(scroll_to_bottom), for: UIControlEvents.touchUpInside)
        
        cellCommentHeader.Show_AddComment.addTarget(self, action: #selector(ShowAllComment), for: UIControlEvents.touchUpInside)
        
        cellCommentHeader.selectionStyle = .none
        if (self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!){
            cellCommentHeader.viewAddComment.isHidden = true
        }else {
             cellCommentHeader.viewAddComment.isHidden = false
        }
        return cellCommentHeader
    }
    
    func ShowAllComment(sender : UIButton){
        
        let getview = self.GetView(nameViewController: "BudzMapallReviewViewController", nameStoryBoard: "BudzStoryBoard") as! BudzMapallReviewViewController
        getview.delegate = self
        getview.chooseBudzMap = self.chooseBudzMap
        self.navigationController?.pushViewController(getview, animated: true)
    }
    
    //MARK:
    //MARK: Budz Comment Cell
    func BudzCommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "BudzCommentcell") as! BudzCommentcell
        
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        let mainReview = self.chooseBudzMap.reviews[indexMain]
        
        var newArray = [Any]()
        let id = String(describing: mainReview.reviewed_by)
        if id == DataManager.sharedInstance.user?.ID{
            cellCommentHeader.commentEditView.isHidden = false
            cellCommentHeader.commentDeleteView.isHidden = false
            cellCommentHeader.commentEditViewWidth.constant = 20
            cellCommentHeader.commentDeleteViewWidth.constant = 20
             cellCommentHeader.falgViewBudz.isHidden = true
            cellCommentHeader.falgViewBudzWidth.constant = 0
        }else{
            cellCommentHeader.falgViewBudz.isHidden = false
            cellCommentHeader.falgViewBudzWidth.constant = 55
            cellCommentHeader.commentEditView.isHidden = true
            cellCommentHeader.commentDeleteView.isHidden = true
            cellCommentHeader.commentEditViewWidth.constant = 0
            cellCommentHeader.commentDeleteViewWidth.constant = 0
            
        }
        cellCommentHeader.Lbl_Description.applyTag(baseVC: self , mainText: mainReview.text)
        
        if mainReview.is_reviewed_count == "1"{
            cellCommentHeader.reviewLikeButton.setImage(#imageLiteral(resourceName: "like_Up_White").withRenderingMode(.alwaysTemplate), for: .normal)
            cellCommentHeader.reviewLikeButton.tintColor = UIColor.init(hex: "992D7F")
        }else{
            cellCommentHeader.reviewLikeButton.setImage(#imageLiteral(resourceName: "like_Up_White"), for: .normal)
        }
        cellCommentHeader.likesCount.text = String(mainReview.likes_count)
        cellCommentHeader.reviewLikeButton.tag = indexMain
        cellCommentHeader.reviewLikeButton.addTarget(self, action: #selector(self.Likereview(sender:)), for: .touchUpInside)
        print(mainReview.rating)
        let r = Int(mainReview.rating)
        cellCommentHeader.Lbl_Rating.text = String(r)
        if mainReview.rating > 0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "starFilled")
        }else{
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "starUnfilled")
        }
        cellCommentHeader.Lbl_Description.text = mainReview.text
        cellCommentHeader.Lbl_UserName.text = mainReview.userMain.userFirstName
        cellCommentHeader.Lbl_Time.text = self.getDateWithTh(date: mainReview.created_at)// .GetDateWith(formate: "dd MMM yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
        cellCommentHeader.Btn_UserProfile.tag = indexMain
        cellCommentHeader.Btn_UserProfile.addTarget(self, action: #selector(self.USerProfile), for: .touchUpInside)
        cellCommentHeader.ImgView_USer.image = #imageLiteral(resourceName: "user_placeholder_Budz")
        if mainReview.userMain.profilePictureURL.contains("facebook.com") || mainReview.userMain.profilePictureURL.contains("google.com"){
            cellCommentHeader.ImgView_USer.moa.url =  mainReview.userMain.profilePictureURL.RemoveSpace()
        }else{
           cellCommentHeader.ImgView_USer.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.userMain.profilePictureURL.RemoveSpace()
        }
        if mainReview.userMain.special_icon.characters.count > 6 {
            cellCommentHeader.ImgView_USerTop.isHidden = false
            cellCommentHeader.ImgView_USerTop.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.userMain.special_icon.RemoveSpace()
        }else {
            cellCommentHeader.ImgView_USerTop.isHidden = true
        }
        cellCommentHeader.ImgView_USer.RoundView()
        cellCommentHeader.view_Attachment1.isHidden = false
        cellCommentHeader.view_Attachment2.isHidden = true
        cellCommentHeader.view_Attachment3.isHidden = true
        cellCommentHeader.attachmentView.isHidden = true
        cellCommentHeader.attachmentViewHeight.constant = 0
        cellCommentHeader.ImgView_Attachment1_Video.isHidden = true
        cellCommentHeader.ImgView_Attachment2_Video.isHidden = true
        cellCommentHeader.ImgView_Attachment3_Video.isHidden = true
        
        if mainReview.attachments.count > 0 {
            cellCommentHeader.attachmentView.isHidden = false
            cellCommentHeader.attachmentViewHeight.constant = 56
            cellCommentHeader.view_Attachment1.isHidden = false
            cellCommentHeader.ImgView_Attachment1.image = #imageLiteral(resourceName: "placeholder")
            if mainReview.attachments[0].image_URL.RemoveSpace() != ""{
            cellCommentHeader.ImgView_Attachment1.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[0].image_URL.RemoveSpace()
            }
            cellCommentHeader.view_Attachment1.isHidden = false
            if mainReview.attachments[0].is_Video {
                cellCommentHeader.ImgView_Attachment1_Video.image = #imageLiteral(resourceName: "Video_play_icon_White")
                cellCommentHeader.ImgView_Attachment1_Video.isHidden = false
            }else{
                 cellCommentHeader.ImgView_Attachment1_Video.image = #imageLiteral(resourceName: "Gallery_White")
            }
            
            cellCommentHeader.btn_Attachment1.addTarget(self, action: #selector(OpenAttachment), for: UIControlEvents.touchUpInside)

        }
        
        cellCommentHeader.btn_Attachment1.tag = indexMain
        let budzId = String(chooseBudzMap.user_id)
        if let reply = mainReview.reply{
            cellCommentHeader.replyView.isHidden = false
            cellCommentHeader.replyButton.isHidden = true
            cellCommentHeader.replyImage.isHidden = true
            cellCommentHeader.replyViewHeight.constant = 137
            cellCommentHeader.replyDescription.text = reply.reply
            cellCommentHeader.replyTimeAgo.text = self.GetTimeAgo(StringDate: (reply.created_at)!)
            let id = reply.userId
            if id?.intValue == Int((DataManager.sharedInstance.user?.ID)!){
                cellCommentHeader.replyEditView.isHidden = false
                cellCommentHeader.replyDeleteView.isHidden = false
                cellCommentHeader.replyEditViewWidth.constant = 30
                cellCommentHeader.replyDeleteViewWidth.constant = 30
            }else{
                cellCommentHeader.replyEditView.isHidden = true
                cellCommentHeader.replyDeleteView.isHidden = true
                cellCommentHeader.replyEditViewWidth.constant = 0
                cellCommentHeader.replyDeleteViewWidth.constant = 0
            
            }
        }else{
            if budzId == DataManager.sharedInstance.user?.ID{
                cellCommentHeader.replyButton.isHidden = false
                cellCommentHeader.replyImage.isHidden = false
            }else{
                cellCommentHeader.replyButton.isHidden = true
                cellCommentHeader.replyImage.isHidden = true
            }
            cellCommentHeader.replyViewHeight.constant = 0
            cellCommentHeader.replyView.isHidden = true
        }
        
//        if mainReview.attachments.count > 1 {
//            cellCommentHeader.view_Attachment2.isHidden = false
//            cellCommentHeader.ImgView_Attachment2.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[1].image_URL.RemoveSpace()
//
//            cellCommentHeader.view_Attachment2.isHidden = false
//
//            if mainReview.attachments[1].is_Video {
//                cellCommentHeader.ImgView_Attachment2_Video.isHidden = false
//            }
//        }
        
        
        
//        if mainReview.attachments.count > 2 {
//            cellCommentHeader.view_Attachment3.isHidden = false
//            cellCommentHeader.ImgView_Attachment3.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[2].image_URL.RemoveSpace()
//
//            cellCommentHeader.view_Attachment3.isHidden = false
//
//            if mainReview.attachments[2].is_Video {
//                cellCommentHeader.ImgView_Attachment3_Video.isHidden = false
//            }
//        }
//
        
        if mainReview.isFlag == 0 {
            cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "QAReport")
            cellCommentHeader.lbl_report_abuse.textColor =  UIColor.init(hex: "7D7D7D")
        }else {
            cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "ic_flag_budz")
            cellCommentHeader.lbl_report_abuse.textColor = UIColor.init(hex: "922F87")
        }
        cellCommentHeader.Btn_Report.tag = indexMain
        cellCommentHeader.Btn_Report.addTarget(self, action: #selector(ReportComment), for: UIControlEvents.touchUpInside)

        cellCommentHeader.Btn_Share.tag = indexMain
        cellCommentHeader.Btn_Share.addTarget(self, action: #selector(self.ShareActionReview), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyButton.tag = indexMain
        cellCommentHeader.replyButton.addTarget(self, action: #selector(self.replyAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyEditButton.tag = indexMain
        cellCommentHeader.replyEditButton.addTarget(self, action: #selector(self.replyAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.commentEditButton.tag = indexMain
        cellCommentHeader.commentEditButton.addTarget(self, action: #selector(self.editCommentAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.commentDeleteButton.tag = indexMain
        cellCommentHeader.commentDeleteButton.addTarget(self, action: #selector(self.deleteCommentAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyDeleteButton.tag = indexMain
        cellCommentHeader.replyDeleteButton.addTarget(self, action: #selector(self.deleteReplyAction), for: UIControlEvents.touchUpInside)
        
//        cellCommentHeader.Btn_Rate.tag = indexPath.row
//      cellCommentHeader.Btn_Rate.addTarget(self, action: #selector(rateComment), for: UIControlEvents.touchUpInside)
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    
    func USerProfile(sender : UIButton){
        if  self.chooseBudzMap.reviews != nil{
                let mainReview = self.chooseBudzMap.reviews[sender.tag]
                self.OpenProfileVC(id: "\(mainReview.userMain.ID)")
        }
       
    }
    
    func reportReview() {
        self.oneBtnCustomeAlert(title: "", discription: "Flagged successfully") { (isCom, btn) in
             self.GetBudzMapInfo()
        }
      
    }
    func OpenAttachment(sender : UIButton){
        if self.chooseBudzMap.reviews[sender.tag].attachments[0].is_Video {
            let video_path =  WebServiceName.videos_baseurl.rawValue + self.chooseBudzMap.reviews[sender.tag].attachments[0].video_URL
            let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else {
            
           let image_path =  self.chooseBudzMap.reviews[sender.tag].attachments[0].image_URL
            self.showImagess(attachments: [WebServiceName.images_baseurl.rawValue + image_path])
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
//            vc.urlMain = image_path
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:
    //MARK: Your Comment Heading Cell
    func YourCommentHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "AddYourCommentCell") as! AddYourCommentCell
        if editedCellIndex != -1{
            cellCommentHeader.commentLabel.text = "Edit Your Comment Below"
        }else if replyEditIndex != -1{
            cellCommentHeader.commentLabel.text = "Add Reply"
        }
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    
    
    
    func OtherImageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "ImageDisplayCell") as! ImageDisplayCell
       
        cellCommentHeader.selectionStyle = .none
        if self.chooseBudzMap.others_image != ""{
        cellCommentHeader.others_image?.moa.url = WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.others_image
            cellCommentHeader.imageButton.addTarget(self, action: #selector(self.showOtherImage), for: .touchUpInside)
        print(WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.others_image)
        }else{
        cellCommentHeader.imageButton.removeTarget(nil, action: nil, for: .allEvents)
        cellCommentHeader.others_image?.image = #imageLiteral(resourceName: "pictureplaceholder")
        }
        return cellCommentHeader
    }
    
    @IBAction func showOtherImage(sender: UIButton!){
        self.showImagess(attachments: ([WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.others_image]))
    }
    
    //MARK:
    //MARK: Enter Comment  Cell
    func EnterCommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "EnterCommentCell") as! EnterCommentCell
        cellCommentHeader.txtviewMain.delegate = self as! UITextViewDelegate
        cellCommentHeader.txtviewMain.tag = indexPath.row
        if editedCellIndex != -1{
            cellCommentHeader.txtviewMain.text = self.chooseBudzMap.reviews[editedCellIndex].text
        }else if replyEditIndex != -1{
            if self.chooseBudzMap.reviews[replyEditIndex].reply != nil{
                self.replyUpdating = true
                cellCommentHeader.txtviewMain.text = self.chooseBudzMap.reviews[replyEditIndex].reply.reply
            }else{
                cellCommentHeader.txtviewMain.text = "Type your comment here..."
                self.replyUpdating = false
            }
        }
            if self.txtCommentTxt.characters.count > 0 {
                cellCommentHeader.txtviewMain.text = self.txtCommentTxt
            }
        cellCommentHeader.txtviewMain.tag = indexPath.row
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }

    
    //MARK:
    //MARK: Upload button Cell
    func UPloadBudzButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellUploadBudz = tableView.dequeueReusableCell(withIdentifier: "UploadBudzCell") as! UploadBudzCell
        
        cellUploadBudz.btnUpload.addTarget(self, action: #selector(self.OpenCamera), for: .touchUpInside)

        cellUploadBudz.selectionStyle = .none
        return cellUploadBudz
    }
    
    
    //MARK:
    //MARK: Media Choose Cell
    func MediaChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cellMedia = tableView.dequeueReusableCell(withIdentifier: "ShoeMediaCell") as! ShoeMediaCell
        if tableView == editCommentTableView{
           
            
            let mianAttachment = self.editAttachment
            if editedCellIndex != -1 && mianAttachment.image_URL != ""{
             cellMedia.imgViewImage.moa.url = WebServiceName.images_baseurl.rawValue + mianAttachment.image_URL
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
        }else{
        
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        let mianAttachment = self.array_Attachment[indexMain]
        
        cellMedia.imgViewImage.image = mianAttachment.image_Attachment
        
        cellMedia.imgViewVideo.isHidden = true
        if mianAttachment.is_Video {
            cellMedia.imgViewVideo.isHidden = false
        }
        
        cellMedia.btnDelete.tag = indexMain
        cellMedia.btnDelete.addTarget(self, action: #selector(self.DeleteImageAction), for: .touchUpInside)

        
        cellMedia.selectionStyle = .none
        }
        return cellMedia
    }
    
    
    //MARK:
    //MARK: RATING Cell
    func RatingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "AddRatingcell") as! AddRatingcell
        if editedCellIndex != -1{
         let rate = chooseBudzMap.reviews[editedCellIndex].rating
         cellMedia.viewRating.rating = rate
        }else{
           cellMedia.viewRating.rating = 5.0
        }
        cellMedia.viewRating.settings.fillMode = .full
        cellMedia.viewRating.didTouchCosmos = { rating in
             cellMedia.viewRating.rating = rating
             self.rating = rating

        }
        cellMedia.viewRating.settings.minTouchRating = 1.0
        cellMedia.selectionStyle = .none
        return cellMedia
    }

    //MARK:
    //MARK: Your Comment Heading Cell
    func SubmitCommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "SubmitBudzCell") as! SubmitBudzCell
        if tableView == replyEditTableView{
            cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
            if replyEditIndex != -1{
            cellMedia.btnSubmit.setTitle("SUBMIT REPLY", for: .normal)
                if self.replyUpdating{
                    cellMedia.btnSubmit.setTitle("UPDATE REPLY", for: .normal)
                }
            }
            cellMedia.selectionStyle = .none
            return cellMedia
        }else if tableView == editCommentTableView{
            cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
            cellMedia.btnSubmit.setTitle("UPDATE COMMENT", for: .normal)
            cellMedia.selectionStyle = .none
            return cellMedia
        }else{
        cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
        cellMedia.selectionStyle = .none
        return cellMedia
        }
    }
    
    
    //MARK:
    //MARK: Product CellBudzSe
    func ProductBudzCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellProduct = tableView.dequeueReusableCell(withIdentifier: "BudzProductCell") as! BudzProductCell
        cellProduct.selectionStyle = .none
        return cellProduct
    }
    
    
    //MARK:
    //MARK: Special Cell
    func SpecialBudzCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellSpecial = tableView.dequeueReusableCell(withIdentifier: "SpecialBudzCell") as! SpecialBudzCell

        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        cellSpecial.lblName.applyTag(baseVC: self , mainText: self.budz_specials[indexMain].title)
        cellSpecial.lblDescription.applyTag(baseVC: self , mainText:  self.budz_specials[indexMain].discription)
        if indexMain != 0{
            cellSpecial.lblSpecialOffer.isHidden = true
            cellSpecial.specialOfferHeight.constant = 0
        }else{
            cellSpecial.lblSpecialOffer.isHidden = false
            cellSpecial.specialOfferHeight.constant = 20
        }
        cellSpecial.lblName.text = self.budz_specials[indexMain].title
        cellSpecial.lblDescription.text = self.budz_specials[indexMain].discription

        
        let dayremaining = self.budz_specials[indexMain].date.GetDaysAgo(formate: "yyyy-MM-dd")
        if dayremaining < 0 {
            cellSpecial.lblTime.text = "Expired"
            cellSpecial.lblTime.textColor = UIColor.red
            cellSpecial.lblExpire.isHidden = true
        }else if dayremaining < 2 {
            cellSpecial.lblExpire.isHidden = false
            var ttt = self.budz_specials[indexMain].date.GetShoutoutSpecial()
            cellSpecial.lblTime.text =  ttt
            cellSpecial.lblTime.textColor = UIColor.white
            cellSpecial.lblExpire.text = "Expire Soon!"
            cellSpecial.lblExpire.textColor = UIColor.red
        }else {
            cellSpecial.lblExpire.isHidden = true
            cellSpecial.lblTime.text = "Valid Until : " + self.budz_specials[indexMain].date.GetShoutoutSpecial()
            cellSpecial.lblTime.textColor = UIColor.white
        }
        cellSpecial.viewMainBg.backgroundColor = UIColor.clear
        if(self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!){
            cellSpecial.btn_edit_sp.isHidden = false
            cellSpecial.btn_Save.isHidden = false
            cellSpecial.imgView_Save.isHidden = false
            cellSpecial.img_edit_sp.isHidden = false
                cellSpecial.btn_Save.tag = indexMain
            cellSpecial.btn_edit_sp.tag = indexMain
                cellSpecial.btn_Save.addTarget(self, action: #selector(deleteSp), for: UIControlEvents.touchUpInside)
            cellSpecial.btn_edit_sp.addTarget(self, action: #selector(EditSpecial), for: UIControlEvents.touchUpInside)

        }else {
            cellSpecial.btn_edit_sp.isHidden = true
            cellSpecial.btn_Save.isHidden = true
            cellSpecial.imgView_Save.isHidden = true
            cellSpecial.img_edit_sp.isHidden = true
        }
        cellSpecial.btn_Share.addTarget(self, action: #selector(self.ShareActionSpecial), for: .touchUpInside)
        cellSpecial.selectionStyle = .none
        return cellSpecial
    }
    func ShareActionProduct(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.array_Product[sender.tag].ID)"
        parmas["type"] = "Budz Service"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"//"get-budz-product/\(self.array_Product[sender.tag].ID)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    func deleteSp(sender: UIButton){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this special?") { (isCom, btnType) in
            if(isCom){
                let id  =  self.budz_specials[sender.tag].id
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: "delete_special/\(id)", completion: { (successResponse, messageResponse, DataResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (DataResponse["status"] as! String) == "success" {
                            self.refreshData()
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
        }
        
    }
    func EditSpecial(sender: UIButton){
        
        let storyboard = UIStoryboard(name: "ShoutOut", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "AddNewSpecialVC") as! AddNewSpecialVC
        customAlert.delegate = self
        customAlert.budz_specials = self.budz_specials[sender.tag]
        customAlert.budz_id = "\(self.chooseBudzMap.id)"
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: false, completion: nil)
    }
    func ShareActionService(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.array_Services[sender.tag].id)"
        parmas["type"] = "Budz Service"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"//"get-budz-service/\(self.array_Services[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    func ShareActionSpecial(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.budz_specials[sender.tag].id)"
        parmas["type"] = "Budz Special"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)"//"get-budz-special/\(self.budz_specials[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
  
    func replyAction(sender: UIButton){
        replyEditView.isHidden = false
        self.replyEditIndex = sender.tag
        replyEditTableLoad()
    }
    
    func editCommentAction(sender: UIButton!){
        if self.chooseBudzMap.reviews[sender.tag].attachments.count != 0{
            self.editAttachment = self.chooseBudzMap.reviews[sender.tag].attachments[0]
            self.editAttachment.ID = "-1"
        }
        editCommentView.isHidden = false
        editedCellIndex = sender.tag
        editTableLoad()
    }
    
    
    func deleteCommentAction(sender: UIButton!){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this review?") { (isComp, btnNum) in
            if isComp {
                self.deleteReview(index: sender.tag)
            }
        }
       
    }
    
    func deleteReplyAction(sender: UIButton!){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this reply?") { (isComp, btnNum) in
            if isComp {
                self.deleteReply(index: sender.tag)
            }
        }
       
    }
 
    
    func deleteReply(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["review_reply_id"] = self.chooseBudzMap.reviews[index].reply.id as AnyObject
        
        
        print(newPAram)
        self.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_budz_review_reply.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
            self.hideLoading()
            
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    
                    self.GetBudzMapInfo()
                    //                        if self.editedCellIndex != -1{
                    //                            self.editCommentView.isHidden = true
                    //                            self.editedCellIndex = -1
                    //                        }
                    self.DispensaryDataload()
                    self.tbleViewMain.reloadData()
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
    

    func deleteReview(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["review_id"] = self.chooseBudzMap.reviews[index].id as AnyObject

        
        print(newPAram)
            self.showLoading()
            
            NetworkManager.PostCall(UrlAPI: WebServiceName.delete_budz_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
                self.hideLoading()
                
                if successResponse {
                    if (DataResponse["status"] as! String) == "success" {
                        
                        self.GetBudzMapInfo()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        self.DispensaryDataload()
                        self.tbleViewMain.reloadData()
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
}


extension DispensaryDetailVC  {
    func LeftButtonAction(sender : UIButton){
        self.isSpecialShown = false
        self.isSpecailTapped = false
        isProductAdded = false
        self.SelectOptions(value: 0)
        
    }
    
    func RightButtonAction(sender : UIButton){
        if self.chooseBudzMap.budzMapType.idType == 9{
            self.simpleCustomeAlert(title: "", discription: "You can't upgrade Other Type Business!")
            return
        }
         isProductAdded = false
        if self.chooseBudzMap.is_featured == 1{
        self.isSpecialShown = false
        self.isSpecailTapped = true
        self.SelectOptions(value: 2)
        }else{
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)! {
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.NotAsPopUp = true
                next.updateBudId = self.chooseBudzMap.id
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
    }
    
    func MiddelButtonAction(sender : UIButton){
        if self.chooseBudzMap.budzMapType.idType == 9{
            self.simpleCustomeAlert(title: "", discription: "You can't upgrade Other Type Business!")
            return
        }
         isProductAdded = false
        if self.chooseBudzMap.is_featured == 1{
        self.isSpecialShown = false
         self.isSpecailTapped = false
        self.SelectOptions(value: 1)
        }else{
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.NotAsPopUp = true
                next.updateBudId = self.chooseBudzMap.id
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
    }
    
    
    func SelectOptions(value : Int){
        self.showTag = value
        if let cellHeadingButton = self.tbleViewMain.cellForRow(at: IndexPath.init(row: 1, section: 0) as IndexPath) as? HeaderButtonCell{
            cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzUnselectColor
            cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
            cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
            
            switch value {
            case 0:
                cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzSelectColor
                self.tabsRefreshed = false
                self.RefreshTableView()
                break
                
            case 1:
                if self.chooseBudzMap.is_featured == 1{
                    cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kBudzSelectColor
                    if(self.chooseBudzMap.budzMapType.idType == 3){
                        var parmas = [String: Any]()
                        parmas["sub_user_id"] = "\(self.chooseBudzMap.id)"
                        //sub_user_id
                        NetworkManager.PostCall(UrlAPI: WebServiceName.save_budz_menu_click.rawValue, params: parmas as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
                            print(dataResponse)
                            
                        }
                    }else if(self.chooseBudzMap.budzMapType.idType == 5){
                        var parmas = [String: Any]()
                        parmas["sub_user_id"] = "\(self.chooseBudzMap.id)"
                        //sub_user_id
                        NetworkManager.PostCall(UrlAPI: WebServiceName.save_budz_ticket_click.rawValue, params: parmas as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
                            print(dataResponse)
                            
                        }
                    }
                    self.LoadProduct()
                }
                break;
                
                
            default:
                if self.chooseBudzMap.is_featured == 1{
                    cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kBudzSelectColor
                    self.LoadSpecial()
                }
              
            }
        }else if isProductAdded{
              self.LoadProduct()
        }
    }
    
    
    func LoadSpecial(){
        
           self.array_table.removeAll()
            array_table.append(["type" : BudzMapDataType.Header.rawValue ])
            array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
            if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
                array_table.append(["type" : BudzMapDataType.addSpecial.rawValue ])
            }
            var isFound = false
            var indexMain = 0
            for _ in self.budz_specials {
                array_table.append(["type" : BudzMapDataType.BudzSpecial.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
                 isFound = true
            }
        
        if !isFound{
            array_table.append(["type" : BudzMapDataType.NoRecordtext.rawValue ])
        }
        self.tbleViewMain.reloadData()
    }
    
    
    func LoadProduct(){
        var isEventPurchaseDataAppend : Bool = false
        self.array_table.removeAll()
        array_table.append(["type" : BudzMapDataType.Header.rawValue ])
        array_table.append(["type" : BudzMapDataType.MenuButton.rawValue ])
        
        if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
            if self.chooseBudzMap.business_type_id == "5" {
                isEventPurchaseDataAppend = true
            }else{
                if self.chooseBudzMap.business_type_id == "2" || self.chooseBudzMap.business_type_id == "7" || self.chooseBudzMap.business_type_id == "6" {
                     array_table.append(["type" : BudzMapDataType.addProductServices.rawValue ])
                }else{
                    array_table.append(["type" : BudzMapDataType.NoRecord.rawValue ])
                }
            }
        }
        
        if self.chooseBudzMap.business_type_id == "5" {
            array_table.append(["type" : BudzMapDataType.eventPaymentMethods.rawValue])
            var indexMain = 0
            for _ in self.budz_tickets {
                array_table.append(["type" : BudzMapDataType.eventTicktes.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
            }
            if(self.budz_tickets.count == 0 ){
                array_table.append(["type" : BudzMapDataType.NoRecordtext.rawValue , "index" : indexMain])
            }
        }else{
            var indexMain = 0
            var isFound = false
            if !tabsRefreshed{
            isFound = false
            }else if self.array_Product.count == 0
            {
            isFound = false
            }else{
            isFound = true
            }
            for _ in self.array_Services {
                array_table.append(["type" : BudzMapDataType.BudzService.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
                isFound = true
            }
            
            indexMain = 0
                self.category_array_product = self.category_array_product.sorted(by: {$0.strainCategory!.title < $1.strainCategory!.title})
                self.strainType_array_product = self.strainType_array_product.sorted(by: {$0.straintype!.title < $1.straintype!.title})
            for _ in self.array_Product {
                array_table.append(["type" : BudzMapDataType.BudzProduct.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
                isFound = true
            }

            if !isFound{
                if self.chooseBudzMap.user_id != Int((DataManager.sharedInstance.user?.ID)!)!{
                    array_table.append(["type" : BudzMapDataType.NoRecordtext.rawValue ])
                } else{
                  
                }
            }
        }
        if isEventPurchaseDataAppend{
             array_table.append(["type" : BudzMapDataType.evnetPurchaseTicketCell.rawValue ])
        }
        self.tbleViewMain.reloadData()
        
        
    }
}


//MARK:
//MARK:  Cell Button Action 
extension DispensaryDetailVC {
    func BackAction(sender : UIButton){
        if fromNew{
            self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)! - 2)
        self.navigationController?.popViewController(animated: true)
        }else{
        self.Back()
        }
    }
    
    func OpenGallery(sender : UIButton){
        
        let galleryview = self.GetView(nameViewController: "GalleryViewController", nameStoryBoard: "Main") as! GalleryViewController
        galleryview.chooseBudzMap = self.chooseBudzMap
        self.navigationController?.pushViewController(galleryview, animated: true)
        
    }
    
    
    func EditBudzMAp(sender : UIButton){
        if self.showTag  != 0 && self.showTag != 1 {
            let subuser  = SubUser.init(json: [:])
            self.addNewShoutOutAler(subusers: [subuser] , id : self.chooseBudzMap.id , sub_userTitle : self.chooseBudzMap.title , delegate  : self, specials: self.budz_specials)
        }else{
            let new_vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBudzMapViewController") as! NewBudzMapViewController
            new_vc.isSubscribed = false
            new_vc.chooseBudzMap = self.chooseBudzMap
            new_vc.fiveBack = true
            self.navigationController?.pushViewController(new_vc, animated: false)
        }
        
    }
    
    
    func CallPhoneNumber(sender : UIButton){
        
        if self.chooseBudzMap.phon_number.count > 0 {
            var parmas = [String: Any]()
            parmas["sub_user_id"] = "\(self.chooseBudzMap.id)"
            parmas["keyword"] = searched_keyword
            print(parmas)
            //sub_user_id
            NetworkManager.PostCall(UrlAPI: WebServiceName.save_budz_call_click.rawValue, params: parmas as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
                print(dataResponse)
            }
            self.DialNumber(PhoneNumber: self.chooseBudzMap.phon_number)
        }else {
            self.ShowErrorAlert(message: "No phone number found!")
        }
        
    }
    //MARK:  Open Site Action
    func openSite(sender: UIButton){
        //...
        switch sender.tag {
        case 1:
            if(self.chooseBudzMap.web.count>0) {
                self.OpenLink(webUrl: self.chooseBudzMap.web)                
            }
        case 2:
            if(self.chooseBudzMap.facebook.count>0) {
                self.OpenLink(webUrl: self.chooseBudzMap.facebook)
            }
        case 3:
            if(self.chooseBudzMap.twitter.count>0) {
                self.OpenLink(webUrl: self.chooseBudzMap.twitter)
            }
        case 4:
            if(self.chooseBudzMap.instagram.count>0) {
                self.OpenLink(webUrl: self.chooseBudzMap.instagram)
            }
        default:
            if(self.chooseBudzMap.web.count>0) {
                self.OpenLink(webUrl: self.chooseBudzMap.web)
            }
            break
        }
        
    }

    
    func DeleteImageAction(sender : UIButton){
        if editedCellIndex == -1{
        self.array_Attachment.remove(at: sender.tag)
        self.RefreshTableView()
        }else{
            self.deleteImageReview = 1
            self.editAttachment = Attachment()
            self.array_Attachment.removeAll()
            self.editTableLoad()
        }
    }
    
    func ReportComment(sender:UIButton){
         let mainReview = self.chooseBudzMap.reviews[sender.tag]
         if mainReview.isFlag == 0 {
            if mainReview.userMain.ID ==  DataManager.sharedInstance.user?.ID {
                self.ShowErrorAlert(message: "You can't report on your review!")
                return
            }
            isRefreshonWillAppear = true
            print(mainReview)
             self.openFlagAlert(id: "\(mainReview.id)")
         }else {
            self.ShowErrorAlert(message: "Review already reported!")
         }
      
    }
    func ReportBudz(sender:UIButton){
        let mainReview = self.chooseBudzMap.isFlagged
        if mainReview == 0 {
            if String(self.chooseBudzMap.user_id) ==  DataManager.sharedInstance.user?.ID {
                self.ShowErrorAlert(message: "You can't report on your own budz adz!")
                return
            }
            isRefreshonWillAppear = true
            print(mainReview)
            self.openFlagAlert(id: "\(self.chooseBudzMap.id)" , isBudz: true)
        }else {
            self.ShowErrorAlert(message: "Budz adz already reported!")
        }
        
    }

    func GoBottom(sender:UIButton){
        if self.showTag == 0 {
            let indexPath = IndexPath(row: self.array_table.count-1, section: 0)
            self.tbleViewMain.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
//       self.tbleViewMain.scrollTo
        
    }
    //GoBottom
    func OpenCamera(){
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        if editedCellIndex == -1{
        self.array_Attachment.append(newAttachment)
        self.RefreshTableView()
        }else{
            self.editAttachment = newAttachment
            self.editTableLoad()
        }
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.video_URL = gifURL.absoluteString
        newAttachment.ID = "-1"
        if editedCellIndex == -1{
            self.array_Attachment.append(newAttachment)
            self.RefreshTableView()
        }else{
            self.editAttachment = newAttachment
            self.editTableLoad()
        }
        self.disableMenu()
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        if editedCellIndex == -1{
            self.array_Attachment.append(newAttachment)
            self.RefreshTableView()
        }else{
            self.editAttachment = newAttachment
            self.editTableLoad()
        }
        self.disableMenu()
    }
    
    
    
//    func rateComment(sender:UIButton){
//
//        let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! BudzCommentcell
//
//        if sender.isSelected {
//            sender.isSelected = false
//            cellMain.ImgView_Star.image = UIImage.init(named: "starFilled")
//            cellMain.Lbl_Rating.text = "3.0"
//        }else {
//            sender.isSelected = true
//            cellMain.ImgView_Star.image = UIImage.init(named: "starUnfilled")
//            cellMain.Lbl_Rating.text = "2.0"
//        }
//
//    }
    func showProducts(sender:UIButton){
        if self.chooseBudzMap.is_featured == 1{
             self.SelectOptions(value:1)
        }
       
    }
    func scroll_to_bottom(sender:UIButton){
        let scrollPoint = CGPoint(x: 0, y: self.tbleViewMain.contentSize.height - self.tbleViewMain.frame.size.height)
        self.tbleViewMain.setContentOffset(scrollPoint, animated: true)
    }
    func like_bud(sender:UIButton){
        
        
        isPopShown = false

        let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! BudzHeaderCell
        
        if sender.isSelected {
            sender.isSelected = false
            cellMain.imgView_Like.image = UIImage.init(named: "Heart_White")
            self.CallLikeBudzAPI(value: "0")
          
        }else {
            sender.isSelected = true
            
            isPopShown = true
            
            cellMain.imgView_Like.image = UIImage.init(named: "Heart_Filled")
            self.CallLikeBudzAPI(value: "1")
          
        } 
    }
    
    func onClickStartChat(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
        let model = Message.init()
        model.sender_id = Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!
        model.sender_first_name = (DataManager.sharedInstance.getPermanentlySavedUser()?.userFirstName)!
        model.receiver_id = self.chooseBudzMap.user_id
        model.receiver_first_name = self.chooseBudzMap.title
        model.receiver_image_path = self.chooseBudzMap.logo
        model.receiver_avatar = self.chooseBudzMap.logo
        vc.isFromFeed = 1
        vc.logo = self.chooseBudzMap.logo
        vc.msg_data_modal = model
        vc.nameOther = self.chooseBudzMap.title
        vc.isSelectUser = false
        vc.other_id = "\(self.chooseBudzMap.user_id)"
        vc.bud_map_id  = "\(self.chooseBudzMap.id)"
        print("\(self.chooseBudzMap.user_id)")
        print("\(self.chooseBudzMap.id)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func CallLikeBudzAPI(value : String){
        
        var newParam = [String : AnyObject]()
        newParam["sub_user_id"] = String(self.chooseBudzMap.id) as AnyObject
        newParam["is_like"] = value as AnyObject
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_favorit_bud.rawValue, params: newParam) { (success, message, data) in


            if success {
                if (data["status"] as! String) == "success" {
                    
                    if self.isPopShown {
                    
                        if !UserDefaults.standard.bool(forKey: "BudzPopup"){
                        
                            self.saveView.isHidden = false
                        }
                    }
                    
                }else {
                    if (data["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
        }
    }
    func save_bud(sender:UIButton){
        let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! SpecialBudzCell
        cellMain.imgView_Save.image = #imageLiteral(resourceName: "saved")
        var param = [String : AnyObject]()
        param["business_id"] = self.chooseBudzMap.id as AnyObject
        param["business_type_id"] = self.chooseBudzMap.business_type_id as AnyObject
        let dictValue = array_table[sender.tag]
        let indexMain = dictValue["index"] as! Int
        let special = self.array_Special[indexMain]
        special.isSaved = true
        self.array_Special[indexMain] = special
        param["shout_out_id"] = special.id as AnyObject
        print(param)
        NetworkManager.PostCall(UrlAPI: "save_favorit_shout_out", params: param) { (isSuccess, stringResponse, objectResponse) in
            print(objectResponse)
        }
    }
    
    
    func GO_Home_ACtion(sender : UIButton){
        
        self.GotoHome()
    }
    
    func Show_PopUp(sender : UIButton){
//        self.view_New_Popup.isHidden = false
    }
    
    
   @IBAction func Hide_PopUp(sender : UIButton){
//        self.view_New_Popup.isHidden = true
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
        self.txtCommentTxt = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(textView.text.characters.count)
        self.txtCommentTxt = textView.text
        var cell: EnterCommentCell!
        let index = IndexPath.init(row: textView.tag, section: 0)
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        if self.editedCellIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. 500 Characters"
            }else{
            cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
            cell.lblTextcount.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }else if self.replyEditIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. 500 Characters"
            }else{
            cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
            cell.lblTextcount.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }else{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (tbleViewMain.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (tbleViewMain.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (tbleViewMain.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. 500 Characters"
            }else{
            cell = (tbleViewMain.cellForRow(at: index) as! EnterCommentCell)
            cell.lblTextcount.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }
        var textTemp = textView.text.count + text.count
        if textTemp > 499 {
            return false
        }
        return true
    }
    
    func SubmitAction(sender : UIButton){
     
        var textviewText = ""
        self.txtCommentTxt = ""
        var ratingCount : Double = 5.0
        
        for index in 0..<self.array_table.count {
            var cellMain: UITableViewCell!
            if editedCellIndex != -1{
             cellMain  = self.editCommentTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
            }else if replyEditIndex != -1{
               cellMain  = self.replyEditTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
            }else{
               cellMain  = self.tbleViewMain.cellForRow(at: IndexPath.init(row: index, section: 0))
            }
            if cellMain is EnterCommentCell {
                let cellNew = cellMain as! EnterCommentCell
                textviewText = cellNew.txtviewMain.text
                cellNew.txtviewMain.text =  ""
            }else  if cellMain is AddRatingcell {
                let cellNew = cellMain as! AddRatingcell
                ratingCount = cellNew.viewRating.rating
            }
    
        }
        
        if textviewText == "Type your comment here..." {
           textviewText = ""
        }
        if textviewText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            self.ShowErrorAlert(message: "Enter comment!")
            return
        }
    
        var newPAram = [String : AnyObject]()
        if replyEditIndex != -1{
            newPAram["review_id"] = self.chooseBudzMap.reviews[replyEditIndex].id as AnyObject
            newPAram["reply"] = textviewText as AnyObject
        }else{
        newPAram["sub_user_id"] = String(self.chooseBudzMap.id) as AnyObject
        newPAram["review"] = textviewText as AnyObject
        newPAram["rating"] = String(ratingCount) as AnyObject
        if editedCellIndex != -1{
            newPAram["business_review_id"] = String(self.chooseBudzMap.reviews[editedCellIndex].id) as AnyObject
            if deleteImageReview == 1{
                newPAram["delete_attachment"] = deleteImageReview as AnyObject
            }
        }
        
        }
        print(newPAram)
        if editedCellIndex != -1 && editAttachment.ID == "-1" && editAttachment.image_URL == ""{
            self.array_Attachment.removeAll()
            self.array_Attachment.append(editAttachment)
        }
        if self.array_Attachment.count == 0 {
            self.showLoading()
            var url = ""
            if replyEditIndex != -1{
                url = WebServiceName.add_budz_review_reply.rawValue
            }else{
                url = WebServiceName.add_budz_review.rawValue
            }
            NetworkManager.PostCall(UrlAPI: url, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
                self.hideLoading()

                if successResponse {
                    if (DataResponse["status"] as! String) == "success" {
                        
                        self.GetBudzMapInfo()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        if self.replyEditIndex != -1{
                            self.replyEditView.isHidden = true
                            self.replyEditIndex = -1
                        }
                        
                        self.RefreshTableView()
                        self.tbleViewMain.reloadData()
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

                NetworkManager.UploadVideo( WebServiceName.add_budz_review.rawValue, imageMain: self.array_Attachment[0].image_Attachment, urlVideo: (URL.init(string: self.array_Attachment[0].video_URL)!), withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()

                    if (MainData["status"] as! String) == "success" {
                        self.array_Attachment.removeAll()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        self.RefreshTableView()
                        self.GetBudzMapInfo()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                })
            }else {
                self.showLoading()
                var gifDataUrl : URL? = nil
                if let gif_url = URL.init(string: (self.array_Attachment[0].video_URL)){
                    gifDataUrl = gif_url
                }
                //TODOFILE
                NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_budz_review.rawValue, image: self.array_Attachment[0].image_Attachment, gif_url: gifDataUrl, withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    
                    
                    if (MainData["status"] as! String) == "success" {
                        self.array_Attachment.removeAll()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        self.RefreshTableView()
                        self.GetBudzMapInfo()
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
}


extension DispensaryDetailVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.chooseBudzMap.banner.count > 5 {
            return self.chooseBudzMap.images.count + 1
        }
        return self.chooseBudzMap.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        if self.chooseBudzMap.banner.count > 5{
            if indexPath.row == 0{
                cell.imgViewMain.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.banner)!,placeholder: #imageLiteral(resourceName: "budz_bg_df"))
//                    .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.banner) , completed: nil)
            }else{
                cell.imgViewMain.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.images[indexPath.row - 1].image_path)!,placeholder: #imageLiteral(resourceName: "budz_bg_df"))
//                    .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.images[indexPath.row - 1].image_path) , completed: nil)
            }
        }else{
            cell.imgViewMain.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.images[indexPath.row].image_path)!,placeholder: #imageLiteral(resourceName: "budz_bg_df"))
//                .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue +  self.chooseBudzMap.images[indexPath.row].image_path) , completed: nil)
            
        }
        return cell
    }
    
    func loop() {
        var count = 0
        if self.chooseBudzMap.banner.count > 5 {
            count =  self.chooseBudzMap.images.count + 1
        }else{
            count =  self.chooseBudzMap.images.count
        }
        if indexPAthMain > (count - 2) {
            indexPAthMain = 0
        }else {
            indexPAthMain = indexPAthMain + 1
        }
        print(indexPAthMain)
        if count > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if self.indexPAthMain < (self.cellMain?.collectionView.numberOfItems(inSection: 0))!  && self.indexPAthMain < count {
                    self.cellMain?.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                }
            })
        }
    }
    
    func nextsliderImage()  {
        if indexPAthMain > ((self.chooseBudzMap.images.count) - 2) {
            indexPAthMain = 0
        }else {
            indexPAthMain = indexPAthMain + 1
        }
        print(indexPAthMain)
        self.cellMain?.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    func previousSliderImage()  {
        if indexPAthMain > 0 {
            indexPAthMain = indexPAthMain - 1
        }else {
            indexPAthMain = ((self.chooseBudzMap.images.count) - 1)
        }
        print(indexPAthMain)
        self.cellMain?.collectionView.scrollToItem(at: IndexPath(item: self.indexPAthMain, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
}


class BudzHeaderCell: UITableViewCell {
    
    @IBOutlet  weak var collectionView: UICollectionView!
    
    @IBOutlet var btnBack       : UIButton!
    @IBOutlet weak var btnGalleryView: UIView!
    @IBOutlet var btnGallery    : UIButton!
    @IBOutlet var btnLike       : UIButton!
    
    @IBOutlet var btnReviewBottom       : UIButton!
    @IBOutlet var btnFlag       : UIButton!
    @IBOutlet var btnShare      : UIButton!
    @IBOutlet var btnHome       : UIButton!
    @IBOutlet var btnEdit       : UIButton!
    @IBOutlet var btnMessage       : UIButton!
    
    @IBOutlet var lblName       : UILabel!
    @IBOutlet var lblReview     : UILabel!
    
    
    @IBOutlet weak var imgView_Like : UIImageView!
    @IBOutlet weak var imgView_Flag : UIImageView!
    @IBOutlet weak var imgView_BG   : UIImageView!
    @IBOutlet weak var imgView_Logo : UIImageView!
    
    @IBOutlet weak var imgView_Star1 : UIImageView!
    @IBOutlet weak var imgView_Star2 : UIImageView!
    @IBOutlet weak var imgView_Star3 : UIImageView!
    @IBOutlet weak var imgView_Star4 : UIImageView!
    @IBOutlet weak var imgView_Star5 : UIImageView!
    
    @IBOutlet weak var btn_Next : UIButton!
    @IBOutlet weak var btn_Previous : UIButton!
   
    @IBOutlet weak var view_Organic : UIView!
    @IBOutlet weak var view_Delivery : UIView!
    @IBOutlet weak var view_Message : UIView!
    @IBOutlet weak var view_Edit : UIView!
}

extension BudzHeaderCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
//        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
//    var collectionViewOffset: CGFloat {
//        set { collectionView.contentOffset.x = newValue }
//        get { return collectionView.contentOffset.x }
//    }
}


class HeaderButtonCell: UITableViewCell {
 
    @IBOutlet weak var line: UIView!
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



class TextDetailCell: UITableViewCell {
    @IBOutlet var lblDetailText   : ActiveLabel!
}


class LocationBudzCell: UITableViewCell {
    @IBOutlet var viewLocationIcon  : UIView!
    @IBOutlet var btnProductHeight  : NSLayoutConstraint!
    
    @IBOutlet var btnCall           : UIButton!
    @IBOutlet var btnWebsite        : UIButton!
    @IBOutlet var btnProducts       : UIButton!
    
    @IBOutlet var btnLocation       : UIButton!
    
    @IBOutlet weak var LblWebsite: ActiveLabel!
    @IBOutlet weak var LblLocation: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
}


class TimingofOpreationsCell: UITableViewCell {
    @IBOutlet var lblMonday : UILabel!
    @IBOutlet var lblTuesday : UILabel!
    @IBOutlet var lblWednesday : UILabel!
    @IBOutlet var lblThursday : UILabel!
    @IBOutlet var lblFriday : UILabel!
    @IBOutlet var lblSaturday : UILabel!
    @IBOutlet var lblSunday : UILabel!
    @IBOutlet weak var lblMondayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTuesdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblWednesdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblThursdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblFridayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSaturdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSundayHeight: NSLayoutConstraint!
    @IBOutlet weak var noHoursLbl: UILabel!
    
    @IBOutlet var lblMonday_Time : UILabel!
    @IBOutlet var lblTuesday_Time : UILabel!
    @IBOutlet var lblWednesday_Time : UILabel!
    @IBOutlet var lblThursday_Time : UILabel!
    @IBOutlet var lblFriday_Time : UILabel!
    @IBOutlet var lblSaturday_Time : UILabel!
    @IBOutlet var lblSunday_Time : UILabel!
    @IBOutlet weak var lblMondayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblTuesdayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblWednesdayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblThursdayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblFridayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblSaturdayHeight_time: NSLayoutConstraint!
    @IBOutlet weak var lblSundayHeight_time: NSLayoutConstraint!
    
    @IBOutlet weak var tueTop: NSLayoutConstraint!
    @IBOutlet weak var wedTop: NSLayoutConstraint!
    @IBOutlet weak var thuTop: NSLayoutConstraint!
    @IBOutlet weak var friTop: NSLayoutConstraint!
    @IBOutlet weak var satTop: NSLayoutConstraint!
    @IBOutlet weak var sunTop: NSLayoutConstraint!
}

class SocialMediaLinkCell: UITableViewCell {
    @IBOutlet var lblWebsite    : ActiveLabel!
    @IBOutlet var lblFacebook   : ActiveLabel!
    @IBOutlet var lblTwitter    : ActiveLabel!
    @IBOutlet var lblInstagram  : ActiveLabel!
    @IBOutlet var lblZipCode:   ActiveLabel!
    
    @IBOutlet weak var BtnGoogle: UIButton!
     @IBOutlet weak var BtnFacebook: UIButton!
     @IBOutlet weak var BtnTwitter: UIButton!
     @IBOutlet weak var BtnInstagram: UIButton!
    
}


class PaymentMethodCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    var array = [BudzPayment]()
    var delegate: NewBudzMapViewController!
    var index = [IndexPath]()
    @IBOutlet var noDataLabel: UILabel!
    
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        let paymentCellNib = UINib(nibName: "PaymentMethodCollectionViewCell", bundle: nil)
        collectionView.register(paymentCellNib, forCellWithReuseIdentifier: "PaymentMethodCollectionCell")
        if array.count == 0{
            collectionView.isHidden = true
        }else{
            collectionView.isHidden = false
        }
    }
    
    func paymentTapped(sender: UIButton!){
        if self.array[sender.tag].selected == 0{
           self.array[sender.tag].selected = 1
           delegate.choosePaymentArray.append(self.array[sender.tag])
        }else{
           self.array[sender.tag].selected = 0
            delegate.choosePaymentArray.remove(at: delegate.choosePaymentArray.index(where: { $0.payment_ID == self.array[sender.tag].payment_ID })!)
        }
        var indexPath = [IndexPath]()
        indexPath.append(index[sender.tag])
        collectionView.reloadItems(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodCollectionCell", for: indexPath) as! PaymentMethodCollectionViewCell
        cell.imageView.moa.url = WebServiceName.images_baseurl.rawValue + array[indexPath.row].payment_image
        if array[indexPath.row].selected == 1{
            cell.imageView.alpha = 1
        }else{
            cell.imageView.alpha = 0.6
        }
        if delegate != nil{
         cell.button.tag = indexPath.row
         self.index.append(indexPath)
         cell.button.addTarget(self, action: #selector(paymentTapped), for: .touchUpInside)
        }
        return cell
    }
  
}

class AddCommentHeaderCell: UITableViewCell {
    @IBOutlet weak var Btn_AddComment: UIButton!
    @IBOutlet weak var Show_AddComment: UIButton!
    @IBOutlet weak var lblTotalComments: UILabel!
    
    @IBOutlet weak var viewAddComment: UIView!
    
}


class BudzCommentcell: UITableViewCell {
    @IBOutlet weak var falgViewBudz: UIView!
    @IBOutlet weak var falgViewBudzWidth: NSLayoutConstraint!
    @IBOutlet weak var lbl_report_abuse: UILabel!
    @IBOutlet weak var ImgView_Star: UIImageView!
    @IBOutlet weak var ImgView_USer: UIImageView!
    @IBOutlet weak var ImgView_USerTop: UIImageView!
    @IBOutlet weak var ImgView_Attachment1: UIImageView!
    @IBOutlet weak var ImgView_Attachment2: UIImageView!
    @IBOutlet weak var ImgView_Attachment3: UIImageView!
    @IBOutlet weak var Btn_UserProfile: UIButton!
    @IBOutlet weak var btn_Attachment1: UIButton!
    @IBOutlet weak var btn_Attachment2: UIButton!
    @IBOutlet weak var btn_Attachment3: UIButton!
    @IBOutlet var likesCount: UILabel!
    @IBOutlet weak var ImgView_Attachment1_Video: UIImageView!
    @IBOutlet weak var ImgView_Attachment2_Video: UIImageView!
    @IBOutlet weak var ImgView_Attachment3_Video: UIImageView!
    @IBOutlet weak var ImgView_Flag: UIImageView!
    
    @IBOutlet weak var view_Attachment1: UIView!
    @IBOutlet weak var view_Attachment2: UIView!
    @IBOutlet weak var view_Attachment3: UIView!
    
    
    @IBOutlet weak var Btn_Rate: UIButton!
    @IBOutlet weak var Btn_Share: UIButton!
    @IBOutlet weak var Btn_Report: UIButton!
    
    @IBOutlet weak var Lbl_Rating: UILabel!
    @IBOutlet weak var Lbl_UserName: UILabel!
    @IBOutlet weak var Lbl_Time: UILabel!
    @IBOutlet weak var Lbl_Description: ActiveLabel!
    @IBOutlet weak var replyDeleteView: UIView!
    @IBOutlet weak var replyDeleteButton: UIButton!
    @IBOutlet weak var replyDeleteViewWidth: NSLayoutConstraint!
    @IBOutlet weak var replyEditView: UIView!
    @IBOutlet weak var replyEditButton: UIButton!
    @IBOutlet weak var replyEditViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentDeleteView: UIView!
    @IBOutlet weak var commentDeleteButton: UIButton!
    @IBOutlet weak var commentDeleteViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentEditViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentEditView: UIView!
    @IBOutlet weak var commentEditButton: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyTimeAgo: UILabel!
    @IBOutlet weak var replyDescription: UILabel!
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var reviewLikeButton: UIButton!
    
}


class AddYourCommentCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!
}

class EnterCommentCell: UITableViewCell {
    @IBOutlet var txtviewMain : UITextView!
    @IBOutlet var lblTextcount : UILabel!
}


class UploadBudzCell: UITableViewCell {
      @IBOutlet var btnUpload : UIButton!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
}

class ShoeMediaCell: UITableViewCell {
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var imgViewImage : UIImageView!
    @IBOutlet var imgViewVideo : UIImageView!
    
    
}

class AddRatingcell: UITableViewCell {
    @IBOutlet var viewRating : CosmosView!
}


class SubmitBudzCell: UITableViewCell {
    @IBOutlet var btnSubmit : UIButton!
}

class BudzProductCell: UITableViewCell {
    @IBOutlet var lblName        : UILabel!
    @IBOutlet var lblCBD         : UILabel!
    @IBOutlet var lblTHC         : UILabel!
    @IBOutlet weak var btn_delete_product: UIButton!
    @IBOutlet var lblDistance    : UILabel!
    @IBOutlet weak var img_edit: UIImageView!
    @IBOutlet weak var edit_height: NSLayoutConstraint!
    @IBOutlet weak var edit_display: UIView!
    @IBOutlet var lblCount      : UILabel!
    @IBOutlet var lblType      : UILabel!
    @IBOutlet var imageCountImage: UIImageView!
    @IBOutlet var strainArrow: UIImageView!
    @IBOutlet weak var btn_edit_product: UIButton!
    @IBOutlet var strainLeaf: UIImageView!
    @IBOutlet weak var btn_image: UIButton!
    @IBOutlet var lblSectionName      : UILabel!
    @IBOutlet var lblSectionNameConstraint      : NSLayoutConstraint!
    @IBOutlet var lblConstraintView      : NSLayoutConstraint!
    
    @IBOutlet weak var hybridViewWidth: NSLayoutConstraint!
    @IBOutlet var lblConstraintViewMain      : NSLayoutConstraint!
    @IBOutlet var strainTypeLabel: UILabel!
    @IBOutlet var strainTypeView: UIView!
    @IBOutlet var viewFirst     : UIView!
    @IBOutlet var viewSecond    : UIView!
    @IBOutlet var viewThird     : UIView!
    @IBOutlet var viewFourth    : UIView!
    
    @IBOutlet var imgViewMain    : UIImageView!
    
    @IBOutlet var lblWeight_1  : UILabel!
    @IBOutlet var lblWeight_2  : UILabel!
    @IBOutlet var lblWeight_3  : UILabel!
    @IBOutlet var lblWeight_4  : UILabel!
    
    @IBOutlet var lblPrice_1  : UILabel!
    @IBOutlet var lblPrice_2  : UILabel!
    @IBOutlet var lblPrice_3  : UILabel!
    @IBOutlet var lblPrice_4  : UILabel!
    
    @IBOutlet var btnShare  : UIButton!
    @IBOutlet var btnDetail  : UIButton!
}



class SpecialBudzCell: UITableViewCell {
    @IBOutlet var viewMainBg : UIView!
    @IBOutlet var lblExpire : UILabel!
    @IBOutlet var lblSpecialOffer: UILabel!
    @IBOutlet var specialOfferHeight: NSLayoutConstraint!
    @IBOutlet var lblName : ActiveLabel!
    @IBOutlet weak var btn_edit_sp: UIButton!
    @IBOutlet weak var img_edit_sp: UIImageView!
    @IBOutlet var lblDescription : ActiveLabel!
    @IBOutlet var lblTime : UILabel!
    
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var btn_Share: UIButton!
    
    @IBOutlet weak var imgView_Save: UIImageView!
}

class MedicalLanguagesCell : UITableViewCell {
    @IBOutlet weak var lblLanguage          : UILabel!
    @IBOutlet weak var lblInsuranceAccepted : UILabel!
}

class BudzHeadingWithTextcell : UITableViewCell {
    @IBOutlet weak var lblHeading          : UILabel!
    @IBOutlet weak var lblDescription      : UILabel!
}

class EventTimingCell : UITableViewCell {
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblTime      : UILabel!
}

class BudzServiceCell : UITableViewCell {
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var lblDescription      : UILabel!
    @IBOutlet weak var imgViewMain      : UIImageView!
    @IBOutlet weak var btnShare      : UIButton!
    
    @IBOutlet weak var edit_height: NSLayoutConstraint!
    @IBOutlet weak var edit_diplsay: UIView!
    @IBOutlet var lblSectionName      : UILabel!
    @IBOutlet var lblSectionNameConstraint      : NSLayoutConstraint!
    @IBOutlet var lblConstraintView      : NSLayoutConstraint!
    @IBOutlet weak var img_edit: UIImageView!
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_img: UIButton!
    @IBOutlet var lblConstraintViewMain      : NSLayoutConstraint!
}


class ImageCollectionCell: UICollectionViewCell {
    
   @IBOutlet weak var imgViewMain      : FLAnimatedImageView!

}
