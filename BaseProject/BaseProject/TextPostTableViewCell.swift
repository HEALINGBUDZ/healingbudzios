//
//  TextPostTableViewCell.swift
//  BaseProject
//
//  Created by MAC MINI on 27/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import SwiftyJSON
import AVKit
import AlamofireImage
import SwiftLinkPreview
import GrowingTextView
import MJAutoComplete

class TextPostTableViewCell: UITableViewCell, CameraDelegate, UITextViewDelegate {
    var index:Int!
    var isDetailScreen : Bool = false
    var feedDataController: FeedDataController!
    var loadMoreTags = false
    var baseVC : BaseViewController?
    @IBOutlet weak var btnDiscuss: CornerWithgrayRoundButton!
    
    @IBOutlet weak var repost_view_lline: UIView!
    @IBOutlet weak var repost_new_textlbl: UILabel!
    @IBOutlet weak var repost_new_view_contnt: NSLayoutConstraint!
    
    
    @IBOutlet weak var shadeView: UIView!
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let whiteColor = UIColor.darkGray.withAlphaComponent(0.1)
        let blackColor = UIColor.black.withAlphaComponent(0.3)
        layer.colors = [whiteColor.cgColor, blackColor.cgColor]
        return layer
    }()
    var followed_user_model = [PostUser]()
    var updated_followed_user_model = [PostUser]()
    var updated_tags = [PostTags]()
    var vc = UIViewController()
    var acManager = MJAutoCompleteManager()
    var mentionItems = [MJAutoCompleteItem]()
    var tagItems = [MJAutoCompleteItem]()
    @IBOutlet weak var acContainerView: UIView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageTop: UIImageView!
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var galley_icon: UIImageView!
    @IBOutlet weak var btnUrlOpenScrap: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ActiveLabel!
    @IBOutlet weak var pointsBudzSeperator: UIView!
    @IBOutlet weak var budLabel: UILabel!
    @IBOutlet weak var budIconImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var likedByButton: UIButton!
    var mention_Array = [String]()
    public var result = SwiftLinkPreview.Response()
    public var slp = SwiftLinkPreview(cache: InMemoryCache())
    @IBOutlet weak var repostDetailView: UIView!
    @IBOutlet weak var repostDetailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var shadowViewCons: NSLayoutConstraint!
    @IBOutlet weak var repostedUserButton: UIButton!
    var fromFeedDetail = false
    @IBOutlet weak var postedAsDetailView: UIView!
    @IBOutlet weak var postedAsDetailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var postedAsUserButton: UIButton!
    var userWallVC: UserWallViewController!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likesCountButton:UIButton!
    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var repostsButton: UIButton!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var MediacollectionView: UICollectionView!
    @IBOutlet weak var mediaCollectionViewHighttContraint: NSLayoutConstraint!
    @IBOutlet weak var MediacollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var tagViewHieght: NSLayoutConstraint!
    @IBOutlet weak var tagCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var urlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var moreButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var scrapView: UIView!
    @IBOutlet weak var urlViewImage: UIImageView!
    @IBOutlet weak var urlViewTitle: UILabel!
    @IBOutlet weak var urlViewDesc: UILabel!
    @IBOutlet weak var scrapSource: UILabel!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var commentTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentInputView: UIView!
    @IBOutlet weak var btnRemoveMedia: UIButton!
    @IBOutlet weak var mediaViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var btnCommentedImageOrPoster: UIButton!
    @IBOutlet weak var txtcomment: GrowingTextView!
    
    var attacmentUrl = ""
    var posterImageUrl = ""
    var newAttachment = Attachment()
    
    var heightCalc = 0.0
    func displayLikes()    {
        if let likesCount = post.likes_count?.intValue  {
            likesCountButton.setTitle(" \(likesCount) Like\(likesCount != 1 ? "s" : "s")", for: .normal)
            if !fromFeedDetail{
            likesButton.setTitle(" Like\(likesCount != 1 ? "s" : "s") \(likesCount)", for: .normal)
            likesButton.isSelected = post.isLiked
                if post.isLiked{
                    likesButton.setTitleColor(UIColor.init(hex: "7cc244"), for: .normal)
                    likesButton.backgroundColor = UIColor.clear
                }else{
                    likesButton.setTitleColor(UIColor.init(hex: "b1b1b1"), for: .normal)
                    likesButton.backgroundColor = UIColor.clear
                }
            likesButton.setTitleColor(UIColor.init(hex: "7cc244"), for: .selected)
            likesButton.setTitle(" Like\(likesCount != 1 ? "s" : "s") \(likesCount)", for: .selected)
            }else{
                likesButton.isSelected = post.isLiked
                likesButton.setTitle(" Like\(likesCount != 1 ? "s" : "s") \(likesCount)", for: .normal)
                likesButton.setTitle(" Like\(likesCount != 1 ? "s" : "s") \(likesCount)", for: .selected)
                likesButton.setTitleColor(UIColor.init(hex: "7cc244"), for: .selected)
            }
        }
    }
    
    func increaseLikes()    {
        if  let likesCount =  post.likes_count?.intValue{
            post.liked_count = NSNumber(value: true)
            post.likes_count = NSNumber(value: likesCount + 1)
            displayLikes()
        }
    }
    
    func decreaseLikes()    {
        let likesCount = NSNumber(value: post.likes_count!.intValue - 1)
        post.liked_count = NSNumber(value: false)
        post.likes_count = likesCount
        displayLikes()
    }
    
    func increaseRepost()    {
        
        let  repostCount = post.shared_count!.intValue+1
        repostsButton.setTitle(" Reposts \(repostCount)", for: .normal)
        post.shared_count = NSNumber(integerLiteral: repostCount)
    }
    
    func decreaseRepost()    {
        let  repostCount = post.shared_count!.intValue-1
        repostsButton.setTitle(" Reposts \(repostCount)", for: .normal)
    }
    
    
    var post: Post!
    var tagList: Post!
    var postedAsUserButtonAction: ((BudzMap) -> Void)?
    var profileButtonAction: ((String) -> Void)?
    var menuButtonAction: ((UIButton) -> Void)?
    var likesButtonAction: (() -> Void)?
    var commentsButtonAction: (() -> Void)?
    var repostsButtonAction: (() -> Void)?
    var LikedByAction: (() -> Void)?
    var repostAction: (() -> Void)?
    var urlBtnAtion: (() -> Void)?
    var urlBtnDiss: (() -> Void)?
    var feedDetailAction: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagView.isHidden = true
        tagViewHieght.constant = 0
        descriptionLabel.mentionColor = UIColor(hex: "7cc244")
        descriptionLabel.hashtagColor = UIColor(hex: "7cc244")
        descriptionLabel.URLColor     = UIColor(hex: "808080")
        
        /* descriptionLabel.handleMentionTap { (mentions) in
         print(self.post.json_data ?? "te")
         if self.post.json_data == nil{
         return
         }
         let jsonObj = JSON.init(parseJSON: self.post.json_data!)
         if let json_data_array = jsonObj.array{
         for data in json_data_array{
         print(data.dictionaryValue)
         let dic = data.dictionaryValue
         let user_name  = dic["value"]?.stringValue
         let user_id  =  dic["id"]?.intValue
         let trigger = dic["trigger"]?.stringValue
         let type = dic["type"]?.stringValue
         if trigger! == "@"{
         if user_name!.contains(mentions.replacingOccurrences(of: "_", with: " ")){
         if self.baseVC != nil {
         if type == "budz"{
         self.baseVC?.openBudzMap(id: "\(user_id ?? 0)")
         }else{
         self.baseVC?.OpenProfileVC(id: "\(user_id ?? 0)")
         }
         }
         break
         }
         }
         
         }
         }
         
         }
         descriptionLabel.handleHashtagTap { (tags) in
         if self.baseVC != nil {
         print(self.post.json_data ?? "te")
         if self.post.json_data == nil{
         return
         }
         let jsonObj = JSON.init(parseJSON: self.post.json_data!)
         if let json_data_array = jsonObj.array{
         for data in json_data_array{
         print(data.dictionaryValue)
         let dic = data.dictionaryValue
         let tag  = dic["value"]?.stringValue
         let trigger = dic["trigger"]?.stringValue
         if trigger! == "#"{
         if tag!.contains(tags){
         if self.baseVC != nil {
         self.baseVC?.ShowKeywordPopUp(value: tags)
         }
         break
         }
         }
         }
         }
         
         }
         }
         descriptionLabel.handleURLTap({ url in
         var urlToCall = url
         if !url.absoluteString.hasPrefix("http"){
         urlToCall = URL(string: "http://" + url.absoluteString)!
         }
         UIApplication.shared.open(urlToCall)
         }) */
        
        let postTagCellNib = UINib(nibName: "TagPostFeedCollectionViewCell", bundle: nil)
        tagCollectionView!.register(postTagCellNib, forCellWithReuseIdentifier: "tagPost")
        
    }
    
    override func layoutSubviews() {
        if !fromFeedDetail{
        self.commentTableView.register(UINib(nibName: "CommentCellWall", bundle: nil), forCellReuseIdentifier: "CommentCellWall")
        
            
                if PostFeedViewController.followedUsers.count > 0 {
                    if PostFeedViewController.tags.count > 0 {
                        self.configureTagTextView()
                    }else{
                        self.getTags()
                    }
                }else{
                    self.getFollowers()
                }
            commentTableView.isScrollEnabled = false
            commentTableView.separatorStyle = .none
            commentTableView.showsHorizontalScrollIndicator = false
            commentTableView.showsVerticalScrollIndicator = false
        }
    }
    
    override func prepareForReuse() {
        likesButton.isSelected = false
        repostDetailView.isHidden = true
        repostDetailHeightContraint.constant = 0
        postedAsDetailView.isHidden = true
        postedAsDetailHeightContraint.constant = 0
    }
    func setTag(post: Post){
        self.tagList = post
        if tagList.tagged?.count != 0{
            tagView.isHidden = false
            tagViewHieght.constant = 40
            if (tagList.tagged?.count)! > 3{
                moreButton.setTitle(String((tagList.tagged?.count)! - 3) + "more", for: .normal)
                moreButtonWidth.constant = 0
            }else{
                moreButtonWidth.constant = 0
            }
        }else{
            tagView.isHidden = true
            tagViewHieght.constant = 0
        }
        
        moreButtonWidth.constant = 0
        //        tagCollectionViewWidth.constant = UIScreen.main.bounds.width - 60
        loadMoreTags = true
    }
    func display(post: Post,parentVC: UIViewController!)    {
        self.post = post
        
        
        if parentVC.isKind(of: UserWallViewController.self){
            vc = parentVC as! UserWallViewController
        }else if parentVC.isKind(of: FeedDetailViewController.self){
            vc = parentVC as! FeedDetailViewController
        }else if parentVC.isKind(of: UserProfileViewController.self){
            vc = parentVC as! UserProfileViewController
        }else if parentVC.isKind(of: MyWallViewController.self){
            vc = parentVC as! MyWallViewController
        }
        if !fromFeedDetail{
        if post.newAttachment?.ID != "-1"{
            mediaViewHeightConstaint.constant = 0
            btnRemoveMedia.isHidden = true
            btnCommentedImageOrPoster.isHidden = true
        }else{
            mediaViewHeightConstaint.constant = 90
            self.btnRemoveMedia.isHidden=false
            btnCommentedImageOrPoster.isHidden = false
            self.btnCommentedImageOrPoster.setBackgroundImage(post.newAttachment?.image_Attachment, for: .normal)
            if (post.newAttachment?.is_Video)!{
             self.btnCommentedImageOrPoster.setImage(#imageLiteral(resourceName: "VideoOverlay"), for: .normal)
            }else{
            self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
            }
        }
        }

        if post.postType == .text{
            print(post.scrapind_data)
            if post.scrapind_data != nil {
                if self.urlViewTitle == nil{
                    
                }else{
                    self.activityIndicate.stopAnimating()
                    self.activityIndicate.isHidden = true
                    urlViewHeight.constant = 230
                    scrapView.isHidden  = false
                    if let url = post.scrapind_data!["image"] as? String{
                        self.urlViewImage.sd_setImage(with: URL(string: url), completed: { (image, error, chache, url) in
                            self.urlViewImage.image = image
                        })
                    }else{
                        self.urlViewImage.image = #imageLiteral(resourceName: "placeholder")
                    }
                    if let title = post.scrapind_data!["title"] as? String{
                         self.urlViewTitle.text = title
                    }else{
                         self.urlViewTitle.text = "scrap.title"
                    }
                    
                    if let content = post.scrapind_data!["content"] as? String{
                        let upContent = content.replacingOccurrences(of: "&nbsp;", with: "").trimmingCharacters(in: .whitespaces)
                        self.urlViewDesc.text = upContent
                        
                    }else{
                        self.urlViewDesc.text = "content"
                    }
                   
                    if let url = post.scrapind_data!["url"] as? String{
                        self.scrapSource.text = url
                    }else{
                        self.scrapSource.text = "url"
                    }
                    
                    let stt =  Constants.ShareLinkConstant + "get-question-answers/"
                    let sttt =  "http://139.162.37.73/healingbudz/get-question-answers/"
                    if let url = self.slp.extractURL(text: post.discription!){
                        urlBtnDiss = { [unowned self] menuButton in
                            if (url.absoluteString.contains(stt)){
                                let DetailQuestionVc = self.baseVC?.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                                DetailQuestionVc.QuestionID = (url.absoluteString.replacingOccurrences(of: stt, with: ""))
                                self.vc.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                            }else if (url.absoluteString.contains(sttt)){
                                let DetailQuestionVc = self.baseVC?.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                                DetailQuestionVc.QuestionID = (url.absoluteString.replacingOccurrences(of: sttt, with: ""))
                                self.vc.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                            }
                        }
                    }
                }
            }else{
                urlViewHeight.constant = 0
                scrapView.isHidden  = true
            }
               
        }
        
        
        if !fromFeedDetail{
            commentTableView.reloadData()
        }
        if self.post.json_data == nil{
            descriptionLabel.mentionColor = UIColor(hex: "FFFFFF")
            descriptionLabel.hashtagColor = UIColor(hex: "FFFFFF")
        }else{
            descriptionLabel.mentionColor = UIColor(hex: "7cc244")
            descriptionLabel.hashtagColor = UIColor(hex: "7cc244")
        }
        
        if post.tagged?.count != 0{
            tagView.isHidden = false
        }
        
        let isReposted = post.isReposted
        if  isReposted {
            repostDetailView.isHidden = false
            repostDetailHeightContraint.constant = 20
            repostedUserButton.setTitle(post.shared_user?.first_name, for: .normal)
            repostedUserButton.setTitleColor(post.shared_user?.pointsColor, for: .normal)
            repost_new_textlbl.text = post.repostDiscp
            repost_new_textlbl.isHidden = false
            repost_view_lline.isHidden = false
            repost_new_view_contnt.constant = 8
        } else {
            repostDetailView.isHidden = true
            repostDetailHeightContraint.constant = 0
            repost_view_lline.isHidden = true
            repost_new_textlbl.text = ""
            repost_new_textlbl.isHidden = true
            repost_new_view_contnt.constant = -20
        }
        
        let isPostedAs = post.isPostedAs
        if isPostedAs {
            postedAsDetailView.isHidden = false
            postedAsDetailHeightContraint.constant = 20
            postedAsUserButton.setTitle(post.sub_user?.title, for: .normal)
        }
        else {
            postedAsDetailView.isHidden = true
            postedAsDetailHeightContraint.constant = 0
        }
        
        
        let desc = post.discription?.html2String
        var mention_array = [String]()
        if self.post.json_data != nil{
            let jsonObj = JSON.init(parseJSON: self.post.json_data!)
            if let json_data_array = jsonObj.array{
                print(jsonObj.rawValue)
                _  = [[String : Any]]()
                var index = 0
                for data in json_data_array{
                    print(data.dictionaryValue)
                    let dic = data.dictionaryValue
                    let user_name  = dic["value"]?.stringValue
                    let trigger = dic["trigger"]?.stringValue
                    let triger_word = trigger!+user_name!
                    mention_array.append(triger_word.replaceHash())
                    index = index + 1
                }
            }
        }
        
        print(desc ?? "sdf")
        mention_array.append(Constants.SeeMore)
        descriptionLabel.createMentions(array: mention_array, color: UIColor.init(hex: "7cc244")) { (clicked_word) in
            print(clicked_word)
            if clicked_word == Constants.SeeMore {
                print("detail")
                self.feedDetailAction?(self.index)
                return
            }
            print(self.post.json_data ?? "te")
            if self.post.json_data == nil{
                //                for main_keyword in AppDelegate.appDelegate().keywords{
                //                    if main_keyword.lowercased() == clicked_word.lowercased(){
                //                        if self.baseVC != nil {
                //                            self.baseVC?.ShowKeywordPopUp(value: clicked_word)
                //                            return
                //                        }
                //
                //                        return
                //                    }
                //                }
                return
            }
            let jsonObj = JSON.init(parseJSON: self.post.json_data!)
            if let json_data_array = jsonObj.array{
                for data in json_data_array{
                    print(data.dictionaryValue)
                    let dic = data.dictionaryValue
                    let user_name  = dic["value"]?.stringValue
                    let user_id  =  dic["id"]?.intValue
                    let trigger = dic["trigger"]?.stringValue
                    let type = dic["type"]?.stringValue
                    if trigger! == "@"{
                        if user_name!.lowercased().contains(clicked_word.lowercased().replacingOccurrences(of: "@", with: "")){
                            if self.baseVC != nil {
                                if type == "budz"{
                                    self.baseVC?.openBudzMap(id: "\(user_id ?? 0)")
                                }else{
                                    self.baseVC?.OpenProfileVC(id: "\(user_id ?? 0)")
                                }
                            }
                            break
                        }
                    }else if trigger! == "#"{
                        if (user_name?.lowercased().contains(clicked_word.lowercased().replacingOccurrences(of: "#", with: "")))!{
                            if self.baseVC != nil {
                                self.baseVC?.ShowKeywordPopUp(value: clicked_word.replacingOccurrences(of: "#", with: ""))
                            }
                            break
                        }
                    }
                }
            }
            //            for main_keyword in AppDelegate.appDelegate().keywords{
            //                if main_keyword.lowercased() == clicked_word.lowercased(){
            //                    if self.baseVC != nil {
            //                        self.baseVC?.ShowKeywordPopUp(value: clicked_word)
            //                        return
            //                    }
            //
            //                    return
            //                }
            //            }
        }
        
        if (desc?.count)! > 200 {
            if isDetailScreen {
                descriptionLabel.text = desc
            }else{
                descriptionLabel.text = String(desc!.prefix(200)) + Constants.SeeMore
            }  
        }else{
            descriptionLabel.text = desc
        }
        
        profileNameButton.setTitle(post.user?.first_name, for: .normal)
        pointsLabel.text = post.user?.pointsValue
        budLabel.text = post.user?.budType
        
        displayLikes()
        
        let commentsCount = post.comments_count!.intValue
        commentsCountButton.setTitle(" \(commentsCount) Comments", for: .normal)
        commentsButton.setTitle(" Comments \(commentsCount)", for: .normal)
        
        if let allowRepost = post.allow_repost, allowRepost.boolValue {
            repostsButton.isHidden = false
            let repostCount = post.shared_count!.intValue
            repostsButton.setTitle(" Reposts \(repostCount)", for: .normal)
        } else {
            repostsButton.isHidden = true
        }
        
        let pointsColor = post.user?.pointsColor
        profileNameButton.setTitleColor(pointsColor, for: .normal)
        pointsLabel.textColor = pointsColor
        pointsBudzSeperator.backgroundColor = pointsColor
        budLabel.textColor = pointsColor
        
        budIconImageView.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        budIconImageView.tintColor = pointsColor
        if profileImageTop != nil {
            profileImageTop.isHidden = false
        }
        if (post.user?.special_icon?.count)! > 6 {
            profileImageTop.isHidden = false
            let linked = URL(string: WebServiceName.images_baseurl.rawValue + (post.user?.special_icon?.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            profileImageTop.af_setImage(withURL: linked)
        }else {
            profileImageTop.isHidden = true
        }
        profileImageButton.setImage(#imageLiteral(resourceName: "ic_discuss_question_profile"), for: .normal)
        if let profilePicUrlString = post.user?.profilePictureURL {
            if let url = URL(string: profilePicUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                profileImageButton.sd_setImage(with: url, for: .normal,placeholderImage : #imageLiteral(resourceName: "ic_discuss_question_profile") ,completed: nil)
            }else {
                profileImageButton.setImage( #imageLiteral(resourceName: "ic_discuss_question_profile"), for: .normal)
            }
        } else {
            profileImageButton.setImage(#imageLiteral(resourceName: "ic_discuss_question_profile"), for: .normal
            )
        }
        
        if post.files == nil {
            if self.galley_icon != nil {
                self.galley_icon.isHidden = true
            }
        }else{
            if (post.files?.count)! > 1 {
                if self.galley_icon != nil {
                    self.galley_icon.isHidden = false
                }
            }else{
                if self.galley_icon != nil {
                    self.galley_icon.isHidden = true
                }
            }
        }
        
        
        if let ratio = post.files?.first?.image_ratio {
            if ratio < 1.0 {
                let width = self.MediacollectionView.frame.width
                let newHight  = width / CGFloat(ratio)
                if self.mediaCollectionViewHighttContraint != nil {
                    if newHight > 400{
                        self.mediaCollectionViewHighttContraint.constant = 400
                        self.setShadow(vale: 400)
                    }else{
                        if newHight > 180 {
                            self.mediaCollectionViewHighttContraint.constant = newHight
                        }else{
                            self.mediaCollectionViewHighttContraint.constant = 350
                        }
                    }
                }
            }else{
                if self.mediaCollectionViewHighttContraint != nil {
                    self.mediaCollectionViewHighttContraint.constant = 350
                    self.setShadow(vale: 350)
                }
            }
        }else{
            if self.mediaCollectionViewHighttContraint != nil {
                self.mediaCollectionViewHighttContraint.constant = 350
                self.setShadow(vale: 350)
            }
        }
    }
    func setShadow(vale: CGFloat){
        if self.shadowViewCons != nil {
            self.shadowViewCons.constant = vale
        }
    }
    fileprivate func showPlaceholder()  {
        txtcomment.textColor = .white
        txtcomment.text = "Your Comment…"

        
    }
    
    fileprivate func hidePlaceholder()  {
        txtcomment.text = ""
        txtcomment.textColor = .white
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
                            self?.baseVC?.ShowLogoutAlert()
                        }
                        else {
                            self?.baseVC?.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        self?.baseVC?.ShowErrorAlert(message:"Try again later!")
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
                            self?.baseVC?.ShowLogoutAlert()
                        }
                        else {
                            self?.baseVC?.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        self?.baseVC?.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
            } // api Succeed
        } // netowrk call
    }
    
    
    @IBAction func removeMedia(_ sender: Any)
    {
        self.contentView.layoutIfNeeded()
        resetCommentBar()
    }
    func resetCommentBar()
    {
        self.attacmentUrl = ""
        self.posterImageUrl = ""
        self.btnRemoveMedia.isHidden = true
        self.btnCommentedImageOrPoster.isHidden = false
        self.post.newAttachment = Attachment()
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        self.btnCommentedImageOrPoster.setBackgroundImage(UIImage(named:""), for: .normal)
        self.mediaViewHeightConstaint.constant=0
        self.btnRemoveMedia.isHidden=true
    }
    
    @IBAction func commentImage(sender: UIButton!){
        let vcCamera = baseVC?.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        if vc != nil{
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
            if self.vc.isKind(of: UserProfileViewController.self){
                isfromYoutubePlayer = true
            }else if self.vc.isKind(of: MyWallViewController.self){
                isfromYoutubePlayer = true
            }
        vc.navigationController?.pushViewController(vcCamera, animated: true)
        }
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 90
        self.btnRemoveMedia.isHidden=false
        self.btnCommentedImageOrPoster.isHidden = false
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        post.newAttachment = newAttachment
        //        var i = feedDataController.postList.index(where: {$0.id == post.id})
        //        feedDataController.postList[i!] = post
        //        feedDataController.postList[i!].scrapedData = post.scrapedData
        newAttachment = Attachment()
        self.UploadFiles(imageMain: image, index: 0,gif_url: gifURL)
    }
    func captured(image: UIImage) {
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 90
        self.btnRemoveMedia.isHidden=false
        self.btnCommentedImageOrPoster.isHidden = false
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(UIImage(named:""), for: .normal)
        post.newAttachment = newAttachment
//        var i = feedDataController.postList.index(where: {$0.id == post.id})
//        feedDataController.postList[i!] = post
//        feedDataController.postList[i!].scrapedData = post.scrapedData
        newAttachment = Attachment()
        self.UploadFiles(imageMain: image, index: 0)
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        self.btnCommentedImageOrPoster.setBackgroundImage(image, for: .normal)
        self.btnCommentedImageOrPoster.setImage(#imageLiteral(resourceName: "VideoOverlay"), for: .normal)
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        mediaViewHeightConstaint.constant = 90
        self.btnRemoveMedia.isHidden=false
        self.btnCommentedImageOrPoster.isHidden = false
        post.newAttachment = newAttachment
//        var i = feedDataController.postList.index(where: {$0.id == post.id})
//        feedDataController.postList[i!] = post
//        feedDataController.postList[i!].scrapedData = post.scrapedData
        newAttachment = Attachment()
        self.UploadVideoFiles(videoUrl: videoURL)
//        userWallVC.tableView.reloadData()
    }
    
    func UploadFiles(imageMain : UIImage, index: Int,gif_url:URL? = nil){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_post_image.rawValue, image: imageMain,gif_url:gif_url, onView: vc) { (MainResponse) in
            
            print(MainResponse)
            self.hideLoading()
            
            if MainResponse != nil {
                let url = MainResponse["file"] as! String
                self.attacmentUrl = url
                self.posterImageUrl = ""
                self.post.imageU = url
                var i = self.feedDataController.postList.index(where: {$0.id == self.post.id})
                self.feedDataController.postList[i!] = self.post
                self.feedDataController.postList[i!].newAttachment = self.post.newAttachment
                self.feedDataController.postList[i!].scrapedData = self.post.scrapedData
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
                    if (self?.vc.isKind(of: UserWallViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! UserWallViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! UserWallViewController).tableView)
                        (self?.vc as! UserWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! UserWallViewController).tableView.isHidden = false
                    }else if (self?.vc.isKind(of: FeedDetailViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! FeedDetailViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! FeedDetailViewController).tableView)
                        (self?.vc as! FeedDetailViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! FeedDetailViewController).tableView.isHidden = false
                    }else if (self?.vc.isKind(of: UserProfileViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! UserProfileViewController).tbleViewMain)
                        (self?.vc as! UserProfileViewController).tbleViewMain.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = false
                    }else if (self?.vc.isKind(of: MyWallViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! MyWallViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! MyWallViewController).tableView)
                        (self?.vc as! MyWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! MyWallViewController).tableView.isHidden = false
                    }
                }
                
                //                }
            }else {
                self.baseVC?.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    
    func UploadVideoFiles(videoUrl : URL){
        self.showLoading()
        NetworkManager.UploadVideo(WebServiceName.add_post_video.rawValue, urlVideo: videoUrl, onView: vc) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if MainResponse != nil {
                let videoUrl = MainResponse["file"] as! String
                let poeterUrl = MainResponse["poster"] as! String
                self.posterImageUrl = poeterUrl
                self.attacmentUrl = videoUrl
                self.post.imageU = poeterUrl
                self.post.newAttachment?.video_URL = videoUrl
                var i = self.feedDataController.postList.index(where: {$0.id == self.post.id})
                self.feedDataController.postList[i!] = self.post
                self.feedDataController.postList[i!].newAttachment = self.post.newAttachment
                self.feedDataController.postList[i!].scrapedData = self.post.scrapedData
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
                    if (self?.vc.isKind(of: UserWallViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! UserWallViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! UserWallViewController).tableView)
                        (self?.vc as! UserWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! UserWallViewController).tableView.isHidden = false
                    }else if (self?.vc.isKind(of: FeedDetailViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! FeedDetailViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! FeedDetailViewController).tableView)
                        (self?.vc as! FeedDetailViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! FeedDetailViewController).tableView.isHidden = false
                    }else if (self?.vc.isKind(of: UserProfileViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! UserProfileViewController).tbleViewMain)
                        (self?.vc as! UserProfileViewController).tbleViewMain.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = false
                    }else if (self?.vc.isKind(of: MyWallViewController.self))!{
                        self?.baseVC?.showLoading()
                        (self?.vc as! MyWallViewController).tableView.isHidden = true
                        self?.baseVC?.reload(tableView: (self?.vc as! MyWallViewController).tableView)
                        (self?.vc as! MyWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                        self?.baseVC?.hideLoading()
                        (self?.vc as! MyWallViewController).tableView.isHidden = false
                    }
                }
            }else {
                self.baseVC?.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    
    @IBAction func profileButtonTapped(sender: UIButton)    {
        var userId: String!
        switch sender.tag {
        case 10, 11:
            userId = post.user!.id!.stringValue
        case 12:
            userId = post.shared_user!.id!.stringValue
        default: // case 10
            userId = post.user!.id!.stringValue
        }
        profileButtonAction?(userId)
    }
    
    @IBAction func postedAsUserButtonTapped()    {
        let budzMap = post.sub_user!
        postedAsUserButtonAction?(budzMap)
    }
    
    
    @IBAction func menuButtonTapped()   {
        menuButtonAction?(menuButton)
    }
    @IBAction func urlAction()   {
        urlBtnAtion?()
    }
    @IBAction func dissCalled(){
        urlBtnDiss?()
    }
    @IBAction func likesButtonTapped()   {
        likesButtonAction?()
    }
    
    @IBAction func commentsButtonTapped()    {
        commentsButtonAction?()
    }
    
    @IBAction func repostsButonTapped()  {
        repostAction?()
        
    }
    
    
    @IBAction func LikedByClicked()   {
        LikedByAction?()
    }
    
    @IBAction func moreButtonTapped(sender: UIButton!){
        moreButtonWidth.constant = 0
        //        tagCollectionViewWidth.constant = UIScreen.main.bounds.width - 60
        loadMoreTags = true
        tagCollectionView.reloadData()
        
    }
    
}

extension TextPostTableViewCell: UICollectionViewDataSource ,  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == MediacollectionView{
            return post.files?.count ?? 0
        }else if tagList != nil{
            if loadMoreTags || (tagList.tagged?.count)! <= 3{
                return tagList.tagged?.count ?? 0
            }else{
                return 3
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == MediacollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCell.identifier, for: indexPath) as! PostImageCollectionViewCell
            let file = post.files![indexPath.item]
            if let ratio = post.files?.first?.image_ratio {
                if ratio < 1.0 {
                    let width = self.MediacollectionView.frame.width
                    let newHight  = width / CGFloat(ratio)
                    if self.mediaCollectionViewHighttContraint != nil {
                        if newHight > 400{
                            cell.imageView.contentMode = .scaleAspectFit
                        }else{
                            cell.imageView.contentMode = .scaleAspectFill
                        }
                    }
                }else{
                    cell.imageView.contentMode = .scaleAspectFill
                }
            }else{
                cell.imageView.contentMode = .scaleAspectFill
            }
            cell.imageView.contentMode = .scaleAspectFit
            MediacollectionViewLayout.itemSize = MediacollectionView.frame.size
            cell.display(file: file)
            return cell
        }else {
            if  (tagList.tagged?.count)! > indexPath.row {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagPost", for: indexPath) as? TagPostFeedCollectionViewCell{
                    if  (tagList.tagged?.count)! > indexPath.row {
                        cell.tagName.text = tagList.tagged![indexPath.row].user.first_name
                        cell.tagName.textColor = tagList.tagged![indexPath.row].user.pointsColor
                        if let url = tagList.tagged![indexPath.row].user.profilePictureURL{
                            cell.user_img.sd_addActivityIndicator()
                            cell.user_img.sd_setShowActivityIndicatorView(true)
                            cell.user_img.sd_showActivityIndicatorView()
                            cell.user_img.sd_setImage(with: URL.init(string: url),placeholderImage:#imageLiteral(resourceName: "placeholderMenu") ,completed: nil)
                        }else{
                            cell.user_img.image = #imageLiteral(resourceName: "placeholderMenu")
                        }
                        
                        return cell
                    }
                    else {
                        return UICollectionViewCell()
                    }
                }else{
                    return UICollectionViewCell()
                }
                
            }else {
                return UICollectionViewCell()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != MediacollectionView{
            if  (tagList.tagged?.count)! > indexPath.row {
                let name  = tagList.tagged![indexPath.row].user.first_name
                var clculated_width = ((name?.count)! * 10) + 48
                if (name?.count)! < 4 {
                    clculated_width = 85
                }
                if clculated_width > 138 {
                    return CGSize(width: 140, height: 38)
                }else{
                    if clculated_width < 50 {
                        return CGSize(width: 85, height: 38)
                    }else{
                        return CGSize(width: clculated_width, height: 38)
                    }
                } 
            }
            return CGSize(width: 140, height: 38)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
extension TextPostTableViewCell: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == MediacollectionView{
            pageControl.currentPage = indexPath.item
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == MediacollectionView{
            if let poster = post.files![indexPath.row].poster, poster != "<null>" {
                let videoURL =  WebServiceName.videos_baseurl.rawValue + post.files![indexPath.row].file!
                let player = AVPlayer(url:  NSURL(string: videoURL)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                baseVC?.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else{
                self.CreateGalleryViewer(index: indexPath.item)
            }
        }else{
            baseVC?.OpenProfileVC(id: String(tagList.tagged![indexPath.row].user.id!.intValue))
        }
    }
    func CreateGalleryViewer(index: Int)    {
        photos.removeAll()
        for file in post.files!
        {
            if let poster = file.poster, poster != "<null>" {
                //videoIconImageView.isHidden = false
                if let url = URL(string: WebServiceName.images_baseurl.rawValue + poster)   {
                    
                    guard let video_url = URL(string: WebServiceName.videos_baseurl.rawValue + file.file!)    else{return}
                    print(video_url)
                    let  video = Media.init(videoURL: video_url, previewImageURL:url)
                    photos.append(video)
                }
            }
            else if let fileimg = file.file    {
                if let url = URL(string: WebServiceName.images_baseurl.rawValue + fileimg)    {
                    let photo = Media.init(url: url)
                    photos.append(photo)
                }
            }
            else {
                // TODO: show placeholder image
                
                
            }
            
        }
        let browser = MediaBrowser2(delegate: self as MediaBrowser2Delegate)
        browser.setCurrentIndex(at: index)
        browser.enableGrid = false
        browser.post = post
        browser.index=self.index
        browser.feedDataController = feedDataController
        self.viewContainingController?.navigationController?.pushViewController(browser, animated: false)
    }
}

var photos : [Media] = [Media]()

extension TextPostTableViewCell : MediaBrowser2Delegate {
    func numberOfMedia(in mediaBrowser: MediaBrowser2) -> Int {
        return photos.count
    }
    
    func media(for mediaBrowser: MediaBrowser2, at index: Int) -> Media {
        return photos[index]
    }
}


fileprivate struct PostImageCell    {
    static let identifier = "PostImageCollectionViewCell"
}

extension TextPostTableViewCell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (post.comments?.count)! > 2{
        return 2
        }else{
            return (post.comments?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailForPost = post
        let commentsCell = tableView.dequeueReusableCell(withIdentifier: "CommentCellWall", for: indexPath) as? CommentTableViewCell
        let comment = detailForPost?.comments![indexPath.row]
        commentsCell?.display(comment: comment!)
        commentsCell?.performLike.tag = indexPath.row
        commentsCell?.performLike.addTarget(self, action: #selector(self.likeButtonAction(sender:)), for: .touchUpInside)
        commentsCell?.timeAgoLabel.text = baseVC?.GetTimeAgoWall(StringDate: (comment?.created_at!)!)
        if(comment?.user_id?.stringValue == DataManager.sharedInstance.user?.ID ){
            commentsCell?.menuButton.isHidden = false
            commentsCell?.menuButtonWidthConstraint.constant = 30
            
        }else {
            commentsCell?.menuButton.isHidden = true
            commentsCell?.menuButtonWidthConstraint.constant = 0
        }
//        commentsCell?.menuButton.tag = postindex
//        commentsCell?.menuButtonCommentAction = { [unowned self] menuButton in
//            self.feedDataController.showPopoverMenuComment(sender: menuButton, for: comment!, controller: self, completion: { (menuAction) in
//                self.handleMoreMenuComment(for: menuAction , comment: comment)
//            })
//        }
        commentsCell?.post=detailForPost
//        cell = commentsCell
        commentsCell?.baseVC = self.baseVC
        commentsCell?.profileButtonAction = {[unowned self] userId in
            let sessionUserId = DataManager.sharedInstance.user!.ID
            var fdc: FeedDataController?
            if userId == sessionUserId  {
                fdc = self.feedDataController
            }
            self.baseVC?.OpenProfileVC(id: (comment?.user_id!.stringValue)!, feedDataController: fdc)
        }
        return commentsCell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            let comments = self.post.comments![indexPath.row]
            if let poster =  comments.attachment?.poster
            {
                CreateGalleryViewer(withImage: comments.attachment!.file!, userIfno: false, poster:poster, index: indexPath.row - 1)
            }
            else if let file  = comments.attachment?.file
            {
                CreateGalleryViewer(withImage: file, userIfno: false, poster:"", index: indexPath.row - 1)
            }
            
            
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.layoutSubviews()
    }

    
}

extension TextPostTableViewCell{
    func CreateGalleryViewer(withImage:String, userIfno:Bool,poster:String, index: Int)    {
        photos.removeAll()
        if poster.count>0 {
            if URL(string: WebServiceName.images_baseurl.rawValue + posterImageUrl) != nil   {
                guard let video_url = URL(string: WebServiceName.videos_baseurl.rawValue + withImage)    else{return}
                let player = AVPlayer(url:  NSURL(string: video_url.absoluteString)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.vc.present(playerViewController, animated: true) {
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
        browser.post = post
        let i = feedDataController.postList.index(where: {$0.id == post.id})
        browser.index=i
        browser.userIfno = userIfno
        browser.feedDataController = feedDataController
        self.vc.navigationController?.present(browser, animated: true, completion: nil)
    }
}

    
extension TextPostTableViewCell  {
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
        self.txtcomment.delegate = self
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
        _  = (self.txtcomment.frame.width * percent)/100
        let xPosition = self.txtcomment.frame.origin.x
        let yPosition = self.txtcomment.frame.origin.y +  CGFloat((Int(text.count/45) * 30 ) + 30)
        let height = self.acContainerView.frame.size.height
        let width = self.acContainerView.frame.size.width
        self.acContainerView.frame =  CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
        if self.acContainerView.isHidden{
            self.acContainerView.zoomIn()
        }
    }
}

extension TextPostTableViewCell: MJAutoCompleteManagerDataSource {
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

extension TextPostTableViewCell: MJAutoCompleteManagerDelegate {
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
        self.SetAttributedText(mainString: newText.replacingOccurrences(of: "_", with: " "), attributedStringsArray: self.mention_Array, view: self.txtcomment, color: UIColor.init(hex: "7CC244"))
    }
}

extension TextPostTableViewCell{
    @IBAction func postComment(_ sender: Any) {
        self.delayWithSeconds(1) {
            self.configureTagTextView()
        }
        self.acContainerView.isHidden = true
        self.contentView.endEditing(true)
        var comment = self.txtcomment.text!
        if attacmentUrl.count == 0 && newAttachment.ID.count == 0 && newAttachment.image_URL.count == 0 && newAttachment.video_URL.count == 0  {
            if comment == "Your Comment…" || comment == ""{
                self.txtcomment.text = "Your Comment…"
                self.baseVC?.ShowErrorAlert(message: "Please enter your comment!")
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
        var attach = Attachment()
        if let p = post.newAttachment?.ID, p == "-1"{
            
            attach = post.newAttachment!
            if !(post.newAttachment?.is_Video)!{
            self.attacmentUrl = post.imageU!
            }else if (post.newAttachment?.is_Video)!{
                self.posterImageUrl = post.imageU!
                self.attacmentUrl = (post.newAttachment?.video_URL)!
            }
        }
        var i = feedDataController.postList.index(where: {$0.id == post.id})
        feedDataController.performPostComment(post: self.post, comment: comment, attachement: attacmentUrl, poster: posterImageUrl,controller: vc, jsonData : json_data, attachmentObject:attach, postIndex:i! ,completion: { void in
            self.updated_tags = PostFeedViewController.tags
            self.updated_followed_user_model = self.followed_user_model
            self.acManager.removeAllAutoCompleteTriggers()
            self.configureTagTextView()
            self.resetCommentBar()
            self.showPlaceholder()
            self.mention_Array.removeAll()
            self.attacmentUrl = ""
            self.newAttachment = Attachment()
            self.post.newAttachment = Attachment()
//            self.commentViewBottomConstraint.constant = 0
            var i = self.feedDataController.postList.index(where: {$0.id == self.post.id})
            self.feedDataController.postList[i!] = self.post
            self.feedDataController.postList[i!].newAttachment = self.post.newAttachment
            self.feedDataController.postList[i!].scrapedData = self.post.scrapedData
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
                if (self?.vc.isKind(of: UserWallViewController.self))!{
                    self?.baseVC?.showLoading()
                    (self?.vc as! UserWallViewController).tableView.isHidden = true
                    self?.baseVC?.reload(tableView: (self?.vc as! UserWallViewController).tableView)
                    (self?.vc as! UserWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                    self?.baseVC?.hideLoading()
                    (self?.vc as! UserWallViewController).tableView.isHidden = false
                }else if (self?.vc.isKind(of: FeedDetailViewController.self))!{
                    self?.baseVC?.showLoading()
                    (self?.vc as! FeedDetailViewController).tableView.isHidden = true
                    self?.baseVC?.reload(tableView: (self?.vc as! FeedDetailViewController).tableView)
                    (self?.vc as! FeedDetailViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                    self?.baseVC?.hideLoading()
                    (self?.vc as! FeedDetailViewController).tableView.isHidden = false
                }else if (self?.vc.isKind(of: UserProfileViewController.self))!{
                    self?.baseVC?.showLoading()
                    (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = true
                    self?.baseVC?.reload(tableView: (self?.vc as! UserProfileViewController).tbleViewMain)
                    (self?.vc as! UserProfileViewController).tbleViewMain.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                    self?.baseVC?.hideLoading()
                    (self?.vc as! UserProfileViewController).tbleViewMain.isHidden = false
                }else if (self?.vc.isKind(of: MyWallViewController.self))!{
                    self?.baseVC?.showLoading()
                    (self?.vc as! MyWallViewController).tableView.isHidden = true
                    self?.baseVC?.reload(tableView: (self?.vc as! MyWallViewController).tableView)
                    (self?.vc as! MyWallViewController).tableView.scrollToRow(at: IndexPath.init(row: i!, section: 0), at: .bottom, animated: false)
                    self?.baseVC?.hideLoading()
                    (self?.vc as! MyWallViewController).tableView.isHidden = false
                }
            }
//            self.commentCross(sender: sender as! UIButton)
        })
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
        if textView.text == ""
        {
            showPlaceholder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        acManager.processString(textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 {
            self.updateTriggerData(newText: self.txtcomment.text)
        }
        return true
    }
}



extension TextPostTableViewCell{
    
    @IBAction func likeButtonAction(sender: UIButton!){
        sender.removeTarget(nil, action: nil, for: .allEvents)
        self.performCommentLike(comment: self.post.comments![sender.tag], sender: sender)
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
                let s = self.post.comments?.index(where: {$0.id == comment.id})
                self.post.comments![s!] = comment
                var i = self.feedDataController.postList.index(where: {$0.id == self.post.id})
                self.feedDataController.postList[i!] = self.post
                self.feedDataController.postList[i!].newAttachment = self.post.newAttachment
                self.feedDataController.postList[i!].scrapedData = self.post.scrapedData
                self.commentTableView.reloadData()
            }else{
                self.simpleCustomeAlert(title: "Error", discription: message)
            }
        })
    }
}


