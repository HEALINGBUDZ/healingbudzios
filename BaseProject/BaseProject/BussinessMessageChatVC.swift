//
//  BussinessMessageChatVC.swift
//  BaseProject
//
//  Created by MAC MINI on 09/01/2018.
//  Copyright © 2018 Wave. All rights reserved.

import UIKit
import AVFoundation
import AVKit
import SwiftLinkPreview
import IQKeyboardManager
class BussinessMessageChatVC: BaseViewController, UITableViewDelegate , UITableViewDataSource ,CameraDelegate {
      var chat_msg_list = [MessageChat]()
     var isFromFeed = 0
    var bud_map_id = ""
     var chat_id = ""
    var logo = ""
    var other_id = ""
    var isImageUploadedSuccess = false
     @IBOutlet weak var viewKeyboard: UIView!
     @IBOutlet var chat_table_view: UITableView!
     @IBOutlet weak var sender_image: UIImageView!
    @IBOutlet weak var sender_imageTop: UIImageView!
     @IBOutlet weak var attached_image: UIImageView!
     @IBOutlet weak var sender_name: UILabel!
     @IBOutlet weak var msg_text_field: UITextField!
     @IBOutlet weak var attachment_view: UIView!
    var nameOther = ""
     @IBOutlet weak var attachment_view_width_constraint: NSLayoutConstraint!
     var is_Media_attached = 0
     var msg_data_modal = Message()
     var selectUser = User()
     var isSelectUser = false
     var array_Attachment = [Attachment]()
    //Url Scrapping
    private var result = SwiftLinkPreview.Response()
    private let slp = SwiftLinkPreview(cache: InMemoryCache())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName = (DataManager.sharedInstance.getPermanentlySavedUser()?.userFirstName)!
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        msg_text_field.autocorrectionType = .yes
        OtherUserName = self.nameOther
        self.sender_name.text = OtherUserName
         self.sender_image.image = #imageLiteral(resourceName: "leafCirclePink")
        if(self.logo.count > 0){
            self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + self.logo.RemoveSpace()
        }else {
            self.sender_image.image = #imageLiteral(resourceName: "leafCirclePink")
        }
        self.msg_text_field.delegate = self
        if self.isSelectUser {
//            self.sender_name.text = selectUser.userFirstName
//            OtherUserName = self.sender_name.text!
            if selectUser.profilePictureURL.contains("facebook.com") || selectUser.profilePictureURL.contains("google.com"){
//                self.sender_image.moa.url =  selectUser.profilePictureURL.RemoveSpace()
            }else{
//                self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + selectUser.profilePictureURL.RemoveSpace()
            }
            if selectUser.special_icon.characters.count > 6 {
                self.sender_imageTop.isHidden = true
                self.sender_imageTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + selectUser.special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
            }else {
                self.sender_imageTop.isHidden = true
            }
        }else {
            if msg_data_modal.sender_id == Int((DataManager.sharedInstance.user?.ID)!)! {
//                self.sender_name.text = msg_data_modal.receiver_first_name
//                 OtherUserName = self.sender_name.text!
                if msg_data_modal.receiver_image_path.contains("facebook.com") || msg_data_modal.receiver_image_path.contains("google.com"){
//                    self.sender_image.moa.url =  msg_data_modal.receiver_image_path.RemoveSpace()
                }else{
//                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + msg_data_modal.receiver_image_path.RemoveSpace()
                }
                if msg_data_modal.receiver_special_icon.characters.count > 6 {
                    self.sender_imageTop.isHidden = true
                    self.sender_imageTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_data_modal.receiver_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                }else {
                    self.sender_imageTop.isHidden = true
                }
            }else {
//                self.sender_name.text = msg_data_modal.sender_first_name
                 OtherUserName = self.sender_name.text!
                if msg_data_modal.sender_image_path.contains("facebook.com") || msg_data_modal.sender_image_path.contains("google.com"){
//                    self.sender_image.moa.url =  msg_data_modal.sender_image_path.RemoveSpace()
                }else{
//                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + msg_data_modal.sender_image_path.RemoveSpace()
                }
                if msg_data_modal.sender_special_icon.characters.count > 6 {
                    self.sender_imageTop.isHidden = true
                    self.sender_imageTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + msg_data_modal.sender_special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                }else {
                    self.sender_imageTop.isHidden = true
                }
                
            }
            
        }

        self.sender_image.RoundView()
        self.chat_table_view.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.attachment_view.isHidden = true
        self.attachment_view_width_constraint.constant = 0
        self.RegisterXib()
        IOSocketBudz.sharedInstance.Get { (data) in
            print(data)
            print(DataManager.sharedInstance.user!.ID)
            if data.first!["user_id"] != nil {
                var Id = 0
                if let vlv = data.first!["user_id"] as? Int {
                    Id = vlv
                }else if let vlv = data.first!["user_id"] as? String  {
                    Id = Int(vlv)!
                }
                if Id == Int(DataManager.sharedInstance.user!.ID)
                    &&  (data.first!["budz_id"] as! String) == self.bud_map_id {
                    
                    let newMeesage = MessageChat()
                    newMeesage.created_at = self.GetTodaydateWithFullFormat()
//                    newMeesage.receiver_id = (data.first!["user_id"] as? Int ?? 0)
                    if let other_id  = data.first!["other_id"] as? Int{
                         newMeesage.sender_id = other_id
                    }else if let other_id  = data.first!["other_id"] as? String{
                        newMeesage.sender_id = Int(other_id)!
                    }
                    if let other_id  = data.first!["user_id"] as? Int{
                        newMeesage.receiver_id = other_id
                    }else if let other_id  = data.first!["user_id"] as? String{
                        newMeesage.receiver_id = Int(other_id)!
                    }
                    if let text  = data.first!["text"] as? String{
                         newMeesage.message = text
                    }
                   
                    if let file_type = data.first!["file_type"] as? String{
                        newMeesage.file_type = file_type
                    }
                    
                    
                   
                    if newMeesage.file_type == "image"{
                        newMeesage.file_path = (data.first!["file"] as? String ?? "")
                    }else{
                         newMeesage.VideoUrl = (data.first!["file"] as? String ?? "")
                         newMeesage.file_path = (data.first!["file_poster"] as? String ?? "")
                    }
                    self.chat_msg_list.insert(newMeesage, at: 0)
                    self.chat_table_view.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    self.chat_table_view.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.chat_table_view.reloadData()
                    }
                }
            }
        }
     
        
        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if self.isRefreshonWillAppear {
            if self.isSelectUser {
                 self.APICall()
            }else {
                self.APICall()
            }
            
        }
        self.isRefreshonWillAppear = false
    }

    func APICall(){
        self.showLoading()
        self.chat_msg_list.removeAll()
        var newPAram = [String : AnyObject]()
        var url = ""
        if other_id.isEmpty{
            newPAram["chat_id"] = self.chat_id as AnyObject
            url = "get_budz_detail_chat"
        }else{
            url = "get_budz_chat_detail"
            newPAram["other_id"] = self.other_id as AnyObject
            newPAram["budz_id"] = self.bud_map_id as AnyObject
        }
       
        NetworkManager.PostCall(UrlAPI: url, params: newPAram)  { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            print(successResponse)
            print(messageResponse)
            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        self.chat_msg_list.append(MessageChat.init(json: indexObj as [String : AnyObject] ))
                        
                    }
                    self.chat_msg_list.reverse()
                    if (self.chat_msg_list.count>0) {
                       self.isFromFeed = 0
                    if self.isFromFeed == 1 {
                        self.isFromFeed = 0
                        if (self.chat_msg_list.count>0){
                            let msg  = self.chat_msg_list.first
                            if(msg?.sender_id == self.msg_data_modal.sender_id){
                                self.msg_data_modal.sender_avatar = (msg?.sender_avatar)!
                                self.msg_data_modal.receiver_first_name = (msg?.receiver_first_name)!
                                self.msg_data_modal.sender_first_name = (msg?.sender_first_name)!
                                
                                self.msg_data_modal.sender_image_path = (msg?.sender_image_path)!
                                if self.msg_data_modal.sender_image_path.contains("facebook.com") || self.msg_data_modal.sender_image_path.contains("google.com"){
//                                    self.sender_image.moa.url =  self.msg_data_modal.sender_image_path.RemoveSpace()
                                }else{
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + self.msg_data_modal.sender_image_path.RemoveSpace()
                                }
                                if( self.msg_data_modal.receiver_avatar.count > 5){
//                                       self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + self.msg_data_modal.receiver_avatar.RemoveSpace()
                                }else if (self.msg_data_modal.sender_avatar.count > 5){
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + self.msg_data_modal.sender_avatar.RemoveSpace()
                                }
                            }
                            if msg?.receiver_id == Int((DataManager.sharedInstance.user?.ID)!){
//                                self.sender_name.text = msg?.sender_first_name
//                                 OtherUserName = self.sender_name.text!
                                if (msg?.sender_image_path.contains("facebook.com"))! || (msg?.sender_image_path.contains("google.com"))!{
//                                    self.sender_image.moa.url =  (msg?.sender_image_path.RemoveSpace())!
                                }else if msg?.sender_image_path != "" && (msg?.sender_image_path.count)! > 5{
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + (msg?.sender_image_path.RemoveSpace())!
                                }else{
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + (msg?.sender_avatar.RemoveSpace())!
                                }
                                if (msg?.receiver_special_icon.characters.count)! > 6 {
                                    self.sender_imageTop.isHidden = true
                                    self.sender_imageTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (msg?.receiver_special_icon.RemoveSpace())!),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                                }else {
                                    self.sender_imageTop.isHidden = true
                                }
                            }else {
//                                self.sender_name.text = msg?.receiver_first_name
//                                 OtherUserName = self.sender_name.text!
                                if (msg?.receiver_image_path.contains("facebook.com"))! || (msg?.receiver_image_path.contains("google.com"))!{
//                                    self.sender_image.moa.url =  (msg?.receiver_image_path.RemoveSpace())!
                                }else  if msg?.receiver_image_path != "" && (msg?.receiver_image_path.count)! > 5{
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + (msg?.receiver_image_path.RemoveSpace())!
                                }else{
//                                    self.sender_image.moa.url = WebServiceName.images_baseurl.rawValue + (msg?.receiver_avatar.RemoveSpace())!
                                }
                                if (msg?.receiver_special_icon.characters.count)! > 6 {
                                    self.sender_imageTop.isHidden = true
                                    self.sender_imageTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (msg?.receiver_special_icon.RemoveSpace())!),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
                                }else {
                                    self.sender_imageTop.isHidden = true
                                }
                            }
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
            
            self.chat_table_view.reloadData()
            
            self.scrollToLastRow();
            if (self.chat_msg_list.count > 0 ) {
                self.chat_table_view.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
        
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.Back()
    }
    
    @IBAction func attachment_cross(_ sender: Any) {
        self.attachment_view.isHidden = true
        self.attachment_view_width_constraint.constant = 0
        is_Media_attached = 0
        
    
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        
        self.attachment_view.isHidden = false
        self.attachment_view_width_constraint.constant = 56
        is_Media_attached = 2
        self.attached_image.image = image

        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        newAttachment.video_URL = gifURL.absoluteString
        self.array_Attachment.append(newAttachment)
        
        self.attachment_view.isHidden = false
        self.attachment_view_width_constraint.constant = 56
        is_Media_attached = 1
        self.attached_image.image = image
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        
        
        self.attachment_view.isHidden = false
        self.attachment_view_width_constraint.constant = 56
        is_Media_attached = 1
        self.attached_image.image = image

        
    }
    
    @IBAction func attachment_Add(_ sender: Any) {
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        self.navigationController?.pushViewController(vcCamera, animated: true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.viewKeyboard.backgroundColor = UIColor.white
        textField.textColor = .white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.viewKeyboard.backgroundColor = UIColor.init(red: (92/255), green: (92/255), blue: (92/255), alpha: 1.0)
    }
    
    @IBAction func Sed_Msg(_ sender: Any) {
        
        isImageUploadedSuccess = false
        
        var newParam = [String : AnyObject]()
        newParam["budz_id"] = self.bud_map_id as AnyObject
        let receiver_obj = MessageChat()
        receiver_obj.created_at = self.GetTodaydateWithFullFormat()
        receiver_obj.message = self.msg_text_field.text!
        receiver_obj.sender_id = Int(DataManager.sharedInstance.user!.ID)!
        if let url = self.slp.extractURL(text: self.msg_text_field.text!){
            receiver_obj.site_url = url.absoluteString
            receiver_obj.url = url.absoluteString
            newParam["url"] =  url.absoluteString as AnyObject
            self.slp.preview(
                self.msg_text_field.text!,
                onSuccess: { result in
                    print(result)
                    self.result = result
            },
                onError: { error in
                    print(error)
            }
            )
        }
        
        
        if self.msg_text_field.text!.trimmingCharacters(in: .whitespaces).count > 0 || self.array_Attachment.count > 0 {
            if isSelectUser {
                newParam["message"] = self.msg_text_field.text! as AnyObject
                
                
                newParam["receiver_id"] = self.selectUser.ID as AnyObject
                receiver_obj.receiver_id =  Int(self.selectUser.ID)!
                    
                
            }else {
                newParam["message"] = self.msg_text_field.text! as AnyObject
                
                if(self.msg_data_modal.receiver_id == Int(DataManager.sharedInstance.user!.ID)){
                    newParam["receiver_id"] = String(self.msg_data_modal.sender_id) as AnyObject
                    
                    
                    receiver_obj.receiver_id =  self.msg_data_modal.sender_id
                    
                }else {
                    newParam["receiver_id"] = String(self.msg_data_modal.receiver_id) as AnyObject
                    receiver_obj.receiver_id =  self.msg_data_modal.receiver_id
                    
                }
            }
            
           
        }else {
            return
        }
        
        print(newParam)
        if self.is_Media_attached == 1 {
            receiver_obj.file_type = "image"
            var gifDataUrl : URL? = nil
            if let gif_url = URL.init(string: (self.array_Attachment.first?.video_URL)!){
                gifDataUrl = gif_url
            }
            receiver_obj.imageMain = (self.array_Attachment.first?.image_Attachment)!
            NetworkManager.UploadFiles(kBaseURLString + "send_budz_message", image: (self.array_Attachment.first?.image_Attachment)!, gif_url: gifDataUrl, withParams:newParam , onView: self, completion: { (MainData) in
                print(MainData)
                
                
                if (MainData["status"] as! String) == "success" {
                    let dataObj = MainData["successData"] as! [String : Any]
                    var socket_param = [String : AnyObject] ()
                    socket_param["budz_id"] = self.bud_map_id as AnyObject
                    socket_param["user_id"] =   dataObj["receiver_id"]  as AnyObject
                    socket_param["photo"] =   "" as AnyObject
                    socket_param["text"] =   dataObj["message"]  as AnyObject
                    socket_param["file"] =   dataObj["file_path"] as! String as AnyObject
                    socket_param["file_type"] =   dataObj["file_type"] as AnyObject
                    socket_param["file_poster"] =   dataObj["poster"]  as AnyObject
                    socket_param["images_base"] =   WebServiceName.images_baseurl.rawValue  as AnyObject
                    socket_param["video_base"] =   WebServiceName.videos_baseurl.rawValue  as AnyObject
                    socket_param["other_id"] =  Int((DataManager.sharedInstance.user?.ID)!)  as AnyObject
                    socket_param["other_name"] =  self.sender_name.text  as AnyObject
                    IOSocketBudz.sharedInstance.Send(withParm: socket_param) {
                        print("send data")
                        self.isImageUploadedSuccess = true
                         self.chat_table_view.reloadData()
                    }
                }
                
            })
        }else if self.is_Media_attached == 2 {
            receiver_obj.file_type = "video"
            receiver_obj.imageMain = (self.array_Attachment.first?.image_Attachment)!
            receiver_obj.VideoUrl = self.array_Attachment[0].video_URL
            NetworkManager.UploadVideo( "send_budz_message", imageMain: (self.array_Attachment.first?.image_Attachment)!, urlVideo: (URL.init(string: self.array_Attachment[0].video_URL)!), withParams: newParam, onView: self, completion: { (MainData) in
                print(MainData)
                
                if (MainData["status"] as! String) == "success" {
                    
                    let dataObj = MainData["successData"] as! [String : Any]
                    var socket_param = [String : AnyObject] ()
                    socket_param["budz_id"] = self.bud_map_id as AnyObject
                    socket_param["user_id"] =   dataObj["receiver_id"]  as AnyObject
                    socket_param["photo"] =   "" as AnyObject
                    socket_param["text"] =   dataObj["message"]  as AnyObject
                    socket_param["file"] =   dataObj["file_path"] as! String as AnyObject
                    socket_param["file_type"] =   dataObj["file_type"] as AnyObject
                    socket_param["file_poster"] =   dataObj["poster"]  as AnyObject
                    socket_param["images_base"] =   WebServiceName.images_baseurl.rawValue  as AnyObject
                    socket_param["video_base"] =   WebServiceName.videos_baseurl.rawValue  as AnyObject
                    socket_param["other_id"] =  Int((DataManager.sharedInstance.user?.ID)!)  as AnyObject
                    socket_param["other_name"] =  self.sender_name.text  as AnyObject
                                        
                    IOSocketBudz.sharedInstance.Send(withParm: socket_param) {
                        print("send data")
                        self.isImageUploadedSuccess = true
                        self.chat_table_view.reloadData()
                    }
                }
            })
        }else {
            
        
            NetworkManager.PostCall(UrlAPI:"send_budz_message", params: newParam) { (successResponse, messageResponse, MainData) in
                if successResponse {
                    let dataObj = MainData["successData"] as! [String : Any]
                   self.isFromFeed = 0
                    if self.isFromFeed == 1
                    {
                        self.APICall()
                    }
                        var socket_param = [String : AnyObject] ()
                        socket_param["budz_id"] = self.bud_map_id as AnyObject
                        socket_param["user_id"] =   dataObj["receiver_id"]  as AnyObject
                        socket_param["photo"] =   "" as AnyObject
                        socket_param["text"] =   dataObj["message"]  as AnyObject
                        socket_param["file"] =   ""  as AnyObject
                        socket_param["file_type"] =   "" as AnyObject
                        socket_param["file_poster"] =   ""  as AnyObject
                        socket_param["images_base"] =   WebServiceName.images_baseurl.rawValue  as AnyObject
                        socket_param["video_base"] =   WebServiceName.videos_baseurl.rawValue  as AnyObject
                        socket_param["other_id"] =  Int((DataManager.sharedInstance.user?.ID)!)  as AnyObject
                        socket_param["other_name"] =  self.sender_name.text  as AnyObject
                
                    
                       if let site_url = dataObj["site_url"] as? String ,
                        let site_content = dataObj["site_content"] as? String ,
                        let site_extracted_url = dataObj["site_extracted_url"] as? String ,
                        let site_title = dataObj["site_title"] as? String ,
                        let site_image = dataObj["site_image"] as? String {
                         socket_param["site_url"] =  site_url  as AnyObject
                        socket_param["site_content"] =  site_content  as AnyObject
                        socket_param["site_extracted_url"] =  site_extracted_url  as AnyObject
                        socket_param["site_title"] =  site_title  as AnyObject
                        socket_param["site_image"] =  site_image  as AnyObject
                    }
                       IOSocketBudz.sharedInstance.Send(withParm: socket_param) {
                            print("send data")
                        }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            }
        }
        self.chat_msg_list.insert(receiver_obj, at: 0)
//        self.chat
        if (self.chat_msg_list.count != 1 ) {
            self.chat_table_view.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
        }
        self.array_Attachment.removeAll()
        
        self.chat_table_view.reloadData()
//        self.scrollToLastRow();
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chat_table_view.reloadData()
        }
        self.msg_text_field.resignFirstResponder()
        self.msg_text_field.text = ""
        self.attachment_view.isHidden = true
        self.attachment_view_width_constraint.constant = 0
        is_Media_attached = 0
        

    }
    
    func scrollToLastRow() {
        
        if self.chat_msg_list.count > 0 {
            let indexPath = IndexPath.init(row: self.chat_msg_list.count-1, section: 0)
            self.chat_table_view.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    //Mark: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat_msg_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat_obj = self.chat_msg_list[indexPath.row]
        print(chat_obj)
        if(chat_obj.file_type.count > 0){
            if(chat_obj.receiver_id == Int(DataManager.sharedInstance.user!.ID)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMediaMsgTVCell") as? SenderMediaMsgTVCell
                cell?.view_Scrapping.isHidden = true
                cell?.indicator.isHidden = true
                cell?.indicator.startAnimating()
                  cell?.sender_name.text = OtherUserName
                cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
                cell?.selectionStyle = .none
                cell?.MSG_TEXT.applyTag(baseVC: self , mainText: chat_obj.message)
                cell?.MSG_TEXT.text = chat_obj.message
                if(chat_obj.file_type == "image"){
                    cell?.Video_icon.isHidden  = true
                    cell?.MES_IMAGE.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue + chat_obj.file_path.RemoveSpace())!)
//                        .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + chat_obj.file_path.RemoveSpace()), completed: { (image, error, chache, url) in
//                        cell?.indicator.isHidden = true
//                    })
                }else{
                    cell?.Video_icon.isHidden  = false
                    print(WebServiceName.images_baseurl.rawValue + chat_obj.poster)
                    cell?.MES_IMAGE.sd_setImage(with: URL.init(string:WebServiceName.images_baseurl.rawValue + chat_obj.poster.RemoveSpace()), completed: { (image, error, chache, url) in
                        cell?.indicator.isHidden = true
                    })
                }
                cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverMediaMsgTVCell") as? ReceiverMediaMsgTVCell
                cell?.view_Scrapping.isHidden = true
                cell?.selectionStyle = .none
                cell?.MSG_TEXT.applyTag(baseVC: self , mainText: chat_obj.message)
                cell?.MSG_TEXT.text = chat_obj.message
                cell?.MSG_IMG.image = nil
                cell?.rece_name.text = UserName
                cell?.indicator.startAnimating()
                cell?.indicator.isHidden = true
                cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
                if(chat_obj.file_type == "image"){
                    cell?.Video_icon.isHidden  = true
                    if chat_obj.file_path.count > 0 {
                        cell?.MSG_IMG.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue + chat_obj.file_path.RemoveSpace())!)
//                            .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + chat_obj.file_path.RemoveSpace()), completed: { (image, error, chache, url) in
//                            cell?.indicator.isHidden = true
//                            cell?.indicator.stopAnimating()
//                        })
                    }else {
                        cell?.MSG_IMG.image = chat_obj.imageMain
                        if  isImageUploadedSuccess {
                            cell?.indicator.isHidden = true
                            cell?.indicator.stopAnimating()
                        } 
                    }
                }else{
                    cell?.Video_icon.isHidden  = false
                    print(WebServiceName.images_baseurl.rawValue + chat_obj.poster)
                    if chat_obj.file_path.count > 0 {
                        cell?.indicator.isHidden = false
                        cell?.indicator.startAnimating()
                        cell?.MSG_IMG.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + chat_obj.poster.RemoveSpace()), completed: { (image, error, chache, url) in
                            cell?.indicator.isHidden = true
                        })
                    }else {
                        cell?.MSG_IMG.image = chat_obj.imageMain
                        if  isImageUploadedSuccess {
                            cell?.indicator.isHidden = true
                            cell?.indicator.stopAnimating()
                        }
                    }
                }
                
                cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                return cell!
            }
        }else{
            if(chat_obj.receiver_id == Int(DataManager.sharedInstance.user!.ID)){
                if let url = self.slp.extractURL(text: chat_obj.message){
                    return self.senderScrppingCell(tableView: tableView, indexpath: indexPath, url: url, chat_obj: chat_obj)
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMsgTVCell") as? SenderMsgTVCell
                    cell?.selectionStyle = .none
                    cell?.MSG_TEXT.applyTag(baseVC: self , mainText:chat_obj.message )
                    cell?.MSG_TEXT.text = chat_obj.message
                    cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
                     cell?.sender_name.text = OtherUserName
                    cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
                    
                    return cell!
                }
            }else{
                if let url = self.slp.extractURL(text: chat_obj.message){
                    return self.receiverScrappingCell(tableView: tableView, indexpath: indexPath, url: url, chat_obj: chat_obj)
                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverMsgTVCell") as? ReceiverMsgTVCell
                    cell?.MSG_Text.applyTag(baseVC: self , mainText: chat_obj.message)
                    cell?.selectionStyle = .none
                    cell?.MSG_Text.text = chat_obj.message
                    cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
                     cell?.rece_name.text = UserName
                    cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
                    
                    return cell!
                }
            }
        }
    }
    
    
    func receiverScrappingCell(tableView : UITableView , indexpath : IndexPath , url : URL , chat_obj  : MessageChat) -> UITableViewCell {
        let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverMediaMsgTVCell") as? ReceiverMediaMsgTVCell
        cell?.lbl_scrapping.text = ""
        cell?.lbl_scrapping_discription.text = ""
        cell?.lbl_scrapping_source.text = ""
        cell?.MSG_TEXT.applyTag(baseVC: self , mainText: chat_obj.message)
        cell?.MSG_TEXT.text = chat_obj.message
        cell?.Video_icon.isHidden  = true
        cell?.selectionStyle = .none
        cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
        cell?.indicator.isHidden = false
         cell?.rece_name.text = UserName
        cell?.view_Scrapping.isHidden = false
        cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
        cell?.MSG_IMG.image = nil
        if cached?.count != nil{
            self.result = cached!
            cell?.indicator.startAnimating()
            cell?.lbl_scrapping.text = self.result[.title] as? String
            cell?.lbl_scrapping_discription.text = self.result[.description] as? String
            cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
            if let img_url = result[.image] as? String{
                cell?.indicator.startAnimating()
                cell?.Img_scrapping.sd_setImage(with: URL.init(string: img_url), placeholderImage : #imageLiteral(resourceName: "noimage"), completed: { (image, error, chache, url) in
                    cell?.indicator.isHidden = true
                     cell?.indicator.stopAnimating()
                })
            }else{
               cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
            }
        }else{
            self.slp.preview(
                chat_obj.message,
                onSuccess: { result in
                    print(result)
                    self.result = result
                    cell?.indicator.startAnimating()
                    cell?.lbl_scrapping.text = result[.title] as? String
                    cell?.lbl_scrapping_discription.text = result[.description] as? String
                    cell?.lbl_scrapping_source.text = (result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
                    if let img_url = result[.image] as? String{
                        cell?.indicator.startAnimating()
                        cell?.Img_scrapping.sd_setImage(with: URL.init(string: img_url), placeholderImage : #imageLiteral(resourceName: "noimage") ,completed: { (image, error, chache, url) in
                            cell?.indicator.isHidden = true
                             cell?.indicator.stopAnimating()
                        })
                    }else{
                        cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
                    }
            },
                onError: { error in
                    print(error)
            }
            )
        }
        
        cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell!
    }
    func senderScrppingCell(tableView : UITableView , indexpath : IndexPath , url : URL , chat_obj  : MessageChat) -> UITableViewCell {
        let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMediaMsgTVCell") as? SenderMediaMsgTVCell
        cell?.MSG_TEXT.applyTag(baseVC: self , mainText: chat_obj.message)
        cell?.MSG_TEXT.text = chat_obj.message
        cell?.selectionStyle = .none
        cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
        cell?.Video_icon.isHidden  = true
        cell?.lbl_date.text = self.GetTimeAgo(StringDate: chat_obj.created_at)
        cell?.indicator.isHidden = false
        cell?.indicator.startAnimating()
        cell?.MES_IMAGE.image = nil
        cell?.view_Scrapping.isHidden = false
          cell?.sender_name.text = OtherUserName
        cell?.lbl_scrapping.text = ""
        cell?.lbl_scrapping_discription.text = ""
        cell?.lbl_scrapping_source.text = ""
        if cached?.count != nil{
            self.result = cached!
            cell?.lbl_scrapping.text = self.result[.title] as? String
            cell?.lbl_scrapping_discription.text = self.result[.description] as? String
            cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
            if let img_url = result[.image] as? String{
                 cell?.indicator.startAnimating()
                cell?.Img_scrapping.sd_setImage(with: URL.init(string: img_url), placeholderImage : #imageLiteral(resourceName: "noimage") ,completed: { (image, error, chache, url) in
                    cell?.indicator.isHidden = true
                    cell?.indicator.stopAnimating()
                })
            }else{
                cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
            }
        }
        else{
            self.slp.preview(
                chat_obj.message,
                onSuccess: { result in
                    print(result)
                    self.result = result
                    cell?.lbl_scrapping.text = self.result[.title] as? String
                    cell?.lbl_scrapping_discription.text = self.result[.description] as? String
                    cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
                    if let img_url = result[.image] as? String{
                         cell?.indicator.startAnimating()
                        cell?.Img_scrapping.sd_setImage(with: URL.init(string: img_url), placeholderImage : #imageLiteral(resourceName: "noimage") ,completed: { (image, error, chache, url) in
                            cell?.indicator.isHidden = true
                             cell?.indicator.stopAnimating()
                        })
                    }else{
                        cell?.Img_scrapping.image = #imageLiteral(resourceName: "noimage")
                    }
            },
                onError: { error in
                    print(error)
            }
            )
        }
        
        cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell!

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let chat_obj = self.chat_msg_list[indexPath.row]
        if(chat_obj.file_type.count > 0){
            if(chat_obj.file_type == "image"){
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
                if chat_obj.file_path.count > 0 {
                    vc.urlMain = chat_obj.file_path
                     self.showImagess(attachments: [ chat_obj.file_path])
                    
                }else {
                    vc.img = chat_obj.imageMain
                    self.showImageFromImage(attachments: chat_obj.imageMain!)
                    vc.urlMain = ""
//                      self.navigationController?.pushViewController(vc, animated: true)
                }
              
            }else {
                var  videoURL = ""
                print(chat_obj.file_path)
                print(chat_obj.VideoUrl)
                if chat_obj.file_path.count > 0 {
                    videoURL =  WebServiceName.videos_baseurl.rawValue + chat_obj.VideoUrl
                }else {
                    videoURL = chat_obj.VideoUrl
                }
                print(videoURL)
                let player = AVPlayer(url:  NSURL(string: videoURL) as! URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }else{
            if let url = self.slp.extractURL(text: chat_obj.message) {
                if (url.absoluteString.contains("youtube.com")) || (url.absoluteString.contains("youtu.be")) {
                    self.present(YoutubePlayerVC.PlayerVC(url: url), animated: true, completion: nil)
                }else{
                    UIApplication.shared.open(url, options: [:])
                }
                
            }
        }
    }
    
    func RegisterXib(){
        self.chat_table_view.register(UINib(nibName: "myMessageCell", bundle: nil), forCellReuseIdentifier: "myMessageCell")
          self.chat_table_view.register(UINib(nibName: "DateItemTVCell", bundle: nil), forCellReuseIdentifier: "DateItemTVCell")
         self.chat_table_view.register(UINib(nibName: "SenderMsgTVCell", bundle: nil), forCellReuseIdentifier: "SenderMsgTVCell")
         self.chat_table_view.register(UINib(nibName: "ReceiverMsgTVCell", bundle: nil), forCellReuseIdentifier: "ReceiverMsgTVCell")
          self.chat_table_view.register(UINib(nibName: "SenderMediaMsgTVCell", bundle: nil), forCellReuseIdentifier: "SenderMediaMsgTVCell")
           self.chat_table_view.register(UINib(nibName: "ReceiverMediaMsgTVCell", bundle: nil), forCellReuseIdentifier: "ReceiverMediaMsgTVCell")
    }
}

