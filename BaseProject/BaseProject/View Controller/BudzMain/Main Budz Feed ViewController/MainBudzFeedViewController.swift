//
//  MainBudzFeedViewController.swift
//  BaseProject
//
//  Created by macbook on 28/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class MainBudzFeedViewController: BaseViewController {

    @IBOutlet weak var view_hight: NSLayoutConstraint!
    @IBOutlet weak var green_line: UIView!
    @IBOutlet var tbleViewMain : UITableView!
    
    @IBOutlet weak var onClearBtn: UIView!
    @IBOutlet var lblCount : UILabel!
    
    @IBOutlet weak var lblHEading: UILabel!
    var arrayMain = [BuzzFeedModel]()
    var refreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleViewMain.register(UINib(nibName: "MainBudzFeedCell", bundle: nil), forCellReuseIdentifier: "MainBudzFeedCell")
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tbleViewMain.addSubview(refreshControl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func RefreshAPICall(sender:AnyObject){
        self.green_line.isHidden = false
        self.view_hight.constant = 1
        self.lblHEading.isHidden = true
        
        self.playSound(named: "refresh")
        self.GetAllNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.GetAllNotification()
        self.disableMenu()
        if DataManager.sharedInstance.getPermanentlySavedUser()!.notifications_count.intValue == 0 {
            self.green_line.isHidden = false
            self.view_hight.constant = 1
            self.lblHEading.isHidden = true
        }else{
            self.green_line.isHidden = false
            self.view_hight.constant = 25
              self.lblHEading.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
        self.enableMenu()
    }
    
    func GetAllNotification(){
        if !refreshControl.isRefreshing{
             self.showLoading()
        }
        self.arrayMain.removeAll()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_notifications.rawValue) { (successRespons, messageResponse, dataResponse) in
            self.hideLoading()
            self.refreshControl.endRefreshing()
            print(dataResponse)
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    if let data = dataResponse["successData"] as? [String : Any]{
                       let dataDuzzFeed = data["notifications"] as? [[String : Any]]
                        
                        for indexObj in dataDuzzFeed!{
                            self.arrayMain.append(BuzzFeedModel.init(json: indexObj as [String : AnyObject]))
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
            
            self.lblHEading.text = "\(DataManager.sharedInstance.getPermanentlySavedUser()!.notifications_count.intValue) New notifications since you last logged in"
            if self.arrayMain.count == 0
            {
                self.onClearBtn.isHidden = true
                self.tbleViewMain.setEmptyMessage()
            }else {
                 self.onClearBtn.isHidden = false
                self.tbleViewMain.backgroundView = nil
            }
            
            self.refreshControl.endRefreshing()
            self.tbleViewMain.reloadData()
        }
    }
    @IBAction func BackAction(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoHomeAction(sender : UIButton){
        self.GotoHome()
    }
    
    @IBAction func ClearAction(sender : UIButton){
        NetworkManager.GetCall(UrlAPI: "clear_all_notifications") { (success, messageResponse, maindata) in
            print(success)
            print(messageResponse)
            self.green_line.isHidden = false
            self.view_hight.constant = 1
            self.lblHEading.isHidden = true
            self.GetAllNotification()
        }
    }
}


extension MainBudzFeedViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMain.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainBudzFeedCell") as! MainBudzFeedCell
        if !(indexPath.row < self.arrayMain.count ){
             cell.selectionStyle = .none
            return cell
        }
        _ = [Any]()
        cell.lblDescription.applyTag(baseVC: self ,  mainText: self.arrayMain[indexPath.row].descriptionBuzzfeed)
        cell.lblName.text = self.arrayMain[indexPath.row].notification_text
        cell.lblDescription.text = self.arrayMain[indexPath.row].descriptionBuzzfeed
        cell.lblTime.text = self.GetTimeAgo(StringDate:self.arrayMain[indexPath.row].created_at)
        if self.arrayMain[indexPath.row].type == "Questions" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "QAQuestion")
            cell.lblName.textColor = ConstantsColor.kQuestionColor
            cell.lblDescription.textColor = ConstantsColor.kQuestionColor
            cell.lblTime.textColor = ConstantsColor.kQuestionColor
        }else if self.arrayMain[indexPath.row].type == "Likes" {
            let activty_model = self.arrayMain[indexPath.row].model
            if (activty_model.contains("Question")) {
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "0E6DC1")
                cell.lblName.textColor = UIColor.init(hex: "0E6DC1")
                cell.lblDescription.textColor = UIColor.init(hex: "0E6DC1")
                cell.lblTime.textColor = UIColor.init(hex: "0E6DC1")
            } else if (activty_model.contains("Answer")) {
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "0E6DC1")
                cell.lblName.textColor = UIColor.init(hex: "0E6DC1")
                cell.lblDescription.textColor = UIColor.init(hex: "0E6DC1")
                cell.lblTime.textColor = UIColor.init(hex: "0E6DC1")
            } else if (activty_model.contains("Strains") || activty_model.contains("Strain") || activty_model.contains("UserStrainLike")) {
                
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "F4C42E")
                cell.lblName.textColor = UIColor.init(hex: "F4C42E")
                cell.lblDescription.textColor = UIColor.init(hex: "F4C42E")
                cell.lblTime.textColor = UIColor.init(hex: "F4C42E")
            } else if (activty_model.contains("Groups")) {
                
            } else if (activty_model.contains("Budz Map") || activty_model.contains("Budz Adz") || activty_model.contains("SubUser")) {
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "942B88")
                cell.lblName.textColor = UIColor.init(hex: "942B88")
                cell.lblDescription.textColor = UIColor.init(hex: "942B88")
                cell.lblTime.textColor = UIColor.init(hex: "942B88")
            } else if (activty_model.contains("Journal")) {
                
            } else if (activty_model.contains("ShoutOutLike")) {
                
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "D551D8")
                cell.lblName.textColor = UIColor.init(hex: "D551D8")
                cell.lblDescription.textColor = UIColor.init(hex: "D551D8")
                cell.lblTime.textColor = UIColor.init(hex: "D551D8")
            } else if (activty_model.contains("UserPost")) {
                
                cell.imgViewMain.image = #imageLiteral(resourceName: "Qa_LikeS").withRenderingMode(.alwaysTemplate)
                cell.imgViewMain.tintColor = UIColor.init(hex: "80C548")
                cell.lblName.textColor = UIColor.init(hex: "80C548")
                cell.lblDescription.textColor = UIColor.init(hex: "80C548")
                cell.lblTime.textColor = UIColor.init(hex: "80C548")
            }
        }else if self.arrayMain[indexPath.row].type == "Favorites" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "QALike_Fill")
            cell.lblName.textColor = ConstantsColor.kQuestionColor
            cell.lblDescription.textColor = ConstantsColor.kQuestionColor
            cell.lblTime.textColor = ConstantsColor.kQuestionColor
        }else if self.arrayMain[indexPath.row].type == "Users" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "ic_feed_user")
            cell.lblName.textColor = UIColor.init(hex: "979797")
            cell.lblDescription.textColor = UIColor.init(hex: "979797")
            cell.lblTime.textColor = UIColor.init(hex: "979797")
        }else if self.arrayMain[indexPath.row].type == "Chat" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "Chat_tab_qa")
            cell.lblName.textColor = ConstantsColor.kStrainGreenColor
            cell.lblDescription.textColor = ConstantsColor.kStrainGreenColor
            cell.lblTime.textColor = UIColor.init(hex: "545454")
        }else  if self.arrayMain[indexPath.row].type == "Answers" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "QAAnswer")
            cell.lblName.textColor = ConstantsColor.kQuestionColor
            cell.lblDescription.textColor = ConstantsColor.kQuestionColor
            cell.lblTime.textColor = ConstantsColor.kQuestionColor
        }else if self.arrayMain[indexPath.row].type == "Budz" || self.arrayMain[indexPath.row].type == "BudzChat"{
            cell.imgViewMain.image = #imageLiteral(resourceName: "tab_map")
            cell.lblName.textColor = UIColor.init(hex: "942B88")
            cell.lblDescription.textColor =  UIColor.init(hex: "942B88")
            cell.lblTime.textColor =  UIColor.init(hex: "942B88")
        }else if self.arrayMain[indexPath.row].type == "UserStrain"  || self.arrayMain[indexPath.row].type == "Strains" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "tab_strain")
            cell.lblName.textColor = UIColor.init(hex: "F4C42E")
            cell.lblDescription.textColor =  UIColor.init(hex: "F4C42E")
            cell.lblTime.textColor =  UIColor.init(hex: "F4C42E")
        }else if self.arrayMain[indexPath.row].type == "Tags" ||  self.arrayMain[indexPath.row].type == "Admin"{
            cell.imgViewMain.image = #imageLiteral(resourceName: "QATag")
            if self.arrayMain[indexPath.row].type == "Admin" {
                cell.imgViewMain.image = #imageLiteral(resourceName: "admin")
            }
            cell.lblName.textColor = UIColor.init(hex: "5CA71A")
            cell.lblDescription.textColor =  UIColor.init(hex: "5CA71A")
            cell.lblTime.textColor =  UIColor.init(hex: "5CA71A")
        }else if self.arrayMain[indexPath.row].type == "Budz Map" || self.arrayMain[indexPath.row].type == "Budz Adz" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "tab_map")
            cell.lblName.textColor = UIColor.init(hex: "942B88")
            cell.lblDescription.textColor =  UIColor.init(hex: "942B88")
            cell.lblTime.textColor =  UIColor.init(hex: "942B88")
        }else if self.arrayMain[indexPath.row].type == "ShoutOut" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "shoot_out_purpole")
            cell.lblName.textColor = UIColor.init(hex: "D551D8")
            cell.lblDescription.textColor =  UIColor.init(hex: "D551D8")
            cell.lblDescription.text = ""
            cell.lblTime.textColor =  UIColor.init(hex: "D551D8")
        }else if self.arrayMain[indexPath.row].type == "Post" {
            cell.imgViewMain.image = #imageLiteral(resourceName: "social-wall-green")
            cell.lblName.textColor = UIColor.init(hex: "80C548")
            cell.lblDescription.textColor =  UIColor.init(hex: "80C548")
            cell.lblTime.textColor =  UIColor.init(hex: "80C548")
        }else if self.arrayMain[indexPath.row].type == "Comment" {
//            cell.imgViewMain.image = #imageLiteral(resourceName: "comments-icon")
//            cell.lblName.textColor = UIColor.init(hex: "A3A2A1")
//            cell.lblDescription.textColor =  UIColor.init(hex: "A3A2A1")
//            cell.lblTime.textColor =  UIColor.init(hex: "A3A2A1")
            cell.imgViewMain.image = #imageLiteral(resourceName: "comments-icon").withRenderingMode(.alwaysTemplate)
            cell.imgViewMain.tintColor = UIColor.init(hex: "80C548")
            cell.lblName.textColor = UIColor.init(hex: "80C548")
            cell.lblDescription.textColor = UIColor.init(hex: "80C548")
            cell.lblTime.textColor = UIColor.init(hex: "80C548")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DataElement = self.arrayMain[indexPath.row]
        let dataType = self.arrayMain[indexPath.row].type
        let MainDAta = self.arrayMain[indexPath.row]
        let modelType = MainDAta.model
        switch dataType{
        case ActivityLog.Liked.rawValue , ActivityLog.Favourites.rawValue ,ActivityLog.Tags.rawValue, "Likes", "Favorites", "Tags":
            if modelType.contains("Question") ||  modelType.contains("Questions") ||  modelType.contains("Answers") {
                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                DetailQuestionVc.QuestionID = String(MainDAta.type_id)
                DetailQuestionVc.isFromProfile = false
                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
            }else if modelType.contains("Strains") ||  modelType.contains("Strain") {
                let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
                detailView.IDMain = "\(MainDAta.type_id)"
                self.navigationController?.pushViewController(detailView, animated: true)
            }else if modelType.contains("ShoutOutLike") {
                self.openShoutOutPopup(id: String(MainDAta.type_id))
            }else if modelType.contains("SubUser") ||  modelType.contains("Budz Map") || modelType.contains("Budz Adz") {
                let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
                viewpush.budz_map_id = String(MainDAta.type_id)
                self.navigationController?.pushViewController(viewpush, animated: true)
            }else if modelType.contains("UserPost") {
                self.openPost(index: String(MainDAta.type_id))
            }
            break
            
        case "ShoutOut":
            if modelType.contains("ShoutOut") {
                self.openShoutOutPopup(id: String(MainDAta.type_id))
            }
        case "Users":
            self.OpenProfileVC(id: String(MainDAta.type_id))
            break
        case "BudzChat" :
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
            vc.msg_data_modal = Message()
            vc.msg_data_modal.sender_id = MainDAta.user_id
            vc.msg_data_modal.sender_first_name = MainDAta.notification_text.replacingOccurrences(of: " send you a budz message.", with: "").replacingOccurrences(of: " sent you a private message.", with: "")
            vc.msg_data_modal.receiver_id = Int((DataManager.sharedInstance.user?.ID)!)!
            vc.isFromFeed = 1
            vc.nameOther = MainDAta.notification_text.replacingOccurrences(of: " send you a budz message.", with: "").replacingOccurrences(of: " sent you a private message.", with: "")
            vc.isSelectUser = false
            vc.chat_id = "\(MainDAta.type_id)"
            vc.bud_map_id = "\(MainDAta.type_sub_id)"
            self.navigationController?.pushViewController(vc, animated: true)
           
            break
        case "Chat" :
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
            
            vc.isSelectUser = false
            vc.msg_data_modal = Message()
            vc.msg_data_modal.sender_id = MainDAta.user_id
            vc.msg_data_modal.sender_first_name = MainDAta.notification_text.replacingOccurrences(of: " sent you a private message.", with: "")
            vc.msg_data_modal.receiver_id = Int((DataManager.sharedInstance.user?.ID)!)!
//            vc.msg_data_modal.ch
            vc.isFromFeed = 1
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case ActivityLog.Answered.rawValue, "Answers" ,"Answer" :
            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
            DetailQuestionVc.QuestionID = String(MainDAta.type_id)
            DetailQuestionVc.isFromProfile = false
            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
            break
        case ActivityLog.followingBud.rawValue :
            
            break
        case ActivityLog.QuestionAsked.rawValue, "Questions" , "Question" :
            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
            DetailQuestionVc.QuestionID = String(MainDAta.type_id)
            DetailQuestionVc.isFromProfile = false
            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
            break
        case ActivityLog.strainAdd.rawValue, "Strains" :
            let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
            detailView.IDMain = "\(MainDAta.type_id)"
            self.navigationController?.pushViewController(detailView, animated: true)
            break
        case ActivityLog.Comment.rawValue, ActivityLog.Post.rawValue , "Post" , "Posts" , "Comments" ,"Comment" :
            self.openPost(index:String(MainDAta.type_id))
            break
        default:
            break
        }
    }
}

extension BaseViewController{
    func openShoutOutPopup(id : String) {
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: "shout_detail/"+id) { (successRespons, messageResponse, dataResponse) in
            self.hideLoading()
            if successRespons {
                let mainData = dataResponse["successData"] as! [String : Any]
                if let shout_out_objt  = mainData["shout_outs"] as? [String : AnyObject]{
                    let shout_out =   ShoutOut.init(json: shout_out_objt)
                    let storyboard = UIStoryboard(name: "ShoutOut", bundle: nil)
                    let customAlert = storyboard.instantiateViewController(withIdentifier: "ShoutOutDetailsVC") as! ShoutOutDetailsVC
                    customAlert.shoutOutObj = shout_out
                    customAlert.navigation = self.navigationController
                    customAlert.providesPresentationContextTransitionStyle = true
                    customAlert.definesPresentationContext = true
                    customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(customAlert, animated: false, completion: nil)
                }
            }else{
                self.ShowErrorAlert(message: messageResponse)
            }
            
        }
    }
}


class MainBudzFeedCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDescription : ActiveLabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var imgViewMain : UIImageView!
}
