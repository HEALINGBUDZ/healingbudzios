//
//  ActivityLogVC.swift
//  BaseProject
//
//  Created by MAC MINI on 26/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class ActivityLogVC: BaseViewController {
  @IBOutlet weak var tableView_activityLog: UITableView!
  @IBOutlet weak var tableView_Filter: UITableView!
 @IBOutlet weak var viewFilter: UIView!
    
  @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    var array_tble = [[String : Any]]()
    var arrayModel = [ActivityLogModel]()
    var arrayMainModel = [ActivityLogModel]()
    var array_filter = [[String : Any]]()
    var isFilterChoose = false
     var refreshControl: UIRefreshControl!
    var pageNumber = 0
    var isFilterOpen = false
    fileprivate var shouldLoadMore = true
    var filter = "&filter="
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_activityLog.addSubview(refreshControl)
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.tableView_activityLog.isScrollEnabled = true
                self.tableView_activityLog.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView_activityLog.alpha  = 1.0
                    self.FilterTopValue.constant = -350 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFilterOpen{
                    isFilterOpen = false
                    self.tableView_activityLog.isScrollEnabled = true
                    self.tableView_activityLog.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tableView_activityLog.alpha  = 1.0
                        self.FilterTopValue.constant = -350 // heightCon is the IBOutlet to the constraint
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
   
    func RefreshAPICall(sender:AnyObject){
         self.playSound(named: "refresh")
        for index in 0..<self.array_filter.count{
            if let tbleviewCell = self.tableView_Filter.cellForRow(at: IndexPath.init(row: index, section: 0)) as? activityFilterCell {
            tbleviewCell.bg_view.isHidden = true
            tbleviewCell.img_cross.isHidden = true
            tbleviewCell.btn_cross.isHidden = true
            }
        }
        if let sndr  = sender as? UIButton{
            self.HideFilterView(sender: sndr)
        }
        
        refreshControl.endRefreshing()
        self.tableView_Filter.reloadData()
        self.pageNumber = 0
        self.filter = "&filter="
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.APICAll(page:  0)
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      self.tabBarController?.tabBar.isHidden = true
         self.pageNumber = 0
        self.APICAll(page: 0)
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }

    func APICAll(page : Int){
        self.showLoading()
        let url = WebServiceName.filter_activity.rawValue + (DataManager.sharedInstance.user?.ID)! + "?skip=\(page)\(self.filter)"
        print(url)
        NetworkManager.GetCall(UrlAPI: url) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()

            if successResponse {

                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    print(mainData)
                    if page > 0{
                    }else{
                        self.arrayModel.removeAll()
                        self.arrayMainModel.removeAll()
                    }
                    for indexObj in mainData {
                        self.arrayModel.append(ActivityLogModel.init(json: indexObj as [String : AnyObject] ))
                        self.arrayMainModel.append(ActivityLogModel.init(json: indexObj as [String : AnyObject] ))
                    }
                    self.shouldLoadMore = !mainData.isEmpty
                    self.pageNumber = page
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
    @IBAction func Home_Btn(_ sender: Any) {
     self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
}
extension ActivityLogVC:UITableViewDelegate,UITableViewDataSource{
    @IBAction func ShowFilterView(sender : UIButton){
         isFilterOpen = true
        self.tableView_activityLog.isScrollEnabled = false
        self.tableView_activityLog.isUserInteractionEnabled = false
        self.isFilterChoose = true
        self.tableView_Filter.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView_activityLog.alpha = 0.2
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let aVariable = appDelegate.isIphoneX
            if(aVariable){
               self.FilterTopValue.constant = 65 // heightCon is the IBOutlet to the constraint
            }else {
                self.FilterTopValue.constant = 55 // heightCon is the IBOutlet to the constraint
            }
           
            self.view.layoutIfNeeded()
        })
    }
    // MARK: - HideFilter
    
    @IBAction func HideFilterView(sender : UIButton){
         isFilterOpen = false
        self.tableView_activityLog.isScrollEnabled = true
        self.tableView_activityLog.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView_activityLog.alpha = 1.0
            self.FilterTopValue.constant = -350 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }

    func ReloadData(){
        self.array_tble.removeAll()
        
        
        for indexObj in self.arrayModel {
            if indexObj.type == "Likes" {
                self.array_tble.append(["type" : ActivityLog.Liked.rawValue])
            }else  if indexObj.type == "Answers" {
                self.array_tble.append(["type" : ActivityLog.Answered.rawValue])
            }else  if indexObj.type == "Users" {
                self.array_tble.append(["type" : ActivityLog.followingBud.rawValue])
            }else  if indexObj.type == "Questions" {
                self.array_tble.append(["type" : ActivityLog.QuestionAsked.rawValue])
            }else  if indexObj.type == "Favorites" {
                self.array_tble.append(["type" : ActivityLog.Favourites.rawValue])
            }else  if indexObj.type == "Strains" {
                self.array_tble.append(["type" : ActivityLog.strainAdd.rawValue])
            }else if indexObj.type == "Comment" {
                self.array_tble.append(["type" : ActivityLog.Comment.rawValue])
            }else if indexObj.type == "Post" {
                self.array_tble.append(["type" : ActivityLog.Post.rawValue])
            }else if indexObj.type == "Tags" {
                self.array_tble.append(["type" : ActivityLog.Tags.rawValue])
            }
        }
        
        if self.arrayModel.count == 0
        {
            self.tableView_activityLog.setEmptyMessage()
        }else {
            self.tableView_activityLog.restore()
        }
        self.tableView_activityLog.reloadData()
        self.array_filter.removeAll()
        self.array_filter.append(["type" : ActivityLog.Answered.rawValue])
        self.array_filter.append(["type" : ActivityLog.Favourites.rawValue])
        self.array_filter.append(["type" : ActivityLog.Liked.rawValue])
        self.array_filter.append(["type" : ActivityLog.strainAdd.rawValue])
        self.array_filter.append(["type" : ActivityLog.Comment.rawValue])
        self.array_filter.append(["type" : ActivityLog.Post.rawValue])
        
      
    }
    
    
    
    func RegisterXib(){
        
        
        self.tableView_activityLog.register(UINib(nibName: "strainAddedCell", bundle: nil), forCellReuseIdentifier: "strainAddedCell")
        self.tableView_activityLog.register(UINib(nibName: "answeredQuestionCell", bundle: nil), forCellReuseIdentifier: "answeredQuestionCell")
        self.tableView_activityLog.register(UINib(nibName: "askedQuestionCell", bundle: nil), forCellReuseIdentifier: "askedQuestionCell")
        self.tableView_Filter.register(UINib(nibName: "activityFilterCell", bundle: nil), forCellReuseIdentifier: "activityFilterCell")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView != self.tableView_Filter){
         return 75
        }else{
            return 44
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView != self.tableView_Filter){
            return UITableViewAutomaticDimension
        }else{
            return 44
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView_activityLog{
            return self.array_tble.count
        }
        else{
              return self.array_filter.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if  tableView == tableView_activityLog{
            let DataElement = self.array_tble[indexPath.row]
            
            let dataType = DataElement["type"] as! String
            switch dataType {
            case ActivityLog.strainAdd.rawValue, ActivityLog.followingBud.rawValue, ActivityLog.FollowingTags.rawValue:
                return strainAddedCell(tableView:tableView, cellForRowAt:indexPath)
            case ActivityLog.QuestionAsked.rawValue,ActivityLog.Comment.rawValue ,
                 ActivityLog.Post.rawValue,ActivityLog.Tags.rawValue ,
                 ActivityLog.AddedJournal.rawValue ,
                 ActivityLog.StartedJournal.rawValue ,
                 ActivityLog.JoinedGroup.rawValue ,
                 ActivityLog.CreatedGroup.rawValue ,
                 ActivityLog.Answered.rawValue,
                 ActivityLog.Liked.rawValue,
                 ActivityLog.Favourites.rawValue:
                return answeredQuestionCell(tableView:tableView, cellForRowAt:indexPath)
            case ActivityLog.Random.rawValue:
                return askedQuestionCell(tableView:tableView, cellForRowAt:indexPath)
            default:
                return askedQuestionCell(tableView:tableView, cellForRowAt:indexPath)
            }
        }
        else{
           return filterCell(tableView:tableView,  cellForRowAt:indexPath)
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView_Filter){
            for index in 0..<self.array_filter.count{
                if indexPath.row == index {
                    let tbleviewCell = tableView.cellForRow(at: indexPath) as! activityFilterCell
                    tbleviewCell.bg_view.isHidden = false
                    tbleviewCell.img_cross.isHidden = false
                    tbleviewCell.btn_cross.isHidden = false
                }else {
                  let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! activityFilterCell
                  tbleviewCell.bg_view.isHidden = true
                  tbleviewCell.img_cross.isHidden = true
                    tbleviewCell.btn_cross.isHidden = true
                }
            }
            self.RefrefData(index: indexPath.row)
        }else{
            let DataElement = self.array_tble[indexPath.row]
            let dataType = DataElement["type"] as! String
            let MainDAta = self.arrayModel[indexPath.row]
            let modelType = MainDAta.model
            switch dataType{
            case ActivityLog.Liked.rawValue , ActivityLog.Favourites.rawValue ,ActivityLog.Tags.rawValue:
                if modelType.contains("Question") ||  modelType.contains("Answers") {
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
                }else if modelType.contains("SubUser") ||  modelType.contains("Budz Map") || modelType.contains("Budz Adz"){
                    let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
                    viewpush.budz_map_id = MainDAta.type_id
                    self.navigationController?.pushViewController(viewpush, animated: true)
                }else if modelType.contains("UserPost") {
                    self.openPost(index: MainDAta.type_id)
                }
                break
            case ActivityLog.Answered.rawValue :
                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                DetailQuestionVc.QuestionID = String(MainDAta.type_id)
                DetailQuestionVc.isFromProfile = false
                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                break
            case ActivityLog.followingBud.rawValue :
                
                break
            case ActivityLog.QuestionAsked.rawValue :
                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                DetailQuestionVc.QuestionID = String(MainDAta.type_id)
                DetailQuestionVc.isFromProfile = false
                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                break
            case ActivityLog.strainAdd.rawValue :
                let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
                detailView.IDMain = "\(MainDAta.type_id)"
                self.navigationController?.pushViewController(detailView, animated: true)
                break
            case ActivityLog.Comment.rawValue, ActivityLog.Post.rawValue :
                self.openPost(index: MainDAta.type_id)
                break
            default:
                break
            }
        }
    }

    func RefrefData(index : Int){
        var stringValue = ""
        if index == 0 {
            stringValue = "Answers"
        }else if index == 1 {
            stringValue = "Favorites"
        }else if index == 2 {
            stringValue = "Likes"
        }else if index == 3 {
            stringValue = "Strains"
        }else if index == 4 {
            stringValue = "Comment"
        }else if index == 5 {
            stringValue = "Post"
        }  
        self.HideFilterView(sender: UIButton.init())
        self.filter = "&filter="+stringValue
         self.pageNumber = 0
        self.APICAll(page: 0)
    }
    
    func strainAddedCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "strainAddedCell") as? strainAddedCell
        cell?.selectionStyle = .none
        let MainDAta = self.arrayModel[indexPath.row]
        let modelType = MainDAta.model
        cell?.imgView_main.image = #imageLiteral(resourceName: "tab_strain")
        cell?.lbl_title.text = MainDAta.text
        cell?.lbl_title.textColor = ConstantsColor.kStrainColor
        cell?.lbl_subtitle.text = MainDAta.Activitydescription
        cell?.view_tag.isHidden = false
        cell?.lbl_time.text = MainDAta.updated_at.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MM.dd.yyyy hh:mm a")
//            .GetDateWith(formate: "MM.dd.yyyy,HH:mm a", inputFormat: "yyyy-MM-dd HH:mm:ss")
        cell?.view_tag.backgroundColor = ConstantsColor.kStrainColor
        return cell!
    }
    func answeredQuestionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answeredQuestionCell") as? answeredQuestionCell
        let MainDAta = self.arrayModel[indexPath.row]
        let modelType = MainDAta.model
        cell?.lbl_time.text = MainDAta.updated_at.UTCToLocal(inputFormate: "yyyy-MM-dd HH:mm:ss", outputFormate: "MM.dd.yyyy hh:mm a")
//            .GetDateWith(formate: "MM.dd.yyyy,HH:mm a", inputFormat: "yyyy-MM-dd HH:mm:ss")
        print(MainDAta.type + "   " + modelType)
        if MainDAta.type == "Questions" &&  modelType == "Question" {
            
                cell?.lbl_title.text = MainDAta.text
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.imgView_main.image = #imageLiteral(resourceName: "QAAnswer")
                cell?.lbl_QorA.text = ""
                cell?.lbl_subtitle.applyTag(baseVC: self , mainText:  MainDAta.Activitydescription)
                cell?.lbl_subtitle.text = MainDAta.Activitydescription
                cell?.lbl_subtitle.textColor = ConstantsColor.KLightGrayColor
        }else if MainDAta.type == "Favorites"{
                cell?.lbl_title.text = MainDAta.text
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.imgView_main.image = #imageLiteral(resourceName: "QALike_Fill")
                cell?.lbl_QorA.text = ""
                cell?.lbl_subtitle.applyTag(baseVC: self , mainText:  MainDAta.text)
                cell?.lbl_subtitle.text = MainDAta.text
                cell?.lbl_subtitle.textColor = ConstantsColor.KLightGrayColor
        }else if MainDAta.type == "Answers"  &&  modelType == "Question"{
                cell?.lbl_title.text = MainDAta.text
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_subtitle.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_time.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_QorA.textColor = ConstantsColor.kQuestionColor
                cell?.imgView_main.image = #imageLiteral(resourceName: "QAAnswer")
                cell?.lbl_QorA.text = "Q:"
                cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
                cell?.lbl_subtitle.text = MainDAta.Activitydescription
        }else if MainDAta.type == "Likes" {
                cell?.lbl_title.text = MainDAta.text
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.imgView_main.image = #imageLiteral(resourceName: "Qa_LikeS")
                cell?.lbl_QorA.text = ""
                
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_subtitle.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_time.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_QorA.textColor = ConstantsColor.kQuestionColor
               cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
                cell?.lbl_subtitle.text = MainDAta.Activitydescription
                
        }else if MainDAta.type == "Likes" && modelType == "Question" {
                cell?.lbl_title.text = MainDAta.text
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                
                cell?.imgView_main.image = #imageLiteral(resourceName: "Qa_LikeS")
                cell?.lbl_QorA.text = ""
                
                cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_subtitle.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_time.textColor = ConstantsColor.kQuestionColor
                cell?.lbl_QorA.textColor = ConstantsColor.kQuestionColor
                 cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
                cell?.lbl_subtitle.text = MainDAta.Activitydescription
        }else if MainDAta.type == "Comment" && modelType == "UserPost" {
            cell?.lbl_title.text = MainDAta.text
            cell?.lbl_title.textColor = UIColor.lightGray
            cell?.imgView_main.image = #imageLiteral(resourceName: "comments-icon")
            cell?.lbl_QorA.text = ""
            
            cell?.lbl_subtitle.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_time.textColor =  ConstantsColor.KLightGrayColor
            cell?.lbl_QorA.textColor = ConstantsColor.KLightGrayColor
             cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
            cell?.lbl_subtitle.text = MainDAta.Activitydescription
        }else if MainDAta.type == "Post" && modelType == "UserPost" {
            cell?.lbl_title.text = MainDAta.text
            cell?.lbl_title.textColor = ConstantsColor.KLightGrayColor
            cell?.imgView_main.image = #imageLiteral(resourceName: "social-wall-green")
            cell?.lbl_QorA.text = ""
            
            cell?.lbl_subtitle.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_time.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_QorA.textColor =  ConstantsColor.KLightGrayColor
            cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
            cell?.lbl_subtitle.text = MainDAta.Activitydescription
        }else if MainDAta.type == "Tags" {
            cell?.lbl_title.text = MainDAta.text
            cell?.lbl_title.textColor = ConstantsColor.kStrainGreenColor
            cell?.imgView_main.image = #imageLiteral(resourceName: "QATag")
            cell?.lbl_QorA.text = ""
            
            cell?.lbl_subtitle.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_time.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_QorA.textColor = ConstantsColor.KLightGrayColor
            cell?.lbl_subtitle.applyTag(baseVC: self , mainText: MainDAta.Activitydescription)
            cell?.lbl_subtitle.text = MainDAta.Activitydescription
        }
        
        cell?.lbl_time.textColor = ConstantsColor.KLightGrayColor
        cell?.selectionStyle = .none
        return cell!
    }
    func askedQuestionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "askedQuestionCell") as? askedQuestionCell
        cell?.selectionStyle = .none
        let DataElement = self.array_tble[indexPath.row]
        let dataType = DataElement["type"] as! String
        switch dataType {
        case ActivityLog.QuestionAsked.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "QAQuestion")
            cell?.lbl_title.text = "You asked a question"
            cell?.lbl_subtitle.text = "Should I warm cannabis oil before applying?"
            cell?.lbl_title.textColor = ConstantsColor.kQuestionColor
        case ActivityLog.AddedJournal.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab2")
            cell?.lbl_title.text = "You added a journal entry"
            cell?.lbl_subtitle.text = "Regimen - Day 1"
            cell?.lbl_title.textColor = ConstantsColor.kJournalColor
        case ActivityLog.StartedJournal.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab2")
            cell?.lbl_title.text = "You started a journal entry"
            cell?.lbl_subtitle.text = "My Cannabis Regimen"
            cell?.lbl_title.textColor = ConstantsColor.kJournalColor
        case ActivityLog.CreatedGroup.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab1")
            cell?.lbl_title.text = "You created a group"
            cell?.lbl_subtitle.text = "Cannabis for Cancer"
            cell?.lbl_title.textColor = ConstantsColor.kGroupColor
        case ActivityLog.JoinedGroup.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab1")
            cell?.lbl_title.text = "You joined a group"
            cell?.lbl_subtitle.text = "Miami Medical Merijuana"
            cell?.lbl_title.textColor = ConstantsColor.kGroupColor
        default:
            break
        }
        return cell!
    }
    
     func filterCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityFilterCell") as? activityFilterCell
        cell?.btn_cross.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.touchUpInside)
        cell?.selectionStyle = .none
        let DataElement = self.array_filter[indexPath.row]
        let dataType = DataElement["type"] as! String
        switch dataType {
        case ActivityLog.QuestionAsked.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "QAQuestion")
            cell?.lbl_title.text = "QUESTIONS"
        case ActivityLog.Answered.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "QAAnswer")
            cell?.lbl_title.text = "ANSWERS"
        case ActivityLog.Favourites.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "QALike_Fill")
            cell?.lbl_title.text = "FAVOURITES"
        case ActivityLog.Liked.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Qa_LikeS")
            cell?.lbl_title.text = "LIKES"
        case ActivityLog.CreatedGroup.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab1")
            cell?.lbl_title.text = "GROUPS"
        case ActivityLog.AddedJournal.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "Tab2")
            cell?.lbl_title.text = "JOURNAL"
        case ActivityLog.FollowingTags.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "QATag")
            cell?.lbl_title.text = "TAGS"
        case ActivityLog.followingBud.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "tab_map")
            cell?.lbl_title.text = "BUDZ ADZ"
        case ActivityLog.strainAdd.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "tab_strain")
            cell?.lbl_title.text = "STRAINS"
        case ActivityLog.Comment.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "comments-icon")
            cell?.lbl_title.text = "COMMENTS"
        case ActivityLog.Post.rawValue:
            cell?.imgView_main.image = #imageLiteral(resourceName: "social-wall-green")
            cell?.lbl_title.text = "POSTS"
        default:
            break
        }
        
        return cell!
    }
    
    
}
extension ActivityLogVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
    
    fileprivate func loadMore() {
        if shouldLoadMore {
            self.APICAll(page: pageNumber +  1)
        }
    }
}
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
class strainAddedCell :UITableViewCell{
    @IBOutlet weak var view_tag: UIView!
    
    @IBOutlet weak var imgView_main: UIImageView!
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!

}
class answeredQuestionCell :UITableViewCell{
    @IBOutlet weak var imgView_main: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_QorA: UILabel!
    @IBOutlet weak var lbl_subtitle: ActiveLabel!
}

class askedQuestionCell :UITableViewCell{
    @IBOutlet weak var imgView_main: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    
    
}
class activityFilterCell :UITableViewCell{
    @IBOutlet weak var imgView_main: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var img_cross: UIImageView!
    @IBOutlet weak var btn_cross: UIButton!
}



extension UITableView {
    func setEmptyMessage(_ message: String = "No Record Found!" , color : UIColor = UIColor.white) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text          = message
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.backgroundView  = noDataLabel
        noDataLabel.font = UIFont.init(name: noDataLabel.font.fontName, size: 17.0)
        self.separatorStyle  = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    public func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
}


extension UICollectionView {
    func setEmptyMessage(_ message: String = "No Record Found!" , color : UIColor = UIColor.white) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text          =  message
        noDataLabel.textColor     =  color
        noDataLabel.textAlignment =  .center
        noDataLabel.font = UIFont.init(name: noDataLabel.font.fontName, size: 17.0)
        self.backgroundView  = noDataLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

