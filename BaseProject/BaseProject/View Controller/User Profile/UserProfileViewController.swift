//
//  UserProfileViewController.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ObjectMapper
import ActiveLabel
import SYBlinkAnimationKit
import SwiftLinkPreview
enum valueChoose : Int {
    case isHome = 0
    case isQA = 1
    case isStrain = 2
    case isBudz = 3
    case isActivity = 4
}



class UserProfileViewController: BaseViewController {
    @IBOutlet weak var blinking_image: UIImageView!
    @IBOutlet weak var loading_view: SYView!
    @IBOutlet weak var  loading_animation_view: SYView!
    @IBOutlet var tbleViewMain : UITableView!
    var user_id : String!
    var afterCompletion = 0
    var tabClickedIndex = -1
    var isSeeAll : Bool = false
    var feedDataController = FeedDataController()
    fileprivate var currentPageIndex = 0
    fileprivate var shouldLoadMore = true
    public var result = SwiftLinkPreview.Response()
    public let slp = SwiftLinkPreview(cache: InMemoryCache())
    var isStrainApiCalled = false
    var mainArray = [[String : Any]]()
    var budz_reviews = [BudzReview]()
    public static var userMain = User()
    var userQuestion = [QA]()
    var userAnswer = [Answer]()
    var budzArray = [BudzMap]()
    var budzArrayFav = [BudzMap]()
    var strainArray = [Strain]()
    var strain_reviews = [[String : Any]]()
    var mainFollowers = UIViewController()
    
    var valueSelected = valueChoose.isHome.rawValue
    var StrainHeading = ""
    
    var expery_One = ""
    var expery_Two = ""
    var followScreen = false
    
    var experty1  = [AddExperties]()
    var experty2  = [AddExperites2]()
    var isViewWillAppeard = false
    
    var valueHomeSelected = false
    var valueQASelected = true
    var valueAnsSelected = true
    
    var isStrainSelected = true
    var isBudzSelected = true
    
    
    @IBOutlet weak var viewFilter: filterView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var indicator_close: UIButton!
    @IBOutlet weak var tableViewGroups: UITableView!
    @IBOutlet weak var btnApply: RoundButton!
    @IBOutlet weak var filterLabel: UILabel!
    var filterList = ["Newest","Most Liked"]
    var isFilterOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.tbleViewMain.contentInset.top = -20
        self.viewFilter.center.y = -310
        self.viewFilter.selectedIndex = wallSelectedFilter
        let filterCellNib = UINib(nibName: "FilterCell", bundle: nil)
        tableViewGroups.register(filterCellNib, forCellReuseIdentifier: "FilterCell")
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        indicator_close.setImage(#imageLiteral(resourceName: "groups_menu_indicator_close").withRenderingMode(.alwaysTemplate), for: .normal)
        indicator_close.tintColor = UIColor.init(hex: "7cc245")
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.hideView()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.viewFilter{
                if isFilterOpen{
                    isFilterOpen = false
                    self.hideView()
                    self.view.endEditing(true)
                }
            }
        }
    }
    
    func hideView()
    {
        isFilterOpen = false
        self.tbleViewMain.isScrollEnabled = true
        self.tbleViewMain.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: .curveLinear ,
                       animations: {
                        self.tbleViewMain.alpha  = 1.0
                        if self.viewFilter.showReportMenu{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: -310)
                        }else{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: -210)
                        }
                        self.view.setNeedsDisplay()
        },
                       completion: { finished in
        })
    }
    
    @IBAction func applyFilter(_ sender: Any)
    {
        self.hideView()
        if viewFilter.showReportMenu
        {
            if self.feedDataController.postList[viewFilter.tag].flaged_count?.intValue==0
            {
                self.feedDataController.postList[viewFilter.tag].flaged_count=NSNumber(integerLiteral: 1)
                self.feedDataController.performlReportOrFlag(index: viewFilter.tag, reason: self.filterList[viewFilter.selectedIndex])
            }
            
        }
        else
        {
        }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if (appDelegate.keywords.count == 0 ){
//            self.GetKeywords(completion: {
//                print(appDelegate.keywords)
//            })
//        }
    }
    
    @IBAction func aktion_OpenFilters(_ sender: Any)
    {
        self.resetFilter()
        self.showView()
    }
    func resetFilter()
    {
        self.viewFilter.showReportMenu=true
        
        
    }
    func showView()
    {
        
        isFilterOpen = true
        self.tbleViewMain.isScrollEnabled = false
        self.tbleViewMain.isUserInteractionEnabled = false
        if self.viewFilter.showReportMenu
        {
            self.filterLabel.text = "REASON FOR REPORTING:"
            self.btnApply.setTitle("SEND", for: .normal)
        }
        else
        {
            
            self.filterLabel.text = "FILTER:"
            self.btnApply.setTitle("APPLY", for: .normal)
        }
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options:  .curveEaseIn ,
                       animations: {
                        self.tbleViewMain.alpha  = 0.2
                        self.tableViewGroups.reloadData()
                        if self.viewFilter.showReportMenu{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 240)
                        }else{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 150)
                        }
        },
                       completion: { finished in
                        
                        
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isfromYoutubePlayer {
            isfromYoutubePlayer = false
            return
        }
        self.tabBarController?.tabBar.isHidden = true
        self.APICall()
        self.experty1.removeAll()
        self.experty2.removeAll()
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadFollowersData), name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil)
        if self.afterCompletion == 1 || isProfileViewFromMsgChatVC{
             isProfileViewFromMsgChatVC = false
        }else {
          self.disableMenu()
        }
        if isViewWillAppeard{
             self.ReloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil)
        isProfileBlinkingClose = false
        if !isProfileViewFromMsgChatVC{
            isProfileViewFromMsgChatVC = false
            self.enableMenu()
        }
       
    }
    
    func APICall(){
        
        if !followScreen{
           self.loading_view.isHidden = false
          isProfileBlinkingClose = false
          blinking_count = 0
          self.loading_animation_view.animationBackgroundColor = UIColor.black.withAlphaComponent(0.5)
          self.loading_animation_view.animationType = .background
          self.loading_animation_view.startAnimating()
        }else{
            self.loading_animation_view.stopAnimating()
            self.loading_view.isHidden = true
        }
        self.budzArray.removeAll()
        self.expery_Two = ""
        self.expery_One = ""
        let urlMain = WebServiceName.get_user_profile.rawValue + user_id! + "?time_zone=+05:00&skip=0&lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        print(urlMain)
        NetworkManager.GetCall(UrlAPI: urlMain) { (successMain, message, MainData) in
            print(MainData)
            isProfileBlinkingClose = true
            self.isViewWillAppeard = true
            if successMain {
                let userDict = MainData["successData"] as? [String : Any]
                let userArray = userDict!["user_data"] as? [[String : Any]]
                let myBudzArray = userDict!["subuser"] as? [[String : Any]]
                
                if (myBudzArray?.count)! > 0 {
                    for index in myBudzArray! {
                        self.budzArray.append(BudzMap.init(json: index as? [String : AnyObject]))
                    }
                }
                if (userArray?.count)! > 0 {
                    UserProfileViewController.userMain = User.init(json: userArray?.first as [String : AnyObject]?)
                    
                    let experties = userArray?.first!["get_expertise"] as! [[String : Any]]
                    print(experties)
                    for indexObj in experties {
                        if let m = indexObj["medical"] as? [String: Any]{
                            self.experty1.append(AddExperties.init(json: indexObj["medical"] as? [String : AnyObject]))
                                if self.expery_One.characters.count == 0 {
                                    self.expery_One = (indexObj["medical"] as! [String : Any])["m_condition"] as! String
                                }else {
                                    self.expery_One =  self.expery_One + "\n" + ((indexObj["medical"] as! [String : Any])["m_condition"] as! String)
                                }
                            }else {
                                self.experty2.append(AddExperites2.init(json: indexObj["strain"] as! [String : AnyObject]))

                                
                                if self.expery_Two.characters.count == 0 {
                                    self.expery_Two = (indexObj["strain"] as! [String : Any])["title"] as! String
                                }else {
                                    self.expery_Two =  self.expery_Two + "\n" + ((indexObj["strain"] as! [String : Any])["title"] as! String)
                                }
                            }
                    }
                    
                    print(self.experty1)
                    print(self.experty2)
                    print(self.expery_One)
                    print(self.expery_Two)
                    let ansArray = userArray?.first!["get_answers"] as? [[String : Any]]
                    self.userAnswer.removeAll()
                    for index in ansArray! {
                        self.userAnswer.append(Answer.init(json: index as? [String : AnyObject]))
                    }
                    self.userQuestion.removeAll()
                    let questionArray = userArray?.first!["get_question"] as? [[String : Any]]
                    for index in questionArray! {
                        let qa = QA.init(json: index as? [String : AnyObject])
                        qa.user_id =  (index["user_id"] as? Int)!
                        self.userQuestion.append(qa)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                      self.fetchPosts()
//                if self.feedDataController.postList.isEmpty {
//                         self.fetchPosts()
//                }else {
//                    isProfileBlinkingClose = true
//                    self.loading_animation_view.stopAnimating()
//                    self.loading_view.isHidden = true
//                     self.ReloadData()
//                    }
                })
            }
            
            
        }
    }
}

extension UserProfileViewController {
    
    fileprivate func loadMore() {
        if shouldLoadMore {
//            fetchPosts(pageIndex: currentPageIndex + 1)
        }
    }
    
    fileprivate func fetchPosts(pageIndex: Int = 0)   {
        
        let _userId = user_id ?? DataManager.sharedInstance.user!.ID
        
        let serviceUrl = WebServiceName.user_posts.rawValue + "/\(_userId)?skip=\(pageIndex)"
        print(serviceUrl)
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            self?.loading_animation_view.stopAnimating()
            self?.currentPageIndex = pageIndex
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        let postDictionaries = data["posts"] as! [[String: Any]]
                        
                        self?.shouldLoadMore = !postDictionaries.isEmpty
                        print("should load more: \(String(describing: self?.shouldLoadMore)), arrayCount = \(postDictionaries.count)")
                        
                        if pageIndex == 0   {
                            self?.feedDataController.postList.removeAll()
                        }
                        
                        for postDictionary in postDictionaries  {
                            if let post = Post(JSON: postDictionary)    {
                                
//                                post.checkIfLiked()
                                post.checkPostType()
                                print("ID: \(String(describing: post.id!)), Description: \(String(describing: post.discription))")
                                self?.feedDataController.postList.append(post)
                            }
                        }
                    }
                      isProfileBlinkingClose = true
                    self?.blinking_image.stopAnimating()
                    self?.loading_view.isHidden = true
                } // successs
                else {
                    if let errorMessage = responseData["errorMessage"] as? String   {
                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                            DataManager.sharedInstance.logoutUser()
                            self?.ShowLogoutAlert()
                        }
                        else {
                            self?.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        self?.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
            } // api Succeed
            
            self?.ReloadData()
            
        } // netowrk call
    }
    
    
    
    fileprivate func showFeedDetail(index: Int) {
        let feedDetailController = self.GetView(nameViewController: "FeedDetail", nameStoryBoard: "Wall") as! FeedDetailViewController
        feedDetailController.postindex = index
        feedDetailController.feedDataController = feedDataController
        self.navigationController?.pushViewController(feedDetailController, animated: true)
    }
}


//MARK:
//MARK: TableView
extension UserProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : profileSettings.profileSettingsUserInfo.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue , "index" : 1])
        
        self.mainArray.append(["type" : profileSettings.profileSettingsDetailCell.rawValue])
        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue , "index" : 2])
        self.mainArray.append(["type" : profileSettings.profileSettingsMedicalConditionsCell.rawValue])
        
        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue , "index" : 3])
        
        if isSeeAll {
            for indexObj in 0..<self.budzArray.count {
                self.mainArray.append(["type" : profileSettings.BudzCell.rawValue , "index" : indexObj])
            }
        }else{
            if self.budzArray.count > 2 {
                for indexObj in 0..<2 {
                    self.mainArray.append(["type" : profileSettings.BudzCell.rawValue , "index" : indexObj])
                }
            }else{
                for indexObj in 0..<self.budzArray.count {
                    self.mainArray.append(["type" : profileSettings.BudzCell.rawValue , "index" : indexObj])
                }
            }
        }
        
        if self.budzArray.count == 0 {
             self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 0])
        }
        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue , "index" : 4])

        self.mainArray.append(["type" : profileSettings.profileButton.rawValue ])
        
        
        if self.valueSelected == valueChoose.isHome.rawValue    {
            for (index, post) in feedDataController.postList.enumerated() {
                if post.postType == .text   {
                    self.mainArray.append(["type" : profileSettings.TextPostCell.rawValue , "index" : index])
                }
                else    {
                    self.mainArray.append(["type" : profileSettings.MediaPostCell.rawValue , "index" : index])
                }
            }
            if self.feedDataController.postList.count == 0 {
                 self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 0])
            }else{
                self.mainArray.append(["type" : profileSettings.LoadingMore.rawValue , "index" : 0])
            }
        } else if  self.valueSelected == valueChoose.isQA.rawValue
        {
            if self.userQuestion.count == 0  || self.userAnswer.count == 0 {
                if self.userQuestion.count != 0 {
                    self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 1])
                    if self.valueQASelected {
                        for indexObj in 0..<self.userQuestion.count {
                            self.mainArray.append(["type" : profileSettings.QACell.rawValue , "index" : indexObj])
                        }
                    }
                }
                
                if self.userAnswer.count != 0 {
                    self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 2])
                    if self.valueAnsSelected {
                        for indexObj in 0..<self.userAnswer.count {
                            self.mainArray.append(["type" : profileSettings.AnswerCell.rawValue , "index" : indexObj])
                        }
                    }
                }
                
                if self.userAnswer.count == 0  && self.userQuestion.count == 0 {
                     self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 1])
                }
            }else{
                self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 1])
                if self.valueQASelected {
                    
                    for indexObj in 0..<self.userQuestion.count {
                        self.mainArray.append(["type" : profileSettings.QACell.rawValue , "index" : indexObj])
                    }
                    
                }
                
                self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 2])
                if self.valueAnsSelected {
                    for indexObj in 0..<self.userAnswer.count {
                        self.mainArray.append(["type" : profileSettings.AnswerCell.rawValue , "index" : indexObj])
                    }
                }
            }
        }else if  self.valueSelected == valueChoose.isStrain.rawValue
        {
            self.StrainHeading = "My Strain"
            if self.strainArray.count == 0 {
                    if self.isStrainApiCalled == false{
                        self.isStrainApiCalled = true
                      self.StrainAPICall()
                    }
                    
                } else {
                self.mainArray.append(["type" : profileSettings.StrainHeadingCell.rawValue ])
                for indexObj in 0..<self.strainArray.count {
                    self.mainArray.append(["type" : profileSettings.StrainCell.rawValue , "index" : indexObj])
                }
            }
            
            if self.strainArray.count == 0 {
                 self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 0])
            }
        }else if  self.valueSelected == valueChoose.isBudz.rawValue
        {
            self.StrainHeading = "My Favorite Adz Listing"
            if self.budzArrayFav.count == 0 {
                self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 0])
            }else{
                self.mainArray.append(["type" : profileSettings.BudzHeadingCell.rawValue ])
                
                for indexObj in 0..<self.budzArrayFav.count {
                    self.mainArray.append(["type" : profileSettings.BudzCell.rawValue , "index" : indexObj])
                }
            }
            
        }else  if  self.valueSelected == valueChoose.isActivity.rawValue
        {
            if self.budz_reviews.count != 0 {
                self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 3])
                
                if self.isBudzSelected {
                    
                    for indexObj in 0..<self.budz_reviews.count {
                        self.mainArray.append(["type" : profileSettings.BudzReview.rawValue , "index" : indexObj])
                    }
                }
                
            }
           
            if self.strain_reviews.count != 0 {
                self.mainArray.append(["type" : profileSettings.isQACell.rawValue , "index" : 4])
                
                
                if self.isStrainSelected {
                    for indexObj in 0..<self.strain_reviews.count {
                        self.mainArray.append(["type" : profileSettings.StrainReview.rawValue , "index" : indexObj])
                    }
                }
            }
            
            if self.strain_reviews.count == 0  && self.budz_reviews.count == 0 {
                self.mainArray.append(["type" : profileSettings.NoRecordFound.rawValue , "index" : 1])
            }
            
            
        }
        
        
        
        print(self.valueSelected)
        self.reloadTableview(tbleViewMain: self.tbleViewMain)
//        self.delayWithSeconds(0.2) {
//            self.reloadTableview(tbleViewMain: self.tbleViewMain)
//        }
    }
    func StrainAPICall(){
        self.isStrainApiCalled = true
        self.showLoading()
        self.strainArray.removeAll()
        
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_user_profile_strains.rawValue + user_id! ) { (successMain, messageMain, MainData) in
            self.hideLoading()
            print(MainData)
            
            
            if successMain {
                self.StrainHeading = "My Strains"
                let strainList = Mapper<Strain>().mapArray(JSONArray:MainData["successData"] as! [[String : Any]])
                
                
                self.strainArray = NSMutableArray(array: strainList) as! [Strain] //strainList as! NSMutableArray
                print(self.strainArray.count)
            }else {
             
            }
            self.ReloadData()
            
        }
    }
    
//    func BudzAPICall(){
//        self.showLoading()
//        self.budzArray.removeAll()
//
//        NetworkManager.GetCall(UrlAPI: WebServiceName.get_budz_profile.rawValue + (DataManager.sharedInstance.user?.ID)! ) { (successResponse, messageResponse, MainResponse) in
//            self.hideLoading()
//            print(MainResponse)
//
//
//            if successResponse {
//                self.StrainHeading = "My Favorite Adz Listing"
//
//                if (MainResponse["status"] as! String) == "success" {
//                    let mainData = MainResponse["successData"] as! [[String : Any]]
//                    for indexObj in mainData {
//                        self.budzArray.append(BudzMap.init(json: indexObj as [String : AnyObject] ))
//                    }
//
//                }else {
//                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
//                        DataManager.sharedInstance.logoutUser()
//                        self.ShowLogoutAlert()
//                    }
//                }
//            }else {
//                self.ShowErrorAlert(message:messageResponse)
//            }
//
//
//            self.ReloadData()
//
//        }
//    }
    
    
    
    func RegisterXib(){
        // Text Post Cell
        
        self.tbleViewMain.register(UINib(nibName: "NoRecodFoundCell", bundle: nil), forCellReuseIdentifier: "NoRecodFoundCell")
        
        self.tbleViewMain.register(UINib(nibName: "TextPostTableViewCell", bundle: nil), forCellReuseIdentifier: "TextPostTableViewCell")
        
        // Media Post Cell
        self.tbleViewMain.register(UINib(nibName: "MediaPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaPostTableViewCell")
        
        
        
            self.tbleViewMain.register(UINib(nibName: "QuestionProfileCell", bundle: nil), forCellReuseIdentifier: "QuestionProfileCell")

            self.tbleViewMain.register(UINib(nibName: "AnswerProfileCell", bundle: nil), forCellReuseIdentifier: "AnswerProfileCell")
        self.tbleViewMain.register(UINib(nibName: "StrainProfileCell", bundle: nil), forCellReuseIdentifier: "StrainProfileCell")
        self.tbleViewMain.register(UINib(nibName: "StrainReviewProfileCell", bundle: nil), forCellReuseIdentifier: "StrainReviewProfileCell")
        self.tbleViewMain.register(UINib(nibName: "BudzReviewProfileCell", bundle: nil), forCellReuseIdentifier: "BudzReviewProfileCell")
        self.tbleViewMain.register(UINib(nibName: "UserInfoHEaderCell", bundle: nil), forCellReuseIdentifier: "UserInfoHEaderCell")
        self.tbleViewMain.register(UINib(nibName: "profileSettingsTitleCell", bundle: nil), forCellReuseIdentifier: "profileSettingsTitleCell")
        self.tbleViewMain.register(UINib(nibName: "profileSettingsDetailCell", bundle: nil), forCellReuseIdentifier: "profileSettingsDetailCell")
        self.tbleViewMain.register(UINib(nibName: "QAProfileCell", bundle: nil), forCellReuseIdentifier: "QAProfileCell")
        self.tbleViewMain.register(UINib(nibName: "BudzMainMapCell", bundle: nil), forCellReuseIdentifier: "BudzMainMapCell")
        self.tbleViewMain.register(UINib(nibName: "UserProfileButtonCell", bundle: nil), forCellReuseIdentifier: "UserProfileButtonCell")
        self.tbleViewMain.register(UINib(nibName: "profileSettingsMedicalConditionsCell", bundle: nil), forCellReuseIdentifier: "profileSettingsMedicalConditionsCell")
        self.tbleViewMain.register(UINib(nibName: "LoadingMoreCell", bundle: nil), forCellReuseIdentifier: "LoadingMoreCell")
       
       
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
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
            case profileSettings.profileSettingsTitleCell.rawValue:
                return titleCell(tableView:tableView  ,cellForRowAt:indexPath)
            case profileSettings.profileSettingsUserInfo.rawValue:
                return profileInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
            case profileSettings.profileSettingsDetailCell.rawValue:
                        return DetailCell(tableView:tableView  ,cellForRowAt:indexPath)

            case profileSettings.profileBudzInfo.rawValue:
                    return BudzCell(tableView:tableView  ,cellForRowAt:indexPath)
        
            case profileSettings.profileSettingsMedicalConditionsCell.rawValue:
                return profileSettingsMedicalConditionsCell(tableView:tableView  ,cellForRowAt:indexPath)
        
            case profileSettings.profileButton.rawValue:
                return ProfileButton(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.StrainReview.rawValue:
            return StrainReviewCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.BudzReview.rawValue:
            return BudzReviewCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.QACell.rawValue:
            return QuestionMainCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.AnswerCell.rawValue:
            return AnswerMainCell(tableView:tableView  ,cellForRowAt:indexPath)
          
            case profileSettings.isQACell.rawValue:
                return QAProfileCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.StrainHeadingCell.rawValue:
            return StrainHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case profileSettings.BudzHeadingCell.rawValue:
            return BudzHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.NoRecordFound.rawValue:
            return NoRecodFoundCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.StrainCell.rawValue:
            return StrainProfileCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.BudzCell.rawValue:
            return BudzmainCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        case profileSettings.TextPostCell.rawValue,
             profileSettings.MediaPostCell.rawValue:
            return PostCell(tableView:tableView, cellForRowAt:indexPath)
            
        case profileSettings.LoadingMore.rawValue:
            return LoadingMoreCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        default:
            return profileInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is TextPostTableViewCell || cell is MediaPostTableViewCell  {
            let indexMain = self.mainArray[indexPath.row]
            let indexObj = indexMain["index"] as! Int
            
            if indexObj == feedDataController.postList.count - 1  {
                loadMore()
            }
        }
        
    }
    
    func LoadingMoreCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingMoreCell") as? LoadingMoreCell
        cell?.btnLoadMore.addTarget(self, action: #selector(self.LoadMoreFeeds), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func LoadMoreFeeds() {
        let myFeedVc = self.GetView(nameViewController: "MyWallViewController", nameStoryBoard: "Wall") as! MyWallViewController
        myFeedVc.other_user_id = self.user_id!
        self.navigationController?.pushViewController(myFeedVc, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
    func BudzCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudzMainMapCell") as? BudzMainMapCell
        cell?.selectionStyle = .none
        return cell!
    }
    
    func QuestionMainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionProfileCell") as? QuestionProfileCell
        
        let maindata = self.mainArray[indexPath.row]
        let indexMain  = maindata["index"] as! Int
        cell?.lblQuestion.applyTag(baseVC: self , mainText: self.userQuestion[indexMain].Question.RemoveHTMLTag().RemoveBRTag() )
        cell?.lblQuestion.text = self.userQuestion[indexMain].Question.RemoveHTMLTag().RemoveBRTag()
        print(self.userQuestion[indexMain].AnswerCount)
        cell?.lblAnswerCount.text = String(self.userQuestion[indexMain].AnswerCount)
        cell?.lblTimeAgo.text = self.GetTimeAgo(StringDate: self.userQuestion[indexMain].questiontime)
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func AnswerMainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerProfileCell") as? AnswerProfileCell
        let maindata = self.mainArray[indexPath.row]
        let indexMain  = maindata["index"] as! Int
        cell?.lblQuestion.applyTag(baseVC: self , mainText: self.userAnswer[indexMain].mainQuestion.Question)
        cell?.lblAnswerCount.applyTag(baseVC: self , mainText: String(self.userAnswer[indexMain].answer))
        cell?.lblQuestion.text = self.userAnswer[indexMain].mainQuestion.Question
        print(self.userAnswer[indexMain].answer)
        cell?.lblAnswerCount.text = String(self.userAnswer[indexMain].answer)
        cell?.lblTimeAgo.text = self.GetTimeAgo(StringDate: self.userAnswer[indexMain].answertime)
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func ProfileButton(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileButtonCell") as? UserProfileButtonCell
        
        cell?.btn_Home.isHidden = user_id == nil
        
        cell?.btn_Home.tag = indexPath.row
        cell?.btn_QA.tag = indexPath.row
        cell?.btn_Budz.tag = indexPath.row
        cell?.btn_Strain.tag = indexPath.row
        cell?.btn_Activity.tag = indexPath.row
        
        cell?.btn_Home.addTarget(self, action: #selector(self.Home_Show_Action), for: .touchUpInside)
        cell?.btn_QA.addTarget(self, action: #selector(self.QA_Show_Action), for: .touchUpInside)
        cell?.btn_Activity.addTarget(self, action: #selector(self.Activity_Show_Action), for: .touchUpInside)
        cell?.btn_Budz.addTarget(self, action: #selector(self.Budz_Show_Action), for: .touchUpInside)
        cell?.btn_Strain.addTarget(self, action: #selector(self.Strain_Show_Action), for: .touchUpInside)
        
        if self.valueSelected == valueChoose.isHome.rawValue{
            cell?.view_Home.backgroundColor = ConstantsColor.kHomeColor
            cell?.view_QA.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
            cell?.imgView_Home.image = #imageLiteral(resourceName: "budz_feeds_white")
            cell?.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
            cell?.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
            cell?.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
            cell?.imgView_Activity.image = #imageLiteral(resourceName: "Strain1")
        }else  if self.valueSelected == valueChoose.isQA.rawValue{
            cell?.view_Home.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_QA.backgroundColor = ConstantsColor.kQuestionColor
            cell?.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
            cell?.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
            cell?.imgView_QA.image = #imageLiteral(resourceName: "QAWhite")
            cell?.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
            cell?.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
            cell?.imgView_Activity.image = #imageLiteral(resourceName: "Strain1")
        }else  if self.valueSelected == valueChoose.isStrain.rawValue{
            cell?.view_Home.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_QA.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Strain.backgroundColor = ConstantsColor.kStrainColor
            cell?.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
            cell?.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
            cell?.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
            cell?.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
            cell?.imgView_Strain.image = #imageLiteral(resourceName: "StrainWhite")
            cell?.imgView_Activity.image  = #imageLiteral(resourceName: "Strain1")
        }else  if self.valueSelected == valueChoose.isBudz.rawValue{
            cell?.view_Home.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_QA.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Budz.backgroundColor = ConstantsColor.kBudzSelectColor
            cell?.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
            cell?.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
            cell?.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
            cell?.imgView_Budz.image = #imageLiteral(resourceName: "budz_map_white")
            cell?.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
            cell?.imgView_Activity.image = #imageLiteral(resourceName: "Strain1")
        }else  if self.valueSelected == valueChoose.isActivity.rawValue{
            cell?.view_Home.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_QA.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
            cell?.view_Activity.backgroundColor = ConstantsColor.kHomeColor
            cell?.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
            cell?.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
            cell?.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
            cell?.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
            cell?.imgView_Activity.image = #imageLiteral(resourceName: "Strain0")
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func StrainReviewCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StrainReviewProfileCell") as? StrainReviewProfileCell
        let arrayIndex = self.mainArray[indexPath.row]
        let indexObj = arrayIndex["index"] as! Int
        var strain_obg  =  self.strain_reviews[indexObj]
        if let strain = strain_obg["get_strain"] as? [String : Any]{
            if let title = strain["title"] as? String {
                cell?.lblName.text = title
            }
            if let type = strain["get_type"] as? [String : Any] {
                if let type_title = type["title"] as? String {
                 cell?.lblType.text = type_title
                }
            }
        }
        
        if let date  = strain_obg["created_at"] as? String{
            cell?.lblDate.text = self.getDateWithTh(date: date)//date.UTCToLocal(inputFormate: "yyyyy-MM-dd HH:mm:ss", outputFormate: "MMMM dd, yyyy")
        }
        
        if let review  = strain_obg["review"] as? String{
             cell?.lblText.applyTag(baseVC: self , mainText: review.RemoveHTMLTag())
            cell?.lblText.text = review.RemoveHTMLTag()
        }
        cell?.imgViewUpperMain.image = #imageLiteral(resourceName: "noimage")
        cell?.attachemt_type.isHidden = true
        if let attathcment  = strain_obg["attachment"] as? [String : Any]{
            if let type = attathcment["type"] as? String{
                cell?.attachemt_type.isHidden = false
                 if type == "video" {
                        if let img_path = attathcment["poster"] as? String{
                            cell?.imgViewUpperMain.moa.url = WebServiceName.images_baseurl.rawValue + img_path
                            cell?.attachemt_type.image = #imageLiteral(resourceName: "Video_play_icon_White")
                        }
                    }else{
                        if let img_path = attathcment["attachment"] as? String{
                            cell?.imgViewUpperMain.moa.url = WebServiceName.images_baseurl.rawValue + img_path
                            cell?.attachemt_type.image = #imageLiteral(resourceName: "gallery_gray")
                        }
                    }
               }
        }
        
        if let rating_obg = strain_obg["rating"] as? [String : Any] {
            if let rating  = rating_obg["rating"] as? Int{
                cell?.lblRatingDown.text = "\(rating)" + ".0"
                if rating == 0 {
                    cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain0B")
                }else if rating > 0 && rating <= 1{
                     cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain1B")
                }else if rating > 1 && rating <= 2{
                    cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain2B")
                }else if rating > 2 && rating <= 3{
                    cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain3B")
                }else if rating > 3 && rating <=  4{
                    cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain4B")
                }else{
                      cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain5B")
                }
            }else{
                 cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain0B")
                 cell?.lblRatingDown.text = "0"
            }
        }else{
            cell?.imgViewUpperDown.image = #imageLiteral(resourceName: "Strain0B")
            cell?.lblRatingDown.text = "0"
        }
        cell?.btnShare.addTarget(self, action: #selector(self.ShareAction), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func Home_Show_Action(sender: UIButton) {
        if self.tabClickedIndex != 1 {
            self.tabClickedIndex = 1
            self.valueSelected = valueChoose.isHome.rawValue
//            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UserProfileButtonCell
//
//            cellMain.view_Home.backgroundColor = ConstantsColor.kHomeColor
//
//            cellMain.view_QA.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.imgView_Home.image = #imageLiteral(resourceName: "budz_feeds_white")
//
//            cellMain.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
//            cellMain.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
//            cellMain.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
//            cellMain.imgView_Activity.image = #imageLiteral(resourceName: "Strain1B")
//            self.tbleViewMain.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
            self.ReloadData()
        }
    }
    
    func QA_Show_Action(sender : UIButton){
        if self.tabClickedIndex != 2 {
            self.tabClickedIndex = 2
            self.valueSelected = valueChoose.isQA.rawValue
            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UserProfileButtonCell
//            cellMain.view_Home.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_QA.backgroundColor = ConstantsColor.kQuestionColor
//            cellMain.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
//            cellMain.imgView_QA.image = #imageLiteral(resourceName: "QAWhite")
//            cellMain.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
//            cellMain.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
//            cellMain.imgView_Activity.image = #imageLiteral(resourceName: "Strain1B")
//            self.tbleViewMain.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
            self.ReloadData()
        }
        
    }
    
    func Strain_Show_Action(sender : UIButton){
        if self.tabClickedIndex != 3 {
            self.tabClickedIndex = 3
            self.valueSelected = valueChoose.isStrain.rawValue
//            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UserProfileButtonCell
//
//            cellMain.view_Home.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_QA.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.view_Strain.backgroundColor = ConstantsColor.kStrainColor
//
//            cellMain.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
//            cellMain.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
//            cellMain.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
//            cellMain.imgView_Strain.image = #imageLiteral(resourceName: "StrainWhite")
//            cellMain.imgView_Activity.image = #imageLiteral(resourceName: "Strain1B")
//             self.tbleViewMain.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
            self.ReloadData()
        }
    }
    
    func Budz_Show_Action(sender : UIButton){
        if self.tabClickedIndex != 4 {
            self.tabClickedIndex = 4
            self.valueSelected = valueChoose.isBudz.rawValue
//            self.StrainHeading = ""
//            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UserProfileButtonCell
//            cellMain.view_Home.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_QA.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.view_Budz.backgroundColor = ConstantsColor.kBudzSelectColor
//
//            cellMain.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Activity.backgroundColor = ConstantsColor.kDarkGrey
//
//            cellMain.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
//            cellMain.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
//            cellMain.imgView_Budz.image = #imageLiteral(resourceName: "BudzWhite")
//            cellMain.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
//            cellMain.imgView_Activity.image = #imageLiteral(resourceName: "Strain1B")
//             self.tbleViewMain.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
            if self.budzArrayFav.count == 0 {
                self.getFavBudz()
            }else{
                self.ReloadData()
            }
        }
        
        
    }
    func getFavBudz(){
          self.showLoading()
        let url = WebServiceName.user_my_get_budz_map.rawValue+"/\(UserProfileViewController.userMain.ID)" + "?time_zone=+05:00&skip=0&lat=\(DataManager.sharedInstance.user_locaiton?.latitude ?? 0.0)&lng=\(DataManager.sharedInstance.user_locaiton?.longitude ?? 0.0)&page_no=0"
        NetworkManager.GetCall(UrlAPI: url) { (isSuccess, response, responseObj) in
            self.hideLoading()
            if isSuccess {
                if let data = responseObj["successData"] as? [[String : Any]]{
                    self.budzArrayFav.removeAll()
                    for index in data{
                        self.budzArrayFav.append(BudzMap.init(json: index as? [String : AnyObject]))
                    }
                    self.ReloadData()
                }
            }else{
                self.ShowErrorAlert(message: response)
            }
        }
        
    }
    func Activity_Show_Action(sender : UIButton){
        if self.tabClickedIndex != 5 {
            self.tabClickedIndex = 5
            self.valueSelected = valueChoose.isActivity.rawValue
//            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UserProfileButtonCell
//            cellMain.view_Home.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_QA.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Budz.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Strain.backgroundColor = ConstantsColor.kDarkGrey
//            cellMain.view_Activity.backgroundColor = ConstantsColor.kStrainGreenColor
//            cellMain.imgView_Home.image = #imageLiteral(resourceName: "Tab6")
//            cellMain.imgView_QA.image = #imageLiteral(resourceName: "Tab0")
//            cellMain.imgView_Budz.image = #imageLiteral(resourceName: "calloutImage")
//            cellMain.imgView_Strain.image = #imageLiteral(resourceName: "Tab3")
//            cellMain.imgView_Activity.image = #imageLiteral(resourceName: "Strain0")
//             self.tbleViewMain.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
            if self.budz_reviews.count == 0 || self.strain_reviews.count == 0{
                self.getReviews()
            }else{
                self.ReloadData()
            }
        }
       
    }
    
    
    func getReviews() {
        self.showLoading()
        var url = WebServiceName.user_my_get_reviews.rawValue+"/\(UserProfileViewController.userMain.ID)"
        print(url)
       NetworkManager.GetCall(UrlAPI: WebServiceName.user_my_get_reviews.rawValue+"/\(UserProfileViewController.userMain.ID)") { (isSuccess, response, responseObj) in
        self.hideLoading()
            print(response)
            print(responseObj)
        if isSuccess {
            if let data = responseObj["successData"] as? [String : Any]{
                if let budz_reviw = data["budz_reviews"] as? [[String : Any]]{
                    for review in budz_reviw{
                        var sub = BudzReview(JSON: review)
                        sub?.bud = BudzMap.init(json: review["bud"] as! [String : AnyObject])
                        if let attach = review["attachments"] as? [[String: AnyObject]]{
                            sub?.attached = Attachment.init(json: attach.first)
                        }
                        self.budz_reviews.append(sub!)
                    }
                    print(self.budz_reviews)
                }
                if let strain_review = data["strains_reviews"] as? [[String : Any]]{
                    for strain in strain_review {
                        self.strain_reviews.append(strain)
                    }
                }
            }
        }else{
            self.ShowErrorAlert(message: response)
        }
            self.ReloadData()
        }
    }
    func titleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsTitleCell") as? profileSettingsTitleCell
        
        let indexData = self.mainArray[indexPath.row]
        cell?.btn_see_all.isHidden = true
        if (indexData["index"] as! Int) == 1 {
            cell?.lblMainHeading.text = "About This Bud"
            cell?.viewBG.backgroundColor = UIColor.gray
        }else if (indexData["index"] as! Int) == 2 {
            cell?.lblMainHeading.text = "My Experience"
            cell?.viewBG.backgroundColor = UIColor.gray
        }else if (indexData["index"] as! Int) == 3 {
            cell?.lblMainHeading.text = "My Budz Adz Listings"
            if self.budzArray.count > 2 {
                 cell?.btn_see_all.isHidden = false
            }else{
                cell?.btn_see_all.isHidden = true
                
            }
           
            
            cell?.viewBG.backgroundColor = ConstantsColor.kBudzSelectColor
        }else if (indexData["index"] as! Int) == 4 {
            cell?.lblMainHeading.text = "My Activity"
            cell?.viewBG.backgroundColor = UIColor.gray
        }
        cell?.btn_see_all.addTarget(self, action: #selector(self.onClickSeeAll), for: .touchUpInside)
        cell?.viewEdit.isHidden = true
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func onClickSeeAll() {
        if !self.isSeeAll{
            self.isSeeAll = true
            self.ReloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath)
        if cell is TextPostTableViewCell || cell is MediaPostTableViewCell  {
            let indexMain = self.mainArray[indexPath.row]
            let objectIndex = indexMain["index"] as! Int
            
            showFeedDetail(index: objectIndex)
        }
        else if cell is BudzMainMapCell {
            
            let indexMain = self.mainArray[indexPath.row]
            let indexpath = indexMain["index"] as! Int
            
            
            let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
            var  budz_obj = BudzMap()
            if self.valueSelected == valueChoose.isBudz.rawValue{
                budz_obj = self.budzArrayFav[indexpath]
            }else{
                budz_obj = self.budzArray[indexpath]
            }
            viewpush.chooseBudzMap = budz_obj
            self.navigationController?.pushViewController(viewpush, animated: true)
        }else  if cell is QuestionProfileCell || cell is AnswerProfileCell {
            print("QuestionProfileCell")
            let indexMain = self.mainArray[indexPath.row]
            let indexpath = indexMain["index"] as! Int
            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
//            DetailQuestionVc.QuestionID = String(self.userQuestion[indexpath].id)
            if cell is QuestionProfileCell {
                DetailQuestionVc.QuestionID = String(self.userQuestion[indexpath].id)
//                DetailQuestionVc.chooseQuestion = self.userQuestion[indexpath]
            }else {
                DetailQuestionVc.QuestionID = self.userAnswer[indexpath].question_ID
//                DetailQuestionVc.chooseQuestion = self.userAnswer[indexpath].mainQuestion
            }
//            DetailQuestionVc.isFromProfile = true
            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)

        }else  if cell is StrainProfileCell {
            print("StrainProfileCell")
            let indexMain = self.mainArray[indexPath.row]
            let indexpath = indexMain["index"] as! Int
            let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
//            detailView.chooseStrain = self.strainArray[indexpath].strain!
            detailView.IDMain = "\(self.strainArray[indexpath].strain?.strainID ?? 0)"
            self.navigationController?.pushViewController(detailView, animated: true)
            
        }else  if cell is StrainReviewProfileCell {
            print("StrainReviewProfileCell")
            let indexMain = self.mainArray[indexPath.row]
            let indexpath = indexMain["index"] as! Int
            var strain_obg  =  self.strain_reviews[indexpath]
            print(strain_obg)
            let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
            let strainobj = Strain()
            if let id =  strain_obg["strain_id"] as? NSNumber{
                  strainobj.strainID = id
                  detailView.IDMain = "\(id)"
            }else{
                  strainobj.strainID = 0
                  detailView.IDMain = "0"
            }
            print(detailView.IDMain)
            detailView.chooseStrain = strainobj
            self.navigationController?.pushViewController(detailView, animated: true)
            
        }else  if cell is BudzReviewProfileCell {
            print("BudzReviewProfileCell")
            let indexMain = self.mainArray[indexPath.row]
            let indexpath = indexMain["index"] as! Int
            let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
            var budz = self.budz_reviews[indexpath]
            budz.id = budz.sub_user_id!
            viewpush.chooseBudzMap = budz.bud!
            print(self.budz_reviews[indexpath].sub_user_id)
            self.navigationController?.pushViewController(viewpush, animated: true)
        }
    }
    func DetailCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsDetailCell") as? profileSettingsDetailCell
        if UserProfileViewController.userMain.Bio.isEmpty{
            cell?.lblText.text = "No biography available."
            cell?.lblText.textAlignment = .center
        }else{
            cell?.lblText.textAlignment = .left
            cell?.lblText.text = UserProfileViewController.userMain.Bio
        }
        cell?.imgViewLine.isHidden = true
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    
    
    func StrainHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StrainProfileCell") as? StrainProfileCell
        
        cell?.lblMain.text = self.StrainHeading
        cell?.lblMain.textColor = ConstantsColor.kStrainColor
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func BudzReviewCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudzReviewProfileCell") as? BudzReviewProfileCell
        let indexMain = self.mainArray[indexPath.row]
        let indexObj = indexMain["index"] as! Int
        var budz_review_object  = self.budz_reviews[indexObj]
        cell?.lblText.applyTag(baseVC: self , mainText:  (budz_review_object.text?.RemoveHTMLTag())!)
        cell?.lblText.text = budz_review_object.text?.RemoveHTMLTag()
        cell?.lblName.text = budz_review_object.bud?.budzMapType.title
        cell?.lblType.text = budz_review_object.bud?.title
        cell?.lblDistance.text = String((budz_review_object.bud?.distance.FloatValue())!) + " mi"
//        cell?.lblType.text = self.budzArray[indexObj].title
        cell?.imgViewOrganic.isHidden = true
        cell?.imgViewDeliver.isHidden = true
        
        if budz_review_object.bud?.is_organic == "1" {
            cell?.imgViewOrganic.isHidden = false
        }
        
        if budz_review_object.bud?.is_delivery == "1" {
            cell?.imgViewDeliver.isHidden = false
        }
        
        cell?.lblDate.text = self.getDateWithTh(date: (budz_review_object.created_at)!)//.GetDateWith(formate: "dd MMM yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
        cell?.lblRatingDown.text = String(format: "%.1f", budz_review_object.rating!)
        cell?.star1.image = #imageLiteral(resourceName: "starUnfilled")
        cell?.star2.image = #imageLiteral(resourceName: "starUnfilled")
        cell?.star3.image = #imageLiteral(resourceName: "starUnfilled")
        cell?.star4.image = #imageLiteral(resourceName: "starUnfilled")
        cell?.star5.image = #imageLiteral(resourceName: "starUnfilled")
        
        
        cell?.imgviewMain.moa.url = WebServiceName.images_baseurl.rawValue + (budz_review_object.bud?.logo.RemoveSpace())!

        
        if let bid = Int((budz_review_object.bud?.business_type_id)!){
        switch  bid{
        case 1 ,2:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
            break
            
        case 3:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
            break
        case 4:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
            break
        case 5:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Event.rawValue)
            break
        case 6:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 7:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 9:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Others.rawValue)
            break
        default:
            cell?.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
            
        }
        }
        
        
        
        
        cell?.imgViewUpperDown.isHidden = false
        cell?.attachemt_type.isHidden = true
        if budz_review_object.attached != nil {
            cell?.attachemt_type.isHidden = false
            print(WebServiceName.images_baseurl.rawValue + (budz_review_object.attached?.image_URL)!)
            cell?.attachemt_type.image = #imageLiteral(resourceName: "gallery_gray")
            cell?.imgViewUpperMain.moa.url = WebServiceName.images_baseurl.rawValue + (budz_review_object.attached?.image_URL)!.RemoveSpace()
        }
        
        
        cell?.btnShare.addTarget(self, action: #selector(self.ShareAction), for: .touchUpInside)
        if Double((cell!.lblRatingDown.text)!.FloatValue())! < 1.0 {
            if(Double((cell!.lblRatingDown.text)!.FloatValue())!) >= 0.1 {
                cell?.star1.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double((cell!.lblRatingDown.text)!.FloatValue())! < 2.0 {
            cell?.star1.image = #imageLiteral(resourceName: "starFilled")
            if(Double((cell!.lblRatingDown.text)!.FloatValue())!) >= 1.1 {
                 cell?.star2.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double((cell!.lblRatingDown.text)!.FloatValue())! < 3.0 {
            cell?.star1.image = #imageLiteral(resourceName: "starFilled")
            cell?.star2.image = #imageLiteral(resourceName: "starFilled")
            if(Double((cell!.lblRatingDown.text)!.FloatValue())!) >= 2.1 {
                cell?.star3.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double((cell!.lblRatingDown.text)!.FloatValue())! < 4.0 {
            cell?.star1.image = #imageLiteral(resourceName: "starFilled")
            cell?.star2.image = #imageLiteral(resourceName: "starFilled")
            cell?.star3.image = #imageLiteral(resourceName: "starFilled")
            if(Double((cell!.lblRatingDown.text)!.FloatValue())!) >= 3.1 {
                cell?.star4.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double((cell!.lblRatingDown.text)!.FloatValue())! < 5.0 {
            cell?.star1.image = #imageLiteral(resourceName: "starFilled")
            cell?.star2.image = #imageLiteral(resourceName: "starFilled")
            cell?.star3.image = #imageLiteral(resourceName: "starFilled")
            cell?.star4.image = #imageLiteral(resourceName: "starFilled")
            if(Double((cell!.lblRatingDown.text)!.FloatValue())!) >= 4.1 {
                cell?.star5.image = #imageLiteral(resourceName: "half_star")
            }
            
        }else  {
            cell?.star1.image = #imageLiteral(resourceName: "starFilled")
            cell?.star2.image = #imageLiteral(resourceName: "starFilled")
            cell?.star3.image = #imageLiteral(resourceName: "starFilled")
            cell?.star4.image = #imageLiteral(resourceName: "starFilled")
            cell?.star5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    func ShareAction(sender : UIButton){
        self.OpenShare()
    }
    
    func likedByActivity(index: Int){
        if  feedDataController.postList[index].likes?.count != 0 || feedDataController.postList[index].liked_count != 0{
            let likedActivity = self.GetView(nameViewController: "LikedByViewController", nameStoryBoard: "Wall") as! LikedByViewController
            likedActivity.feedDataController = self.feedDataController
            likedActivity.postIndex = index
            self.present(likedActivity, animated: true, completion: nil)
        }
    }
    
    func PostCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexMain = self.mainArray[indexPath.row]
        let indexObj = indexMain["index"] as! Int
        
        let post = feedDataController.postList[indexObj]
        var cell: TextPostTableViewCell!
        if post.postType == .text   {
            cell = tableView.dequeueReusableCell(withIdentifier: "TextPostTableViewCell", for: indexPath) as? TextPostTableViewCell
            cell.feedDataController = feedDataController
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MediaPostTableViewCell", for: indexPath) as? MediaPostTableViewCell
            cell.feedDataController = feedDataController
        }
        
//        if post.postType == .text{
//            cell?.scrapView.isHidden = true
//            cell?.urlViewHeight.constant = 0
//            if let url = self.slp.extractURL(text: post.discription!){
//                cell?.urlBtnAtion = { [unowned self] menuButton in
//                    self.OpenUrl(webUrl: url)
//                }
//                cell?.activityIndicate.startAnimating()
//                cell?.urlViewHeight.constant = 230
//                cell?.scrapView.isHidden  = false
//                let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString)
//                if cached?.count != nil{
//                    cell?.activityIndicate.stopAnimating()
//                    self.result = cached!
//                    cell?.selectionStyle = .none
//                    cell?.scrapSource.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                    cell?.urlViewTitle.text = self.result[.title] as? String
//                    cell?.urlViewDesc.text = self.result[.description] as? String
//                    //                    cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                    if let img_url = result[.image] as? String{
//                        cell?.urlViewImage.sd_setImage(with: URL.init(string: img_url), completed: { (image, error, chache, url) in
//                        })
//                    }
//                }else{
//                    self.slp.preview(post.discription!,
//                                     onSuccess: { result in
//                                        print(result)
//                                        cell?.activityIndicate.stopAnimating()
//                                        self.result = result
//                                        cell?.selectionStyle = .none
//                                        cell?.scrapSource.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                                        cell?.urlViewTitle.text = self.result[.title] as? String
//                                        cell?.urlViewDesc.text = self.result[.description] as? String
//                                        if let img_url = result[.image] as? String{
//                                            cell?.urlViewImage.sd_setImage(with: URL.init(string: img_url), completed: { (image, error, chache, url) in
//                                            })
//                                        }
//
//                    },
//                                     onError: { error in
//                                        print(error)
//                    }
//                    )
//
//                }
//            }
//        }
        
        let width = UIScreen.main.bounds.width - 90
        var h: CGFloat = 0.0
        var count = 0
        if (post.comments?.count)! > 2{
            count = 2
        }else{
            count = (post.comments?.count)!
        }
        for i in 0..<count{
            var commentHeight = CGFloat()
            let font = UIFont(name: "Lato-Light", size: 14.0)
            if let text = post.comments?[i].comment{
                commentHeight = self.heightForView(text: text, font: font!, width: width)
            }else{
                commentHeight = 0
            }
            if commentHeight > 30{
                if post.comments?[i].attachment != nil{
                    h = h + commentHeight + 70 + 150
                }else{
                    h = h + commentHeight + 70
                }
            }else{
                if post.comments?[i].attachment != nil{
                    h = h + 101.5 + 150
                }else{
                    h = h + 101.5
                }
            }
        }
        if (post.comments?.count)! > 0{
            if h < 101.5{
                cell?.commentTableViewHeight.constant = 101.5
            }else{
                cell?.commentTableViewHeight.constant = h
            }
        }else{
            cell?.commentTableViewHeight.constant = h
        }
        
        
        cell?.setTag(post: post)
        cell?.tagCollectionView.reloadData()
        cell?.isDetailScreen = false
        cell?.display(post: post, parentVC: self)
        cell?.index=indexObj
        cell?.timeAgoLabel.text = self.GetTimeAgoWall(StringDate: post.created_at!)
        cell.menuButton.tag=indexObj
        cell?.menuButtonAction = { [unowned self] menuButton in
            
            let  rectInTableView = tableView.rectForRow(at: indexPath)
            let rectInSuperview =  tableView.convert(rectInTableView, to: tableView.superview)
            let screen_hight  = UIScreen.main.bounds.height
            print("Cell Y Is =  \(rectInSuperview.origin.y) ,  screen hight  = \(screen_hight)" )
            var is_shown_on_top = false
            if rectInSuperview.origin.y < (screen_hight/2) {
                is_shown_on_top = false
            }else{
                is_shown_on_top = true
            }
            self.feedDataController.showPopoverMenu(isShownOnTop: is_shown_on_top, sender: menuButton, for: post, controller: self)    { menuAction in
                
                self.ReloadData()
            }
        }
        
        cell?.feedDetailAction = { [unowned self] index in
            self.showFeedDetail(index: index)
        }
        cell?.profileButtonAction = {[unowned self] userId in
            if let uId = self.user_id, uId == userId    {
                self.tbleViewMain.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                return
            }
            let sessionUserId = DataManager.sharedInstance.user!.ID
            var fdc: FeedDataController?
            if userId == sessionUserId  {
                fdc = self.feedDataController
            }
            self.OpenProfileVC(id: userId, feedDataController: fdc) 
        }
        cell?.LikedByAction = { [unowned self] menuButton in
            self.likedByActivity(index: indexObj)
        }
        cell?.likesButtonAction = {[unowned self] in
//            self.delayWithSeconds(0.01, completion: {
//                self.tbleViewMain.reloadData()
//            })
        
            self.feedDataController.performLike(cell: cell, index: indexObj, controller: self)
            
        }
        
        cell?.commentsButtonAction = {[weak self]  in
            self?.showFeedDetail(index: indexObj)
        }
        
        cell?.repostAction = {[weak self]  in
            // self?.handleRepostsAction(index: indexPath.row)
            if post.user_id!.stringValue != DataManager.sharedInstance.getPermanentlySavedUser()!.ID {
                self?.feedDataController.performRepost(cell: cell, index: indexObj, controller: self!, completion:{ (r) in
                    
                })
            }else {
                self?.ShowErrorAlert(message: "You can't repost your own post!")
            }
           
        }
        
        
        cell.baseVC = self
        return cell!
    }
    
    func BudzHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StrainProfileCell") as? StrainProfileCell
        
        cell?.lblMain.text = self.StrainHeading
        cell?.lblMain.textColor = ConstantsColor.kBudzSelectColor
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func StrainProfileCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StrainProfileCell") as? StrainProfileCell
        
        let indexMain = self.mainArray[indexPath.row]
        
        cell?.lblMain.text = self.strainArray[indexMain["index"] as! Int].strain?.title!
        cell?.lblMain.textColor = UIColor.white
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    
    func QAProfileCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "QAProfileCell") as? QAProfileCell
        
        let maindata = self.mainArray[indexPath.row]
        
       
        cell?.btnMain.tag = indexPath.row
        cell?.btnMain.addTarget(self, action: #selector(self.ShowQuestion), for: .touchUpInside)

        print(self.valueSelected)
        
        print(maindata["index"] as! Int)
        print(self.valueQASelected)
        print(self.valueAnsSelected)
        
        if (maindata["index"] as! Int) == 1 {
            cell?.lblMain.text = "My Q’s"
            if self.valueQASelected {
                 cell?.imgviewMain.image = #imageLiteral(resourceName: "downArrow")
            }else {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "upArrow")
            }
            cell?.lblMain.textColor = ConstantsColor.kQuestionColor
        }else  if (maindata["index"] as! Int) == 2 {
            if self.valueAnsSelected {
                 cell?.imgviewMain.image = #imageLiteral(resourceName: "downArrow")
            }else {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "upArrow")
            }
            cell?.lblMain.text = "My A’s"
            cell?.lblMain.textColor = ConstantsColor.kQuestionColor
        }else  if (maindata["index"] as! Int) == 3 {
            if self.isBudzSelected {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "downArrow")
            }else {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "upArrow")
            }
            cell?.lblMain.text = "My Budz Adz Reviews"
            cell?.lblMain.textColor = ConstantsColor.kBudzSelectColor
        }else  if (maindata["index"] as! Int) == 4 {
            if self.isStrainSelected {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "downArrow")
            }else {
                cell?.imgviewMain.image = #imageLiteral(resourceName: "upArrow")
            }
            cell?.lblMain.text = "My Strain Reviews"
            cell?.lblMain.textColor = ConstantsColor.kStrainColor
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func ShowQuestion(sender : UIButton){
        
         let maindata = self.mainArray[sender.tag]
        
        
        print(self.valueSelected)
        
        
         if (maindata["index"] as! Int) == 1 {
            if self.valueQASelected {
                self.valueQASelected = false
            }else {
                self.valueQASelected = true
            }
            
         }else if (maindata["index"] as! Int) == 2 {
            if self.valueAnsSelected {
                self.valueAnsSelected = false
            }else {
                self.valueAnsSelected = true
            }
         }else if (maindata["index"] as! Int) == 3 {
            if self.isBudzSelected {
                self.isBudzSelected = false
            }else {
                self.isBudzSelected = true
            }
         }else if (maindata["index"] as! Int) == 4 {
            if self.isStrainSelected {
                self.isStrainSelected = false
            }else {
                self.isStrainSelected = true
            }
        }
        
        self.ReloadData()
        
    }
    

    //MARK: settingCell0
    func profileInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoHEaderCell") as? UserInfoHEaderCell
        
        cell?.lblName.text = UserProfileViewController.userMain.userFirstName
        cell?.lblName.textColor = UserProfileViewController.userMain.colorMAin
        cell?.lblPoints.text = UserProfileViewController.userMain.Points
        cell?.lblBllomingBud.text = UserProfileViewController.userMain.bloomingBudText
        cell?.lblBllomingBud.textColor = UserProfileViewController.userMain.colorMAin
        cell?.img_indicator_line.backgroundColor = UserProfileViewController.userMain.colorMAin
        cell?.lblPoints.textColor = UserProfileViewController.userMain.colorMAin
        cell?.img_user_point_rating.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        cell?.img_user_point_rating.tintColor = UserProfileViewController.userMain.colorMAin
        cell?.lblFollowersCount.text = UserProfileViewController.userMain.followers_count
        cell?.lblFollowingCount.text = UserProfileViewController.userMain.followings_count
        if UserProfileViewController.userMain.profilePictureURL.contains("facebook.com") || UserProfileViewController.userMain.profilePictureURL.contains("google.com"){
            cell?.imgViewUSer.sd_setImage(with: URL.init(string: UserProfileViewController.userMain.profilePictureURL.RemoveSpace()),placeholderImage: #imageLiteral(resourceName: "noimage") , completed: nil)
        }else{
            cell?.imgViewUSer.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.profilePictureURL.RemoveSpace()),placeholderImage: #imageLiteral(resourceName: "noimage") , completed: nil)
        }
        if UserProfileViewController.userMain.special_icon.characters.count > 6 {
            cell?.imgViewUSerTop.isHidden = false
            cell?.imgViewUSerTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.special_icon.RemoveSpace()),placeholderImage: #imageLiteral(resourceName: "topi_ic") , completed: nil)
        }else {
            cell?.imgViewUSerTop.isHidden = true
        }
        cell?.imgViewCover.image = nil
        cell?.imgViewCover.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + UserProfileViewController.userMain.coverPhoto.RemoveSpace()), completed: nil)
        cell?.imgViewCover.contentMode = .scaleAspectFill
        if UserProfileViewController.userMain.ID == DataManager.sharedInstance.user?.ID {
            cell?.viewMessage.isHidden = true
            cell?.viewLogout.isHidden = false
            cell?.viewFollow.isHidden = true
            cell?.lblFollow.isHidden = true
            cell?.btn_Follow.isHidden = true
            cell?.btn_Following.isHidden = false
            cell?.btn_Followers.isHidden = false
            cell?.viewEdit.isHidden = false
            cell?.lblHbGallery.text = "Edit My HB Gallery"
            
        }else {
            cell?.lblHbGallery.text = "     My HB Gallery"
            cell?.viewLogout.isHidden = true
            cell?.viewEdit.isHidden = true
            cell?.viewMessage.isHidden = false
            cell?.viewFollow.isHidden = false
            cell?.lblFollow.isHidden = false
            cell?.btn_Following.isHidden = true
            cell?.btn_Followers.isHidden = true
            cell?.btn_Follow.isHidden = false
            
            print(UserProfileViewController.userMain.is_following_count)
            
            if UserProfileViewController.userMain.is_following_count != nil {
            if UserProfileViewController.userMain.is_following_count.characters.count > 0  {
                if Int(UserProfileViewController.userMain.is_following_count)! > 0 {
                    cell?.imgViewFollow.image = #imageLiteral(resourceName: "crossQA")
                    cell?.lblFollow.text = "Unfollow"
                }else {
                    
                    cell?.lblFollow.text = "Follow"
                    cell?.imgViewFollow.image = #imageLiteral(resourceName: "AddGreen")
                }
            }else {
                
                cell?.lblFollow.text = "Follow"
                cell?.imgViewFollow.image = #imageLiteral(resourceName: "AddGreen")
                }
                
            }else {
                
                cell?.lblFollow.text = "Follow"
                cell?.imgViewFollow.image = #imageLiteral(resourceName: "AddGreen")
            }
            
        }
        
        cell?.btn_BoomingBud.addTarget(self, action: #selector(self.BloomingBud), for: UIControlEvents.touchUpInside)
        
        cell?.btn_Message.addTarget(self, action: #selector(self.ChatStart), for: UIControlEvents.touchUpInside)

        
        
        cell?.btn_Logout.addTarget(self, action: #selector(self.Logout), for: UIControlEvents.touchUpInside)

        
        

            cell?.btn_Followers.addTarget(self, action: #selector(self.ShowFollowers), for: UIControlEvents.touchUpInside)

            cell?.btn_Following.addTarget(self, action: #selector(self.ShowFollowing), for: UIControlEvents.touchUpInside)
        
        
        cell?.btn_Follow.addTarget(self, action: #selector(self.FollowUser), for: UIControlEvents.touchUpInside)

        
                cell?.btn_Back.addTarget(self, action: #selector(self.BackAction), for: UIControlEvents.touchUpInside)
        
        cell?.btn_Edit.addTarget(self, action: #selector(self.EditProfile), for: UIControlEvents.touchUpInside)

        
                cell?.btn_Home.addTarget(self, action: #selector(self.HomeAction), for: UIControlEvents.touchUpInside)
        
        
        cell?.btn_Gallery.addTarget(self, action: #selector(self.ShowGallery), for: UIControlEvents.touchUpInside)

        
//                cell?.btn_EditCoverPhoto.addTarget(self, action: #selector(self.EditoverPhotoAction), for: UIControlEvents.touchUpInside)
        
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func FollowUser(){
        var newPAram  = [String : AnyObject]()
        newPAram["followed_id"] = UserProfileViewController.userMain.ID as AnyObject
        
        var urlMain = WebServiceName.follow_user.rawValue
        if Int(UserProfileViewController.userMain.is_following_count)! > 0 {
            urlMain = WebServiceName.un_follow.rawValue
        }
        self.showLoading()
        NetworkManager.PostCall(UrlAPI:urlMain , params: newPAram) { (success, MessageSingle, MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if success {
                
                if (MainResponse["status"] as! String) == "error" {
                    self.ShowErrorAlert(message: MainResponse["errorMessage"] as! String)
                    
                }else {
                    
                    let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! UserInfoHEaderCell
                    
                    
                    if Int(UserProfileViewController.userMain.is_following_count)! > 0 {
                        cellMain.imgViewFollow.image = #imageLiteral(resourceName: "AddGreen")
                        cellMain.lblFollow.text = "Follow"
                        UserProfileViewController.userMain.is_following_count = "0"
                        
                    }else {
                        cellMain.lblFollow.text = "Unfollow"
                        
                        cellMain.imgViewFollow.image = #imageLiteral(resourceName: "crossQA")
                        UserProfileViewController.userMain.is_following_count = "1"
                    }
                    
                    self.ShowSuccessAlertWithNoAction(message:  MainResponse["successMessage"] as! String)
                    //                self.ShowErrorAlert(message: "Following Successfully." , AlertTitle: "")
                }
                 self.reloadTableview(tbleViewMain: self.tbleViewMain)
            }else{
                if !MessageSingle.isEmpty {
                     self.ShowErrorAlert(message: MessageSingle)
                }
            }
        }
    }
    func ChatStart(sender : UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
        
        vc.isSelectUser = true
        isRefreshonWillAppear = true
        vc.selectUser = UserProfileViewController.userMain

        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func ShowFollowers(sender : UIButton){
        mainFollowers = self.GetView(nameViewController: "FollowersViewController", nameStoryBoard: "ProfileView") as! FollowersViewController
        (mainFollowers as! FollowersViewController).isFollower = true
        (mainFollowers as! FollowersViewController).UserID = self.user_id!
        (mainFollowers as! FollowersViewController).delegate = self
        self.followScreen = true
        self.view.addSubview(mainFollowers.view)
    }
    
    func ShowFollowing(sender : UIButton){
        mainFollowers = self.GetView(nameViewController: "FollowersViewController", nameStoryBoard: "ProfileView") as! FollowersViewController
        (mainFollowers as! FollowersViewController).isFollower = false
        (mainFollowers as! FollowersViewController).UserID = self.user_id!
        (mainFollowers as! FollowersViewController).delegate = self
        self.followScreen = true
        self.view.addSubview(mainFollowers.view)
    }
    
    func Logout(sender : UIButton){
        var params = [String: AnyObject]()
        params["device_id"] = DataManager.sharedInstance.deviceToken as? AnyObject
        NetworkManager.PostCall(UrlAPI: WebServiceName.logout.rawValue, params: params) { (success, response, MainResponse) in
            print(success)
            print(response)
            print(MainResponse)
        }

        DataManager.sharedInstance.logoutUser()
        //
        let userDefaults = UserDefaults.standard
        userDefaults.setValue("0", forKey: "firstView")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushLoginView"), object: nil)
        
    }
    func ShowGallery(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "UserGalleryViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserGalleryViewController
        viewMain.userName = UserProfileViewController.userMain.userFirstName
        viewMain.userID = UserProfileViewController.userMain.ID
        self.navigationController?.pushViewController(viewMain, animated: true) 
    }
    
    func BloomingBud(sender : UIButton){
         let viewMain = self.GetView(nameViewController: "BloomingBudViewController", nameStoryBoard: StoryBoardConstant.Profile) as! BloomingBudViewController
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
    }
    
    @IBAction func onClickBack(_ sender : UIButton){
        self.BackAction()
    }
    @IBAction func onClickHome(_ sender : UIButton){
       self.GotoHome()
    }
    func BackAction(){
        if afterCompletion != 1{
        self.navigationController?.popViewController(animated: true)
        }else{
            self.GotoHome()
        }
    }
    
    func EditProfile(){
        let profileEdit = self.GetView(nameViewController: "profileSettingsVC", nameStoryBoard: StoryBoardConstant.Main) as! profileSettingsVC

        profileEdit.userMain = UserProfileViewController.userMain
        profileEdit.experty1 = self.experty1
        profileEdit.experty2 = self.experty2
        if expery_Two == ""{
            profileEdit.expery_Two = "None Listed"
        }else{
            profileEdit.expery_Two = self.expery_Two
        }
        if expery_One == ""{
            profileEdit.expery_One = "None Listed"
        }else{
            profileEdit.expery_One = self.expery_One
        }
        self.navigationController?.pushViewController(profileEdit, animated: true)
    }
    func HomeAction(){
        self.GotoHome()
    }
    
    func profileSettingsMedicalConditionsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsMedicalConditionsCell") as? profileSettingsMedicalConditionsCell
        
        
        cell?.medicalExpertyWarnView1.isHidden = true
        cell?.medicalExpertyWarnView2.isHidden = true
        cell?.medicalExpertyWarnView3.isHidden = true
        cell?.medicalExpertyWarnView4.isHidden = true
        cell?.medicalExpertyWarnView5.isHidden = true
        
        cell?.strainExpertyWarnView1.isHidden = true
        cell?.strainExpertyWarnView2.isHidden = true
        cell?.strainExpertyWarnView3.isHidden = true
        cell?.strainExpertyWarnView4.isHidden = true
        cell?.strainExpertyWarnView5.isHidden = true
        
        
        // hide vies
        cell?.medicalExpertyView1.isHidden = true
        cell?.medicalExpertyView2.isHidden = true
        cell?.medicalExpertyView3.isHidden = true
        cell?.medicalExpertyView4.isHidden = true
        cell?.medicalExpertyView5.isHidden = true
        cell?.medicalExpertyView1.isHidden = true
        cell?.stackView1Height.constant = 0
        
        
        cell?.strainExpertyView1.isHidden = true
        cell?.strainExpertyView2.isHidden = true
        cell?.srainExpertyView3.isHidden = true
        cell?.strainExpertyView4.isHidden = true
        cell?.strainExpertyView5.isHidden = true
        cell?.stackView2Height.constant = 0
        cell?.strainExpertyView1.isHidden = true
        
        print(self.expery_One)
        print(self.expery_Two)
        cell?.lblMedicalConditions.isHidden = false
        cell?.lblStrains.isHidden = false
        if expery_Two == ""{
            cell?.lblStrains.text = "None Listed"
        }else{
            cell?.lblStrains.text = self.expery_Two
        }
        if expery_One == ""{
            cell?.lblMedicalConditions.text = "None Listed"
        }else{
            cell?.lblMedicalConditions.text = self.expery_One
        }
//        if experty1.count > 0{
//         for i in 0...self.experty1.count-1{
//            switch i{
//            case 0:
//                cell?.stackView1Height.constant = 25
//                cell?.medicalExpertyView1.isHidden = false
//                cell?.medicalExpertyLabel1.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView1.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView1.isHidden = true
//                }
//            case 1:
//                cell?.stackView1Height.constant = 50
//                cell?.medicalExpertyView2.isHidden = false
//                cell?.medicalExpertyLabel2.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView2.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView2.isHidden = true
//                }
//            case 2:
//                cell?.stackView1Height.constant = 75
//                cell?.medicalExpertyView3.isHidden = false
//                cell?.medicalExpertyLabel3.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView3.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView3.isHidden = true
//                }
//            case 3:
//                cell?.stackView1Height.constant = 100
//                cell?.medicalExpertyView4.isHidden = false
//                cell?.medicalExpertyLabel4.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView4.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView4.isHidden = true
//                }
//            case 4:
//                cell?.stackView1Height.constant = 125
//                cell?.medicalExpertyView5.isHidden = false
//                cell?.medicalExpertyLabel5.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView5.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView5.isHidden = true
//                }
//
//            default:
//                cell?.stackView1Height.constant = 0
//                cell?.medicalExpertyView1.isHidden = false
//                cell?.medicalExpertyLabel1.text = self.experty1[i].title
//                if self.experty1[i].is_approved == 0{
//                    cell?.medicalExpertyWarnView1.isHidden = false
//                }else{
//                    cell?.medicalExpertyWarnView1.isHidden = true
//                }
//            }
//          }
//        }else{
//            cell?.lblMedicalConditions.isHidden = false
//              cell?.lblMedicalConditions.text = "None Listed"
//        }
//        if experty2.count > 0{
//            for i in 0...self.experty2.count-1{
//                switch i{
//                case 0:
//                    cell?.stackView2Height.constant = 25
//                    cell?.strainExpertyView1.isHidden = false
//                    cell?.strainExpertyLabel1.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView1.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView1.isHidden = true
////                    }
//                case 1:
//                    cell?.stackView2Height.constant = 50
//                    cell?.strainExpertyView2.isHidden = false
//                    cell?.strainExpertyLabel2.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView2.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView2.isHidden = true
////                    }
//                case 2:
//                    cell?.stackView2Height.constant = 75
//                    cell?.srainExpertyView3.isHidden = false
//                    cell?.strainExpertyLabel3.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView3.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView3.isHidden = true
////                    }
//                case 3:
//                    cell?.stackView2Height.constant = 100
//                    cell?.strainExpertyView4.isHidden = false
//                    cell?.strainExpertyLabel4.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView4.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView4.isHidden = true
////                    }
//                case 4:
//                    cell?.stackView2Height.constant = 125
//                    cell?.strainExpertyView5.isHidden = false
//                    cell?.strainExpertyLabel5.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView5.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView5.isHidden = true
////                    }
//
//                default:
//                    cell?.stackView2Height.constant = 0
//                    cell?.strainExpertyView1.isHidden = false
//                    cell?.strainExpertyLabel1.text = self.experty2[i].title
////                    if self.experty2[i].approved == 0{
////                        cell?.strainExpertyWarnView1.isHidden = false
////                    }else{
////                        cell?.strainExpertyWarnView1.isHidden = true
////                    }
//                }
//            }
//        }else{
//            cell?.lblStrains.isHidden = false
//            cell?.lblStrains.text = "None Listed"
//        }
        cell?.selectionStyle = .none
        cell?.setMedicalLayout(numbr: self.experty1.count)
        cell?.setStrainLayout(numbr: self.experty2.count)
        return cell!
    }
    
    func NoRecodFoundCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:NoRecodFoundCell = (tableView.dequeueReusableCell(withIdentifier: "NoRecodFoundCell") as?
            NoRecodFoundCell)!
        cell.selectionStyle = .none
        
        return cell
    }
    func BudzmainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:BudzMainMapCell = (tableView.dequeueReusableCell(withIdentifier: "BudzMainMapCell") as?
            BudzMainMapCell)!
        
        
        let indexMain = self.mainArray[indexPath.row]
        let indexpath = indexMain["index"] as! Int
        var  budz_obj = BudzMap()
        if self.valueSelected == valueChoose.isBudz.rawValue && indexpath < self.budzArrayFav.count && indexPath.row > 8 {
            budz_obj = self.budzArrayFav[indexpath]
        }else{
             budz_obj = self.budzArray[indexpath]
        }
        
        cell.lblName.text = budz_obj.title
        cell.lblDistance.text = String(budz_obj.distance)
        cell.lblreview.text = String(budz_obj.reviews.count) + " Reviews"
        cell.lblType.text = budz_obj.budzMapType.title
        if budz_obj.is_organic == "0" {
            cell.imgviewOrganic.isHidden = true
        }else {
            cell.imgviewOrganic.isHidden = false
        }
        
        if budz_obj.is_delivery == "0" {
            cell.imgviewDelivery.isHidden = true
        }else {
            cell.imgviewDelivery.isHidden = false
        }
        
        switch Int(budz_obj.business_type_id)! {
        case 1 ,2:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Dispencery.rawValue)
            break
            
        case 3:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Cannabites.rawValue)
            break
        case 4:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Entertainment.rawValue)
            break
        case 5:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Event.rawValue)
            break
        case 6:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 7:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        case 9:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Others.rawValue)
            break
            
        default:
            cell.imgviewType.image = UIImage.init(named: BudzIcon.Medical.rawValue)
            break
        }
        
        
        cell.imgviewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        cell.imgviewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        if Double(budz_obj.rating_sum)! < 1 {
            if Double(budz_obj.rating_sum)! >= 0.5{
                
                cell.imgviewStar1.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(budz_obj.rating_sum)! < 2 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            if Double(budz_obj.rating_sum)! >= 1.5{
                
                cell.imgviewStar2.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(budz_obj.rating_sum)! < 3 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            if Double(budz_obj.rating_sum)! >= 2.5{
                
                cell.imgviewStar3.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(budz_obj.rating_sum)! < 4 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            if Double(budz_obj.rating_sum)! >= 3.5{
                
                cell.imgviewStar4.image = #imageLiteral(resourceName: "half_star")
            }
        }else if Double(budz_obj.rating_sum)! < 5 {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            if Double(budz_obj.rating_sum)! >= 4.5{
                
                cell.imgviewStar5.image = #imageLiteral(resourceName: "half_star")
            }
        }else {
            cell.imgviewStar1.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar2.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar3.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar4.image = #imageLiteral(resourceName: "starFilled")
            cell.imgviewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        if budz_obj.is_featured == 1 {
            cell.view_BG.backgroundColor = UIColor.black
            cell.view_featured.isHidden = false
            cell.view_DottedLine.isHidden = false
        }
        else{
            cell.view_BG.backgroundColor = UIColor.init(red: (35/255), green: (35/255), blue: (35/255), alpha: 1.0)
            cell.view_featured.isHidden = true
            cell.view_DottedLine.isHidden = true
        }
        cell.imgviewUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + budz_obj.logo.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "leafCirclePink") , completed: nil)

        cell.imgviewType.RoundView()
        cell.view_featured.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func ReloadFollowersData(notification: NSNotification){
        
        if let count = notification.userInfo?["count"] as? String {
            let cellMain = self.tbleViewMain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! UserInfoHEaderCell

            
                UserProfileViewController.userMain.followings_count = String(Int(UserProfileViewController.userMain.followings_count)! + Int(count)!)
                cellMain.lblFollowingCount.text = UserProfileViewController.userMain.followings_count

        }
    }
    
    
}

//MARK:
//MARK: Button Actions

extension UserProfileViewController {
    @IBAction func GoBack_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
    }
}


class UserInfoHEaderCell : UITableViewCell {
    @IBOutlet var btn_Message : UIButton!
    @IBOutlet var btn_Logout : UIButton!
    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Home : UIButton!
    @IBOutlet var btn_Followers : UIButton!
    @IBOutlet var btn_Follow : UIButton!
    @IBOutlet var btn_Following : UIButton!
    @IBOutlet var btn_Gallery : UIButton!
    @IBOutlet var btn_BoomingBud : UIButton!
    @IBOutlet var btn_Edit : UIButton!
    
    @IBOutlet weak var img_user_point_rating: UIImageView!
    @IBOutlet weak var img_indicator_line: UIImageView!
    @IBOutlet var imgViewUSer  : UIImageView!
    @IBOutlet var imgViewUSerTop  : UIImageView!
    @IBOutlet var imgViewFollow  : UIImageView!
    @IBOutlet var imgViewCover  : UIImageView!
    
    @IBOutlet var lblName  : UILabel!
    @IBOutlet var lblBllomingBud  : UILabel!
    @IBOutlet var lblHbGallery  : UILabel!
    @IBOutlet var lblPoints  : UILabel!
    @IBOutlet var lblFollowersCount  : UILabel!
    @IBOutlet var lblFollowingCount  : UILabel!
    
    @IBOutlet var viewEdit  : UIView!
    @IBOutlet var viewFollow  : UIView!
    @IBOutlet var viewLogout  : UIView!
    @IBOutlet var viewMessage  : UIView!
    @IBOutlet var lblFollow  : UILabel!
    
}


class UserProfileButtonCell : UITableViewCell {
    @IBOutlet var btn_Home : UIButton!
    @IBOutlet var btn_QA : UIButton!
    @IBOutlet var btn_Strain : UIButton!
    @IBOutlet var btn_Budz : UIButton!
    @IBOutlet var btn_Activity : UIButton!
    
    @IBOutlet var view_Home : UIView!
    @IBOutlet var view_QA : UIView!
    @IBOutlet var view_Strain : UIView!
    @IBOutlet var view_Budz : UIView!
    @IBOutlet var view_Activity : UIView!
    
    @IBOutlet var imgView_Home : UIImageView!
    @IBOutlet var imgView_QA : UIImageView!
    @IBOutlet var imgView_Strain : UIImageView!
    @IBOutlet var imgView_Budz : UIImageView!
    @IBOutlet var imgView_Activity : UIImageView!
}

class QAProfileCell : UITableViewCell {
    @IBOutlet var imgviewMain : UIImageView!
    @IBOutlet var btnMain : UIButton!
    @IBOutlet var lblMain : UILabel!
}

class QuestionProfileCell :UITableViewCell{
    @IBOutlet var lblQuestion : ActiveLabel!
    @IBOutlet var lblAnswerCount : UILabel!
    @IBOutlet var lblTimeAgo : UILabel!
}

class AnswerProfileCell :UITableViewCell{
    @IBOutlet var lblQuestion : ActiveLabel!
    @IBOutlet var lblAnswerCount : ActiveLabel!
    @IBOutlet var lblTimeAgo : UILabel!
}


class StrainProfileCell : UITableViewCell {
    @IBOutlet var lblMain : UILabel!
}

class StrainReviewProfileCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblRatingUpper : UILabel!
    @IBOutlet var lblRatingDown : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblText : ActiveLabel!
    
    @IBOutlet var btnShare : UIButton!
    
    @IBOutlet var imgViewUpperRating : UIImageView!
    @IBOutlet var imgViewUpperDown : UIImageView!
    @IBOutlet var attachemt_type : UIImageView!
    
    @IBOutlet var imgViewUpperMain : UIImageView!
}


class BudzReviewProfileCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblRatingDown : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblText : ActiveLabel!
    @IBOutlet var lblDistance : UILabel!
    
     @IBOutlet var attachemt_type : UIImageView!
    @IBOutlet var imgViewOrganic : UIImageView!
    @IBOutlet var imgViewDeliver : UIImageView!
    @IBOutlet var imgViewUpperDown : UIImageView!
    @IBOutlet var imgviewType : UIImageView!
    @IBOutlet var imgviewMain : UIImageView!
    
    
    @IBOutlet var star1 : UIImageView!
    @IBOutlet var star2 : UIImageView!
    @IBOutlet var star3 : UIImageView!
    @IBOutlet var star4 : UIImageView!
    @IBOutlet var star5 : UIImageView!
    
    @IBOutlet var btnShare : UIButton!
    
    @IBOutlet var imgViewUpperMain : UIImageView!
}


