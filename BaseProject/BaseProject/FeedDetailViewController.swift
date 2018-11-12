 //
//  FeedDetailViewController.swift
//  BaseProject
//
//  Created by Yasir Ali on 31/03/2018.
//  Copyright © 2018 Wave. All rights reserved.

import UIKit
import ActiveLabel
import GrowingTextView
import IQKeyboardManager
import SwiftLinkPreview
import MJAutoComplete
import SDWebImage
import SwiftyJSON
import AVKit
import INSPhotoGallery
 
 extension FeedDetailViewController  {
    fileprivate func setupData() {
        // mention list
        followed_user_model = PostFeedViewController.followedUsers
        for sub_user in mentionSubUsers{
            let sub_usr_obj =  PostUser()
            sub_usr_obj.id = sub_user.id
            sub_usr_obj.first_name = sub_user.title
            sub_usr_obj.user_type = -400
            followed_user_model.append(sub_usr_obj)
        }
        for name in followed_user_model {
            let item = MJAutoCompleteItem()
            item.autoCompleteString = name.first_name?.replaceSpace(str: "_")
            item.displayedString = name.first_name
            item.context = ["user" :  name as AnyObject]
            mentionItems.append(item)
        }
        
        // tags list
        for tag in PostFeedViewController.tags {
            let item = MJAutoCompleteItem()
            item.autoCompleteString = tag.title
            item.displayedString = tag.title
            tagItems.append(item)
        }
        self.updated_tags = PostFeedViewController.tags
        self.updated_followed_user_model = followed_user_model
        self.updateData(users: followed_user_model, tags: self.updated_tags)
    }
    fileprivate func updateData(users : [PostUser] , tags : [PostTags]) {
        mentionItems.removeAll()
        tagItems.removeAll()
        for name in users {
            let item = MJAutoCompleteItem()
            item.autoCompleteString = name.first_name?.replaceSpace(str: "_")
            item.displayedString = name.first_name
            item.context = ["user" :  name as AnyObject]
            mentionItems.append(item)
        }
        
        for tag in tags {
            let item = MJAutoCompleteItem()
            item.autoCompleteString = tag.title
            item.displayedString = tag.title
            tagItems.append(item)
        }
        
        let atTrigger = MJAutoCompleteTrigger(delimiter: "@", autoCompleteItems: mentionItems)
        atTrigger?.cell = "MentionTableViewCell"
        let hashTrigger = MJAutoCompleteTrigger(delimiter: "#", autoCompleteItems: tagItems)
        hashTrigger?.cell = "MentionTableViewCell"
        acManager.add(atTrigger)
        acManager.add(hashTrigger)
    }
    fileprivate func configureTagTextView() {
        setupData()
        acManager.isFromCommentScreen = true
        self.acContainerView.isHidden = true
        self.acContainerView.backgroundColor = UIColor.init(hex: "2F2F2F")
        acManager.dataSource = self
        acManager.delegate = self
        let atTrigger = MJAutoCompleteTrigger(delimiter: "@", autoCompleteItems: mentionItems)
        atTrigger?.cell = "MentionTableViewCell"
        
        let hashTrigger = MJAutoCompleteTrigger(delimiter: "#", autoCompleteItems: tagItems)
        hashTrigger?.cell = "MentionTableViewCell"
        acManager.add(atTrigger)
        acManager.add(hashTrigger)
        acManager.container = acContainerView
        acManager.container.backgroundColor = UIColor.init(hex: "2F2F2F")
        self.txtComment.delegate = self
    }
    
    func matches(regex: String, text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateTaggingViewPosition(text : String) {
        print(text.count)
        let percent  =  CGFloat(((text.count % 45) * 100)/45)
        _  = (self.txtComment.frame.width * percent)/100
        let xPosition = self.txtComment.frame.origin.x
        let yPosition = self.txtComment.frame.origin.y +  CGFloat((Int(text.count/45) * 30 ) + 30)
        let height = self.acContainerView.frame.size.height
        let width = self.acContainerView.frame.size.width
        self.acContainerView.frame =  CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
        if self.acContainerView.isHidden{
            self.acContainerView.zoomIn()
        }
    }
 }
 
 extension FeedDetailViewController: MJAutoCompleteManagerDataSource {
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, itemListFor trigger: MJAutoCompleteTrigger!, with string: String!, callback: MJAutoCompleteListCallback!) {
        self.acContainerView.isHidden = true
        callback(trigger.autoCompleteItemList)
    }
    func updateTriggerData(newText : String) {
        self.updated_tags = PostFeedViewController.tags
        self.updated_followed_user_model = followed_user_model
        self.acManager.removeAllAutoCompleteTriggers()
        var index  = 0
        var newGenratedArray =  [PostUser]()
        for user in updated_followed_user_model{
            if let name_f  = user.first_name{
                let name : String =  "@" + (name_f.replacingOccurrences(of: " ", with: "_"))
                print(name + " == " + newText)
                if !newText.contains(name) {
                    newGenratedArray.append(user)
                }
            }
            index = index + 1
        }
        updated_followed_user_model = newGenratedArray

        var index_tag = 0
        var newGenratedTagsArray = [PostTags]()
        for tags in updated_tags{
            if tags.title != nil{
                let tag_name : String  = "#" + tags.title!
                if !newText.contains(tag_name) {
                    newGenratedTagsArray.append(tags)
                }
                
             
            }
            index_tag = index_tag + 1
        }
        updated_tags = newGenratedTagsArray
        
        
        print("old count " + "\(updated_followed_user_model.count)")
        let filteredElements_users = updated_followed_user_model.filterDuplicates { $0.first_name == $1.first_name}
        print("new count " + "\(filteredElements_users.count)")
//        let filteredElements_tags = updated_tags.filterDuplicates { $0.title == $1.title}
        self.updateData(users: filteredElements_users, tags: PostFeedViewController.tags)
        
    }
 }
 
 extension FeedDetailViewController: MJAutoCompleteManagerDelegate {
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, willPresentCell autoCompleteCell: Any!, for trigger: MJAutoCompleteTrigger!) {
        self.acContainerView.isHidden = false
     if trigger.delimiter == "#" {
            let cell = autoCompleteCell as! MentionTableViewCell
            cell.profileImageView.image = #imageLiteral(resourceName: "QATag")
            cell.nameLabel.text = cell.textLabel?.text
            cell.textLabel?.text = ""
            print(trigger.autoCompleteItemList.count)
            cell.nameLabel.textColor = UIColor.white
            cell.profileImageViewTop.isHidden = true
            cell.backgroundColor = UIColor.init(hex: "2F2F2F")
        }else if trigger.delimiter == "@" {
            let cell = autoCompleteCell as! MentionTableViewCell
            cell.profileImageView.image = #imageLiteral(resourceName: "placeholderMenu")
            cell.nameLabel.text = cell.textLabel?.text
            var data  = cell.autoCompleteItem.context
            if let  user : PostUser = data!["user"] as? PostUser{
                if user.user_type?.intValue == -400 {
                    cell.profileImageView.image = #imageLiteral(resourceName: "leafCirclePink")
                    cell.nameLabel.text = user.first_name
                    cell.nameLabel.textColor = UIColor.white
                    cell.profileImageViewTop.isHidden = true
                }else{
                    if let pic = user.profilePictureURL{
                        cell.profileImageView.sd_setImage(with: URL.init(string: pic) , placeholderImage : #imageLiteral(resourceName: "placeholderMenu")) { (image, error, chache, url) in
                            print(error ?? "tesst")
                        }
                    }
                    if (user.special_icon?.characters.count)! > 6 {
                        cell.profileImageViewTop.isHidden = false
                        var linked = URL(string: WebServiceName.images_baseurl.rawValue + (user.special_icon?.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        cell.profileImageViewTop.af_setImage(withURL: linked)
                    }else {
                        cell.profileImageViewTop.isHidden = true
                    }
                    cell.nameLabel.text = user.first_name
                    cell.nameLabel.textColor = user.pointsColor
                }
            
            }
            cell.textLabel?.text = ""
            cell.backgroundColor = UIColor.init(hex: "2F2F2F")
            print(trigger.autoCompleteItemList.count)
        }
    }
    
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, shouldUpdateToText newText: String!) {
        self.acContainerView.isHidden = true
        let mentions = self.matches(regex: "([@#][\\w_-]+)", text: newText)
        print("mentions are: \(mentions)")
        self.updateTriggerData(newText: newText)
        if mentions.count > 0 {
            let menstion_str = mentions.last?.replacingOccurrences(of: "_", with: " ")
            self.mention_Array.append(menstion_str!)
        }
        self.SetAttributedText(mainString: newText.replacingOccurrences(of: "_", with: " "), attributedStringsArray: self.mention_Array, view: self.txtComment, color: UIColor.init(hex: "7CC244"))
    }
 }
 
 
class FeedDetailViewController: BaseViewController {
    @IBOutlet weak var commentInputView: UIView!
    var followed_user_model = [PostUser]()
    var updated_followed_user_model = [PostUser]()
    var updated_tags = [PostTags]()
    var isEditComment: Bool = false
    @IBOutlet weak var btnRemoveMedia: UIButton!
    @IBOutlet weak var mediaViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var btnCommentedImageOrPoster: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFilter: filterView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var indicator_close: UIButton!
    @IBOutlet weak var tableViewGroups: UITableView!
    @IBOutlet weak var btnApply: RoundButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var crossBtnWidthConstraint : NSLayoutConstraint!
     @IBOutlet weak var crossBtnLeadingConstraint : NSLayoutConstraint!
    public var result = SwiftLinkPreview.Response()
    public let slp = SwiftLinkPreview(cache: InMemoryCache())
    var videoUploaded = false
    @IBOutlet weak var txtComment: GrowingTextView!
    var filterList = ["Newest","Most Liked"]
    @IBOutlet var commentViewBottomConstraint: NSLayoutConstraint!
    var commentImageOrPoster:UIImage!
    var attacmentUrl = ""
    var posterImageUrl = ""
    var newAttachment = Attachment()
    var fromActivityLog = false
    var fromActivityID: Int!
    var mention_Array = [String]()
    fileprivate var currentPageIndex = 0
    fileprivate var shouldLoadMore = true
    @IBOutlet weak var acContainerView: UIView!
    var acManager = MJAutoCompleteManager()
    var mentionItems = [MJAutoCompleteItem]()
    var tagItems = [MJAutoCompleteItem]()
    var fromUserWall = false
    var keyboardHeight = CGFloat(0.0)
    let textViewMaxHeight = CGFloat(100)
    
    var detailForPost: Post!
    var feedDataController = FeedDataController()
    var postindex: Int!
    var isFilterOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        showPlaceholder()
        mediaViewHeightConstaint.constant = 0
        self.viewFilter.center.y = -210
        self.viewFilter.selectedIndex = wallSelectedFilter
        let filterCellNib = UINib(nibName: "FilterCell", bundle: nil)
        tableViewGroups.register(filterCellNib, forCellReuseIdentifier: "FilterCell")
        btnRemoveMedia.isHidden=false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        automaticallyAdjustsScrollViewInsets = false
        self.btnRemoveMedia.isHidden=true
        if !fromActivityLog{
            detailForPost = feedDataController.postList[postindex!]
        }
        if PostFeedViewController.followedUsers.count > 0 {
            if PostFeedViewController.tags.count > 0 {
                self.configureTagTextView()
            }else{
                self.getTags()
            }
        }else{
            self.getFollowers()
        }
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
            
            if  view != self.commentInputView{
               self.txtComment.resignFirstResponder()
               self.view.endEditing(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isfromYoutubePlayer {
            isfromYoutubePlayer = false
            return
        }
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
         self.tabBarController?.tabBar.isHidden = true
        if !fromActivityLog{
            if self.feedDataController.shouldFetchLatestPosts == true && !self.fromUserWall{
                self.navigationController?.popViewController(animated: true)
                return
            }
//            fetchComments(pageIndex: currentPageIndex)
        }else{
            postindex = 0
            if let i = fromActivityID{
               self.fetchPostDetail(index: fromActivityID)
            }
//            fetchComments(pageIndex: currentPageIndex)

        }
        
//        fetchComments(pageIndex: currentPageIndex)
        self.tableView.reloadData()
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func aktion_close(_ sender: Any)
    {
        self.hideView()
        //self.btnApply.setTitle("Send", for: .normal)
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
                        self.tableView.alpha  = 1.0
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.keywords.count == 0 ){
            self.GetKeywords(completion: {
                print(appDelegate.keywords)
            })
        }
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
                         self.tableView.alpha  = 0.2
                        self.tableViewGroups.reloadData()
                        if self.viewFilter.showReportMenu{
                        self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 230)
                        }else{
                        self.viewFilter.center = CGPoint(x: self.view.frame.size.width/2, y: 150)
                        }
        },
                       completion: { finished in
                        
                        
        })
    }
    func getFollowers(){
        let UserId = DataManager.sharedInstance.user!.ID
        let serviceUrl = WebServiceName.get_followings.rawValue + "\(UserId)"
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    let data = responseData["successData"] as? [[String: Any]]
                    PostFeedViewController.followedUsers.removeAll()
                    for user in data!  {
                        let follow = PostUser(JSON: user)
                        PostFeedViewController.followedUsers.append(follow!)
                    }
                    if PostFeedViewController.tags.count > 0 {
                        self?.configureTagTextView()
                    }else{
                        self?.getTags()
                    }
                   
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
    
    func getTags(){
        let serviceUrl = WebServiceName.get_tags.rawValue
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    let data = responseData["successData"] as? [[String: Any]]
                    PostFeedViewController.tags.removeAll()
                    for user in data!  {
                        let tag = PostTags(JSON: user)
                        PostFeedViewController.tags.append(tag!)
                    }
                    self?.configureTagTextView()
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
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    fileprivate func loadMore() {
        if shouldLoadMore {
            fetchComments(pageIndex: currentPageIndex + 1)
        }
    }
    
    func fetchPostDetail(index: Int!){
        
        self.showLoading()
        let serviceUrl = WebServiceName.get_post.rawValue + "/\(index!)"
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)
            
            self?.hideLoading()
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        if  let postDictionaries = data["post"] as? [String: Any] {
                        
                            self?.detailForPost = Post(JSON: postDictionaries)
                            self?.detailForPost.checkPostType()
                            self?.feedDataController.postList.append((self?.detailForPost)!)
                            self?.tableView.reloadData()

                            
                        }
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
        }
    }
    
    fileprivate func fetchComments(pageIndex: Int = 1)   {
        self.showLoading()
        self.detailForPost.comments?.removeAll()
//        let  filter = filterList[self.viewFilter.selectedIndex].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //        replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = WebServiceName.user_post_comment.rawValue + "/\((detailForPost.id?.intValue)!)" + "?skip=\(pageIndex)"
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
            print(responseData)

            self?.currentPageIndex = pageIndex
            self?.hideLoading()
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        let commentsDictionaries = data["comments"] as! [[String: Any]]
                        
                        self?.shouldLoadMore = !commentsDictionaries.isEmpty
//                        if let feeds = self?.feedDataController{
//                        feeds.postList[(self?.postindex!)!].commeentsLoaded = commentsDictionaries.isEmpty
//                        print("should load more: \(String(describing: self?.shouldLoadMore)), arrayCount = \(commentsDictionaries.count)")
//                        }
                        
                        var x = 0
                        for _ in commentsDictionaries  {
                            let index = (commentsDictionaries.count - 1) - x
                            if let comments = PostComment(JSON: commentsDictionaries[index])    {
                                self?.detailForPost.comments?.append(comments)
                            }
                            x = x + 1
                        }
                        self?.detailForPost.comments = self?.detailForPost.comments?.sorted(by: {$0.dates.compare($1.dates) == .orderedDescending})
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
    
    @IBAction func removeMedia(_ sender: Any)
    {
        self.view.layoutIfNeeded()
        resetCommentBar()
    }
    func resetCommentBar()
    {
        self.attacmentUrl = ""
        self.posterImageUrl = ""
        self.btnRemoveMedia.isHidden = true
        self.newAttachment = Attachment()
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        self.btnCommentedImageOrPoster.setBackgroundImage(UIImage(named:""), for: .normal)
        self.mediaViewHeightConstaint.constant=0
        self.btnRemoveMedia.isHidden=true
        
    }
    func likedByActivity(){
        if  detailForPost.likes?.count != 0 || detailForPost.liked_count != 0{
            let likedActivity = self.GetView(nameViewController: "LikedByViewController", nameStoryBoard: "Wall") as! LikedByViewController
            likedActivity.feedDataController = self.feedDataController
            likedActivity.postIndex = postindex
            likedActivity.feedDetailVC = self
            self.present(likedActivity, animated: true, completion: nil)
        }
    }
    func repostActivity(){
        let repostViewController = self.GetView(nameViewController: "RepostViewController", nameStoryBoard: "Wall") as! RepostViewController
        repostViewController.post = self.detailForPost
        repostViewController.feedDataController = self.feedDataController
        self.present(repostViewController, animated: true, completion: nil)
    }
    
    @IBAction func playMedia(_ sender: Any)
    {
        
        CreateGalleryViewer(withImage: attacmentUrl, userIfno: false, poster:posterImageUrl, index: 0)
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    @IBAction func postComment(_ sender: Any) {
        self.delayWithSeconds(1) {
             self.configureTagTextView()
        }
        self.acContainerView.isHidden = true
        self.view.endEditing(true)
        var comment = self.txtComment.text!
        if attacmentUrl.count == 0 && newAttachment.ID.count == 0 && newAttachment.image_URL.count == 0 && newAttachment.video_URL.count == 0  {
            if comment.contains("Your Comment…") || comment == ""{
               self.txtComment.text = "Your Comment…"
               self.ShowErrorAlert(message: "Please enter your comment!")
               return
            }
        }else{
            if comment.contains("Your Comment…") || comment == ""{
                comment = ""
            }
        }
        var json_data_mentions = [[String : Any]]()
        for mentios_data  in self.mention_Array{
            if mentios_data.contains("@"){
                for user in self.followed_user_model{
                    print(user.first_name ?? "test")
                    print(mentios_data)
                    let user_name = "@" + user.first_name!
                    if  mentios_data == user_name {
                        var json_data_single = [String : Any]()
                        json_data_single["id"] = user.id?.intValue
                        json_data_single["trigger"] = "@"
                        if user.user_type?.intValue == -400 {
                            json_data_single["type"] = "budz"
                        }else{
                            json_data_single["type"] = "user"
                        }
                        json_data_single["value"] = user.first_name
                        json_data_mentions.append(json_data_single)
                        break
                    }
                }
            }else{
                for tag in PostFeedViewController.tags{
                    print(tag.title ?? "test")
                    print(mentios_data)
                    let title = "#" + tag.title!
                    if  mentios_data == title{
                        var json_data_single = [String : Any]()
                        json_data_single["id"] = tag.id?.intValue
                        json_data_single["trigger"] = "#"
                        json_data_single["type"] = "tag"
                        json_data_single["value"] = tag.title
                        json_data_mentions.append(json_data_single)
                        break
                    }
                }
            }
        }
        var characters  = comment.components(separatedBy: " ")
        for char in characters {
            for main_keyword in AppDelegate.appDelegate().orignalkeywords{
                if main_keyword.lowercased() == char.lowercased() ||  "#"+main_keyword.lowercased() == char.lowercased(){
                    var json_data_single = [String : Any]()
                    json_data_single["id"] = 1
                    json_data_single["trigger"] = "#"
                    json_data_single["type"] = "tag"
                    json_data_single["value"] = char
                    json_data_mentions.append(json_data_single)
                    comment = comment.replacingOccurrences(of: char, with: "#"+char, options: .literal, range: nil)
                    characters.remove(at: characters.index(of: char)!)
                    break
                }
            }
        }
        
        comment = comment.replaceHash()

        var json_data : String = ""
        if json_data_mentions.count > 0 {
            let paramsJSON = JSON(json_data_mentions)
            print(paramsJSON.stringValue)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            print(paramsString)
            json_data = paramsString
        }
        
        
        feedDataController.performPostComment(post: self.detailForPost, comment: comment, attachement: attacmentUrl, poster: posterImageUrl,controller: self, jsonData : json_data, attachmentObject:newAttachment, postIndex:self.postindex ,completion: { void in
            self.updated_tags = PostFeedViewController.tags
            self.updated_followed_user_model = self.followed_user_model
            self.acManager.removeAllAutoCompleteTriggers()
            self.configureTagTextView()
            self.resetCommentBar()
                self.showPlaceholder()
                self.mention_Array.removeAll()
                self.attacmentUrl = ""
                self.newAttachment = Attachment()
                self.commentViewBottomConstraint.constant = 0
                self.tableView.reloadData()
              self.commentCross(sender: sender as! UIButton)
            })
}
    var photos : [Media] = [Media]()
    func CreateGalleryViewer(withImage:String, userIfno:Bool,poster:String, index: Int)    {
        photos.removeAll()
        if poster.count>0 {
            if URL(string: WebServiceName.images_baseurl.rawValue + posterImageUrl) != nil   {
                guard let video_url = URL(string: WebServiceName.videos_baseurl.rawValue + withImage)    else{return}
                let player = AVPlayer(url:  NSURL(string: video_url.absoluteString)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                return
            }
        }
        else    {
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + withImage)    {
                let photo = Media.init(url: url)
                photos.append(photo)
            }
        }
        let browser = MediaBrowser2(delegate: self as MediaBrowser2Delegate)
        browser.setCurrentIndex(at: index)
        browser.enableGrid = false
        browser.post = detailForPost
        browser.index = self.postindex!
        browser.userIfno = userIfno
        browser.feedDataController = feedDataController
        self.navigationController?.present(browser, animated: true, completion: nil)
    }
    
    fileprivate func showPlaceholder()  {
        txtComment.textColor = .lightGray
        txtComment.text = "Your Comment…"
    }
    
    fileprivate func hidePlaceholder()  {
        txtComment.text = ""
        txtComment.textColor = .white
    }
 }
 
 
 
 extension FeedDetailViewController : MediaBrowser2Delegate {
    func numberOfMedia(in mediaBrowser: MediaBrowser2) -> Int {
        return photos.count
    }
    
    func media(for mediaBrowser: MediaBrowser2, at index: Int) -> Media {
        return photos[index]
    }
 }


 
extension FeedDetailViewController  {

    @objc func keyboardWillShow(sender: NSNotification) {
//        keyboardDidShow(sender: sender, adjustHeight: 150)
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            //- (self.tabBarController?.tabBar.frame.height)!
            print("keyboard height is : \(keyboardHeight)")
            var hieghtForBottomConstrain:CGFloat = 0.0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.commentViewBottomConstraint.constant = ((self?.keyboardHeight)!) * -1
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
      //  keyboardHeight = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.commentViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    
    
    
    //-------------------
//    func keyboardDidShow(sender: NSNotification, adjustHeight: CGFloat) {
//        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardHeight = keyboardSize.height
//            //- (self.tabBarController?.tabBar.frame.height)!
//            print("keyboard height is : \(keyboardHeight)")
//
//            commentViewBottomConstraint.constant = keyboardHeight  * -1
//        }
//    }
    
   
}
 extension FeedDetailViewController: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
//            self.loadMore()
        }
    }
 }
extension FeedDetailViewController  {
    
    fileprivate func presentPostFeedViewController()
    {
        self.fromActivityLog = true
        let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
        let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
        postFeedViewController.feedDataController=feedDataController
        self.present(postFeedNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func aktion_GotoPostFeeds(_ sender: Any)
    {
        
        self.fromActivityLog = true
        self.presentPostFeedViewController()
    }
    @IBAction func backButtonTapped()   {
        self.Back()
    }
    @IBAction func commentImage(sender: UIButton!){
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    @IBAction func commentCross(sender: UIButton!){
        self.txtComment.text = ""
        self.txtComment.endEditing(true)
        self.isEditComment = false
        self.attacmentUrl = ""
        self.newAttachment = Attachment()
        feedDataController.idComment = "0"
        feedDataController.isEdit = false
        self.btnRemoveMedia.isHidden = true
        self.crossBtnWidthConstraint.constant = 0
        self.crossBtnLeadingConstraint.constant = 0
         self.mediaViewHeightConstaint.constant = 0
        self.showPlaceholder()
        self.tableView.reloadData()
        
    }
    fileprivate func handleMoreMenu(for action: MenuAction) {
        switch action {
        case .delete:
            self.oneBtnCustomeAlert(title: "", discription: "Post deleted successfully") { (isComp, btn) in
                   self.navigationController?.popViewController(animated: true)
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
    fileprivate func handleMoreMenuComment(for action: MenuAction , comment: PostComment) {
        switch action {
        case .delete:
            var ind = (feedDataController.postList[feedDataController.postList.index(where: {$0.id! == comment.post_id})!].comments?.index(where: {$0.id! == comment.id}))!
            var count = feedDataController.postList[feedDataController.postList.index(where: {$0.id! == comment.post_id!})!].comments!.count - 1
            feedDataController.postList[feedDataController.postList.index(where: {$0.id! == comment.post_id!})!].comments_count = count as NSNumber
            feedDataController.postList[feedDataController.postList.index(where: {$0.id! == comment.post_id!})!].comments?.remove(at:ind )
           //.comments_count
            self.oneBtnCustomeAlert(title: "", discription:  "Comment deleted successfully") { (isComp, btn) in
                self.tableView.reloadData()
            }
           
        case .edit:
            self.isEditComment = true
            feedDataController.isEdit = true
            feedDataController.idComment = (comment.id?.stringValue)!
            if(comment.json_data != nil){
                if comment.json_data != nil {
                    let jsonObj = JSON.init(parseJSON: comment.json_data!)
                    if let json_data_array = jsonObj.array{
                        for data in json_data_array{
                            print(data.dictionaryValue)
                            let dic = data.dictionaryValue
                            let user_name  = dic["value"]?.stringValue
                            let trigger = dic["trigger"]?.stringValue
                            self.mention_Array.append((trigger!+user_name!).replaceHash())
                        }
                    }
                }
//                self.txtComment.text = comment.comment!
            self.SetAttributedText(mainString: comment.comment!+" ", attributedStringsArray: self.mention_Array, view: self.txtComment, color: UIColor.init(hex: "7CC244"))
            }else {
                if let cmnt = comment.comment {
                    self.txtComment.text = cmnt
                }
            }
            self.txtComment.becomeFirstResponder()
            self.crossBtnWidthConstraint.constant = 30
             self.crossBtnLeadingConstraint.constant = 8
            
            if(comment.attachment != nil){
                if(comment.attachment!.type!.trimmingCharacters(in: .whitespaces) == "image"){
                    self.attacmentUrl = comment.attachment!.file!
                    self.posterImageUrl = ""
                    self.videoUploaded = false
                    newAttachment.is_Video = false
                    newAttachment.ID = "-1"
                    mediaViewHeightConstaint.constant = 80
                    self.btnRemoveMedia.isHidden=false
                    self.btnCommentedImageOrPoster.sd_setBackgroundImage(with:URL.init(string: WebServiceName.images_baseurl.rawValue + self.attacmentUrl ) , for: .normal, completed:  { (Image, Error, Ca, urk) in
                        self.newAttachment.image_Attachment = Image!
                        self.btnCommentedImageOrPoster.setBackgroundImage(Image, for: .normal)
                    })
                }else {
                    self.posterImageUrl = comment.attachment!.poster!
                    self.attacmentUrl = comment.attachment!.file!
                    self.videoUploaded = true
                    newAttachment.is_Video = true
                    self.btnCommentedImageOrPoster.sd_setBackgroundImage(with:URL.init(string: WebServiceName.images_baseurl.rawValue + self.posterImageUrl ) , for: .normal, completed:  { (Image, Error, Ca, urk) in
                        self.newAttachment.image_Attachment = Image!
                        self.btnCommentedImageOrPoster.setBackgroundImage(Image, for: .normal)
                    })
                    newAttachment.video_URL = self.attacmentUrl
                    newAttachment.ID = "-1"
                    mediaViewHeightConstaint.constant = 80
                    self.btnRemoveMedia.isHidden=false
                }
            }
           self.tableView.reloadData()

        case .likeBy:
            if comment.likes?.count != 0 || comment.likedCount != 0{
                let likedActivity = self.GetView(nameViewController: "LikedByViewController", nameStoryBoard: "Wall") as! LikedByViewController
                likedActivity.feedDataController = self.feedDataController
                likedActivity.fromComment = true
                let p = self.feedDataController.postList[postindex].comments?.index(where: {$0.id == comment.id})
                likedActivity.commentIndex = p!
                likedActivity.postIndex = postindex
                self.present(likedActivity, animated: true, completion: nil)
            }
        
            
        default:
            break
        }
    }
}

// MARK: - Delegates
extension FeedDetailViewController: CameraDelegate{
    func VideoOutPulURL(videoURL: URL, image: UIImage) {

        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(#imageLiteral(resourceName: "VideoOverlay"), for: .normal)
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 80
        self.btnRemoveMedia.isHidden=false
        
        self.UploadVideoFiles(videoUrl: videoURL, index: postindex!)
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 80
        self.btnRemoveMedia.isHidden=false
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        
        self.UploadFiles(imageMain: image, index: 0,gif_url: gifURL)
    }
    func captured(image: UIImage) {
        
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 80
        self.btnRemoveMedia.isHidden=false
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        
        self.UploadFiles(imageMain: image, index: 0)
    }
}


extension FeedDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let post = detailForPost{
        return (post.comments?.count ?? 0) + 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return   UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0   {
            var postCell: TextPostTableViewCell!
            if detailForPost.postType == .text   {
                postCell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.textPost, for: indexPath) as? TextPostTableViewCell
            }
            else {
                postCell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.mediaPost, for: indexPath) as? MediaPostTableViewCell
                postCell.pageControl.isHidden = false
            }
            postCell.fromFeedDetail = true
//            if detailForPost.postType == .text{
//                postCell?.scrapView.isHidden = true
//                postCell?.urlViewHeight.constant = 0
//                postCell?.scrapSource.text = ""
//                postCell?.urlViewTitle.text = ""
//                postCell?.urlViewDesc.text = ""
//                postCell?.urlViewImage.image = nil
//                if let url = self.slp.extractURL(text: detailForPost.discription!){
//                    postCell?.urlBtnAtion = { [unowned self] menuButton in
//                        self.OpenUrl(webUrl: url)
//                    }
//                    var stt =  Constants.ShareLinkConstant + "get-question-answers/"
//                    var sttt =  "http://139.162.37.73/healingbudz/get-question-answers/"
//                    if (url.absoluteString.contains(stt)){
//                        postCell?.btnDiscuss.isHidden = false
//                    }else if (url.absoluteString.contains(sttt)){
//                        postCell?.btnDiscuss.isHidden = false
//                    }else {
//                        postCell?.btnDiscuss.isHidden = true
//                    }
//                    postCell?.urlBtnDiss = { [unowned self] menuButton in
//                        if (url.absoluteString.contains(stt)){
//                            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
//                            DetailQuestionVc.QuestionID = url.absoluteString.replacingOccurrences(of: stt, with: "")
//                            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
//                        }else if (url.absoluteString.contains(sttt)){
//                            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
//                            DetailQuestionVc.QuestionID = url.absoluteString.replacingOccurrences(of: sttt, with: "")
//                            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
//                        }
//                    }
//                    postCell?.activityIndicate.startAnimating()
//                    postCell?.urlViewHeight.constant = 230
//                    postCell?.scrapView.isHidden  = false
//                    let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString)
//                    if cached?.count != nil{
//                        postCell?.activityIndicate.stopAnimating()
//                        self.result = cached!
//                        postCell?.selectionStyle = .none
//                        postCell?.scrapSource.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                        postCell?.urlViewTitle.text = self.result[.title] as? String
//                        postCell?.urlViewDesc.text = self.result[.description] as? String
//                        if let img_url = result[.image] as? String{
//                            postCell?.urlViewImage.sd_setImage(with: URL.init(string: img_url), completed: { (image, error, chache, url) in
//                            })
//                        }else{
//                            postCell?.urlViewImage.image = nil
//                        }
//                    }else{
//                        self.slp.preview(detailForPost.discription!,
//                                         onSuccess: { result in
//                                            print(result)
//                                            postCell?.activityIndicate.stopAnimating()
//                                            self.result = result
//                                            postCell?.selectionStyle = .none
//                                            postCell?.scrapSource.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                                            postCell?.urlViewTitle.text = self.result[.title] as? String
//                                            postCell?.urlViewDesc.text = self.result[.description] as? String
//                                            //                            cell?.lbl_scrapping_source.text = (self.result[.canonicalUrl] as? String)?.components(separatedBy: ".")[1]
//                                            if let img_url = result[.image] as? String{
//                                                postCell?.urlViewImage.sd_setImage(with: URL.init(string: img_url), completed: { (image, error, chache, url) in
//                                                })
//                                            }else{
//                                                postCell?.urlViewImage.image = nil
//                                            }
//
//                        },
//                                         onError: { error in
//                                            print(error)
//                        }
//                        )
//
//                    }
//                }
//            }
            postCell.urlBtnAtion = { [unowned self] in
                if let url = self.detailForPost.scrapind_data!["url"] as? String{
                    self.OpenUrl(webUrl: URL.init(string: url)!)
                }
                
            }
            postCell.index = postindex
            postCell.isDetailScreen = true
            postCell?.setTag(post: detailForPost)
            postCell?.tagCollectionView.reloadData()
            postCell.feedDataController=self.feedDataController
            postCell?.display(post: detailForPost, parentVC: self)
            postCell?.timeAgoLabel.text = self.GetTimeAgoWall(StringDate: detailForPost.created_at!)
            postCell?.menuButton.tag = postindex
            
            postCell?.menuButtonAction = { [unowned self] menuButton in
                self.feedDataController.showPopoverMenu(isShownOnTop: false, sender: menuButton, for: self.detailForPost, controller: self)    { menuAction in
                    self.handleMoreMenu(for: menuAction)
                
                }
            }
            
            postCell?.LikedByAction = { [unowned self] menuButton in
                self.likedByActivity()
            }
            postCell?.repostAction = { [unowned self] menuButton in
                if self.detailForPost.user_id!.stringValue != DataManager.sharedInstance.getPermanentlySavedUser()!.ID {
                    self.repostActivity()
                }else {
                    self.ShowErrorAlert(message: "You can't repost your own post!")
                }
                
            }
            
            postCell?.likesButtonAction = {[unowned self] in
                self.feedDataController.performLike(cell: postCell, index: self.postindex, controller: self)
                self.detailForPost = self.feedDataController.postList[self.postindex]
            }
            
            postCell?.commentsButtonAction = {[weak self] commentsButton in
                self?.txtComment.becomeFirstResponder()
            }
            
            postCell?.profileButtonAction = {[unowned self] userId in
                let sessionUserId = DataManager.sharedInstance.user!.ID
                var fdc: FeedDataController?
                if userId == sessionUserId  {
                    fdc = self.feedDataController
                }
                self.OpenProfileVC(id: userId, feedDataController: fdc)
            }
            
            postCell?.postedAsUserButtonAction = {[unowned self] budzMap in
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewPush = mainStoryboard.instantiateViewController(withIdentifier: "DispensaryDetailVC") as! DispensaryDetailVC
                viewPush.chooseBudzMap = budzMap
                self.navigationController?.pushViewController(viewPush, animated: true)
            }
            
            postCell.baseVC =  self
            
           /*
 postCell?.menuButtonAction = { [weak self] menuButton in
                self?.showPopoverMenu(sender: menuButton)
            }
            
            
            
            postCell?.repostsButtonAction = {[weak self] repostsButton in
                self?.handleRepostsAction(repostsButton: repostsButton, for: post)
            }
 */
            cell = postCell
        }
        else {
            let commentsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentier.comment, for: indexPath) as? CommentTableViewCell
            let comment = detailForPost.comments![indexPath.row - 1]
            commentsCell?.display(comment: comment)
            commentsCell?.performLike.tag = indexPath.row - 1
            commentsCell?.performLike.addTarget(self, action: #selector(self.likeButtonAction(sender:)), for: .touchUpInside)
            commentsCell?.timeAgoLabel.text = self.GetTimeAgoWall(StringDate: comment.created_at!)
            if(comment.user_id?.stringValue == DataManager.sharedInstance.user?.ID ){
                commentsCell?.menuButton.isHidden = false
                commentsCell?.menuButtonWidthConstraint.constant = 30
                
            }else {
                commentsCell?.menuButton.isHidden = true
                commentsCell?.menuButtonWidthConstraint.constant = 0
            }
            commentsCell?.menuButton.tag = postindex
            commentsCell?.menuButtonCommentAction = { [unowned self] menuButton in
                self.feedDataController.showPopoverMenuComment(sender: menuButton, for: comment, controller: self, completion: { (menuAction) in
                    self.handleMoreMenuComment(for: menuAction , comment: comment)
                })
            }
            commentsCell?.post=self.detailForPost
            cell = commentsCell
            commentsCell?.baseVC = self
            commentsCell?.profileButtonAction = {[unowned self] userId in
                let sessionUserId = DataManager.sharedInstance.user!.ID
                var fdc: FeedDataController?
                if userId == sessionUserId  {
                    fdc = self.feedDataController
                }
                self.OpenProfileVC(id: comment.user_id!.stringValue, feedDataController: fdc)
            }
            
        }
        
        return cell!
    }
}

extension FeedDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row != 0
        {
            
            let comments = self.detailForPost.comments![indexPath.row-1]
            if let poster =  comments.attachment?.poster
            {
                CreateGalleryViewer(withImage: comments.attachment!.file!, userIfno: false, poster:poster, index: indexPath.row - 1)
            }
            else if let file  = comments.attachment?.file
            {
                CreateGalleryViewer(withImage: file, userIfno: false, poster:"", index: indexPath.row - 1)
            }
            
            
        }
    }
}

 extension FeedDetailViewController{
    @IBAction func likeButtonAction(sender: UIButton!){
        sender.removeTarget(nil, action: nil, for: .allEvents)
        self.performCommentLike(comment: self.detailForPost.comments![sender.tag], sender: sender)
    }
    
    
    func performCommentLike(comment: PostComment!, sender: UIButton!){
        //    self.showLoading()
        var likeVal = 0
        if let val = comment.likedCount{
            if val == 0{
                likeVal = 1
            }
        }
        var param = [String: AnyObject]()
        param["comment_id"] = comment.id as! AnyObject
        param["is_like"] = likeVal as! AnyObject
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_comment_like_dislike.rawValue, params: param, completion: {(success, message, response) in
            sender.addTarget(self, action: #selector(self.likeButtonAction(sender:)), for: .touchUpInside)
            print(response)
            if success{
                if likeVal == 1{
                    comment.likedCount = 1
                    comment.likesCount = comment.likesCount! + 1
                }else{
                    comment.likedCount = 0
                    comment.likesCount = comment.likesCount! - 1
                }
                let s = self.detailForPost.comments?.index(where: {$0.id == comment.id})
                self.detailForPost.comments![s!] = comment
                var i = self.feedDataController.postList.index(where: {$0.id == self.detailForPost.id})
                self.feedDataController.postList[i!] = self.detailForPost
                self.feedDataController.postList[i!].newAttachment = self.detailForPost.newAttachment
                self.feedDataController.postList[i!].scrapedData = self.detailForPost.scrapedData
                //                self.videoUploaded = true
                self.feedDataController.shouldFetchLatestPosts = true
                self.tableView.reloadData()
            }else{
                self.simpleCustomeAlert(title: "Error", discription: message)
            }
        })
    }
 }


extension FeedDetailViewController: GrowingTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        acManager.processString(textView.text)
        if textView.text.count == 0 {
            self.updateTriggerData(newText: textView.text)
            self.SetAttributedText(mainString: textView.text.replacingOccurrences(of: "_", with: " "), attributedStringsArray: self.mention_Array, view: self.txtComment, color: UIColor.init(hex: "7CC244"))
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.contains("Your Comment")
        {
            hidePlaceholder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.delayWithSeconds(0.03) {
            self.SetAttributedText(mainString: textView.text+" ", attributedStringsArray: self.mention_Array, view: self.txtComment, color: UIColor.init(hex: "7CC244"))
        }
     if textView.text == ""
     {
        showPlaceholder()
     }
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
//network calls
extension FeedDetailViewController
{
    func UploadFiles(imageMain : UIImage, index: Int,gif_url:URL? = nil){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_post_image.rawValue, image: imageMain,gif_url:gif_url, onView: self) { (MainResponse) in
            
            print(MainResponse)
            self.hideLoading()
            
            if MainResponse != nil {
               let url = MainResponse["file"] as! String
                self.attacmentUrl = url
                self.posterImageUrl = ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
               
                }
                
                //                }
            }else {
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    func UploadVideoFiles(videoUrl : URL, index: Int){
        self.showLoading()
        NetworkManager.UploadVideo(WebServiceName.add_post_video.rawValue, urlVideo: videoUrl, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if MainResponse != nil {
                let videoUrl = MainResponse["file"] as! String
                let poeterUrl = MainResponse["poster"] as! String
                self.posterImageUrl = poeterUrl
                self.attacmentUrl = videoUrl
                self.videoUploaded = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                }
            }else {
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
}



// MARK: - Private Constants
fileprivate struct CellIdentier {
    static let textPost = "TextPostTableViewCell"
    static let mediaPost = "MediaPostTableViewCell"
    static let comment = "CommentTableViewCell"
//    static let postImage = "PostImageCollectionViewCell"
}
