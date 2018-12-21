//
//  NewBudzMapViewController.swift
//  BaseProject
//
//  Created by macbook on 16/10/2017.
//  Copyright © 2017 Wave. All rights reserved.

import UIKit
import MapKit
import AAPickerView
import CoreLocation
import GooglePlaces
import ObjectMapper
import SDWebImage
class TipInCellAnimator {
    class func animate(cell:UITableViewCell) {
    }
}

class NewBudzMapViewController: BaseViewController , CameraDelegate  , makePremiumDelegate  , refreshDataDelgate {
    func refreshData() {
        self.showTag = 2
        self.GetBudzMapInfo()
    }
    
  @IBOutlet weak var addProductView: UIView!
    @IBOutlet var tbleView_NewBudz : UITableView!
    var tagVal : Int  = -1;
    var paymentMethodsArray = [String]()
    var array_table = [[String: Any]]()
    var rtestVr = 0
    var isUploadImage : Bool = false
    var tick_selected_index =  -9
    var tick_selected_index_title =  "Dispensary"
    var isBannerChoose = false
    var isMedicalCellExpand = false
    var typeMain = 0
    let datePicker = UIDatePicker()
    var isSubscribed : Bool?
    var sub_user_id : String?
    var showTag = 0
    var array_Special = [BudzMapSpecial]()
    var array_Services = [BudzMapServices]()
    var budz_specials = [Specials]()
    var budz_tickets = [Ticktes]()
    var isTitleUpdate : Bool = false
    var updated_title : String = ""
    var dataArray = [BudzType]()
    var langaugeArray = [BudzLanguage]()
    var paymentArray = [BudzPayment]()
    var chooseLangaugeArray = [BudzLanguage]()
    var array_Product = [StrainProduct]()
    var choosePaymentArray = [BudzPayment]()
    let manager = CLLocationManager()
    var textViewValues = ["Add Short Description", "Office policies & Information","Pre-visit Requirements","Description..." ]
    var completeAddress = ""
    var addresslat = ""
    var addresslong = ""
    var afterCompleting = 0
    var business_type_id = "1"
    var dateSelect = ""
    var hideorganic = false
    var mapViewMain = MKMapView()
    var newPin1  = budzAnnotation()
    var insuranceCheck = false
    var expandMedical = false
    var expandEntertainment = false
    var chooseBudzMap = BudzMap()
    var fromPaymentPopUp = false
    var placesClient: GMSPlacesClient!
    var state = ""
    var AttachmentMain = Attachment()
    var AttachmentBanner = Attachment()
    var AttachmentOther = Attachment()
    var strain_Array : [[String : Any]] = [[String : Any]]()
    var croped_image_url = ""
    var placeHolderAddress = ""
    var phoneNo = ""
    var emailInfo = ""
    var zipCodeInfo = ""
    var otherImageTake = false
    var fiveBack = false
    var previousimage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MainDataLoad()
        self.RegisterXibNewBudz()
        self.MapReload()
        self.tbleView_NewBudz.keyboardDismissMode = .onDrag
        placesClient = GMSPlacesClient.shared()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onClickCross(_ sender: Any) {
        self.addProductView.isHidden = true
    }
    
    func GetAllLanguage(){
        if self.chooseBudzMap.id == 0 {
            self.showLoading()
        }
        self.langaugeArray.removeAll()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_languages.rawValue) { (successResponse, messageResponse, MainResponse) in
            print(MainResponse)
            
            if self.chooseBudzMap.id == 0 {

              self.hideLoading()
            }
//
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    if let data = MainResponse["successData"] as? [String : Any] {
                        if let mainData = data["languages"] as? [[String : Any]]{
                            for indexObj in mainData {
                                self.langaugeArray.append(BudzLanguage.init(json: indexObj as [String : AnyObject] ))
                            }
                        }
                        if let payData = data["payment_methods"] as? [[String : Any]]{
                            for indexPayObj in payData {
                                self.paymentArray.append(BudzPayment.init(json: indexPayObj as [String : AnyObject] ))
                            }
                        }
                        
                        if self.chooseBudzMap.payments.count != 0{
                            for pay in self.chooseBudzMap.payments{
                                let index: Int! = self.paymentArray.index(where: {$0.payment_ID == pay.payment_ID})
                                self.paymentArray[index].selected = 1
                                self.choosePaymentArray.append(pay)
                            }
                        }
                        
                       
                    }
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }

    
    func MedicalDataload(){
        self.DefaultData()
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.AddLanguage.rawValue ])
        
        var index = 0
        for _ in self.chooseLangaugeArray {
            array_table.append(["type" : NewBudzMapDataType.ShowLanguage.rawValue , "index" : index])
            index = index + 1
        }
        array_table.append(["type" : NewBudzMapDataType.InsuranceAccepted.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 4])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 5])
        array_table.append(["type" : NewBudzMapDataType.Payment.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.HoursofOpreation.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        self.tblReload()
    }
    
    
    func CannabitesDataload(){
        self.self.DefaultData()
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.Payment.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.HoursofOpreation.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        self.tblReload()
    }
    
    
    func EntertainmentDataload(){
        self.DefaultData()
        
        
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.Payment.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.HoursofOpreation.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        self.tblReload()
    }
    
    func tblReload() {
        UIView.setAnimationsEnabled(false)
        self.tbleView_NewBudz.beginUpdates()
        UIView.transition(with: self.tbleView_NewBudz,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tbleView_NewBudz.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        })
        self.tbleView_NewBudz.endUpdates()
    }
    
    func EventDataload(){
        self.self.DefaultData()
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.Payment.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EventTime.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        self.tblReload()
    }
    
    
    func DispensaryDataload(){
        self.DefaultData()
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.Payment.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.HoursofOpreation.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        
        self.tblReload()

    }
    
    func OtherDataLoad(){
        self.DefaultData()
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 1])
        array_table.append(["type" : NewBudzMapDataType.EnterText.rawValue , "index" : 2])
        
        array_table.append(["type" : NewBudzMapDataType.Location.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Contact.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.UploadButton.rawValue ])
        if self.chooseBudzMap.others_image != "" && self.chooseBudzMap.others_image != nil{
            self.AttachmentOther.ID = "-1"
            self.AttachmentOther.server_URL = WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.others_image
            if let url = URL(string: (WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.others_image)){
                do{
                    let imageData = try Data(contentsOf: url)
                    self.AttachmentOther.image_Attachment = UIImage(data: imageData)!
                }catch{
                    print(error)
                }
                
            }
        }
        if AttachmentOther.ID == "-1"{
            array_table.append(["type" : NewBudzMapDataType.OtherAttachment.rawValue ])
        }
        array_table.append(["type" : NewBudzMapDataType.SubmitButton.rawValue ])
        
        self.tblReload()
    }
    
    func DefaultData(){
        self.array_table.removeAll()
        array_table.append(["type" : NewBudzMapDataType.Header.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.MenuButton.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.Heading.rawValue ])
        if expandMedical && expandEntertainment{
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            if self.chooseBudzMap.is_featured != 1{
                array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            }
        }else if !expandMedical && !expandEntertainment{
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            if self.chooseBudzMap.is_featured != 1{
                array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            }
        }else if !expandMedical && expandEntertainment{
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            if self.chooseBudzMap.is_featured != 1{
                array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            }
        }else if expandMedical && !expandEntertainment{
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            if self.chooseBudzMap.is_featured != 1{
                array_table.append(["type" : NewBudzMapDataType.BudzType.rawValue ])
            }
        }
    }
    
    func makePremium(isSubscribed: Bool, sub_user_id: String) {
       self.isSubscribed = isSubscribed
       self.fromPaymentPopUp = true
       self.sub_user_id = sub_user_id
       self.chooseBudzMap.is_featured = 1
       self.navigationController?.navigationBar.isHidden = true
        self.oneBtnCustomeAlert(title: "Congratulations!", discription: "Your business is now paid.") { (isConfirm, i) in
            if let cellBtnHeading = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? HeaderButtonCell {
                cellBtnHeading.viewMiddel.isUserInteractionEnabled = false
                cellBtnHeading.viewRight.isUserInteractionEnabled = false
                cellBtnHeading.lblMiddel.isHidden = true
                cellBtnHeading.lblRight.isHidden = true
                cellBtnHeading.line.isHidden = true
                cellBtnHeading.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
                cellBtnHeading.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
            }
        }
    }

    func MainDataLoad(){
        let budgType1 = BudzType()
        budgType1.title = "Dispensary"
        budgType1.imageShown = true
        budgType1.image = UIImage.init(named: "DispensaryIcon")
        budgType1.tickType = 1
        budgType1.DataType = 1
        budgType1.business_type_id = "1"
        
        let budgType2 = BudzType()
        budgType2.title = "Medical"
        budgType2.imageShown = true
        budgType2.image = UIImage.init(named: "MedicalIcon")
        budgType2.tickType = 0
        budgType2.DataType = 2
        budgType2.business_type_id = "2"
        
        let budgType3 = BudzType()
        budgType3.title = "Medical Practitioner"
        budgType3.imageShown = false
        budgType3.tickType = 1
        budgType3.DataType = 2
        budgType3.business_type_id = "2"
        
        let budgType4 = BudzType()
        budgType4.title = "Holistic Medicine"
        budgType4.imageShown = false
        budgType4.tickType = 1
        budgType4.DataType = 2
        budgType4.business_type_id = "6"
        
        let budgType5 = BudzType()
        budgType5.title = "Clinic"
        budgType5.imageShown = false
        budgType5.tickType = 1
        budgType5.DataType = 2
        budgType5.business_type_id = "7"
        
        let budgType6 = BudzType()
        budgType6.title = "Cannabites"
        budgType6.imageShown = true
        budgType6.image = UIImage.init(named: "CannabitesIcon")
        budgType6.tickType = 1
        budgType6.DataType = 3
        budgType6.business_type_id = "3"
        
        let budgType7 = BudzType()
        budgType7.title = "Entertainment"
        budgType7.imageShown = true
        budgType7.image = UIImage.init(named: "EntertainmentIcon")
        budgType7.tickType = 0
        budgType7.DataType = 4
        budgType7.business_type_id = "4"

        let budgType8 = BudzType()
        budgType8.title = "Lounge"
        budgType8.imageShown = false
        budgType8.tickType = 1
        budgType8.DataType = 4
        budgType8.business_type_id = "4"
        
        let budgType9 = BudzType()
        budgType9.title = "Cannabis Club/Bar"
        budgType9.imageShown = false
        budgType9.tickType = 1
        budgType9.DataType = 4
        budgType9.business_type_id = "8"
    
        let budgType10 = BudzType()
        budgType10.title = "Events"
        budgType10.imageShown = true
        budgType10.image = UIImage.init(named: "EventsIcon")
        budgType10.tickType = 1
        budgType10.DataType = 5
        budgType10.business_type_id = "5"
        
        let budgType11 = BudzType()
        budgType11.title = "Others"
        budgType11.imageShown = true
        budgType11.image = UIImage.init(named: "OthersIcon")
        budgType11.tickType = 1
        budgType11.DataType = 6
        budgType11.business_type_id = "9"
        
        self.dataArray.removeAll()
        self.dataArray.append(budgType1)
        self.dataArray.append(budgType2)
        if expandMedical{
            self.dataArray.append(budgType3)
            self.dataArray.append(budgType4)
            self.dataArray.append(budgType5)
        }
        self.dataArray.append(budgType6)
        self.dataArray.append(budgType7)
        if expandEntertainment{
            self.dataArray.append(budgType8)
            self.dataArray.append(budgType9)
        }
        self.dataArray.append(budgType10)
        if self.chooseBudzMap.is_featured != 1{
        self.dataArray.append(budgType11)
        }
        
        
        for i in 0...self.dataArray.count - 1{
            
            let obj = self.dataArray[i]
            
            
            if obj.business_type_id == String(self.chooseBudzMap.budzMapType.idType) {
                if obj.title == "Medical" || obj.title == "Entertainment"{
                    obj.tickType = 0
                }else{
                    if obj.title == self.chooseBudzMap.budzMapType.title{
                    obj.tickType = 2
                    }else{
                        obj.tickType = 1
                    }
                }
            }else if obj.title == "Medical" || obj.title == "Entertainment"{
                obj.tickType = 0
            }else{
                if self.chooseBudzMap.id > 0{
                    if obj.title == self.chooseBudzMap.budzMapType.title{
                        obj.tickType = 2
                        self.tick_selected_index_title = obj.title!
                    }else{
                        obj.tickType = 1
                        self.tick_selected_index_title = ""
                    }
                }else{
                    obj.tickType = 1
                }
            }
            
            
            self.dataArray[i] = obj
        }
        
        self.DatePickerRefresh()
    }
    
    func DatePickerRefresh(){
        datePicker.frame = CGRect(x: 0, y: 00, width: self.view.frame.width, height: 220)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .time
        
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.getStateFromZip()
        if self.isRefreshonWillAppear {
            print(self.chooseBudzMap.id)
            print("BudzMap")
            self.GetAllLanguage()
            if self.chooseBudzMap.id == 0 {
                self.tagVal = 0
                self.reinstiate()
                self.DispensaryDataload()
            }else {
                print(self.chooseBudzMap.budzMapType.idType)
                if self.chooseBudzMap.business_type_id != "0" {
                    self.GetBudzMapInfo()
                }else{
                    self.tagVal = 0
                    self.reinstiate()
                    self.DispensaryDataload()
                }
                
            }
            
        }
        
       self.isRefreshonWillAppear = false
        if self.afterCompleting == 1 {
            
        }else {
            self.disableMenu()
        }
        
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.enableMenu()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func refreshTabs(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        self.GetBudzMapInfo()
            //        self.SelectOptions(value: self.showTag)
        })
    }
    
    
    func GetBudzMapInfo(){
        self.showLoading()
        var newURL = WebServiceName.get_budz_profile.rawValue + String(self.chooseBudzMap.id) + "?lat="
        newURL = newURL + (DataManager.sharedInstance.user?.userlat)! + "&lng=" + (DataManager.sharedInstance.user?.userlng)!
        print(newURL)
        NetworkManager.GetCall(UrlAPI: newURL) { (successResponse, MessageResponse, DataResponse) in
            self.hideLoading()
            print(DataResponse)
            if  let strain = DataResponse["strains"] as? [[String : Any]]{
                self.strain_Array = strain
            }
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    let mainData = DataResponse["successData"] as! [String : AnyObject]
                    
                    self.chooseBudzMap = BudzMap.init(json: mainData)
                    self.business_type_id = String(self.chooseBudzMap.budzMapType.idType)
                    self.choosePaymentArray = self.chooseBudzMap.payments
                    
                    for pay in self.choosePaymentArray{
                        self.paymentArray[self.paymentArray.index(where: {$0.payment_ID == pay.payment_ID})!].selected = 1
                    }
                    for lng in self.chooseBudzMap.languageArray{
                        if let ind = self.langaugeArray.index(where: {$0.language_ID == lng.language_ID}) {
                            self.chooseLangaugeArray.append(self.langaugeArray[ind])
                        }
                    }
                    
                    let productsData = mainData["products"] as! [[String : AnyObject]]
                    
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
                    
                    self.completeAddress = self.chooseBudzMap.location
                    for i in 0...self.dataArray.count - 1{
                        
                        let obj = self.dataArray[i]
                        
                        
                        if obj.business_type_id == String(self.chooseBudzMap.budzMapType.idType) {
                           if obj.title == "Medical" || obj.title == "Entertainment"{
                             obj.tickType = 0
                            }else{
                            if obj.title == self.chooseBudzMap.budzMapType.title{
                                obj.tickType = 2
                            }else{
                                obj.tickType = 1
                            }
                            }
                        }else if obj.title == "Medical" || obj.title == "Entertainment"{
                            obj.tickType = 0
                        }else{
                            if self.chooseBudzMap.id > 0{
                                if obj.title == self.chooseBudzMap.budzMapType.title{
                                    obj.tickType = 2
                                }else{
                                    obj.tickType = 1
                                }
                            }else{
                            obj.tickType = 1
                            }
                        }
                        
                        
                        self.dataArray[i] = obj
                    }
                    if self.showTag ==  0 {
                        if self.chooseBudzMap.budzMapType.idType == 5 {
                            self.hideorganic = true
                            self.EventDataload()
                        }else if self.chooseBudzMap.budzMapType.idType == 2 || self.chooseBudzMap.budzMapType.idType == 6 || self.chooseBudzMap.budzMapType.idType == 7 {
                            self.hideorganic = false
                            self.MedicalDataload()
                        }else if self.chooseBudzMap.budzMapType.idType == 1 {
                            self.hideorganic = false
                            self.DispensaryDataload()
                        }else if self.chooseBudzMap.budzMapType.idType == 3 {
                            self.hideorganic = false
                            self.CannabitesDataload()
                        }else if self.chooseBudzMap.budzMapType.idType == 4 || self.chooseBudzMap.budzMapType.idType == 8 {
                            self.hideorganic = true
                            self.EntertainmentDataload()
                        }else if self.chooseBudzMap.budzMapType.idType == 9 {
                            self.hideorganic = true
                            self.OtherDataLoad()
                        }else{
                            self.hideorganic = false
                            self.DispensaryDataload()
                        }
                    }else if self.showTag == 1{
                        self.LoadProduct()
                    }else{
                        self.LoadSpecial()
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
            
        }
    }
    
    func getStateFromZip() {
        NetworkManager.getUserAddressFromZipCode(zipcode: (DataManager.sharedInstance.user?.zipcode)!, completion: { (success, message, response) in
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
                }else{
                }
            }
        })
    }
    
    func checkStateFromZip(zipcode : String ,complition : @escaping(Bool) -> Void) {
        NetworkManager.getUserAddressFromZipCode(zipcode: zipcode, completion: { (success, message, response) in
            print(message)
            print(response ?? "text" )
            print(response!["results"] ?? "text")
            if(success){
                if( ((response!["results"] as! [[String : Any]]).count) > 0){
                    let location =  (response!["results"] as! [[String : Any]])[0]["address_components"] as! [[String: AnyObject]]
                    var isMatched = true
                    for lct in location{
                        let st  = lct["long_name"] as! String
                        if self.states.contains(st){
                            isMatched = false
                            complition(false)
                            return
                        }
                    }
                    if !isMatched {
                        complition(true)
                    }
                    
                }else{
                     complition(false)
                }
            }else{
                complition(false)
            }
        })
    }
    
    
    func checkState() -> Bool{
        if states.contains(self.state){
            return false
        }else{
            return true
        }
    }
    func checkStateInitisl() -> Bool{
        for testt in stateInitial {
           if  self.completeAddress.contains(testt) {
                return false
            }
        }
        return true
        
    }
    
    func MapReload(){
        
        self.mapViewMain = MKMapView.init(frame: CGRect.init(x: 0, y: 0, width: self.tbleView_NewBudz.frame.size.width, height: 161))
        self.tbleView_NewBudz.delegate = self
        self.tbleView_NewBudz.dataSource = self
        
        self.mapViewMain.showsUserLocation = true
        self.mapViewMain.delegate = self
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        
        
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        
    }
    
    
    func dropPin(location:CLLocation) {
        

        
        for indexObj in self.mapViewMain.annotations {
            self.mapViewMain.removeAnnotation(indexObj)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        self.mapViewMain.addAnnotation(annotation)
//
//
//        let newPin1 = budzAnnotation()
//
////        newPin1.type = 1
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        newPin1.title = ""
//        self.mapViewMain.setRegion(region, animated: true)
//        newPin1.coordinate = location.coordinate
//        self.mapViewMain.addAnnotation(newPin1)
        
    }
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: self.mapViewMain)
            let newCoordinate = self.mapViewMain.convert(touchPoint, toCoordinateFrom: self.mapViewMain)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare! + " "
                            
                        }
                    }
                    
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                print(newCoordinate)
                annotation.title = title
                
                self.mapViewMain.addAnnotation(annotation)
                
            })
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinTintColor = .purple
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = false
            pinAnnotationView.animatesDrop = true
            return pinAnnotationView
        }
       return nil
    }
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView?.isDraggable = true
//        }
//        else {
//            pinView?.annotation = annotation
//        }
//
//
//        switch typeMain {
//        case 1 :
//            pinView?.image = UIImage(named: "DispensaryMap")
//            break
//
//        case 3:
//            pinView?.image = UIImage(named: "CannbitesMap")
//            break
//        case 4:
//            pinView?.image = UIImage(named: "ticketMap")
//            break
//        case 5:
//            pinView?.image = UIImage(named: "EventMap")
//            break
//
//        default:
//            pinView?.image = UIImage(named: "MedicalMap")
//            break
//
//        }
//
//
//
//        return pinView
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        print("MKAnnotationViewDragState")
        print("\(newState)")
        switch newState {
        case .ending, .canceling:
            let droppedAt =  view.annotation?.coordinate
            print("dropped at  lat \(droppedAt?.latitude ?? 0.0) lng \(String(describing: droppedAt?.longitude))")
            view.dragState = .none

            self.addresslat = String((droppedAt?.latitude)!)
            self.addresslong = String((droppedAt?.longitude)!)

           self.GetAddress(location: CLLocation.init(latitude: (droppedAt?.latitude)!, longitude: (droppedAt?.longitude)!))
        default:
            break
        }
    }
    
    
    func GetAddress(location : CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in

            if error != nil {

            } else {

                var Country = ""
                
                if let placemark = placemarks?[0] {

                    if let arrayAddress = placemark.addressDictionary!["FormattedAddressLines"] as? [String] {
                        for indexObj in arrayAddress {
                            if Country.count > 0 {
                                Country = Country + ", " + indexObj
                            }else {
                                Country = indexObj
                            }
                            
                        }
                    }
                }

                print(Country)
                self.completeAddress = Country
                self.placeHolderAddress = Country
                
                let tableSubviews =       self.tbleView_NewBudz.subviews
                
                for indexObj in tableSubviews{
                    if let cellInfo = indexObj as? AddInfoCell {
                        if cellInfo.Lbl_title.text == "Add Location" {
                            cellInfo.txtView_Main.text = self.completeAddress
                            if self.rtestVr == 0 {
                                self.rtestVr = 1
                                 self.tbleView_NewBudz.reloadData()
                            }
                        }
                        
                    }
                }
                
                
            }
        })
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
    
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.dropPin(location: location)
        manager.stopUpdatingLocation()
        self.mapViewMain.setRegion(region, animated: true)
        self.addresslat = String(location.coordinate.latitude)
        self.addresslong = String(location.coordinate.longitude)
       if !(self.chooseBudzMap.id > 0) {
             self.GetAddress(location: location)
       }
    
    }
}

//MARK:
//MARK: TbleView Delegate
extension NewBudzMapViewController : UITableViewDataSource, UITableViewDelegate{
    
    func RegisterXibNewBudz(){
        //AddNewProductServices
        self.tbleView_NewBudz.register(UINib(nibName: "NewBudzHeaderCell", bundle: nil), forCellReuseIdentifier: "NewBudzHeaderCell")
        self.tbleView_NewBudz.register(UINib(nibName: "AddNewProductServices", bundle: nil), forCellReuseIdentifier: "AddNewProductServices")
         self.tbleView_NewBudz.register(UINib(nibName: "MedicalCell", bundle: nil), forCellReuseIdentifier: "MedicalCell")
        self.tbleView_NewBudz.register(UINib(nibName: "HeaderButtonCell", bundle: nil), forCellReuseIdentifier: "HeaderButtonCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzProductCell", bundle: nil), forCellReuseIdentifier: "BudzProductCell")
        self.tbleView_NewBudz.register(UINib(nibName: "ChooseTypeCell", bundle: nil), forCellReuseIdentifier: "ChooseTypeCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzSelectTypeCell", bundle: nil), forCellReuseIdentifier: "BudzSelectTypeCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzSelectTypeCell2", bundle: nil), forCellReuseIdentifier: "BudzSelectTypeCell2")
        self.tbleView_NewBudz.register(UINib(nibName: "AddInfoCell", bundle: nil), forCellReuseIdentifier: "AddInfoCell")
        self.tbleView_NewBudz.register(UINib(nibName: "MapViewCell", bundle: nil), forCellReuseIdentifier: "MapViewCell")
        self.tbleView_NewBudz.register(UINib(nibName: "NewBudzContactCell", bundle: nil), forCellReuseIdentifier: "NewBudzContactCell")
        self.tbleView_NewBudz.register(UINib(nibName: "HoursofOpreationCell", bundle: nil), forCellReuseIdentifier: "HoursofOpreationCell")
         self.tbleView_NewBudz.register(UINib(nibName: "SubmitButtonCell", bundle: nil), forCellReuseIdentifier: "SubmitButtonCell")
        self.tbleView_NewBudz.register(UINib(nibName: "LanguageSelectCell", bundle: nil), forCellReuseIdentifier: "LanguageSelectCell")
        self.tbleView_NewBudz.register(UINib(nibName: "EventTimeCell", bundle: nil), forCellReuseIdentifier: "EventTimeCell")
        self.tbleView_NewBudz.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")

        self.tbleView_NewBudz.register(UINib(nibName: "LanguageShowCell", bundle: nil), forCellReuseIdentifier: "LanguageShowCell")

        
        self.tbleView_NewBudz.register(UINib(nibName: "notificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")

        
        self.tbleView_NewBudz.register(UINib(nibName: "BudzHeaderCell", bundle: nil), forCellReuseIdentifier: "BudzHeaderCell")
        self.tbleView_NewBudz.register(UINib(nibName: "HeaderButtonCell", bundle: nil), forCellReuseIdentifier: "HeaderButtonCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzServiceCell", bundle: nil), forCellReuseIdentifier: "BudzServiceCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "AddSpecialCell", bundle: nil), forCellReuseIdentifier: "AddSpecialCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "EvnetPaymentMethodsCell", bundle: nil), forCellReuseIdentifier: "EvnetPaymentMethodsCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "EventPurchaseTicketCell", bundle: nil), forCellReuseIdentifier: "EventPurchaseTicketCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "EventTicktesCell", bundle: nil), forCellReuseIdentifier: "EventTicktesCell")
        
        
        self.tbleView_NewBudz.register(UINib(nibName: "TextDetailCell", bundle: nil), forCellReuseIdentifier: "TextDetailCell")
        self.tbleView_NewBudz.register(UINib(nibName: "LocationBudzCell", bundle: nil), forCellReuseIdentifier: "LocationBudzCell")
        self.tbleView_NewBudz.register(UINib(nibName: "TimingofOpreationsCell", bundle: nil), forCellReuseIdentifier: "TimingofOpreationsCell")
        self.tbleView_NewBudz.register(UINib(nibName: "SocialMediaLinkCell", bundle: nil), forCellReuseIdentifier: "SocialMediaLinkCell")
        self.tbleView_NewBudz.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        self.tbleView_NewBudz.register(UINib(nibName: "AddCommentHeaderCell", bundle: nil), forCellReuseIdentifier: "AddCommentHeaderCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzCommentcell", bundle: nil), forCellReuseIdentifier: "BudzCommentcell")
        self.tbleView_NewBudz.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
        self.tbleView_NewBudz.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.tbleView_NewBudz.register(UINib(nibName: "UploadBudzCell", bundle: nil), forCellReuseIdentifier: "UploadBudzCell")
        self.tbleView_NewBudz.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.tbleView_NewBudz.register(UINib(nibName: "AddRatingcell", bundle: nil), forCellReuseIdentifier: "AddRatingcell")
        self.tbleView_NewBudz.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        self.tbleView_NewBudz.register(UINib(nibName: "BudzProductCell", bundle: nil), forCellReuseIdentifier: "BudzProductCell")
        self.tbleView_NewBudz.register(UINib(nibName: "AddProductCell", bundle: nil), forCellReuseIdentifier: "AddProductCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "SpecialBudzCell", bundle: nil), forCellReuseIdentifier: "SpecialBudzCell")
        self.tbleView_NewBudz.register(UINib(nibName: "UploadBudzCell", bundle: nil), forCellReuseIdentifier: "UploadBudzCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.tbleView_NewBudz.register(UINib(nibName: "MedicalLanguagesCell", bundle: nil), forCellReuseIdentifier: "MedicalLanguagesCell")
        
        self.tbleView_NewBudz.register(UINib(nibName: "BudzHeadingWithTextcell", bundle: nil), forCellReuseIdentifier: "BudzHeadingWithTextcell")
        
        
        self.tbleView_NewBudz.register(UINib(nibName: "EventTimingCell", bundle: nil), forCellReuseIdentifier: "EventTimingCell")
        
        
         self.tbleView_NewBudz.register(UINib(nibName: "NoRecordFoundCell", bundle: nil), forCellReuseIdentifier: "NoRecordFoundCell")

        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array_table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dictValue = array_table[indexPath.row]
        let dataType = dictValue["type"] as! String
        switch dataType  {
            
        case NewBudzMapDataType.BudzType.rawValue:
           return BudzSelectTypeCell(tableView:tableView ,cellForRowAt:indexPath)
        
        case NewBudzMapDataType.Heading.rawValue:
            return ChooseTypeHeadingCell(tableView:tableView ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.MenuButton.rawValue:
            return HeadingButtonxell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.EnterText.rawValue:
            return AddInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.Payment.rawValue:
            return addPaymentCell(tableView: tableView, cellForRowAt: indexPath)
            
        case NewBudzMapDataType.Location.rawValue:
            return MapCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.Contact.rawValue:
            return BudzContactCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case NewBudzMapDataType.UploadButton.rawValue:
            return UPloadBudzButtonCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.OtherAttachment.rawValue:
            return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.HoursofOpreation.rawValue:
            return OpreationCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.SubmitButton.rawValue:
            return submitButtonCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case NewBudzMapDataType.AddLanguage.rawValue:
            return LanguageCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case NewBudzMapDataType.EventTime.rawValue:
            return EventTimeCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case NewBudzMapDataType.ShowLanguage.rawValue:
            return LanguageshowCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        
        case NewBudzMapDataType.InsuranceAccepted.rawValue:
            return notificationCell(tableView:tableView  ,cellForRowAt:indexPath)
    
        case BudzMapDataType.BudzService.rawValue:
            return BudzServiceCel(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.BudzProduct.rawValue:
            return StrainProductCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case BudzMapDataType.BudzSpecial.rawValue:
            return SpecialBudzCell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.addSpecial.rawValue:
            return AddSpecialCell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.NoRecord.rawValue:
            return NoRecodFoundCell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.NoRecordtext.rawValue:
            return NoRecodFoundCellText(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.addProductServices.rawValue:
            return addNewProductServices(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.eventPaymentMethods.rawValue:
            return EventTicketPaymentMethods(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.evnetPurchaseTicketCell.rawValue:
            return EventPurchaseTicketCell(tableView:tableView  ,cellForRowAt:indexPath)
        case BudzMapDataType.eventTicktes.rawValue:
            return EventTicktesCell(tableView:tableView  ,cellForRowAt:indexPath)
        default:
            return HeadingNewCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
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
    
    
    func SpecialBudzCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellSpecial = tableView.dequeueReusableCell(withIdentifier: "SpecialBudzCell") as! SpecialBudzCell
        
        let dictValue = array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        cellSpecial.lblName.applyTag(baseVC: self , mainText: self.budz_specials[indexMain].title)
        cellSpecial.lblDescription.applyTag(baseVC: self , mainText: self.budz_specials[indexMain].discription)
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
        let link : String = Constants.ShareLinkConstant + "get-budz-product/\(self.array_Product[sender.tag].ID)" + "/" + "\(self.chooseBudzMap.id)"
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
                            self.SelectOptions(value: 2)
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
        let link : String = Constants.ShareLinkConstant + "get-budz-service/\(self.array_Services[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    func ShareActionSpecial(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.budz_specials[sender.tag].id)"
        parmas["type"] = "Budz Special"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz-special/\(self.budz_specials[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
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
        if self.array_Product[indexMain].isAlsoStrain && self.array_Product[indexMain].titleDisplay != "Others"{
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
        
        cellStrainBud.lblCBD.text = self.array_Product[indexMain].cbd + "% CBD | "
        cellStrainBud.lblName.text = self.array_Product[indexMain].name
        cellStrainBud.lblTHC.text = self.array_Product[indexMain].thc + "% THC"
        
        print(self.array_Product[indexMain].images.count)
        if self.array_Product[indexMain].images.count > 0{
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
        if (self.array_Product[indexMain].straintype?.title.count)! > 2 && self.array_Product[indexMain].titleDisplay != "Others"{
            cellStrainBud.lblType.text = self.array_Product[indexMain].straintype?.title
            
        }else{
            cellStrainBud.lblType.text = ""
        }
        
        cellStrainBud.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellStrainBud.img_edit.image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
        cellStrainBud.img_edit.tintColor = .white
        cellStrainBud.btn_delete_product.tag = indexMain
        cellStrainBud.btn_delete_product.addTarget(self, action: #selector(self.deleteProduct), for: .touchUpInside)
        cellStrainBud.btn_edit_product.tag = indexMain
        cellStrainBud.btn_edit_product.addTarget(self, action: #selector(self.editProduct), for: .touchUpInside)
        
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
    func onClickShowImagesServices(sender : UIButton)  {
        var images_url : [String] =  [String]()
        images_url.append(self.array_Services[sender.tag].image)
        if images_url.count > 0 {
            self.showImagess(attachments: images_url)
        }
    }
    
    func DetailAction(sender : UIButton){
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
        
        
        cellService.lblName.text = self.array_Services[indexMain].name
        cellService.lblDescription.text = "$" + String(self.array_Services[indexMain].charges)
        cellService.btnShare.tag = indexMain
        cellService.btnShare.addTarget(self, action:  #selector(ShareActionService(sender:)), for: UIControlEvents.touchUpInside)
        cellService.imgViewMain.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Services[indexMain].image.RemoveSpace()
        
        cellService.btn_img.tag = indexMain
        cellService.btn_img.addTarget(self, action: #selector(self.onClickShowImagesServices(sender:)), for: .touchUpInside)
        
        cellService.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellService.img_edit.image?.withRenderingMode(.alwaysTemplate)
        cellService.img_edit.image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
        cellService.img_edit.tintColor = .white
        cellService.btn_delete.tag = indexMain
        cellService.btn_delete.addTarget(self, action: #selector(self.deleteService), for: .touchUpInside)
        cellService.btn_edit.tag = indexMain
        cellService.btn_edit.addTarget(self, action: #selector(self.editService), for: .touchUpInside)
        
        
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
        cell.array = self.paymentMethodsArray
        cell.collection_view.reloadData()
        cell.selectionStyle  = .none
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductCell") as! AddProductCell
        cell.productHandler = {
//            self.onClickAddNewProduct()
        }
        cell.selectionStyle  = .none
        return cell
    }
    func NoRecodFoundCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductCell") as! AddProductCell
        cell.productHandler = {
            self.onClickAddNewProduct()
        }
        cell.selectionStyle  = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        TipInCellAnimator.animate(cell: cell)
        if let cellMap = tableView.cellForRow(at: indexPath) as? MapViewCell{
            self.mapViewMain.showsUserLocation = false
            if cellMap.MapView.isHidden {
                cellMap.MapView.isHidden = false
                if DeviceType.IS_IPHONE_6P_7P{
                    self.mapViewMain.frame =  CGRect.init(x: 0, y: 0, width: cellMap.MapView.frame.size.width + 20, height: cellMap.MapView.frame.size.height)
                }else{
                    self.mapViewMain.frame =  CGRect.init(x: 0, y: 0, width: cellMap.MapView.frame.size.width + 0, height: cellMap.MapView.frame.size.height)
                }
                self.mapViewMain.layer.cornerRadius = 5
                cellMap.MapView.addSubview(self.mapViewMain)
            }
        }
    }
}

//MARK:
//MARK: Custom Cell

extension NewBudzMapViewController {
    
    func HeadingNewCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "NewBudzHeaderCell") as! NewBudzHeaderCell
        cellHeader.viewAddYourLogo.DrawCorner()
        if self.hideorganic{
            cellHeader.viewDelivery.isHidden = true
            cellHeader.viewOrganic.isHidden = true
        }else{
            cellHeader.viewDelivery.isHidden = false
            cellHeader.viewOrganic.isHidden = false
        }
        cellHeader.btn_resize.addTarget(self, action: #selector(self.onClickresizeImage), for: UIControlEvents.touchUpInside)
        cellHeader.btn_cancel.addTarget(self, action: #selector(self.onClickCanvelImage(sender:)), for: UIControlEvents.touchUpInside)
        
        cellHeader.btn_Back.addTarget(self, action: #selector(self.BackAction), for: UIControlEvents.touchUpInside)
        cellHeader.btn_Home.addTarget(self, action: #selector(self.GO_Home_ACtion), for: UIControlEvents.touchUpInside)
        
        cellHeader.btnChooseImage.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        cellHeader.btnChooseImageLogo.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        cellHeader.btn_Banner.addTarget(self, action: #selector(chooseBanner), for: .touchUpInside)
        
        cellHeader.btn_Organic.addTarget(self, action: #selector(self.OrganicAction), for: UIControlEvents.touchUpInside)
        cellHeader.btn_Delivery.addTarget(self, action: #selector(self.DeliveryAction), for: UIControlEvents.touchUpInside)
        cellHeader.txtField_BusinessName.delegate = self
        cellHeader.txtField_BusinessName.tag = 989
        if self.business_type_id == "9"{
            cellHeader.view_four.isHidden = true
        }
        if self.chooseBudzMap.id > 0  {
            if self.chooseBudzMap.business_type_id != "0"{
            cellHeader.txtField_BusinessName.text = self.chooseBudzMap.title
            }
            cellHeader.imgView_Banner.moa.url = WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.banner.RemoveSpace()
            
            if  self.chooseBudzMap.logo.count > 3 {
                cellHeader.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.logo.RemoveSpace()), completed: nil)
            }
            if self.chooseBudzMap.is_organic == "1" || cellHeader.btn_Organic.isSelected{
               
                cellHeader.btn_Organic.isSelected = true
                cellHeader.imgView_Organic.image = #imageLiteral(resourceName: "pinkBoxS")
                
            }else  {
                cellHeader.btn_Organic.isSelected = false
                cellHeader.imgView_Organic.image = #imageLiteral(resourceName: "pinkBoxU")
            }
            
            
            if self.chooseBudzMap.is_delivery == "1" || cellHeader.btn_Delivery.isSelected{
                
                cellHeader.btn_Delivery.isSelected = true
                cellHeader.imgView_Delivery.image = #imageLiteral(resourceName: "pinkBoxS")
                
            }else  {
                cellHeader.btn_Delivery.isSelected = false
                cellHeader.imgView_Delivery.image = #imageLiteral(resourceName: "pinkBoxU")
            }
        }
        
        if self.isTitleUpdate {
             cellHeader.txtField_BusinessName.text = self.updated_title
        }
        
        
        cellHeader.selectionStyle = .none
        return cellHeader
    }
    
    
    func chooseBanner(sender : UIButton){
        self.isBannerChoose = true
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    func chooseImage(sender : UIButton){
        self.isBannerChoose = false
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func otherImage(sender : UIButton){
        self.isBannerChoose = false
        self.otherImageTake = true
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func UPloadBudzButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellUploadBudz = tableView.dequeueReusableCell(withIdentifier: "UploadBudzCell") as! UploadBudzCell
        
        cellUploadBudz.btnUpload.addTarget(self, action: #selector(self.otherImage(sender:)), for: .touchUpInside)
        cellUploadBudz.label1.text = "An Image"
        cellUploadBudz.label2.text = "(Max 1 Image)"
        cellUploadBudz.selectionStyle = .none
        return cellUploadBudz
    }
    
    
    func MediaChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "ShoeMediaCell") as! ShoeMediaCell
            let mianAttachment = self.AttachmentOther
            cellMedia.imgViewImage.image = mianAttachment.image_Attachment
            if let url = URL(string: mianAttachment.server_URL){
            cellMedia.imgViewImage.sd_setImage(with: url, completed: nil)
            }
            cellMedia.imgViewVideo.isHidden = true
            if mianAttachment.is_Video {
                cellMedia.imgViewVideo.isHidden = false
            }
            cellMedia.btnDelete.addTarget(self, action: #selector(self.DeleteImageAction), for: .touchUpInside)
            
            
            cellMedia.selectionStyle = .none
        return cellMedia
    }

    func DeleteImageAction(sender : UIButton){
            self.AttachmentOther = Attachment()
            self.chooseBudzMap.others_image = ""
            self.OtherDataLoad()
    }
    
    func OrganicAction(sender : UIButton){
        let MainCell = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! NewBudzHeaderCell
        
        if MainCell.btn_Organic.isSelected {
           MainCell.btn_Organic.isSelected = false
            MainCell.imgView_Organic.image = #imageLiteral(resourceName: "pinkBoxU")
        }else {
            MainCell.btn_Organic.isSelected = true
            MainCell.imgView_Organic.image = #imageLiteral(resourceName: "pinkBoxS")
        }
        
    }
    
    func DeliveryAction(sender : UIButton){
        let MainCell = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! NewBudzHeaderCell
        
        if MainCell.btn_Delivery.isSelected {
            MainCell.btn_Delivery.isSelected = false
            MainCell.imgView_Delivery.image = #imageLiteral(resourceName: "pinkBoxU")
        }else {
            MainCell.btn_Delivery.isSelected = true
            MainCell.imgView_Delivery.image = #imageLiteral(resourceName: "pinkBoxS")
        }
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        
    }
    
    
    func notificationCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? notificationCell
        cell?.title.text = "Insurance Accepted"
        cell?.title.textColor = ConstantsColor.kBudzColor
        cell?.btn_switch.addTarget(self, action: #selector(self.acceptInsuranceAction), for: .touchUpInside)
        cell?.btn_switch.tag = indexPath.row
        if self.insuranceCheck{
            cell?.btn_switch.isSelected = true
            cell?.swtich_image.image =  #imageLiteral(resourceName: "btn_on1")
        }else {
            cell?.btn_switch.isSelected = false
            cell?.swtich_image.image = #imageLiteral(resourceName: "btn_off")
        }
        
        if self.chooseBudzMap.id > 0 && self.insuranceCheck == false{
            if self.chooseBudzMap.Insurance_accepted == 1 {
                cell?.btn_switch.isSelected = true
                cell?.swtich_image.image =  #imageLiteral(resourceName: "btn_on1")
            }else {
                cell?.btn_switch.isSelected = false
                cell?.swtich_image.image = #imageLiteral(resourceName: "btn_off")
            }
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func acceptInsuranceAction(sender : UIButton){
        let cell = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! notificationCell
        
        if cell.btn_switch.isSelected {
           cell.btn_switch.isSelected = false
            cell.swtich_image.image = #imageLiteral(resourceName: "btn_off")
            self.insuranceCheck = false
        }else {
           cell.btn_switch.isSelected = true
           cell.swtich_image.image =  #imageLiteral(resourceName: "btn_on1")
            self.insuranceCheck = true
        }
    }
    func gifData(gifURL: URL, image: UIImage) {
        isUploadImage = true
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.video_URL = gifURL.absoluteString
        newAttachment.ID = "-1"
        let cellMain = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! NewBudzHeaderCell
        if self.isBannerChoose {
            self.tbleView_NewBudz.isScrollEnabled = false
            cellMain.crop_view.isHidden = false
            self.AttachmentBanner = newAttachment
            cellMain.view_one.isHidden = true
            cellMain.view_two.isHidden = true
            cellMain.view_three.isHidden = true
            cellMain.view_four.isHidden = true
            cellMain.imgScrollview.isUserInteractionEnabled = true
            cellMain.imgScrollview.imageToDisplay = image
            if cellMain.imgScrollview.minimumZoomScale != 2.1 {
                cellMain.imgScrollview.minimumZoomScale = 2.1
                cellMain.imgScrollview.setZoomScale(2.1, animated: true)
            }
        }else {
            cellMain.imgViewMain.image = image
            self.AttachmentMain = newAttachment
        }
    }
    func captured(image: UIImage) {
        if !otherImageTake{
        isUploadImage = true
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        let cellMain = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! NewBudzHeaderCell
        if self.isBannerChoose {
            if let i = cellMain.imgView_Banner.image{
                self.previousimage = i
            }
            cellMain.imgView_Banner.image = nil
            cellMain.imgScrollview.isHidden = false
            self.tbleView_NewBudz.isScrollEnabled = false
            cellMain.crop_view.isHidden = false
            self.AttachmentBanner = newAttachment
            cellMain.view_one.isHidden = true
            cellMain.view_two.isHidden = true
            cellMain.view_three.isHidden = true
            cellMain.view_four.isHidden = true
            cellMain.imgScrollview.isUserInteractionEnabled = true
            cellMain.imgScrollview.imageToDisplay = image
            if cellMain.imgScrollview.minimumZoomScale != 2.1 {
                cellMain.imgScrollview.minimumZoomScale = 2.1
                cellMain.imgScrollview.setZoomScale(2.1, animated: true)
            }
        }else{
            cellMain.imgViewMain.image = image
            self.AttachmentMain = newAttachment
        }
           
        
        }else{
            self.AttachmentOther.is_Video = false
            self.AttachmentOther.image_Attachment = image
            self.AttachmentOther.ID = "-1"
            OtherDataLoad()
        }
    }
    
     func captureVisibleRect(scrollView : FAScrollView) -> UIImage{
        
        var croprect = CGRect.zero
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView.frame.width) / (scrollView.contentSize.width)
        let normalizedHeight = (scrollView.frame.height) / (scrollView.contentSize.height)
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixImageOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        return cropped
        
    }
    
    func HeadingButtonxell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellBtnHeading = tableView.dequeueReusableCell(withIdentifier: "HeaderButtonCell") as! HeaderButtonCell
        
        cellBtnHeading.lblLeft.text = "Business Info"
        cellBtnHeading.lblMiddel.text = "Product/Services"
        cellBtnHeading.lblRight.text = "Specials"
        cellBtnHeading.btnRight.addTarget(self, action: #selector(RightButtonAction), for: UIControlEvents.touchUpInside)
        cellBtnHeading.btnMiddel.addTarget(self, action: #selector(MiddelButtonAction), for: UIControlEvents.touchUpInside)
         cellBtnHeading.btnLeft.addTarget(self, action: #selector(LeftButtonAction), for: UIControlEvents.touchUpInside)
        if self.chooseBudzMap.id == 0 && self.isSubscribed != nil && self.sub_user_id != nil{
            if isSubscribed! && (self.sub_user_id?.count)! > 0  {
                cellBtnHeading.viewMiddel.isUserInteractionEnabled = false
                cellBtnHeading.viewRight.isUserInteractionEnabled = false
                cellBtnHeading.lblMiddel.isHidden = true
                cellBtnHeading.lblRight.isHidden = true
                cellBtnHeading.line.isHidden = true
                cellBtnHeading.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
                cellBtnHeading.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
            }else{
                cellBtnHeading.viewMiddel.isUserInteractionEnabled = true
                cellBtnHeading.viewRight.isUserInteractionEnabled = true
                cellBtnHeading.lblMiddel.isHidden = false
                cellBtnHeading.line.isHidden = false
                cellBtnHeading.lblRight.isHidden = false
            }
        }else{
            cellBtnHeading.viewMiddel.isUserInteractionEnabled = true
            cellBtnHeading.viewRight.isUserInteractionEnabled = true
            cellBtnHeading.lblMiddel.isHidden = false
            cellBtnHeading.line.isHidden = false
            cellBtnHeading.lblRight.isHidden = false
        }
        
        cellBtnHeading.viewLeft.backgroundColor = ConstantsColor.kBudzUnselectColor
        cellBtnHeading.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
        cellBtnHeading.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
        
        if self.showTag == 0 {
             cellBtnHeading.viewLeft.backgroundColor = ConstantsColor.kBudzSelectColor
        }else if self.showTag == 1 {
            cellBtnHeading.viewMiddel.backgroundColor = ConstantsColor.kBudzSelectColor
        }else{
            cellBtnHeading.viewRight.backgroundColor = ConstantsColor.kBudzSelectColor
        }
        cellBtnHeading.selectionStyle = .none
        if self.chooseBudzMap.budzMapType.idType == 3 {
            cellBtnHeading.lblMiddel.text = "Menu"
        }else if self.chooseBudzMap.budzMapType.idType == 5 {
            cellBtnHeading.lblMiddel.text = "Price/Tickets"
        }else {
            cellBtnHeading.lblMiddel.text = "Product/Services"
        }
        return cellBtnHeading
    }
    
    func RightButtonAction(sender : UIButton){
        if self.isSubscribed != nil {
            if    self.chooseBudzMap.id != 0 || self.chooseBudzMap.is_featured == 1 || self.isSubscribed!{
                self.SelectOptions(value: 2)
            }else{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.isFromNewBudzScreen = true
                next.premiumDelegate = self
                self.present(next, animated: true, completion: nil)
            }
        }else{
            if self.chooseBudzMap.id != 0 && self.chooseBudzMap.is_featured == 1{
                self.SelectOptions(value: 2)
            }else{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.isFromNewBudzScreen = true
                next.premiumDelegate = self
                self.present(next, animated: true, completion: nil)
            }
        }
    }
    func MiddelButtonAction(sender : UIButton){
        if self.isSubscribed != nil {
            if    self.chooseBudzMap.id != 0 || self.chooseBudzMap.is_featured == 1 || self.isSubscribed!{
                self.SelectOptions(value: 1)
            }else{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.isFromNewBudzScreen = true
                next.premiumDelegate = self
                self.present(next, animated: true, completion: nil)
            }
        }else{
            if self.chooseBudzMap.id != 0 && self.chooseBudzMap.is_featured == 1{
                self.SelectOptions(value: 1)
            }else{
                let next = self.GetView(nameViewController: "PaymentPopupViewController", nameStoryBoard: "BudzStoryBoard") as! PaymentPopupViewController
                next.isFromNewBudzScreen = true
                next.premiumDelegate = self
                self.present(next, animated: true, completion: nil)
            }
        }
    }
    
    func LeftButtonAction(sender : UIButton){
        self.SelectOptions(value: 0)
    }
    
    func ProductBudzCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellProduct = tableView.dequeueReusableCell(withIdentifier: "BudzProductCell") as! BudzProductCell
        
        
        cellProduct.selectionStyle = .none
        return cellProduct
    }    
    
    func ChooseTypeHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellProduct = tableView.dequeueReusableCell(withIdentifier: "ChooseTypeCell") as! ChooseTypeCell
        
        cellProduct.selectionStyle = .none
        return cellProduct
    }
    func BudzSelectTypeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let budzSelectTypeCell = tableView.dequeueReusableCell(withIdentifier: "BudzSelectTypeCell") as! BudzSelectTypeCell
        
        let dataObj = dataArray[indexPath.row-3]
        if dataObj.tickType == 0 {
            budzSelectTypeCell.btn_Check.isEnabled = false
            budzSelectTypeCell.ImgView_Check.isHidden = false
            budzSelectTypeCell.ImgView_Check.image = #imageLiteral(resourceName: "expandArrow")
            budzSelectTypeCell.imgViewWidth.constant = 15
            budzSelectTypeCell.imgViewHeight.constant = 10
            budzSelectTypeCell.expandList.isHidden = false
            
        }
        else if dataObj.tickType == 1 {
            budzSelectTypeCell.btn_Check.isEnabled = true
            budzSelectTypeCell.ImgView_Check.isHidden = false
            budzSelectTypeCell.ImgView_Check.image = #imageLiteral(resourceName: "uncheck")
            budzSelectTypeCell.imgViewWidth.constant = 25
            budzSelectTypeCell.imgViewHeight.constant = 19
            budzSelectTypeCell.expandList.isHidden = true
        }
        else{
            budzSelectTypeCell.btn_Check.isEnabled = true
            budzSelectTypeCell.ImgView_Check.isHidden = false
            budzSelectTypeCell.ImgView_Check.image = #imageLiteral(resourceName: "check")
            budzSelectTypeCell.imgViewWidth.constant = 25
            budzSelectTypeCell.imgViewHeight.constant = 19
            budzSelectTypeCell.expandList.isHidden = true
        }
        budzSelectTypeCell.Lbl_title.text = dataObj.title
        budzSelectTypeCell.ImgView_mainImg.image = dataObj.image
        budzSelectTypeCell.btn_Check.tag = indexPath.row
        budzSelectTypeCell.btn_Check.addTarget(self, action: #selector(tickbudSelectTypeCell), for: UIControlEvents.touchUpInside)
//        indexPath.row == self.tick_selected_index  &&
        if  dataObj.title == self.tick_selected_index_title{
            budzSelectTypeCell.ImgView_Check.image = #imageLiteral(resourceName: "check")
        }
        if dataObj.title == "Medical"{
            budzSelectTypeCell.expandList.tag = 1
        }else if dataObj.title == "Entertainment"{
            budzSelectTypeCell.expandList.tag = 2
        }
        budzSelectTypeCell.expandList.addTarget(self, action: #selector(expandTableList), for: .touchUpInside)
        budzSelectTypeCell.backgroundColor = UIColor.clear
        budzSelectTypeCell.selectionStyle = .none
        return budzSelectTypeCell
        
    }
    func expandTableList(sender: UIButton!){
        if sender.tag == 1{
            if self.checkState(){
                self.expandMedical = !self.expandMedical
                self.MainDataLoad()
                self.MedicalDataload()
            }else{
                self.ShowErrorAlert(message: "You can't create this type of business in your area.")
            }
            
        }else if sender.tag == 2{
            self.expandEntertainment = !self.expandEntertainment
            self.MainDataLoad()
            self.EntertainmentDataload()
        }
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
    
    
    func BudzSelectTypeCell2(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let budzSelectTypeCell2 = tableView.dequeueReusableCell(withIdentifier: "BudzSelectTypeCell2") as! BudzSelectTypeCell2
        
        let dataObj = dataArray[indexPath.row-3]
        if dataObj.tickType == 0 {
            budzSelectTypeCell2.btn_Check.isEnabled = false
            budzSelectTypeCell2.ImgView_Check.isHidden = true
        }
        else if dataObj.tickType == 1 {
            budzSelectTypeCell2.btn_Check.isEnabled = true
            budzSelectTypeCell2.ImgView_Check.isHidden = false
            budzSelectTypeCell2.ImgView_Check.image = #imageLiteral(resourceName: "uncheck")
        } else{
            budzSelectTypeCell2.btn_Check.isEnabled = true
            budzSelectTypeCell2.ImgView_Check.isHidden = false
            budzSelectTypeCell2.ImgView_Check.image = #imageLiteral(resourceName: "check")
        }
        
//         indexPath.row == self.tick_selected_index &&
        if dataObj.title == self.tick_selected_index_title{
             budzSelectTypeCell2.ImgView_Check.image = #imageLiteral(resourceName: "check")
        }
        budzSelectTypeCell2.Lbl_title.text = dataObj.title
        budzSelectTypeCell2.btn_Check.tag = indexPath.row
        budzSelectTypeCell2.btn_Check.addTarget(self, action: #selector(tickbudSelectTypeCell), for: UIControlEvents.touchUpInside)
        budzSelectTypeCell2.backgroundColor = UIColor.clear
        budzSelectTypeCell2.selectionStyle = .none
        return budzSelectTypeCell2
        
    }
    
    func addPaymentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
     cell.array = self.paymentArray
        if self.paymentArray.count == 0{
            cell.collectionView.isHidden = true
            cell.noDataLabel.isHidden = false
        }else{
            cell.collectionView.isHidden = false
            cell.noDataLabel.isHidden = true
        }
     cell.delegate = self
        cell.lbl_title.text = "Select Payment Methods Offered"
     cell.collectionView.reloadData()
     cell.selectionStyle = .none
     return cell
    }

    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func AddInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellInfo = tableView.dequeueReusableCell(withIdentifier: "AddInfoCell") as! AddInfoCell
        
        
        let dictValue = self.array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        
        cellInfo.txtView_Main.delegate = self
        if indexMain == 1 {
            cellInfo.Lbl_title.text = "Add Short Description"
            print(textViewValues[3])
             if self.chooseBudzMap.id > 0 {
                if self.chooseBudzMap.business_type_id == "0"{
                    cellInfo.txtView_Main.text = "Description..."
                }else{
                cellInfo.txtView_Main.text = self.chooseBudzMap.budz_map_description.RemoveHTMLTag()
                textViewValues[3] = self.chooseBudzMap.budz_map_description.RemoveHTMLTag()
                }
             }else {
                cellInfo.txtView_Main.text = textViewValues[3]
            }
            cellInfo.locationButton.isHidden = true
            cellInfo.txtView_Main.tag = 101
        }else  if indexMain == 2 {
            cellInfo.Lbl_title.text = "Add Location"
            if self.chooseBudzMap.id > 0 {
                if self.chooseBudzMap.business_type_id == "0"{
                   cellInfo.Lbl_title.text = "Add Location"
                }else{
//                    if self.placeHolderAddress == ""{
//                        self.completeAddress = self.chooseBudzMap.location
//                    }else{
//                        self.completeAddress = self.placeHolderAddress
//                    }
                   cellInfo.txtView_Main.text = self.completeAddress
                    let center = CLLocationCoordinate2D(latitude: Double(self.chooseBudzMap.lat)!, longitude: Double(self.chooseBudzMap.lng)!)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.dropPin(location: CLLocation.init(latitude: (Double(self.chooseBudzMap.lat))!, longitude: (Double(self.chooseBudzMap.lng))!))
                    manager.stopUpdatingLocation()
                    self.mapViewMain.setRegion(region, animated: true)
                    
                }
            }else {
                if self.completeAddress.count > 3 {
                    cellInfo.txtView_Main.text = self.completeAddress
                }else{
                    cellInfo.txtView_Main.text = "Add Location"
                }
                
            }
            cellInfo.locationButton.isHidden = false
            cellInfo.locationButton.addTarget(self, action: #selector(self.autocompleteClicked), for: .touchUpInside)
            cellInfo.txtView_Main.tag = 102
        }else  if indexMain == 4 {
             cellInfo.Lbl_title.text = "Office policies & Information"
            cellInfo.txtView_Main.text = textViewValues[1]
//
            if self.chooseBudzMap.id > 0 {
                if self.chooseBudzMap.business_type_id == "0" || self.chooseBudzMap.office_Policies.RemoveHTMLTag() == ""{
                    cellInfo.Lbl_title.text = "Office policies & Information"
                }else{
                cellInfo.txtView_Main.text = self.chooseBudzMap.office_Policies.RemoveHTMLTag()
                textViewValues[1] = self.chooseBudzMap.office_Policies.RemoveHTMLTag()
                }
            }else {
                cellInfo.txtView_Main.text = textViewValues[1]
            }
            cellInfo.locationButton.isHidden = true
            cellInfo.txtView_Main.tag = 104
        }else  if indexMain == 5 {
            cellInfo.Lbl_title.text = "Pre-visit Requirements"
            cellInfo.txtView_Main.text = textViewValues[2]
            
            
            if self.chooseBudzMap.id > 0 {
                if self.chooseBudzMap.business_type_id == "0" || self.chooseBudzMap.visit_Requirements.RemoveHTMLTag() == ""{
                    cellInfo.Lbl_title.text = "Pre-visit Requirements"
                }else{
                cellInfo.txtView_Main.text = self.chooseBudzMap.visit_Requirements.RemoveHTMLTag()
                textViewValues[2] = self.chooseBudzMap.visit_Requirements.RemoveHTMLTag()
                }
            }else {
                cellInfo.txtView_Main.text = textViewValues[2]
            }
            cellInfo.locationButton.isHidden = true
            cellInfo.txtView_Main.tag = 105
        }
        
        cellInfo.txtView_Main.delegate = self
        cellInfo.selectionStyle = .none
        return cellInfo
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 101{
            if textView.text != textViewValues[3]{
                textViewValues[3] = textView.text!
                if self.chooseBudzMap.id > 0{
                    self.chooseBudzMap.budz_map_description = textView.text!
                }
            }
        }else if textView.tag == 104{
            if textView.text! != textViewValues[1]{
                textViewValues[1] = textView.text!
                if self.chooseBudzMap.id > 0{
                    self.chooseBudzMap.office_Policies = textView.text!
                }
            }
        }else if textView.tag == 105{
            if textView.text != textViewValues[2]{
                textViewValues[2] = textView.text!
                if self.chooseBudzMap.id > 0{
                    self.chooseBudzMap.visit_Requirements = textView.text!
                }
            }
        }
    }
    
    func MapCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMap = tableView.dequeueReusableCell(withIdentifier: "MapViewCell") as! MapViewCell
        
       self.mapViewMain.showsUserLocation = false
        cellMap.MapView.isHidden = false
        if DeviceType.IS_IPHONE_6P_7P{
            self.mapViewMain.frame =  CGRect.init(x: 0, y: 0, width: cellMap.MapView.frame.size.width + 20, height: cellMap.MapView.frame.size.height)
        }else{
            self.mapViewMain.frame =  CGRect.init(x: 0, y: 0, width: cellMap.MapView.frame.size.width + 0, height: cellMap.MapView.frame.size.height)
        }
        self.mapViewMain.layer.cornerRadius = 5
        if !cellMap.MapView.subviews.contains(self.mapViewMain) {
          cellMap.MapView.addSubview(self.mapViewMain)
        }
        cellMap.Lbl_title.text = "Adjust Pin Position"
        cellMap.selectionStyle = .none
        return cellMap
    }
    
    func BudzContactCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellContact = tableView.dequeueReusableCell(withIdentifier: "NewBudzContactCell") as! NewBudzContactCell
        cellContact.txtField_Phone.delegate = self
        cellContact.txtField_Email.delegate = self
        cellContact.txtField_ZipCode.delegate = self
        cellContact.txtField_Website.delegate = self
        cellContact.txtField_FB.delegate = self
        cellContact.txtField_Instagram.delegate = self
        cellContact.txtField_Twitter.delegate = self
        cellContact.txtField_Email.text = self.emailInfo
        cellContact.txtField_Phone.text = self.phoneNo
        cellContact.txtField_ZipCode.text = self.zipCodeInfo
        if self.chooseBudzMap.id > 0 {
            if self.chooseBudzMap.facebook != ""{
            cellContact.txtField_FB.text = self.chooseBudzMap.facebook
            }
            if self.chooseBudzMap.twitter != ""{
            cellContact.txtField_Twitter.text = self.chooseBudzMap.twitter
            }
            if self.chooseBudzMap.web != ""{
            cellContact.txtField_Website.text = self.chooseBudzMap.web
            }
            if self.chooseBudzMap.instagram != ""{
            cellContact.txtField_Instagram.text = self.chooseBudzMap.instagram
            }
            if self.chooseBudzMap.zipCode != ""{
            self.zipCodeInfo = self.chooseBudzMap.zipCode
            cellContact.txtField_ZipCode.text = self.chooseBudzMap.zipCode
            }
            if self.chooseBudzMap.phon_number != ""{
            self.phoneNo = self.chooseBudzMap.phon_number
            cellContact.txtField_Phone.text = self.chooseBudzMap.phon_number
            }
            if self.chooseBudzMap.email != ""{
            self.emailInfo = self.chooseBudzMap.email
            cellContact.txtField_Email.text = self.chooseBudzMap.email
            }
        }
        if self.business_type_id == "9"{
            cellContact.websiteView.isHidden = true
            cellContact.facebookView.isHidden = true
            cellContact.InstaView.isHidden = true
            cellContact.twitterView.isHidden = true
            cellContact.websiteHeight.constant = 0
            cellContact.facebookHeight.constant = 0
            cellContact.InstaHeight.constant = 0
            cellContact.twitterHeight.constant = 0
        }
        
        cellContact.selectionStyle = .none
        return cellContact
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 321{
            guard let text = textField.text else {
                return true
            }
            let newLength = text.count + string.count - range.length
            if string.count > 0 {
                if newLength == 1 {
                    textField.text = "(" + textField.text!
                }else if newLength == 5 {
                    textField.text =  textField.text! + ") "
                }else if newLength == 10 {
                    textField.text =  textField.text! + "-"
                }
            }
            return newLength <= 14
        }
       return true
    }
    
    func OpreationCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellContact = tableView.dequeueReusableCell(withIdentifier: "HoursofOpreationCell") as! HoursofOpreationCell
        
        
        cellContact.btn_Friday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Monday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Sunday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Tuesday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Saturday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Thursday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)
        cellContact.btn_Wednesday.addTarget(self, action: #selector(RefreshTimeView), for: UIControlEvents.touchUpInside)

        cellContact.txt_End_Sunday.delegate = self
        cellContact.txt_End_Saturday.delegate = self
        cellContact.txt_End_Monday.delegate = self
        cellContact.txt_End_Tuesday.delegate = self
        cellContact.txt_End_Wednesday.delegate = self
        cellContact.txt_End_Thursday.delegate = self
        cellContact.txt_End_Friday.delegate = self
        cellContact.txt_Start_Sunday.delegate = self
        cellContact.txt_Start_Saturday.delegate = self
        cellContact.txt_Start_Monday.delegate = self
        cellContact.txt_Start_Tuesday.delegate = self
        cellContact.txt_Start_Wednesday.delegate = self
        cellContact.txt_Start_Thursday.delegate = self
        cellContact.txt_Start_Friday.delegate = self
        
        
        cellContact.txt_End_Sunday.pickerType = .DatePicker
        cellContact.txt_End_Saturday.pickerType = .DatePicker
        cellContact.txt_End_Monday.pickerType = .DatePicker
        cellContact.txt_End_Tuesday.pickerType = .DatePicker
        cellContact.txt_End_Wednesday.pickerType = .DatePicker
        cellContact.txt_End_Thursday.pickerType = .DatePicker
        cellContact.txt_End_Friday.pickerType = .DatePicker
        cellContact.txt_Start_Sunday.pickerType = .DatePicker
        cellContact.txt_Start_Saturday.pickerType = .DatePicker
        cellContact.txt_Start_Monday.pickerType = .DatePicker
        cellContact.txt_Start_Tuesday.pickerType = .DatePicker
        cellContact.txt_Start_Wednesday.pickerType = .DatePicker
        cellContact.txt_Start_Thursday.pickerType = .DatePicker
        cellContact.txt_Start_Friday.pickerType = .DatePicker
        
        
        cellContact.txt_End_Sunday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Saturday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Monday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Tuesday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Wednesday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Thursday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_End_Friday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Sunday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Saturday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Monday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Tuesday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Wednesday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Thursday.dateFormatter = self.GetTimeForMatter()
        cellContact.txt_Start_Friday.dateFormatter = self.GetTimeForMatter()
        
        
        cellContact.txt_End_Sunday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Saturday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Monday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Tuesday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Wednesday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Thursday.datePicker?.datePickerMode = .time
        cellContact.txt_End_Friday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Sunday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Saturday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Monday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Tuesday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Wednesday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Thursday.datePicker?.datePickerMode = .time
        cellContact.txt_Start_Friday.datePicker?.datePickerMode = .time
        

        
        
        if self.chooseBudzMap.id > 0 {
            
            if self.chooseBudzMap.business_type_id != "0"{
            if self.chooseBudzMap.timing.saturday == "Closed" {
                cellContact.img_Saturday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Saturday.isHidden = true

            }else {
                cellContact.view_Saturday.isHidden = false
                cellContact.img_Saturday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Saturday.text = self.chooseBudzMap.timing.saturday
                cellContact.txt_End_Saturday.text = self.chooseBudzMap.timing.sat_end
            }
            
            
            if self.chooseBudzMap.timing.sunday == "Closed" {
                cellContact.img_Sunday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Sunday.isHidden = true
                
            }else {
                cellContact.view_Sunday.isHidden = false
                cellContact.img_Sunday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Sunday.text = self.chooseBudzMap.timing.sunday
                cellContact.txt_End_Sunday.text = self.chooseBudzMap.timing.sun_end
            }
            
            if self.chooseBudzMap.timing.monday == "Closed" {
                cellContact.img_Monday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Monday.isHidden = true
                
            }else {
                cellContact.view_Monday.isHidden = false
                cellContact.img_Monday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Monday.text = self.chooseBudzMap.timing.monday
                cellContact.txt_End_Monday.text = self.chooseBudzMap.timing.mon_end
            }
            
            if self.chooseBudzMap.timing.tuesday == "Closed" {
                cellContact.img_Tuesday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Tuesday.isHidden = true
                
            }else {
                cellContact.view_Tuesday.isHidden = false
                cellContact.img_Tuesday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Tuesday.text = self.chooseBudzMap.timing.tuesday
                cellContact.txt_End_Tuesday.text = self.chooseBudzMap.timing.tue_end
            }
            
            if self.chooseBudzMap.timing.wednesday == "Closed" {
                cellContact.img_Wednesday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Wednesday.isHidden = true
                
            }else {
                cellContact.view_Wednesday.isHidden = false
                cellContact.img_Wednesday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Wednesday.text = self.chooseBudzMap.timing.wednesday
                cellContact.txt_End_Wednesday.text = self.chooseBudzMap.timing.wed_end
            }
            
            
            if self.chooseBudzMap.timing.thursday == "Closed" {
                cellContact.img_Thursday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Thursday.isHidden = true
                
            }else {
                cellContact.view_Thursday.isHidden = false
                cellContact.img_Thursday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Thursday.text = self.chooseBudzMap.timing.thursday
                cellContact.txt_End_Thursday.text = self.chooseBudzMap.timing.thu_end
            }
            
            if self.chooseBudzMap.timing.friday == "Closed" {
                cellContact.img_Friday.image = UIImage.init(named: "Cross_White")
                cellContact.view_Friday.isHidden = true
                
            }else {
                cellContact.view_Friday.isHidden = false
                cellContact.img_Friday.image = UIImage.init(named: "check")
                cellContact.txt_Start_Friday.text = self.chooseBudzMap.timing.friday
                cellContact.txt_End_Friday.text = self.chooseBudzMap.timing.fri_end
            }
        }
        }
        cellContact.selectionStyle = .none
        return cellContact
    }
    
    
    func submitButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonCell") as? SubmitButtonCell
        cell?.submitButton.layer.cornerRadius = 10
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 1.0
        if self.chooseBudzMap.id == 0 {
            cell?.submitButton.setTitle("ADD LISTING", for: .normal)
        }else{
              cell?.submitButton.setTitle("UPDATE LISTING", for: .normal)
        }
        cell?.submitButton.addTarget(self, action: #selector(self.addNewBudzMap), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func addNewBudzMap(sender : UIButton){
        self.showLoading()
        print(self.AttachmentMain.ID)
        let tableSubviews =       self.tbleView_NewBudz.subviews
        var newParam = [String : AnyObject]()
        newParam["title"] = "" as AnyObject
        newParam["description"]  = "" as AnyObject
        for indexObj in tableSubviews{
            if let cellInfo = indexObj as? NewBudzHeaderCell {
                if cellInfo.txtField_BusinessName.text! != "" {
                    newParam["title"] = cellInfo.txtField_BusinessName.text! as AnyObject
                }
            }else if let cellInfo = indexObj as? AddInfoCell {
                if cellInfo.Lbl_title.text! == "Add Short Description" {
                    
                    if cellInfo.txtView_Main.text! != ""  &&  cellInfo.txtView_Main.text! != "Description..."{
                        newParam["description"] = cellInfo.txtView_Main.text! as AnyObject
                    }
                }
            }
            
            if textViewValues[3] != "Description..."{
                newParam["description"] = textViewValues[3] as AnyObject
                
            }
        }
        
        if newParam["title"] as! String == "" {
            self.ShowErrorAlert(message: "Title is missing!")
              self.hideLoading()
            return
        }
        
        if newParam["description"] as! String == "" {
            self.ShowErrorAlert(message: "Description is missing!")
            self.hideLoading()
            return
        }
        
        
        if self.AttachmentBanner.ID == "0" ||  self.AttachmentBanner.ID == ""{
            if self.AttachmentMain.ID == "0" ||  self.AttachmentMain.ID == ""{
                if self.AttachmentOther.ID != "-1"{
                    self.NewBudzMapAPI()
                }else{
                    self.hideLoading()
                    self.UploadBanner()
                }
            }else {
                  self.hideLoading()
                self.UploadLogo()
            }
        }else {
            self.hideLoading()
            self.UploadBanner()
        }
    }
    
    
    func UploadBanner(){
        self.showLoading()
        var gifDataUrl : URL? = nil
        if let gif_url = URL.init(string: (self.AttachmentBanner.video_URL)){
            gifDataUrl = gif_url
        }

        if AttachmentOther.ID != "-1" && self.AttachmentBanner.ID == "-1"{
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_banner.rawValue, image: self.AttachmentBanner.image_Attachment,gif_url: gifDataUrl, onView: self) { (MainResponse) in

            print(MainResponse)
            if (MainResponse["status"] as! String) == "success"{

                self.AttachmentBanner.server_URL = (MainResponse["successData"] as! [String: AnyObject])["url"] as! String
                if self.AttachmentMain.ID == "0" ||  self.AttachmentMain.ID == ""{
                    self.NewBudzMapAPI()
                }else {
                    self.UploadLogo()
                }
            }else {
                self.hideLoading()
            }
        }
        }else{
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_banner.rawValue, image: self.AttachmentOther.image_Attachment, onView: self) { (MainResponse) in
                print(MainResponse)
                if (MainResponse["status"] as! String) == "success"{
                    
                    self.AttachmentOther.server_URL = (MainResponse["successData"] as! [String: AnyObject])["url"] as! String
                        self.NewBudzMapAPI()
                }else {
                    self.hideLoading()
                }
            }
        }
    }
    
    func UploadLogo(){
        
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_logo.rawValue, image: self.AttachmentMain.image_Attachment, onView: self) { (MainResponse) in
            
            print(MainResponse)
            if (MainResponse["status"] as! String) == "success"{
                
                self.AttachmentMain.server_URL = (MainResponse["successData"] as! [String: AnyObject])["url"] as! String
                self.NewBudzMapAPI()
            }else {
                self.hideLoading()
            }
        }
    }
    
    func NewBudzMapAPI(){
        let tableSubviews =       self.tbleView_NewBudz.subviews
        var newParam = [String : AnyObject]()
        newParam["location"] = self.completeAddress as AnyObject
        newParam["lat"] = self.addresslat as AnyObject
        newParam["lng"] = self.addresslong as AnyObject
        newParam["business_type_id"] = self.business_type_id as AnyObject
        if (self.business_type_id == "2" || self.business_type_id == "6" || self.business_type_id == "7"){
            if self.chooseLangaugeArray.count == 0 {
                self.ShowErrorAlert(message: "Language is mandatory!")
                self.hideLoading()
                return
            }else {
                var languagedata = ""
                for indexObj in self.chooseLangaugeArray {
                    if languagedata == "" {
                        languagedata = indexObj.language_ID
                    }else {
                        languagedata = languagedata + "," + indexObj.language_ID
                    }
                }
                
                newParam["langeages"] = languagedata as AnyObject
                
            }
            if !self.checkStateInitisl() {
                self.ShowErrorAlert(message: "You can't create this type of business in your area.")
                self.hideLoading()
                return
            }
            
        }
       
        
        var email = ""
        newParam["phone"] = "" as AnyObject
        newParam["email"] = "" as AnyObject
        for indexObj in tableSubviews{
            if let cellMain = indexObj as? NewBudzHeaderCell {
                print(cellMain.btn_Delivery.isSelected)
            }
            
            if choosePaymentArray.count != 0{
                var payments = ""
                for payment in choosePaymentArray{
                    if payments == ""{
                      payments = payment.payment_ID
                    }else{
                        payments = payments + "," + payment.payment_ID
                    }
                }
                newParam["payments"] = payments as AnyObject
            }else{
                newParam["payments"] = "" as AnyObject
            }
            
            if let cellInfo = indexObj as? AddInfoCell {
                
                if cellInfo.Lbl_title.text! == "Add Short Description" {
                    newParam["description"] = cellInfo.txtView_Main.text! as AnyObject
                }else if cellInfo.Lbl_title.text! == "Office policies & Information"{
                    newParam["office_policies"] = cellInfo.txtView_Main.text! as AnyObject
                }else if cellInfo.Lbl_title.text! == "Pre-visit Requirements"{
                    newParam["visit_requirements"] = cellInfo.txtView_Main.text! as AnyObject
                }
                if textViewValues[3] != "Description..."{
                    newParam["description"] = textViewValues[3] as AnyObject
                    
                }
                if textViewValues[2] != "Pre-visit Requirements"{
                         newParam["visit_requirements"] = textViewValues[2] as AnyObject
                }
                if textViewValues[1] != "Office policies & Information"{
                    newParam["office_policies"] = textViewValues[1] as AnyObject
                }
                
            }else if let cellInfo = indexObj as? NewBudzContactCell {
                if(newParam["phone"] as? String == "" ){
                    newParam["phone"] = self.phoneNo as AnyObject
                }
                if(newParam["email"] as? String == "" ){
                    newParam["email"] = self.emailInfo as AnyObject
                }
                newParam["web"] = cellInfo.txtField_Website.text! as AnyObject
                newParam["fb"] = cellInfo.txtField_FB.text! as AnyObject
                newParam["twitter"] = cellInfo.txtField_Twitter.text! as AnyObject
                newParam["instagram"] = cellInfo.txtField_Instagram.text! as AnyObject
//                newParam["email"] = cellInfo.txtField_Email.text! as AnyObject
                newParam["zip_code"] = cellInfo.txtField_ZipCode.text! as AnyObject
                email = cellInfo.txtField_Email.text!
                
                if newParam["phone"] as? String == ""{
                 simpleCustomeAlert(title: "", discription: "Phone is mandatory")
                    self.hideLoading()
                    return
                }
                
                if newParam["email"] as? String == ""{
                    simpleCustomeAlert(title: "", discription: "Email is mandatory")
                    self.hideLoading()
                    return
                }
                
            }else if let cellInfo = indexObj as? notificationCell {
                
                if cellInfo.btn_switch.isSelected{
                    newParam["insurance_accepted"] = "Yes" as AnyObject
                }else {
                    newParam["insurance_accepted"] = "NO" as AnyObject
                }
            }else if let cellInfo = indexObj as? NewBudzHeaderCell {
                if (newParam["title"] as? String ?? "").isEmpty{
                     newParam["title"] = cellInfo.txtField_BusinessName.text! as AnyObject
                }
                if cellInfo.btn_Organic.isSelected{
                    newParam["is_organic"] = "1" as AnyObject
                }else {
                    newParam["is_organic"] = "0" as AnyObject
                }
                
                if cellInfo.btn_Delivery.isSelected{
                    newParam["is_delivery"] = "1" as AnyObject
                }else {
                    newParam["is_delivery"] = "0" as AnyObject
                }
                //GetDateBudz
            }else if let cellInfo = indexObj as? EventTimeCell {
                
                newParam["date"] = cellInfo.txtdate.text! as AnyObject
                newParam["from"] = cellInfo.txtStartTime.text! as AnyObject
                newParam["to"] = cellInfo.txtEndTime.text! as AnyObject
                
            }else if let cellInfo = indexObj as? HoursofOpreationCell {
                
                if cellInfo.view_Saturday.isHidden {
                    newParam["sat_start"] = "Closed" as AnyObject
                    newParam["sat_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["sat_start"] = cellInfo.txt_Start_Saturday.text! as AnyObject
                    newParam["sat_end"] = cellInfo.txt_End_Saturday.text! as AnyObject
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Saturday.text!, endTime: cellInfo.txt_End_Saturday.text!){
                         self.ShowErrorAlert(message: "Staturday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                if cellInfo.view_Sunday.isHidden {
                    newParam["sun_start"] = "Closed" as AnyObject
                    newParam["sun_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["sun_start"] = cellInfo.txt_Start_Sunday.text! as AnyObject
                    newParam["sun_end"] = cellInfo.txt_End_Sunday.text! as AnyObject
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Sunday.text!, endTime: cellInfo.txt_End_Sunday.text!){
                        self.ShowErrorAlert(message: "Sunday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                
                
                if cellInfo.view_Monday.isHidden {
                    newParam["mon_start"] = "Closed" as AnyObject
                    newParam["mon_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["mon_start"] = cellInfo.txt_Start_Monday.text! as AnyObject
                    newParam["mon_end"] = cellInfo.txt_End_Monday.text! as AnyObject
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Monday.text!, endTime: cellInfo.txt_End_Monday.text!){
                        self.ShowErrorAlert(message: "Monday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                if cellInfo.view_Tuesday.isHidden {
                    newParam["tue_start"] = "Closed" as AnyObject
                    newParam["tue_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["tue_start"] = cellInfo.txt_Start_Tuesday.text! as AnyObject
                    newParam["tue_end"] = cellInfo.txt_End_Tuesday.text! as AnyObject
                    
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Tuesday.text!, endTime: cellInfo.txt_End_Tuesday.text!){
                        self.ShowErrorAlert(message: "Tuesday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                if cellInfo.view_Wednesday.isHidden {
                    newParam["wed_start"] = "Closed" as AnyObject
                    newParam["wed_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["wed_start"] = cellInfo.txt_Start_Wednesday.text! as AnyObject
                    newParam["wed_end"] = cellInfo.txt_End_Wednesday.text! as AnyObject
                    
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Wednesday.text!, endTime: cellInfo.txt_End_Wednesday.text!){
                        self.ShowErrorAlert(message: "Wednesday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                if cellInfo.view_Thursday.isHidden {
                    newParam["thu_start"] = "Closed" as AnyObject
                    newParam["thu_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["thu_start"] = cellInfo.txt_Start_Thursday.text! as AnyObject
                    newParam["thu_end"] = cellInfo.txt_End_Thursday.text! as AnyObject
                    
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Thursday.text!, endTime: cellInfo.txt_End_Thursday.text!){
                        self.ShowErrorAlert(message: "Thursday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
                
                if cellInfo.view_Friday.isHidden {
                    newParam["fri_start"] = "Closed" as AnyObject
                    newParam["fri_end"] = "Closed" as AnyObject
                    
                }else {
                    newParam["fri_start"] = cellInfo.txt_Start_Friday.text! as AnyObject
                    newParam["fri_end"] = cellInfo.txt_End_Friday.text! as AnyObject
                    
                    if !checkStartTimewithEndTime(startime: cellInfo.txt_Start_Friday.text!, endTime: cellInfo.txt_End_Friday.text!){
                        self.ShowErrorAlert(message: "Friday end time should be greater then its start time")
                          self.hideLoading()
                        return
                    }
                }
            }
        }
        
       
        if isSubscribed != nil{
            if isSubscribed == true {
                newParam["sub_user_id"] = self.sub_user_id as AnyObject
            }
        }
        
        if self.chooseBudzMap.id >  0 {
            newParam["sub_user_id"] = String(self.chooseBudzMap.id) as AnyObject
        }
        
        newParam["logo"] = self.AttachmentMain.server_URL as AnyObject
        if self.croped_image_url.count == 0 {
            newParam["banner"] = self.AttachmentBanner.server_URL as AnyObject
        }else{
            newParam["banner"] = self.croped_image_url as AnyObject
        }

        newParam["banner_full"] = self.AttachmentBanner.server_URL as AnyObject
        newParam["others_image"] = self.AttachmentOther.server_URL as AnyObject
        if email.count > 0 {
            if self.EmailValidationOnstring(strEmail: email){
                
            }else {
                  self.hideLoading()
                return
                
            }
        }
        if (self.business_type_id == "2" || self.business_type_id == "6" || self.business_type_id == "7"){
            if let zip = newParam["zip_code"] as? String {
                if zip.count > 2 {
                    self.showLoading()
                    self.checkStateFromZip(zipcode: zip) { (isValidStates) in
                        self.hideLoading()
                        if !isValidStates{
                            self.ShowErrorAlert(message: "You can't create this type of business in your area.")
                              self.hideLoading()
                            return
                        }else{
                              self.hideLoading()
                            self.addNewBudzMapAPICall(newParam: newParam)
                        }
                    }
                }else{
                      self.hideLoading()
                    self.addNewBudzMapAPICall(newParam: newParam)
                }
            }else{
                  self.hideLoading()
                self.addNewBudzMapAPICall(newParam: newParam)
            }
        }else{
              self.hideLoading()
            self.addNewBudzMapAPICall(newParam: newParam)
        }
    }
    
    func checkStartTimewithEndTime(startime : String , endTime : String) -> Bool {
        let start_dt = startime.UTCToLocalSameZone(inputFormate: "HH:mm a", outputFormate: "HH:mm a").GetDateObject(formate: "HH:mm a")
        let end_dt = endTime.UTCToLocalSameZone(inputFormate: "HH:mm a", outputFormate: "HH:mm a").GetDateObject(formate: "HH:mm a")
        print(start_dt)
        print(end_dt)
        if start_dt < end_dt {
            return true
        }
        return false
    }
    func addNewBudzMapAPICall(newParam : [String : AnyObject])  {
        self.showLoading()
        print(newParam)
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_listing.rawValue, params: newParam) { (successResponse, messageResponse, MainResponse) in
            print(successResponse)
            print(MainResponse)
            self.hideLoading()
            
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    self.oneBtnCustomeAlert(title: "", discription: "Saved successfully!", complition: { (isConfirm, i) in
                        if let data  = MainResponse["successData"] as? [String : Any]{
                            if let id = data["id"] as? String{
                                if self.fiveBack{
                                self.navigationController?.popViewController(animated: true)
                                }else{
                                self.openBudzMap(id: id, new: true)
                                }
                            }else if let id = data["id"] as? Int{
                                if self.fiveBack{
                                self.navigationController?.popViewController(animated: true)
                                }else{
                                self.openBudzMap(id: String(id), new: true)
                                }
                            }
                        }
                    })
//
//                    if self.afterCompleting == 1 {
//                        self.ShowSuccessAlertWithNoAction(message: "Saved successfully!")
//                        self.GotoHome()
//                    }else {
//                        if self.fromPaymentPopUp{
//                            self.oneBtnCustomeAlert(title: "", discription: "Saved successfully!", complition: { (isConfirm, i) in
//                                if let data  = MainResponse["successData"] as? [String : Any]{
//                                    if let id = data["id"] as? String{
//                                       self.openBudzMap(id: id)
//                                    }else if let id = data["id"] as? Int{
//                                        self.openBudzMap(id: String(id))
//                                    }
//                                }
//
//                            })
//                        }else{
//
//                        }
//                    }
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        
                        self.ShowLogoutAlert()
                    }else{
                        self.ShowErrorAlert(message: MainResponse["errorMessage"] as! String)
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
        
    }

    func LanguageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSelectCell") as? LanguageSelectCell
        
        var arrayLanguage = [String]()
        for index in self.langaugeArray {
            arrayLanguage.append(index.language_name)
        }
        cell?.selectionStyle = .none
        print(arrayLanguage)
        cell?.txtLanguage.delegate = self
        cell?.txtLanguage.pickerType = .StringPicker
        cell?.txtLanguage.stringPickerData = arrayLanguage
        cell?.txtLanguage.stringDidChange =  { value in
            if !self.chooseLangaugeArray.contains(self.langaugeArray[value]){
                
                self.chooseLangaugeArray.append(self.langaugeArray[value])
                
            }else{
                self.ShowErrorAlert(message: "You can't choose the same language again!")
            }
            self.MedicalDataload()
            cell?.txtLanguage.text = ""
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func EventTimeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTimeCell") as? EventTimeCell
        
        cell?.txtdate.text = Date().GetString(dateFormate: "MM/dd/yyyy")
        cell?.txtdate.delegate = self
        cell?.txtStartTime.delegate = self
        cell?.txtEndTime.delegate = self
        
        cell?.txtdate.pickerType = .DatePicker
        cell?.txtStartTime.pickerType = .DatePicker
        cell?.txtEndTime.pickerType = .DatePicker
        
        cell?.txtdate.datePicker?.datePickerMode = .date
        cell?.txtStartTime.datePicker?.datePickerMode = .time
        cell?.txtEndTime.datePicker?.datePickerMode = .time
        
        cell?.txtStartTime.dateFormatter = self.GetTimeForMatter()
        cell?.txtEndTime.dateFormatter = self.GetTimeForMatter()
        cell?.txtdate.dateFormatter = self.GetDateForMatter()
        
        
        if self.chooseBudzMap.id > 0 {
            
            if self.chooseBudzMap.EventTime.count > 0 {
                cell?.txtdate.text = self.GetDateBudz(date: (self.chooseBudzMap.EventTime.first?.dateMain)!)//.GetDateBudz
                cell?.txtStartTime.text = self.chooseBudzMap.EventTime.first?.toTime
                cell?.txtEndTime.text = self.chooseBudzMap.EventTime.first?.fromTime
            }
            
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func LanguageshowCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageShowCell") as? LanguageShowCell
        
        let dictValue = self.array_table[indexPath.row]
        let indexMain = dictValue["index"] as! Int
        cell?.selectionStyle = .none
        cell?.lblLanguageName.text = self.chooseLangaugeArray[indexMain].language_name
        cell?.btnDelete.tag = indexMain
        cell?.btnDelete.addTarget(self, action: #selector(self.DeleteLanguage), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func DeleteLanguage(sender : UIButton){
        self.chooseLangaugeArray.remove(at: sender.tag)
        self.MedicalDataload()
    }
    
}

//MARK:
//MARK: Delegate Methods
extension NewBudzMapViewController : UITextViewDelegate , MKMapViewDelegate ,CLLocationManagerDelegate{
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView.tag == 101 {
                textView.text = "Description..."
            }else if textView.tag == 102 {
                textView.text = "Add Location"
            }else if textView.tag == 104 {
                textView.text = "Office policies & Information"
            }else if textView.tag == 105 {
                textView.text = "Pre-visit Requirements"
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 102{
            return false            
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print(textView.tag)
        if textView.tag == 101{
            if textView.text == "Description..." {
               textView.text = ""
            }
        }else if textView.tag == 102{
            if textView.text == "Add Location" {
                textView.text = ""
            }
        }else if textView.tag == 104{
            if textView.text == "Office policies & Information" {
                textView.text = ""
            }
        }else if textView.tag == 105{
            if textView.text == "Pre-visit Requirements" {
                textView.text = ""
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 989 {
            self.isTitleUpdate = true
            self.updated_title = textField.text!
        }else if textField.tag == 321{
            self.phoneNo = textField.text!
        }else if textField.tag == 331{
            self.emailInfo = textField.text!
        }else if textField.tag == 341{
            self.zipCodeInfo = textField.text!
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        let cellHours = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 17, section: 0)) as! HoursofOpreationCell
//
//        textField.text = dateSelect
//        switch textField.tag {
//        case 100:
//            cellHours.txt_End_Monday.text = dateSelect
//            break
//        case -100:
//            cellHours.txt_Start_Monday.text = dateSelect
//            break
//        case 101:
//            cellHours.txt_End_Tuesday.text = dateSelect
//            break
//        case -101:
//            cellHours.txt_Start_Tuesday.text = dateSelect
//            break
//        case 102:
//            cellHours.txt_End_Wednesday.text = dateSelect
//            break
//        case 103:
//            cellHours.txt_End_Thursday.text = dateSelect
//            break
//        case 104:
//            cellHours.txt_End_Friday.text = dateSelect
//            break
//        case 105:
//            cellHours.txt_End_Saturday.text = dateSelect
//            break
//        case 106:
//            cellHours.txt_End_Sunday.text = dateSelect
//            break
//        case -102:
//            cellHours.txt_Start_Wednesday.text = dateSelect
//            break
//        case -103:
//            cellHours.txt_Start_Thursday.text = dateSelect
//            break
//        case -104:
//            cellHours.txt_Start_Friday.text = dateSelect
//            break
//        case -105:
//            cellHours.txt_Start_Saturday.text = dateSelect
//            break
//        case -106:
//            cellHours.txt_Start_Sunday.text = dateSelect
//            break
//
//
//        default:
//            break
//        }
//    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        let currentOffset = self.tbleView_NewBudz.contentOffset
//        UIView.setAnimationsEnabled(false)
//        self.tbleView_NewBudz.beginUpdates()
//        self.tbleView_NewBudz.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        self.tbleView_NewBudz.setContentOffset(currentOffset, animated: false)
//    }
    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//
//        let identifier = "MyPin"
//        let currentAnnot:budzAnnotation = (annotation as?budzAnnotation)!
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        annotationView?.canShowCallout = false
//        if annotationView == nil {
//
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.isDraggable = true
//
//            if currentAnnot.type == "Home" {
//                annotationView?.image = UIImage(named: "customAnnotation1")
//            }
//            else if currentAnnot.type == "Home2"{
//                annotationView?.image = UIImage(named: "customAnnotation2")
//
//            }
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//
//        annotationView?.isDraggable = true
//        return annotationView
//    }
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKPointAnnotation {
//            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
//
//            pinAnnotationView.pinColor = .purple
//            pinAnnotationView.isDraggable = true
//            pinAnnotationView.canShowCallout = false
//            pinAnnotationView.animatesDrop = false
//
//            return pinAnnotationView
//        }
//
//        return nil
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}


extension NewBudzMapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.addresslat = String(place.coordinate.latitude)
        self.addresslong = String(place.coordinate.longitude)
        self.completeAddress = place.name
        self.placeHolderAddress = place.name
       if self.chooseBudzMap.business_type_id != "0" {
            self.chooseBudzMap.lat = String(place.coordinate.latitude)
            self.chooseBudzMap.lng = String(place.coordinate.longitude)
        }
        self.GetAddress(location: CLLocation.init(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude)))
        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.dropPin(location: CLLocation.init(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude)))
        manager.stopUpdatingLocation()
        self.mapViewMain.setRegion(region, animated: true)
        self.tbleView_NewBudz.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


//MARK:
//MARK: Button Actions
extension NewBudzMapViewController
{
    func onClickresizeImage(sender : UIButton){
        if let cellMain = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? NewBudzHeaderCell{
            cellMain.crop_view.isHidden = true
            cellMain.view_one.isHidden = false
            cellMain.view_two.isHidden = false
            cellMain.view_three.isHidden = false
            cellMain.view_four.isHidden = false
            cellMain.imgScrollview.isUserInteractionEnabled = false
            self.tbleView_NewBudz.isScrollEnabled = true
            let croped_image  =  self.captureVisibleRect(scrollView: cellMain.imgScrollview)
            self.showLoading()
            cellMain.imgScrollview.isHidden = true
            cellMain.imgView_Banner.image = croped_image
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_banner.rawValue, image: croped_image, onView: self) { (MainResponse) in
                print(MainResponse)
                self.hideLoading()
                if (MainResponse["status"] as! String) == "success"{
                    self.croped_image_url = (MainResponse["successData"] as! [String: AnyObject])["url"] as! String
                }else {
                    self.hideLoading()
                }
            }
        }
    }
    func onClickCanvelImage(sender : UIButton){
        if let cellMain = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? NewBudzHeaderCell{
            cellMain.crop_view.isHidden = true
            cellMain.view_one.isHidden = false
            cellMain.view_two.isHidden = false
            cellMain.view_three.isHidden = false
            cellMain.view_four.isHidden = false
            cellMain.imgScrollview.isUserInteractionEnabled = false
            cellMain.imgScrollview.isHidden = true
            cellMain.imgView_Banner.image = previousimage
            self.tbleView_NewBudz.isScrollEnabled = true
            self.tbleView_NewBudz.reloadData()
        }
    }
    
    func BackAction(sender : UIButton){
        if self.fromPaymentPopUp{
            let next = self.GetView(nameViewController: "EditProfileViewController", nameStoryBoard: "Main") as! BudzMainVC
            self.navigationController?.pushViewController(next, animated: true)
        }else{
            if self.afterCompleting != 1{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.GotoHome()
            }
        }
    }
    
    
    func GO_Home_ACtion(sender : UIButton){
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
        self.GotoHome()
    }
    
    
//    func LeftButtonAction(sender : UIButton){
//        self.SelectOptions(value: 0)
//
//    }
//
//    func RightButtonAction(sender : UIButton){
//        self.SelectOptions(value: 2)
//    }
//
//    func MiddelButtonAction(sender : UIButton){
//        self.SelectOptions(value: 1)
//    }
    
    
    func SelectOptions(value : Int){
        self.showTag = value
        let cellHeadingButton = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: 1, section: 0) as IndexPath) as! HeaderButtonCell
        cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzUnselectColor
        cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kBudzUnselectColor
        cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kBudzUnselectColor
        
        
        
        switch value {
        case 0:
            
            self.DefaultData()
            cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzSelectColor
            if self.chooseBudzMap.budzMapType.idType == 5 {
                self.hideorganic = true
                self.EventDataload()
            }else if self.chooseBudzMap.budzMapType.idType == 2 || self.chooseBudzMap.budzMapType.idType == 6 || self.chooseBudzMap.budzMapType.idType == 7 {
                self.hideorganic = false
                self.MedicalDataload()
            }else if self.chooseBudzMap.budzMapType.idType == 1 {
                self.hideorganic = false
                self.DispensaryDataload()
            }else if self.chooseBudzMap.budzMapType.idType == 3 {
                self.hideorganic = false
                self.CannabitesDataload()
            }else if self.chooseBudzMap.budzMapType.idType == 4 || self.chooseBudzMap.budzMapType.idType == 8 {
                self.hideorganic = true
                self.EntertainmentDataload()
            }else if self.chooseBudzMap.budzMapType.idType == 9{
                self.hideorganic = true
                self.OtherDataLoad()
            }else{
                self.hideorganic = false
                self.DispensaryDataload()
            }
            break
        case 1:
            
            if self.chooseBudzMap.budzMapType.idType == 9{
                self.simpleCustomeAlert(title: "", discription: "You can't upgrade Other Type Business!")
                cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzSelectColor
                return
            }
            cellHeadingButton.viewMiddel.backgroundColor = ConstantsColor.kBudzSelectColor
             self.LoadProduct()
            break;
        default:
            
            if self.chooseBudzMap.budzMapType.idType == 9{
                self.simpleCustomeAlert(title: "", discription: "You can't upgrade Other Type Business!")
                cellHeadingButton.viewLeft.backgroundColor = ConstantsColor.kBudzSelectColor
                return
            }
            cellHeadingButton.viewRight.backgroundColor = ConstantsColor.kBudzSelectColor
             self.LoadSpecial()
        }
    }
    
    func LoadSpecial(){
        
        self.array_table.removeAll()
        array_table.append(["type" : NewBudzMapDataType.Header.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.MenuButton.rawValue ])
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
//            array_table.append(["type" : BudzMapDataType.NoRecordtext.rawValue ])
        }
        self.tblReload()
    }
    
    
    func LoadProduct(){
        var isEventPurchaseDataAppend : Bool = false
        self.array_table.removeAll()
        array_table.append(["type" : NewBudzMapDataType.Header.rawValue ])
        array_table.append(["type" : NewBudzMapDataType.MenuButton.rawValue ])
        
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
        }else{
            var indexMain = 0
            var isFound = false
            for _ in self.array_Services {
                array_table.append(["type" : BudzMapDataType.BudzService.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
                isFound = true
            }
            
            indexMain = 0
            self.array_Product =  self.array_Product.sorted(by: { $0.straintype!.title > $1.straintype!.title })
            for _ in self.array_Product {
                array_table.append(["type" : BudzMapDataType.BudzProduct.rawValue , "index" : indexMain])
                indexMain = indexMain + 1
                isFound = true
            }
            
            if !isFound{
                if self.chooseBudzMap.user_id == Int((DataManager.sharedInstance.user?.ID)!)!{
//                    array_table.append(["type" : BudzMapDataType.NoRecord.rawValue ])
                } else{
                    
                }
            }
        }
        if isEventPurchaseDataAppend{
            array_table.append(["type" : BudzMapDataType.evnetPurchaseTicketCell.rawValue ])
        }
         self.tblReload()
    }
   
    func reinstiate(){
        for i in 0...self.dataArray.count - 1{
            
            let obj = self.dataArray[i]
            if obj.tickType == 2 {
                obj.tickType = 1
            }
            self.dataArray[i] = obj
        }
        
        let obj = self.dataArray[self.tagVal]
        
        obj.tickType = 2
        self.dataArray[self.tagVal] = obj
        
        self.reloadMainTable(tableView: tbleView_NewBudz)
        
        self.business_type_id = obj.business_type_id!
        if obj.DataType == 1 {
            self.hideorganic = false
            self.DispensaryDataload()
        }else if obj.DataType == 2 {
            self.hideorganic = false
            self.MedicalDataload()
        }else if obj.DataType == 3 {
            self.hideorganic = false
            self.CannabitesDataload()
        }else if obj.DataType == 4 {
            self.hideorganic = true
            self.EntertainmentDataload()
        }else {
            self.hideorganic = true
            self.EventDataload()
        }
        
    }
    
    func tickbudSelectTypeCell(sender:UIButton)  {
        self.tick_selected_index = sender.tag
        for i in 0...self.dataArray.count - 1{
            
            let obj = self.dataArray[i]
            if obj.tickType == 2 {
                obj.tickType = 1
            }
            self.dataArray[i] = obj
        }
        let obj = self.dataArray[sender.tag - 3]
        self.tick_selected_index_title = obj.title!
        obj.tickType = 2
        self.dataArray[sender.tag-3] = obj
        
        self.reloadMainTable(tableView: tbleView_NewBudz)
        
        self.business_type_id = obj.business_type_id!
        if obj.DataType == 1 {
            self.hideorganic = false
            self.DispensaryDataload()
        }else if obj.DataType == 2 {
            self.hideorganic = false
            self.MedicalDataload()
        }else if obj.DataType == 3 {
            self.hideorganic = false
            self.CannabitesDataload()
        }else if obj.DataType == 4 {
            self.hideorganic = true
            self.EntertainmentDataload()
        }else if obj.DataType == 6 {
            self.hideorganic = true
            self.OtherDataLoad()
        }else{
            self.hideorganic = true
             self.EventDataload()
        }
        self.tbleView_NewBudz.scrollToRow(at: IndexPath.init(row: sender.tag + 2, section: 0), at: .none, animated: false)
        
    }
    
    func RefreshTimeView(sender : UIButton){

        
        if let cellHours = self.tbleView_NewBudz.cellForRow(at: IndexPath.init(row: tbleView_NewBudz.numberOfRows(inSection: 0) - 2, section: 0)) as? HoursofOpreationCell{

            switch sender.tag {
            case 100: // Monday
                
                if cellHours.view_Monday.isHidden {
                    cellHours.view_Monday.isHidden = false
                    cellHours.img_Monday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Monday.text = "9:00 AM"
                    cellHours.txt_End_Monday.text = "5:00 PM"
                }else {
                    cellHours.img_Monday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Monday.isHidden = true
                }
                break
                
            case 101: //Tuesday
                if cellHours.view_Tuesday.isHidden {
                    cellHours.view_Tuesday.isHidden = false
                    cellHours.img_Tuesday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Tuesday.text = "9:00 AM"
                    cellHours.txt_End_Tuesday.text = "5:00 PM"
                }else {
                    cellHours.img_Tuesday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Tuesday.isHidden = true
                }
                break
                
            case 102: //Wednesday
                if cellHours.view_Wednesday.isHidden {
                    cellHours.view_Wednesday.isHidden = false
                    cellHours.img_Wednesday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Wednesday.text = "9:00 AM"
                    cellHours.txt_End_Wednesday.text = "5:00 PM"
                }else {
                    cellHours.img_Wednesday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Wednesday.isHidden = true
                }
                
                break
                
            case 103: //Thursday\
                
                if cellHours.view_Thursday.isHidden {
                    cellHours.view_Thursday.isHidden = false
                    cellHours.img_Thursday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Thursday.text = "9:00 AM"
                    cellHours.txt_End_Thursday.text = "5:00 PM"
                }else {
                    cellHours.img_Thursday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Thursday.isHidden = true
                }
                
                break
                
            case 104: //Friday
                if cellHours.view_Friday.isHidden {
                    cellHours.view_Friday.isHidden = false
                    cellHours.img_Friday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Friday.text = "9:00 AM"
                    cellHours.txt_End_Friday.text = "5:00 PM"
                }else {
                    cellHours.img_Friday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Friday.isHidden = true
                }
                
                break
                
            case 105: //Saturday
                if cellHours.view_Saturday.isHidden {
                    cellHours.view_Saturday.isHidden = false
                    cellHours.img_Saturday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Saturday.text = "9:00 AM"
                    cellHours.txt_End_Saturday.text = "5:00 PM"
                }else {
                    cellHours.img_Saturday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Saturday.isHidden = true
                }
                
                break
                
                
            default:  // Sunday
                if cellHours.view_Sunday.isHidden {
                    cellHours.view_Sunday.isHidden = false
                    cellHours.img_Sunday.image = UIImage.init(named: "check")
                    cellHours.txt_Start_Sunday.text = "9:00 AM"
                    cellHours.txt_End_Sunday.text = "5:00 PM"
                }else {
                    cellHours.img_Sunday.image = UIImage.init(named: "Cross_White")
                    cellHours.view_Sunday.isHidden = true
                }
                
                break
            }
        }
    }
    
    
    func datePickerValueChanged(sender: UIDatePicker){
        dateSelect = sender.date.GetString(dateFormate: "hh:mm a")
    }
    
    
}


class NewBudzHeaderCell: UITableViewCell {
    @IBOutlet var viewAddYourLogo       : UIView!
    @IBOutlet var viewAddBusinessName   : UIView!
    
    @IBOutlet weak var crop_view: UIView!
    @IBOutlet weak var btn_resize: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var imgScrollview: FAScrollView!
    @IBOutlet weak var view_three: UIView!
     @IBOutlet weak var view_four: UIView!
    @IBOutlet weak var view_two: UIView!
    @IBOutlet weak var view_one: UIView!
    @IBOutlet var txtField_BusinessName : UITextField!
    
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var imgView_Banner : UIImageView!
    @IBOutlet var imgView_Organic : UIImageView!
    @IBOutlet var imgView_Delivery : UIImageView!
    
    
    @IBOutlet var btnChooseImage : UIButton!
    @IBOutlet var btnChooseImageLogo : UIButton!
    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Home : UIButton!
    @IBOutlet var btn_Organic : UIButton!
    @IBOutlet var btn_Delivery : UIButton!
    @IBOutlet var btn_Banner : UIButton!
    @IBOutlet var viewDelivery: UIView!
    @IBOutlet var viewOrganic: UIView!
}


class ChooseTypeCell: UITableViewCell {
    
}

class BudzSelectTypeCell:UITableViewCell{
    @IBOutlet weak var ImgView_mainImg: CircularImageView!
    @IBOutlet weak var ImgView_Check: UIImageView!
    @IBOutlet weak var expandList: UIButton!
    @IBOutlet weak var Lbl_title: UILabel!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btn_Check: UIButton!
    
}
class BudzSelectTypeCell2:UITableViewCell{
    @IBOutlet weak var ImgView_Check: UIImageView!
    @IBOutlet weak var Lbl_title: UILabel!
    @IBOutlet weak var btn_Check: UIButton!
    
}


class AddInfoCell:UITableViewCell{
    @IBOutlet weak var Lbl_title   : UILabel!
    @IBOutlet weak var txtView_Main: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    
}


class MapViewCell:UITableViewCell{
    @IBOutlet weak var Lbl_title   : UILabel!
    @IBOutlet weak var MapView   : UIView!
    
}


class NewBudzContactCell:UITableViewCell{
    @IBOutlet weak var txtField_Phone   : UITextField!
    @IBOutlet weak var txtField_Website   : UITextField!
    @IBOutlet weak var txtField_FB   : UITextField!
    @IBOutlet weak var txtField_Email   : UITextField!
    @IBOutlet weak var txtField_Instagram   : UITextField!
    @IBOutlet weak var txtField_Twitter   : UITextField!
    @IBOutlet weak var txtField_ZipCode:  UITextField!
    @IBOutlet weak var websiteHeight: NSLayoutConstraint!
    @IBOutlet weak var facebookHeight: NSLayoutConstraint!
    @IBOutlet weak var InstaHeight: NSLayoutConstraint!
    @IBOutlet weak var twitterHeight: NSLayoutConstraint!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var InstaView: UIView!
    @IBOutlet weak var twitterView: UIView!
    
    override func awakeFromNib() {
        self.txtField_Phone.tag = 321
        self.txtField_Email.tag = 331
        self.txtField_ZipCode.tag = 341
    }
}

class HoursofOpreationCell:UITableViewCell{
    @IBOutlet weak var view_Monday      : UIView!
    @IBOutlet weak var view_Tuesday     : UIView!
    @IBOutlet weak var view_Wednesday   : UIView!
    @IBOutlet weak var view_Thursday    : UIView!
    @IBOutlet weak var view_Friday      : UIView!
    @IBOutlet weak var view_Saturday    : UIView!
    @IBOutlet weak var view_Sunday      : UIView!
    
    
    @IBOutlet weak var btn_Monday      : UIButton!
    @IBOutlet weak var btn_Tuesday     : UIButton!
    @IBOutlet weak var btn_Wednesday   : UIButton!
    @IBOutlet weak var btn_Thursday    : UIButton!
    @IBOutlet weak var btn_Friday      : UIButton!
    @IBOutlet weak var btn_Saturday    : UIButton!
    @IBOutlet weak var btn_Sunday      : UIButton!
    
    
    @IBOutlet weak var img_Monday      : UIImageView!
    @IBOutlet weak var img_Tuesday     : UIImageView!
    @IBOutlet weak var img_Wednesday   : UIImageView!
    @IBOutlet weak var img_Thursday    : UIImageView!
    @IBOutlet weak var img_Friday      : UIImageView!
    @IBOutlet weak var img_Saturday    : UIImageView!
    @IBOutlet weak var img_Sunday      : UIImageView!
    
    
    
    @IBOutlet weak var txt_Start_Monday      : AAPickerView!
    @IBOutlet weak var txt_Start_Tuesday     : AAPickerView!
    @IBOutlet weak var txt_Start_Wednesday   : AAPickerView!
    @IBOutlet weak var txt_Start_Thursday    : AAPickerView!
    @IBOutlet weak var txt_Start_Friday      : AAPickerView!
    @IBOutlet weak var txt_Start_Saturday    : AAPickerView!
    @IBOutlet weak var txt_Start_Sunday      : AAPickerView!
    
    @IBOutlet weak var txt_End_Monday      : AAPickerView!
    @IBOutlet weak var txt_End_Tuesday     : AAPickerView!
    @IBOutlet weak var txt_End_Wednesday   : AAPickerView!
    @IBOutlet weak var txt_End_Thursday    : AAPickerView!
    @IBOutlet weak var txt_End_Friday      : AAPickerView!
    @IBOutlet weak var txt_End_Saturday    : AAPickerView!
    @IBOutlet weak var txt_End_Sunday      : AAPickerView!
    
    
}
class SubmitButtonCell :UITableViewCell{
    @IBOutlet weak var submitButton : UIButton!
}

class LanguageSelectCell : UITableViewCell {
    @IBOutlet var txtLanguage : AAPickerView!
}


class EventTimeCell : UITableViewCell {
    @IBOutlet var txtdate : AAPickerView!
    @IBOutlet var txtStartTime : AAPickerView!
    @IBOutlet var txtEndTime : AAPickerView!
}

class LanguageShowCell : UITableViewCell{
    @IBOutlet var lblLanguageName : UILabel!
    @IBOutlet var btnDelete : UIButton!
}
