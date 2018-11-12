//
//  Notifications&AlertsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ZFTokenField

class Notifications_AlertsVC: BaseViewController,ZFTokenFieldDataSource, ZFTokenFieldDelegate {
    
    func lineHeightForToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 40
    }
    
    func numberOfToken(in tokenField: ZFTokenField!) -> UInt {
        return UInt(self.tags_array.count)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    func tokenField(_ tokenField: ZFTokenField!, viewForTokenAt index: UInt) -> UIView! {
        let tutorialsXibs = Bundle.main.loadNibNamed("keywordsCell", owner: self, options: nil)
        let viewMain = tutorialsXibs?[0] as! UIView
        let lblMain = viewMain.viewWithTag(100) as! UILabel
        let btnMain = viewMain.viewWithTag(200) as! UIButton
        btnMain.tag = Int(index)
        btnMain.addTarget(self, action: #selector(self.DeleteKeyword), for: .touchUpInside)
        let tags_obj = self.tags_array[Int(index)]
        if let tags = tags_obj["tag"] as? [String : Any]{
            if let tag_title = tags["title"] as? String{
                lblMain.text = tag_title
            }else{
                lblMain.text = ""
            }
        }else{
            lblMain.text = ""
        }
        
        var heightSize = lblMain.text?.height(withConstrainedWidth: self.view.frame.size.width - 50 , font: lblMain.font)
        if Double(heightSize!) < 25.0 {
           heightSize = 25.0
        }
        let widthSize = lblMain.text?.width(withConstrainedHeight: heightSize!, font: lblMain.font)
        viewMain.frame = CGRect.init(x: 0, y: 0, width: widthSize! + 50 , height:  heightSize!)
        viewMain.backgroundColor = UIColor.init(hex: "7cc144")
        return viewMain
    }
    
    func tokenMarginInToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 5
    }

    func DeleteKeyword(sender : UIButton){
        print(sender.tag)
         let tags_obj = self.tags_array[sender.tag]
          if let tag_id = tags_obj["id"] as? Int{
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: WebServiceName.remove_tag.rawValue + "/\(tag_id)") { (successRespons, messageResponse, dataResponse) in
                    self.hideLoading()
                    print(dataResponse)
                    self.tags_array.remove(at: sender.tag)
                    self.tableView_settings.reloadData()
                }
            }
        
       
    }
    
    @IBOutlet weak var tableView_settings: UITableView!
    var is_new_question = false
    var is_follow_question_answer = false
    var is_public_joined = false
    var is_private_joined = false
    var is_follow_strains = false
    var is_specials = false
    var is_shout_out = false
    var is_message = false
    var is_follow_profile = false
    var is_follow_journal = false
    var is_your_strain = false
    var is_like_question = false
    var is_like_answer = false
    var is_like_journal = false
    var tags_array = [[String : Any]]()
    var mainArray =  [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.APICAllForNotification()
         self.disableMenu()
    }

    func APICAllForNotification(){
        self.showLoading()
        
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_notification_settings.rawValue) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.hideLoading()
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    let maindata = dataResponse["successData"] as! [String : AnyObject]
                    if let mainNotificatgion = maindata["notification_setting"] as? [String : AnyObject] {
                        if let tagsArray =  maindata["tags"] as? [[String : Any]]{
                            self.tags_array = tagsArray
                        }
                        print(mainNotificatgion)
                        self.is_message = (mainNotificatgion["message"] as! Int).boolValue
                        self.is_specials = (mainNotificatgion["specials"] as! Int).boolValue
                        self.is_shout_out = (mainNotificatgion["shout_out"] as! Int).boolValue
                        self.is_like_answer = (mainNotificatgion["like_answer"] as! Int).boolValue
                        self.is_your_strain = (mainNotificatgion["your_strain"] as! Int).boolValue
                        self.is_new_question = (mainNotificatgion["new_question"] as! Int).boolValue
                        self.is_like_question = (mainNotificatgion["like_question"] as! Int).boolValue
                        self.is_follow_profile = (mainNotificatgion["follow_profile"] as! Int).boolValue
                        self.is_follow_strains = (mainNotificatgion["follow_strains"] as! Int).boolValue
                        self.is_follow_question_answer = (mainNotificatgion["follow_question_answer"] as! Int).boolValue
                        
                    }
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
  

}
extension Notifications_AlertsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : notifications_Alerts.mainHeadingCell.rawValue , "title" : "General" ,  "isCheck" : false])//1
        self.mainArray.append(["type" : notifications_Alerts.notificationCell.rawValue , "title" : "New Question Push Notification" ,  "isCheck" : self.is_new_question])//2  1
        
        self.mainArray.append(["type" : notifications_Alerts.mainHeadingCell.rawValue , "title" : "Buzz Feed" ,  "isCheck" : false])//3
        self.mainArray.append(["type" : notifications_Alerts.notificationCell.rawValue , "title" : "Q&A Disscussions You Follow" ,  "isCheck" : self.is_follow_question_answer])//4 2
        
//        self.mainArray.append(["type" : notifications_Alerts.subHeadingCell.rawValue , "title" : "Group:" ,  "isCheck" : false])//5
//        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Public Group You've Joined:" ,  "isCheck" : self.is_public_joined])//6
//        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Private Group You've Joined:" ,  "isCheck" : self.is_private_joined])//7
        
         self.mainArray.append(["type" : notifications_Alerts.notificationCell.rawValue, "title" : "Update to Strains You Follow" ,  "isCheck" : self.is_follow_strains])//8 3
        
        self.mainArray.append(["type" : notifications_Alerts.subHeadingCell.rawValue, "title" : "Budz Adz:" ,  "isCheck" : false])//9
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Specials" ,  "isCheck" : self.is_specials])//10  4
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Business Shout Outs" ,  "isCheck" : self.is_shout_out])//11  5
        
          self.mainArray.append(["type" : notifications_Alerts.notificationCell.rawValue, "title" : "Messages" ,  "isCheck" : self.is_message])//12  6
        
        self.mainArray.append(["type" : notifications_Alerts.subHeadingCell.rawValue, "title" : "Budz Following" ,  "isCheck" : false])//13
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Profile" ,  "isCheck" : self.is_follow_profile])//14  7
//        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Journals" ,  "isCheck" : self.is_follow_journal])//15
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Created Strains" ,  "isCheck" : self.is_your_strain])//16  8
        
        self.mainArray.append(["type" : notifications_Alerts.subHeadingCell.rawValue, "title" : "Budz Who Like/Dislike" ,  "isCheck" : false])//17
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Questions" ,  "isCheck" : self.is_like_question])//18  9
        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Answers" ,  "isCheck" : self.is_like_answer])//19  10
//        self.mainArray.append(["type" : notifications_Alerts.notificationCell2.rawValue , "title" : "Your Journal Entries" ,  "isCheck" : self.is_like_journal])
        
        self.mainArray.append(["type" : notifications_Alerts.keywordCell.rawValue ])

        
        
        self.tableView_settings.reloadData()
    }
    
    func RegisterXib(){
        
        
        self.tableView_settings.register(UINib(nibName: "notificationsMainHeadingCell", bundle: nil), forCellReuseIdentifier: "notificationsMainHeadingCell")
        self.tableView_settings.register(UINib(nibName: "notificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        self.tableView_settings.register(UINib(nibName: "notificationsSubHeadingCell", bundle: nil), forCellReuseIdentifier: "notificationsSubHeadingCell")
        
        self.tableView_settings.register(UINib(nibName: "KeywordMainCell", bundle: nil), forCellReuseIdentifier: "KeywordMainCell")
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
        let DataElement = self.mainArray[indexPath.row]
        let dataType = DataElement["type"] as! String
        switch dataType {
        case notifications_Alerts.mainHeadingCell.rawValue:
            return notificationsMainHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
        case notifications_Alerts.notificationCell.rawValue:
            return notificationCell(tableView:tableView  ,cellForRowAt:indexPath)
        case notifications_Alerts.notificationCell2.rawValue:
            return notificationCell2(tableView:tableView  ,cellForRowAt:indexPath)
        case notifications_Alerts.keywordCell.rawValue:
            return KeywordCell(tableView:tableView  ,cellForRowAt:indexPath)
        case notifications_Alerts.subHeadingCell.rawValue:
            return notificationsSubHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
        default:
            return notificationsSubHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }

    //MARK: settingCell1
    func notificationsMainHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsMainHeadingCell") as? notificationsMainHeadingCell
        let DataElement = self.mainArray[indexPath.row]
        cell?.title.text = DataElement["title"] as? String
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK: settingCell2
    func notificationCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? notificationCell
        let DataElement = self.mainArray[indexPath.row]
        cell?.title.text = DataElement["title"] as? String
        cell?.mainView_LeadingSpace.constant = 0
        cell?.selectionStyle = .none
       self.InitSwitchCell(button: (cell?.btn_switch)!, img: (cell?.swtich_image)!, DataElement: DataElement, index: indexPath.row)
        return cell!
    }
    //MARK: settingCell2
    func notificationCell2(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? notificationCell
        let DataElement = self.mainArray[indexPath.row]
        cell?.title.text = DataElement["title"] as? String
        cell?.mainView_LeadingSpace.constant = 15
        cell?.selectionStyle = .none
        self.InitSwitchCell(button: (cell?.btn_switch)!, img: (cell?.swtich_image)!, DataElement: DataElement, index: indexPath.row)
        return cell!
    }
    
    func KeywordCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordMainCell") as? KeywordMainCell
        cell?.tokenfield.dataSource = self
        cell?.tokenfield.delegate = self
        cell?.tokenfield.textField.isEnabled = false
        cell?.tokenfield.reloadData()
        return cell!
    }
    
    func notificationsSubHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsSubHeadingCell") as? notificationsSubHeadingCell
        let DataElement = self.mainArray[indexPath.row]
        cell?.title.text = DataElement["title"] as? String
        cell?.selectionStyle = .none
        return cell!
    }
    
    func InitSwitchCell(button  : UIButton , img : UIImageView , DataElement : [String : Any] , index : Int ) {
        if(DataElement["isCheck"] as? Bool ?? false){
            img.image =  #imageLiteral(resourceName: "btn_on1")
        }else{
            img.image = #imageLiteral(resourceName: "btn_off")
        }
        button.tag = index
        button.addTarget(self, action: #selector(self.SwitchAction(_sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func SwitchAction(_sender : UIButton) {
        
        print(_sender.tag)
        var DataElement = self.mainArray[_sender.tag]
        var finalValue = false
        
        if(DataElement["isCheck"] as? Bool ?? false){
            DataElement["isCheck"] =  false
            finalValue = false
        }else{
            DataElement["isCheck"] =  true
            finalValue = true
        }
        self.mainArray[_sender.tag] = DataElement
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: _sender.tag, section: 0)], with: .fade)
        
        
        
        switch _sender.tag {
        case 1: self.is_new_question = finalValue; break
        case 3: self.is_follow_question_answer = finalValue; break
//        case 5: self.is_public_joined = finalValue; break
//        case 6: self.is_private_joined = finalValue; break
        case 4: self.is_follow_strains = finalValue; break
        case 6: self.is_specials = finalValue; break
        case 7: self.is_shout_out = finalValue; break
        case 8: self.is_message = finalValue; break
        case 10: self.is_follow_profile = finalValue; break
//        case 14: self.is_follow_journal = finalValue; break
        case 11: self.is_your_strain = finalValue; break
        case 13: self.is_like_question = finalValue; break
        case 14: self.is_like_answer = finalValue; break
//        case 19: self.is_like_journal = finalValue; break
            
        default:
            break
            
        }
    }
    @IBAction func GoBAck(sender : UIButton){
        Save_Action(sender: sender)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func GoHOme(sender : UIButton){
        Save_Action(sender: sender)
        self.GotoHome()
        
    }
    
    @IBAction func Save_Action(sender : UIButton){
//        self.showLoading()
        var newPAram = [String : AnyObject]()
        
        newPAram["message"] = String(self.is_message.intValue) as AnyObject
        newPAram["specials"] = String(self.is_specials.intValue) as AnyObject
        newPAram["shout_out"] = String(self.is_shout_out.intValue) as AnyObject
        newPAram["like_answer"] = String(self.is_like_answer.intValue) as AnyObject
        newPAram["your_strain"] = String(self.is_your_strain.intValue) as AnyObject
        newPAram["like_journal"] = String(self.is_like_journal.intValue) as AnyObject
        newPAram["new_question"] = String(self.is_new_question.intValue) as AnyObject
        newPAram["like_question"] = String(self.is_like_question.intValue) as AnyObject
        newPAram["public_joined"] = String(self.is_public_joined.intValue) as AnyObject
        newPAram["follow_journal"] = String(self.is_follow_journal.intValue) as AnyObject
        newPAram["follow_profile"] = String(self.is_follow_profile.intValue) as AnyObject
        newPAram["follow_strains"] = String(self.is_follow_strains.intValue) as AnyObject
        newPAram["private_joined"] = String(self.is_private_joined.intValue) as AnyObject
        newPAram["follow_question_answer"] = String(self.is_follow_question_answer.intValue) as AnyObject

        print(newPAram)
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_notificarion_setting.rawValue, params: newPAram) {  (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
//            self.hideLoading()
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
//                    let maindata = dataResponse["successData"] as! [String : AnyObject]
//                    let mainNotificatgion = maindata["notification_setting"] as! [String : AnyObject]
//
//                    print(mainNotificatgion)
//
//
//                    self.is_message = (mainNotificatgion["message"] as! Int).boolValue
//                    self.is_specials = (mainNotificatgion["specials"] as! Int).boolValue
//                    self.is_shout_out = (mainNotificatgion["shout_out"] as! Int).boolValue
//                    self.is_like_answer = (mainNotificatgion["like_answer"] as! Int).boolValue
//                    self.is_your_strain = (mainNotificatgion["your_strain"] as! Int).boolValue
//                    self.is_like_journal = (mainNotificatgion["like_journal"] as! Int).boolValue
//                    self.is_new_question = (mainNotificatgion["new_question"] as! Int).boolValue
//                    self.is_like_question = (mainNotificatgion["like_question"] as! Int).boolValue
//                    self.is_public_joined = (mainNotificatgion["public_joined"] as! Int).boolValue
//                    self.is_follow_journal = (mainNotificatgion["follow_journal"] as! Int).boolValue
//                    self.is_follow_profile = (mainNotificatgion["follow_profile"] as! Int).boolValue
//                    self.is_follow_strains = (mainNotificatgion["follow_strains"] as! Int).boolValue
//                    self.is_private_joined = (mainNotificatgion["private_joined"] as! Int).boolValue
//                    self.is_follow_question_answer = (mainNotificatgion["follow_question_answer"] as! Int).boolValue
                    
                    
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
class notificationsMainHeadingCell :UITableViewCell{
    @IBOutlet weak var title: UILabel!
    
}
class notificationCell :UITableViewCell{
    
    @IBOutlet weak var swtich_image: UIImageView!
    @IBOutlet weak var btn_switch: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView_LeadingSpace: NSLayoutConstraint!
}


class KeywordMainCell :UITableViewCell{
    
    @IBOutlet weak var tokenfield: ZFTokenField!

    
}

class notificationsSubHeadingCell :UITableViewCell{
    @IBOutlet weak var title: UILabel!
    
}

extension Integer {
    var boolValue: Bool { return self != 0 }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
