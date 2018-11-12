//
//  myStrainVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ObjectMapper

class myStrainVC: BaseViewController {

    @IBOutlet weak var tableView_myStrain: UITableView!
     fileprivate var shouldLoadMore = true
    var strainArray = [Strain]()
    var choose_StrainUSers = [UserStrain]()
    @IBOutlet weak var indicator_UserStrain: UIView!
    @IBOutlet weak var indicator_SavedStrain: UIView!
    var pageNumber = 0
    var arrayMain = [SaveModel]()
    var refreshControl: UIRefreshControl!
    var isSecondTab : Bool =  true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_myStrain.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func RefreshAPICall(sender:AnyObject){
         self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        self.pageNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.isSecondTab{
            self.CallAPIFilter()
            }else{
            self.APICAll( page:  self.pageNumber)
            }
            
            
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
//        self.APICAll(page: 0)
        self.isSecondTab = true
        self.CallAPIFilter()
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    
    func APICAll(page : Int){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_my_strains.rawValue + String(page))  { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            
            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let strainList = Mapper<Strain>().mapArray(JSONArray:MainResponse["successData"] as! [[String : Any]])
                    let strainUSerList = Mapper<UserStrain>().mapArray(JSONArray:MainResponse["successData"] as! [[String : Any]])
                    let response_array   =  NSMutableArray(array: strainList) as! [Strain]
                    let response_strain_user = NSMutableArray(array: strainUSerList) as! [UserStrain]
                    if page > 0{
                        for data in response_array{
                            self.strainArray.append(data)
                        }
                        for data in response_strain_user{
                            self.choose_StrainUSers.append(data)
                        }
                    }else{
                        self.strainArray =  response_array
                        self.choose_StrainUSers = response_strain_user
                       
                    }
                    self.shouldLoadMore = !response_array.isEmpty
                    self.pageNumber = page
                    print(self.strainArray.count)
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.strainArray.count == 0
            {
                self.tableView_myStrain.setEmptyMessage()
            }else {
                self.tableView_myStrain.restore()
            }
            self.tableView_myStrain.reloadData()
        }
    }
    
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func onClickSaveStrian(_ sender: Any) {
        self.isSecondTab = true
       self.indicator_UserStrain.backgroundColor = UIColor.init(hex: "252525")
       self.indicator_SavedStrain.backgroundColor = UIColor.white
        if self.arrayMain.count > 0 {
            self.tableView_myStrain.reloadData()
        }else{
            self.CallAPIFilter()
        }
        
    }
    @IBAction func onClickUserStrain(_ sender: Any) {
         self.isSecondTab = false
        self.indicator_SavedStrain.backgroundColor = UIColor.init(hex: "252525")
        self.indicator_UserStrain.backgroundColor = UIColor.white
        if self.strainArray.count > 0 {
            self.tableView_myStrain.reloadData()
        }else{
            self.APICAll(page: 0)
        }
    }
    func CallAPIFilter(){
        var newURl = "7"
        if newURl.count == 0 {
            return
        }
        newURl = WebServiceName.filter_my_save.rawValue + newURl
        self.showLoading()
        self.arrayMain.removeAll()
        print(newURl)
        NetworkManager.GetCall(UrlAPI: newURl) { (successRespons, messageResponse, dataResponse) in
            self.hideLoading()
            print(dataResponse)
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    if let data = dataResponse["successData"] as? [[String : Any]]{
                        
                        for indexObj in data {
                            self.arrayMain.append(SaveModel.init(json: indexObj as [String : AnyObject]))
                        }
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
            
            if self.arrayMain.count == 0 {
                self.tableView_myStrain.setEmptyMessage()
            }else{
                self.tableView_myStrain.restore()
            }
            self.tableView_myStrain.reloadData()
        }
        
        
    }
}
extension myStrainVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        
        self.tableView_myStrain.register(UINib(nibName: "mySaveCell", bundle: nil), forCellReuseIdentifier: "mySaveCell")
        self.tableView_myStrain.register(UINib(nibName: "myStrainCell", bundle: nil), forCellReuseIdentifier: "myStrainCell")
       
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSecondTab{
            return self.arrayMain.count
        }else{
             return self.strainArray.count
        }
       
        
    }
    
    
    func DeleteSave(sender : UIButton){
        self.openDeleteAlert(text: "You want to delete this Save?") {
            self.showLoading()
            NetworkManager.GetCall(UrlAPI: WebServiceName.delete_my_save.rawValue + "/\(String(self.arrayMain[sender.tag].ID))") {  (successRespons, messageResponse, dataResponse) in
                self.hideLoading()
                print(dataResponse)
                if successRespons {
                    if (dataResponse["status"] as! String) == "success" {
                        self.arrayMain.remove(at: sender.tag)
                    }else {
                        if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
                self.tableView_myStrain.reloadData()
            }
        }
    }
    //MARK: mySaveCell
    func mySaveCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySaveCell") as? mySaveCell   
        cell?.btn_delete.tag = indexPath.row
        cell?.btn_delete.addTarget(self, action: #selector(self.DeleteSave), for: .touchUpInside)
        if self.arrayMain[indexPath.row].type_id == 7 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "Tab3")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor(red:(246/255), green:(195/255), blue:(80/255), alpha:1.000)
        }else if self.arrayMain[indexPath.row].type_id == 4 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "Tab0")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor(red:0.067, green:0.404, blue:0.588, alpha:1.000)
        }else if self.arrayMain[indexPath.row].type_id == 8 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "tab_map")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor(red:0.427, green:0.122, blue:0.400, alpha:1.000)
        }else if self.arrayMain[indexPath.row].type_id == 10 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "save_Green")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor.init(hex: "7cc244")
        }
        else if self.arrayMain[indexPath.row].type_id == 11 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "saved")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor.init(hex: "942b88")
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.isSecondTab{
             return mySaveCell(tableView:tableView  ,cellForRowAt:indexPath)
        }else{
       
              return myStrainCell(tableView:tableView  ,cellForRowAt:indexPath)
         }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSecondTab {
            let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
            detailView.chooseStrain.strainID = self.arrayMain[indexPath.row].type_sub_id as NSNumber
            detailView.chooseStrain.strain_id = self.arrayMain[indexPath.row].type_sub_id as NSNumber
            detailView.chooseStrain.get_likes_count = 0 as NSNumber
            detailView.chooseStrain.get_dislikes_count = 0 as NSNumber
            self.navigationController?.pushViewController(detailView, animated: true)
        }else{
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "StrainDetailViewController") as! StrainDetailViewController
            detailView.chooseStrain = self.strainArray[indexPath.row].strain!
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
    //MARK: mySaveCell
    func myStrainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myStrainCell") as? myStrainCell
        cell?.lblName.text = "You Updated Description."
        let strain = self.strainArray[indexPath.row].strain
        cell?.lblDescription.text = strain?.title
        if let createdTime = self.strainArray[indexPath.row].updated_at {
            cell?.lblTime.text = self.GetTimeAgo(StringDate: createdTime)
        }
        else{
            cell?.lblTime.text = ""
        }
        cell?.btnEdit.tag = indexPath.row
        cell?.btnEdit.addTarget(self, action: #selector(self.EditStrain), for: .touchUpInside)
        
        cell?.btnDelete.tag = indexPath.row
        cell?.btnDelete.addTarget(self, action: #selector(self.DeleteStrain), for: .touchUpInside)
        
        cell?.selectionStyle = .none
        return cell!
    }

    func EditStrain(sender : UIButton){
        
        let addStrain = self.storyboard?.instantiateViewController(withIdentifier: "AddStrainInfoViewController") as! AddStrainInfoViewController
        addStrain.chooseStrain = self.strainArray[sender.tag].strain!
        addStrain.isEdit = true
        addStrain.Strain_id_for_edit = (self.strainArray[sender.tag].strainID?.intValue)!
        
//        addStrain.chooseUSerStrain = self.choose_StrainUSers[sender.tag]!
        self.navigationController?.pushViewController(addStrain, animated: true)
        
//        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "StrainDetailViewController") as! StrainDetailViewController
//        detailView.chooseStrain = self.strainArray[sender.tag].strain!
//        self.navigationController?.pushViewController(detailView, animated: true)
    }
    func DeleteStrain(sender : UIButton){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this strain?") { (isComp, btnNum) in
            if isComp {
                self.showLoading()
                var newApram  = [String : AnyObject]()
                newApram["user_strain_id"] = self.strainArray[sender.tag].strainID?.stringValue as AnyObject
                NetworkManager.PostCall(UrlAPI: WebServiceName.delete_user_strain.rawValue, params: newApram)  { (successResponse, messageResponse, MainResponse) in
                    self.hideLoading()
                    
                    print(MainResponse)
                    if successResponse {
                        
                        if (MainResponse["status"] as! String) == "success" {
                            self.APICAll(page: 0)
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
        }
      
        
        
        
       
    }
}
extension myStrainVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            if self.isSecondTab != true {
                  self.loadMore()
            }
        }
    }
    
    fileprivate func loadMore() {
        if shouldLoadMore {
           self.APICAll(page: pageNumber +  1)
        }
    }
}
class myStrainCell :UITableViewCell{
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var lblTime : UILabel!
    
    @IBOutlet var btnEdit : UIButton!
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var viewDelete : UIView!
    @IBOutlet var viewEdit : UIView!
}
