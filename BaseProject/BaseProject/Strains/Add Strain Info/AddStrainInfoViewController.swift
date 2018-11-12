//
//  AddStrainInfoViewController.swift
//  BaseProject
//
//  Created by macbook on 26/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import AAPickerView
import ObjectMapper

class AddStrainInfoViewController: BaseViewController , CameraDelegate , UITextViewDelegate , UIPickerViewDelegate {
   @IBOutlet var tbleView_Strain : UITableView!
    var array_tble = [[String : Any]]()
    var FirstBreed = ""
    var SecondBreed = ""
     var array_Attachment = [Attachment]()
    var ifItHide : Bool = false
     var strainArray = [Strain]()
    var chooseStrain = Strain()
    var Strain_id_for_edit : Int?
    var strainName = [String]()
    var user_starin_edit = [String : Any]()
    var strainValue:Float = 0.5
    var isEdit : Bool = false
    var isGenticShown : Bool  = false
    var isGone : Bool = false
    var isLevelSelected = ""
    var isgenetics = ""
    var isYeild = "low"
    var breedLoad = 1
    var strain_discription = ""
    var strain_note = ""
    var indica_value : Int = 0
    var sativa_value : Int = 0
    var isClimate = "indoor"
    var isFirstTimeTblReload : Bool  = true
    var isShownHybridFirst = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView_Strain.isPagingEnabled = false
        self.RegisterXib()
        self.getStrains()
        self.disableMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.disableMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    func getStrains(){
        self.showLoading()
        self.strainArray.removeAll()
        self.strainName.removeAll()
        let urlMain = WebServiceName.get_strains.rawValue
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! NSDictionary
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    
                    
                    for indexObj in self.strainArray{
                        self.strainName.append(indexObj.title!)
                    }
                    if self.isEdit{
                        self.getStrainDetails()
                    }else{
                         self.ReloadData()
                    }
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        AppDelegate.appDelegate().PushLoginView()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
    
    func getStrainDetails()  {
        self.showLoading()
        let urlMain = WebServiceName.get_user_strain_detail.rawValue + "/\(String(describing: Strain_id_for_edit!))"
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    if let mainData = MainResponse["successData"]  as? [String :  Any] {
                        if let user_Strain = mainData["user_strain"] as? [String : Any]{
                            self.user_starin_edit = user_Strain
                            self.strain_discription = self.user_starin_edit["description"] as? String ?? ""
                            self.sativa_value = self.user_starin_edit["sativa"] as? Int ?? 0
                        }
                    }
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        AppDelegate.appDelegate().PushLoginView()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            self.ReloadData()
        }
    }
}

extension AddStrainInfoViewController  : UITableViewDelegate , UITableViewDataSource {
    func ReloadData(){
        self.array_tble.removeAll()
        self.array_tble.append(["type" : AddNewStrain.HeaderView.rawValue])
        self.array_tble.append(["type" : AddNewStrain.ImageUpload.rawValue])
        self.array_tble.append(["type" : AddNewStrain.AddInfo.rawValue])
        self.array_tble.append(["type" : AddNewStrain.AddType.rawValue])
        self.array_tble.append(["type" : AddNewStrain.AddBreed.rawValue])
        self.array_tble.append(["type" : AddNewStrain.Chemistry.rawValue])
        self.array_tble.append(["type" : AddNewStrain.AddCare.rawValue])
        self.array_tble.append(["type" : AddNewStrain.AddNotes.rawValue])
        self.array_tble.append(["type" : AddNewStrain.Submit.rawValue])
        self.reloadTableview(tbleViewMain: self.tbleView_Strain)
    }
    
    
    func RegisterXib(){
        self.tbleView_Strain.register(UINib(nibName: "ImageUploadStrainCell", bundle: nil), forCellReuseIdentifier: "ImageUploadStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "AddNewInfoHomeCell", bundle: nil), forCellReuseIdentifier: "AddNewInfoHomeCell")
        self.tbleView_Strain.register(UINib(nibName: "AddInfoStrainCell", bundle: nil), forCellReuseIdentifier: "AddInfoStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "AddTypeStrainCell", bundle: nil), forCellReuseIdentifier: "AddTypeStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "AddBreedStrainCell", bundle: nil), forCellReuseIdentifier: "AddBreedStrainCell")
        self.tbleView_Strain.register(UINib(nibName: "chemistryCell", bundle: nil), forCellReuseIdentifier: "chemistry")

        self.tbleView_Strain.register(UINib(nibName: "AddCareCell", bundle: nil), forCellReuseIdentifier: "AddCareCell")
        self.tbleView_Strain.register(UINib(nibName: "AddStrainNotesCell", bundle: nil), forCellReuseIdentifier: "AddStrainNotesCell")
        self.tbleView_Strain.register(UINib(nibName: "SubmitStrainCell", bundle: nil), forCellReuseIdentifier: "SubmitStrainCell")

        
        
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 { // For Image
            return 0
        }
        
        if indexPath.row == 4 {
            
            if self.strainValue == 0.0 || self.strainValue == 1.0 || sativa_value == 100 || sativa_value == 0 {
                if !isEdit && isFirstTimeTblReload{
                    isFirstTimeTblReload = false
                     return UITableViewAutomaticDimension
                }
                return 0
            }
            
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_tble.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let DataElement = self.array_tble[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        
        switch dataType {
      
        case AddNewStrain.HeaderView.rawValue:
            return HeaderView(tableView:tableView  ,cellForRowAt:indexPath)
            
        case AddNewStrain.AddInfo.rawValue:
            return AddInfo(tableView:tableView  ,cellForRowAt:indexPath)
            
        
        case AddNewStrain.AddType.rawValue:
            return AddStrainTypeCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case AddNewStrain.AddBreed.rawValue:
            return AddBreedCell(tableView:tableView  ,cellForRowAt:indexPath)
        case AddNewStrain.Chemistry.rawValue:
            return AddChemistry(tableView:tableView  ,cellForRowAt:indexPath)
            
        case AddNewStrain.AddCare.rawValue:
            return AddMoreCare(tableView:tableView  ,cellForRowAt:indexPath)
        
        case AddNewStrain.AddNotes.rawValue:
            return AddStrainNotes(tableView:tableView  ,cellForRowAt:indexPath)
            
        case AddNewStrain.Submit.rawValue:
            return SubmitAction(tableView:tableView  ,cellForRowAt:indexPath)
        
            
            
        default:
            return ImageUpload(tableView:tableView  ,cellForRowAt:indexPath)
        }
    }
    
}


//MARK:
//MARK: Custom Cells
extension AddStrainInfoViewController {
    func ImageUpload(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellUploadImage = tableView.dequeueReusableCell(withIdentifier: "ImageUploadStrainCell") as! ImageUploadStrainCell
        
        cellUploadImage.btnUpload.addTarget(self, action: #selector(self.uploadimage), for: .touchUpInside)
        cellUploadImage.selectionStyle = .none
        return cellUploadImage
    }
    
    func uploadimage(sender : UIButton){
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.showImage(imageMain: image)
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.showImage(imageMain: image)
    }
    
    
    func showImage(imageMain : UIImage){
        let cellHEader = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ImageUploadStrainCell
        cellHEader.imgviewMain.image = imageMain
    }
    func HeaderView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "AddNewInfoHomeCell") as! AddNewInfoHomeCell
        cellHeader.btn_Back.addTarget(self, action: #selector(self.BackAction), for: UIControlEvents.touchUpInside)
        cellHeader.btn_Home.addTarget(self, action: #selector(self.Home_Action), for: UIControlEvents.touchUpInside)
        
        cellHeader.lblHeadingName.text = self.chooseStrain.title
        cellHeader.lblType.text = self.chooseStrain.strainType?.title
        
        cellHeader.selectionStyle = .none
        return cellHeader
    }
    
    
    func AddInfo(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellInfo = tableView.dequeueReusableCell(withIdentifier: "AddInfoStrainCell") as! AddInfoStrainCell
        if self.strain_discription.RemoveHTMLTag() != ""{
         cellInfo.txtViewMain.text = self.strain_discription.RemoveHTMLTag()
        }else{
         cellInfo.txtViewMain.text = "Optional."
        }
        cellInfo.txtViewMain.tag = 1
        cellInfo.txtViewMain.delegate = self as UITextViewDelegate
        cellInfo.selectionStyle = .none
        return cellInfo
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView.tag == 1{
        if textView.text == "Optional."{
           textView.text = ""
        }else {
            self.strain_discription  = textView.text
        }
        }else{
            if textView.text == "Add Notes."{
                textView.text = ""
            }else{
             self.strain_note  = textView.text
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1{
        if textView.text == "" {
            textView.text = "Optional."
        }else{
            self.strain_discription  = textView.text
        }
        }else{
            if textView.text == ""{
                textView.text = "Add Notes."
            }else{
              self.strain_note  = textView.text
            }
        }
    }
    
    func AddStrainTypeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellType = tableView.dequeueReusableCell(withIdentifier: "AddTypeStrainCell") as! AddTypeStrainCell
        if self.isEdit{
            if sativa_value == 0 {
                self.isGenticShown = false
                cellType.lbl_hybrid_type.text = "Indica"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "AE59C2")
            }else if sativa_value == 100{
                self.isGenticShown = false
                cellType.lbl_hybrid_type.text = "Sativa"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "C24462")
            }else{
                self.isGenticShown = true
                cellType.lbl_hybrid_type.text = "Hybrid"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "7cc244")
            }
            if isShownHybridFirst{
                isShownHybridFirst = false
                self.strainValue = Float(sativa_value)
                if indica_value == 100 {
                    cellType.slider.value = 0
                } else{
                    cellType.slider.value = Float( Float(sativa_value) / 100)
                }
                cellType.sliderValueChange(sender: cellType.slider)
            }
        }
        
        cellType.stainHandler = {(sliderValue) in
            self.sativa_value = Int(sliderValue * 100)
            if self.indica_value == 100 {
                self.indica_value = 0
            }
            
            self.strainValue = sliderValue
            if sliderValue == 1 {
                self.isGenticShown = false
                cellType.lbl_hybrid_type.text = "Sativa"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "C24462")
                self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
            }else if sliderValue == 0{
                self.isGenticShown = false
                cellType.lbl_hybrid_type.text = "Indica"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "AE59C2")
                self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
            }else{
                self.isGenticShown = true
                cellType.lbl_hybrid_type.text = "Hybird"
                cellType.lbl_hybrid_type.textColor = UIColor.init(hex: "7cc244")
                
               
            }
           print(self.sativa_value)
            if (self.sativa_value == 0 || self.sativa_value == 100) {
                self.tbleView_Strain.reloadData()
                self.ifItHide = true
                print("hide")
            }else if self.ifItHide{
                self.ifItHide = false
                self.tbleView_Strain.reloadData()
                print("visible")
            }
        }
        
        cellType.selectionStyle = .none
        return cellType
    }
    
    
    
    func AddBreedCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellBreed = tableView.dequeueReusableCell(withIdentifier: "AddBreedStrainCell") as! AddBreedStrainCell
        
        cellBreed.txtFieldCrossBreedFirst.pickerType = .StringPicker
        cellBreed.txtFieldCrossBreedSecond.pickerType = .StringPicker
        cellBreed.txtFieldCrossBreedFirst.stringPickerData = self.strainName
        cellBreed.txtFieldCrossBreedSecond.stringPickerData = self.strainName
        
        cellBreed.txtFieldCrossBreedFirst.stringDidChange = { index in
            self.FirstBreed = self.strainName[index]
        }
        cellBreed.txtFieldCrossBreedSecond.stringDidChange = {index in
            self.SecondBreed = self.strainName[index]
        }
        
        if (self.FirstBreed != "" || self.SecondBreed != ""){
            cellBreed.txtFieldCrossBreedFirst.text! = self.FirstBreed
            cellBreed.txtFieldCrossBreedSecond.text! = self.SecondBreed
        }
        
        if self.isEdit{
            if let cross_breed = self.user_starin_edit["cross_breed"] as? String{
                if cross_breed.count > 3 {
                    if cross_breed.contains(","){
                        let array_cross_breed = cross_breed.components(separatedBy: ",")
                        if array_cross_breed.first != nil{
                            cellBreed.txtFieldCrossBreedFirst.text = array_cross_breed.first
                        }else{
                            cellBreed.txtFieldCrossBreedFirst.text = ""
                        }
                        
                        if array_cross_breed.last != nil{
                          cellBreed.txtFieldCrossBreedSecond.text = array_cross_breed.last
                        }else{
                            cellBreed.txtFieldCrossBreedSecond.text = ""
                        }
                    }else{
                         cellBreed.txtFieldCrossBreedFirst.text = cross_breed
                    }
                }
            }
           
           
        }
        
        cellBreed.txtFieldCrossBreedFirst.delegate = self
        cellBreed.txtFieldCrossBreedSecond.delegate = self
        
        cellBreed.selectionStyle = .none
        return cellBreed
    }
    
    
    func AddChemistry(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cellChem = tableView.dequeueReusableCell(withIdentifier: "chemistry") as! ChemistryCell
        cellChem.CBDText1.delegate = self
        cellChem.CBDText1.tag = 201
        cellChem.CBDText2.delegate = self
        cellChem.CBDText2.tag = 202
        cellChem.THCText1.delegate = self
        cellChem.THCText1.tag = 203
        cellChem.THCText2.delegate = self
        cellChem.THCText2.tag = 204
        
        if self.isEdit{
            if let CBDMin = self.user_starin_edit["min_CBD"] as? Double{
                cellChem.CBDText1.text = "\(CBDMin)" + "%"
            }else{
                cellChem.CBDText1.text = "0.0%"
            }
            if let CBDMax = self.user_starin_edit["max_CBD"] as? Double{
                cellChem.CBDText2.text = "\(CBDMax)" + "%"
            }else{
                cellChem.CBDText2.text = "0.0%"
            }
            if let THCMin = self.user_starin_edit["min_THC"] as? Double{
                cellChem.THCText1.text = "\(THCMin)" + "%"
            }else{
                cellChem.THCText1.text = "0.0%"
            }
            if let THCMax = self.user_starin_edit["max_THC"] as? Double{
                cellChem.THCText2.text = "\(THCMax)" + "%"
            }else{
                cellChem.THCText2.text = "0.0%"
            }
            
        }
        cellChem.selectionStyle = .none
        return cellChem
    }
    
    func AddMoreCare(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCare = tableView.dequeueReusableCell(withIdentifier: "AddCareCell") as! AddCareCell
        
        cellCare.btn_Low.tag = 100
        cellCare.btn_Medium.tag = 200
        cellCare.btn_High.tag = 300
        
        cellCare.btn_LevelEasy.tag = 100
        cellCare.btn_LevelModereate.tag = 200
        cellCare.btn_LevelHard.tag = 300
        
        cellCare.btn_Low.addTarget(self, action: #selector(self.ChangeYeildValue), for: .touchUpInside)
        cellCare.btn_Medium.addTarget(self, action: #selector(self.ChangeYeildValue), for: .touchUpInside)
        cellCare.btn_High.addTarget(self, action: #selector(self.ChangeYeildValue), for: .touchUpInside)
        
        cellCare.btn_LevelEasy.addTarget(self, action: #selector(self.ChangeLevelValue), for: .touchUpInside)
        cellCare.btn_LevelModereate.addTarget(self, action: #selector(self.ChangeLevelValue), for: .touchUpInside)
        cellCare.btn_LevelHard.addTarget(self, action: #selector(self.ChangeLevelValue), for: .touchUpInside)
        
        cellCare.btn_Indoor.tag = 100
        cellCare.btn_OutDoor.tag = 200
        cellCare.btn_Green.tag = 300
        
        cellCare.btn_Indoor.addTarget(self, action: #selector(self.ChangeClimateValue), for: .touchUpInside)
        cellCare.btn_OutDoor.addTarget(self, action: #selector(self.ChangeClimateValue), for: .touchUpInside)
        cellCare.btn_Green.addTarget(self, action: #selector(self.ChangeClimateValue), for: .touchUpInside)
        
        cellCare.txtfield_PlantHeight.delegate = self
        cellCare.txtfield_PlantHeight.tag = 872
        
        cellCare.txtfield_Flowering.delegate = self
        cellCare.txtfield_Flowering.tag = 873
        
        cellCare.txtfield_TempFDown.delegate = self
        cellCare.txtfield_TempFDown.tag = 874
        
        cellCare.txtfield_TempFUp.delegate = self
        cellCare.txtfield_TempFUp.tag = 875
        
        
        cellCare.txtfield_TempCDown.delegate = self
        cellCare.txtfield_TempCDown.tag = 876
        
        cellCare.txtfield_TempCUp.delegate = self
        cellCare.txtfield_TempCUp.tag = 877
        

        
        if isEdit{
            if let planet_hight = self.user_starin_edit["plant_height"] as? Int {
                cellCare.txtfield_PlantHeight.text = "\(planet_hight)"
            }else{
                 cellCare.txtfield_PlantHeight.text = "0"
            }
            if let flowering_time = self.user_starin_edit["flowering_time"] as? Int {
                cellCare.txtfield_Flowering.text = "\(flowering_time)"
            }else{
                cellCare.txtfield_Flowering.text = "0"
            }
            
            if let min_fahren_temp = self.user_starin_edit["min_fahren_temp"] as? Int {
                cellCare.txtfield_TempFDown.text = "\(min_fahren_temp)"
            }else{
                cellCare.txtfield_TempFDown.text = "0"
            }
            if let max_fahren_temp = self.user_starin_edit["max_fahren_temp"] as? Int {
                cellCare.txtfield_TempFUp.text = "\(max_fahren_temp)"
            }else{
                cellCare.txtfield_TempFUp.text = "0"
            }
            
            if let min_celsius_temp = self.user_starin_edit["min_celsius_temp"] as? Int {
                cellCare.txtfield_TempCDown.text = "\(min_celsius_temp)"
            }else{
                cellCare.txtfield_TempCDown.text = "0"
            }
            if let max_celsius_temp = self.user_starin_edit["max_celsius_temp"] as? Int {
                cellCare.txtfield_TempCUp.text = "\(max_celsius_temp)"
            }else{
                cellCare.txtfield_TempCUp.text = "0"
            }
            
            cellCare.view_Low.backgroundColor = UIColor.clear
            cellCare.view_Medium.backgroundColor = UIColor.clear
            cellCare.view_High.backgroundColor = UIColor.clear
            
            cellCare.view_Low.StrainRadious()
            cellCare.view_Medium.StrainRadious()
            cellCare.view_High.StrainRadious()
            
            cellCare.lbl_Low.textColor = UIColor.lightGray
            cellCare.lbl_Medium.textColor = UIColor.lightGray
            cellCare.lbl_High.textColor = UIColor.lightGray
            if let yeild =  self.user_starin_edit["yeild"] as? String{
                if yeild == "low" {
                    self.isYeild = "low"
                    cellCare.lbl_Low.textColor = UIColor.black
                    cellCare.view_Low.backgroundColor = ConstantsColor.kStrainColor
                }else if yeild == "medium" {
                    self.isYeild = "medium"
                    cellCare.lbl_Medium.textColor = UIColor.black
                    cellCare.view_Medium.backgroundColor = ConstantsColor.kStrainColor
                }else {
                    self.isYeild = "high"
                    cellCare.lbl_High.textColor = UIColor.black
                    cellCare.view_High.backgroundColor = ConstantsColor.kStrainColor
                }
            }
            
            
            cellCare.lbl_LevelEasy.textColor = UIColor.lightGray
            cellCare.lbl_LevelHard.textColor = UIColor.lightGray
            cellCare.lbl_LevelModereate.textColor = UIColor.lightGray
            if let growing =  self.user_starin_edit["growing"] as? String{
                if growing == "easy" {
                    self.isLevelSelected = "easy"
                    cellCare.lbl_LevelEasy.textColor = ConstantsColor.kStrainColor
                }else if growing == "moderate" {
                    self.isLevelSelected = "moderate"
                    cellCare.lbl_LevelModereate.textColor = ConstantsColor.kStrainColor
                }else {
                    self.isLevelSelected = "hard"
                    cellCare.lbl_LevelHard.textColor = ConstantsColor.kStrainColor
                }
            }
            
            
            
            cellCare.view_Indoor.backgroundColor = UIColor.clear
            cellCare.view_OutDoor.backgroundColor = UIColor.clear
            cellCare.view_Green.backgroundColor = UIColor.clear
            
            cellCare.view_Indoor.StrainRadious()
            cellCare.view_OutDoor.StrainRadious()
            cellCare.view_Green.StrainRadious()
            
            cellCare.lbl_Indoor.textColor = UIColor.lightGray
            cellCare.lbl_OutDoor.textColor = UIColor.lightGray
            cellCare.lbl_Green.textColor = UIColor.lightGray
            if let climate =  self.user_starin_edit["climate"] as? String{
                if climate == "indoor" {
                    self.isClimate = "indoor"
                    cellCare.lbl_Indoor.textColor = UIColor.black
                    cellCare.view_Indoor.backgroundColor = ConstantsColor.kStrainColor
                }else if climate == "outdoor" {
                    self.isClimate = "outdoor"
                    cellCare.lbl_OutDoor.textColor = UIColor.black
                    cellCare.view_OutDoor.backgroundColor = ConstantsColor.kStrainColor
                }else {
                    self.isClimate = "greenshouse"
                    cellCare.lbl_Green.textColor = UIColor.black
                    cellCare.view_Green.backgroundColor = ConstantsColor.kStrainColor
                }
            }
            
        }
        
        cellCare.selectionStyle = .none
        return cellCare
    }
    func ChangeLevelValue(sender : UIButton){
        let cellCare = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: self.array_tble.count - 3, section: 0)) as! AddCareCell
        
        cellCare.lbl_LevelEasy.textColor = UIColor.lightGray
        cellCare.lbl_LevelHard.textColor = UIColor.lightGray
        cellCare.lbl_LevelModereate.textColor = UIColor.lightGray
        
        
        if sender.tag == 100 {
            self.isLevelSelected = "easy"
            cellCare.lbl_LevelEasy.textColor = ConstantsColor.kStrainColor
        }else if sender.tag == 200 {
            self.isLevelSelected = "moderate"
            cellCare.lbl_LevelModereate.textColor = ConstantsColor.kStrainColor
        }else {
            self.isLevelSelected = "hard"
            cellCare.lbl_LevelHard.textColor = ConstantsColor.kStrainColor
        }
    }
    
    
    func ChangeYeildValue(sender : UIButton){
        let cellCare = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: self.array_tble.count - 3, section: 0)) as! AddCareCell

        cellCare.view_Low.backgroundColor = UIColor.clear
        cellCare.view_Medium.backgroundColor = UIColor.clear
        cellCare.view_High.backgroundColor = UIColor.clear
        
        cellCare.view_Low.StrainRadious()
        cellCare.view_Medium.StrainRadious()
        cellCare.view_High.StrainRadious()
        
        cellCare.lbl_Low.textColor = UIColor.lightGray
        cellCare.lbl_Medium.textColor = UIColor.lightGray
        cellCare.lbl_High.textColor = UIColor.lightGray
        
        if sender.tag == 100 {
            self.isYeild = "low"
            cellCare.lbl_Low.textColor = UIColor.black
            cellCare.view_Low.backgroundColor = ConstantsColor.kStrainColor
        }else if sender.tag == 200 {
            self.isYeild = "medium"
            cellCare.lbl_Medium.textColor = UIColor.black
            cellCare.view_Medium.backgroundColor = ConstantsColor.kStrainColor
        }else {
            self.isYeild = "high"
            cellCare.lbl_High.textColor = UIColor.black
            cellCare.view_High.backgroundColor = ConstantsColor.kStrainColor
        }
    }
    
    func ChangeClimateValue(sender : UIButton){
        let cellCare = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: self.array_tble.count - 3, section: 0)) as! AddCareCell
        
        cellCare.view_Indoor.backgroundColor = UIColor.clear
        cellCare.view_OutDoor.backgroundColor = UIColor.clear
        cellCare.view_Green.backgroundColor = UIColor.clear
        
        cellCare.view_Indoor.StrainRadious()
        cellCare.view_OutDoor.StrainRadious()
        cellCare.view_Green.StrainRadious()
        
        cellCare.lbl_Indoor.textColor = UIColor.lightGray
        cellCare.lbl_OutDoor.textColor = UIColor.lightGray
        cellCare.lbl_Green.textColor = UIColor.lightGray
        
        if sender.tag == 100 {
            self.isClimate = "indoor"
            cellCare.lbl_Indoor.textColor = UIColor.black
            cellCare.view_Indoor.backgroundColor = ConstantsColor.kStrainColor
        }else if sender.tag == 200 {
            self.isClimate = "outdoor"
            cellCare.lbl_OutDoor.textColor = UIColor.black
            cellCare.view_OutDoor.backgroundColor = ConstantsColor.kStrainColor
        }else {
            self.isClimate = "greenshouse"
            cellCare.lbl_Green.textColor = UIColor.black
            cellCare.view_Green.backgroundColor = ConstantsColor.kStrainColor
        }
    }

    func AddStrainNotes(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellBreed = tableView.dequeueReusableCell(withIdentifier: "AddStrainNotesCell") as! AddStrainNotesCell
        if self.strain_note.RemoveHTMLTag() != ""{
            cellBreed.txtViewNotes.text = self.strain_note.RemoveHTMLTag()
        }else{
            cellBreed.txtViewNotes.text = "Add Notes."
            if isEdit{
                if let notes = self.user_starin_edit["note"] as? String{
                    cellBreed.txtViewNotes.text = notes
                }else{
                    cellBreed.txtViewNotes.text = "Add Notes."
                }
        }
        
        }
        cellBreed.txtViewNotes.tag = 2
        cellBreed.txtViewNotes.delegate = self as UITextViewDelegate
        cellBreed.selectionStyle = .none
        return cellBreed
    }

    func SubmitAction(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellSubmit = tableView.dequeueReusableCell(withIdentifier: "SubmitStrainCell") as! SubmitStrainCell
        
        cellSubmit.btn_Submit.addTarget(self, action: #selector(self.Submit), for: .touchUpInside)

        if isEdit{
            cellSubmit.btn_Submit.setTitle("UPDATE", for: .normal)
        }else{
            cellSubmit.btn_Submit.setTitle("SUBMIT", for: .normal)
        }
        cellSubmit.selectionStyle = .none
        return cellSubmit
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        
        if textField.tag != 201 && textField.tag != 202 && textField.tag != 203 && textField.tag != 204{
        }else{
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

       if textField.tag != 201 && textField.tag != 202 && textField.tag != 203 && textField.tag != 204{
        if textField.text!.count > 1 {
            return false
        }else{
          return true
        }
       }else{
        if !string.isEmpty {
            return textField.text!.count < 3
            
        }else{
            return true
        }
        }
    }
 
    func Submit(sender : UIButton){
        let tableSubviews =       self.tbleView_Strain.subviews
        
        
        var messageTextDescription = ""
        var messageTextCrossBreed = ""
        var messageText = ""
        
        var isError = false
        
        var newPAram = [String : AnyObject]()
        for indexObj in tableSubviews{
            
            
            print(indexObj)
            if let cellMain = indexObj as? AddInfoStrainCell {
                
                print(cellMain.txtViewMain.text)
                
                if cellMain.txtViewMain.hasText {
                    if cellMain.txtViewMain.text == "Optional." {
//                        isError = true
//                        messageTextDescription = "Description is missing"
//                        break
                    }else {
                        newPAram["description"] = cellMain.txtViewMain.text! as AnyObject
                    }
                    
                }else {
//                   isError = true
//                    messageTextDescription = "Description is missing"
//                    break
                }
                
            }else if let cellMain = indexObj as?  AddBreedStrainCell {
                if cellMain.txtFieldCrossBreedFirst.hasText &&  cellMain.txtFieldCrossBreedSecond.hasText {
                    newPAram["cross_breed"] = cellMain.txtFieldCrossBreedFirst.text! + "," +  cellMain.txtFieldCrossBreedSecond.text! as AnyObject
                }else {
                    if  self.strainValue > 0 && self.strainValue < 100 {
                        //isError = true
                          //messageTextCrossBreed = "Cross bread missing"
                    }
                    newPAram["cross_breed"] = "" as AnyObject
                }
                
            }else  if let cellMain = indexObj as? AddTypeStrainCell {
                newPAram["indica"] = cellMain.Lbl_leftPercentage.text?.replacingOccurrences(of: "%", with: "") as AnyObject
                newPAram["sativa"] = cellMain.Lbl_rightPercentage.text?.replacingOccurrences(of: "%", with: "") as AnyObject
                
                
                if (cellMain.slider.value == 0) {
                    self.isgenetics = "sativa";
                } else if (cellMain.slider.value == 1) {
                    self.isgenetics = "indica";
                } else {
                    self.isgenetics = "hybrid";
                }
                
            }else if let cellMain = indexObj as? ChemistryCell {
              
                if cellMain.CBDText1.hasText {
                    newPAram["min_CBD"] =  cellMain.CBDText1.text!.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces) as AnyObject
                  }else{
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "CBD is missing."
                    }
                }
                if cellMain.CBDText2.hasText {
                    newPAram["max_CBD"] =  cellMain.CBDText2.text!.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces) as AnyObject
                }else{
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "CBD is missing."
                    }
                }
                if cellMain.THCText1.hasText {
                    newPAram["min_THC"] =  cellMain.THCText1.text!.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces) as AnyObject
                }else{
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "THC is missing."
                    }
                }
                if cellMain.THCText2.hasText {
                    newPAram["max_THC"] =  cellMain.THCText2.text!.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces) as AnyObject
                }else{
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "THC is missing."
                    }
                }
                
                
            }else if let cellMain = indexObj as? AddCareCell {
                
                newPAram["yeild"] =  self.isYeild as AnyObject
                newPAram["climate"] =  self.isClimate as AnyObject
                newPAram["genetics"] =  self.isgenetics as AnyObject
                if self.isLevelSelected != "" {
                    newPAram["growing"] =  self.isLevelSelected as AnyObject
                }else {
                    isError = true
                    messageText = "Difficulty level is missing."
//                    break
                }
                
                if cellMain.txtfield_PlantHeight.hasText {
                    newPAram["plant_height"] =  cellMain.txtfield_PlantHeight.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Mature height is missing."
                    }
                    
//                    break
                }
                
                if cellMain.txtfield_Flowering.hasText {
                    newPAram["flowering_time"] =  cellMain.txtfield_Flowering.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Flowering time is missing."
                    }
//                    break
                }
                
                if cellMain.txtfield_Flowering.hasText {
                    newPAram["min_fahren_temp"] =  cellMain.txtfield_TempFDown.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Fahrenheit minimum is missing."
                    }
                    
//                    break
                }
                
                if cellMain.txtfield_Flowering.hasText {
                    newPAram["max_fahren_temp"] =  cellMain.txtfield_TempFUp.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Fahrenheit maximum temp is missing."
                    }
                    
//                    break
                }
                
                if cellMain.txtfield_Flowering.hasText {
                    newPAram["min_celsius_temp"] =  cellMain.txtfield_TempCDown.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Centigrade minimum temp is missing."
                    }
                    
//                    break
                }
                
                if cellMain.txtfield_Flowering.hasText {
                    newPAram["max_celsius_temp"] =  cellMain.txtfield_TempCUp.text as AnyObject
                }else {
                    isError = true
                    if messageText.characters.count == 0 {
                        messageText = "Centigrade maximum temp is missing."
                    }
                    
//                    break
                }
                
            }else  if let cellMain = indexObj as? AddStrainNotesCell {
                if cellMain.txtViewNotes.text.trimmingCharacters(in: .whitespaces) != "Add Notes."{  //Add Notes.
                newPAram["note"] = cellMain.txtViewNotes.text as AnyObject
                }else {
                    newPAram["note"] = "" as AnyObject
                }
            }
        }
        
        
        if isError {
            
            if messageTextDescription.characters.count > 0 {
                self.ShowErrorAlert(message: messageTextDescription)
                return
            }else if messageTextCrossBreed.characters.count > 0 {
                self.ShowErrorAlert(message: messageTextCrossBreed)
                return
                
            }else {
                self.ShowErrorAlert(message: messageText)
                return
            }
            
        }
        newPAram["strain_id"] = self.chooseStrain.strainID?.stringValue as AnyObject
        
      
        if isEdit{
           newPAram["user_strain_id"] = self.Strain_id_for_edit as AnyObject
        }
        
        print(newPAram)
        if self.array_Attachment.count == 0 {
            self.showLoading()
            NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_strain.rawValue, params: newPAram, completion: { (success, Message, dataMain) in
                self.hideLoading()
                print(dataMain)
                if success {
                    if (dataMain["status"] as! String) == "success" {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name.init("backFrominfo"), object: nil)
                        self.ShowSuccessAlert(message: dataMain["successMessage"] as! String )
                        
                    }else {
                        if (dataMain["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            AppDelegate.appDelegate().PushLoginView()
                            self.ShowLogoutAlert()
                        }else{
                            if let msg = dataMain["errorMessage"] as? String{
                                 self.ShowErrorAlert(message:msg)
                            }else{
                                self.ShowErrorAlert(message: dataMain.description)
                            }
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:Message)
                }                
            })
        }else {
            self.showLoading()
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.save_user_strain.rawValue, image: (self.array_Attachment.first?.image_Attachment)! , withParams : newPAram, onView: self, completion: { (dataMain) in
                self.hideLoading()
                print(dataMain)
                if (dataMain["status"] as! String) == "success" {
                    self.ShowSuccessAlert(message: dataMain["successMessage"] as! String )
                }else {
                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        AppDelegate.appDelegate().PushLoginView()
                        self.ShowLogoutAlert()
                    }
                }
            })
        }
    }
}


//MARK:
//MARK: BUttons Action
extension AddStrainInfoViewController {
    func BackAction(sender : UIButton){
        NotificationCenter.default.post(name: Notification.Name.init("backFrominfo"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
     func Home_Action(sender : UIButton){
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
        
        self.GotoHome()
        
    }
}
class ImageUploadStrainCell: UITableViewCell {
    @IBOutlet var btnUpload : UIButton!
    @IBOutlet var imgviewMain : UIImageView!
}

class AddNewInfoHomeCell: UITableViewCell {
    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Home : UIButton!
    
    @IBOutlet var lblHeadingName : UILabel!
    @IBOutlet var lblType : UILabel!
}

class AddInfoStrainCell: UITableViewCell {
    @IBOutlet var txtViewMain : UITextView!
}

class AddTypeStrainCell: UITableViewCell {
    
    @IBOutlet weak var lbl_hybrid_type: UILabel!
    typealias AddStrainTypeHandler = (_ sliderValue:Float) -> Void

    @IBOutlet weak var lbl_indica_type: UILabel!
    @IBOutlet weak var lbl_stiva_type: UILabel!
    
    @IBOutlet var btn_Back : UIButton!
    
    var gradientLayer: CAGradientLayer!
    var sliderImageView:UIImageView?
    
    var stainHandler:AddStrainTypeHandler?


    @IBOutlet weak var dragMeIV: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var gradView: UIView!
   
    @IBOutlet weak var Lbl_rightPercentage: UILabel!
    @IBOutlet weak var Lbl_leftPercentage: UILabel!
    
    override func awakeFromNib() {
        self.createGradientLayer()
         slider.setThumbImage(#imageLiteral(resourceName: "drag_me"), for: .normal)
//        slider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        slider.addTarget(self, action: #selector(self.sliderValueChange(sender:)), for: .valueChanged)
        self.gradView.bringSubview(toFront: self.slider)
        self.gradView.bringSubview(toFront: Lbl_rightPercentage)
        self.gradView.bringSubview(toFront: Lbl_leftPercentage)
        
        sliderImageView = UIImageView(frame: CGRect(x: (self.gradView.frame.width/2) - 29, y: self.gradView.frame.origin.y-20, width: 66, height: 16))
        sliderImageView?.image = #imageLiteral(resourceName: "dragme")
//        self.contentView.addSubview(sliderImageView!)
        self.sliderValueChange(sender: self.slider)
        self.layoutIfNeeded()
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-60, height: 39)
        gradientLayer.frame = frame
      
        gradientLayer.colors = [UIColor(red:1.000, green:0.694, blue:0.212, alpha:1.000).cgColor,UIColor(red:0.965, green:0.000, blue:0.216, alpha:1.000).cgColor]
        gradientLayer.locations = [0.0, 0.05]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.gradView.layer.addSublayer(gradientLayer)
    }
    @objc func sliderValueChange(sender: UISlider) {
        print("slider value \(slider.value)")
        
        let trackRect = self.slider.trackRect(forBounds: self.slider.bounds)
        let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: self.slider.value)
        var r = imageView?.frame
        r?.origin.x = thumbRect.origin.x
        sliderImageView?.frame = CGRect(x: (r?.origin.x)!, y: (sliderImageView?.frame.origin.y)!, width: (sliderImageView?.frame.size.width)!, height: (sliderImageView?.frame.size.height)!)

        if self.stainHandler != nil {
            self.stainHandler!(slider.value)
        }
        
        if slider.value < 0.5 {
            self.Lbl_rightPercentage.text = String(format: "%.0f",slider.value * 100) + " %"
            self.Lbl_leftPercentage.text = String(format: "%.0f",(1 - slider.value) * 100) + " %"
        }
        else if slider.value >= 0.5{
            self.Lbl_rightPercentage.text = String(format: "%.0f",slider.value * 100) + " %"
            self.Lbl_leftPercentage.text = String(format: "%.0f",(1 - slider.value) * 100) + " %"
            
        }
        
        gradientLayer.colors = [ConstantsColor.gradiant_first_colro, ConstantsColor.gradiant_second_colro]
        switch (slider.value) {
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
        
//        switch (slider.value) {
//        case 0...0.05:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.0, 0.1]
//        case 0.05...0.1:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.05, 0.2]
//
//        case 0.1...0.2:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.1, 0.3]
//        case 0.2...0.4:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.2, 0.45]
//        case 0.4...0.6:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.35, 0.65]
//        case 0.6...0.8:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.55, 0.85]
//        case 0.8...1.0:
//            gradientLayer.colors = [UIColor(red:174.0/255.0, green:89.0/255.0, blue:194.0/255.0, alpha:1.000).cgColor,UIColor(red:194.0/255.0, green:68.0/255.0, blue:98.0/255.0, alpha:1.000).cgColor]
//            gradientLayer.locations = [0.8, 1.0]
//
//        default:
//            break
//        }
        
    }


}

class AddBreedStrainCell: UITableViewCell {
    
    @IBOutlet var txtFieldCrossBreedFirst : AAPickerView!
    @IBOutlet var txtFieldCrossBreedSecond : AAPickerView!
    
    
}

class AddCareCell : UITableViewCell{
    @IBOutlet var btn_LevelEasy : UIButton!
    @IBOutlet var btn_LevelModereate : UIButton!
    @IBOutlet var btn_LevelHard : UIButton!
    
    @IBOutlet var lbl_LevelEasy : UILabel!
    @IBOutlet var lbl_LevelModereate : UILabel!
    @IBOutlet var lbl_LevelHard : UILabel!
    
    @IBOutlet var lbl_Low : UILabel!
    @IBOutlet var lbl_Medium : UILabel!
    @IBOutlet var lbl_High : UILabel!
    @IBOutlet var lbl_Indoor : UILabel!
    @IBOutlet var lbl_OutDoor : UILabel!
    @IBOutlet var lbl_Green : UILabel!
    
    @IBOutlet var txtfield_PlantHeight : UITextField!
    @IBOutlet var txtfield_Flowering : UITextField!
    
    @IBOutlet var txtfield_TempCUp : UITextField!
    @IBOutlet var txtfield_TempCDown : UITextField!
    @IBOutlet var txtfield_TempFUp : UITextField!
    @IBOutlet var txtfield_TempFDown : UITextField!
    
    @IBOutlet var view_Low : UIView!
    @IBOutlet var view_Medium : UIView!
    @IBOutlet var view_High : UIView!
    @IBOutlet var view_Indoor : UIView!
    @IBOutlet var view_OutDoor : UIView!
    @IBOutlet var view_Green : UIView!
    
    @IBOutlet var btn_Low : UIButton!
    @IBOutlet var btn_Medium : UIButton!
    @IBOutlet var btn_High : UIButton!
    @IBOutlet var btn_Indoor : UIButton!
    @IBOutlet var btn_OutDoor : UIButton!
    @IBOutlet var btn_Green : UIButton!
}


class ChemistryCell: UITableViewCell{
    @IBOutlet var CBDText1: UITextField!
    @IBOutlet var CBDText2: UITextField!
    @IBOutlet var THCText1: UITextField!
    @IBOutlet var THCText2: UITextField!
}

class AddStrainNotesCell : UITableViewCell{
    @IBOutlet var txtViewNotes : UITextView!
}


class SubmitStrainCell : UITableViewCell{
    @IBOutlet var btn_Submit : UIButton!
}

