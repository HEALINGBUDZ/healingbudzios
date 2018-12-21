//
//  SupportVC.swift
//  BaseProject
//
//  Created by MAC MINI on 19/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import MessageUI


class SupportVC: BaseViewController, MFMessageComposeViewControllerDelegate  {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        self.enableMenu()
    }
    // MARK: - Outlets
    @IBOutlet weak var tableView_Support: UITableView!
    
    var shouldHideFirstSection:Bool?
    var shouldHideSecondSection:Bool?
    var shouldHideThirdSection:Bool?
    
    var selectedSubID:String?
    var message:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldHideFirstSection = false
        shouldHideSecondSection = false
        shouldHideThirdSection = false
        self.tableView_Support.delegate = self
        self.tableView_Support.dataSource = self
        self.RegisterXib()
        DataManager.sharedInstance.supportOptionsArray.removeAll()
        var subTest = SubUser()
        subTest.id = (DataManager.sharedInstance.user?.ID)!
        subTest.title = (DataManager.sharedInstance.user?.userFirstName)!
        DataManager.sharedInstance.supportOptionsArray.append(subTest)
        getSupportOption()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ViewDidAppear Method
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.tabBarController?.tabBar.isHidden = true
        
        self.disableMenu()
       
    }
    
    func getSupportOption(){
        
        
        self.showLoading()
        
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_sub_users.rawValue) { (success, message, response) in
            
            self.hideLoading()
            if success{
                if (response["status"] as! String) == "success" {
                    
                    

                    
                    //let mainUser = ((response["successData"] as! [String : Any])["sub_users"] as! [String : Any])

                    
                    let mainUser = response["successData"] as? NSDictionary
                    
                    
                    let objUser = mainUser?["sub_users"]   as? NSArray
                    
                    if objUser != nil {
                        
                        for indexObj in  objUser! {
                            DataManager.sharedInstance.supportOptionsArray.append(SubUser.init(json: indexObj as? [String : AnyObject]))
                            }
                        
                    }
                    
                    

                    self.tableView_Support.reloadData()
                    
                    print( DataManager.sharedInstance.supportOptionsArray )
                }
            }
            
        }
        
    }
    
    func submitSupport(){
        
        
        
        
        if DataManager.sharedInstance.supportSubID == nil {
        
            self.ShowErrorAlert(message: "Select some user!")
            
            return
        }
        
        let user = User()

        user.sub_user_id = DataManager.sharedInstance.supportSubID!
        var objMessageCell = messageCell()
        self.tableView_Support.subviews.forEach { (objView) in
            
            if objView.isKind(of: messageCell.self){
                
                objMessageCell = objView as! messageCell
                
               user.message =  objMessageCell.textView_message.text
            }
        }
        
        
        if user.sub_user_id.isEmpty {
            
            self.ShowErrorAlert(message: "Select some user!")
            return
        }
        
        
        if user.message.isEmpty {
            
            self.ShowErrorAlert(message: "Message field should not be empty!")
            return
        }
        
        if objMessageCell.textView_message != nil {
            objMessageCell.textView_message.text = ""
        }
        
        
        self.showLoading()
       
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.mail_support.rawValue, params: user.toRegisterJSONSupport(), completion: { (successResponse, messageResponse, dataResponse) in
            
            self.hideLoading()
            if successResponse{
                if (dataResponse["status"] as! String) == "success" {
                   self.ShowSuccessAlertWithNoAction (message: "Your message has been sent successfully!")
                    self.tableView_Support.reloadData()
                }
            }
        })
    }
}
extension SupportVC:UITableViewDelegate,UITableViewDataSource{
    
    func RegisterXib(){
        let nib = UINib(nibName: "supportCell", bundle: nil)
        self.tableView_Support.register(nib, forHeaderFooterViewReuseIdentifier: "supportCell")
        self.tableView_Support.register(UINib(nibName: "helpLabelCell", bundle: nil), forCellReuseIdentifier: "helpLabelCell")
      self.tableView_Support.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        self.tableView_Support.register(UINib(nibName: "messageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
       self.tableView_Support.register(UINib(nibName: "SubmitButtonCell", bundle: nil), forCellReuseIdentifier: "SubmitButtonCell")
        
        self.tableView_Support.register(UINib(nibName: "likeCell", bundle: nil), forCellReuseIdentifier: "likeCell")
        self.tableView_Support.register(UINib(nibName: "inviteCell", bundle: nil), forCellReuseIdentifier: "inviteCell")
        self.tableView_Support.register(UINib(nibName: "inviteViaCell", bundle: nil), forCellReuseIdentifier: "inviteViaCell")
        self.tableView_Support.register(UINib(nibName: "privacyCell", bundle: nil), forCellReuseIdentifier: "privacyCell")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if shouldHideFirstSection! {
                return 0
            }
            else{
               return 4
            }
           
        }
        else if section == 1{
            if shouldHideSecondSection! {
                return 0
            }
            else{
               return 5
            }
            
        }
        else{
            if shouldHideThirdSection! {
                return 0
            }
            else{
             return 1
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       return SupportCell(tableView: tableView, cellForRowAt: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return HelpLabelCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 1:
                return PickerCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 2:
                return MessageCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 3:
                 return SubmitButtonCell(tableView:tableView ,cellForRowAt:indexPath)
            default:
                 return PickerCell(tableView:tableView ,cellForRowAt:indexPath)
            }
            
         
        }
        else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                return LikeCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 1:
                return createInviteCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 2:
                return inviteViaCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 3:
                 return createInviteCell(tableView:tableView  ,cellForRowAt:indexPath)
            case 4:
                return SubmitButtonCell(tableView:tableView ,cellForRowAt:indexPath)
            default:
                return SubmitButtonCell(tableView:tableView ,cellForRowAt:indexPath)
            }
        }

        
        else
        {
                 return privacyCell(tableView:tableView ,cellForRowAt:indexPath)
        }
 
                
        
    }
   
    //MARK: SupportCell
    func SupportCell(tableView: UITableView, cellForRowAt section: Int) -> supportCell{
        let cell = self.tableView_Support.dequeueReusableHeaderFooterView(withIdentifier: "supportCell") as? supportCell
        if section == 0 {
            cell?.lbl_Title.text = "Support Message Center"
            
            if (shouldHideFirstSection)!{
                cell?.imgView_arrow.image = UIImage.init(named: "downArrow")

            }else {
                cell?.imgView_arrow.image = UIImage.init(named: "upArrow")

            }
        }
        else if section == 1 {
             cell?.lbl_Title.text = "Contact"
            if (shouldHideSecondSection)!{
                cell?.imgView_arrow.image = UIImage.init(named: "downArrow")
                
            }else {
                cell?.imgView_arrow.image = UIImage.init(named: "upArrow")
                
            }
        }
        else{
             cell?.lbl_Title.text = "Legal"
            
            if (shouldHideThirdSection)!{
                cell?.imgView_arrow.image = UIImage.init(named: "downArrow")
                
            }else {
                cell?.imgView_arrow.image = UIImage.init(named: "upArrow")
                
            }
        }
        

        cell?.btn_arrow.tag = section
        
        cell?.btn_arrow.addTarget(self, action: #selector(hideShowCells), for: UIControlEvents.touchUpInside)

   
        return cell!
    }
     //MARK: PickerCell
    func PickerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as? pickerCell
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK: Help LabelCell
    func HelpLabelCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpLabelCell") as? helpLabelCell
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK: MessageCell
    func MessageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? messageCell
        
        cell?.textView_message.layer.cornerRadius = 10
        cell?.textView_message.layer.borderColor = UIColor.white.cgColor
        cell?.textView_message.layer.borderWidth = 1.0
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func submitButtonPressed(sender : UIButton){
        if sender.tag == 655{
             self.submitSupport()
        }
       
    }
    
    func inviteButtonPressed(sender : UIButton){
        if sender.tag != 766 {
            return
        }
        let user = User()
        var objMessageCell = inviteCell()
        
        self.tableView_Support.subviews.forEach { (objView) in
            
            
            if objView.isKind(of: inviteCell.self){
                
                objMessageCell = objView as! inviteCell
                
                if objMessageCell.txtEmail.tag == 1{
                    
                    if (!(objMessageCell.txtEmail.text?.isEmpty)!){
                        
                        user.email =  objMessageCell.txtEmail.text!
                        

                    }
                }
                else if objMessageCell.txtEmail.tag == 2{
                    
                    if (!(objMessageCell.txtEmail.text?.isEmpty)!){
                        
                        user.phone =  objMessageCell.txtEmail.text!
                    }
                }
                
            }
        }
        
        
        if user.email.isEmpty && user.phone.isEmpty{
            self.ShowErrorAlert(message: "Enter email or phone!")
            return
        }
        if !user.phone.isEmpty{
            if (MFMessageComposeViewController.canSendText()) {
                self.refresTF()
                self.tableView_Support.reloadData()
                let controller = MFMessageComposeViewController()
                controller.body = "Check out Healing Budz for your smartphone. Download it today from " + Constants.ShareLinkConstant
                controller.recipients = [user.phone]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            } else {
                self.ShowErrorAlert(message: "Your device can't sent messages!")
            }
        }
        
        if !user.email.isEmpty
        {
            self.showLoading()
            NetworkManager.PostCall(UrlAPI: WebServiceName.invite.rawValue, params: user.toRegisterJSON(), completion: { (successResponse, messageResponse, dataResponse) in
            
                self.hideLoading()
                if successResponse{
                    if (dataResponse["status"] as! String) == "success" {
                        self.refresTF()
                        self.ShowSuccessAlertWithNoAction(message: "Your invitation has been sent successfully!")
                    
                        self.tableView_Support.reloadData()
                    }
                }
            })
        }
    }
    
    func refresTF() {
        self.tableView_Support.subviews.forEach { (objView) in
            if objView.isKind(of: inviteCell.self){
                let objMessageCell = objView as! inviteCell
                if objMessageCell.txtEmail.tag == 1{
                    objMessageCell.txtEmail.text = ""
                } else if objMessageCell.txtEmail.tag == 2{
                    objMessageCell.txtEmail.text = ""
                }
                
            }
        }
    }
    //MARK: Help LabelCell
    func SubmitButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonCell") as? SubmitButtonCell
        
        cell?.submitButton.backgroundColor = UIColor(red:0.467, green:0.769, blue:0.318, alpha:1.000)
        cell?.submitButton.layer.cornerRadius = 5
        cell?.submitButton.layer.borderColor = UIColor(red:0.467, green:0.769, blue:0.318, alpha:1.000).cgColor
        cell?.submitButton.layer.borderWidth = 1.0
        if indexPath.section == 0 {
            cell?.submitButton.setTitle("SUBMIT", for: .normal)
            cell?.submitButton.setTitleColor(UIColor.init(hex: "FFFFFF"), for: .normal)
            cell?.submitButton.tag = 655
            cell?.submitButton.addTarget(self, action: #selector(self.submitButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        }
        else{
            cell?.submitButton.setTitle("INVITE NEW BUD", for: .normal)
            
            cell?.submitButton.setTitleColor(UIColor.init(hex: "FFFFFF"), for: .normal)
            cell?.submitButton.tag = 766
            cell?.submitButton.addTarget(self, action: #selector(self.inviteButtonPressed(sender:)), for: UIControlEvents.touchUpInside)

        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func LikeCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell") as? likeCell
        
        cell?.askSupportButton.addTarget(self, action: #selector(self.openFreshChat(sender:)), for: .touchUpInside)
        cell?.appStore.addTarget(self, action: #selector(self.openAppStore(sender:)), for: .touchUpInside)
        //
        cell?.fbBtn.addTarget(self, action: #selector(self.openFb(sender:)), for: .touchUpInside)
        cell?.twiBtn.addTarget(self, action: #selector(self.openTwi(sender:)), for: .touchUpInside)
        cell?.ytBtn.addTarget(self, action: #selector(self.openYt(sender:)), for: .touchUpInside)
        cell?.instaBtn.addTarget(self, action: #selector(self.openInsta(sender:)), for: .touchUpInside)
        //
        cell?.selectionStyle = .none
        return cell!
    }
    @objc func openAppStore(sender: UIButton!){
        self.OpenLink(webUrl: "https://itunes.apple.com/us/app/healing-budz/id1438614769?mt=8")
    }
    //
    //Youtube https://www.youtube.com/channel/UCcQUb_JBOCzPItwVA56DNuA?view_as=subscriber
    //Insta https://www.instagram.com/healingbudz/?hl=en
    //FB https://www.facebook.com/healingbudz/
    // Twit https://twitter.com/healingbudz?lang=en
    @objc func openFb(sender: UIButton!){
        self.OpenLink(webUrl: "https://www.facebook.com/healingbudz/")
    }
    @objc func openInsta(sender: UIButton!){
        self.OpenLink(webUrl: "https://www.instagram.com/healingbudz/?hl=en")
    }
    @objc func openTwi(sender: UIButton!){
        self.OpenLink(webUrl: "https://twitter.com/healingbudz?lang=en")
    }
    @objc func openYt(sender: UIButton!){
//        self.OpenLink(webUrl: "https://www.youtube.com/channel/UCcQUb_JBOCzPItwVA56DNuA?view_as=subscriber")
        var url = "https://www.youtube.com/channel/UCcQUb_JBOCzPItwVA56DNuA?view_as=subscriber"
        if self.verifyUrl(urlString: url) {
            let url = URL(string: url)
               UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }else{
            self.ShowErrorAlert(message: "Invalid URL!", AlertTitle: "Error!")
        }
    }
    //
    @objc func openFreshChat(sender: UIButton!){
        var fUser = FreshchatUser()
        fUser.firstName = DataManager.sharedInstance.user?.userFirstName
        Freshchat.sharedInstance().setUser(fUser)
        Freshchat.sharedInstance().showConversations(self)
        
    }
    
    func createInviteCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") as? inviteCell
        if indexPath.row == 1 {
            cell?.label_title.text = "Invite via email address"
            cell?.txtEmail.tag = 1
            cell?.txtEmail.keyboardType = .emailAddress
            cell?.img.image = #imageLiteral(resourceName: "ic_email_icon").withRenderingMode(.alwaysTemplate)
            cell?.img.tintColor = UIColor.init(hex: "252525")
        }else {
            cell?.label_title.text = "Add Phone Number Below"
            cell?.txtEmail.tag = 2
            cell?.txtEmail.keyboardType = .numberPad
             cell?.img.image = #imageLiteral(resourceName: "ic_call_icon").withRenderingMode(.alwaysTemplate)
            cell?.img.tintColor = UIColor.init(hex: "252525")
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func inviteViaCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteViaCell") as? inviteViaCell
        cell?.selectionStyle = .none
        return cell!
    }
    func privacyCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacyCell") as? privacyCell
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        cell?.btn_policy.addTarget(self, action: #selector(callForPrivacy), for: .touchUpInside)
        cell?.btn_term.addTarget(self, action: #selector(callForTerm), for: .touchUpInside)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Version "+version)
//            cell?.version.text = "Version "+version
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            cell?.version.text = "Version "+build
        }
        cell?.lb_copy_right_text.text = "Copyright Healing Budz, Inc. " + "\(year)"
        cell?.selectionStyle = .none
        return cell!
    }
    
    func callForPrivacy(sender : UIButton){
        var uiviewct = self.GetView(nameViewController: "TermContditionVC", nameStoryBoard: "BudzStoryBoard") as! TermContditionVC
        uiviewct.isTerm = false
        self.navigationController?.pushViewController(uiviewct, animated: true)
    }
    func callForTerm(sender : UIButton){
        var uiviewct = self.GetView(nameViewController: "TermContditionVC", nameStoryBoard: "BudzStoryBoard") as! TermContditionVC
        uiviewct.isTerm = true
        self.navigationController?.pushViewController(uiviewct, animated: true)
    }
    //MARK: Button Actions
    func hideShowCells(sender : UIButton){
        
        
        
        switch sender.tag {
        case 0:
            
            if shouldHideFirstSection! {
                shouldHideFirstSection = false
            }else {
                shouldHideFirstSection = true
            }
            
            break;
            
        case 1:
            if shouldHideSecondSection! {
                shouldHideSecondSection = false
            }else {
                shouldHideSecondSection = true
            }
            break;
            
        default:
            
            if shouldHideThirdSection! {
                shouldHideThirdSection = false
            }else {
                shouldHideThirdSection = true
            }
            break
        }
        
        self.tableView_Support.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .automatic)
        
    }
    
    
    @IBAction func Back_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)

    }
}
class supportCell: UITableViewHeaderFooterView {
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var imgView_arrow: UIImageView!
    
    @IBOutlet weak var btn_arrow: UIButton!
    
    
}
class helpLabelCell: UITableViewCell{
    
    
}
class messageCell:UITableViewCell{
    @IBOutlet weak var textView_message: UITextView!
    
    
}
class likeCell:UITableViewCell{
  
    @IBOutlet weak var askSupportButton: UIButton!
    @IBOutlet weak var appStore: UIButton!
    
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var instaBtn: UIButton!
    @IBOutlet weak var twiBtn: UIButton!
    @IBOutlet weak var ytBtn: UIButton!
    
}
class inviteCell:UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    
}
class inviteViaCell:UITableViewCell{
    
    
    
}
class privacyCell:UITableViewCell{
    
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var lb_copy_right_text: UILabel!
    
    @IBOutlet weak var btn_policy: UIButton!
    
    @IBOutlet weak var btn_term: UIButton!
    
}
