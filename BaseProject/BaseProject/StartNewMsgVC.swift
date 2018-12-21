//
//  StartNewMsgVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class StartNewMsgVC:  BaseViewController {
    @IBOutlet weak var Header_Title: UILabel!
    @IBOutlet weak var search_tf_view: RoundView!
    @IBOutlet weak var Search_TF: UITextField!
    @IBOutlet weak var img_search_icon: UIImageView!
    @IBOutlet weak var tableView_myMessages: UITableView!
    var refreshControl: UIRefreshControl!
    var msg_list = [Message]()
    var searchUsers = [User]()
    var isMyMessagesClick : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.Search_TF.delegate = self
        self.Search_TF.becomeFirstResponder()
        self.search_tf_view.bouncingAnimation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //self.searchUsers.removeAll()
        //self.tableView_myMessages.reloadData()
        self.Search_TF.text  = ""
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
    }

    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.Back()
    }
    
    @IBAction func New_MSG(_ sender: Any) {
        self.Search_TF.becomeFirstResponder()
        self.search_tf_view.bouncingAnimation()
    }
    @IBAction func onClickClearSearch(_ sender: Any) {
        if self.Search_TF.text!.count > 0 {
            self.Search_TF.text = ""
            self.Search_TF.resignFirstResponder()
            self.searchUsers.removeAll()
            self.tableView_myMessages.reloadData()
            self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
        }
    }
}
extension StartNewMsgVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        self.tableView_myMessages.register(UINib(nibName: "myMessageCell", bundle: nil), forCellReuseIdentifier: "myMessageCell")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        return myMessageCell(tableView:tableView  ,cellForRowAt:indexPath)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
        vc.isSelectUser = false
        let data = self.searchUsers[indexPath.row]
        let messe_user = Message()
        messe_user.receiver_id = Int(data.ID)!
        messe_user.receiver_image_path = data.profilePictureURL
        messe_user.receiver_first_name = data.userFirstName
        messe_user.receiver_avatar  = data.avatarImage
        messe_user.receiver_special_icon  = data.special_icon
        messe_user.sender_image_path = data.profilePictureURL
        messe_user.sender_first_name = data.userFirstName
        messe_user.sender_avatar  = data.avatarImage
        messe_user.sender_special_icon  = data.special_icon
        vc.msg_data_modal = messe_user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: mySaveCell
    func myMessageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myMessageCell") as? myMessageCell
        cell?.selectionStyle = .none
        cell?.img_msgStatus.isHidden = true
        print(indexPath.row)
        print(searchUsers.count)
        if(searchUsers.count > 0) {
            let user_obg = searchUsers[indexPath.row]
            cell?.MSG_date.text = ""
            cell?.MSG_count_view.isHidden = true
            cell?.MSG_Name.text = user_obg.userFirstName
            
            if user_obg.profilePictureURL.contains("facebook.com") || user_obg.profilePictureURL.contains("google.com"){
                cell?.MSG_sender_Img.moa.url = user_obg.profilePictureURL.RemoveSpace()
            }else{
                cell?.MSG_sender_Img.moa.url = WebServiceName.images_baseurl.rawValue + user_obg.profilePictureURL.RemoveSpace()
            }
            cell?.MSG_sender_Img.RoundView()
            if user_obg.special_icon.characters.count > 6 {
                cell?.MSG_sender_ImgTop.isHidden = false
                cell?.MSG_sender_ImgTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + user_obg.special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
            }else {
                cell?.MSG_sender_ImgTop.isHidden = true
            }
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
        }else{
            self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0 {
            self.SearchAPICAll()
        }else {
            self.searchUsers.removeAll()
            self.tableView_myMessages.reloadData()
            self.img_search_icon.image = #imageLiteral(resourceName: "SearchGray")
        }
    }
    
    func SearchAPICAll(){
        self.searchUsers.removeAll()
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.search_users.rawValue + self.Search_TF.text!) { (successMain, messageResponse, MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if successMain {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        print(indexObj)
                        self.searchUsers.append(User.init(json: indexObj as [String : AnyObject] ))
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
            
            if self.searchUsers.count == 0 {
                self.tableView_myMessages.setEmptyMessage("No User Found!", color: UIColor.white)
            }else{
                self.tableView_myMessages.restore()
            }
            self.tableView_myMessages.reloadData()
        }
        
        
    }
}
