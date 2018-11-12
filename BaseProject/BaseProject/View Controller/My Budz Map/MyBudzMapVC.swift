//
//  MyBudzMapVC.swift
//  BaseProject
//
//  Created by MAC MINI on 01/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class MyBudzMapVC: BaseViewController {
@IBOutlet weak var tableView_myBudzMap: UITableView!
    var refreshControl: UIRefreshControl!
    var bud_map_list = [BudzMap]()
    var pending_budz_map = [BudzMap]()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_myBudzMap.addSubview(refreshControl)
        self.RegisterXib()
        // Do any additional setup after loading the view.
    }
    
    
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.GetMyBudz()
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.tabBarController?.tabBar.isHidden = true
        
        self.GetMyBudz()
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    func GetMyBudz(){
        self.showLoading()
       self.bud_map_list.removeAll()
        let urlMain = WebServiceName.my_get_budz_map.rawValue + "?lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    self.bud_map_list.removeAll()
                    self.pending_budz_map.removeAll()
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                     for indexObj in mainData {
                        let bud_map = BudzMap.init(json: indexObj as [String : AnyObject])
                        if bud_map.business_type_id != "0"{
                            self.bud_map_list.append(bud_map)
                        }else{
                            self.pending_budz_map.append(bud_map)
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
            
            
            if self.bud_map_list.count == 0
            {
                self.tableView_myBudzMap.setEmptyMessage()
            }else {
                self.tableView_myBudzMap.restore()
            }
            
            
            self.tableView_myBudzMap.reloadData()
        }
    }
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension MyBudzMapVC:UITableViewDelegate,UITableViewDataSource{
    
    func RegisterXib(){
        self.tableView_myBudzMap.register(UINib(nibName: "BudzMapCell", bundle: nil), forCellReuseIdentifier: "BudzMapCell")
//        self.tableView_myBudzMap.register(UINib(nibName: "MyBudzMapFeaturedCell", bundle: nil), forCellReuseIdentifier: "MyBudzMapFeaturedCell")

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.pending_budz_map.count > 0 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pending_budz_map.count > 0 {
            if section == 0{
                return self.pending_budz_map.count
            }else{
                return bud_map_list.count
            }
        }else{
           return bud_map_list.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.pending_budz_map.count == 0 {
            return nil
        }else{
            var section_data = ""
            if section == 0{
                section_data =  " Pending"
            }else{
                section_data = " My Listing"
            }
            let header_lbl: UILabel    =  UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView_myBudzMap.bounds.size.width, height: 26))
            header_lbl.text            =   section_data
            header_lbl.textColor       =   UIColor.init(hex: "932A88")
            header_lbl.backgroundColor =  UIColor.init(hex: "252525")
            header_lbl.textAlignment   = .left
            header_lbl.font = UIFont (name: "lato-bold", size: 17)
            return header_lbl
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.pending_budz_map.count == 0 {
            return 0
        }
        return 46
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return MainCell(tableView  ,cellForRowAt:indexPath)        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.section != 0  || self.pending_budz_map.count  == 0 {
            let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
            viewPush.chooseBudzMap = self.bud_map_list[indexPath.row]
            viewPush.isFromMyBudzMap = true
            self.navigationController?.pushViewController(viewPush, animated: true)
        }
        
    }
    
    //MARK: mySaveCell
    
    func MainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            if self.pending_budz_map.count > 0 {
                let cell:BudzMapCell = (tableView.dequeueReusableCell(withIdentifier: "BudzMapCell") as?
                    BudzMapCell)!
                cell.btnDelete.tag = indexPath.row
                cell.btnEdit.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnEdit.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(self.onClickPendignDelete(sender:)), for: .touchUpInside)
                cell.view_BG.backgroundColor = UIColor.init(hex: "252525")
                cell.view_featured.isHidden = false
                cell.view_DottedLine.isHidden = false
                cell.lblName.text = ""
                cell.lblType.text =  ""
                cell.tag = indexPath.section
                cell.btnEdit.addTarget(self , action: #selector(self.EditPendingActionList(sender:)), for: .touchUpInside)
                cell.imgviewType.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
                cell.imgviewUser.image =  #imageLiteral(resourceName: "leafCirclePink")
                cell.imgviewDelivery.isHidden = true
                cell.imgviewOrganic.isHidden = true
                cell.lblreview.text = "0 reviews"
                cell.lblDistance.text = "0 mi"
                cell.imgviewStar1.image = #imageLiteral(resourceName: "starUnfilled")
                cell.imgviewStar2.image = #imageLiteral(resourceName: "starUnfilled")
                cell.imgviewStar3.image = #imageLiteral(resourceName: "starUnfilled")
                cell.imgviewStar4.image = #imageLiteral(resourceName: "starUnfilled")
                cell.imgviewStar5.image = #imageLiteral(resourceName: "starUnfilled")
                cell.imgviewUser.CornerRadious()
                cell.view_featured.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
                cell.selectionStyle = .none
                return cell
            }else{
                 return myBudzMapCell(tableView: tableView,indexPath: indexPath)
            }
        }else {
            return myBudzMapCell(tableView: tableView,indexPath: indexPath)
            
        }
        
    }
    
    func myBudzMapCell(tableView: UITableView ,indexPath : IndexPath) -> UITableViewCell {
        let cell:BudzMapCell = (tableView.dequeueReusableCell(withIdentifier: "BudzMapCell") as?
            BudzMapCell)!
        
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.DeleteAction), for: .touchUpInside)
        cell.tag = indexPath.section
        cell.btnEdit.removeTarget(nil, action: nil, for: .allEvents)
        cell.btnEdit.addTarget(self, action: #selector(self.EditAction(sender:)), for: .touchUpInside)
        cell.ShowDeleteOptions(value: false)
        cell.lblName.text = self.bud_map_list[indexPath.row].title
        cell.lblDistance.text = String(self.bud_map_list[indexPath.row].distance) + " mi"
        cell.lblreview.text = String(self.bud_map_list[indexPath.row].reviews.count) + " reviews"
        cell.lblType.text = self.bud_map_list[indexPath.row].budzMapType.title
        if self.bud_map_list[indexPath.row].is_organic == "0" {
            cell.imgviewOrganic.isHidden = true
        }else {
            cell.imgviewOrganic.isHidden = false
        }
        
        if self.bud_map_list[indexPath.row].is_delivery == "0" {
            cell.imgviewDelivery.isHidden = true
        }else {
            cell.imgviewDelivery.isHidden = false
        }
        
        switch Int(self.bud_map_list[indexPath.row].business_type_id)! {
        case 1 ,2:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
            break
            
        case 3:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
            break
        case 4:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
            break
        case 5:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Event.rawValue)
            break
        case 6:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 7:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 9:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Others.rawValue)
            break
        default:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        }
        
        cell.imgviewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        if Double(self.bud_map_list[indexPath.row].rating_sum)! < 1 {
            if Double(self.bud_map_list[indexPath.row].rating_sum)! >= 0.1 {
                     cell.imgviewStar1.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(self.bud_map_list[indexPath.row].rating_sum)! < 2 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.bud_map_list[indexPath.row].rating_sum)! >= 1.1 {
                cell.imgviewStar2.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(self.bud_map_list[indexPath.row].rating_sum)! < 3 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.bud_map_list[indexPath.row].rating_sum)! >= 2.1 {
                cell.imgviewStar3.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(self.bud_map_list[indexPath.row].rating_sum)! < 4 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.bud_map_list[indexPath.row].rating_sum)! >= 3.1 {
                cell.imgviewStar4.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(self.bud_map_list[indexPath.row].rating_sum)! < 5 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.bud_map_list[indexPath.row].rating_sum)! >= 4.1 {
                cell.imgviewStar5.image = #imageLiteral(resourceName: "half_star")
            }
        }else {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        if self.bud_map_list[indexPath.row].is_featured == 1 {
            cell.view_BG.backgroundColor = UIColor.black
            cell.view_featured.isHidden = false
            cell.view_DottedLine.isHidden = false
        }
        else{
            cell.view_BG.backgroundColor = UIColor.init(red: (35/255), green: (35/255), blue: (35/255), alpha: 1.0)
            cell.view_featured.isHidden = true
            cell.view_DottedLine.isHidden = true
        }
        
        cell.imgviewUser.image = #imageLiteral(resourceName: "leafCirclePink")
        print(WebServiceName.images_baseurl.rawValue + self.bud_map_list[indexPath.row].logo.RemoveSpace())
        cell.imgviewUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.bud_map_list[indexPath.row].logo.RemoveSpace()), placeholderImage:  #imageLiteral(resourceName: "leafCirclePink")) { (image, error, chaceh, url) in
            print(url as Any )
            print(error as Any)
        }
        cell.imgviewType.RoundView()
        cell.imgviewUser.CornerRadious()
        cell.view_featured.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.selectionStyle = .none
        return cell
    }

    
    func DeleteAction(sender : UIButton){
        
        self.deleteCustomeAlert(title: "Are you sure?", discription: "Are you sure you want to delete this budz adz?") { (isBtnClicked, btnNum) in
            if isBtnClicked{
                self.showLoading()
                var newApram  = [String : AnyObject]()
                newApram["sub_user_id"] = String(self.bud_map_list[sender.tag].id) as AnyObject
                print(newApram)
                NetworkManager.PostCall(UrlAPI: WebServiceName.delete_sub_user.rawValue, params: newApram)  { (successResponse, messageResponse, MainResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (MainResponse["status"] as! String) == "success" {
                            self.bud_map_list.remove(at: sender.tag)
                        }else {
                            if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                                DataManager.sharedInstance.logoutUser()
                                self.ShowLogoutAlert()
                            }else{
                                if let msg = MainResponse["errorMessage"] as? String{
                                    self.ShowErrorAlert(message:msg)
                                }else{
                                    self.ShowErrorAlert(message:"Server Error!")
                                }
                                
                            }
                        }
                    }else {
                        self.ShowErrorAlert(message:messageResponse)
                    }
                    self.tableView_myBudzMap.reloadData()
                }
            }
        }

    }
    
    func onClickPendignDelete(sender : UIButton){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "Are you sure you want to delete this budz adz?") { (isBtnClicked, btnNum) in
            if isBtnClicked{
                self.showLoading()
                var newApram  = [String : AnyObject]()
                newApram["sub_user_id"] = String(self.bud_map_list[sender.tag].id) as AnyObject
                print(newApram)
                NetworkManager.PostCall(UrlAPI: WebServiceName.delete_sub_user.rawValue, params: newApram)  { (successResponse, messageResponse, MainResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (MainResponse["status"] as! String) == "success" {
                            self.bud_map_list.remove(at: sender.tag)
                        }else {
                            if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                                DataManager.sharedInstance.logoutUser()
                                self.ShowLogoutAlert()
                            }else{
                                if let msg = MainResponse["errorMessage"] as? String{
                                    self.ShowErrorAlert(message:msg)
                                }else{
                                    self.ShowErrorAlert(message:"Server Error!")
                                }
                                
                            }
                        }
                    }else {
                        self.ShowErrorAlert(message:messageResponse)
                    }
                    self.tableView_myBudzMap.reloadData()
                }
            }
        }

    }
    func EditAction(sender : UIButton){
        let new_vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBudzMapViewController") as! NewBudzMapViewController
        new_vc.isSubscribed = false
        new_vc.chooseBudzMap = self.bud_map_list[sender.tag]
        self.navigationController?.pushViewController(new_vc, animated: false)
    }
    
    func EditPendingActionList(sender : UIButton){
        let new_vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBudzMapViewController") as! NewBudzMapViewController
        if self.pending_budz_map.count > 0 && sender.tag < self.pending_budz_map.count{
        new_vc.isSubscribed = true
        new_vc.sub_user_id = "\(self.pending_budz_map[sender.tag].id)"
        new_vc.chooseBudzMap = self.pending_budz_map[sender.tag]
        self.navigationController?.pushViewController(new_vc, animated: false)
        }
    }
    

    
}
class myBudzMapCell :UITableViewCell{
    
}
