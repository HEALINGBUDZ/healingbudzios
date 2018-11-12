//
//  MyWallViewController.swift
//  BaseProject
//
//  Created by MN on 16/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import SwiftLinkPreview
class MyWallViewController: BaseViewController {

    @IBOutlet weak var img_title: UIImageView!
    @IBOutlet weak var lbl_menu_btn: UIButton!
    
    @IBOutlet weak var img_feed: UIButton!
    @IBOutlet weak var lbl_add_new_btn: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tableView: MyTableView!
    fileprivate let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableViewGroups: UITableView!
    @IBOutlet weak var btnApply: RoundButton!
    @IBOutlet weak var filterLabel: UILabel!
    var other_user_id : String = ""
    @IBOutlet weak var viewFilter: filterView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    fileprivate var currentPageIndex = 0
    fileprivate var shouldLoadMore = true
    @IBOutlet weak var imgUserPorfile: UIImageView!
    public var result = SwiftLinkPreview.Response()
    public let slp = SwiftLinkPreview(cache: InMemoryCache())
    let feedDataController = FeedDataController()
    var filtersListCached = ["Newest","Most Liked"]
    var filterList = ["Newest","Most Liked"]
    var postindex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MArk Green theme

        img_feed.setImage(#imageLiteral(resourceName: "feed-plus").withRenderingMode(.alwaysTemplate), for: .normal)
        img_feed.tintColor = UIColor.init(hex: "7cc245")
        
        
//        self.topSpace.constant = -420
        tableView.reloadData()
//        self.btnApply.setTitle("Send", for: .normal)
        configure()
        addObserver()
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
            return
        }
        if self.other_user_id.count > 0 {
            self.lbl_title.text = "THE BUZZ"
//            self.lbl_menu_btn.setImage(#imageLiteral(resourceName: "Back-Arrow"), for: .normal)
            self.img_title.isHidden = false
            self.lbl_add_new_btn.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
             self.lbl_title.text = "My Buzz"
            self.lbl_add_new_btn.isHidden = false
//            self.lbl_menu_btn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            self.img_title.isHidden = false
        }
        self.lbl_add_new_btn.addTarget(self, action: #selector(OpenNewPost), for: UIControlEvents.touchUpInside)
        
        self.navigationController?.isNavigationBarHidden = true;
        tableView.separatorStyle = .none
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        if feedDataController.postList.isEmpty || feedDataController.shouldFetchLatestPosts {
            feedDataController.postList.removeAll()
            fetchPosts()
            feedDataController.shouldFetchLatestPosts = false
        }
        tableView.reloadData()
    }

    func OpenNewPost(sender: UIButton){
        let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
        let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
        postFeedViewController.feedDataController=feedDataController
        self.present(postFeedNavigationController, animated: true, completion: nil)
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
        self.presentPostFeedViewController()
    }
    
    
    func likedByActivity(index: Int){
        if feedDataController.postList[index].likes?.count != 0{
            let likedActivity = self.GetView(nameViewController: "LikedByViewController", nameStoryBoard: "Wall") as! LikedByViewController
            likedActivity.feedDataController = self.feedDataController
            likedActivity.postIndex = index
            self.present(likedActivity, animated: true, completion: nil)
        }
    }
    func repostActivity(index: Int){
        let repostViewController = self.GetView(nameViewController: "RepostViewController", nameStoryBoard: "Wall") as! RepostViewController
        repostViewController.post = self.feedDataController.postList[index]
        repostViewController.feedDataController = self.feedDataController
        self.present(repostViewController, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
extension MyWallViewController    {
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
        
//        let filterCellNib = UINib(nibName: "FilterCell", bundle: nil)
//        tableViewGroups.register(filterCellNib, forCellReuseIdentifier: "FilterCell")
//        tableViewGroups.delegate=viewFilter
//        tableViewGroups.dataSource = viewFilter
//
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
                self.dismiss(animated: true)
            }
        
            
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
        self.showLoading()
        var UserId  = ""
        if self.other_user_id.count == 0 {
         UserId = DataManager.sharedInstance.user!.ID
        }else{
            UserId = self.other_user_id
        }
        let serviceUrl = WebServiceName.user_posts.rawValue + "/\(UserId)?skip=\(pageIndex)"
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            self?.refreshControl.endRefreshing()
            self?.currentPageIndex = pageIndex
            self?.hideLoading()
            
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
                        if (self?.feedDataController.postList.count)! < 1 {
                            self?.tableView.setEmptyMessage()
                        }
                        else{
                            self?.tableView.restore()
                        }
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
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options:  .curveEaseIn ,
                       animations: {
                        self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 200)
        },
                       completion: { finished in
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
                        self.tableViewGroups.reloadData()
        })
    }
    
    
    func hideView()
    {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: .curveLinear ,
                       animations: {
                        self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: -210)
                        self.view.setNeedsDisplay()
        },
                       completion: { finished in
                        
                        
        })
    }
    
}


// MARK: - Actions
extension MyWallViewController    {
    
    @IBAction func aktion_OpenFilters(_ sender: Any)
    {
        self.resetFilter()
        self.showView()
    }
    @IBAction func aktion_close(_ sender: Any)
    {
        
        self.hideView()
        self.btnApply.setTitle("Send", for: .normal)
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
        
    }
    
    
    
    @IBAction func newPostButtonTapped(sender: UIButton)    {
        self.presentPostFeedViewController()
        //        self.navigationController?.pushViewController(postFeedViewController, animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        if self.other_user_id.count > 0 {
            self.Back()
        }else{
            self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITableViewDataSource
extension MyWallViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedDataController.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let post = feedDataController.postList[indexPath.row]
        var cell: TextPostTableViewCell!
        if post.postType == .text   {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.textPost, for: indexPath) as? TextPostTableViewCell
            cell.feedDataController = feedDataController
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.mediaPost, for: indexPath) as? MediaPostTableViewCell
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
//                                        //                            cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
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
        cell?.display(post: post, parentVC: self)
        cell?.index=indexPath.row
        cell?.isDetailScreen = false
        cell?.timeAgoLabel.text = self.GetTimeAgoWall(StringDate: post.created_at!)
        cell.menuButton.tag=indexPath.row
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
                self.postindex = indexPath.row
                self.handleMenu(action: menuAction)
                self.tableView.reloadData()
            }
        }
        
        cell?.feedDetailAction = { [unowned self] index in
            self.showFeedDetail(index: index)
        }
        cell?.LikedByAction = { [unowned self] menuButton in
            self.likedByActivity(index: indexPath.row)
        }
        cell.repostAction = {
            [unowned self] menuButton in
            if self.feedDataController.postList[indexPath.row].user_id!.stringValue != DataManager.sharedInstance.getPermanentlySavedUser()!.ID {
                self.repostActivity(index: indexPath.row)
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
            self.feedDataController.performLike(cell: cell, index: indexPath.row, controller: self)
        }
        
        cell?.commentsButtonAction = {[weak self]  in
            self?.handleCommentsAction(index: indexPath.row)
        }
        
        //        cell?.repostAction = {[weak self]  in
        //           // self?.handleRepostsAction(index: indexPath.row)
        //            self?.feedDataController.performRepost(cell: cell, index: indexPath.row, controller: self!, completion:{(r) in
        //                if r
        //                {
        //                    self?.fetchPosts()
        //                    self?.tableView.setContentOffset(CGPoint.zero, animated: true)
        //                }
        //
        //            })
        //
        //        }
        
        
        cell.baseVC = self
        return cell!
    }
}

extension MyWallViewController: UITableViewDelegate   {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 200
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        showFeedDetail(index: indexPath.row)
    }
    
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if indexPath.row == feedDataController.postList.count - 1  {
    //            loadMore()
    //        }
    //    }
}

extension MyWallViewController: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
}

// Post Cell Actions
extension MyWallViewController {
    
    
    
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

