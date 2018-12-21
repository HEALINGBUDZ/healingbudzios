//
//  PostFeedViewController.swift
//  BaseProject
//
//  Created by Yasir Ali on 02/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import GrowingTextView
import ObjectMapper
import SwiftyJSON
import AVKit
import IQKeyboardManager
import MJAutoComplete
var mentionSubUsers = [PostSubUser]()

extension String{
    func replaceHash() -> String{
        var text = self
        text = text.replacingOccurrences(of: "##################", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "#################", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "################", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "###############", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "##############", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "#############", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "############", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "###########", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "##########", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "#########", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "########", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "#######", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "######", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "#####", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "####", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "###", with: "#", options: .literal, range: nil)
        text = text.replacingOccurrences(of: "##", with: "#", options: .literal, range: nil)
        return text
    }
}
extension PostFeedViewController  {
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
        self.whatsOnYourMindTextView.delegate = self
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
        let value  = (self.whatsOnYourMindTextView.frame.width * percent)/100
        let xPosition = self.whatsOnYourMindTextView.frame.origin.x
        let yPosition = self.whatsOnYourMindTextView.frame.origin.y +  CGFloat((Int(text.count/45) * 30 ) + 30)
        let height = self.acContainerView.frame.size.height
        let width = self.acContainerView.frame.size.width
        self.acContainerView.frame =  CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
        if self.acContainerView.isHidden{
            self.acContainerView.zoomIn()
        }
    }
}

extension PostFeedViewController: MJAutoCompleteManagerDataSource {
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, itemListFor trigger: MJAutoCompleteTrigger!, with string: String!, callback: MJAutoCompleteListCallback!) {
        self.acContainerView.isHidden = true
        callback(trigger.autoCompleteItemList)
    }
}

extension PostFeedViewController: MJAutoCompleteManagerDelegate {
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, willPresentCell autoCompleteCell: Any!, for trigger: MJAutoCompleteTrigger!) {
        if self.acContainerView.isHidden{
            self.acContainerView.isHidden = false
            self.updateTaggingViewPosition(text: self.whatsOnYourMindTextView.text)
        }
        if trigger.delimiter == "#"{
            let cell = autoCompleteCell as! MentionTableViewCell
            cell.profileImageView.image = #imageLiteral(resourceName: "QATag")
            cell.nameLabel.text = cell.textLabel?.text
            cell.textLabel?.text = ""
            print(trigger.autoCompleteItemList.count)
            cell.nameLabel.textColor = UIColor.white
            cell.profileImageViewTop.isHidden = true
            cell.backgroundColor = UIColor.clear
            
        }else if trigger.delimiter == "@"{
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
            cell.backgroundColor = UIColor.clear
            print(trigger.autoCompleteItemList.count)
        }
    }
    
    func autoCompleteManager(_ acManager: MJAutoCompleteManager!, shouldUpdateToText newText: String!) {
        self.acContainerView.isHidden = true
        self.updateTriggerData(newText: newText)
        let mentions = self.matches(regex: "([@#][\\w_-]+)", text: newText)
        print("mentions are: \(mentions)")
        if mentions.count > 0 {
            let menstion_str = mentions.last?.replacingOccurrences(of: "_", with: " ")
            self.mention_Array.append(menstion_str!)
        }
        self.SetAttributedText(mainString: newText.replacingOccurrences(of: "_", with: " "), attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
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

extension Array {
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}

class PostFeedViewController: BaseViewController, CameraDelegate {
    @IBOutlet weak var acContainerView: UIView!
    @IBOutlet weak var whatsOnYourMindTextView: GrowingTextView!
    @IBOutlet var feedOptionViewList: [PostFeedOptionView]!
    @IBOutlet var feedOptionBarViewList: [PostFeedOptionBarView]!
    var txtUrl:String?
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var mediaCollectionViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var mediaCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet var feedOptionListStackView: UIStackView!
    @IBOutlet var feedOptionBarStackView: UIStackView!
    
    
    @IBOutlet weak var profilePictureImageView: CircularImageView!
    @IBOutlet weak var profilePictureImageViewTop: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var budLabel: UILabel!
    @IBOutlet weak var pointsBudzSeperator: UIView!
    @IBOutlet weak var budIconImageView: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!;
    @IBOutlet weak var videoPickerButton: UIButton!;
    @IBOutlet weak var savePost: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var moreTagButton:UIButton!
    @IBOutlet weak var moreTagButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var tagView:UIView!
    
    var updated_followed_user_model = [PostUser]()
    var updated_tags = [PostTags]()
    var letMoretags = false
    var ifsubusers = false
    var videoUploaded = false
    var imageCount = 0
    var array_Attachment = [Attachment]()
    var SubUsers = [PostSubUser]()
    var editIndex = -1
    var editPostId: String!
    var feedDataController: FeedDataController!
    var photos = Media()
    static  var followedUsers = [PostUser]()
    static  var tags = [PostTags]()
    var withTagsArray = [PostUser]()
    var followed_user_model = [PostUser]()
    var mention_Array = [String]()
    var acManager = MJAutoCompleteManager()
    var mentionItems = [MJAutoCompleteItem]()
    var tagItems = [MJAutoCompleteItem]()
    var editTagList = [PostUser]()
    @IBOutlet weak var SubUserView:UIView!
    @IBOutlet weak var SubUserTableView:UITableView!
    @IBOutlet weak var SubUserLabel:UILabel!
    @IBOutlet weak var postAsToggleButton:UIButton!
    @IBOutlet weak var postAsLabel: UILabel!
    @IBOutlet weak var postAsView: UIView!
    @IBOutlet weak var postAsConstraintHeight: NSLayoutConstraint!
    var SubUserID: NSNumber! = 0
    
    @IBOutlet var feedOptionBarBottomConstraint: NSLayoutConstraint!
    var keyboardHeight = CGFloat(0.0)
    
    @IBOutlet weak var feedOptionToolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
//        configureTagTextView()
        self.whatsOnYourMindTextView.delegate = self
        whatsOnYourMindTextView.text = "Hey Bud, what's on your mind?"
        self.tagView.isHidden = true
        self.displayUserProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
//        self.whatsOnYourMindTextView.inputAccessoryView = feedOptionToolbar
        let mediaPostCellNib = UINib(nibName: CellIdentier.postImage, bundle: nil)
        self.mediaCollectionView.register(mediaPostCellNib, forCellWithReuseIdentifier: CellIdentier.postImage)
        SubUserTableView.estimatedRowHeight = 20
        SubUserTableView.rowHeight = UITableViewAutomaticDimension
        SubUserTableView.separatorStyle = .none
        SubUserView.isHidden = true
        mediaCollectionViewHeightContraint.constant =  array_Attachment.count != 0 ? 200 : 0
        pageControl.numberOfPages = array_Attachment.count
        mediaCollectionViewLayout.minimumLineSpacing = 0
        mediaCollectionViewLayout.minimumInteritemSpacing = 0
        feedOptionViewList.first!.isSelected = true
        feedOptionBarViewList.first!.isSelected=true
        self.postAsView.isHidden = true
        self.postAsLabel.isHidden = true
        configureCollectionViewLayoutItemSize()
        getFollowers()
        getSubUsers()
    }
    private func configureCollectionViewLayoutItemSize()    {
        mediaCollectionView.invalidateIntrinsicContentSize()
        
        mediaCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mediaCollectionViewLayout.itemSize = mediaCollectionView!.frame.size
        print(mediaCollectionViewLayout.itemSize)
        print(self.array_Attachment.count)
        
        
        //        mediaCollectionViewLayout.collectionView!.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postSaveParams.images = ""
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        if txtUrl != nil {
            if (txtUrl?.count)! > 0 {
                whatsOnYourMindTextView.text = txtUrl!
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func moreTagButttonAction(sender: UIButton!){
      self.letMoretags = true
      self.moreTagButtonWidth.constant = 0
      tagCollectionView.reloadData()
    }
    
  
    @IBAction func imagePicker(sender: UIButton!){
        self.whatsOnYourMindTextView.endEditing(true)
        if imageCount < 5{
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
        }else{
            self.ShowErrorAlert(message:"You have added 5 images already!")
        }
    }
    @IBAction func tagAction(sender: UIButton!){
        let tagNav = self.GetView(nameViewController: "TagsViewController", nameStoryBoard: "Wall") as! TagsViewController
        tagNav.delegate = self
        editTagList = PostFeedViewController.followedUsers
        if withTagsArray.count != 0{
            for tag in withTagsArray{
                self.editTagList.remove(at: self.editTagList.index(where: { $0.id == tag.id })!)
            }
            tagNav.tags = editTagList
            tagNav.selectedTags = withTagsArray
        }else{
            tagNav.tags = PostFeedViewController.followedUsers
        }
        self.present(tagNav, animated: true, completion: nil)
    }
    
    func removeTag(index: Int!){
        self.withTagsArray.remove(at: index)
        if self.withTagsArray.count == 0{
            tagView.isHidden = true
        }
        self.tagCollectionView.reloadData()
    }
    
    @IBAction func videoPicker(sender: UIButton!){
        self.whatsOnYourMindTextView.endEditing(true)
        if videoUploaded == false{
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        vcCamera.callFromWall = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
        }else{
            self.ShowErrorAlert(message:"You already added a video!")
        }
    }
    @IBAction func postAsViewToggle(sender: UIButton!){
        self.whatsOnYourMindTextView.endEditing(true)
        if ifsubusers{
          SubUserView.isHidden = !SubUserView.isHidden
        }
    }
    
    @IBAction func textFieldFocus(sender: UIButton!){
        self.whatsOnYourMindTextView.becomeFirstResponder()
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func toggleView(sender: UIButton!){
        toggleAllowSelection()
    }
    
    private func toggleAllowSelection(){
        self.whatsOnYourMindTextView.endEditing(true)
        feedOptionViewList[0].isSelected = !feedOptionViewList[0].isSelected
        feedOptionBarViewList[0].isSelected = !feedOptionBarViewList[0].isSelected
        if feedOptionViewList[0].isSelected {
             postSaveParams.repost_to_wall = 1
        }else{
             postSaveParams.repost_to_wall = 0
        }
//        if postSaveParams.repost_to_wall == 0{
//            postSaveParams.repost_to_wall = 1
//        }else{
//            postSaveParams.repost_to_wall = 0
//        }
    }
    
    func getFollowers(){
        
        let UserId = DataManager.sharedInstance.user!.ID
        let serviceUrl = WebServiceName.get_followings.rawValue + "\(UserId)"
        
        NetworkManager.GetCall(UrlAPI: serviceUrl) { [weak self] (apiSucceed, message, responseData) in
//            print(responseData)
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    let data = responseData["successData"] as? [[String: Any]]
                    PostFeedViewController.followedUsers.removeAll()
                    for user in data!  {
                      let follow = PostUser(JSON: user)
                      PostFeedViewController.followedUsers.append(follow!)
                    }
                    self?.getTags()
                    if(self?.editIndex != -1){
                        self?.editPost(post: (self?.feedDataController.postList[(self?.editIndex)!])!)
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
//            print(responseData)
            
            
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
    @IBAction func savePostAction(sender: UIButton!){
        self.whatsOnYourMindTextView.endEditing(true)
        print(withTagsArray)
        var whatsOnYourMind = whatsOnYourMindTextView.text
        if whatsOnYourMindTextView.text == "Hey Bud, what's on your mind?" || whatsOnYourMindTextView.text == "" {
            whatsOnYourMind = ""
        }
        
        postSaveParams.images = ""
        postSaveParams.tagged = ""
        postSaveParams.video = ""
        postSaveParams.ratio = ""
        postSaveParams.thumb = ""
        
        if array_Attachment.count != 0{
            for attachment in array_Attachment{
                if attachment.is_Video == true{
                    postSaveParams.video = attachment.server_URL
                    postSaveParams.poster = attachment.image_URL
                }else{
                    if postSaveParams.images == ""{
                        postSaveParams.images = attachment.server_URL
                        postSaveParams.thumb = attachment.thumb
                        postSaveParams.ratio = String(attachment.image_ratio)
                    }else{
                        postSaveParams.images = postSaveParams.images + "," + attachment.server_URL
                         postSaveParams.thumb = postSaveParams.thumb + "," + attachment.thumb
                         postSaveParams.ratio = postSaveParams.ratio + "," + String(attachment.image_ratio)
                    }
                }
            }
        }
        if withTagsArray.count != 0{
        for tag in withTagsArray{
            if postSaveParams.tagged == ""{
                postSaveParams.tagged = String((tag.id?.intValue)!)
            }else{
                postSaveParams.tagged = postSaveParams.tagged + "," + String((tag.id?.intValue)!)
            }
        }
        }

        postSaveParams.description = whatsOnYourMind!
        if SubUserID != 0{
         postSaveParams.posting_user = "s_" + String(describing: SubUserID!)
        }else{
         postSaveParams.posting_user = ""
        }

        var json_data_mentions = [[String : Any]]()
        for mentios_data  in self.mention_Array{
            if mentios_data.contains("@"){
                for user in followed_user_model{
                    print(user.first_name ?? "test")
                    print(mentios_data)
                    if user.first_name != nil {
                        let user_name = "@" + user.first_name!
                        if  mentios_data == user_name && self.whatsOnYourMindTextView.text.contains(mentios_data){
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
                }
            }else{
                for tag in PostFeedViewController.tags{
                    print(tag.title ?? "test")
                    print(mentios_data)
                    let title = "#" + tag.title!
                    if  mentios_data == title  && self.whatsOnYourMindTextView.text.contains(mentios_data){
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
        
        
        var characters  = self.whatsOnYourMindTextView.text.components(separatedBy: " ")
        for char in characters {
            for main_keyword in AppDelegate.appDelegate().orignalkeywords{
                print(char.lowercased() + " -- " + main_keyword + "  Adn  " +  "#"+main_keyword.lowercased() )
                if main_keyword.lowercased() == char.lowercased() ||  "#"+main_keyword.lowercased() == char.lowercased(){
                    var json_data_single = [String : Any]()
                    json_data_single["id"] = 1
                    json_data_single["trigger"] = "#"
                    json_data_single["type"] = "tag"
                    json_data_single["value"] = char
                    json_data_mentions.append(json_data_single)
                    whatsOnYourMind = whatsOnYourMind?.replacingOccurrences(of: char, with: "#"+char, options: .literal, range: nil)
                    characters.remove(at: characters.index(of: char)!)
                    break
                }
            }
        }
        postSaveParams.description = whatsOnYourMind!.replaceHash()
        if json_data_mentions.count > 0 {
            if editIndex != -1{
                if feedDataController.postList[editIndex].json_data != nil {
                    let jsonObj = JSON.init(parseJSON: feedDataController.postList[editIndex].json_data!)
                    if let json_data_array = jsonObj.array{
                        for data in json_data_array{
                            print(data.dictionaryValue)
                            let dic = data.dictionaryValue
                            let user_name  = dic["value"]?.stringValue
                            let trigger = dic["trigger"]?.stringValue
                            let type = dic["type"]?.stringValue
                            let id = dic["id"]?.intValue
                            var json_data_single = [String : Any]()
                            json_data_single["id"] = id
                            json_data_single["trigger"] = trigger
                            json_data_single["type"] = type
                            json_data_single["value"] = user_name
                            json_data_mentions.append(json_data_single)
                        }
                    }
                }
            }
            
            let paramsJSON = JSON(json_data_mentions)
            print(paramsJSON.stringValue)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            print(paramsString)
            postSaveParams.json_data = paramsString
        }
        print(postSaveParams)
        var url = ""
        if postSaveParams.description.count > 0 || self.array_Attachment.count > 0{
            let desc = postSaveParams.description
                // extract url
                do {
                    
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(in: desc, options: [], range: NSRange(location: 0, length: desc.utf16.count))
                    
                    if !matches.isEmpty {
                        let range = Range(matches.first!.range, in: desc)!
                        url = desc[range]
                        print(url)
                        if url.contains("Https"){
                            url = url.stringByReplacingFirstOccurrenceOfString(target: "H", withString: "h")
                        }
                    }
                }
                catch {
                    print(error)
                }
                
                
                //  /extract url
                
                self.showLoading()
                var mainParam: [String : AnyObject]
                if editIndex == -1{
                    mainParam = ["description": desc as AnyObject,
                                 "images": postSaveParams.images as AnyObject,
                                 "video": postSaveParams.video as AnyObject,
                                 "poster": postSaveParams.poster as AnyObject,
                                 "tagged": postSaveParams.tagged as AnyObject,
                                 "thumb": postSaveParams.thumb as AnyObject,
                                 "ratio": postSaveParams.ratio as AnyObject,
                                 "json_data": postSaveParams.json_data as AnyObject,
                                 "posting_user": postSaveParams.posting_user as AnyObject,
                                 "repost_to_wall": postSaveParams.repost_to_wall as AnyObject,
                                 "url": url as AnyObject]
                }else{
                    mainParam = ["description": desc as AnyObject,
                                 "images": postSaveParams.images as AnyObject,
                                 "video": postSaveParams.video as AnyObject,
                                 "thumb": postSaveParams.thumb as AnyObject,
                                 "ratio": postSaveParams.ratio as AnyObject,
                                 "poster": postSaveParams.poster as AnyObject,
                                 "tagged": postSaveParams.tagged as AnyObject,
                                 "json_data": postSaveParams.json_data as AnyObject,
                                 "posting_user": postSaveParams.posting_user as AnyObject,
                                 "repost_to_wall": postSaveParams.repost_to_wall as AnyObject,
                                 "post_id": editPostId as AnyObject,
                                 "url": url as AnyObject]
                }
                print(mainParam)
                NetworkManager.PostCall(UrlAPI:WebServiceName.save_post.rawValue, params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
//                    print(responseData)
                    self.hideLoading();
                    if apiSucceed   {
                        let status = responseData["status"] as! String
                        if status == "success"  {
                            self.feedDataController.shouldFetchLatestPosts = true
                            if self.editIndex == -1{
                                self.oneBtnCustomeAlert(title: "", discription:   "Post added successfully") { (isComp, btn) in
//                                    if self.txtUrl != nil && (self.txtUrl?.count)! > 0 {
////                                        exit(0)
//                                        self.navigationController?.popViewController(animated: true)
//                                    }else {
//                                        self.dismiss(animated: false, completion: nil)
//                                    }
                                    self.dismiss(animated: false, completion: nil)
                                }
                                
                            }else{
                                self.oneBtnCustomeAlert(title: "", discription:   "Post updated successfully") { (isComp, btn) in
                                    self.dismiss(animated: true)
                                }
                                
                            }
                        }  // data
                    } // successs
                    else {
                        if let errorMessage = responseData["errorMessage"] as? String   {
                            if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                                DataManager.sharedInstance.logoutUser()
                                self.ShowLogoutAlert()
                            }
                            else {
                                self.ShowErrorAlert(message:errorMessage)
                            }
                        } // errorMessage
                        else    {
                            self.ShowErrorAlert(message:"Try again later!")
                        }
                    } // error
                } // api Succeed
        }else{
             self.ShowErrorAlert(message:"Description is required!")
        }
    } // netowrk call
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    func gifData(gifURL: URL, image: UIImage) {
        print(gifURL)
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        
        self.array_Attachment.append(newAttachment)
        self.feedOptionListStackView.isHidden = true
        self.feedOptionBarStackView.isHidden = false
        let index = self.array_Attachment.index(of: newAttachment)
        self.UploadFiles(imageMain: image, index: index!, isGif: true, gifURL: gifURL)
        self.mediaCollectionViewHeightContraint.constant =  200
        self.pageControl.numberOfPages = self.array_Attachment.count
        self.configureCollectionViewLayoutItemSize()
        self.feedOptionListStackView.isHidden = true
        self.feedOptionBarStackView.isHidden = false
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        
        self.array_Attachment.append(newAttachment)
        let index = self.array_Attachment.index(of: newAttachment)
        self.UploadVideoFiles(videoUrl: videoURL, index: index!)
        self.mediaCollectionViewHeightContraint.constant =  200
        self.pageControl.numberOfPages = self.array_Attachment.count
        self.configureCollectionViewLayoutItemSize()
        self.feedOptionListStackView.isHidden = true
        self.feedOptionBarStackView.isHidden = false
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.feedOptionListStackView.isHidden = true
        self.feedOptionBarStackView.isHidden = false
        let index = self.array_Attachment.index(of: newAttachment)
        self.delayWithSeconds(0.9) {
            self.view.bringSubview(toFront: self.feedOptionBarStackView)

        }
        self.UploadFiles(imageMain: image, index: index!)
    }
    
    func showMediaInCollectionView()   {
        self.mediaCollectionViewHeightContraint.constant =  200
        self.pageControl.numberOfPages = self.array_Attachment.count
        self.configureCollectionViewLayoutItemSize()
        
        mediaCollectionView.reloadData()
        mediaCollectionView.layoutIfNeeded()
    }
    
    func UploadFiles(imageMain : UIImage, index: Int , isGif : Bool = false , gifURL : URL? = nil){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_post_image.rawValue, image: imageMain,gif_url:  gifURL  ,onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if MainResponse != nil {
                self.array_Attachment[index].server_URL = MainResponse["file"] as! String
                self.array_Attachment[index].thumb = MainResponse["thumb"] as! String
                if let ratio = MainResponse["ratio"] as? String {
                    self.array_Attachment[index].image_ratio = Double(ratio)!
                }else if let ratio = MainResponse["ratio"] as? NSNumber {
                     self.array_Attachment[index].image_ratio = ratio.doubleValue
                }
                self.imageCount = self.imageCount + 1;
                self.mediaCollectionViewHeightContraint.constant =  200
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.showMediaInCollectionView()
                }
            }else {
                self.hideLoading()
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
                    self.array_Attachment[index].server_URL = MainResponse["file"] as! String
                    self.array_Attachment[index].image_URL = MainResponse["poster"] as! String
                    self.videoUploaded = true
                    self.array_Attachment[index].is_Video = true
                self.mediaCollectionViewHeightContraint.constant =  200
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.showMediaInCollectionView()
                }
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    
    func deleteImage(index: Int){
        if self.array_Attachment[index].is_Video == true{
            self.videoUploaded = false
        }else{
            self.imageCount = self.imageCount - 1
        }
        self.array_Attachment.remove(at: index);
        if self.array_Attachment.count == 0{
            self.mediaCollectionViewHeightContraint.constant =  0
        }
        self.pageControl.numberOfPages = self.array_Attachment.count
        self.mediaCollectionView.reloadData();
        
    }

     func getSubUsers(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI:WebServiceName.get_sub_users.rawValue) { (apiSucceed, message, responseData) in
            self.hideLoading()
//            print(responseData)
            self.SubUsers.removeAll()
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let successData = responseData["successData"]    {
                        if let sub_users_dictionaries = successData["sub_users"]  as? [[String: Any]]  {
                            if sub_users_dictionaries.count != 0{
                                self.postAsView.isHidden = false
                                self.postAsLabel.isHidden = false
                            for sub_user_dictionary in sub_users_dictionaries{
                                let sub = PostSubUser(JSON: sub_user_dictionary)
                                self.SubUsers.append(sub!)
                            }
                                if(self.SubUsers.count == 1){
                                    self.postAsConstraintHeight.constant = 60
                                }else if(self.SubUsers.count == 2){
                                    self.postAsConstraintHeight.constant = 90
                                }else if(self.SubUsers.count == 3){
                                    self.postAsConstraintHeight.constant = 120
                                }else if(self.SubUsers.count >= 4){
                                    self.postAsConstraintHeight.constant = 150
                                }
                            }else{
                                self.postAsView.isHidden = true
                                self.postAsLabel.isHidden = true
                            }
                        }
                    }
                    
                    if (self.SubUsers.count) > 0{
                        self.ifsubusers = true
                    }
                    self.SubUserTableView.reloadData()
                }  // data
            } // successs
            else {
                if let errorMessage = responseData["errorMessage"] as? String   {
                    if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                    else {
                        self.ShowErrorAlert(message:errorMessage)
                    }
                } // errorMessage
                else    {
                    self.ShowErrorAlert(message:"Try again later!")
                }
            } // error
        } // api Succeed
    } // netowrk call
    
    func editPost(post: Post){
        let id = post.id! as! Int
        self.editPostId = String(id)
        if post.allow_repost != 1{
            toggleAllowSelection()
        }
        if post.tagged?.count != 0{
            for tag in post.tagged!{
                self.withTagsArray.append(tag.user)
                
            }
            if self.withTagsArray.count > 3{
            self.moreTagButton.setTitle((String(self.withTagsArray.count - 3) + " more"), for: .normal)
            }else{
                self.moreTagButtonWidth.constant = 0
            }
            self.tagView.isHidden = false
            self.tagCollectionView.reloadData()
            
        }
        if post.files?.count != 0{
        if let fileLength = post.files?.count{
            for i in  0..<fileLength {
                let attach = Attachment()
                attach.server_URL = post.files![i].file!
                if post.files![i].type! == "video"{
                    attach.is_Video = true
                    attach.image_URL = post.files![i].poster!
                }
                
                array_Attachment.append(attach)
                imageCount = imageCount + 1
            }
          }
            self.feedOptionListStackView.isHidden = true
            self.feedOptionBarStackView.isHidden = false
            self.mediaCollectionViewHeightContraint.constant =  200
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.showMediaInCollectionView()
            }
        }
        if post.json_data != nil {
            let jsonObj = JSON.init(parseJSON: post.json_data!)
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
        print(self.mention_Array)
        self.SetAttributedText(mainString: post.discription!+" ", attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
        if post.sub_user != nil{
            SubUserLabel.text = post.sub_user?.title
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

 //MARK: - UITableViewDataSource

extension PostFeedViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(SubUsers.count)
        return SubUsers.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SubUserTableView.dequeueReusableCell(withIdentifier: "SubUserCell", for: indexPath) as! PostAsTableViewCell

        if indexPath.row == 0{
            cell.subUserTitle.text = userNameLabel.text!
        }else{
          cell.subUserTitle.text = SubUsers[indexPath.row - 1].title ?? ""
        }

        cell.selectionStyle = .none
//        print(SubUsers[indexPath.row].title!)
        return cell
    }



}

extension PostFeedViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
         SubUserLabel.text = SubUsers[indexPath.row - 1].title!
         SubUserID = SubUsers[indexPath.row - 1].id!;
        }else{
            SubUserLabel.text = userNameLabel.text!
            SubUserID = 0
        }
        self.SubUserView.isHidden = true
        print(SubUserID)
    }
}


//Mark: - Collection Views

extension PostFeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mediaCollectionView{
         return self.array_Attachment.count;
        }else{
            if letMoretags || withTagsArray.count < 3{
              return withTagsArray.count
            }else{
              return 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mediaCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentier.postImage, for: indexPath) as! PostImageCollectionViewCell
        let file = array_Attachment[indexPath.row]
        cell.displayImageWhileSaving(file: file)
        cell.deleteButtonAction = {[unowned self] in
          self.deleteImage(index: indexPath.row)
        }
            return cell
        }else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "tagPostCell", for: indexPath) as! TagPostFeedCollectionViewCell
            cell2.tagName.text = withTagsArray[indexPath.row].first_name!
            cell2.tagName.textColor = withTagsArray[indexPath.row].pointsColor
            cell2.removeTag = {[unowned self] in
                self.removeTag(index: indexPath.row)
            }
            return cell2
        }
    }
}

extension PostFeedViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != mediaCollectionView{
            if  (withTagsArray.count) > indexPath.row {
                let name  = withTagsArray[indexPath.row].first_name
                var clculated_width = ((name?.count)! * 8) + 48
                if (name?.count)! < 4 {
                    clculated_width = 88
                }
                if clculated_width > 298 {
                    return CGSize(width: 298, height: 38)
                }else{
                    if clculated_width < 50 {
                        return CGSize(width: 88, height: 38)
                    }else{
                        return CGSize(width: clculated_width, height: 38)
                    }
                }
            }
            return CGSize(width: 170, height: 38)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mediaCollectionView{
            if array_Attachment[indexPath.row].is_Video{
                let videoURL =  WebServiceName.videos_baseurl.rawValue + self.array_Attachment[indexPath.row].server_URL
                let player = AVPlayer(url:  NSURL(string: videoURL)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
//                CreateGalleryViewer(index: indexPath.item)
            }
        }
    }
 
    func CreateGalleryViewer(index: Int)    {
        for file in array_Attachment
        {
            let poster = file.image_URL
                //videoIconImageView.isHidden = false
            if let url = URL(string: poster)   {
                    guard let video_url = URL(string: file.server_URL)else{return}
                    let  video = Media.init(videoURL: video_url, previewImageURL:url)
                    photos = video
            }
        }
        let browser = MediaBrowser2(delegate: self as MediaBrowser2Delegate)
        browser.setCurrentIndex(at: index)
        browser.enableGrid = false
        browser.feedDataController = feedDataController
        browser.savingPost = photos
        browser.fromSavingPost = true;
        self.navigationController?.pushViewController(browser, animated: false)
    }
}
extension PostFeedViewController : MediaBrowser2Delegate {
    func numberOfMedia(in mediaBrowser: MediaBrowser2) -> Int {
        return 1
    }

    func media(for mediaBrowser: MediaBrowser2, at index: Int) -> Media {
        return photos
    }
}


extension PostFeedViewController    {
    
    @objc func showKeyboard(sender: NSNotification) {
        keyboardDidShow(sender: sender, adjustHeight: 150)
    }
    
    @objc func hideKeyboard(sender: NSNotification) {
       keyboardHeight = 0
       showFeedOptionsList()
    }

    //-------------------
    func keyboardDidShow(sender: NSNotification, adjustHeight: CGFloat) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
                //- (self.tabBarController?.tabBar.frame.height)!
            print("keyboard height is : \(keyboardHeight)")
            hideFeedOptionsList()
        }
    }
    
    
    fileprivate func hideFeedOptionsList()  {
        if self.array_Attachment.count == 0 {
            self.feedOptionListStackView.isHidden = true
            self.feedOptionBarStackView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            print("keyboard height is : \(self?.keyboardHeight)")
            self?.feedOptionBarBottomConstraint.constant = (self?.keyboardHeight)! + 10
            self?.view.layoutIfNeeded()
        }
    }
    
    fileprivate func showFeedOptionsList()  {
        if self.array_Attachment.count == 0{
            self.feedOptionListStackView.isHidden = false
            self.feedOptionBarStackView.isHidden = true
        }

        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.feedOptionBarBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
        
    }
}

extension PostFeedViewController: UITextViewDelegate    {
    func textViewDidChange(_ textView: UITextView) {
        acManager.processString(textView.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Hey Bud, what's on your mind?"   {
            textView.text = ""
        }
        if array_Attachment.count != 0{
        mediaCollectionViewHeightContraint.constant = 50
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.delayWithSeconds(0.03) {
             self.SetAttributedText(mainString: textView.text, attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""   {
            textView.text = "Hey Bud, what's on your mind?"
        }
        self.acContainerView.isHidden = true
        if array_Attachment.count != 0{
        mediaCollectionViewHeightContraint.constant = 200
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 {
             self.updateTriggerData(newText: self.whatsOnYourMindTextView.text)
            
//            self.SetAttributedText(mainString: self.whatsOnYourMindTextView.text.replacingOccurrences(of: "_", with: " "), attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
        }
        if text == " " {
            self.acContainerView.isHidden = true
            self.acContainerView.backgroundColor = UIColor.init(hex: "2F2F2F")
            self.acContainerView.isHidden = true
            self.updateTriggerData(newText: self.whatsOnYourMindTextView.text)
            let mentions = self.matches(regex: "([@#][\\w_-]+)", text: text)
            print("mentions are: \(mentions)")
            if mentions.count > 0 {
                let menstion_str = mentions.last?.replacingOccurrences(of: "_", with: " ")
                self.mention_Array.append(menstion_str!)
            }
            self.SetAttributedText(mainString: self.whatsOnYourMindTextView.text, attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
        }
        if text == "\n"{
            self.acContainerView.isHidden = true
            self.acContainerView.backgroundColor = UIColor.init(hex: "2F2F2F")
            self.updateTriggerData(newText: self.whatsOnYourMindTextView.text)
            let mentions = self.matches(regex: "([@#][\\w_-]+)", text: text)
            print("mentions are: \(mentions)")
            if mentions.count > 0 {
                let menstion_str = mentions.last?.replacingOccurrences(of: "_", with: " ")
                self.mention_Array.append(menstion_str!)
            }
            self.SetAttributedText(mainString: self.whatsOnYourMindTextView.text, attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
        }
//        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
//        
//        if text.rangeOfCharacter(from: characterset.inverted) != nil {
//            if text == "#" || text == "@" {
//                
//            }else {
//                self.acContainerView.isHidden = true
//                self.acContainerView.backgroundColor = UIColor.init(hex: "2F2F2F")
//                self.updateTriggerData(newText: self.whatsOnYourMindTextView.text)
//                let mentions = self.matches(regex: "([@#][\\w_-]+)", text: text)
//                print("mentions are: \(mentions)")
//                if mentions.count > 0 {
//                    let menstion_str = mentions.last?.replacingOccurrences(of: "_", with: " ")
//                    self.mention_Array.append(menstion_str!)
//                }
//                self.SetAttributedText(mainString: self.whatsOnYourMindTextView.text, attributedStringsArray: self.mention_Array, view: self.whatsOnYourMindTextView, color: UIColor.init(hex: "7CC244"))
//            }
//        }
        
        return true
    }
}

extension PostFeedViewController    {
    
    @IBAction func cancelButtonTapped() {
//        if txtUrl != nil && (txtUrl?.count)! > 0 {
////            exit(0)
//            self.navigationController?.popViewController(animated: true)
//        }else {
//            self.dismiss(animated: false, completion: nil)
//        }
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func displayUserProfile()    {
        
        let user = DataManager.sharedInstance.user
        
        userNameLabel.text = user?.userFirstName
        SubUserLabel.text = user?.userFirstName
        pointsLabel.text = user?.Points
        budLabel.text = user?.budType
        whatsOnYourMindTextView.text = "Hey Bud, what's on your mind?"
        
        
        let pointsColor = user?.pointsColor
        userNameLabel.textColor = pointsColor
        pointsLabel.textColor = pointsColor
        pointsBudzSeperator.backgroundColor = pointsColor
        budLabel.textColor = pointsColor
        
        budIconImageView.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        budIconImageView.tintColor = pointsColor
        
       profilePictureImageView.setUserProfilesImage()
        
        if (user?.special_icon.characters.count)! > 6 {
            profilePictureImageViewTop.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (user?.special_icon.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            profilePictureImageViewTop.af_setImage(withURL: linked)
        }else {
            profilePictureImageViewTop.isHidden = true
        }
        
    }
}
// MARK: - Private Constants
fileprivate struct CellIdentier {
    static let postImage = "PostImageCollectionViewCell"
}
var postSaveParams =  (
    description:  "",
    images: "",
    video: "",
    thumb: "",
    ratio: "",
    poster: "",
    tagged: "",
    json_data: "",
    posting_user: "",
    repost_to_wall: 1
)


