//
//  MyMessageVC.swift
//  BaseProject
//
//  Created by MAC MINI on 01/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActionCell
class MyMessageVC: BaseViewController {
    @IBOutlet weak var btn_budz_bak: UIButton!
    @IBOutlet weak var view_addnewmessage: UIView!
    @IBOutlet weak var lbl_bussinessTitle: UILabel!
    @IBOutlet weak var bussiness_back_view_hight: NSLayoutConstraint!
    @IBOutlet weak var indicator_businessMessages: UIView!
    @IBOutlet weak var indicator_myMessages: UIView!
    @IBOutlet weak var Header_Title: UILabel!
    @IBOutlet weak var search_tf_view: RoundView!
    @IBOutlet weak var Search_TF: UITextField!
    @IBOutlet weak var img_search_icon: UIImageView!
    @IBOutlet weak var tableView_myMessages: UITableView!
    var refreshControl: UIRefreshControl!
    var msg_list = [Message]()
    var main_msg_list = [Message]()
    var business_user_msg_list = [Message]()
    var main_business_user_msg_list = [Message]()
    var business_msg_list  = [[String : Any]]()
    var main_business_msg_list  = [[String : Any]]()
    var is_bussiness_loaded  = false
    var isMyMessagesClick : Bool = true
    var isBussinessChatClick = false
    var businex_chat_clicked_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.Search_TF.delegate = self
        self.tableView.becomeFirstResponder()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_myMessages.addSubview(refreshControl)
        
    }

    
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.isMyMessagesClick{
                 self.APICALL()
            }else if self.isBussinessChatClick{
                self.APICALL_GetBussinessUserChat(id: self.businex_chat_clicked_id)
            }else{
                self.APICALL_GetBussiness()
            }
           
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = true
        self.Search_TF.text  = ""
        super.viewWillAppear(true)
         self.tabBarController?.tabBar.isHidden = true
        self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
//         self.APICALL()
    if self.isMyMessagesClick{
        self.APICALL()
    }else if self.isBussinessChatClick{
        self.APICALL_GetBussinessUserChat(id: self.businex_chat_clicked_id)
    }else{
        self.APICALL_GetBussiness()
    }
    }
    
    func APICALL(){
        if !refreshControl.isRefreshing{
            self.showLoading()
        }
        self.msg_list.removeAll()
        self.main_msg_list.removeAll()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_chats.rawValue) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            self.refreshControl.endRefreshing()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        print(indexObj)
                        self.msg_list.append(Message.init(json: indexObj as [String : AnyObject] ))
                    }
                    
                    self.main_msg_list = self.msg_list
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.msg_list.count == 0 {
                self.tableView_myMessages.setEmptyMessage("No Message Found!", color: UIColor.white)
            }else{
                self.tableView_myMessages.setEmptyMessage("")
                self.tableView_myMessages.restore()
            }
            self.tableView_myMessages.reloadData()
        }
    }
    
    
    func APICALL_GetBussiness(){
        if !refreshControl.isRefreshing{
            self.showLoading()
        }
        self.business_msg_list.removeAll()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_budz_chats.rawValue) { (successResponse, messageResponse, MainResponse) in
            self.is_bussiness_loaded = true
            self.hideLoading()
            self.refreshControl.endRefreshing()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        print(indexObj)
                        self.business_msg_list.append(indexObj)
                    }
                    self.main_business_msg_list = self.business_msg_list
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.business_msg_list.count == 0 {
                self.tableView_myMessages.setEmptyMessage("No Business Message Found!", color: UIColor.white)
            }else{
                self.tableView_myMessages.setEmptyMessage("")
                self.tableView_myMessages.restore()
            }
            self.tableView_myMessages.reloadData()
        }
    }
    
    func APICALL_GetBussinessUserChat(id : String){
        if !refreshControl.isRefreshing{
            self.showLoading()
        }
        self.business_user_msg_list.removeAll()
        NetworkManager.GetCall(UrlAPI: "get_budz_chats_user/\(id)") { (successResponse, messageResponse, MainResponse) in
            self.isBussinessChatClick = true
            self.hideLoading()
            self.refreshControl.endRefreshing()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        print(indexObj)
                        self.business_user_msg_list.append(Message.init(json: indexObj as [String : AnyObject] ))
                    }
                    
                    self.main_business_user_msg_list = self.business_user_msg_list
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.business_user_msg_list.count == 0 {
                self.tableView_myMessages.setEmptyMessage("No Business Message Found!", color: UIColor.white)
            }else{
                self.tableView_myMessages.setEmptyMessage("")
                self.tableView_myMessages.restore()
            }
            self.showBusinessBack()
            self.tableView_myMessages.reloadData()
        }
    }
    
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
         self.GotoHome()
    }
    
    @IBAction func New_MSG(_ sender: Any) {
       self.PushViewWithIdentifier(name: "StartNewMsgVC")
    }
    @IBAction func onClikBusinessBack(_ sender: Any) {
        hideBusinessBack()
        self.isBussinessChatClick = false
        self.tableView_myMessages.reloadData()
    }
    
    @IBAction func onClickMyMessages(_ sender: Any) {
        self.isMyMessagesClick = true
        self.isBussinessChatClick = false
        self.indicator_myMessages.isHidden = false
        self.indicator_businessMessages.isHidden = true
        self.view_addnewmessage.isHidden = false
        self.business_msg_list =  self.main_business_msg_list
        self.tableView_myMessages.reloadData()
        self.hideBusinessBack()
        if self.msg_list.count == 0 {
            self.tableView_myMessages.setEmptyMessage("No Message Found!", color: UIColor.white)
        }else{
            self.tableView_myMessages.setEmptyMessage("")
            self.tableView_myMessages.restore()
        }
        
    }
    
    @IBAction func onClickBusinessMessages(_ sender: Any) {
        self.isMyMessagesClick = false
        self.isBussinessChatClick = false
        self.indicator_myMessages.isHidden = true
        self.indicator_businessMessages.isHidden = false
        self.view_addnewmessage.isHidden = true
        self.msg_list = self.main_msg_list
        if self.business_msg_list.count == 0 {
            self.tableView_myMessages.setEmptyMessage("No Business Message Found!", color: UIColor.white)
        }else{
            self.tableView_myMessages.setEmptyMessage("")
            self.tableView_myMessages.restore()
        }
        if is_bussiness_loaded{
            self.tableView_myMessages.reloadData()
        }else{
            self.tableView_myMessages.reloadData()
            self.APICALL_GetBussiness()
        }
        
    }
    @IBAction func onClickClearSearch(_ sender: Any) {
        if self.Search_TF.text!.count > 0 {
            self.Search_TF.text = ""
            self.Search_TF.resignFirstResponder()
            self.msg_list = self.main_msg_list
            self.business_msg_list =  self.main_business_msg_list
            self.business_user_msg_list = self.main_business_user_msg_list
            self.tableView_myMessages.reloadData()
            self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
        }
    }
    func showBusinessBack() {
        self.btn_budz_bak.isHidden = false
        self.lbl_bussinessTitle.isHidden = false
        self.bussiness_back_view_hight.constant =  46
        self.view.layoutIfNeeded()
    }
    
    func hideBusinessBack() {
        self.btn_budz_bak.isHidden = true
        self.lbl_bussinessTitle.isHidden = true
        self.bussiness_back_view_hight.constant =  0
        self.view.layoutIfNeeded()
    }
}
extension MyMessageVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        self.tableView_myMessages.register(UINib(nibName: "myMessageCell", bundle: nil), forCellReuseIdentifier: "myMessageCell")
        
        self.tableView_myMessages.register(UINib(nibName: "BudzChatCell", bundle: nil), forCellReuseIdentifier: "BudzChatCell")
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMyMessagesClick{
             return msg_list.count
        }else{
            if isBussinessChatClick{
                 return business_user_msg_list.count
            }else{
                return business_msg_list.count
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isMyMessagesClick{
            return myMessageCell(tableView:tableView  ,cellForRowAt:indexPath)
        }else{
            if isBussinessChatClick{
                 return businessMessageCell(tableView:tableView  ,cellForRowAt:indexPath)
            }else{
                return myBussinessChatCell(tableView:tableView  ,cellForRowAt:indexPath)
            }
           
        }    
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.msg_list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "DELETE") { (action, indexPath) in
            self.openDeleteAlert(text: "you want to delete this chat?"){
                if self.isMyMessagesClick{
                    self.DeleteChat(value: String(self.msg_list[indexPath.row].id))
                    self.msg_list.remove(at: indexPath.row)
                    self.main_msg_list.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }else if self.isBussinessChatClick{
                    self.DeleteBudzChatuser(id: String(self.business_user_msg_list[indexPath.row].id))
                    self.business_user_msg_list.remove(at: indexPath.row)
                    self.main_business_user_msg_list.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }else{
                    var business_chat = self.business_msg_list[indexPath.row]
                    self.DeleteBudzChat(id: String(describing: business_chat["budz_id"] as! Int))
                    self.business_msg_list.remove(at: indexPath.row)
                    self.main_business_msg_list.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } 
            }
        }
        if self.isMyMessagesClick {
            var save :UITableViewRowAction?
            if self.msg_list[indexPath.row].is_saved_count == "0" {
                save = UITableViewRowAction(style: .default, title: "SAVE") { (action, indexPath) in
                    self.openSaveAlert(text: "you want to save this chat?"){
                        if self.isMyMessagesClick{
                            self.SaveChat(value: String(self.msg_list[indexPath.row].id),saveVal: 1, inde: indexPath.row)
                            
                        }
                    }
                }
            }else {
                save = UITableViewRowAction(style: .default, title: "UN-SAVE") { (action, indexPath) in
                    self.openSaveAlert(text: "you want to un-save this chat?"){
                        if self.isMyMessagesClick{
                            self.SaveChat(value: String(self.msg_list[indexPath.row].id),saveVal: 0 , inde: indexPath.row )
                            
                        }
                    }
                }
            }
            delete.backgroundColor = UIColor.init(hex: "c14562")
            save!.backgroundColor = UIColor.init(hex: "7cc244")
            return [save!,delete]
        } else if self.isBussinessChatClick {
            var save :UITableViewRowAction?
            if self.business_user_msg_list[indexPath.row].is_saved_count == "0" {
                save = UITableViewRowAction(style: .default, title: "SAVE") { (action, indexPath) in
                    self.openSaveAlert(text: "you want to save this chat?"){
                        if self.isBussinessChatClick{
                            self.SaveChatBud(value: String(self.business_user_msg_list[indexPath.row].id),saveVal: 1, inde: indexPath.row)
                            
                        }
                    }
                }
            }else {
                save = UITableViewRowAction(style: .default, title: "UN-SAVE") { (action, indexPath) in
                    self.openSaveAlert(text: "you want to un-save this chat?"){
                        if self.isBussinessChatClick{
                            self.SaveChatBud(value: String(self.business_user_msg_list[indexPath.row].id),saveVal: 0 , inde: indexPath.row )
                            
                        }
                    }
                }
            }
            delete.backgroundColor = UIColor.init(hex: "c14562")
            save!.backgroundColor = UIColor.init(hex: "7cc244")
            return [save!,delete]
        }else {
            return [delete]
        }
        
    }
    func DeleteBudzChat(id : String){
        var newPAram = [String : AnyObject]()
        newPAram["budz_id"] = id as AnyObject
        NetworkManager.PostCall(UrlAPI: "delete_chat_budzs", params: newPAram) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
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
    
    func DeleteBudzChatuser(id : String){
        var newPAram = [String : AnyObject]()
        newPAram["chat_id"] = id as AnyObject
        NetworkManager.PostCall(UrlAPI: "delete_chat_budz", params: newPAram) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
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

    
    func DeleteChat(value : String){
        var newPAram = [String : AnyObject]()
        newPAram["chat_id"] = value as AnyObject
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_chat.rawValue, params: newPAram) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
                
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
    func SaveChat(value : String , saveVal : Int , inde : Int){
        var newPAram = [String : AnyObject]()
        newPAram["chat_id"] = value as AnyObject
        if self.msg_list[inde].receiver_id == Int((DataManager.sharedInstance.user?.ID)!){
            newPAram["other_id"] = self.msg_list[inde].sender_id as AnyObject
        }else{
            newPAram["other_id"] = self.msg_list[inde].receiver_id as AnyObject
        }
        if saveVal == 1 {
            newPAram["save"] = saveVal as AnyObject
        }
        NetworkManager.PostCall(UrlAPI: "save_chat", params: newPAram) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
                    self.msg_list[inde].is_saved_count = "\(saveVal)"
                    self.tableView_myMessages.reloadData()
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
    func SaveChatBud(value : String , saveVal : Int , inde : Int){
        var newPAram = [String : AnyObject]()
        newPAram["chat_id"] = value as AnyObject
        if self.business_user_msg_list[inde].receiver_id == Int((DataManager.sharedInstance.user?.ID)!){
            newPAram["other_id"] = self.business_user_msg_list[inde].sender_id as AnyObject
        }else{
            newPAram["other_id"] = self.business_user_msg_list[inde].receiver_id as AnyObject
        }
        if saveVal == 1 {
            newPAram["save"] = saveVal as AnyObject
        }
        NetworkManager.PostCall(UrlAPI: "save_chat_budz", params: newPAram) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
                    self.business_user_msg_list[inde].is_saved_count = "\(saveVal)"
                    self.tableView_myMessages.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMyMessagesClick{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
            vc.msg_data_modal = self.msg_list[indexPath.row]
            vc.isSelectUser = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if isBussinessChatClick{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                vc.msg_data_modal = self.business_user_msg_list[indexPath.row]
                vc.isSelectUser = false
                vc.nameOther = self.lbl_bussinessTitle.text!
                vc.chat_id = "\(self.business_user_msg_list[indexPath.row].id)"
                vc.bud_map_id = self.businex_chat_clicked_id
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                var business_chat = self.business_msg_list[indexPath.row]
                self.businex_chat_clicked_id = String(describing: business_chat["budz_id"] as! Int)
                if let budz =  business_chat["budz"] as? [String : Any]{
                    self.lbl_bussinessTitle.text = budz["title"] as? String ?? "Bester Bud"
                }
                self.APICALL_GetBussinessUserChat(id: "\(String(describing: business_chat["budz_id"] as! Int))")
            }
        }
    }
    
    //MARK: mySaveCell
    func myMessageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myMessageCell") as? myMessageCell
        cell?.selectionStyle = .none
            let msg_obg = msg_list[indexPath.row]
            cell?.MSG_date.text = self.GetTimeAgo(StringDate: msg_obg.updated_at)
            if (msg_obg.messages_count) > 0 {
                cell?.MSG_count_view.isHidden = false
                cell?.MSG_count.text = String(msg_obg.messages_count)
            }else{
                cell?.MSG_count_view.isHidden = true
            }
            
            cell?.MSG_sender_Img.image = #imageLiteral(resourceName: "placeholderMenu")
            if msg_obg.receiver_id == Int(DataManager.sharedInstance.user!.ID) {
                if msg_obg.sender_is_online_count > 0 {
                     cell?.img_msgStatus.image = #imageLiteral(resourceName: "online")
                }else{
                     cell?.img_msgStatus.image = #imageLiteral(resourceName: "offline")
                }
               
                cell?.MSG_Name.text = msg_obg.sender_first_name
                if msg_obg.sender_image_path.contains("facebook.com") ||  msg_obg.sender_image_path.contains("google.com") ||  msg_obg.sender_image_path.contains("googleusercontent.com"){
                    cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: msg_obg.sender_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }else {
                    if msg_obg.sender_image_path.characters.count > 6 {
                        cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                    }else {
                        cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_avatar.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                    }
                    
                }
                if msg_obg.sender_special_icon.characters.count > 6 {
                    cell?.MSG_sender_ImgTop.isHidden = false
                    cell?.MSG_sender_ImgTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                }else {
                    cell?.MSG_sender_ImgTop.isHidden = true
                }
                
            }else {
                if msg_obg.receiver_is_online_count > 0 {
                    cell?.img_msgStatus.image = #imageLiteral(resourceName: "online")
                }else{
                    cell?.img_msgStatus.image = #imageLiteral(resourceName: "offline")
                }
                cell?.MSG_Name.text = msg_obg.receiver_first_name
                if msg_obg.receiver_image_path.contains("facebook.com") ||  msg_obg.receiver_image_path.contains("google.com") ||  msg_obg.receiver_image_path.contains("googleusercontent.com"){
                    cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: msg_obg.receiver_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }else {
                    if msg_obg.sender_image_path.characters.count > 6 {
                       cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                    }else {
                        cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_avatar.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                    }
                }
                if msg_obg.receiver_special_icon.characters.count > 6 {
                    cell?.MSG_sender_ImgTop.isHidden = false
                    cell?.MSG_sender_ImgTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                }else {
                    cell?.MSG_sender_ImgTop.isHidden = true
                }
                
            }
        cell?.MSG_sender_Img.RoundView()
        cell?.cellActionButtonLabel?.textColor = UIColor.blue
        return cell!
    }
    func businessMessageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myMessageCell") as? myMessageCell
        cell?.selectionStyle = .none
        let msg_obg = business_user_msg_list[indexPath.row]
        cell?.MSG_date.text = self.GetTimeAgo(StringDate: msg_obg.updated_at)
        if (msg_obg.messages_count) > 0 {
            cell?.MSG_count_view.isHidden = false
            cell?.MSG_count.text = String(msg_obg.messages_count)
        }else{
            cell?.MSG_count_view.isHidden = true
        }
        
        cell?.MSG_sender_Img.image = #imageLiteral(resourceName: "placeholderMenu")
        if msg_obg.receiver_id == Int(DataManager.sharedInstance.user!.ID) {
            if msg_obg.sender_is_online_count > 0 {
                cell?.img_msgStatus.image = #imageLiteral(resourceName: "online")
            }else{
                cell?.img_msgStatus.image = #imageLiteral(resourceName: "offline")
            }
            
            cell?.MSG_Name.text = msg_obg.sender_first_name
            if msg_obg.sender_image_path.contains("facebook.com") ||  msg_obg.sender_image_path.contains("google.com") ||  msg_obg.sender_image_path.contains("googleusercontent.com"){
                cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: msg_obg.sender_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
            }else {
                if msg_obg.sender_image_path.characters.count > 6 {
                    cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }else {
                    cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_avatar.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }
            }
            if msg_obg.sender_special_icon.characters.count > 6 {
                cell?.MSG_sender_ImgTop.isHidden = false
                cell?.MSG_sender_ImgTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.sender_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
            }else {
                cell?.MSG_sender_ImgTop.isHidden = true
            }
            
            
        }else {
            if msg_obg.receiver_is_online_count > 0 {
                cell?.img_msgStatus.image = #imageLiteral(resourceName: "online")
            }else{
                cell?.img_msgStatus.image = #imageLiteral(resourceName: "offline")
            }
            cell?.MSG_Name.text = msg_obg.receiver_first_name
            if msg_obg.receiver_image_path.contains("facebook.com") ||  msg_obg.receiver_image_path.contains("google.com") ||  msg_obg.receiver_image_path.contains("googleusercontent.com"){
                cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: msg_obg.receiver_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
            }else {
                if msg_obg.receiver_image_path.characters.count > 6 {
                     cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_image_path.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }else {
                     cell?.MSG_sender_Img.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_avatar.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
                }
               
            }
            if msg_obg.receiver_special_icon.characters.count > 6 {
                cell?.MSG_sender_ImgTop.isHidden = false
                cell?.MSG_sender_ImgTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_obg.receiver_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
            }else {
                cell?.MSG_sender_ImgTop.isHidden = true
            }
            
        }
        cell?.MSG_sender_Img.RoundView()
        return cell!
    }
    //MARK: mySaveCell
    func myBussinessChatCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudzChatCell") as? BudzChatCell
        cell?.selectionStyle = .none
        var business_chat = self.business_msg_list[indexPath.row]
        cell?.imd_budz.image = #imageLiteral(resourceName: "leafCirclePink")
        cell?.indicator_unread.isHidden = true
        var type_id = 1
        if let budz =  business_chat["budz"] as? [String : Any]{
            cell?.lbl_BudzName.text = budz["title"] as? String ?? "Bester Bud"
            if let logo  = budz["logo"] as? String{
                cell?.imd_budz.sd_setImage(with: URL.init(string: logo), placeholderImage : #imageLiteral(resourceName: "leafCirclePink"),completed: nil)
            }else{
               cell?.imd_budz.image = #imageLiteral(resourceName: "leafCirclePink")
            }
            
            if let get_biz_type =  budz["get_biz_type"] as? [String : Any]{
                cell?.lbl_type_name.text = get_biz_type["title"] as? String ?? "Event"
            }
            
            type_id  =  (budz["business_type_id"] as? Int)!
        }
        if let unread =  business_chat["messages_chat_count"] as? Int{
            if unread > 0 {
                cell?.lbl_unread.text = "\(unread) Unreads"
                cell?.indicator_unread.isHidden = false
            }else{
                var tt = business_chat["member_count"] as? Int ?? 1
                if tt == 1 {
                    cell?.lbl_unread.text = "\(tt) Chat"
                    
                }else {
                    cell?.lbl_unread.text = "\(tt) Chats"
                    
                }
//                cell?.lbl_unread.text = "\(business_chat["member_count"] as? Int ?? 1) Chats"
                cell?.indicator_unread.isHidden = true
            }
        }else{
            var tt = business_chat["member_count"] as? Int ?? 1
            if tt == 1 {
                cell?.lbl_unread.text = "\(tt) Chat"
                
            }else {
                cell?.lbl_unread.text = "\(tt) Chats"
                
            }
//            cell?.lbl_unread.text = "\(business_chat["member_count"] as? Int ?? 1) Chats"
            cell?.indicator_unread.isHidden = true
        }
        
       
        switch type_id {
        case 1 ,2:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
            break
            
        case 3:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
            break
        case 4:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
            break
        case 5:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Event.rawValue)
            break
        case 6:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 7:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 9:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Others.rawValue)
            break
        default:
            cell?.img_type.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        }
        return cell!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var query:String = ""
        if string.count > 0 {
            query = textField.text! + string
        }else{
            query = textField.text!
            query.remove(at: query.index(before: query.endIndex))
            
        }
        
        if query.count > 0{
            self.img_search_icon.image = #imageLiteral(resourceName: "cross")
            if isMyMessagesClick{
                self.msg_list.removeAll()
                for msg_usr in self.main_msg_list{
                    if msg_usr.sender_first_name.contains(query) || msg_usr.receiver_first_name.contains(query){
                        self.msg_list.append(msg_usr)
                    }
                }
            }else if isBussinessChatClick{
                self.business_user_msg_list.removeAll()
                for msg_usr in self.main_business_user_msg_list{
                    if msg_usr.sender_first_name.contains(query) || msg_usr.receiver_first_name.contains(query){
                        self.business_user_msg_list.append(msg_usr)
                    }
                }
            }else{
                self.business_msg_list.removeAll()
                for obj in self.main_business_msg_list{
                    if let budz =  obj["budz"] as? [String : Any]{
                        let title  = budz["title"] as? String ?? "Bester Bud"
                        if title.contains(query){
                            self.business_msg_list.append(obj)
                        }
                    }
                }
            }
            self.tableView_myMessages.reloadData()
        }else{
            self.msg_list = self.main_msg_list
            self.business_msg_list =  self.main_business_msg_list
            self.business_user_msg_list = self.main_business_user_msg_list
            self.tableView_myMessages.reloadData()
            self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
        }
        return true
    }
    
    func TableviewCellSwipeButtonSetting(cell : UITableViewCell) {
        let wrapper = ActionCell()
        wrapper.delegate = self
        wrapper.animationStyle = .ladder_emergence
        wrapper.wrap(cell: cell,
                     actionsRight: [
                        {
                            let action  = TextAction(action: "DELETE", width: 55)
                            action.tintColor = UIColor.blue
                            return action
                        }()
            ])
    }
}
extension MyMessageVC: ActionCellDelegate {
    var tableView: UITableView! {
        return self.tableView_myMessages
    }
    
    func didActionTriggered(cell: UITableViewCell, action: String) {
        print(action)
        switch action {
        case "action_delete":
            self.openDeleteAlert(text: "you want to delete this chat?"){
            }
            break
        default:
            break
        }
    }
}
class myMessageCell :UITableViewCell{
    @IBOutlet weak var MSG_date: UILabel!
    @IBOutlet weak var MSG_count_view: CircleView!
    @IBOutlet weak var MSG_Name: UILabel!
    @IBOutlet weak var MSG_sender_Img: UIImageView!
    @IBOutlet weak var MSG_sender_ImgTop: UIImageView!
    @IBOutlet weak var MSG_count: UILabel!
    
    @IBOutlet weak var img_msgStatus: UIImageView!
}
