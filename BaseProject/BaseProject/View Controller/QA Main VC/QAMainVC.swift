//
//  QAMainVC.swift
//  BaseProject
//
//  Created by Vengile on 15/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import moa
import AVKit

enum QASort : String {
    case Favorites = "favorites"
    //FAVORITES
    case Newest = "newest"
    case Unanswered = "unanswered"
    case MyQuestion = "my_questions"
    case MyAnswer = "my_answers"
}

enum QAReport : String {
    case None = ""
    case Answer = "Answer is offensive"
    case Spam = "Spam"
    case Unrelated = "Unrelated"
    case Nudity = "Nudity or sexual content"
    case harassment = "Harassment or hate spech"
    case violent = "Threatening, violent or concerning"
}

class QAMainVC: BaseViewController  {
    var isFromAnswerTap : Bool = false
    @IBOutlet weak var saveView: UIView!
    @IBOutlet var tbleViewMain: UITableView!
    @IBOutlet var tbleViewFilter: UITableView!
    @IBOutlet var txtField_Search: UITextField!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var header_top: NSLayoutConstraint!
    @IBOutlet var viewFilter : UIView!
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    
    @IBOutlet var viewCross : UIImageView!
    @IBOutlet var btnCross : UIButton!
    
    var isFliterviewOpen = false
    var selected_filter_index : Int = -1
    var isFilterChoose = false
    var qa_list = [QA]()
    var array_filter = [[String : String]]()
    var pageNumber = 0
    var sortValue = QASort.Newest.rawValue
    var reportValue = QAReport.Answer.rawValue
    var choose_QA = QA()
    var questionAdded = false
    var refreshControl = UIRefreshControl()
    
    var tagSearch = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtField_Search.delegate = self
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tbleViewMain.addSubview(refreshControl)
         self.RegisterXb()
        self.appdelegate.reloadvideoAdd()
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        
        if appdelegate.isIphoneX {
            self.header_top.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFliterviewOpen {
                isFliterviewOpen = false
                self.tbleViewMain.isScrollEnabled = true
                self.tbleViewMain.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.tbleViewMain.alpha = 1.0
                    self.FilterTopValue.constant = -400 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                    if self.isFilterChoose {
                        self.pageNumber = 0
                        self.APICAll()
                    }
                })
            }
           
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFliterviewOpen {
                    isFliterviewOpen = false
                    self.tbleViewMain.isScrollEnabled = true
                    self.tbleViewMain.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.FilterTopValue.constant = -450 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                        self.tbleViewMain.alpha = 1.0
                        if self.isFilterChoose {
                            self.pageNumber = 0
                            self.APICAll()
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func viewWillAppear(_ animated: Bool) {
       self.appdelegate.reloadvideoAdd()
        if questionAdded{
        self.pageNumber = 0
        self.APICAll()
        }
       self.saveView.isHidden = true
       viewCross.image = #imageLiteral(resourceName: "SearchGray")
        btnCross.isHidden = true
        self.txtField_Search.text = ""
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        self.isFilterChoose = false
        self.HideFilterView(sender: UIButton.init())
        self.navigationController?.isNavigationBarHidden = true;
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.tabBarController?.tabBar.isHidden = false
        self.appdelegate.isShownPremioumpopup  = true
	}
	
    

    func RegisterXb(){
        self.tbleViewMain.register(UINib(nibName: "QuestionMainCell", bundle: nil), forCellReuseIdentifier: "QuestionMainCell")
        
        self.tbleViewMain.register(UINib(nibName: "QuestionwithAnswerCell", bundle: nil), forCellReuseIdentifier: "QuestionwithAnswerCell")
        
        
        self.tbleViewMain.register(UINib(nibName: "GoogleAddCell", bundle: nil), forCellReuseIdentifier: "GoogleAddCell")
        
        self.tbleViewMain.register(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: "EmptyCell")

        
        
        
        self.tbleViewFilter.register(UINib(nibName: "QAFilterCell", bundle: nil), forCellReuseIdentifier: "QAFilterCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        
        
        
        
        
        if self.tagSearch.characters.count > 0 {
            self.APICAllForSearch()
        }else {
            self.APICAll()
        }
        
    }
    
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        self.pageNumber = 0
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.APICAll()
        })
        
    }
    
    func RefreshFilterArray(){
        self.array_filter.removeAll()
        
        
        if isFilterChoose {
            var dataDict = [String : String]()
            dataDict["image"] = "QALike_Fill"
            dataDict["name"] = "FAVORITES"
            
            var dataDict2 = [String : String]()
            dataDict2["image"] = "QANew"
            dataDict2["name"] = "NEWEST"
            
            var dataDict3 = [String : String]()
            dataDict3["image"] = "QAUnAnswered"
            dataDict3["name"] = "UNANSWERED"
            
            var dataDict6 = [String : String]()
            dataDict6["image"] = "trending_icon"
            dataDict6["name"] = "TRENDING"
            
            var dataDict4 = [String : String]()
            dataDict4["image"] = "QAQuestion"
            dataDict4["name"] = "MY QUESTIONS"
            
            
            var dataDict5 = [String : String]()
            dataDict5["image"] = "QAAnswer"
            dataDict5["name"] = "MY ANSWERS"
            
            self.array_filter.append(dataDict2)
            self.array_filter.append(dataDict)
            self.array_filter.append(dataDict3)
            self.array_filter.append(dataDict6)
            self.array_filter.append(dataDict4)
            self.array_filter.append(dataDict5)
        }else {
            var dataDict = [String : String]()
            dataDict["image"] = "CircleE"
            dataDict["name"] = "Question is offensive"
            
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
            
            self.array_filter.append(dataDict)
            
            self.array_filter.append(dataDict4)
            self.array_filter.append(dataDict6)
            self.array_filter.append(dataDict7)
            self.array_filter.append(dataDict2)
            self.array_filter.append(dataDict)
            self.array_filter.append(dataDict3)
            self.array_filter.append(dataDict5)
        }
        
        self.tbleViewFilter.reloadData()
    }
	
	
    @IBAction func ShowMenu(sender : UIButton){
        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        
    }
    
    @IBAction func AskQuestion_Action(sender : UIButton){
        let AskQuestionVc = self.GetView(nameViewController: "AskQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AskQuestionViewController
        AskQuestionVc.delegate = self
        self.navigationController?.pushViewController(AskQuestionVc, animated: true)

    }
}

//MARK: View Filter
extension QAMainVC {
    @IBAction func ShowFilterView(sender : UIButton){
        self.isFilterChoose = true
        self.tbleViewMain.isScrollEnabled = false
        self.tbleViewMain.isUserInteractionEnabled = false
        isFliterviewOpen = true
        self.filterViewHeight.constant = 350
        self.RefreshFilterArray()
        UIView.animate(withDuration: 0.5, animations: {
            self.tbleViewMain.alpha = 0.2
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let aVariable = appDelegate.isIphoneX
            if(aVariable){
                self.FilterTopValue.constant = 35 // heightCon is the IBOutlet to the constraint
            }else {
                self.FilterTopValue.constant = 55 // heightCon is the IBOutlet to the constraint
            }
            
            self.view.layoutIfNeeded()
        })
        
        
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
    @IBAction func HideFilterView(sender : UIButton){
        isFliterviewOpen = false
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tbleViewMain.alpha = 1.0
            self.FilterTopValue.constant = -450 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            if self.isFilterChoose {
                self.pageNumber = 0
                self.APICAll()
            }
        })
    }


}

extension QAMainVC : UITableViewDelegate ,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 100 {
            return self.array_filter.count
        }else{
           return self.qa_list.count //+ (Int(self.qa_list.count/10))
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("Row === >")
        print(self.qa_list.count)
        
        
        if self.pageNumber > -1 {
            if self.qa_list.count - 1 == indexPath.row {
                self.pageNumber = self.pageNumber + 1
                self.APICAll()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if tableView.tag == 100 {
            if self.isFilterChoose {
                return self.Filtercell(tableView, cellForRowAt: indexPath)
            }else {
                if indexPath.row == 0 {
                    return self.ReportHeadingCell(tableView, cellForRowAt: indexPath)
                }else if indexPath.row == self.array_filter.count - 1 {
                     return self.SendButtonCell(tableView, cellForRowAt: indexPath)
                }else {
                     return self.ReportOptionCell(tableView, cellForRowAt: indexPath)
                }
            }
        }else{
            if (false) {//indexPath.row % 10 == 0 && indexPath.row > 8
                let add_cell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddCell") as! GoogleAddCell
                self.addBannerViewToView(add_cell.add_view)
                add_cell.selectionStyle = .none
                return add_cell
            }else{
                if indexPath.row < qa_list.count  {//+ (Int(self.qa_list.count/10))
                   // let decreased_index = (Int(indexPath.row/10))
                    let index = indexPath.row //- decreased_index
                    let qa: QA = qa_list[index]
                    if(qa.AnswerCount == 0){
                        return self.NoAnswerCell(tableView, cellForRowAt: indexPath)
                    }else{
                        return self.AnswerCell(tableView, cellForRowAt: indexPath)
                    }
                }else{
                   return self.emptyCell(tableView, cellForRowAt: indexPath)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            if self.isFilterChoose {
                for index in 0..<self.array_filter.count{
                    if indexPath.row == index {
                        let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAFilterCell
                        tbleviewCell.view_BG.isHidden = false
                        tbleviewCell.Img_clear_search.isHidden = false
                        tbleviewCell.Btn_Clear_Selection.isHidden = false
                        self.ChooseSortOption(value: index)
                        self.selected_filter_index = index
                    }else {
                        let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAFilterCell
                        tbleviewCell.view_BG.isHidden = true
                        tbleviewCell.Img_clear_search.isHidden = true
                        tbleviewCell.Btn_Clear_Selection.isHidden = true
                    }
                }
                self.HideFilterView(sender: UIButton.init())
            }else {
                print(indexPath)
                if indexPath.row == 0 || indexPath.row == self.array_filter.count - 1 {
                    
                }else {
                    for index in 1..<self.array_filter.count - 1 {
                        
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
        }else {
            if !self.isFilterChoose {
                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                let decreased_index = (Int(indexPath.row/10))
                let index = indexPath.row - decreased_index
                DetailQuestionVc.chooseQuestion = self.qa_list[index]
                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
            }
        }
    }
    
    
    
    func ChooseSortOption(value : Int){
        
        print("value \(value)")
        switch value {
        case 1:
            self.sortValue = QASort.Favorites.rawValue
            break
        case 2:
            self.sortValue = QASort.Unanswered.rawValue
            break
        case 4:
            self.sortValue = QASort.MyQuestion.rawValue
            break
        case 5:
            self.sortValue = QASort.MyAnswer.rawValue
        case 3:
            self.sortValue =  "Featured"
            break
        default:
            self.sortValue = QASort.Newest.rawValue
        }
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
    
    func emptyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let empty_cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
        empty_cell.selectionStyle = .none
        return empty_cell
    }
    
    func NoAnswerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "QuestionMainCell") as! QuestionMainCell
        
        let decreased_index = (Int(indexPath.row/10))
        let index = indexPath.row - decreased_index
        let qa: QA = qa_list[index]
        var mention_array = [String]()
        for obj in appdelegate.keywords{
            if qa.Question.lowercased().contains(obj.lowercased()){
                mention_array.append(obj)
            }
        }
        cellHeader.lbl_Question.createMentionsApplyTag(array: mention_array, color: Constants.kTagColor, complition: { (text) in
            self.ShowKeywordPopUp(value: text)
        })
        print("user_image_path of \(index)  "+qa.user_photo)
        cellHeader.ImgView_User.image = #imageLiteral(resourceName: "ic_profile_blue")
        cellHeader.ImgView_User.sd_setImage(with: URL.init(string: qa.user_photo.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "ic_profile_blue")) { (Iamge, Error, Chache, url) in
            if Error != nil{
                cellHeader.ImgView_User.image = #imageLiteral(resourceName: "noimage")
            }else {
                cellHeader.ImgView_User.image = Iamge
            }
        }
        if qa.attachments.count > 0{
            cellHeader.attachmentView.isHidden = false
            cellHeader.attachmentViewHeight.constant = 50
            cellHeader.attachmentImage1.isHidden = true
            cellHeader.attachmentImage2.isHidden = true
            cellHeader.attachmentImage3.isHidden = true
            cellHeader.videoIcon1.isHidden = true
            cellHeader.videoIcon2.isHidden = true
            cellHeader.videoIcon3.isHidden = true
            cellHeader.imageButton1.isHidden = true
            cellHeader.imageButton2.isHidden = true
            cellHeader.imageButton3.isHidden = true
            for i in 0..<qa.attachments.count{
                switch i{
                case 0:
                    cellHeader.attachmentImage1.isHidden = false
                    cellHeader.imageButton1.isHidden = false
                    cellHeader.attachmentImage1.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon1.isHidden = false
                    }else{
                        cellHeader.videoIcon1.isHidden = true
                    }
                    cellHeader.imageButton1.tag = index
                    cellHeader.imageButton1.addTarget(self, action: #selector(self.OnClickAttachemntOne(sender:)), for: .touchUpInside)
                case 1:
                    cellHeader.attachmentImage2.isHidden = false
                    cellHeader.imageButton2.isHidden = false
                    cellHeader.attachmentImage2.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon2.isHidden = false
                    }else{
                        cellHeader.videoIcon2.isHidden = true
                    }
                    cellHeader.imageButton2.tag = index
                    cellHeader.imageButton2.addTarget(self, action: #selector(self.OnClickAttachemntTwo(sender:)), for: .touchUpInside)
                case 2:
                    cellHeader.attachmentImage3.isHidden = false
                    cellHeader.imageButton3.isHidden = false
                    cellHeader.attachmentImage3.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon3.isHidden = false
                    }else{
                        cellHeader.videoIcon3.isHidden = true
                    }
                    cellHeader.imageButton3.tag = index
                    cellHeader.imageButton3.addTarget(self, action: #selector(self.OnClickAttachemntThree(sender:)), for: .touchUpInside)
                default:
                    cellHeader.attachmentView.isHidden = false
                    cellHeader.attachmentImage1.isHidden = true
                    cellHeader.attachmentImage2.isHidden = true
                    cellHeader.attachmentImage3.isHidden = true
                    cellHeader.videoIcon1.isHidden = true
                    cellHeader.videoIcon2.isHidden = true
                    cellHeader.videoIcon3.isHidden = true
                    cellHeader.imageButton1.isHidden = true
                    cellHeader.imageButton2.isHidden = true
                    cellHeader.imageButton3.isHidden = true
                }
            }
        }else{
            cellHeader.attachmentView.isHidden = true
            cellHeader.attachmentViewHeight.constant = 0
        }
        
        if qa.special_icon.characters.count > 0 {
            cellHeader.ImgView_UserTop.isHidden = false
            cellHeader.ImgView_UserTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue +  qa.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic")) { (Iamge, Error, Chache, url) in
                if Error != nil{
                    cellHeader.ImgView_UserTop.image = #imageLiteral(resourceName: "noimage")
                }else {
                    cellHeader.ImgView_UserTop.image = Iamge
                }
            }
        }else {
            cellHeader.ImgView_UserTop.isHidden = true
        }
        cellHeader.ImgView_User.RoundView()
        
        cellHeader.lbl_Question.text = qa.Question.trimmingCharacters(in: .whitespaces) + " \n"
        cellHeader.btn_Answer.tag = index
        if String(qa.user_id) == DataManager.sharedInstance.user?.ID {
         cellHeader.btn_Answer.isHidden = true
        }else{
            cellHeader.btn_Answer.isHidden = false
        }
        cellHeader.btn_Answer.addTarget(self, action: #selector(self.GotoAnswer), for: UIControlEvents.touchUpInside)

        cellHeader.btn_Report.tag = index
        cellHeader.btn_Report.addTarget(self, action: #selector(self.GoToReport), for: UIControlEvents.touchUpInside)

        cellHeader.btn_Like.tag = index
        cellHeader.btn_Like.addTarget(self, action: #selector(self.LikeAction), for: UIControlEvents.touchUpInside)

        
        cellHeader.btn_Share.tag = index
        cellHeader.btn_Share.addTarget(self, action: #selector(self.ShareAction), for: UIControlEvents.touchUpInside)

        
        cellHeader.btn_diccription.tag = index
        cellHeader.btn_diccription.addTarget(self, action: #selector(self.GotoDetailView(sender:)), for: UIControlEvents.touchUpInside)
        
        cellHeader.btn_user_profile.tag = index
        cellHeader.btn_user_profile.addTarget(self, action: #selector(self.OpenUserProfile(sender:)), for: UIControlEvents.touchUpInside)
        
        
        if qa.get_user_likes_count == 1 {
            cellHeader.ImgView_Like.image = UIImage.init(named: "QALike_Fill")
        }else {
            cellHeader.ImgView_Like.image = UIImage.init(named: "QALike")
        }
        
        if qa.get_user_flag_count == 1 {
            cellHeader.imgView_Report.image = #imageLiteral(resourceName: "QAReportBlue")
        }else {
            cellHeader.imgView_Report.image = #imageLiteral(resourceName: "ic_flag_gray")
        }
        cellHeader.user_name.text = qa.user_name
        cellHeader.selectionStyle = .none
        return cellHeader
    }
    
    func OnClickAttachemntOne(sender : UIButton){
        
        self.PreviewAttachments(index: sender.tag, attachmnet_no: 0)
        
    }
    func OnClickAttachemntTwo(sender : UIButton){
        
        self.PreviewAttachments(index: sender.tag, attachmnet_no: 1)
        
    }
    func OnClickAttachemntThree(sender : UIButton){
        
        self.PreviewAttachments(index: sender.tag, attachmnet_no: 2)
        
    }

    
    
    func PreviewAttachments(index : Int , attachmnet_no : Int) {
        if self.qa_list[index].attachments.count > 0 {
            if self.qa_list[index].attachments[attachmnet_no].is_Video {
                let video_path =  WebServiceName.videos_baseurl.rawValue + self.qa_list[index].attachments[attachmnet_no].video_URL
                let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else {
                
                self.ShowImageQA(attachments: self.qa_list[index].attachments , index: attachmnet_no)
            }
        }
    }

    
    
    
    func ShareAction(sender : UIButton){
          let qa: QA = qa_list[sender.tag]
        let link : String = Constants.ShareLinkConstant + "get-question-answers/\(qa.id)"
        var parmas = [String: Any]()
        parmas["id"] = "\(qa.id)"
        parmas["type"] = "Question"
        self.OpenShare(params:parmas, link: link,content:qa.Question)
    }
    
    
    func Filtercell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAFilterCell") as! QAFilterCell
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"]
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
        cellFilter.selectionStyle = .none
        if indexPath.row == self.selected_filter_index {
             cellFilter.view_BG.isHidden = false
             cellFilter.Img_clear_search.isHidden = false
             cellFilter.Btn_Clear_Selection.isHidden = false
        }else{
            cellFilter.view_BG.isHidden = true
            cellFilter.Img_clear_search.isHidden = true
            cellFilter.Btn_Clear_Selection.isHidden = true
        }
        cellFilter.Btn_Clear_Selection.addTarget(self, action:#selector(self.ClearFilterSelection), for: UIControlEvents.touchUpInside)
        return cellFilter
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
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"]
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
        if indexPath.row == 1 {
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
            cellFilter.view_BG.isHidden = false
        }else{
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
            cellFilter.view_BG.isHidden = true
        }
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func AnswerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let decreased_index = (Int(indexPath.row/10))
        let index = indexPath.row - decreased_index
        
        let qa: QA = qa_list[index]
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "QuestionwithAnswerCell") as! QuestionwithAnswerCell
        var mention_array = [String]()
        for obj in appdelegate.keywords{
            if qa.Question.lowercased().contains(obj.lowercased()){
                mention_array.append(obj)
            }
        }
        cellHeader.lbl_Question.createMentionsApplyTag(array: mention_array, color: Constants.kTagColor, complition: { (text) in
            self.ShowKeywordPopUp(value: text)
        })
        cellHeader.lbl_Question.text = qa.Question.trimmingCharacters(in: .whitespaces) + " \n"
        if qa.attachments.count > 0{
            cellHeader.attachmentView.isHidden = false
            cellHeader.attachmentViewHeight.constant = 50
            cellHeader.attachmentImage1.isHidden = true
            cellHeader.attachmentImage2.isHidden = true
            cellHeader.attachmentImage3.isHidden = true
            cellHeader.videoIcon1.isHidden = true
            cellHeader.videoIcon2.isHidden = true
            cellHeader.videoIcon3.isHidden = true
            cellHeader.imageButton1.isHidden = true
            cellHeader.imageButton2.isHidden = true
            cellHeader.imageButton3.isHidden = true
            for i in 0..<qa.attachments.count{
                switch i{
                case 0:
                    cellHeader.attachmentImage1.isHidden = false
                    cellHeader.imageButton1.isHidden = false
                    cellHeader.attachmentImage1.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon1.isHidden = false
                    }else{
                        cellHeader.videoIcon1.isHidden = true
                    }
                    cellHeader.imageButton1.tag = index
                    cellHeader.imageButton1.addTarget(self, action: #selector(self.OnClickAttachemntOne(sender:)), for: .touchUpInside)
                case 1:
                    cellHeader.attachmentImage2.isHidden = false
                    cellHeader.imageButton2.isHidden = false
                    cellHeader.attachmentImage2.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon2.isHidden = false
                    }else{
                        cellHeader.videoIcon2.isHidden = true
                    }
                    cellHeader.imageButton2.tag = index
                    cellHeader.imageButton2.addTarget(self, action: #selector(self.OnClickAttachemntTwo(sender:)), for: .touchUpInside)
                case 2:
                    cellHeader.attachmentImage3.isHidden = false
                    cellHeader.imageButton3.isHidden = false
                    cellHeader.attachmentImage3.sd_setImage(with: URL(string: WebServiceName.images_baseurl.rawValue + qa.attachments[i].image_URL), placeholderImage: nil, completed: nil)
                    if qa.attachments[i].is_Video{
                        cellHeader.videoIcon3.isHidden = false
                    }else{
                        cellHeader.videoIcon3.isHidden = true
                    }
                    cellHeader.imageButton3.tag = index
                    cellHeader.imageButton3.addTarget(self, action: #selector(self.OnClickAttachemntThree(sender:)), for: .touchUpInside)
                default:
                    cellHeader.attachmentView.isHidden = false
                    cellHeader.attachmentImage1.isHidden = true
                    cellHeader.attachmentImage2.isHidden = true
                    cellHeader.attachmentImage3.isHidden = true
                    cellHeader.videoIcon1.isHidden = true
                    cellHeader.videoIcon2.isHidden = true
                    cellHeader.videoIcon3.isHidden = true
                    cellHeader.imageButton1.isHidden = true
                    cellHeader.imageButton2.isHidden = true
                    cellHeader.imageButton3.isHidden = true
                }
            }
        }else{
            cellHeader.attachmentView.isHidden = true
            cellHeader.attachmentViewHeight.constant = 0
        }
        cellHeader.btn_Discuss.tag = index
        cellHeader.btn_Discuss.addTarget(self, action: #selector(self.GotoDetailView), for: UIControlEvents.touchUpInside)
       cellHeader.ImgView_User.image = #imageLiteral(resourceName: "noimage")
        cellHeader.ImgView_User.sd_setImage(with: URL.init(string: qa.user_photo.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "ic_profile_blue")) { (Iamge, Error, Chache, url) in
//            if Error != nil{
//            cellHeader.ImgView_User.image = #imageLiteral(resourceName: "noimage")
//            }else {
//                cellHeader.ImgView_User.image = Iamge
//            }
        }
        
        if qa.icCurrentUserAnserd {
            cellHeader.img_userAnswerd.image = #imageLiteral(resourceName: "ic_answered")
        }else{
             cellHeader.img_userAnswerd.image = #imageLiteral(resourceName: "ic_non_answer")
        }
        
        
        if qa.special_icon.count > 0 {
            cellHeader.ImgView_UserTop.isHidden = false
            cellHeader.ImgView_UserTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue +  qa.special_icon.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic")) { (Iamge, Error, Chache, url) in
//                if Error != nil{
//                    cellHeader.ImgView_UserTop.image = #imageLiteral(resourceName: "noimage")
//                }else {
//                    cellHeader.ImgView_UserTop.image = Iamge
//                }
            }
        }else {
            cellHeader.ImgView_UserTop.isHidden = true
        }
        cellHeader.ImgView_User.RoundView()
        
        
        
        if qa.get_user_flag_count == 1 {
            cellHeader.imgView_Report.image = #imageLiteral(resourceName: "QAReportBlue")
        }else {
            cellHeader.imgView_Report.image = #imageLiteral(resourceName: "ic_flag_gray")
        }
        cellHeader.btn_Report.tag = index
        cellHeader.btn_Report.addTarget(self, action: #selector(self.GoToReport), for: UIControlEvents.touchUpInside)
        
        cellHeader.btn_Share.tag = index
        cellHeader.btn_Share.addTarget(self, action: #selector(self.ShareAction), for: UIControlEvents.touchUpInside)
        
        
        cellHeader.btn_Like.tag = index
        cellHeader.btn_Like.addTarget(self, action: #selector(self.LikeAction), for: UIControlEvents.touchUpInside)
        
        cellHeader.btn_diccription.tag = index
        cellHeader.btn_diccription.backgroundColor = UIColor.red
        cellHeader.btn_diccription.addTarget(self, action: #selector(self.GotoDetailView(sender:)), for: UIControlEvents.touchUpInside)
        
        cellHeader.btn_user_profile.tag = index
        cellHeader.btn_user_profile.addTarget(self, action: #selector(self.OpenUserProfile(sender:)), for: UIControlEvents.touchUpInside)
        
        if qa.get_user_likes_count == 1 {
            cellHeader.ImgView_Like.image = UIImage.init(named: "QALike_Fill")
        }else {
            cellHeader.ImgView_Like.image = UIImage.init(named: "QALike")
        }
        
        cellHeader.user_name.text = qa.user_name
        cellHeader.lbl_totalAnswer.text = String(qa.AnswerCount)
        
        if qa.AnswerCount > 19 {
            cellHeader.img_featured.isHidden = false
        }else{
            cellHeader.img_featured.isHidden = true
        }
        cellHeader.selectionStyle = .none
        return cellHeader
    }
}

//MARK:
//MARK: Cell Actions
//MARK:
extension QAMainVC {
    
    func ClearFilterSelection(){
        self.selected_filter_index = -1
        self.sortValue = QASort.Newest.rawValue
        self.tbleViewFilter.reloadData()
        self.HideFilterView(sender: UIButton.init())
    }
    func GotoAnswer(sender : UIButton){
        if String(qa_list[sender.tag].user_id) == DataManager.sharedInstance.user?.ID {
            
            self.ShowErrorAlert(message: "You can't answer firstly on your own question!")
            return
        }
        let AnswerQuestionVc = self.GetView(nameViewController: "AnswerQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AnswerQuestionViewController
        AnswerQuestionVc.isFromMainVC = true
        AnswerQuestionVc.chooseQuestion = qa_list[sender.tag]
        self.navigationController?.pushViewController(AnswerQuestionVc, animated: true)
    }
    
    func GotoDetailView(sender : UIButton){
        let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
        DetailQuestionVc.chooseQuestion = self.qa_list[sender.tag]
        self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
        
    }
    
    func GoToReport(sender : UIButton){
        choose_QA = self.qa_list[sender.tag]
        if String(choose_QA.user_id) == DataManager.sharedInstance.user?.ID {
            self.ShowErrorAlert(message: "You can't report your own question!")
            return
        }
        if choose_QA.get_user_flag_count == 1 {
            self.ShowErrorAlert(message: "Question already reported!")
            choose_QA = QA()
            return
        }
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        
        self.isFilterChoose = false
        
        
        self.RefreshFilterArray()
        self.isFliterviewOpen = true
        self.tbleViewMain.isScrollEnabled = false
        self.tbleViewMain.isUserInteractionEnabled = false
        self.filterViewHeight.constant = 430
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = 52
            self.tbleViewMain.alpha = 0.2
            self.view.layoutIfNeeded()
        })
    }
    
    func OpenUserProfile(sender : UIButton) {
        let qa : QA = self.qa_list[sender.tag]
        self.OpenProfileVC(id: "\( qa.user_id)")
    }
    
    func LikeAction(sender : UIButton){
        self.choose_QA = self.qa_list[sender.tag]
        self.APICAllForLike()
    }

}
//MARK:
//MARK: TextField Delegate Method
//MARK:
extension QAMainVC {
    override  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
     func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text!).count > 2 {
            self.APICAllForSearch()
        }
        viewCross.image = #imageLiteral(resourceName: "SearchGray")
        btnCross.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewCross.image = #imageLiteral(resourceName: "cross")
        btnCross.isHidden = false
        
    }
    
    @IBAction func CrosseSearch(sender : UIButton){
        self.txtField_Search.text = ""
        self.txtField_Search.resignFirstResponder()
        self.APICAll()
    }
}

//MARK:
//MARK: API Calling
//MARK:
extension QAMainVC {
    func APICAll(){
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        if !self.refreshControl.isRefreshing{
            self.view.showLoading()
        }
        self.tbleViewMain.restore()
        if self.pageNumber == 0 {
            self.qa_list.removeAll()
        }
        let mainUrl = WebServiceName.get_questions.rawValue + sortValue + "&skip=" + String(pageNumber)
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successRespons, messageResponse, dataResponse) in
//             print(dataResponse)
            if !self.refreshControl.isRefreshing{
                self.view.hideLoading()
            }
            self.refreshControl.endRefreshing()
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    if let mainData = dataResponse["successData"] as? [[String : Any]]{
                        for indexObj in mainData {
                            self.qa_list.append(QA.init(json: indexObj as [String : AnyObject]))
                        }
                    }
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        self.ShowErrorAlert(message:dataResponse["errorMessage"] as? String ?? "Server Error")
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            
           if self.qa_list.count == 0
           {
                self.tbleViewMain.setEmptyMessage("No Questions Found!")
           }else {
                self.tbleViewMain.restore()
            }
            
            print("self.qa_list    ====>")
            print(self.qa_list.count)
            
            if self.qa_list.count % 15 != 0 {
                self.pageNumber = -1
            }
            self.tbleViewMain.reloadData()
            if self.pageNumber ==  0 && self.qa_list.count > 0{
                self.tbleViewMain.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: false)
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
        param["question_id"] = choose_QA.id as AnyObject
        param["is_flag"] = "1" as AnyObject
        param["reason"] = reportValue as AnyObject

        let mainUrl = WebServiceName.add_question_flag.rawValue
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
//            print(dataResponse)
            self.view.hideLoading()
            if successRespons {
                if let successMessage = dataResponse["successMessage"] as? String {
                        self.ShowErrorAlert(message: successMessage ,AlertTitle: "Success")
                    self.HideFilterView(sender: UIButton.init())
                    
                    
                    for indexObj in self.qa_list {
                        if self.choose_QA.id == indexObj.id {
                            indexObj.get_user_flag_count = 1
                        }
                    }
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }

            self.tbleViewMain.reloadData()
        }
    }
    
    func APICAllForLike(){
         print(choose_QA.id)
        
        
        var isPopUpShown :Bool = false
        
        
        var param = [String : AnyObject]()
        param["question_id"] = choose_QA.id as AnyObject
        
        if choose_QA.get_user_likes_count == 1 {
            param["is_like"] = "0" as AnyObject
        }else {
            
            isPopUpShown = true
            
            param["is_like"] = "1" as AnyObject
        }
        
        
        let mainUrl = WebServiceName.add_question_like.rawValue
        self.view.showLoading()
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
//            print(dataResponse)
             self.view.hideLoading()
            if successRespons {
                    if let errorMessage = dataResponse["errorMessage"] as? String {
                        if errorMessage == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }else {
                        if self.choose_QA.get_user_likes_count == 1 {
                           self.choose_QA.get_user_likes_count = 0
                        }else {
                           self.choose_QA.get_user_likes_count = 1
                        }
                        
                        for index in 0..<self.qa_list.count {
                            let indexObj = self.qa_list[index]
                            if indexObj.id == self.choose_QA.id {
                                self.qa_list[index] = self.choose_QA
                                self.tbleViewMain.reloadData()
                               
                               
                                if isPopUpShown {
                                
                                    if !DataManager.sharedInstance.getQAPopupStatus() {
                                    
                                        self.saveView.isHidden = false
                                    }
                                }
                                
                                return
                            }
                        }
                    }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.tbleViewMain.reloadData()
        }
    }
    
    
    
    func APICAllForSearch(){
        self.showLoading()
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        var newText = self.txtField_Search.text!
        self.pageNumber = -1
        if self.tagSearch.characters.count > 0 {
            newText = self.tagSearch
        }
        let mainUrl = WebServiceName.search_question.rawValue + newText
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successRespons, messageResponse, dataResponse) in
//            print(dataResponse)
            self.hideLoading()
            self.tagSearch = ""
             self.qa_list.removeAll()
            if successRespons {
                if let errorMessage = dataResponse["errorMessage"] as? String {
                    if errorMessage == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }else if "success" == (dataResponse["status"] as! String) {
                    let mainData = dataResponse["successData"] as! [[String : AnyObject]]
                    for indexObj in mainData{
                        self.qa_list.append(QA.init(json: indexObj))
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            if self.qa_list.count == 0
            {
                if (self.isFromAnswerTap){
                    self.isFromAnswerTap = false
                    self.tbleViewMain.setEmptyMessage("No Answers Found!")
                }else {
                    self.tbleViewMain.setEmptyMessage("No Questions Found!")
                }
                
            }else {
                self.tbleViewMain.restore()
            }
            self.tbleViewMain.reloadData()
        }
    }
    
    func alert(_ title: String, message: String) {
        self.simpleCustomeAlert(title: title, discription: message)

    }
    
}

