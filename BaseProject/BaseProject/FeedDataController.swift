//
//  FeedDataController.swift
//  BaseProject
//
//  Created by Yasir Ali on 05/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import Foundation
import Popover

class FeedDataController    {
    var postList = [Post]()
    var isEdit: Bool = false
    var idComment: String  = "0"
    var shouldFetchLatestPosts = false
//    init() {
//        postList = HBUserDafalts.sharedInstance.getDefaultPosts()
//    }
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
        
    }
    func OpenShare(params: [String: Any], link: String,content: String, controller: UIViewController){
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_share.rawValue, params: params as [String : AnyObject]) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
        }
        
        var activityItems: [AnyObject]?
        let text = "Check out Healing Budz for your smartphone: \n"
        let url = URL.init(string: link)
        activityItems = [text as AnyObject , url! as AnyObject]
        let activityController = UIActivityViewController(activityItems:
            activityItems!, applicationActivities: nil)
        controller.present(activityController, animated: true,
                     completion: nil)
    }
    func showPopoverMenu(isShownOnTop : Bool ,sender: UIButton, for post: Post, controller: UIViewController, completion: ((MenuAction) -> Void)?)  {
        
        print(sender.frame.origin.y)
        var moreMenu: MoreMenuView = .fromNib()
        let user = DataManager.sharedInstance.user!
        if let postUserId = post.user?.id, postUserId.intValue == Int(user.ID)  {
            if post.comments_count?.intValue     == 0 ||
                post.flaged_count?.intValue      == 0 ||
                post.shared_id?.intValue         == 0 ||
                post.shared_user_id?.intValue    == 0 {
                moreMenu =  Bundle.main.loadNibNamed("MoreMenuView2", owner: nil, options: nil)![0] as! MoreMenuView
            }else{
                moreMenu = .fromNib()
            }
        }else{
            moreMenu = .fromNib()
        }
        moreMenu.postIndex = sender.tag
        var options : [PopoverOption] = [PopoverOption]()
        if isShownOnTop{
            options =  [
                .type(.up),
                .cornerRadius(0),
                .animationIn(0.3),
                .blackOverlayColor(UIColor.clear),
                .arrowSize(CGSize.zero)
                ] as [PopoverOption]
            
            let bubbleImage = #imageLiteral(resourceName: "popup_bouble_down")
            let edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
            moreMenu.bubbleImageView.image = bubbleImage.resizableImage(withCapInsets: edgeInsets)
          
        }else{
            options =  [
                .type(.down),
                .cornerRadius(0),
                .animationIn(0.3),
                .blackOverlayColor(UIColor.clear),
                .arrowSize(CGSize.zero)
                ] as [PopoverOption]
            
            let bubbleImage = #imageLiteral(resourceName: "popup-bubble")
            let edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
            moreMenu.bubbleImageView.image = bubbleImage.resizableImage(withCapInsets: edgeInsets)
        }
        moreMenu.isShownonTop = isShownOnTop
        moreMenu.post = post
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.popoverColor = UIColor.clear
        popover.show(moreMenu, fromView: sender)
        
        moreMenu.sharePostAction = { [unowned self] moreMenuView in
            self.performShare(for: post, controller: controller)
            popover.dismiss()
            completion?(.share)
        }
        
        moreMenu.flagPostAction = { [weak self] moreMenuView in
            
            if moreMenu.post.flaged_count!.intValue==0
            {
                self?.openReasonView(controller: controller, index: moreMenu.postIndex,post:moreMenu.post)
            }
            popover.dismiss()
            completion?(.flagReport)

        }
        
        moreMenu.mutePostAction = { [weak self] moreMenuView in
            // TODO: mute post
            self?.performMute(post: post,index: moreMenu.postIndex, controller: controller)
            popover.dismiss()
            completion?(.mute)
        }
        
        moreMenu.unmutePostAction = { [weak self] moreMenuView in
            // TODO: unmute post
            popover.dismiss()
            completion?(.unmute)
        }
        
//        moreMenu.unfollowPostAction = { [weak self] moreMenuView in
//            // TODO: unfollow post
//            self?.performUnfollowBud(post: post, index: moreMenu.postIndex, controller: controller)
//            popover.dismiss()
//            completion?(.unfollow)
//        }
//        
        moreMenu.editPostAction = { [unowned self] moreMenuView in
            // TODO: edit post
            let index = self.postList.index(where: {$0.id == post.id})
            self.performEdit(index: index!, controller: controller)
            popover.dismiss()
            completion?(.edit)
        }
        
        moreMenu.deletePostAction = { [unowned self] moreMenuView in
            // TODO: delete post
            self.performDelete(post: post, controller: controller) {
                completion?(.delete)
            }
            popover.dismiss()
        }
        moreMenu.likedByAction = { [unowned self] moreMenuView in
            // TODO: delete post
            completion?(.likeBy)
            popover.dismiss()
        }
        
    }
    func showPopoverMenuComment(sender: UIButton, for post: PostComment, controller: UIViewController, completion: ((MenuAction) -> Void)?)  {
        let moreMenu: MoreMenuViewComment = .fromNib()
        moreMenu.postIndex = sender.tag
        let options = [
            .type(.down),
            .cornerRadius(0),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.clear),
            .arrowSize(CGSize.zero)
            ] as [PopoverOption]
        moreMenu.post = post
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.popoverColor = UIColor.clear
        popover.show(moreMenu, fromView: sender)
        
        moreMenu.editPostAction = { [unowned self] moreMenuView in
            // TODO: edit post
//            let index = self.postList.index(where: {$0.id == post.id})
//            self.performEdit(index: index!, controller: controller)
//            popover.dismiss()
            completion?(.edit)
             popover.dismiss()
        }
        
        moreMenu.deletePostAction = { [unowned self] moreMenuView in
            // TODO: delete post
            self.performDeleteComment(post: post, controller: controller, completion: {
                 completion?(.delete)
            })
            popover.dismiss()
        }
        
        moreMenu.likePostAction = { [unowned self] moreMenuView in
            // TODO: delete post
            completion?(.likeBy)
            popover.dismiss()
        }
    }

    func openReasonView(controller:UIViewController,index:Int,post:Post)
    {
                    if controller.isKind(of: UserWallViewController.self)
                    {
                        let vc = controller as! UserWallViewController
                        vc.viewFilter.showReportMenu = true
                        vc.viewFilter.tag =  index
                        vc.viewFilter.filtersList = ["Nudity or sexual content", "Harassment or hate speech", "Threatening, violent or concerning","Spam","Post is Offensive", "Unrelated Post"]
                        vc.viewFilter.selectedIndex = wallSelectedFilter
                        vc.filterList = vc.viewFilter.filtersList
                        vc.showView()
                    }else if controller.isKind(of: UserProfileViewController.self)
                    {
                    let vc = controller as! UserProfileViewController
                    vc.viewFilter.showReportMenu = true
                    vc.viewFilter.tag =  index
                    vc.viewFilter.filtersList = ["Nudity or sexual content", "Harassment or hate speech", "Threatening, violent or concerning","Spam","Post is Offensive", "Unrelated Post"]
                    vc.viewFilter.selectedIndex = wallSelectedFilter
                    vc.filterList = vc.viewFilter.filtersList
                    vc.showView()
                    }else{
                        if controller.isKind(of: FeedDetailViewController.self)
                        {
                            let vc = controller as! FeedDetailViewController
                            vc.viewFilter.showReportMenu = true
                            vc.viewFilter.tag =  index
                            vc.viewFilter.filtersList = ["Nudity or sexual content", "Harassment or hate speech", "Threatening, violent or concerning","Spam","Post is Offensive", "Unrelated Post"]
                            vc.viewFilter.selectedIndex = wallSelectedFilter
                            vc.filterList = vc.viewFilter.filtersList
                            vc.showView()
                        }
                        else if controller.isKind(of: MediaBrowser2.self){
                            let vc = controller as! MediaBrowser2
                            let flagView = vc.GetView(nameViewController: "StrainReportAlertVC", nameStoryBoard: "Rewards") as! StrainReportAlertVC
                            flagView.fromMediaBrowser = 1
//                            flagView.modalPresentationStyle = .overCurrentContext
//                            flagView.modalTransitionStyle = .coverVertical
                            flagView.providesPresentationContextTransitionStyle = true
                            flagView.definesPresentationContext = true
                            flagView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            flagView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                            self.present(customAlert, animated: true, completion: nil)
                            vc.present(flagView, animated: true, completion: nil)
                        }
        }
    }
    
    // MARK: - API Actions
    func performEdit(index: Int, controller: UIViewController){
        let postFeedNavigationController = self.GetView(nameViewController: "PostFeedNavigation", nameStoryBoard: "Wall") as! UINavigationController
        let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
        postFeedViewController.feedDataController=self
        postFeedViewController.editIndex = index
        //        let postFeedViewController = self.GetView(nameViewController: "PostFeed", nameStoryBoard: "Wall") as! PostFeedViewController
        controller.present(postFeedNavigationController, animated: true, completion: nil)
    }
    func performlReportOrFlag(index:Int ,reason:String)
    {
        
        
        
        let serviceUrl = WebServiceName.add_post_flag.rawValue
        
        NetworkManager.PostCall(UrlAPI: serviceUrl, params: ["post_id": postList[index].id!, "reason": reason as AnyObject]) {  (apiSucceed, message, responseData) in
            print(responseData)
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        print("data: \(data)")
                        self.postList[index].flaged_count = NSNumber(integerLiteral: 1)
                    }  // data
                } // successs
                else {
                    if let errorMessage = responseData["errorMessage"] as? String   {
                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                            DataManager.sharedInstance.logoutUser()
                            
                        }
                        else {
                            
                        }
                    } // errorMessage
                    else    {
                        
                    }
                } // error
            } // api Succeed
        } // net
    }
    
    
    
    
    
    func performUnfollowBud(post:Post,index:Int, controller: UIViewController) {
        
     
        let personToUnfollow = post.user_id!
        let serviceUrl = WebServiceName.un_follow.rawValue
        NetworkManager.PostCall(UrlAPI: serviceUrl, params: ["followed_id": personToUnfollow as AnyObject]) {  (apiSucceed, message, responseData) in
            print(responseData)
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    NotificationCenter.default.post(name: .budUnfollowed, object: nil)
                } // successs
                else {
                    if let errorMessage = responseData["errorMessage"] as? String   {
                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                            DataManager.sharedInstance.logoutUser()
                            controller.ShowLogoutAlert()
                        }
                        else {
                            controller.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        controller.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
            } // api Succeed
        } // netowrk call
    }
    func performMute(post:Post,index:Int, controller: UIViewController) {
        
        var isMute = 0
        if post.mute_post_by_user_count == 1
        {
            isMute = 0
            
        }
        else
        {
            isMute = 1
        }
    
        let serviceUrl = WebServiceName.mute_post.rawValue
        NetworkManager.PostCall(UrlAPI: serviceUrl, params: ["post_id": post.id!, "is_mute": isMute as AnyObject]) {  (apiSucceed, message, responseData) in
            print(responseData)
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        print("data: \(data)")
                        self.postList[index].mute_post_by_user_count = NSNumber(integerLiteral: isMute)
                    }  // data
                } // successs
                else {
                    if let errorMessage = responseData["errorMessage"] as? String   {
                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                            DataManager.sharedInstance.logoutUser()
                            controller.ShowLogoutAlert()
                        }
                        else {
                            controller.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        controller.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
            } // api Succeed
        } // netowrk call
    }
    
    
    fileprivate func performLike(postId: NSNumber, isLiked: Bool, index: Int, controller: UIViewController? = nil)  {
        let serviceUrl = WebServiceName.add_post_like_dislike.rawValue
        
        NetworkManager.PostCall(UrlAPI: serviceUrl, params: ["post_id": postId, "is_like": isLiked as AnyObject]) {  (apiSucceed, message, responseData) in
            print(responseData)
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    if let data = responseData["successData"] as? [String: Any] {
                        print("data: \(data)")
                        
                        self.postList[index].liked_count = NSNumber(value: isLiked)
                        
                    }  // data
                } // successs
                else {
                    if let errorMessage = responseData["errorMessage"] as? String   {
                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                            DataManager.sharedInstance.logoutUser()
                            controller?.ShowLogoutAlert()
                        }
                        else {
                            controller?.ShowErrorAlert(message:errorMessage)
                        }
                    } // errorMessage
                    else    {
                        controller?.ShowErrorAlert(message:"Try again later!")
                    }
                } // error
            } // api Succeed
        } // netowrk call
    }
    
    func performlikeFromGallery(index:Int ,islike:Bool)
    {
        performLike(postId: postList[index].id!, isLiked: islike, index: index)
    }
    
    func performLike(cell: TextPostTableViewCell, index: Int, controller: UIViewController) {
        
        var isLiked = false
        if cell.likesButton.isSelected   {
            cell.decreaseLikes()
            
        }
        else {
            cell.increaseLikes()
            isLiked = true
        }
        
        performLike(postId: postList[index].id!, isLiked: isLiked, index: index, controller: controller)
    }
    
    func performRepost(cell: TextPostTableViewCell?, index: Int, controller: UIViewController,completion:@escaping (_ r:Bool) -> Void) -> Void {
        let repostViewController = self.GetView(nameViewController: "RepostViewController", nameStoryBoard: "Wall") as! RepostViewController
        repostViewController.feedDataController = self
        repostViewController.post = self.postList[index]
        controller.present(repostViewController, animated: true, completion: nil)
//        if let postCell = cell
//        {
//                postCell.increaseRepost()
//        }
//
//        let poster_id = DataManager.sharedInstance.user?.ID
//        var taggeruser = ""
//        for loop in self.postList[index].tagged!
//        {
//            taggeruser = taggeruser+"\(loop.id!)"
//        }
//        let serviceUrl = WebServiceName.repost.rawValue
//        NetworkManager.PostCall(UrlAPI: serviceUrl, params: ["post_id": postList[index].id!, "posting_user": poster_id as AnyObject , "tagged_users":taggeruser as AnyObject]) {  (apiSucceed, message, responseData) in
//            print(responseData)
//
//            if apiSucceed   {
//                let status = responseData["status"] as! String
//                if status == "success"  {
//                    if let data = responseData["successData"] as? [String: Any] {
//                        print("data: \(data)")
//                        if let postCell = cell{
//                            self.postList[index] = postCell.post
//                            }
//
//                        completion(true)
//                    }  // data
//                } // successs
//                else {
//                    if let errorMessage = responseData["errorMessage"] as? String   {
//                        if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
//                            DataManager.sharedInstance.logoutUser()
//                            controller.ShowLogoutAlert()
//                        }
//                        else {
//                            controller.ShowErrorAlert(message:errorMessage)
//                        }
//                    } // errorMessage
//                    else    {
//                        controller.ShowErrorAlert(message:"Try again later!")
//                    }
//                    completion(false)
//                } // error
//            } // api Succeed
//        } // netowrk call
    }
    
    
    

    func performShare(for post: Post, controller: UIViewController)  {
        var parmas = [String: Any]()
        parmas["id"] = "\(post.id!)"
        parmas["type"] = "Post"
        let link : String = Constants.ShareLinkConstant + "get-post/\(post.id!)"
        self.OpenShare(params:parmas,link: link,content: post.discription!, controller: controller)
//        let text = WebServiceName.shareUrl.rawValue + "\(String(describing: post.id!))"
//        let textToShare = [ text ]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
//
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
//
//        // present the view controller
//        controller.present(activityViewController, animated: true, completion: nil)
    }

    
    func performDelete(post: Post, controller: UIViewController, completion: (() -> Void)?){
        controller.showLoading()
        
        print(post.id!)
        let mainParam: [String : AnyObject] = ["post_id": post.id!]
        NetworkManager.PostCall(UrlAPI:WebServiceName.delete_user_post.rawValue, params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
            print(responseData)
            controller.hideLoading();
            
            
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    self.postList = (self.postList.filter { $0.id! != post.id! })
                    completion?()
                }  // data
            } // successs
            else {
                if let errorMessage = responseData["errorMessage"] as? String   {
                    if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                        DataManager.sharedInstance.logoutUser()
                        controller.ShowLogoutAlert()
                    }
                    else {
                        controller.ShowErrorAlert(message:errorMessage)
                    }
                } // errorMessage
                else    {
                    controller.ShowErrorAlert(message:"Try again later!")
                }
            } // error
        } // api Succeed
    }// netowrk call
    func performDeleteComment(post: PostComment, controller: UIViewController, completion: (() -> Void)?){
        controller.showLoading()
        
        print(post.id!)
        let mainParam: [String : AnyObject] = ["comment_id": post.id!]
        NetworkManager.PostCall(UrlAPI:WebServiceName.delete_comment.rawValue, params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
            print(responseData)
            controller.hideLoading();
            
            
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
//                    self.postList = (self.postList.filter { $0.id! != post.post_id! })
                   
                    
                    completion?()
                }  // data
            } // successs
            else {
                if let errorMessage = responseData["errorMessage"] as? String   {
                    if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                        DataManager.sharedInstance.logoutUser()
                        controller.ShowLogoutAlert()
                    }
                    else {
                        controller.ShowErrorAlert(message:errorMessage)
                    }
                } // errorMessage
                else    {
                    controller.ShowErrorAlert(message:"Try again later!")
                }
            } // error
        } // api Succeed
    }// netowrk call
    
    func addComment(commet:PostComment , postWithComment:Post,postIndex:Int)
    {
        var comments = [PostComment]()
        var commenteList = postWithComment.comments
        if(commenteList != nil){
            if(commenteList!.count > 0){
                if(commenteList?.contains(where: {$0.id == commet.id}))!{
                    commenteList?[(commenteList?.index(where: {$0.id! == commet.id!}))!] = commet
                    comments = commenteList!
                    postWithComment.comments = comments
                    self.postList[postIndex] = postWithComment
                    self.postList[postIndex].comments_count = NSNumber(integerLiteral: self.postList[postIndex].comments_count!.intValue)
                }else {
                    comments = [commet]
                    if let previousComments = postWithComment.comments  {
                        comments.append(contentsOf: previousComments)                       
                    }
                    postWithComment.comments = comments
                    self.postList[postIndex] = postWithComment
                    self.postList[postIndex].comments_count = NSNumber(integerLiteral: self.postList[postIndex].comments_count!.intValue+1)
                }
                self.shouldFetchLatestPosts = true
            }else {
                comments = [commet]
                if let previousComments = postWithComment.comments  {
                    comments.append(contentsOf: previousComments)
                }
                postWithComment.comments = comments
                self.postList[postIndex] = postWithComment
                self.postList[postIndex].comments_count = NSNumber(integerLiteral: self.postList[postIndex].comments_count!.intValue+1)
                self.shouldFetchLatestPosts = true
            }
        }else {
            comments = [commet]
            if let previousComments = postWithComment.comments  {
                comments.append(contentsOf: previousComments)
            }
            postWithComment.comments = comments
            self.postList[postIndex] = postWithComment
            self.postList[postIndex].comments_count = NSNumber(integerLiteral: self.postList[postIndex].comments_count!.intValue+1)
            self.shouldFetchLatestPosts = true
        }
        
        
       
        
    }
    func performPostComment(post: Post,comment:String ,attachement:String ,poster:String , controller: UIViewController?,jsonData : String, attachmentObject:Attachment,postIndex:Int, completion: (() -> Void)?){
        controller?.showLoading()
        
        var type = "image"
    
        if poster.count>0
        {
            type = "video"
          
        }
        var mainParam: [String : AnyObject] = ["post_id": post.id!,"comment":comment as AnyObject , "attachment":attachement as AnyObject,"json_data" : jsonData as AnyObject , "poster":poster as AnyObject, "type":type as AnyObject]
        if(self.isEdit){
            mainParam["comment_id"] = idComment as AnyObject
        }
        NetworkManager.PostCall(UrlAPI:WebServiceName.add_comment.rawValue, params: mainParam) { [unowned self] (apiSucceed, message, responseData) in
            print(responseData)
            controller?.hideLoading();
            
            
            
            if apiSucceed   {
                let status = responseData["status"] as! String
                if status == "success"  {
                    guard let data = responseData["successData"] else{return }
                    let comment =  PostComment(JSON: data["comments"] as! [String:AnyObject])
                    //comment?.attachment?.file = attachement
                    comment?.attachment?.type = type
                    
//                    if poster.count > 0
//                    {
//                            comment?.attachment?.poster
//                    }
                    
                    
                    self.addComment(commet: comment!, postWithComment: post, postIndex: postIndex)
                    completion?()
                }  // data
            } // successs
            else {
                if let errorMessage = responseData["errorMessage"] as? String   {
                    if errorMessage.lowercased() == "session expired" || errorMessage.lowercased() == "you are not autherize for app" {
                        DataManager.sharedInstance.logoutUser()
                        controller?.ShowLogoutAlert()
                    }
                    else {
                        controller?.ShowErrorAlert(message:errorMessage)
                    }
                } // errorMessage
                else    {
                    controller?.ShowErrorAlert(message:"Try again later!")
                }
            } // error
        } // api Succeed
    }
}
