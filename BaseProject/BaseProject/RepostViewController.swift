//
//  RepostViewController.swift
//  BaseProject
//
//  Created by MN on 13/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class RepostViewController: BaseViewController , UITextViewDelegate{

    @IBOutlet weak var whats_on_your_mind: UITextView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var mediaCollectionViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var mediaCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profilePictureImageViewTop: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var budLabel: UILabel!
    @IBOutlet weak var pointsBudzSeperator: UIView!
    @IBOutlet weak var budIconImageView: UIImageView!
    @IBOutlet weak var savePost: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var moreTagButton:UIButton!
    @IBOutlet weak var moreTagButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var postAsConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tagView:UIView!
    var letMoretags = false
    var feedDataController: FeedDataController!
    var followedUsers = [PostUser]()
    var withTagsArray = [PostUser]()
    var editTagList = [PostUser]()
    var ifsubusers = false

    var SubUsers = [PostSubUser]()
    @IBOutlet weak var SubUserView:UIView!
    @IBOutlet weak var SubUserTableView:UITableView!
    @IBOutlet weak var SubUserLabel:UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var SubUserID: NSNumber! = 0
    var array_Attachment = [Attachment]()
    var post: Post!
    @IBOutlet weak var postAsLabel: UILabel!
    @IBOutlet weak var postAsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUserProfile()
        self.whats_on_your_mind.delegate = self
        let mediaPostCellNib = UINib(nibName: CellIdentier.postImage, bundle: nil)
        self.mediaCollectionView.register(mediaPostCellNib, forCellWithReuseIdentifier: CellIdentier.postImage)
        SubUserTableView.estimatedRowHeight = 20
        SubUserTableView.rowHeight = UITableViewAutomaticDimension
        SubUserTableView.separatorStyle = .none
        SubUserView.isHidden = true
        tagView.isHidden = true
        mediaCollectionViewHeightContraint.constant =  post.files?.count != 0 ? 200 : 0
        pageControl.numberOfPages = (post.files?.count)!
        mediaCollectionViewLayout.minimumLineSpacing = 0
        mediaCollectionViewLayout.minimumInteritemSpacing = 0
        configureCollectionViewLayoutItemSize()
        self.postAsView.isHidden = true
        self.postAsLabel.isHidden = true
        
        getSubUsers()
        repostMedia()
        getFollowers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.whats_on_your_mind.text == "What's on your mind?"{
            self.whats_on_your_mind.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.whats_on_your_mind.text.isEmpty{
            self.whats_on_your_mind.text = "What's on your mind?"
        }
    }
    func displayUserProfile()    {
        
        let user = DataManager.sharedInstance.user
        
        userNameLabel.text = user?.userFirstName
        SubUserLabel.text = user?.userFirstName
        pointsLabel.text = user?.Points
        budLabel.text = user?.budType
        
        
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
    
    private func configureCollectionViewLayoutItemSize()    {
        mediaCollectionView.invalidateIntrinsicContentSize()
        
        mediaCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mediaCollectionViewLayout.itemSize = mediaCollectionView!.frame.size
        print(mediaCollectionViewLayout.itemSize)
        
        
        //        mediaCollectionViewLayout.collectionView!.reloadData()
        
    }
    
    
    func showMediaInCollectionView()   {
        self.mediaCollectionViewHeightContraint.constant =  200
        self.pageControl.numberOfPages = self.array_Attachment.count
        self.configureCollectionViewLayoutItemSize()
        
        mediaCollectionView.reloadData()
        mediaCollectionView.layoutIfNeeded()
    }
    @IBAction func moreTagButttonAction(sender: UIButton!){
        self.letMoretags = true
        self.moreTagButtonWidth.constant = 0
        tagCollectionView.reloadData()
    }
    
    @IBAction func tagAction(sender: UIButton!){
        let tagNav = self.GetView(nameViewController: "TagsViewController", nameStoryBoard: "Wall") as! TagsViewController
        tagNav.repostDelegate = self
        editTagList = self.followedUsers
        if withTagsArray.count != 0{
            for tag in withTagsArray{
                self.editTagList.remove(at: self.editTagList.index(where: { $0.first_name == tag.first_name })!)
            }
            tagNav.tags = editTagList
            tagNav.selectedTags = withTagsArray
        }else{
            tagNav.tags = self.followedUsers
        }
        self.present(tagNav, animated: true, completion: nil)
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
                    
                    for user in data!  {
                        let follow = PostUser(JSON: user)
                        self?.followedUsers.append(follow!)
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

    
    @IBAction func postAsViewToggle(sender: UIButton!){
        if ifsubusers{
            SubUserView.isHidden = !SubUserView.isHidden
        }
    }
    @IBAction func dissmissActivity(sender: UIButton!){
        self.dismiss(animated: true, completion: nil)
    }
    func getSubUsers(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI:WebServiceName.get_sub_users.rawValue) { [unowned self] (apiSucceed, message, responseData) in
            print(responseData)
            self.hideLoading()
            
            
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
                    if self.SubUsers.count > 0{
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
    }
    
    func removeTag(index: Int!){
        self.withTagsArray.remove(at: index)
        if self.withTagsArray.count == 0{
            tagView.isHidden = true
        }
        self.tagCollectionView.reloadData()
    }
    
    func repostMedia(){
        if post.files?.count != 0{
            if let fileLength = post.files?.count{
                for i in  0..<fileLength {
                    var attach = Attachment()
                    attach.server_URL = post.files![i].file!
                    if post.files![i].type! == "video"{
                        attach.is_Video = true
                        attach.image_URL = post.files![i].poster!
                    }
                    
                    array_Attachment.append(attach)
                }
            }
            self.mediaCollectionViewHeightContraint.constant =  200
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.showMediaInCollectionView()
            }
        }
        self.descriptionLabel.text = post.discription!
    }
    @IBAction func savePostAction(sender: UIButton!){
        var postingUser: String!
        if SubUserID != 0{
            postingUser = "s_" + String(describing: SubUserID!)
        }else{
            postingUser = ""
        }
        var tagged = ""
        if withTagsArray.count != 0{
            for tag in withTagsArray{
                if tagged == ""{
                   tagged = String((tag.id?.intValue)!)
                }else{
                   tagged = tagged + "," + String((tag.id?.intValue)!)
                }
            }
        }
        let postID = String(describing: post.id!)
            self.showLoading()
            var mainParam: [String : AnyObject]
        mainParam = ["post_id": postID as AnyObject, "posting_user": postingUser as AnyObject, "tagged_users": tagged as AnyObject]
        if self.whats_on_your_mind.text != "What's on your mind?" && self.whats_on_your_mind.text.isEmpty == false{
             mainParam["post_added_comment"] = self.whats_on_your_mind.text as AnyObject
        }
       
            print(mainParam)
            NetworkManager.PostCall(UrlAPI:WebServiceName.repost.rawValue, params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
                print(responseData)
                self.hideLoading();
                if apiSucceed   {
                    let status = responseData["status"] as! String
                    if status == "success"  {
                        self.feedDataController.shouldFetchLatestPosts = true
                        self.oneBtnCustomeAlert(title: "", discription:   "Post added successfully") { (isComp, btn) in
                            self.dismiss(animated: true)
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
    }
    

}
extension RepostViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(SubUsers.count)
        return SubUsers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SubUserTableView.dequeueReusableCell(withIdentifier: "SubUserCellRepost", for: indexPath) as! PostAsTableViewCell
        if indexPath.row == 0{
            cell.subUserTitle.text = userNameLabel.text!
        }else{
            cell.subUserTitle.text = SubUsers[indexPath.row - 1 ].title ?? ""
        } 
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}

extension RepostViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
            SubUserLabel.text = SubUsers[indexPath.row].title!
            SubUserID = SubUsers[indexPath.row].id!;
        }else{
            SubUserLabel.text = userNameLabel.text!
            SubUserID = 0
        }
        self.SubUserView.isHidden = true
        print(SubUserID)
    }
}

//Mark: - Collection View

extension RepostViewController: UICollectionViewDataSource {
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
        return cell
        }else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "tagrePostCell", for: indexPath) as! TagPostFeedCollectionViewCell
            cell2.tagName.text = withTagsArray[indexPath.row].first_name!
            cell2.tagName.textColor = withTagsArray[indexPath.row].pointsColor
            cell2.removeTag = {[unowned self] in
                self.removeTag(index: indexPath.row)
            }
            return cell2
        }
    }
}

extension RepostViewController: UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mediaCollectionView{
          pageControl.currentPage = indexPath.item
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != mediaCollectionView{
            if  (withTagsArray.count) > indexPath.row {
                let name  = withTagsArray[indexPath.row].first_name
                var clculated_width = ((name?.count)! * 8) + 48
                if (name?.count)! < 4 {
                    clculated_width = 88
                }
                if clculated_width > 298{
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
    
}


fileprivate struct CellIdentier {
    static let postImage = "PostImageCollectionViewCell"
}

