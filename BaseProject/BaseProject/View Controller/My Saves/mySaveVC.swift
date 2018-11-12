//
//  mySaveVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class mySaveVC: BaseViewController {

    @IBOutlet weak var tableView_Filter: UITableView!
     @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var tableView_mySave: UITableView!
    
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    
    var arrayMain = [SaveModel]()
    
    var pageNumber = 0
    
    var refreshControl: UIRefreshControl!
    var isFilterOpen = false
    var isFilterQA = "1"
    var isFilterBudzMap = "1"
    var isFilterStrain = "1"
    var isFilterSave = "1"
    var isFilterSpecial = "1"
    var isFilterChat = "1"
    var isFilterChatBudz = "1"
    var isFilterChoose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.tableView_Filter.tag = 10
        self.tableView_mySave.tag = 11
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_mySave.addSubview(refreshControl)
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.tableView_mySave.isScrollEnabled = true
                self.tableView_mySave.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                     self.tableView_mySave.alpha  = 1.0
                    self.FilterTopValue.constant = -400 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                    self.CallAPIFilter()
                })
            }
           
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFilterOpen{
                    isFilterOpen = false
                    self.tableView_mySave.isScrollEnabled = true
                    self.tableView_mySave.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tableView_mySave.alpha  = 1.0
                        self.FilterTopValue.constant = -400 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                        self.CallAPIFilter()
                    })
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.CallAPIFilter()
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
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
            self.CallAPIFilter()
            
        })
        
    }
 
    
    func GetAllSave(){
        self.showLoading()
        
        if self.pageNumber == 0 {
            self.arrayMain.removeAll()
        }
        
        NetworkManager.GetCall(UrlAPI: WebServiceName.filter_my_save.rawValue + "4,8,7,10") { (successRespons, messageResponse, dataResponse) in
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
            
            if self.arrayMain.count % 15 != 0 {
                self.pageNumber = -1
            }
            
            if self.arrayMain.count == 0
            {
                self.tableView_mySave.setEmptyMessage()
            }else {
                self.tableView_mySave.restore()
            }
            
            self.tableView_mySave.reloadData()
        }
    }
    
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    

}
extension mySaveVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
 
    
        self.tableView_mySave.register(UINib(nibName: "mySaveCell", bundle: nil), forCellReuseIdentifier: "mySaveCell")
        self.tableView_Filter.register(UINib(nibName: "mySaveFilterCell", bundle: nil), forCellReuseIdentifier: "mySaveFilterCell")

    }
    
    // MARK: - ShowFilterView
    @IBAction func ShowFilterView(sender : UIButton){
        self.isFilterChoose = true
         isFilterOpen = true
        self.tableView_mySave.isScrollEnabled = false
        self.tableView_mySave.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView_mySave.alpha  = 0.2
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let aVariable = appDelegate.isIphoneX
            if(aVariable){
                self.FilterTopValue.constant = 67 // heightCon is the IBOutlet to the constraint
            }else {
                self.FilterTopValue.constant = 57 // heightCon is the IBOutlet to the constraint
            }
           
            self.view.layoutIfNeeded()
        })
    }
    
    
    func CallAPIFilter(){
        print(self.isFilterBudzMap)
        print(self.isFilterStrain)
        print(self.isFilterQA)
        
        var newURl = ""
        
        if self.isFilterQA.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",4"
            }else {
                newURl = newURl + "4"
            }
        }
        
//        if self.isFilterStrain.characters.count > 0 {
//            if newURl.characters.count > 0 {
//                newURl = newURl + ",7"
//            }else {
//                newURl = newURl + "7"
//            }
//        }
        
        if self.isFilterBudzMap.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",8"
            }else {
                newURl = newURl + "8"
            }
        }
        if self.isFilterSave.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",10"
            }else {
                newURl = newURl + "10"
            }
        }
        if self.isFilterSpecial.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",11"
            }else {
                newURl = newURl + "11"
            }
        }
        if self.isFilterChat.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",2"
            }else {
                newURl = newURl + "2"
            }
        }
        if self.isFilterChatBudz.characters.count > 0 {
            if newURl.characters.count > 0 {
                newURl = newURl + ",13"
            }else {
                newURl = newURl + "13"
            }
        }
        
        
        if newURl.characters.count == 0 {
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
                self.tableView_mySave.setEmptyMessage()
            }else{
                 self.tableView_mySave.restore()
            }
            self.tableView_mySave.reloadData()
        }
        
        
    }
        // MARK: - HideFilter
    
    @IBAction func HideFilterView(sender : UIButton){
         isFilterOpen = false
        self.tableView_mySave.isScrollEnabled = true
        self.tableView_mySave.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView_mySave.alpha  = 1.0
            self.FilterTopValue.constant = -400 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            self.CallAPIFilter()
        })
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if self.pageNumber > -1 {
//            if self.arrayMain.count - 1 == indexPath.row {
//                self.pageNumber = self.pageNumber + 1
//                self.GetAllSave()
//            }
//        }
    }
    
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView_mySave {
             return self.arrayMain.count
        }
        else{
            return 6
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         if tableView.tag == 11 {
           return mySaveCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
         else{
             return mySaveFilterCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 11 {
            if self.arrayMain[indexPath.row].type_id == 4 {
                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                DetailQuestionVc.QuestionID = String(self.arrayMain[indexPath.row].type_sub_id)
                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
            }else if self.arrayMain[indexPath.row].type_id == 8 {
                let detailBudz = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
                detailBudz.chooseBudzMap.id = self.arrayMain[indexPath.row].type_sub_id
                self.navigationController?.pushViewController(detailBudz, animated: true)
            }else if self.arrayMain[indexPath.row].type_id == 7 {
                let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
                detailView.chooseStrain.strainID = self.arrayMain[indexPath.row].type_sub_id as NSNumber
                detailView.chooseStrain.strain_id = self.arrayMain[indexPath.row].type_sub_id as NSNumber
                detailView.chooseStrain.get_likes_count = 0 as NSNumber
                detailView.chooseStrain.get_dislikes_count = 0 as NSNumber
                self.navigationController?.pushViewController(detailView, animated: true)
            }else if self.arrayMain[indexPath.row].type_id == 10  {
                let mainStrain = self.GetView(nameViewController: "StrainsListingViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainsListingViewController
                mainStrain.searchFromSave = self.arrayMain[indexPath.row].descriptionSave.replacingOccurrences(of: "?", with: "")
                self.navigationController?.pushViewController(mainStrain, animated: true)
            }else if self.arrayMain[indexPath.row].type_id == 11  {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewPush = mainStoryboard.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                viewPush.isSpecialShown = true
                var chechValue = self.arrayMain[indexPath.row].descriptionSave
                chechValue = (chechValue.components(separatedBy: "&").first?.replacingOccurrences(of: "business_id=", with: ""))!
                print(chechValue)
                viewPush.budz_map_id = chechValue
                self.navigationController?.pushViewController(viewPush, animated: true)
                
//                let mainStrain = self.GetView(nameViewController: "StrainsListingViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainsListingViewController
//                mainStrain.searchFromSave = self.arrayMain[indexPath.row].descriptionSave
//                self.navigationController?.pushViewController(mainStrain, animated: true)
            }else if self.arrayMain[indexPath.row].type_id == 13{
                //TODO API CALL
                self.showLoading()
                var chat_msg_list = [MessageChat]()
                chat_msg_list.removeAll()
                var newPAram = [String : AnyObject]()
                    newPAram["chat_id"] = self.arrayMain[indexPath.row].type_sub_id as AnyObject
                NetworkManager.PostCall(UrlAPI: "get_budz_detail_chat",params:newPAram)  { (successResponse, messageResponse, MainResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (MainResponse["status"] as! String) == "success" {
                            let mainData = MainResponse["successData"] as! [[String : Any]]
                            let mainDataBUd = MainResponse["successMessage"] as! [String : Any]
                            for indexObj in mainData {
                                chat_msg_list.append(MessageChat.init(json: indexObj as [String : AnyObject] ))
                            }
                            let msg  = chat_msg_list.first
                            let sendMsg = Message()
                            sendMsg.receiver_id = (msg?.receiver_id)!
                            sendMsg.sender_id = msg!.sender_id
                            sendMsg.sender_avatar = msg!.sender_avatar
                            sendMsg.sender_points = msg!.sender_points
                            sendMsg.sender_first_name = msg!.sender_first_name
                            sendMsg.sender_image_path = msg!.sender_image_path
                            sendMsg.sender_special_icon = msg!.sender_special_icon
                            sendMsg.receiver_avatar = msg!.receiver_avatar
                            sendMsg.receiver_points = msg!.receiver_points
                            sendMsg.receiver_first_name = msg!.receiver_first_name
                            sendMsg.receiver_image_path = msg!.receiver_image_path
                            sendMsg.receiver_special_icon = msg!.receiver_special_icon
                            sendMsg.updated_at = msg!.updated_at
                            sendMsg.created_at = msg!.created_at
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                            vc.msg_data_modal = sendMsg
                            vc.isSelectUser = false
                            vc.nameOther = mainDataBUd["title"] as! String//self.lbl_bussinessTitle.text!
                            vc.chat_id = "\(self.arrayMain[indexPath.row].type_sub_id)"
                            if let vall = mainDataBUd["id"] as? Int {
                                vc.bud_map_id = "\(vall)"//self.businex_chat_clicked_id
                            }else if let vall = mainDataBUd["id"] as? String {
                                vc.bud_map_id = vall//self.businex_chat_clicked_id
                            }else {
                                vc.bud_map_id = "1"
                            }
                            
                            self.navigationController?.pushViewController(vc, animated: true)
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
                
            }else if self.arrayMain[indexPath.row].type_id == 2 {
                //TODO API CALL
                self.showLoading()
                 var chat_msg_list = [MessageChat]()
                chat_msg_list.removeAll()
                var newPAram = [String : AnyObject]()
                
                NetworkManager.GetCall(UrlAPI: "get_chat_detail_by_id/\(self.arrayMain[indexPath.row].type_sub_id)")  { (successResponse, messageResponse, MainResponse) in
                    self.hideLoading()
                    if successResponse {
                        if (MainResponse["status"] as! String) == "success" {
                            let mainData = MainResponse["successData"] as! [[String : Any]]
                            for indexObj in mainData {
                                chat_msg_list.append(MessageChat.init(json: indexObj as [String : AnyObject] ))
                                }
                            let msg  = chat_msg_list.first
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
                            let sendMsg = Message()
                            sendMsg.receiver_id = (msg?.receiver_id)!
                            sendMsg.sender_id = msg!.sender_id
                            sendMsg.sender_avatar = msg!.sender_avatar
                            sendMsg.sender_points = msg!.sender_points
                            sendMsg.sender_first_name = msg!.sender_first_name
                            sendMsg.sender_image_path = msg!.sender_image_path
                            sendMsg.sender_special_icon = msg!.sender_special_icon
                            sendMsg.receiver_avatar = msg!.receiver_avatar
                            sendMsg.receiver_points = msg!.receiver_points
                            sendMsg.receiver_first_name = msg!.receiver_first_name
                            sendMsg.receiver_image_path = msg!.receiver_image_path
                            sendMsg.receiver_special_icon = msg!.receiver_special_icon
                            sendMsg.updated_at = msg!.updated_at
                            sendMsg.created_at = msg!.created_at
                            vc.msg_data_modal = sendMsg
                            vc.isSelectUser = false
                            self.navigationController?.pushViewController(vc, animated: true)
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
        }else if self.arrayMain[indexPath.row].type_id == 2 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "Chat_tab_qa")
            cell?.label_title.text = "Saved Chat"  + " with " + self.arrayMain[indexPath.row].user.userFirstName
            cell?.label_title.textColor = UIColor.init(hex: "7cc244")
        }
        else if self.arrayMain[indexPath.row].type_id == 11 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "tab_map")
            cell?.label_title.text = self.arrayMain[indexPath.row].title
            cell?.label_title.textColor = UIColor.init(hex: "942b88")
        }else if self.arrayMain[indexPath.row].type_id == 13 {
            cell?.imageView_mainImage.image = #imageLiteral(resourceName: "tab_map")
            cell?.label_title.text = "Saved Business Chat" + " with " + self.arrayMain[indexPath.row].user.userFirstName
            cell?.label_title.textColor = UIColor.init(hex: "942b88")
        }
        cell?.selectionStyle = .none
        return cell!
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
                self.tableView_mySave.reloadData()
            }
        }
    }
    //MARK: mySaveFilterCell
    func mySaveFilterCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       let cell = tableView.dequeueReusableCell(withIdentifier: "mySaveFilterCell") as? mySaveFilterCell
        switch indexPath.row {
        case 0:
            cell?.imageView_mainImgae.image = UIImage(named: "Tab0")
            cell?.label_title.text = "Q&A"
        case 1:
            cell?.imageView_mainImgae.image = UIImage(named: "tab_map")
            cell?.label_title.text = "BUDZ ADZ"
//        case 2:
//            cell?.imageView_mainImgae.image = UIImage(named: "Tab3")
//            cell?.label_title.text = "STRAINS"
        case 2:
            cell?.imageView_mainImgae.image = #imageLiteral(resourceName: "save_Green")
            cell?.label_title.text = "SEARCH SAVE"
        case 3:
            cell?.imageView_mainImgae.image = #imageLiteral(resourceName: "saved")
            cell?.label_title.text = "SPECIAL SAVE"
        case 4:
            cell?.imageView_mainImgae.image = #imageLiteral(resourceName: "Chat_tab_qa")
            cell?.label_title.text = "CHAT SAVE"
        case 5:
            cell?.imageView_mainImgae.image = UIImage(named: "tab_map")
            cell?.label_title.text = "CHAT SAVE"
        default:
            break
        }
        
        cell?.switchMain.tag = indexPath.row
        cell?.switchMain.transform = CGAffineTransform(scaleX: 0.80, y: 0.75)
        cell?.switchMain.addTarget(self, action: #selector(self.switchChanged), for: UIControlEvents.valueChanged)

        
        cell?.selectionStyle = .none
        return cell!
        
    }

    func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        if mySwitch.isOn {
            if mySwitch.tag == 0 {
                isFilterQA = "1"
            }else if mySwitch.tag == 1 {
                isFilterBudzMap = "1"
            }else if mySwitch.tag == 2{
//                isFilterStrain = "1"
               
                 isFilterSave = "1"
            }else if mySwitch.tag == 3{
                isFilterSpecial = "1"
            }else if mySwitch.tag == 4{
                isFilterChat = "1"
            }else if mySwitch.tag == 5{
                isFilterChatBudz = "1"
            }else {
                isFilterSpecial = "1"
            }
            
        }else {
            if mySwitch.tag == 0 {
                isFilterQA = ""
            }else if mySwitch.tag == 1 {
                isFilterBudzMap = ""
            }else if mySwitch.tag == 2{
//                isFilterStrain = ""
                isFilterSave = ""
            }else if mySwitch.tag == 3{
                isFilterSpecial = ""
            }else if mySwitch.tag == 4{
                isFilterChat = ""
            }else if mySwitch.tag == 5{
                isFilterChatBudz = ""
            }else {
                isFilterSpecial = ""
            }
        }
        
    }
}
class mySaveCell:UITableViewCell{
    @IBOutlet weak var imageView_mainImage: UIImageView!
    @IBOutlet var label_title: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    
    
}
class mySaveFilterCell:UITableViewCell{
    @IBOutlet weak var imageView_mainImgae: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var switchMain: UISwitch!
    
    
}

extension UITableViewCell {
    var cellActionButtonLabel: UILabel? {
        for subview in self.superview?.subviews ?? [] {
            if String(describing: subview).range(of: "UISwipeActionPullView") != nil {
                for view in subview.subviews {
                    if String(describing: view).range(of: "UISwipeActionStandardButton") != nil {
                        for sub in view.subviews {
                            if let label = sub as? UILabel {
                                return label
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
}
