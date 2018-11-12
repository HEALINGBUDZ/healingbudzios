//
//  DetailQAViewController.swift
//  BaseProject
//
//  Created by macbook on 15/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import AVKit
import GoogleMobileAds
import SDWebImage

class DetailQAViewController: BaseViewController , GADInterstitialDelegate {
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var status_barBG: UIView!
    @IBOutlet weak var stickyHeaderView: UIView!
    
    @IBOutlet weak var headerQuestionText: UILabel!
    
    
    var isFromProfile : Bool = false
    @IBOutlet var tbleView_Main         : UITableView!
    var isEditQuestion : Bool = false
    @IBOutlet weak var viewFilter: UIView!
    
    @IBOutlet var tbleView_Report        : UITableView!
    var isFliterviewOpen = false
    var isFromNewAnser : Bool = false
    var chooseQuestion = QA()
    var QuestionID = ""
    var isRefreshApiCall = false
    var reportValue = QAReport.Answer.rawValue
    var isCountCellShwow = false
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var ReportTopValue   : NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    var isReportOpen  = false
    var array_Report = [[String : String]]()
    var array_Answers = [Answer]()
    var choose_Answers = Answer()
    var interstitial: GADInterstitial!
    var isAddLoadingFailed = true
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbleView_Report.tag = -1000
        self.RegisterXib()
        
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tbleView_Main.addSubview(refreshControl)
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        self.refreshControl.endRefreshing()
        isRefreshApiCall = true
        self.GetAnswers()  
    }
    func hideStickyHeader() {
        self.stickyHeaderView.isHidden = true
        self.status_barBG.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.headerHeightConstraint.constant = 0
            self.status_barBG.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func showStickyHeader() {
        self.stickyHeaderView.isHidden = false
        self.status_barBG.isHidden = false
        self.status_barBG.backgroundColor = UIColor.black
        self.status_barBG.alpha = 0.5
        UIView.animate(withDuration: 0.5, animations: {
            self.headerHeightConstraint.constant = 100
             self.status_barBG.alpha = 1.0
            self.view.layoutIfNeeded()
        })
       
    }
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFliterviewOpen {
                isFliterviewOpen = false
                self.tbleView_Main.isScrollEnabled = true
                self.tbleView_Main.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.tbleView_Main.alpha = 1.0
                    self.ReportTopValue.constant = -500 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFliterviewOpen {
                    isFliterviewOpen = false
                    self.tbleView_Main.isScrollEnabled = true
                    self.tbleView_Main.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tbleView_Main.alpha = 1.0
                        self.ReportTopValue.constant = -500 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func showAdd() {
        self.showLoading()
        if  appdelegate.interstitial.isReady{
            self.interstitial = appdelegate.interstitial
            self.appdelegate.interstitial.present(fromRootViewController: self)
        }else{
            self.interstitial = createAndLoadInterstitial()
            self.interstitial.present(fromRootViewController: self)
        }
    }
    
  func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/8691691433")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        self.hideLoading()
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        if isAddLoadingFailed{
            self.hideLoading()
             isAddLoadingFailed = false
            self.oneBtnCustomeAlert(title: "", discription: "\(error.localizedDescription)") { (isCom, btn) in
                if self.QuestionID.count > 0 {
                    self.GetQuestionWithAnswers()
                }else {
                    self.GetAnswers()
                }
            }
        }
        interstitial = createAndLoadInterstitial()
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        self.hideLoading()
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        self.apiCallForAddStatusUpdate()
        self.hideLoading()
        if QuestionID.count > 0 {
            self.GetQuestionWithAnswers()
        }else {
            self.GetAnswers()
        }
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        self.hideLoading()
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
        self.hideLoading()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.saveView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.view.layoutIfNeeded()
        
        if QuestionID.count > 0  ||  self.isEditQuestion{
            self.GetQuestionWithAnswers()
        }else {
            if self.chooseQuestion.show_ads == 1
                && self.chooseQuestion.user_id == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!
                && self.chooseQuestion.AnswerCount > 0
            {
                 self.GetAnswers()
            }else{
                 self.GetAnswers()
            }
           
        }
    }
    
    func apiCallForAddStatusUpdate()  {
        var param = [String : AnyObject]()
        param["question_id"] = self.chooseQuestion.id as AnyObject
        param["show_ads"] =  0 as AnyObject
        NetworkManager.PostCall(UrlAPI: "change_show_ads_status" , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func GetQuestionWithAnswers(){
        self.showLoading()
        
        var urlMain = WebServiceName.get_question.rawValue + String(self.QuestionID)
        if  self.isEditQuestion{
            urlMain = WebServiceName.get_question.rawValue + String(self.chooseQuestion.id)
        }
        print(urlMain)
        NetworkManager.GetCall(UrlAPI: urlMain) { (successResponse, messageResponse, dataResponse) in
            self.array_Answers.removeAll()
            print(successResponse)
            print(messageResponse)
            print(dataResponse)
            self.hideLoading()
            
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    let mainData = dataResponse["successData"] as! [[String : AnyObject]]
                    if mainData.count > 0 {
                        self.chooseQuestion.id = mainData.first!["id"] as! Int
                        self.chooseQuestion.Question = mainData.first!["question"] as! String
                        self.chooseQuestion.special_icon = mainData.first!["get_user"]!["special_icon"] as? String ?? ""
                        if let arrayAttachment = mainData.first![kattachments] as? [[String : AnyObject]] {
                            self.chooseQuestion.attachments.removeAll()
                            for indexObj in arrayAttachment{
                                self.chooseQuestion.attachments.append(Attachment.init(json: indexObj))
                            }
                        }

                        self.chooseQuestion.Question = self.chooseQuestion.Question.RemoveHTMLTag().RemoveBRTag()
                        self.chooseQuestion.Question_description = mainData.first!["description"] as! String
                        if let varr  = mainData.first!["user_notify"] as? Int {
                            self.chooseQuestion.user_notify = String(varr)
                            
                        }else {
                            self.chooseQuestion.user_notify = mainData.first!["user_notify"] as? String ?? "0"
                            
                        }
//                        self.chooseQuestion.user_notify = mainData.first!["user_notify"] as! Int
                        self.chooseQuestion.Question_description = self.chooseQuestion.Question_description.RemoveHTMLTag().RemoveBRTag()
                        self.chooseQuestion.created_at = mainData.first!["created_at"] as! String
                        self.chooseQuestion.updated_at = mainData.first!["updated_at"]  as! String
                        self.chooseQuestion.AnswerCount = mainData.first![KQA_AnswerCount] as? Int ?? 0
                        if self.chooseQuestion.AnswerCount == 0 {
                            if let answerCount = mainData.first!["answers_sum"] as? [[String : AnyObject]]{
                                if answerCount.count > 0 {
                                    if let total = answerCount[0]["total"] as? String{
                                        self.chooseQuestion.AnswerCount = Int(total)!
                                    }else{
                                        self.chooseQuestion.AnswerCount = 0
                                    }
                                    
                                }else{
                                    self.chooseQuestion.AnswerCount = 0
                                }
                            }else{
                                self.chooseQuestion.AnswerCount = 0
                            }
                        }
                        self.chooseQuestion.user_id = mainData.first!["user_id"] as! Int
                        if let show_add = mainData.first!["show_ads"] as? String {
                            self.chooseQuestion.show_ads   = Int(show_add)!
                        }
                        
                        self.chooseQuestion.get_user_flag_count = mainData.first!["get_user_flag_count"] as! Int
                        self.chooseQuestion.get_user_likes_count = mainData.first!["get_user_likes_count"] as! Int
                        if let user = mainData.first!["get_user"] as? [String : Any]{
                            if let photoPath = user["image_path"] as? String {
                                    self.chooseQuestion.user_photo = WebServiceName.images_baseurl.rawValue + photoPath
                            }else {
                                if let avater = user["avatar"] as? String {
                                     self.chooseQuestion.user_photo = WebServiceName.images_baseurl.rawValue + (avater)
                                }else{
                                    self.chooseQuestion.user_photo = ""
                                }
                               
                            }
                            self.chooseQuestion.user_name = (user["first_name"] as? String)!
                        }
                        for indexObj in (mainData.first!["get_answers"] as! [[String : AnyObject]]){
                            self.array_Answers.append(Answer.init(json: indexObj))
                        }
                        
                        if self.chooseQuestion.show_ads == 1
                            && self.chooseQuestion.user_id == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)!
                            && self.chooseQuestion.AnswerCount > 0
                        {
//                            self.showAdd()
                             self.GetAnswers()
                        }else{
                            self.GetAnswers()
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
            
            self.isCountCellShwow = false
            if self.array_Answers.count == 0 {
                if self.chooseQuestion.user_id == Int(DataManager.sharedInstance.user!.ID) {
                    self.isCountCellShwow = true
                }
            }
            self.mainView.isHidden = true
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.tbleView_Main.reloadData()
        }
    }
    
    func editQuestion(sender: UIButton!){
        self.isEditQuestion = true
        let next = self.GetView(nameViewController: "AskQuestionViewController", nameStoryBoard: "QAStoryBoard") as! AskQuestionViewController
        next.chooseQuestion = self.chooseQuestion
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func GetAnswers(){
        self.showLoading()
        let urlMain = WebServiceName.get_answers.rawValue + String(self.chooseQuestion.id)
        print(urlMain)
        NetworkManager.GetCall(UrlAPI: urlMain) { (successResponse, messageResponse, dataResponse) in
            print(successResponse)
             self.array_Answers.removeAll()
            print(messageResponse)
            print(dataResponse)
            self.hideLoading()
            
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    let mainData = dataResponse["successData"] as! [[String : AnyObject]]
                    
                    for indexObj in mainData {
                        self.array_Answers.append(Answer.init(json: indexObj))
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
            
            self.isCountCellShwow = false
            
            if self.array_Answers.count == 0 {
                if self.chooseQuestion.user_id == Int(DataManager.sharedInstance.user!.ID) {
                    self.isCountCellShwow = true
                }
            }
            self.mainView.isHidden = true
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.tbleView_Main.reloadData()
            
            if self.isRefreshApiCall{
                self.isRefreshApiCall = false
                self.hideStickyHeader()
            }
            
        }
    }
    @IBAction func onClickCanel(sender : UIButton){
        
        self.saveView.isHidden = true
    }
    
    @IBAction func onClickGotit(sender : UIButton){
        
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            sender.setImage(UIImage(named: "Check_Round_S"), for: UIControlState.normal)
            UserDefaults.standard.set(true, forKey: "QAPopup")
            UserDefaults.standard.synchronize()
        }
        else{
            sender.setImage(UIImage(named: "Check_Round_U"), for: UIControlState.normal)
            UserDefaults.standard.set(false, forKey: "QAPopup")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    func RegisterXib(){
        self.tbleView_Main.register(UINib(nibName: "DetailQACell", bundle: nil), forCellReuseIdentifier: "DetailQACell")
        
        self.tbleView_Main.register(UINib(nibName: "DetailQAQuestionCell", bundle: nil), forCellReuseIdentifier: "DetailQAQuestionCell")
        
          self.tbleView_Main.register(UINib(nibName: "GoogleAddCell", bundle: nil), forCellReuseIdentifier: "GoogleAddCell")

        self.tbleView_Main.register(UINib(nibName: "NoanswerCEll", bundle: nil), forCellReuseIdentifier: "NoanswerCEll")
        
        self.tbleView_Report.register(UINib(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        
        
        self.tbleView_Report.register(UINib(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        
        self.tbleView_Report.register(UINib(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        
        self.tbleView_Report.register(UINib(nibName: "DetailQAQuestionCell", bundle: nil), forCellReuseIdentifier: "DetailQAQuestionCell")

        self.tbleView_Main.reloadData()
    }
    
     func ShowFilterView(sender : UIButton){
        if(self.array_Answers[sender.tag].userMain.ID != DataManager.sharedInstance.user?.ID){
            if Int(self.array_Answers[sender.tag].flag_by_user_count)! == 0 {
                 self.choose_Answers = self.array_Answers[sender.tag]
                self.isReportOpen = true
                self.tbleView_Main.isScrollEnabled = false
                self.tbleView_Main.isUserInteractionEnabled = false
                self.RefreshFilterArray()
                isFliterviewOpen = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.tbleView_Main.alpha = 0.2
                    self.ReportTopValue.constant = -26 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                })
            }
            
        }else {
            self.ShowErrorAlert(message: "you can't report your own answer!")
        }
    }
    
    @IBAction func HideFilterView(sender : UIButton){
         isFliterviewOpen = false
        self.tbleView_Main.isScrollEnabled = true
        self.tbleView_Main.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tbleView_Main.alpha = 1.0
            self.ReportTopValue.constant = -500 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    func ChooseReportOption(value : Int){
        
        print("value \(value)")
        switch value {
        case 1:
            self.reportValue = QAReport.Nudity.rawValue
            break
        case 2:
            self.reportValue = QAReport.harassment.rawValue
            break
        case 3:
            self.reportValue = QAReport.violent.rawValue
            break
        case 4:
            self.reportValue = QAReport.Answer.rawValue
            break
        case 5:
            self.reportValue = QAReport.Spam.rawValue
            break
        case 6:
            self.reportValue = QAReport.Unrelated.rawValue
            break
            
        default:
            break;
        }
    }
}

//MARK:
//MARK: Table view Delegates
extension DetailQAViewController : UITableViewDelegate ,  UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isCountCellShwow {
            return 1
        }
        if isReportOpen && tableView.tag == -1000{
            return self.array_Report.count
        }
        return self.array_Answers.count + 1 //+ (Int(self.array_Answers.count/10))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tbleView_Main.contentOffset.y > 350 {
            if self.stickyHeaderView.isHidden{
                 self.showStickyHeader()
            }
        }else{
            if !self.stickyHeaderView.isHidden{
                self.hideStickyHeader()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isReportOpen && tableView.tag == -1000 {
            if indexPath.row == 0 {
                return self.ReportHeadingCell(tableView, cellForRowAt: indexPath)
            }else if indexPath.row == self.array_Report.count - 1 {
                
                return self.SendButtonCell(tableView, cellForRowAt: indexPath)
                
            }else {
                return self.ReportOptionCell(tableView, cellForRowAt: indexPath)
            }
            
        }else {
            if isCountCellShwow {
                let cellDetail = tableView.dequeueReusableCell(withIdentifier: "NoanswerCEll") as! NoanswerCEll
                cellDetail.lbl_QuestionDescription.applyTag(baseVC: self , mainText: self.chooseQuestion.Question_description)
                cellDetail.lbl_QuestionTitle.applyTag(baseVC: self , mainText: self.chooseQuestion.Question)
                if self.chooseQuestion.attachments.count > 0{
                    cellDetail.attachmentView.isHidden = false
                    cellDetail.attachmentViewHeight.constant = 50
                    cellDetail.attachmentImage1.isHidden = true
                    cellDetail.attachmentImage2.isHidden = true
                    cellDetail.attachmentImage3.isHidden = true
                    cellDetail.videoIcon1.isHidden = true
                    cellDetail.videoIcon2.isHidden = true
                    cellDetail.videoIcon3.isHidden = true
                    cellDetail.imageButton1.isHidden = true
                    cellDetail.imageButton2.isHidden = true
                    cellDetail.imageButton3.isHidden = true
                    for i in 0..<self.chooseQuestion.attachments.count{
                        switch i{
                        case 0:
                            cellDetail.attachmentImage1.isHidden = false
                            cellDetail.imageButton1.isHidden = false
                            cellDetail.attachmentImage1.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon1.isHidden = false
                            }else{
                                cellDetail.videoIcon1.isHidden = true
                            }
                            cellDetail.imageButton1.tag = 100
                            cellDetail.imageButton1.addTarget(self, action: #selector(self.OnClickAttachemntOne(sender:)), for: .touchUpInside)
                        case 1:
                            cellDetail.attachmentImage2.isHidden = false
                            cellDetail.imageButton2.isHidden = false
                            cellDetail.attachmentImage2.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon2.isHidden = false
                            }else{
                                cellDetail.videoIcon2.isHidden = true
                            }
                            cellDetail.imageButton2.tag = 200
                            cellDetail.imageButton2.addTarget(self, action: #selector(self.OnClickAttachemntTwo(sender:)), for: .touchUpInside)
                        case 2:
                            cellDetail.attachmentImage3.isHidden = false
                            cellDetail.imageButton3.isHidden = false
                            cellDetail.attachmentImage3.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon3.isHidden = false
                            }else{
                                cellDetail.videoIcon3.isHidden = true
                            }
                            cellDetail.imageButton3.tag = 300
                            cellDetail.imageButton3.addTarget(self, action: #selector(self.OnClickAttachemntThree(sender:)), for: .touchUpInside)
                        default:
                            cellDetail.attachmentView.isHidden = false
                            cellDetail.attachmentImage1.isHidden = true
                            cellDetail.attachmentImage2.isHidden = true
                            cellDetail.attachmentImage3.isHidden = true
                            cellDetail.videoIcon1.isHidden = true
                            cellDetail.videoIcon2.isHidden = true
                            cellDetail.videoIcon3.isHidden = true
                            cellDetail.imageButton1.isHidden = true
                            cellDetail.imageButton2.isHidden = true
                            cellDetail.imageButton3.isHidden = true
                        }
                    }
                }else{
                    cellDetail.attachmentView.isHidden = true
                    cellDetail.attachmentViewHeight.constant = 0
                }
                cellDetail.lbl_Count.text = self.chooseQuestion.user_notify + " Budz have been notified."
                cellDetail.lbl_QuestionTitle.text = self.chooseQuestion.Question
                cellDetail.lbl_Time.text = self.chooseQuestion.created_at.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MMM. dd, yyyy, h:mm a")
                cellDetail.lbl_QuestionDescription.text = self.chooseQuestion.Question_description
                cellDetail.btn_Menu.addTarget(self, action: #selector(self.OpenMenu), for: .touchUpInside)
                cellDetail.imgView_UserProfile.image = #imageLiteral(resourceName: "ic_profile_blue")
                cellDetail.imgView_UserProfile.RoundView()
                cellDetail.edit_btn.addTarget(self, action: #selector(self.editQuestion), for: .touchUpInside)
                if self.isFromProfile{
                    cellDetail.lbl_UserName.text = UserProfileViewController.userMain.userFirstName
                    if UserProfileViewController.userMain.profilePictureURL.contains("facebook.com"){
                        cellDetail.imgView_UserProfile.sd_setImage(with: URL.init(string: UserProfileViewController.userMain.profilePictureURL.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "ic_profile_blue") ,completed: nil)
                    }else{
                         cellDetail.imgView_UserProfile.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.profilePictureURL.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "ic_profile_blue") ,completed: nil)

                    }
                    if UserProfileViewController.userMain.special_icon.count > 6 {
                        cellDetail.imgView_UserProfileTop.isHidden = false
                        cellDetail.imgView_UserProfileTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic") ,completed: nil)
                    }else {
                        cellDetail.imgView_UserProfileTop.isHidden = true
                    }
                }else{
                    cellDetail.lbl_UserName.text = self.chooseQuestion.user_name
                    cellDetail.imgView_UserProfile.sd_setImage(with: URL.init(string: self.chooseQuestion.user_photo.RemoveSpace()), completed: nil)
                    if self.chooseQuestion.special_icon.count > 6 {
                        cellDetail.imgView_UserProfileTop.isHidden = false
                        cellDetail.imgView_UserProfileTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic") ,completed: nil)
                    }else {
                        cellDetail.imgView_UserProfileTop.isHidden = true
                    }
                }
                self.view.layoutIfNeeded()
                cellDetail.selectionStyle = .none
                return cellDetail
            }else if indexPath.row == 0 {
                let cellDetail = tableView.dequeueReusableCell(withIdentifier: "DetailQAQuestionCell") as! DetailQAQuestionCell
                cellDetail.lbl_QuestionDescription.applyTag(baseVC: self , mainText:  self.chooseQuestion.Question_description + "\n")
                cellDetail.lbl_QuestionTitle.applyTag(baseVC: self , mainText: self.chooseQuestion.Question)
                cellDetail.imgView_UserProfile.image = #imageLiteral(resourceName: "ic_profile_blue")
                cellDetail.imgView_UserProfile.RoundView()
                if self.chooseQuestion.attachments.count > 0{
                    cellDetail.attachmentView.isHidden = false
                    cellDetail.attachmentViewHeight.constant = 50
                    cellDetail.attachmentImage1.isHidden = true
                    cellDetail.attachmentImage2.isHidden = true
                    cellDetail.attachmentImage3.isHidden = true
                    cellDetail.videoIcon1.isHidden = true
                    cellDetail.videoIcon2.isHidden = true
                    cellDetail.videoIcon3.isHidden = true
                    cellDetail.imageButton1.isHidden = true
                    cellDetail.imageButton2.isHidden = true
                    cellDetail.imageButton3.isHidden = true
                    for i in 0..<self.chooseQuestion.attachments.count{
                        switch i{
                        case 0:
                            cellDetail.attachmentImage1.isHidden = false
                            cellDetail.imageButton1.isHidden = false
                            cellDetail.attachmentImage1.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon1.isHidden = false
                            }else{
                                cellDetail.videoIcon1.isHidden = true
                            }
                            cellDetail.imageButton1.tag = 100
                            cellDetail.imageButton1.addTarget(self, action: #selector(self.OnClickAttachemntOne(sender:)), for: .touchUpInside)
                        case 1:
                            cellDetail.attachmentImage2.isHidden = false
                            cellDetail.imageButton2.isHidden = false
                            cellDetail.attachmentImage2.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon2.isHidden = false
                            }else{
                                cellDetail.videoIcon2.isHidden = true
                            }
                            cellDetail.imageButton2.tag = 200
                            cellDetail.imageButton2.addTarget(self, action: #selector(self.OnClickAttachemntTwo(sender:)), for: .touchUpInside)
                        case 2:
                            cellDetail.attachmentImage3.isHidden = false
                            cellDetail.imageButton3.isHidden = false
                            cellDetail.attachmentImage3.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                            if self.chooseQuestion.attachments[i].is_Video{
                                cellDetail.videoIcon3.isHidden = false
                            }else{
                                cellDetail.videoIcon3.isHidden = true
                            }
                            cellDetail.imageButton3.tag = 300
                            cellDetail.imageButton3.addTarget(self, action: #selector(self.OnClickAttachemntThree(sender:)), for: .touchUpInside)
                        default:
                            cellDetail.attachmentView.isHidden = false
                            cellDetail.attachmentImage1.isHidden = true
                            cellDetail.attachmentImage2.isHidden = true
                            cellDetail.attachmentImage3.isHidden = true
                            cellDetail.videoIcon1.isHidden = true
                            cellDetail.videoIcon2.isHidden = true
                            cellDetail.videoIcon3.isHidden = true
                            cellDetail.imageButton1.isHidden = true
                            cellDetail.imageButton2.isHidden = true
                            cellDetail.imageButton3.isHidden = true
                        }
                    }
                }else{
                    cellDetail.attachmentView.isHidden = true
                    cellDetail.attachmentViewHeight.constant = 0
                }
                cellDetail.lbl_UserName.text = self.chooseQuestion.user_name
                cellDetail.imgView_UserProfile.sd_setImage(with: URL.init(string: self.chooseQuestion.user_photo.RemoveSpace()),placeholderImage: #imageLiteral(resourceName: "ic_profile_blue") ,completed: nil)
                if self.chooseQuestion.special_icon.count > 6 {
                    cellDetail.imgView_UserProfileTop.isHidden = false
                    cellDetail.imgView_UserProfileTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.chooseQuestion.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic") ,completed: nil)
                }else {
                    cellDetail.imgView_UserProfileTop.isHidden = true
                }
                cellDetail.lbl_QuestionTitle.text = self.chooseQuestion.Question
                cellDetail.lbl_Time.text = self.chooseQuestion.created_at.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MMM. dd, yyyy, h:mm a")
                cellDetail.lbl_QuestionDescription.text = self.chooseQuestion.Question_description + "\n"
                cellDetail.btn_Menu.addTarget(self, action: #selector(self.OpenMenu), for: .touchUpInside)
                 cellDetail.btn_AnswerYourBud.addTarget(self, action: #selector(self.AnswerYourBud), for: .touchUpInside)
                cellDetail.btn_UserProfile.tag = indexPath.row
                 cellDetail.btn_UserProfile.addTarget(self, action: #selector(self.OpenUserProfileQuestion(sender:)), for: .touchUpInside)
                cellDetail.btn_Share.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
                self.headerQuestionText.text = self.chooseQuestion.Question
                cellDetail.imgView_Like.image = #imageLiteral(resourceName: "QALike")
                print(self.chooseQuestion.get_user_likes_count)
                print(self.chooseQuestion.isFavorite)
                if self.chooseQuestion.get_user_likes_count == 1 {
                    cellDetail.imgView_Like.image = #imageLiteral(resourceName: "QALike_Fill")
                }
                cellDetail.btn_Like.addTarget(self, action: #selector(self.AddLike), for: .touchUpInside)
                cellDetail.selectionStyle = .none
                return cellDetail
            }else {
                if (false) { // (indexPath.row-1) % 10 == 0 && indexPath.row > 8
                    let add_cell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddCell") as! GoogleAddCell
                    self.addBannerViewToView(add_cell.add_view)
                    add_cell.selectionStyle = .none
                    return add_cell
                }else{
                    let cellAnswer = tableView.dequeueReusableCell(withIdentifier: "DetailQACell") as! DetailQACell
                    _ = (Int(indexPath.row/10))
                    let IndexObj = indexPath.row - 1 // - decreased_index
                    if IndexObj == 0 {
                        cellAnswer.immgTopConstraint.constant = 20
                    }else{
                         cellAnswer.immgTopConstraint.constant = 10
                    }
                    cellAnswer.lbl_Ans.applyTag(baseVC: self , mainText: self.array_Answers[IndexObj].answer)
                    cellAnswer.first_btn.setTitle(String(format:"%d BUDZ ANSWERED",self.array_Answers.count), for: UIControlState.normal)
                    if indexPath.row == 1 {
                        cellAnswer.first_btn.isHidden = false
                        cellAnswer.first_btn_hide.constant = 48
                    }else{
                       cellAnswer.first_btn.isHidden = true
                       cellAnswer.first_btn_hide.constant = 12
                       cellAnswer.first_btn.setTitle("", for: UIControlState.normal)

                    }
                    cellAnswer.Btn_UserProfile.tag = IndexObj
                    cellAnswer.Btn_UserProfile.addTarget(self, action: #selector(self.OpenUserProfile), for: .touchUpInside)

                    cellAnswer.Img_Add.isHidden = false
                    if self.array_Answers[IndexObj].userMain.ID == DataManager.sharedInstance.user?.ID {
                        cellAnswer.Img_Add.isHidden = true
                    }else if Int(self.array_Answers[IndexObj].is_following_count) == 1 {
                        cellAnswer.Img_Add.image = #imageLiteral(resourceName: "crossQA")
                    }else if Int(self.array_Answers[IndexObj].is_following_count) == 0 {
                        cellAnswer.Img_Add.image = #imageLiteral(resourceName: "AddGreen")
                    }else {
                        cellAnswer.Img_Add.isHidden = true
                    }

                    cellAnswer.lbl_Ans.text = self.array_Answers[IndexObj].answer
                    cellAnswer.Img_user_main.image = #imageLiteral(resourceName: "ic_profile_blue")
                    var path_url = ""

                    if (self.array_Answers[IndexObj].userMain.profilePictureURL.contains("avatar")){
                        path_url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].userMain.profilePictureURL
                    }else{
                        if (self.array_Answers[IndexObj].userMain.profilePictureURL.contains("facebook.com")) || (self.array_Answers[IndexObj].userMain.profilePictureURL.contains("google.com")){
                            path_url =  self.array_Answers[IndexObj].userMain.profilePictureURL
                        }else{
                            path_url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].userMain.profilePictureURL
                        }

                    }
                    self.SetRatingImage(image_view: cellAnswer.Img_user_points, point: Int(self.array_Answers[IndexObj].userMain.Points)!)
                    cellAnswer.Img_user_main.sd_setImage(with: URL.init(string: path_url.RemoveSpace()),placeholderImage: #imageLiteral(resourceName: "ic_profile_blue") , completed: nil)
                    if self.array_Answers[IndexObj].userMain.special_icon.characters.count > 6 {
                        cellAnswer.Img_user_mainTop.isHidden = false
                        cellAnswer.Img_user_mainTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].userMain.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic") ,completed: nil)
                    }else {
                        cellAnswer.Img_user_mainTop.isHidden = true
                    }
                    cellAnswer.lbl_Date.text = ""
                    cellAnswer.lbl_updated_date.text = self.array_Answers[IndexObj].answertime.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MM.dd.yyyy hh:mm a")
                    if(self.array_Answers[IndexObj].isEditCount){
                        cellAnswer.lbl_DateEdit.isHidden = false
                    }else {
                         cellAnswer.lbl_DateEdit.isHidden = true
                    }
                    cellAnswer.btn_DateEdit.tag = IndexObj
                    cellAnswer.btn_DateEdit.addTarget(self, action: #selector(self.gotoHistory), for: UIControlEvents.touchUpInside)
//                    cellAnswer.lbl_updated_date.text = ""
//                    if self.array_Answers[IndexObj].answertime != self.array_Answers[IndexObj].updated_time {
//                        cellAnswer.lbl_updated_date.text = self.array_Answers[IndexObj].updated_time.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MM.dd.yyyy hh:mm a")
//                    }else{
//                         cellAnswer.lbl_updated_date.text = ""
//                    }

                    cellAnswer.lbl_Points.text = self.array_Answers[IndexObj].userMain.Points
                    cellAnswer.lbl_Name.text = self.array_Answers[IndexObj].userMain.userFirstName
                    cellAnswer.lbl_Name.textColor = self.array_Answers[IndexObj].userMain.colorMAin
                    cellAnswer.lbl_Points.textColor = self.array_Answers[IndexObj].userMain.colorMAin

                    //                cellAnswer.lbl_Name.textColor = UIColor.red
                    print(self.array_Answers[IndexObj].userMain.Points)
                    cellAnswer.lbl_Likes.text = self.array_Answers[IndexObj].answer_like_count

                    if Int(self.array_Answers[IndexObj].answer_user_like_count) == 0 {
                        cellAnswer.imgView_like.image = #imageLiteral(resourceName: "Qa_Like")
                    }else {
                        cellAnswer.imgView_like.image = #imageLiteral(resourceName: "Qa_LikeS")
                    }
                    cellAnswer.Btn_ReportInner.tag = IndexObj
                    cellAnswer.Btn_EditAnser.tag = IndexObj
                    if self.array_Answers[IndexObj].userMain.ID != DataManager.sharedInstance.getPermanentlySavedUser()?.ID{
                        cellAnswer.Btn_ReportInner.isHidden = false
                        cellAnswer.Btn_EditAnser.isHidden = true
                        cellAnswer.imgView_Edit.isHidden = true
                        cellAnswer.imgView_Report.isHidden = false
                        if Int(self.array_Answers[IndexObj].flag_by_user_count)! == 0 {
                            cellAnswer.imgView_Report.image = #imageLiteral(resourceName: "ic_flag_gray")

                            cellAnswer.Btn_ReportInner.addTarget(self, action: #selector(self.ShowFilterView), for: UIControlEvents.touchUpInside)
                            //                    cellAnswer.Btn_Report.addTarget(self, action: #selector(self.ReportAnswerShow), for: UIControlEvents.touchUpInside)
                        }else {
                            cellAnswer.imgView_Report.image = #imageLiteral(resourceName: "QAReportBlue")
                        }
                    }else {
                        cellAnswer.Btn_ReportInner.isHidden = true
                        cellAnswer.Btn_EditAnser.isHidden = false
                        cellAnswer.imgView_Edit.isHidden = false
                        cellAnswer.imgView_Report.isHidden = true
                        cellAnswer.Btn_EditAnser.addTarget(self, action: #selector(self.editAnswer(sender:)), for: UIControlEvents.touchUpInside)
                    }

                    cellAnswer.Btn_Like.tag = IndexObj
                    cellAnswer.Btn_Like.addTarget(self, action: #selector(self.LikeAction), for: .touchUpInside)

                    cellAnswer.imgView_First.isHidden = true
                    cellAnswer.imgView_Second.isHidden = true
                    cellAnswer.imgView_Third.isHidden = true
                    cellAnswer.imgView_First_Play.isHidden = true
                    cellAnswer.imgView_Second_Play.isHidden = true
                    cellAnswer.imgView_Third_Play.isHidden = true

                    cellAnswer.Btn_First.isHidden = true
                    cellAnswer.Btn_First.tag = IndexObj
                    cellAnswer.Btn_First.addTarget(self, action: #selector(self.OnClickAttachemntOne(sender:)), for: UIControlEvents.touchUpInside)
                    cellAnswer.Btn_Second.isHidden = true
                    cellAnswer.Btn_Second.tag = IndexObj
                    cellAnswer.Btn_Second.addTarget(self, action: #selector(self.OnClickAttachemntTwo(sender:)), for: UIControlEvents.touchUpInside)
                    cellAnswer.Btn_Third.isHidden = true
                    cellAnswer.Btn_Third.tag = IndexObj
                    cellAnswer.Btn_Third.addTarget(self, action: #selector(self.OnClickAttachemntThree(sender:)), for: UIControlEvents.touchUpInside)

                    if self.array_Answers[IndexObj].attachments.count > 0 {
                        cellAnswer.imgView_First.isHidden = false
                        cellAnswer.Btn_First.isHidden = false
                        if self.array_Answers[IndexObj].attachments[0].is_Video {
                            cellAnswer.imgView_First.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[0].server_URL.RemoveSpace()
                            cellAnswer.imgView_First_Play.isHidden = false
                            cellAnswer.imgView_First_Play.image = #imageLiteral(resourceName: "Video_play_icon_White")
                        }else {
                            cellAnswer.imgView_First.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[0].image_URL.RemoveSpace()
                            cellAnswer.imgView_First_Play.isHidden = false
//                            cellAnswer.imgView_First_Play.image = #imageLiteral(resourceName: "Gallery_White")
                        }
                    }


                    if self.array_Answers[IndexObj].attachments.count > 1 {
                        cellAnswer.imgView_Second.isHidden = false
                        cellAnswer.Btn_Second.isHidden = false
                        if self.array_Answers[IndexObj].attachments[1].is_Video {
                            cellAnswer.imgView_Second.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[1].server_URL.RemoveSpace()
                            cellAnswer.imgView_Second_Play.isHidden = false
                            cellAnswer.imgView_Second_Play.image = #imageLiteral(resourceName: "Video_play_icon_White")
                        }else {
                            cellAnswer.imgView_Second.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[1].image_URL.RemoveSpace()
                            cellAnswer.imgView_Second_Play.isHidden = false
//                            cellAnswer.imgView_Second_Play.image = #imageLiteral(resourceName: "Gallery_White")
                        }

                    }

                    if self.array_Answers[IndexObj].attachments.count > 2 {
                        cellAnswer.imgView_Third.isHidden = false
                        cellAnswer.Btn_Third.isHidden = false
                        if self.array_Answers[IndexObj].attachments[2].is_Video {
                            cellAnswer.imgView_Third.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[2].server_URL.RemoveSpace()
                            cellAnswer.imgView_Third_Play.isHidden = false
                            cellAnswer.imgView_Third_Play.image = #imageLiteral(resourceName: "Video_play_icon_White")
                        }else {
                            cellAnswer.imgView_Third.moa.url = WebServiceName.images_baseurl.rawValue + self.array_Answers[IndexObj].attachments[2].image_URL.RemoveSpace()
                            cellAnswer.imgView_Third_Play.isHidden = false
//                            cellAnswer.imgView_Third_Play.image = #imageLiteral(resourceName: "Gallery_White")
                        }
                    }


                    //
                    //                cellAnswer. .tag = IndexObj
                    cellAnswer.Btn_ReportInner.tag = IndexObj
                    self.view.layoutIfNeeded()
                    cellAnswer.selectionStyle = .none
                    return cellAnswer
                }
            }
        }
    }
    func gotoHistory(sender : UIButton){
        let answer = self.GetView(nameViewController: "EditHistoryVC", nameStoryBoard: StoryBoardConstant.QA) as! EditHistoryVC
        answer.idAnswer = Int(self.array_Answers[sender.tag].answer_ID)!
        self.navigationController?.pushViewController(answer, animated: true)
    }
    func editAnswer (sender : UIButton){
        let answer = self.GetView(nameViewController: "AnswerQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AnswerQuestionViewController
        self.array_Answers[sender.tag].mainQuestion.id = self.chooseQuestion.id
        answer.chooseAnswers = self.array_Answers[sender.tag]
        answer.chooseQuestion = self.array_Answers[sender.tag].mainQuestion
        self.navigationController?.pushViewController(answer, animated: true)
    }
    func shareAction(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.chooseQuestion.id)"
        parmas["type"] = "Question"
        let link : String = Constants.ShareLinkConstant + "get-question-answers/\(self.chooseQuestion.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseQuestion.Question)
    }
    func AddLike(sender : UIButton){
        
        var isPopUpShown :Bool = false
        var param = [String : AnyObject]()
        param["question_id"] = self.chooseQuestion.id as AnyObject
        
        if chooseQuestion.get_user_likes_count == 1 {
            param["is_like"] = "0" as AnyObject
        }else {
            isPopUpShown = true
            param["is_like"] = "1" as AnyObject
        }
        
        self.view.showLoading()
        let mainUrl = WebServiceName.add_question_like.rawValue
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
             self.view.hideLoading()
            if successRespons {
                if let errorMessage = dataResponse["errorMessage"] as? String {
                    if errorMessage == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }else {
                    
                    if self.chooseQuestion.get_user_likes_count == 1 {
                        self.chooseQuestion.get_user_likes_count = 0
                    }else {
                        self.chooseQuestion.get_user_likes_count = 1
                    }
                    
                    if isPopUpShown {
                        
                        if !DataManager.sharedInstance.getQAPopupStatus() {
                            
                            self.saveView.isHidden = false
                        }
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.tbleView_Main.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == -1000 {
            if indexPath.row == 0 || indexPath.row == self.array_Report.count - 1 {
                
            }else {
                for index in 1..<self.array_Report.count - 1 {
                    
                    if indexPath.row == index {
                        let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleS")
                        tbleviewCell.view_BG.isHidden = false
                        self.ChooseReportOption(value: index)
                    }else {
                        let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleE")
                        tbleviewCell.view_BG.isHidden = true
                    }
                }
                
          
                
                
            }
        }
    }
    func ReportHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAHeadingcell") as! QAHeadingcell
        
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func SendButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QASendButtonCell") as! QASendButtonCell
        
        cellFilter.btn_Send.addTarget(self, action:#selector(self.APICAllForFlag), for: UIControlEvents.touchUpInside)

        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    
    func ReportOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAReasonCell") as! QAReasonCell
        cellFilter.imageView_Main.image = UIImage.init(named: array_Report[indexPath.row]["image"]!)
        if indexPath.row == 1 {
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
            cellFilter.view_BG.isHidden = false
        }else{
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
            cellFilter.view_BG.isHidden = true
        }
        cellFilter.lbl_Main.text = array_Report[indexPath.row]["name"]
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    
    
    func ShowReportOptions(sender : UIButton){
        
        
    }
    
    func OnClickAttachemntOne(sender : UIButton){
        if sender.tag == 100{
           self.PreviewAttachmentsQ(index: 0, attachmnet_no: 0)
        }else{
            self.PreviewAttachments(index: sender.tag, attachmnet_no: 0)
        }
     }
    func OnClickAttachemntTwo(sender : UIButton){
        if sender.tag == 200{
            self.PreviewAttachmentsQ(index: 0, attachmnet_no: 1)
        }else{
            self.PreviewAttachments(index: sender.tag, attachmnet_no: 1)
        }
    }
    func OnClickAttachemntThree(sender : UIButton){
        if sender.tag == 300{
            self.PreviewAttachmentsQ(index: 0, attachmnet_no: 2)
        }else{
            self.PreviewAttachments(index: sender.tag, attachmnet_no: 2)
        }
    }
    
    func PreviewAttachmentsQ(index : Int , attachmnet_no : Int) {
        if self.chooseQuestion.attachments.count > 0 {
            if self.chooseQuestion.attachments[attachmnet_no].is_Video {
                let video_path =  WebServiceName.videos_baseurl.rawValue + self.chooseQuestion.attachments[attachmnet_no].video_URL
                let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else {
                
                self.ShowImageQA(attachments: self.chooseQuestion.attachments , index: attachmnet_no)
            }
        }
    }
    
    
    
    func PreviewAttachments(index : Int , attachmnet_no : Int) {
        if self.array_Answers[index].attachments.count > 0 {
            if self.array_Answers[index].attachments[attachmnet_no].is_Video {
                let video_path =  WebServiceName.videos_baseurl.rawValue + self.array_Answers[index].attachments[attachmnet_no].video_URL
                let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else {

                self.ShowImageQA(attachments: self.array_Answers[index].attachments , index: attachmnet_no)
            }
        }
    }
    
    func ReportAnswerShow(sender : UIButton){
        
        self.choose_Answers = self.array_Answers[sender.tag]
        if self.choose_Answers.userMain.ID == DataManager.sharedInstance.user?.ID {
            self.ShowErrorAlert(message: "You can't report your own answer!")
            return
        }
        if self.choose_Answers.flag_by_user_count == "0" {
            let cellDetail = self.tbleView_Main.cellForRow(at: IndexPath.init(row: sender.tag + 1 , section: 0)) as! DetailQACell
            if cellDetail.reportRightConstraint.constant == 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    cellDetail.reportRightConstraint.constant = -500 // Some value
                    self.view.layoutIfNeeded()
                })
                
                
            }else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    cellDetail.reportRightConstraint.constant = 0 // Some value
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    

    func LikeAction(sender : UIButton){
        
        let cellAnswer = self.tbleView_Main.cellForRow(at: IndexPath.init(row: sender.tag + 1, section: 0)) as! DetailQACell
        choose_Answers = self.array_Answers[sender.tag]
        if Int(choose_Answers.answer_user_like_count) == 0 {
            cellAnswer.imgView_like.image = #imageLiteral(resourceName: "Qa_LikeS")
            cellAnswer.lbl_Likes.text = String(Int(cellAnswer.lbl_Likes.text!)! + 1)
            self.LikeAPICall(value: "1")
        }else {
            cellAnswer.imgView_like.image = #imageLiteral(resourceName: "Qa_Like")
            let NewValue = String(Int(cellAnswer.lbl_Likes.text!)! - 1)
            
            if Int(NewValue)! < 1 {
                cellAnswer.lbl_Likes.text = "0"
            }else {
                cellAnswer.lbl_Likes.text = NewValue
            }
            self.LikeAPICall(value: "0")
        }
    }
    
    func LikeAPICall(value : String){
        
        var param = [String : AnyObject]()
        param["answer_id"] = choose_Answers.answer_ID as AnyObject
        param["is_like"] = value as AnyObject

        self.view.showLoading()
        let mainUrl = WebServiceName.add_answer_like.rawValue
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            if successRespons {
                if let errorMessage = dataResponse["errorMessage"] as? String {
                    if errorMessage == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }else {
                    if self.choose_Answers.answer_user_like_count == "1" {
                        self.choose_Answers.answer_user_like_count = "0"
                        self.choose_Answers.answer_like_count = String(Int(self.choose_Answers.answer_like_count)! - 1)
                    }else {
                        self.choose_Answers.answer_like_count = String(Int(self.choose_Answers.answer_like_count)! + 1)
                        self.choose_Answers.answer_user_like_count = "1"
                    }
                    
                    for index in 0..<self.array_Answers.count {
                        let indexObj = self.array_Answers[index]
                        if indexObj.answer_ID == self.choose_Answers.answer_ID {
                            self.array_Answers[index] = self.choose_Answers
                            return
                        }
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
        }
    }
    
    
    
    func APICAllForFlag(){
        if reportValue.count == 0 {
            self.ShowErrorAlert(message: "Please choose a reason for reporting!")
            return
        }
        self.view.showLoading()
        var param = [String : AnyObject]()
        param["answer_id"] = choose_Answers.answer_ID as AnyObject
        param["is_flag"] = "1" as AnyObject
        param["reason"] = reportValue as AnyObject
        self.HideFilterView(sender: UIButton())
        let mainUrl = WebServiceName.add_answer_flag.rawValue
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            if successRespons {
                if let successMessage = dataResponse["successMessage"] as? String {
                    self.ShowErrorAlert(message: successMessage ,AlertTitle: "Success")
                    self.HideFilterView(sender: UIButton.init())
                    if self.QuestionID.count > 0 {
                        self.GetQuestionWithAnswers()
                    }else {
                        self.GetAnswers()
                    }
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                    DataManager.sharedInstance.logoutUser()
                    self.ShowLogoutAlert()
                }else if (dataResponse["status"] as! String) == "errorMessage" {
                      self.ShowErrorAlert(message: (dataResponse["status"] as! String))
                        self.HideFilterView(sender: UIButton.init())
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
        }
    }
    
    func AnswerYourBud(sender : UIButton){
        
        if self.array_Answers.count == 0 {
            if String(self.chooseQuestion.user_id) == DataManager.sharedInstance.user?.ID {
                
                self.ShowErrorAlert(message: "You can't answer firstly on your own question!")
                return
            }
        }
        
        let AnswerQuestionVc = self.GetView(nameViewController: "AnswerQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AnswerQuestionViewController
        AnswerQuestionVc.chooseQuestion = self.chooseQuestion
        self.navigationController?.pushViewController(AnswerQuestionVc, animated: true)

    }
    
    func OpenMenu(sender : UIButton){
        if isFromNewAnser{
            self.GotoQuestionMain()
        }else{
             self.Back()
        }
       
    }
    
    func OpenUserProfile(sender : UIButton){
        let answerMain : Answer = self.array_Answers[sender.tag]
        self.OpenProfileVC(id: "\( answerMain.userMain.ID)")
    }
    
    func OpenUserProfileQuestion(sender : UIButton){
        self.OpenProfileVC(id: "\(self.chooseQuestion.user_id)")
    }
    func RefreshFilterArray(){
        self.array_Report.removeAll()
        
        var dataDict = [String : String]()
        dataDict["image"] = "CircleE"
        dataDict["name"] = "Answer is offensive"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "CircleE"
        dataDict2["name"] = "Spam"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "CircleE"
        dataDict3["name"] = "Unrelated"
        
        var dataDict4 = [String : String]()
        dataDict4["image"] = "CircleE"
        dataDict4["name"] = "Nudity or sexual content"
        
        var dataDict6 = [String : String]()
        dataDict6["image"] = "CircleE"
        dataDict6["name"] = "Harassment or hate speech"
        
        var dataDict7 = [String : String]()
        dataDict7["image"] = "CircleE"
        dataDict7["name"] = "Threatening, violent or concerning"
        
        
        var dataDict5 = [String : String]()
        dataDict5["image"] = ""
        dataDict5["name"] = ""
        
        self.array_Report.append(dataDict)
        
        self.array_Report.append(dataDict4)
        self.array_Report.append(dataDict6)
        self.array_Report.append(dataDict7)
        self.array_Report.append(dataDict2)
        self.array_Report.append(dataDict)
        self.array_Report.append(dataDict3)
        self.array_Report.append(dataDict5)
        
        self.tbleView_Report.reloadData()
    }
    
}


class DetailQACell: UITableViewCell {
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Date : UILabel!
    @IBOutlet var lbl_Points : UILabel!
    @IBOutlet var lbl_Ans : ActiveLabel!
    @IBOutlet var lbl_Likes : UILabel!
    @IBOutlet var lbl_DateEdit : UIView!
    @IBOutlet var btn_DateEdit : UIButton!
    @IBOutlet weak var immgTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var first_btn_hide: NSLayoutConstraint!
    @IBOutlet weak var first_btn: RoundButton!
    @IBOutlet weak var Img_user_points: UIImageView!
    @IBOutlet weak var Img_Add: UIImageView!
    @IBOutlet var Btn_Reply : UIButton!
    @IBOutlet var Btn_Like : UIButton!
    @IBOutlet var Btn_Report : UIButton!
    @IBOutlet var Btn_ReportInner : UIButton!
    @IBOutlet var Btn_EditAnser : UIButton!
    @IBOutlet var Btn_First : UIButton!
    @IBOutlet var Btn_Second : UIButton!
    @IBOutlet var Btn_Third : UIButton!
    @IBOutlet var Btn_UserProfile : UIButton!
    
    @IBOutlet weak var lbl_updated_date: UILabel!
    @IBOutlet weak var Img_user_main: UIImageView!
    @IBOutlet weak var Img_user_mainTop: UIImageView!
    
    @IBOutlet var imgView_First : UIImageView!
    @IBOutlet var imgView_Second : UIImageView!
    @IBOutlet var imgView_Third : UIImageView!
    @IBOutlet var imgView_First_Play : UIImageView!
    @IBOutlet var imgView_Second_Play : UIImageView!
    @IBOutlet var imgView_Third_Play : UIImageView!
    @IBOutlet var imgView_like : UIImageView!
    @IBOutlet var imgView_Report : UIImageView!
    @IBOutlet var imgView_Edit : UIImageView!
    
    @IBOutlet var view_Report : UIView!
    
    @IBOutlet var reportRightConstraint : NSLayoutConstraint!
}

class DetailQAQuestionCell : UITableViewCell {
    @IBOutlet var btn_Menu : UIButton!
    @IBOutlet var btn_Like : UIButton!
    @IBOutlet var btn_Share : UIButton!
    @IBOutlet var btn_UserProfile : UIButton!
    @IBOutlet var btn_AnswerYourBud : UIButton!
    @IBOutlet var btn_Answer : UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var videoIcon3: UIImageView!
    @IBOutlet weak var attachmentImage3: RoundImageView!
    @IBOutlet weak var videoIcon2: UIImageView!
    @IBOutlet weak var attachmentImage2: RoundImageView!
    @IBOutlet var lbl_UserName : UILabel!
    @IBOutlet var lbl_Time : UILabel!
    @IBOutlet var lbl_QuestionTitle : ActiveLabel!
    @IBOutlet var lbl_QuestionDescription : ActiveLabel!
    
    @IBOutlet weak var videoIcon1: UIImageView!
    @IBOutlet weak var attachmentImage1: RoundImageView!
    
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var attachmentView: UIView!
    
    @IBOutlet var imgView_Like : UIImageView!
    @IBOutlet var imgView_UserProfile : CircularImageView!
    @IBOutlet var imgView_UserProfileTop : UIImageView!
    
}


class NoanswerCEll : UITableViewCell {
    @IBOutlet var btn_Menu : UIButton!
    @IBOutlet var edit_btn: UIButton!
    @IBOutlet var btn_UserProfile : UIButton!
    
    @IBOutlet var lbl_UserName : UILabel!
    @IBOutlet var lbl_Time : UILabel!
    @IBOutlet var lbl_Count : UILabel!
    @IBOutlet var lbl_QuestionTitle : ActiveLabel!
    @IBOutlet var lbl_QuestionDescription : ActiveLabel!
    
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var imageButton2: UIButton!
    
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var videoIcon3: UIImageView!
    @IBOutlet weak var attachmentImage3: RoundImageView!
    @IBOutlet weak var videoIcon2: UIImageView!
    @IBOutlet weak var attachmentImage2: RoundImageView!
    @IBOutlet weak var videoIcon1: UIImageView!
    @IBOutlet weak var attachmentImage1: RoundImageView!
    
    
    @IBOutlet var imgView_Like : UIImageView!
    @IBOutlet var imgView_UserProfile : CircularImageView!
    @IBOutlet var imgView_UserProfileTop : UIImageView!
    
}




