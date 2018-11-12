//
//  businessListingSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class businessListingSettingsVC: BaseViewController {

    @IBOutlet weak var tableView_businessListing: UITableView!
    var bud_map_list = [BudzMap]()
    var isAPICallExicute : Bool = false
    var mainArray =  [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.ReloadData()
        self.GetMyBudz()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
         self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    func GetMyBudz(){
        self.showLoading()
        let urlMain = WebServiceName.my_feature_budz_map.rawValue + "?page_no=0" + "&time_zone=+05:00&skip=0&lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        NetworkManager.GetCall(UrlAPI:urlMain ) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if successResponse {
                self.isAPICallExicute = true
                self.bud_map_list.removeAll()
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
//                        if indexObj["business_type_id"] as? 
                        self.bud_map_list.append(BudzMap.init(json: indexObj as [String : AnyObject] ))
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
            self.ReloadData()
        }
    }
    
    
}
extension businessListingSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
//        self.mainArray.append(["type" : businessListingSettings.titleCell.rawValue])
//        self.mainArray.append(["type" : businessListingSettings.amountCell.rawValue])
//        self.mainArray.append(["type" : businessListingSettings.amountCell.rawValue])
//        self.mainArray.append(["type" : businessListingSettings.amountCell.rawValue])
//        self.mainArray.append(["type" : businessListingSettings.titleCell.rawValue])
        var indexMain = 0
        for _ in self.bud_map_list {
            self.mainArray.append(["type" : businessListingSettings.mybusinessCell.rawValue , "index" : indexMain])
            indexMain = indexMain + 1
        }
        if isAPICallExicute{
            if self.bud_map_list.count == 0
            {
                self.tableView_businessListing.setEmptyMessage()
            }else {
                self.tableView_businessListing.restore()
            }
        }
        self.tableView_businessListing.reloadData()
    }
    
    func RegisterXib(){
        self.tableView_businessListing.register(UINib(nibName: "titleCell", bundle: nil), forCellReuseIdentifier: "titleCell")
       self.tableView_businessListing.register(UINib(nibName: "premiumCell", bundle: nil), forCellReuseIdentifier: "premiumCell")
        self.tableView_businessListing.register(UINib(nibName: "nextBillingCell", bundle: nil), forCellReuseIdentifier: "nextBillingCell")
        self.tableView_businessListing.register(UINib(nibName: "amountCell", bundle: nil), forCellReuseIdentifier: "amountCell")
        self.tableView_businessListing.register(UINib(nibName: "businessCell", bundle: nil), forCellReuseIdentifier: "businessCell")
        self.tableView_businessListing.register(UINib(nibName: "BussinessTabCell", bundle: nil), forCellReuseIdentifier: "BussinessTabCell")
        
        
        

        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        print(indexPath.row)
        print(self.mainArray.count)
        let DataElement = self.mainArray[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BussinessTabCell") as? BussinessTabCell
            cell?.selectionStyle = .none
            return cell!
        }else{
            let dataType = DataElement["type"] as! String
            switch dataType {
            case businessListingSettings.titleCell.rawValue:
                return titleCell(tableView:tableView  ,cellForRowAt:indexPath)
            case businessListingSettings.amountCell.rawValue:
                return amountCell(tableView:tableView  ,cellForRowAt:indexPath)
            case businessListingSettings.mybusinessCell.rawValue:
                return businessCell(tableView:tableView  ,cellForRowAt:indexPath)
            default:
                return titleCell(tableView:tableView  ,cellForRowAt:indexPath)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        if indexPath.row > 4 {
            let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
            viewPush.chooseBudzMap = self.bud_map_list[indexPath.row - 5]
            self.navigationController?.pushViewController(viewPush, animated: true)
        }
    }
    
    //MARK: settingCell1
    func titleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as? titleCell
        if indexPath.row == 4 {
            cell?.Lbl_main.text = "My Businesses"
        }
        else{
            cell?.Lbl_main.text = "Your Subscriptions" 
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    func amountCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell") as? amountCell
       
        
        if indexPath.row == 1 {
            cell?.lblPlanName.text = "Monthly"
            cell?.lblPlanDescription.text = "Membership fees are billed at the beginning of each period and may take a few days after the billing date to appear on your account."
            cell?.lblPlanPrice.text = "$29.95 /per m"
            
        }else  if indexPath.row == 2  {
            cell?.lblPlanName.text = "3 Months"
            cell?.lblPlanDescription.text = "Membership fees are billed at the beginning of each period and may take a few days after the billing date to appear on your account."
            cell?.lblPlanPrice.text = "$19.95 /per m"
            
        }else {
            cell?.lblPlanName.text = "Annually"
            cell?.lblPlanDescription.text = "Membership fees are billed at the beginning of each period and may take a few days after the billing date to appear on your account."
            cell?.lblPlanPrice.text = "$15.95 /per m"
            
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    func businessCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:businessCell = (tableView.dequeueReusableCell(withIdentifier: "businessCell") as?
            businessCell)!
        
        
        let indexMain = (self.mainArray[indexPath.row])["index"] as! Int
        
        
        cell.lblName.text = self.bud_map_list[indexMain].title
        cell.lblDistance.text = String(self.bud_map_list[indexMain].distance)  + " mi"
        cell.lblreview.text = String(self.bud_map_list[indexMain].reviews.count) + " Reviews"
        cell.lblType.text = self.bud_map_list[indexMain].budzMapType.title
        if self.bud_map_list[indexMain].is_organic == "0" {
            cell.imgviewOrganic.isHidden = true
        }else {
            cell.imgviewOrganic.isHidden = false
        }
        
        if self.bud_map_list[indexMain].is_delivery == "0" {
            cell.imgviewDelivery.isHidden = true
        }else {
            cell.imgviewDelivery.isHidden = false
        }
        
        switch Int(self.bud_map_list[indexMain].business_type_id)! {
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
        
        cell.lblPlanName.text = self.bud_map_list[indexMain].textNamePlan
        cell.imgviewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        if Double(self.bud_map_list[indexMain].rating_sum)! < 1 {
            
        }else if Double(self.bud_map_list[indexMain].rating_sum)! < 2 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(self.bud_map_list[indexMain].rating_sum)! < 3 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(self.bud_map_list[indexMain].rating_sum)! < 4 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
        }else if Double(self.bud_map_list[indexMain].rating_sum)! < 5 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
        }else {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        if self.bud_map_list[indexMain].is_featured == 1 {
//            cell.view_BG.backgroundColor = UIColor.black
            cell.view_featured.isHidden = false
            cell.view_DottedLine.isHidden = false
            cell.lblPremium.isHidden = false
        }
        else{
            cell.view_BG.backgroundColor = UIColor.init(red: (35/255), green: (35/255), blue: (35/255), alpha: 1.0)
            cell.view_featured.isHidden = true
            cell.view_DottedLine.isHidden = true
            cell.lblPremium.isHidden = true
        }
        
        cell.imgviewUser.moa.url = WebServiceName.images_baseurl.rawValue + self.bud_map_list[indexMain].logo.RemoveSpace()
        if self.bud_map_list[indexMain].isCancled {
            cell.lbl_endTime.text = "Ends at: " + self.bud_map_list[indexMain].endTime.GetDateWith(formate: "MM.dd.yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
        }else {
            cell.lbl_endTime.text = "CANCEL"
        }
        cell.btnCancled.tag = indexMain
        cell.btnCancled.addTarget(self, action: #selector(self.callCancelMembership), for: .touchUpInside)
        cell.imgviewType.RoundView()
        cell.imgviewUser.RoundView()
        
        cell.view_featured.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.selectionStyle = .none
        return cell
    }
    @objc func callCancelMembership(sender : UIButton) {
        if (self.bud_map_list[sender.tag].isCancled){
            
        }else {
            
            self.deleteCustomeAlert(title: "Cancel Membership", discription: "Are you sure you want to cancel this membership?", btnTitle1: "Ok", btnTitle2: "Cancel") { (isCom, btn) in
                if isCom {
                    self.showLoading()
                    var UrlLink = WebServiceName.delete_subscription.rawValue + String(self.bud_map_list[sender.tag].id)
                    NetworkManager.GetCall(UrlAPI: UrlLink.RemoveSpace() ) { (success, message, response) in
                        self.hideLoading()
                        if success {
                            self.GetMyBudz()
                        }
                    }
                }else {
                    
                }
            }
           
        }
    }
    func updateAction(sender : UIButton){
        
    }
    
    @IBAction func GoBAck(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoHOme(sender : UIButton){
        self.GotoHome()
    }
    
    
    
}
class titleCell :UITableViewCell{
    @IBOutlet weak var Lbl_main: UILabel!
    
}
class premiumCell :UITableViewCell{
    
}
class nextBillingCell :UITableViewCell{
    
}
class amountCell :UITableViewCell{
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    @IBOutlet weak var lblPlanDescription: UILabel!
    
    
}
class businessCell :UITableViewCell{
    
    @IBOutlet weak var view_featured: UIView!
    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var view_DottedLine: UIView!
    @IBOutlet weak var lbl_endTime: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblreview: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var btnCancled: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var imgviewType: UIImageView!
    @IBOutlet weak var imgviewDelivery: UIImageView!
    @IBOutlet weak var imgviewOrganic: UIImageView!
    
    @IBOutlet weak var imgviewStar1: UIImageView!
    @IBOutlet weak var imgviewStar2: UIImageView!
    @IBOutlet weak var imgviewStar3: UIImageView!
    @IBOutlet weak var imgviewStar4: UIImageView!
    @IBOutlet weak var imgviewStar5: UIImageView!
    
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
}
