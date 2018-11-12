//
//  UserWallViewController.swift
//  BaseProject
//
//  Created by waseem on 16/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import Popover
import SwiftLinkPreview

import CoreLocation


class UserWallViewController: BaseViewController , CLLocationManagerDelegate{
    @IBOutlet weak var img_feed: UIImageView!
    @IBOutlet weak var img_shoutout: UIButton!
    @IBOutlet weak var btn_bdz: UIButton!
    @IBOutlet weak var top_indicator: UIButton!
    @IBOutlet weak var indicator_close: UIButton!
    @IBOutlet weak var Lbl_budz_feed_count: UILabel!
    @IBOutlet weak var Lbl_shout_out_count: UILabel!
    @IBOutlet weak var View_budzfeed_notification_badge: CircleView!
    @IBOutlet weak var View_shout_out_notification_badge: CircleView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shoutOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableViewGroups: UITableView!
    @IBOutlet weak var btnApply: RoundButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var noPostFound:UILabel!
    @IBOutlet weak var viewFilter: filterView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var currentPageIndex = 0
    fileprivate var shouldLoadMore = true
    @IBOutlet weak var imgUserPorfile: CircularImageView!
    @IBOutlet weak var imgUserPorfileTop: UIImageView!
    
    let feedDataController = FeedDataController()
    var filtersListCached = ["Newest","Followers First","Most Liked"]
    var filterList = ["Newest","Followers First","Most Liked"]
    var postindex: Int!
    var iLiked = false
    var isFilterOpen = false
    var isGoToLiked = false
    var isNotificationAprrear = false
    
    var locationManager: CLLocationManager!
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        DataManager.sharedInstance.setLocation(loaciton: locValue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegate.active_navigation_controller = self.navigationController
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getNotificationCount), name: NSNotification.Name(rawValue: "NewNotification"), object: nil)
        //Mark : Apply Green Theme
        btn_bdz.setImage(#imageLiteral(resourceName: "QABuzFeed").withRenderingMode(.alwaysTemplate), for: .normal)
        btn_bdz.tintColor = UIColor.init(hex: "7cc245")
        
        img_feed.image = #imageLiteral(resourceName: "feed-plus").withRenderingMode(.alwaysTemplate)
        img_feed.tintColor = UIColor.init(hex: "7cc245")

        img_shoutout.setImage(#imageLiteral(resourceName: "QAHootOut").withRenderingMode(.alwaysTemplate), for: .normal)
        img_shoutout.tintColor = UIColor.init(hex: "7cc245")
        
        top_indicator.setImage(#imageLiteral(resourceName: "groups_menu_indicator").withRenderingMode(.alwaysTemplate), for: .normal)
        top_indicator.tintColor = UIColor.init(hex: "7cc245")
        
        
        indicator_close.setImage(#imageLiteral(resourceName: "groups_menu_indicator_close").withRenderingMode(.alwaysTemplate), for: .normal)
        indicator_close.tintColor = UIColor.init(hex: "7cc245")
        

        tableView.backgroundColor = UIColor.init(hex: "2F2F2F")
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToProfile), name:NSNotification.Name(rawValue: "LikerProfile"), object: nil)
        self.viewFilter.center.y = -325
        self.viewFilter.selectedIndex = wallSelectedFilter
        tableView.reloadData()
        self.btnApply.setTitle("SEND", for: .normal)
        configure()
        addObserver()
        if DataManager.sharedInstance.user?.subUserCount == 0{
            self.shoutOutButton.isHidden = true
            self.View_shout_out_notification_badge.isHidden = true
        }
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "OpenShoutOut"), object: nil)
        
       
    }
    
    func getNotificationCount(){
        
        self.RefreshData {
            self.isNotificationAprrear =  true
            self.UpdateUI(user: DataManager.sharedInstance.getPermanentlySavedUser()!)
        }
    }
    
    // handle notification
    func showSpinningWheel(_ notification: NSNotification) {
        if let id = notification.userInfo?["sout_out_id"] as? String {
           self.openShoutOutPopup(id: id)
        }
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
                }
               
            }
        }
    }
    func UpdateUI(user : User) {
        if self.isNotificationAprrear{
            self.playSound(named: "click_hb")
            self.isNotificationAprrear =  false
        }
        if user.shout_outs_count.intValue == 0{
            self.View_shout_out_notification_badge.isHidden = true
        }
        if user.subUserCount.intValue != 0{
            self.View_shout_out_notification_badge.isHidden = true
            if user.shout_outs_count.intValue == 0{
                self.View_shout_out_notification_badge.isHidden = true
            }
            self.shoutOutButton.isHidden = false
            self.Lbl_shout_out_count.text = "\(user.shout_outs_count.intValue)"
        }else {
             self.View_shout_out_notification_badge.isHidden = true
        }
        self.Lbl_shout_out_count.isHidden = true
        if user.notifications_count.intValue == 0{
            self.View_budzfeed_notification_badge.isHidden = true
        }else{
            self.View_budzfeed_notification_badge.isHidden = false
            self.Lbl_budz_feed_count.text = "\(user.notifications_count.intValue)"
        }
    }
    
    @IBAction func ShowShoutOut_Action(sender : UIButton){
        self.PushViewWithStoryBoard(nameViewController: "ShoutOutListVC", nameStoryBoard: "ShoutOut")
    }
    
    
    @IBAction func ShowBudzFeed(sender : UIButton){
        let mainView =  self.GetView(nameViewController: "MainBudzFeedViewController", nameStoryBoard: "BudzStoryBoard")
        self.navigationController?.pushViewController(mainView, animated: true)
    }
    
    @IBAction func ShowSearchUpper(sender : UIButton){
        self.navigationController?.pushViewController(self.GetView(nameViewController: "QAMainSearchViewController", nameStoryBoard: "QAStoryBoard"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .budUnfollowed, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isfromYoutubePlayer {
            isfromYoutubePlayer = false
            self.tabBarController?.tabBar.isHidden = false
            return
        }
        self.navigationController?.isNavigationBarHidden = true;
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.tabBarController?.tabBar.isHidden = false
        self.noPostFound.isHidden = true
        imgUserPorfile.setUserProfilesImage()
        let user = DataManager.sharedInstance.user
        if (user?.special_icon.count)! > 6 {
            imgUserPorfileTop.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (user?.special_icon.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            imgUserPorfileTop.af_setImage(withURL: linked)
        }else {
            imgUserPorfileTop.isHidden = true
        }
        if !self.isGoToLiked {
            if feedDataController.postList.isEmpty || feedDataController.shouldFetchLatestPosts {
                feedDataController.postList.removeAll()
                fetchPosts()
                feedDataController.shouldFetchLatestPosts = false
                tableView.reloadData()
            }
            
        }
        self.RefreshData {
            self.UpdateUI(user: DataManager.sharedInstance.getPermanentlySavedUser()!)
        }
        
        self.appdelegate.isShownPremioumpopup  = true
        
        self.getAllSubUsers()
        if (txtUrlMain != nil && (txtUrlMain.count)>0){
//            var mainParam: [String : AnyObject]
//            mainParam = ["description": txtUrlMain as AnyObject,
//                         "images": "" as AnyObject,
//                         "video": "" as AnyObject,
//                         "poster": "" as AnyObject,
//                         "tagged": "" as AnyObject,
//                         "thumb": "" as AnyObject,
//                         "ratio": "" as AnyObject,
//                         "json_data": "" as AnyObject,
//                         "posting_user": "" as AnyObject,
//                         "repost_to_wall": 1 as AnyObject,
//                         "url": txtUrlMain as AnyObject]
//            NetworkManager.PostCall(UrlAPI: WebServiceName.save_post.rawValue, params: mainParam) { (Isdone, ResMessage, response) in
//                print(Isdone)
//                print(ResMessage)
//                print(response)
//                if(Isdone) {
//                    txtUrlMain = ""
//                    self.fetchPosts()
//                }else {
//                    
//                    NetworkManager.PostCall(UrlAPI: WebServiceName.save_post.rawValue, params: mainParam) { (Isdone, ResMessage, response) in
//                        print(Isdone)
//                        print(ResMessage)
//                        print(response)
//                    
//                    }
//                }
//               
//            }
//            let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
//            let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
//            postFeedViewController.feedDataController = feedDataController
//            postFeedViewController.txtUrl = txtUrlMain
//            //        let postFeedViewController = self.GetView(nameViewController: "PostFeed", nameStoryBoard: "Wall") as! PostFeedViewController
//            self.present(postFeedNavigationController, animated: true, completion:{
//                txtUrlMain = ""
//            })
            
        } 
        
    }
    var txtUrl:String?
    func getAllSubUsers(){
        NetworkManager.GetCall(UrlAPI:"get_all_sub_users") { (apiSucceed, message, responseData) in
            self.hideLoading()
            mentionSubUsers.removeAll()
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let successData = responseData["successData"]    {
                        if let sub_users_dictionaries = successData["sub_users"]  as? [[String: Any]]  {
                            if sub_users_dictionaries.count != 0{
                                for sub_user_dictionary in sub_users_dictionaries{
                                    let sub = PostSubUser(JSON: sub_user_dictionary)
                                    mentionSubUsers.append(sub!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func moveToProfile(notification: NSNotification){
        self.isGoToLiked = false
        let userId = notification.userInfo?["userid"] as? String
        var fdc: FeedDataController?
        self.OpenProfileVC(id: userId!, feedDataController: fdc)
    }
    func addObserver()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListAfterBudUnfollowe), name: .budUnfollowed, object: nil)
    }
    @objc func refreshListAfterBudUnfollowe()
    {
        
        feedDataController.postList.removeAll()
        fetchPosts(pageIndex: 0)
    }

    @IBAction func aktion_gotoPostFeed(_ sender: Any)
    {
        self.isGoToLiked = false
        self.presentPostFeedViewController()
    }
    
    
   
    
    func likedByActivity(index: Int){
        self.isGoToLiked = true
        if feedDataController.postList[index].likes?.count != 0 || feedDataController.postList[index].liked_count != 0{
        let likedActivity = self.GetView(nameViewController: "LikedByViewController", nameStoryBoard: "Wall") as! LikedByViewController
        likedActivity.feedDataController = self.feedDataController
        likedActivity.postIndex = index
        likedActivity.iLiked = self.iLiked
        self.present(likedActivity, animated: true, completion: nil)
        }
    }
    func repostActivity(index: Int){
        self.isGoToLiked = false
        let repostViewController = self.GetView(nameViewController: "RepostViewController", nameStoryBoard: "Wall") as! RepostViewController
        repostViewController.post = self.feedDataController.postList[index]
        repostViewController.feedDataController = self.feedDataController
        self.present(repostViewController, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
extension UserWallViewController    {
    fileprivate func configure()    {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        let textPostCellNib = UINib(nibName: CellIdentier.textPost, bundle: nil)
        tableView.register(textPostCellNib, forCellReuseIdentifier: CellIdentier.textPost)
        
        let mediaPostCellNib = UINib(nibName: CellIdentier.mediaPost, bundle: nil)
        tableView.register(mediaPostCellNib, forCellReuseIdentifier: CellIdentier.mediaPost)
        
        let addCellNib = UINib(nibName: "GoogleAddCell", bundle: nil)
        tableView.register(addCellNib, forCellReuseIdentifier: "GoogleAddCell")
        
        
        let filterCellNib = UINib(nibName: "FilterCell", bundle: nil)
        tableViewGroups.register(filterCellNib, forCellReuseIdentifier: "FilterCell")
        tableViewGroups.delegate=viewFilter
        tableViewGroups.dataSource = viewFilter
        
    }
    
    @objc fileprivate func refreshList(_ sender: Any)    {
         self.playSound(named: "refresh")
        fetchPosts()
    }
    
    
    
    fileprivate func loadMore() {
        if shouldLoadMore {
            
            fetchPosts(pageIndex: currentPageIndex + 1)
        }
    }
    fileprivate func handleMenu(action: MenuAction){
        switch action {
        case .delete:
            self.oneBtnCustomeAlert(title: "", discription:   "Post deleted successfully") { (isComp, btn) in
               
            }
            
        case .likeBy:
            self.likedByActivity(index: postindex)
            
        case .edit:
            let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
            let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
            postFeedViewController.feedDataController=feedDataController
            postFeedViewController.editIndex = self.postindex
            //        let postFeedViewController = self.GetView(nameViewController: "PostFeed", nameStoryBoard: "Wall") as! PostFeedViewController
            self.present(postFeedNavigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    fileprivate func fetchPosts(pageIndex: Int = 0)   {
        if !self.refreshControl.isRefreshing{
             self.showLoading()
        }
        var filter = filterList[self.viewFilter.selectedIndex].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if (filter == "Followers First") {
            filter = ""
        }
        let serviceUrl = WebServiceName.get_user_posts.rawValue + "?skip=\(pageIndex)&filters=\(filter)"
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            if !(self?.refreshControl.isRefreshing)!{
                  self?.hideLoading()
            }
            self?.refreshControl.endRefreshing()
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
                        if !(self?.feedDataController.postList.isEmpty)!{
                        }else if pageIndex == 0{
                            self?.tableView.isHidden = true
                            self?.noPostFound.isHidden = false
                        }
                        
                    }  // data
                    
                    
                    HBUserDafalts.sharedInstance.saveUserPost(posts: (self?.feedDataController.postList)!)
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
                    else  {
                        self?.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
                
//                self?.delayWithSeconds(0.5, completion: {
                    self?.reload(tableView: (self?.tableView)!)
                    let i = IndexPath.init(row: ((self?.currentPageIndex)! * 10), section: 0)
                if i.row < (self?.feedDataController.postList.count)!{
                    self?.tableView.scrollToRow(at: i, at: .top, animated: false)
                }
//                })
                if pageIndex == 0{
                    self?.showLoading()
                    self?.delayWithSeconds(2, completion: {
                        self?.hideLoading()
                    })
                }
            } // api Succeed
        } // netowrk call
    } 
    /*
    fileprivate func delete(post: Post){
        self.view.showLoading()
        print(post.id!)
        let mainParam: [String : AnyObject] = ["post_id": post.id!]
        NetworkManager.PostCall(UrlAPI:WebServiceName.delete_user_post.rawValue, params: mainParam) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            self?.hideLoading();
            self?.refreshControl.endRefreshing()
            
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    self?.feedDataController.postList = (self?.feedDataController.postList.filter { $0.id! != post.id! })!
                    self?.tableView.reloadData()
                }  // data
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
    } // netowrk call
    */
    fileprivate func presentPostFeedViewController()
    {
        let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
        let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
        postFeedViewController.feedDataController=feedDataController
//        let postFeedViewController = self.GetView(nameViewController: "PostFeed", nameStoryBoard: "Wall") as! PostFeedViewController
        self.present(postFeedNavigationController, animated: true, completion: nil)
    }
    
    fileprivate func showFeedDetail(index: Int) {
        let feedDetailController = self.GetView(nameViewController: "FeedDetail", nameStoryBoard: "Wall") as! FeedDetailViewController
        feedDetailController.postindex = index
        feedDetailController.feedDataController = feedDataController
        feedDetailController.fromUserWall = true
        self.navigationController?.pushViewController(feedDetailController, animated: true)
    }
    
    func resetFilter()
    {
        self.filterList = filtersListCached
        self.viewFilter.filtersList=self.filterList
        self.viewFilter.showReportMenu=false
        
        
    }
    func showView()
    {
        isFilterOpen = true
        self.tableView.isScrollEnabled = false
        self.tableView.isUserInteractionEnabled = false
        if self.viewFilter.showReportMenu
        {
            self.filterViewHeight.constant = 420
            self.filterLabel.text = "REASON FOR REPORTING:"
            self.btnApply.setTitle("SEND", for: .normal)
        }
        else
        {
            self.filterViewHeight.constant = 300
            self.filterLabel.text = "FILTER:"
            self.btnApply.setTitle("APPLY", for: .normal)
        }
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options:  .curveEaseIn ,
                       animations: {
                        self.tableView.alpha = 0.2
                        self.tableViewGroups.reloadData()
                        if self.viewFilter.showReportMenu{
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let aVariable = appDelegate.isIphoneX
                            if(aVariable){
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 290)
                            }else{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 250)
                            }
                        }else{
                            self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 200)
                        }
                        
                        },
                       completion: { finished in
        })
    }
    
    
    func hideView()
    {
        
        isFilterOpen = false
        self.tableView.isScrollEnabled = true
        self.tableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: .curveLinear ,
                       animations: {
                        self.tableView.alpha = 1.0
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
    
}


// MARK: - Actions
extension UserWallViewController    {
    
    @IBAction func aktion_OpenFilters(_ sender: Any)
    {
       
        self.resetFilter()
        self.showView()
    }
    @IBAction func aktion_close(_ sender: Any)
    {
        self.hideView()
        //self.btnApply.setTitle("Send", for: .normal)
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
            fetchPosts(pageIndex: 0)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.keywords.count == 0 ){
            self.GetKeywords(completion: {
                print(appDelegate.keywords)
            })
        }
    }
    
    
    
    @IBAction func newPostButtonTapped(sender: UIButton)    {
        self.presentPostFeedViewController()
//        self.navigationController?.pushViewController(postFeedViewController, animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
               self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        
        
    }
    
   
    
}


// MARK: - UITableViewDataSource
extension UserWallViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedDataController.postList.count  //+ (Int(feedDataController.postList.count/10))
    }
    @objc func dissCalled(){
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (false) {//indexPath.row % 10 == 0 && indexPath.row > 8
            let add_cell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddCell") as! GoogleAddCell
            self.addBannerViewToView(add_cell.add_view)
            add_cell.add_view.backgroundColor = UIColor.clear
            add_cell.backgroundColor = UIColor.clear
            add_cell.selectionStyle = .none
            return add_cell
        }else{
            let decreased_index = (Int(indexPath.row/10))
            let index = indexPath.row //- decreased_index
            let post = feedDataController.postList[index]
            var cell: TextPostTableViewCell!
            if post.postType == .text   {
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.textPost, for: indexPath) as? TextPostTableViewCell
                cell.feedDataController = feedDataController
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.mediaPost, for: indexPath) as? MediaPostTableViewCell
                cell.feedDataController = feedDataController
                cell.pageControl.isHidden = true
                cell.MediacollectionView.isPagingEnabled = false
            }
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
                let r = text.replacingOccurrences(of: "\n", with: " ")
                commentHeight = self.heightForView(text: r, font: font!, width: width)
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
            cell?.index=index
            cell?.display(post: post, parentVC: self)
            cell?.userWallVC = self
            cell?.isDetailScreen = false
            cell?.urlBtnAtion = { [unowned self] in
                if let url = post.scrapind_data!["url"] as? String{
                    self.OpenUrl(webUrl: URL.init(string: url)!)
                }
                
            }
            cell?.timeAgoLabel.text = self.GetTimeAgoWall(StringDate: post.created_at!)
            cell.menuButton.tag=index
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
                self.feedDataController.showPopoverMenu(isShownOnTop: is_shown_on_top,sender: menuButton, for: post, controller: self)    { menuAction in
                    self.postindex = index
                    self.handleMenu(action: menuAction)
//                    self.tableView.reloadData()
                }
            }
            
            cell?.feedDetailAction = { [unowned self] index in
               self.showFeedDetail(index: index)
            }
            cell?.LikedByAction = { [unowned self] menuButton in
//                self.likedByActivity(index: index)
            }
            cell.repostAction = {
                [unowned self] menuButton in
                if self.feedDataController.postList[index].user_id!.stringValue != DataManager.sharedInstance.getPermanentlySavedUser()!.ID {
                    self.repostActivity(index: index)
                }else {
                    self.ShowErrorAlert(message: "You can't repost your own post!")
                }
                
            }
            cell?.profileButtonAction = {[unowned self] userId in
                let sessionUserId = DataManager.sharedInstance.user!.ID
                var fdc: FeedDataController?
                if userId == sessionUserId  {
                    fdc = self.feedDataController
                }
                self.OpenProfileVC(id: userId, feedDataController: fdc)
            }
            
            cell?.postedAsUserButtonAction = {[unowned self] budzMap in
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                
                viewPush.chooseBudzMap = budzMap
                self.navigationController?.pushViewController(viewPush, animated: true)
            }
            
            cell?.likesButtonAction = {[unowned self] in
                self.feedDataController.performLike(cell: cell, index: index, controller: self)
//                self.tableView.reloadData()
            }
            
            cell?.commentsButtonAction = {[weak self]  in
                self?.handleCommentsAction(index: index)
            }
            
            cell.baseVC = self
            return cell!
        }
    }
}

extension UserWallViewController: UITableViewDelegate   {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let decreased_index = (Int(indexPath.row/10))
        let index = indexPath.row - decreased_index
        showFeedDetail(index: indexPath.row)
    }
    
    
}

extension UserWallViewController: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            for i in feedDataController.postList{
               i.newAttachment = Attachment()
            }
            self.loadMore()
        }
    }
}

// Post Cell Actions
extension UserWallViewController {
    
    
    
    fileprivate func handleCommentsAction(index: Int) {
        showFeedDetail(index: index)
    }
    
    fileprivate func handleRepostsAction(index: Int) {
        
    }
    
    
}


// MARK: - Private Constants
fileprivate struct CellIdentier {
    static let textPost = "TextPostTableViewCell"
    static let mediaPost = "MediaPostTableViewCell"
}
