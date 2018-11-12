//
//  MyRewardsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class MyRewardsVC: BaseViewController {
    var afterCompleting = 0
    @IBOutlet weak var Lbl_Total_Rewards: UILabel!
    public static var total_points : NSNumber = 0
    @IBOutlet weak var View_Menu_Redeem: UIView!
    @IBOutlet weak var View_Menu_mypoints: UIView!
    var data_array  =  [[String : Any]]()
    var points_array  =  [[String : Any]]()
    var points_log_array  =  [[String : Any]]()
    var products_array  =  [[String : Any]]()
    @IBOutlet weak var tbl_rewards: UITableView!
    
    @IBOutlet weak var menuBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.PurchaseProduct(notification:)), name: Notification.Name("PurchasedRewardProduct"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.FreePointsTab()
        if (self.afterCompleting == 1){
            
        }else {
            self.disableMenu()
        }
    }
    @IBAction func OnClickBack(_ sender: Any) {
        if self.afterCompleting == 1 {
            self.GotoHome()
        }else {
            self.Back()
        }
        
    }
    
    @IBAction func OnClickHome(_ sender: Any) {
        self.GotoHome()
    }
    
    func PurchaseProduct(notification: NSNotification) {
        print("purchased")
        if let data = notification.userInfo as? [String: Any]{
            self.Lbl_Total_Rewards.text = "\(MyRewardsVC.total_points.intValue)"
            self.OpenRedeemCompleteAlert(reward_data: data)
        }
    }
    func FreePointsTab() {
        if(self.points_log_array.count == 0){
            data_array.removeAll()
            data_array.append(["cell_type" : "Header","title" : "header"])
            data_array.append(["cell_type" : "Tab","title" : "tab"])
            data_array.append(["cell_type" : "detail","title" : "tab"])
            data_array.append(["cell_type" : "Loading","title" : "tab"])
            self.tbl_rewards.reloadData()
            self.points_array = self.data_array
             self.GetPoints()
        }else{
            self.data_array.removeAll()
            self.data_array = self.points_array
            self.tbl_rewards.reloadData()
        }
    }
    func PointsLogTab() {
        if(self.points_log_array.count == 0){
            data_array.removeAll()
            data_array.append(["cell_type" : "Header","title" : "header"])
            data_array.append(["cell_type" : "Tab","title" : "tab"])
            data_array.append(["cell_type" : "detail","title" : "tab"])
             data_array.append(["cell_type" : "Loading","title" : "tab"])
            self.tbl_rewards.reloadData()
            self.points_log_array = self.data_array
            self.GetPointsLog()
        }else{
            self.data_array.removeAll()
            self.data_array = self.points_log_array
            self.tbl_rewards.reloadData()
        }
    }
    func HBStoreTab() {
        if(self.products_array.count == 0){
            data_array.removeAll()
            data_array.append(["cell_type" : "HBStore_Header","title" : "header"])
            data_array.append(["cell_type" : "Tab","title" : "tab"])
            data_array.append(["cell_type" : "Loading","title" : "tab"])
            self.tbl_rewards.reloadData()
            self.GetProducts()
        }else{
            data_array.removeAll()
            data_array.append(["cell_type" : "HBStore_Header","title" : "header"])
            data_array.append(["cell_type" : "Tab","title" : "tab"])
            data_array.append(["cell_type" : "HBStore_Item","title" : "tab" , "HBStore_items" : self.products_array])
            self.tbl_rewards.reloadData()
        }
    }
    
    
    func GetPoints(){
        let mainUrl = WebServiceName.get_my_rewards.rawValue
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    if let data = dataResponse["successData"] as? [String : Any]{
                        if let points = data["total_points"] as? NSNumber{
                            MyRewardsVC.total_points = points
                            self.Lbl_Total_Rewards.text = "\(points)"
                        }
                        if let points_Array = data["rewards"] as? [[String : Any]] {
                            for indexObj in points_Array {
                                var obj_data = [String : Any]()
                                obj_data = indexObj
                                if let status = obj_data["user_rewards_count"] as? NSNumber{
                                    if(status.intValue == 0){
                                        obj_data["cell_type"] = "Pending"
                                    }else{
                                         obj_data["cell_type"] = "Complete"
                                    }
                                }else{
                                     obj_data["cell_type"] = "Pending"
                                }
                                self.points_array.append(obj_data)
                            }
                            self.points_array[3] = ["cell_type" : "Details","title" : "tab"]
                            self.data_array.removeAll()
                            self.data_array = self.points_array
                            self.tbl_rewards.reloadData()
                        }
                        
                        
                        
                        var obj_data = [String : Any]()
                        obj_data["cell_type"] = "productsHEading"
                        self.data_array.append(obj_data)
                        self.points_array.append(obj_data)
                        
                        if let points_Array = data["products"] as? [[String : Any]] {
                            for indexObj in points_Array {
                                var obj_data = [String : Any]()
                                obj_data = indexObj

                                obj_data["cell_type"] = "products"
                                self.points_array.append(obj_data)
                                self.data_array.append(obj_data)
                            }
                            
                            if points_Array.count == 0{
                                self.data_array.append(["cell_type" : "NoRecodFoundCell","title" : "tab"])
                                self.points_array.append(["cell_type" : "NoRecodFoundCell","title" : "tab"])
                            
                            }
                            
                            self.tbl_rewards.reloadData()
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
        }
    }
    
    func GetProducts(){
        let mainUrl = WebServiceName.get_products.rawValue
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            if successRespons {
                
                
                
                if (dataResponse["status"] as! String) == "success" {
                    if let data = dataResponse["successData"] as? [String : Any]{
                        if let products_array = data["products"] as? [[String : Any]] {
                            self.products_array.removeAll()
                            for indexObj in products_array {
                                self.products_array.append(indexObj)
                            }
                            self.data_array.remove(at: 2)
                            self.data_array.append(["cell_type" : "HBStore_Item","title" : "tab" , "HBStore_items" : self.products_array])
                            self.tbl_rewards.reloadData()
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
        }
    }
    
    func GetPointsLog(){
        let mainUrl = WebServiceName.get_user_point_log.rawValue
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    if let data = dataResponse["successData"] as? [String : Any]{
                        if let points_Array = data["points"] as? [[String : Any]] {
                            for indexObj in points_Array {
                                var obj_data = [String : Any]()
                                obj_data = indexObj
                                obj_data["cell_type"] = "Points_Log"
                                self.points_log_array.append(obj_data)
                            }
                            self.points_log_array.remove(at: 3)
                            if self.points_log_array.count == 3{
                                self.points_log_array.append(["cell_type" : "NoRecodFoundCell","title" : "tab"])
                            }
                            self.data_array.removeAll()
                            self.data_array = self.points_log_array
                           
                            self.tbl_rewards.reloadData()
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
        }
    }
}

extension MyRewardsVC :UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        
         self.tbl_rewards.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        self.tbl_rewards.register(UINib(nibName: "RewardsHeaderCell", bundle: nil), forCellReuseIdentifier: "RewardsHeaderCell")
        self.tbl_rewards.register(UINib(nibName: "RewardsTabCell", bundle: nil), forCellReuseIdentifier: "RewardsTabCell")
        self.tbl_rewards.register(UINib(nibName: "RewarsDiscriptionCell", bundle: nil), forCellReuseIdentifier: "RewarsDiscriptionCell")
        self.tbl_rewards.register(UINib(nibName: "CompletedRewardsCell", bundle: nil), forCellReuseIdentifier: "CompletedRewardsCell")
        self.tbl_rewards.register(UINib(nibName: "PendingRewardsCell", bundle: nil), forCellReuseIdentifier: "PendingRewardsCell")
        self.tbl_rewards.register(UINib(nibName: "PointsLogCell", bundle: nil), forCellReuseIdentifier: "PointsLogCell")
        self.tbl_rewards.register(UINib(nibName: "RewardProductCell", bundle: nil), forCellReuseIdentifier: "RewardProductCell")
        self.tbl_rewards.register(UINib(nibName: "LabelRewardCell", bundle: nil), forCellReuseIdentifier: "LabelRewardCell")
        self.tbl_rewards.register(UINib(nibName: "HBStoreHeaderCell", bundle: nil), forCellReuseIdentifier: "HBStoreHeaderCell")
        self.tbl_rewards.register(UINib(nibName: "HbStoreItemsCell", bundle: nil), forCellReuseIdentifier: "HbStoreItemsCell")
         self.tbl_rewards.register(UINib(nibName: "NoRecodFoundCell", bundle: nil), forCellReuseIdentifier: "NoRecodFoundCell")
        self.tbl_rewards.register(UINib(nibName: "StoreMsgCell", bundle: nil), forCellReuseIdentifier: "StoreMsgCell")
        
        self.tbl_rewards.register(UINib(nibName: "HeaderDetailCell", bundle: nil), forCellReuseIdentifier: "HeaderDetailCell")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let type = data_array[indexPath.row]["cell_type"] as! String
        switch type {
        case "Loading":
            return LoadingCell(tableView  ,cellForRowAt:indexPath)
        case "products":
            return RewardProductCell(tableView  ,cellForRowAt:indexPath)
        case "detail":
            return RewardDetails(tableView  ,cellForRowAt:indexPath)
        case "productsHEading":
            return LabelRewardCell(tableView  ,cellForRowAt:indexPath)
        case "Header":
            return HeaderCell(tableView  ,cellForRowAt:indexPath)
        case "HBStore_Header":
            return HBStoreHeaderCell(tableView  ,cellForRowAt:indexPath)
        case "Tab":
            return RewardsTabCell(tableView  ,cellForRowAt:indexPath)
        case "Details":
            return RewarsDiscriptionCell(tableView  ,cellForRowAt:indexPath)
        case "Complete":
            return CompletedRewardsCell(tableView  ,cellForRowAt:indexPath)
        case "Pending":
            return PendingRewardsCell(tableView  ,cellForRowAt:indexPath)
        case "Points_Log":
            return PointsLogCell(tableView  ,cellForRowAt:indexPath)
        case "HBStore_Item":
            if self.products_array.count == 0{
            return StoreMsgCell(tableView  ,cellForRowAt:indexPath)
            }else{
            return HbStoreItemsCell(tableView  ,cellForRowAt:indexPath)
            }
        case "NoRecodFoundCell":
            return NoRecordFound(tableView  ,cellForRowAt:indexPath)
        default:
             return HeaderCell(tableView  ,cellForRowAt:indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let type = data_array[indexPath.row]["cell_type"] as! String
         if type == "Pending" {
            switch indexPath.row{
            case 4:
                let AskQuestionVc = self.GetView(nameViewController: "AskQuestionViewController", nameStoryBoard: StoryBoardConstant.QA)
                self.navigationController?.pushViewController(AskQuestionVc, animated: true)
                break
            case 5:
                self.OpenProfileVC(id: (DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)
                break
            case 6:
                let search_vc = self.GetView(nameViewController: "QAMainSearchViewController", nameStoryBoard: "QAStoryBoard") as!  QAMainSearchViewController
                search_vc.isFromRewardSection = true
                self.navigationController?.pushViewController(search_vc, animated: true)
                break
            case 7:
                self.PushViewWithStoryBoard(nameViewController: "FollowKeyword", nameStoryBoard: "Rewards")
                break
            case 8:
                self.PushViewWithStoryBoard(nameViewController: "SupportVC", nameStoryBoard: "Main")
                break
            case 9:
                let QAView = self.GetView(nameViewController: "QAMainVC", nameStoryBoard: StoryBoardConstant.Main) as! QAMainVC
                self.navigationController?.pushViewController(QAView, animated: true)
                break
            case 10:
                let mainStrain = self.GetView(nameViewController: "StrainsListingViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainsListingViewController
                self.navigationController?.pushViewController(mainStrain, animated: true)
                break
            default:
                break
            }
            print(indexPath.row)
         }
    }

    func NoRecordFound(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "NoRecodFoundCell") as! NoRecodFoundCell
        cell.selectionStyle = .none
        return cell
    }
    
    func RewardDetails(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "HeaderDetailCell") as! HeaderDetailCell
        cell.points.text = MyRewardsVC.total_points.stringValue
        cell.selectionStyle = .none
        return cell
    }

    func HeaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "RewardsHeaderCell") as! RewardsHeaderCell
        cell.lbl_points.text = "\(MyRewardsVC.total_points.intValue)"
        cell.selectionStyle = .none
        return cell
    }

    
    func LabelRewardCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "LabelRewardCell") as! LabelRewardCell
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func RewardProductCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "RewardProductCell") as! RewardProductCell
        
        let product = data_array[indexPath.row]["get_product"] as? [String : Any]
        cell.lblNAme.text = product!["name"] as! String
        cell.lblPoints.text = String(product!["points"] as! Int) + " points"
        if let attachment = product!["attachment"] as? String {
            cell.imgViewMain.moa.url = WebServiceName.images_baseurl.rawValue + attachment.RemoveSpace()
        }
        let dateText = product!["created_at"] as! String
        cell.lbRedeemdate.text = "Redeem Date: " + dateText.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MM-dd-yyyy")
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func HBStoreHeaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "HBStoreHeaderCell") as! HBStoreHeaderCell
        cell.totalRewardLbl.text = self.Lbl_Total_Rewards.text
        cell.backButtonAction = {[unowned self] in
            let button = UIButton()
            self.OnClickBack(button)
        }
        cell.homesButtonAction = {[unowned self] in
            let button = UIButton()
            self.OnClickHome(button)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func RewardsTabCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "RewardsTabCell") as! RewardsTabCell
        cell.tab_clickListner_delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func RewarsDiscriptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "RewarsDiscriptionCell") as! RewarsDiscriptionCell
        cell.selectionStyle = .none
        return cell
    }
    func CompletedRewardsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "CompletedRewardsCell") as! CompletedRewardsCell
        cell.LBL_discription.text = data_array[indexPath.row]["title"] as? String ?? "Complete your profile."
        cell.lbl_points.text = "+\((data_array[indexPath.row]["points"] as! NSNumber).intValue)"
        cell.selectionStyle = .none
        return cell
    }
    func PendingRewardsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "PendingRewardsCell") as! PendingRewardsCell
        cell.LBL_discription.text = data_array[indexPath.row]["title"] as? String ?? "Complete your profile."
        cell.lbl_points.text = "+\((data_array[indexPath.row]["points"] as! NSNumber).intValue)"
        cell.selectionStyle = .none
        return cell
    }
    func PointsLogCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "PointsLogCell") as! PointsLogCell
        cell.LBL_discription.text = data_array[indexPath.row]["type"] as? String ?? "No Type AVailable."
        cell.LBL_date.text = self.GetDate(date: data_array[indexPath.row]["created_at"] as? String ?? "2018-03-08 10:38:47")
        if let points = data_array[indexPath.row]["points"] as? NSNumber {
             cell.Lbl_points.text = "+\(points.intValue) pts"
        }else{
             cell.Lbl_points.text = "0 pts"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func StoreMsgCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "StoreMsgCell") as! StoreMsgCell
        
        cell.selectionStyle = .none
        return cell
    }
    func HbStoreItemsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "HbStoreItemsCell") as! HbStoreItemsCell
        cell.products_array = self.products_array
        cell.baseView = self
        let total_proudcts_count : Int = self.products_array.count
        if(total_proudcts_count % 2 == 0){
            cell.Constraint_collection_view_height.constant = CGFloat((total_proudcts_count/2) * 224)
        }else{
                cell.Constraint_collection_view_height.constant = CGFloat(((total_proudcts_count/2)+1) * 224)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func LoadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell   =  tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as! LoadingCell
        cell.loading.startAnimating()
        cell.selectionStyle = .none
        return cell
    }
    
}


extension MyRewardsVC : TabClickListner{
    func OnClickFreePointsTab(index: Int) {
        self.View_Menu_Redeem.isHidden = false
        self.View_Menu_mypoints.isHidden = true
        self.menuView.isHidden = false
        self.menuBarHeight.constant = 52
        self.FreePointsTab()
    }
    
    func OnClickPointsLogTab(index: Int) {
        self.View_Menu_Redeem.isHidden = false
        self.View_Menu_mypoints.isHidden = true
        self.menuView.isHidden = false
        self.menuBarHeight.constant = 52
        self.PointsLogTab()
    }
    
    func OnClickHbStoreTab(index: Int) {
        self.HBStoreTab()
        self.View_Menu_Redeem.isHidden = true
        self.View_Menu_mypoints.isHidden = false
        self.menuView.isHidden = true
        self.menuBarHeight.constant = 0
    }
    
    
    @IBAction func Radeem(sender : UIButton){
//        RewardsTabCell
        let cellsecond = self.tbl_rewards.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! RewardsTabCell
        cellsecond.OnClickHBStore(UIButton.init())
        
        
    }
    
}

class RewardProductCell : UITableViewCell {
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var lblNAme : UILabel!
    @IBOutlet var lblPoints : UILabel!
    @IBOutlet weak var lbRedeemdate: UILabel!
    
}

class LabelRewardCell : UITableViewCell {
    
}
