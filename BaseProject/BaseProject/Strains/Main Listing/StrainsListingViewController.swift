//
//  StrainsListingViewController.swift
//  BaseProject
//
//  Created by macbook on 23/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ObjectMapper
import AAPickerView
class StrainsListingViewController: BaseViewController{
    
    
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var advance_search_cross_view: UIView!
    @IBOutlet weak var TF_Save_Search: UITextField!
    @IBOutlet weak var lb_Save_Counter: UILabel!
    @IBOutlet weak var lbl_list_img: UIImageView!
    @IBOutlet weak var lbl_list_filer: UILabel!
    @IBOutlet var tble_StrainListing : UITableView!
    @IBOutlet var tble_Filter       : UITableView!
    var searchFromSave = ""
    var isSaved:Bool = false
    var MedicalUse = ""
    var disease = ""
    var mood = ""
    var flavor = ""
    var refreshControl: UIRefreshControl!
    var medicalConditions = [String]()
    var prevention_diease = [String]()
    var moods =  [String]()
    var  flavours =  [String]()
    @IBOutlet var View_SearchSave       : UIView!
    @IBOutlet var View_SavePopup       : UIView!
    
    var tagSearch = ""
    
    @IBOutlet var Filter_TopView: NSLayoutConstraint!
    
    var array_filter = [String]()
    var isApplyingFilter = false
    
    var strainArray = [Strain]()
    var isFliterviewOpen = false
    
    @IBOutlet var Filterview_Height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXibNewBudz()
        self.TF_Save_Search.delegate = self
        self.lb_Save_Counter.text = "0/15"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.PulltoRefresh), for: UIControlEvents.valueChanged)
        self.tble_StrainListing.addSubview(refreshControl)
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFliterviewOpen {
                isFliterviewOpen = false
                self.HideFilterView()
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFliterviewOpen {
                    isFliterviewOpen = false
                    self.HideFilterView()
                }
            }
        }
    }
    
    @IBAction func onClickCrossAdvanceSearch(_ sender: Any) {
     self.advance_search_cross_view.isHidden = true
        self.PulltoRefresh(sender: sender as AnyObject)
    }
    
    
    
    @IBAction func onClockSaveSearch(_ sender: Any) {
        if (self.TF_Save_Search.text?.trimmingCharacters(in: .whitespaces).count)! > 0 {
            self.View_SearchSave.isHidden = true
            self.isApplyingFilter = false
            self.TF_Save_Search.endEditing(true)
            self.tble_StrainListing.reloadData()
            self.HideSavePopUp(sender: sender as! UIButton)
            self.showLoading()
            var urlMain = WebServiceName.save_strain_search.rawValue + "?medical_use=" + MedicalUse.trimmingCharacters(in: .whitespaces)
            urlMain = urlMain +   "&disease_prevention=" + disease.trimmingCharacters(in: .whitespaces) + "&mood_sensation=" + mood.trimmingCharacters(in: .whitespaces)
            urlMain = urlMain +  "&flavor=" + flavor.trimmingCharacters(in: .whitespaces) + "&search_title=" + self.TF_Save_Search.text!.trimmingCharacters(in: .whitespaces)
            print(urlMain)
            NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
                self.hideLoading()
                self.TF_Save_Search.text = ""
                self.lb_Save_Counter.text = "0/15"
                self.MedicalUse = ""
                self.disease = ""
                self.mood = ""
                self.flavor = ""
                self.isApplyingFilter = false
            }
        }else {
            self.ShowErrorAlert(message: "Empty Title!")
        }
    }
    func PulltoRefresh(sender:AnyObject) {
         self.playSound(named: "refresh")
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.lbl_list_filer.text = "List Newest"
            self.getStrains()
            
         })
    }
    

    @IBAction func onclickIndicaSort(sender: UIButton!){
        if !self.refreshControl.isRefreshing{
            self.view.showLoading()
        }
        let urlMain = WebServiceName.get_strains_by_type.rawValue + "/2"
        self.isSaved = false
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            if !self.refreshControl.isRefreshing{
                self.view.hideLoading()
            }
            self.refreshControl.endRefreshing()
            
            self.View_SearchSave.isHidden = true
            self.isApplyingFilter = false
            self.advance_search_cross_view.isHidden = true
            self.strainArray.removeAll()
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    print(self.strainArray.count)
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
            
            
            if self.strainArray.count == 0
            {
                self.tble_StrainListing.setEmptyMessage()
            }else {
                self.tble_StrainListing.restore()
            }
            
            self.tble_StrainListing.reloadData()
        }
    }
    
    @IBAction func onclickSativaSort(sender: UIButton!){
        if !self.refreshControl.isRefreshing{
            self.view.showLoading()
        }
        let urlMain = WebServiceName.get_strains_by_type.rawValue + "/3"
        self.isSaved = false
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            if !self.refreshControl.isRefreshing{
                self.view.hideLoading()
            }
            self.refreshControl.endRefreshing()
            
            self.View_SearchSave.isHidden = true
            self.isApplyingFilter = false
            self.advance_search_cross_view.isHidden = true
            self.strainArray.removeAll()
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    
                    print(self.strainArray.count)
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
            
            
            if self.strainArray.count == 0
            {
                self.tble_StrainListing.setEmptyMessage()
            }else {
                self.tble_StrainListing.restore()
            }
            
            self.tble_StrainListing.reloadData()
        }
    }
    
    @IBAction func onclickHybridSort(sender: UIButton!){
        if !self.refreshControl.isRefreshing{
            self.view.showLoading()
        }
        let urlMain = WebServiceName.get_strains_by_type.rawValue + "/1"
        self.isSaved = false
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            if !self.refreshControl.isRefreshing{
                self.view.hideLoading()
            }
            self.refreshControl.endRefreshing()
            
            self.View_SearchSave.isHidden = true
            self.isApplyingFilter = false
            self.advance_search_cross_view.isHidden = true
            self.strainArray.removeAll()
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    print(self.strainArray.count)
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
            
            
            if self.strainArray.count == 0
            {
                self.tble_StrainListing.setEmptyMessage()
            }else {
                self.tble_StrainListing.restore()
            }
            
            self.tble_StrainListing.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.View_SearchSave.isHidden = true
        self.View_SavePopup.isHidden = true
        self.advance_search_cross_view.isHidden = true
        self.Filter_TopView.constant = -1 * (self.Filterview_Height.constant + 50.0)
        self.tabBarController?.tabBar.isHidden = false
        
        if self.tagSearch.characters.count > 0 {
            self.getSearchStrains(searchValue: self.tagSearch)
        }else if self.searchFromSave.characters.count > 0 {
            self.isSaved = true
            self.searchAdvance(advance: self.searchFromSave)
//            self.getSearchStrains(searchValue: self.searchFromSave)
        } else{
            self.getStrains()
        }
        self.appdelegate.isShownPremioumpopup  = true
    }
}


extension StrainsListingViewController : UITableViewDataSource, UITableViewDelegate{
    
        
    func getStrains(){
        self.lbl_list_img.isHidden = false
        self.lbl_list_filer.isHidden = false
        if !self.refreshControl.isRefreshing{
            self.view.showLoading()
        }
//        let urlMain = WebServiceName.get_strains.rawValue
        let urlMain = WebServiceName.get_strains_alphabitically.rawValue
        self.isSaved = false
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            if !self.refreshControl.isRefreshing{
                self.view.hideLoading()
            }
            self.refreshControl.endRefreshing()
            
            self.View_SearchSave.isHidden = true
            self.isApplyingFilter = false
            self.advance_search_cross_view.isHidden = true
            self.strainArray.removeAll()
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                  let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    self.medicalConditions.removeAll()
                    self.prevention_diease.removeAll()
                    self.moods.removeAll()
                    self.flavours.removeAll()
                    
                    if let medicals = MainResponse["successData"]!["madical_condition_answers"] as? [[String : Any]]{
                        for medical in medicals{
                            if let medical_name = medical["m_condition"] as? String{
                                self.medicalConditions.append(medical_name)
                            }
                        }
                    }
                    
                    if let prevantions = MainResponse["successData"]!["prevention_answers"] as? [[String : Any]]{
                        for prevent in prevantions{
                            if let prevent_name = prevent["prevention"] as? String{
                                self.prevention_diease.append(prevent_name)
                            }
                        }
                    }
                    
                    if let mods = MainResponse["successData"]!["sensation_answers"] as? [[String : Any]]{
                        for mode in mods{
                            if let mode_name = mode["sensation"] as? String{
                                self.moods.append(mode_name)
                            }
                        }
                    }
                    
                    if let flavours_ans = MainResponse["successData"]!["survey_flavor_answers"] as? [[String : Any]]{
                        for flavour in flavours_ans{
                            if let flavour_name = flavour["flavor"] as? String{
                                self.flavours.append(flavour_name)
                            }
                        }
                    }
                    print(self.strainArray.count)
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
            
            
            if self.strainArray.count == 0
            {
                self.tble_StrainListing.setEmptyMessage()
            }else {
                self.tble_StrainListing.restore()
            }
            
            self.tble_StrainListing.reloadData()
        }
    }
    
    
    func getSearchStrains(searchValue : String){
        self.showLoading()
        self.lbl_list_img.isHidden = true
        self.lbl_list_filer.isHidden = true
        
        self.strainArray.removeAll()
        let urlMain = WebServiceName.search_strain_name.rawValue + searchValue
        self.isSaved = false
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            self.isApplyingFilter = false
             self.tagSearch = ""
            self.View_SearchSave.isHidden = true
            self.advance_search_cross_view.isHidden = true
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    print(self.strainArray.count)
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
            
            if self.strainArray.count == 0 {
                self.tble_StrainListing.setEmptyMessage("No Strain Found!", color: UIColor.white)
            }else{
                self.tble_StrainListing.restore()
            }
            self.tble_StrainListing.reloadData()
        }
    }
    
    func RegisterXibNewBudz()
    {
            self.tble_StrainListing.register(UINib(nibName: "StrainListingCell", bundle: nil), forCellReuseIdentifier: "StrainListingCell")
        
        self.tble_Filter.register(UINib(nibName: "SearchNameCell", bundle: nil), forCellReuseIdentifier: "SearchNameCell")

        self.tble_Filter.register(UINib(nibName: "StrainSearchInfoCell", bundle: nil), forCellReuseIdentifier: "StrainSearchInfoCell")
        
        self.tble_Filter.register(UINib(nibName: "StrainSearchFiltercell", bundle: nil), forCellReuseIdentifier: "StrainSearchFiltercell")
        
        self.tble_Filter.register(UINib(nibName: "FilterByStarinCell", bundle: nil), forCellReuseIdentifier: "FilterByStarinCell")

        self.tble_Filter.register(UINib(nibName: "StrainTextSearchCell", bundle: nil), forCellReuseIdentifier: "StrainTextSearchCell")
        
        
        self.tble_StrainListing.register(UINib(nibName: "StrainListingSearchHeadingCell", bundle: nil), forCellReuseIdentifier: "StrainListingSearchHeadingCell")
        
        self.tble_StrainListing.register(UINib(nibName: "StrainListingSearchCell", bundle: nil), forCellReuseIdentifier: "StrainListingSearchCell")


        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView.tag == 100 {
            return self.array_filter.count
        }
        if isApplyingFilter{
            return self.strainArray.count + 1
        }
        return self.strainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 100{
            
            switch self.array_filter[indexPath.row] {
            case StrainFilter.StrainMatchingText.rawValue:
                return self.strainSearchInfo(tableView , cellForRowAt: indexPath)
            case StrainFilter.Button.rawValue:
                return self.StrainSearchButtonCell(tableView , cellForRowAt: indexPath)
            case StrainFilter.FilterBy.rawValue:
                return self.filterHeading(tableView , cellForRowAt: indexPath)
            case StrainFilter.TextFieldSearch.rawValue:
                return self.StrainSearchTextcell(tableView , cellForRowAt: indexPath)
                
            default:
                return self.NameKeywordCell(tableView , cellForRowAt: indexPath)
                
            }
            
        }else {
            
            if isApplyingFilter {
                if indexPath.row == 0 {
                    let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainListingSearchHeadingCell") as! StrainListingSearchHeadingCell
                    strainCell.selectionStyle = .none
                    return strainCell
                }else {
                    let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainListingSearchCell") as! StrainListingSearchCell
                    print("Total")
                    print(self.strainArray.count)
                    print("Row")
                    let row = indexPath.row - 1
                    print(indexPath.row)
                    
                    
                    strainCell.lblName.text = self.strainArray[row].title
                    
                    strainCell.lblReview.text = (self.strainArray[row].get_review_count?.stringValue)! + " Reviews"
                    if self.strainArray[row].rating?.total != nil {
                        strainCell.lblRate.text = String(format:"%.1f", (self.strainArray[row].rating?.total!.doubleValue)!)
                        
                    }else {
                        strainCell.lblRate.text = "0.0"
                        
                    }
                    
                    strainCell.lbl_matching.text = "\(self.strainArray[row].matched ?? 0) of 4"
                    
                    if self.strainArray[row].strainType?.typeID == 1 {
                        strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainGreenColor)
                        strainCell.lblType.textColor = ConstantsColor.kStrainGreenColor
                        strainCell.lblType.text = "H"
                    }else if self.strainArray[row].strainType?.typeID == 2 {
                        strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainPurpleColor)
                        strainCell.lblType.textColor = ConstantsColor.kStrainPurpleColor
                        strainCell.lblType.text = "I"
                    }else {
                        strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainRedColor)
                        strainCell.lblType.textColor = ConstantsColor.kStrainRedColor
                        strainCell.lblType.text = "S"
                    }
                    
                    if Double(strainCell.lblRate.text!)! < 1.0 {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain0B")
                    }else if Double(strainCell.lblRate.text!)! < 2.0 {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain1B")
                    }else if Double(strainCell.lblRate.text!)! < 3.0 {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain2B")
                    }else if Double(strainCell.lblRate.text!)! < 4.0 {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain3B")
                    } else if Double(strainCell.lblRate.text!)! < 5.0 {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain4B")
                    }else {
                        strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain5B")
                    }
                    //
                    
                    strainCell.selectionStyle = .none
                    return strainCell
                }

            }else {
                let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainListingCell") as! StrainListingCell
                
                print("Total")
                print(self.strainArray.count)
                print("Row")
                print(indexPath.row)
                
                strainCell.lblName.text = self.strainArray[indexPath.row].title
            
                strainCell.lblReview.text = (self.strainArray[indexPath.row].get_review_count?.stringValue)! + " Reviews"
                if self.strainArray[indexPath.row].rating?.total != nil {
                    strainCell.lblRate.text = String(format:"%.1f", (self.strainArray[indexPath.row].rating?.total!.doubleValue)!)
                    
                }else {
                    strainCell.lblRate.text = "0.0"
                    
                }
            
            
            if self.strainArray[indexPath.row].strainType?.typeID == 1 {
                strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainGreenColor)
                strainCell.lblType.textColor = ConstantsColor.kStrainGreenColor
                strainCell.lblType.text = "H"
            }else if self.strainArray[indexPath.row].strainType?.typeID == 2 {
                   strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainPurpleColor)
                strainCell.lblType.textColor = ConstantsColor.kStrainPurpleColor
                strainCell.lblType.text = "I"
            }else {
                strainCell.view_Type.CornerRadious(WithColor: ConstantsColor.kStrainRedColor)
                strainCell.lblType.textColor = ConstantsColor.kStrainRedColor
                strainCell.lblType.text = "S"
            }
                
                if Double(strainCell.lblRate.text!)! < 1.0 {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain0B")
                }else if Double(strainCell.lblRate.text!)! < 2.0 {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain1B")
                }else if Double(strainCell.lblRate.text!)! < 3.0 {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain2B")
                }else if Double(strainCell.lblRate.text!)! < 4.0 {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain3B")
                } else if Double(strainCell.lblRate.text!)! < 5.0 {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain4B")
                }else {
                    strainCell.imgViewRate.image = #imageLiteral(resourceName: "Strain5B")
                }
//                
                
                strainCell.selectionStyle = .none
                return strainCell
            }
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            
        }else {
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "StrainDetailViewController") as! StrainDetailViewController
            detailView.chooseStrain = self.strainArray[indexPath.row]
            self.navigationController?.pushViewController(detailView, animated: true)
        }
        
    }
    
    func NameKeywordCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    {
        let strainCell = tableView.dequeueReusableCell(withIdentifier: "SearchNameCell") as! SearchNameCell
        strainCell.txtFieldSearch.text = ""
        strainCell.selectionStyle = .none
        return strainCell
    }
    
    func strainSearchInfo(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainSearchInfoCell") as! StrainSearchInfoCell
        strainCell.selectionStyle = .none
        return strainCell
    }
    
    func StrainSearchButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainSearchFiltercell") as! StrainSearchFiltercell
        
        
        strainCell.btn_Submit.removeTarget(nil, action: nil, for: .allEvents)
        if indexPath.row == 1 {
            strainCell.btn_Submit.setTitle("SEARCH", for: UIControlState.normal)
            strainCell.btn_Submit.addTarget(self, action: #selector(self.searchFilter), for: UIControlEvents.touchUpInside)
        }else if indexPath.row == 3 {
            strainCell.btn_Submit.setTitle("HELP ME FIND MATCHES", for: UIControlState.normal)
            strainCell.btn_Submit.addTarget(self, action: #selector(self.ShowNextFilter), for: UIControlEvents.touchUpInside)
        }else
        {
            strainCell.btn_Submit.setTitle("SHOW MATCHES", for: UIControlState.normal)
            strainCell.btn_Submit.addTarget(self, action: #selector(self.FilterDONE), for: UIControlEvents.touchUpInside)

        }
        strainCell.selectionStyle = .none
        return strainCell
    }
    
    func filterHeading(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strainCell = tableView.dequeueReusableCell(withIdentifier: "FilterByStarinCell") as! FilterByStarinCell
        strainCell.selectionStyle = .none
        return strainCell
    }
    
    
    
    func StrainSearchTextcell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strainCell = tableView.dequeueReusableCell(withIdentifier: "StrainTextSearchCell") as! StrainTextSearchCell
        strainCell.txtFieldMain.pickerType = .StringPicker
        strainCell.txtFieldMain.delegate = self
        strainCell.txtFieldMain.text = ""
        if indexPath.row == 1 {
            strainCell.lbl_Heading.text = "Medical Use:"
            strainCell.txtFieldMain.tag = 45
            strainCell.txtFieldMain.stringPickerData = self.medicalConditions
            strainCell.txtFieldMain.stringDidChange = { index in
                print("selectedString ", self.medicalConditions[index])
                self.MedicalUse = self.medicalConditions[index]
            }
        }else if indexPath.row == 2 {
            strainCell.lbl_Heading.text = "Disease Prevention:"
            strainCell.txtFieldMain.tag = 46
            strainCell.txtFieldMain.stringPickerData = self.prevention_diease
            strainCell.txtFieldMain.stringDidChange = { index in
                print("selectedString ", self.prevention_diease[index])
                self.disease = self.prevention_diease[index]
            }
        }else if indexPath.row == 3 {
            strainCell.lbl_Heading.text = "Mood & Sensation:"
            strainCell.txtFieldMain.tag = 47
            strainCell.txtFieldMain.stringPickerData = self.moods
            strainCell.txtFieldMain.stringDidChange = { index in
                print("selectedString ", self.moods[index])
                self.mood = self.moods[index]
            }
        }else if indexPath.row == 4 {
            strainCell.lbl_Heading.text = "Flavor Profile:"
            strainCell.txtFieldMain.tag = 48
            strainCell.txtFieldMain.stringPickerData = self.flavours
            strainCell.txtFieldMain.stringDidChange = { index in
                print("selectedString ", self.flavours[index])
                self.flavor = self.flavours[index]
            }
        }
        strainCell.selectionStyle = .none
        return strainCell
    }

//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        switch textField.tag {
//        case 45:
//            MedicalUse = textField.text!
//            print(MedicalUse)
//            break
//        case 46:
//             disease = textField.text!
//               print(disease)
//            break
//        case 47:
//             mood = textField.text!
//               print(mood)
//            break
//        case 48:
//             flavor = textField.text!
//               print(flavor)
//            break
//        default:
//            break
//        }
//        return true
//    }
}

//MARK:
//MARK: Button Action
extension StrainsListingViewController {
    
    func FilterDONE(sender : UIButton){
    
        self.HideFilterView()
        var mainUrl = ""
        
        
        if MedicalUse.count > 0 {
            mainUrl =  "medical_use=" + MedicalUse
        }
        
        if disease.count > 0 {
            if mainUrl.count > 0 {
                mainUrl = mainUrl + "&"
            }
            mainUrl = mainUrl + "disease_prevention=" + disease
        }
        
        if mood.count > 0 {
            if mainUrl.count > 0 {
                mainUrl = mainUrl + "&"
            }
            mainUrl = mainUrl + "mood_sensation=" + mood
        }
        
        if flavor.count > 0 {
            if mainUrl.count > 0 {
                mainUrl = mainUrl + "&"
            }
            mainUrl = mainUrl + "flavor=" + flavor
        }
        
        self.advance_search_cross_view.isHidden = false
        if mainUrl.isEmpty{
            self.strainArray.removeAll()
            self.tble_StrainListing.reloadData()
             self.tble_StrainListing.setEmptyMessage("No Matches Found, Please change terms!", color: UIColor.lightGray)
        }else{
            self.View_SearchSave.isHidden = false
            self.tble_StrainListing.reloadData()
            self.searchAdvance(advance: mainUrl)
        }
    }
    func searchAdvance(advance : String){
        self.lbl_list_img.isHidden = true
        self.lbl_list_filer.isHidden = true
        self.View_SearchSave.isHidden = false
        self.advance_search_cross_view.isHidden = false
        if(self.searchFromSave.count < 1){
            self.isSaved = false
        }
        self.searchFromSave = ""
        var testVariable = advance.replacingOccurrences(of: "?", with: "")
        testVariable = advance.replacingOccurrences(of: "’", with: "")
        testVariable = WebServiceName.search_strain_survey.rawValue + testVariable.trimmingCharacters(in: .whitespacesAndNewlines) + "&skip=0"
        testVariable = testVariable.replacingOccurrences(of: " ", with: "%20")
        print(testVariable)
        print(advance)
        self.showLoading()
        NetworkManager.GetCall(UrlAPI:testVariable ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    self.isApplyingFilter = true
                    self.strainArray.removeAll()
                    if let dat_array = MainResponse["successData"] {
                        if let data_array = dat_array["strains"] as? [[String : Any]]{
                        for strain in data_array {
                            if let data = strain["get_strain"] as? [String : Any] {
                                
                                if  let strain_obj = Mapper<Strain>().map(JSONObject: data){
                                    if let metched = strain["matched"] as? Int{
                                        strain_obj.matched = metched
                                    }else{
                                        strain_obj.matched = 0
                                    }
                                    self.strainArray.append(strain_obj)
                                }
                            }
                            
                        }
                    }
                    }
                    self.medicalConditions.removeAll()
                    self.prevention_diease.removeAll()
                    self.moods.removeAll()
                    self.flavours.removeAll()
                    
                    if let medicals = MainResponse["successData"]!["madical_condition_answers"] as? [[String : Any]]{
                        for medical in medicals{
                            if let medical_name = medical["m_condition"] as? String{
                                self.medicalConditions.append(medical_name)
                            }
                        }
                    }
                    
                    if let prevantions = MainResponse["successData"]!["prevention_answers"] as? [[String : Any]]{
                        for prevent in prevantions{
                            if let prevent_name = prevent["prevention"] as? String{
                                self.prevention_diease.append(prevent_name)
                            }
                        }
                    }
                    
                    if let mods = MainResponse["successData"]!["sensation_answers"] as? [[String : Any]]{
                        for mode in mods{
                            if let mode_name = mode["sensation"] as? String{
                                self.moods.append(mode_name)
                            }
                        }
                    }
                    
                    if let flavours_ans = MainResponse["successData"]!["survey_flavor_answers"] as? [[String : Any]]{
                        for flavour in flavours_ans{
                            if let flavour_name = flavour["flavor"] as? String{
                                self.flavours.append(flavour_name)
                            }
                        }
                    }
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        AppDelegate.appDelegate().PushLoginView()
                        self.ShowLogoutAlert()
                    }else{
                        self.ShowErrorAlert(message: (MainResponse["errorMessage"] as? String)!)
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.strainArray.count == 0 {
                self.tble_StrainListing.setEmptyMessage("No Matches Found, Please change terms!", color: UIColor.lightGray)
            }else{
                self.tble_StrainListing.restore()
            }
            self.tble_StrainListing.reloadData()
        }
    }
    
    func searchFilter(sender : UIButton){
        let cellMain = self.tble_Filter.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! SearchNameCell
        cellMain.txtFieldSearch.resignFirstResponder()
        if (cellMain.txtFieldSearch.text!.characters.count > 0 ) {
            
            self.getSearchStrains(searchValue: cellMain.txtFieldSearch.text!.replacingOccurrences(of: " ", with: "+"))
            self.HideFilterView()
        }else{
            self.ShowErrorAlert(message: "Please enter your data!", AlertTitle: "")
        }
    }
    
    
    func ShowNextFilter(sender : UIButton){
        self.array_filter.removeAll()
        
         self.Filterview_Height.constant = 450
        
        self.array_filter.append(StrainFilter.FilterBy.rawValue)
        self.array_filter.append(StrainFilter.TextFieldSearch.rawValue)
        self.array_filter.append(StrainFilter.TextFieldSearch.rawValue)
        self.array_filter.append(StrainFilter.TextFieldSearch.rawValue)
        self.array_filter.append(StrainFilter.TextFieldSearch.rawValue)
        self.array_filter.append(StrainFilter.Button.rawValue)
        
        self.tble_Filter.reloadData()

    }
    
    @IBAction func ShowStrainFilter(sender : UIButton){
        
        self.ShowFirstFilter()
        UIView.animate(withDuration: 0.5, animations: {
            self.tble_StrainListing.alpha = 0.2
            self.Filter_TopView.constant = 40
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func HideStrainFilter(sender : UIButton){
        
       self.HideFilterView()
    }
    
    
    func HideFilterView(){
         isFliterviewOpen = false
        self.tble_StrainListing.isScrollEnabled = true
        self.tble_StrainListing.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tble_StrainListing.alpha = 1.0
            self.Filter_TopView.constant = -1 * (self.Filterview_Height.constant + 50.0)
            self.view.layoutIfNeeded()
        })
    }
    
    func ShowFirstFilter(){
         isFliterviewOpen = true
        self.tble_StrainListing.isScrollEnabled = false
        self.tble_StrainListing.isUserInteractionEnabled = false
        self.array_filter.removeAll()
         self.Filterview_Height.constant = 450
        self.array_filter.append(StrainFilter.NameKeyword.rawValue)
        self.array_filter.append(StrainFilter.Button.rawValue)
        self.array_filter.append(StrainFilter.StrainMatchingText.rawValue)        
        self.array_filter.append(StrainFilter.Button.rawValue)
        self.tble_Filter.reloadData()
    }
    
    @IBAction func ShowSavePopUp(sender : UIButton){
        if !self.isSaved {
            self.View_SavePopup.isHidden = false
        }else {
            self.ShowErrorAlert(message: "Already Saved Search!")
        }
    }
    
    @IBAction func HideSavePopUp(sender : UIButton){
        self.View_SavePopup.isHidden = true
        self.TF_Save_Search.endEditing(true)
//        self.View_SearchSave.isHidden = true
//        self.isApplyingFilter = false
//        self.tble_StrainListing.reloadData()
    }
    
    
    @IBAction func ShowMenu(sender : UIButton){
        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        
    }

    @IBAction func AlphabticAction(sender : UIButton){
        self.isSaved = false
        self.lbl_list_img.isHidden = false
        self.lbl_list_filer.isHidden = false
        self.showLoading()
        self.strainArray.removeAll()
        var urlMain = WebServiceName.get_strains_alphabitically.rawValue
        if(self.lbl_list_filer.text == "List Alphabetically"){
        
            self.lbl_list_filer.text = "List Newest"
            urlMain = WebServiceName.get_strains_alphabitically.rawValue
        }else {
            self.lbl_list_filer.text = "List Alphabetically"
            urlMain = WebServiceName.get_strains.rawValue
        }
        
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
              self.isApplyingFilter = false
            self.View_SearchSave.isHidden = true
            self.advance_search_cross_view.isHidden = true
//            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"]!["strains"] as! [[String : Any]])
                    self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                    self.medicalConditions.removeAll()
                    self.prevention_diease.removeAll()
                    self.moods.removeAll()
                    self.flavours.removeAll()
                    
                    if let medicals = MainResponse["successData"]!["madical_condition_answers"] as? [[String : Any]]{
                        for medical in medicals{
                            if let medical_name = medical["m_condition"] as? String{
                                self.medicalConditions.append(medical_name)
                            }
                        }
                    }
                    
                    if let prevantions = MainResponse["successData"]!["prevention_answers"] as? [[String : Any]]{
                        for prevent in prevantions{
                            if let prevent_name = prevent["prevention"] as? String{
                                self.prevention_diease.append(prevent_name)
                            }
                        }
                    }
                    
                    if let mods = MainResponse["successData"]!["sensation_answers"] as? [[String : Any]]{
                        for mode in mods{
                            if let mode_name = mode["sensation"] as? String{
                                self.moods.append(mode_name)
                            }
                        }
                    }
                    
                    if let flavours_ans = MainResponse["successData"]!["survey_flavor_answers"] as? [[String : Any]]{
                        for flavour in flavours_ans{
                            if let flavour_name = flavour["flavor"] as? String{
                                self.flavours.append(flavour_name)
                            }
                        }
                    }
                    print(self.strainArray.count)
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
            
            if self.strainArray.count == 0 {
                self.tble_StrainListing.setEmptyMessage("No Strain Found!", color: UIColor.white)
            }else{
                self.tble_StrainListing.restore()
            }
            self.tble_StrainListing.reloadData()
        }
    }
    
}

class  StrainListingCell: UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblRate : UILabel!
    @IBOutlet var lblType : UILabel!
    
    @IBOutlet var imgViewRate : UIImageView!
    
    @IBOutlet var view_Type : UIView!
    
}

class SearchNameCell: UITableViewCell {
    @IBOutlet var txtFieldSearch : UITextField!
}

class StrainSearchInfoCell: UITableViewCell {
    
}

class StrainSearchFiltercell: UITableViewCell {
    @IBOutlet var btn_Submit : UIButton!
}

class FilterByStarinCell: UITableViewCell {

}

class StrainTextSearchCell: UITableViewCell {
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var txtFieldMain : AAPickerView!
}

class  StrainListingSearchHeadingCell: UITableViewCell {
    
}
extension StrainsListingViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if(newLength < 16){
            self.lb_Save_Counter.text = "\(newLength)/15"
        }
        return newLength <= 15
    }
    
}
class  StrainListingSearchCell: UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblRate : UILabel!
    @IBOutlet var lblType : UILabel!
    
    @IBOutlet weak var lbl_matching: UILabel!
    @IBOutlet var imgViewRate : UIImageView!
    
    @IBOutlet var view_Type : UIView!
}
