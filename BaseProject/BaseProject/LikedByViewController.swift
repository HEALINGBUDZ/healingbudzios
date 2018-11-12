//
//  LikedByViewController.swift
//  BaseProject
//
//  Created by MN on 13/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class LikedByViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var likeTableView:UITableView!
    var postIndex: Int?
    var feedDataController: FeedDataController!
   // var likes = [PostLike]()
    var allLikes = [Like]()
    var filteredLikes = [PostLike]()
    var iLiked = false
    var commentIndex = 0
    var fromComment = false
    var feedDetailVC: FeedDetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        likeTableView.dataSource = self
        likeTableView.delegate = self
        likeTableView.estimatedRowHeight = 50
        likeTableView.rowHeight = UITableViewAutomaticDimension
        likeTableView.separatorStyle = .none
        extractLikes()
    }
    
    fileprivate func extractLikes() {
        let sessionUser = DataManager.sharedInstance.user
        var otherUserLikes = [Like]()
        if !fromComment{
        if let exsistingLikes = feedDataController.postList[postIndex!].likes   {
            for index in 0..<exsistingLikes.count  {
                let postLike = exsistingLikes[index]
                var image: String!
                if let postuser = postLike.user{
                if postLike.user?.image_path?.range(of:"/") != nil{
                    image = (postLike.user?.image_path)!
                }else{
                    image = (postLike.user?.avatar)!
                }
                if Int((sessionUser?.ID)!) != postLike.user_id!.intValue    {
                    var otherUserLike = Like(
                        userId: (postLike.user?.id?.intValue)!,
                        firstName: (postLike.user?.first_name)!,
                        imagePath: image,
                        special_icon: (postLike.user?.special_icon)!,
                        color:  (postLike.user?.pointsColor)!
                    )
                    //otherUserLike.firstName = postLike.user.firstName
                    //                ...
                    otherUserLikes.append(otherUserLike)
                }
                }
            }
        }
        }else{
            if let exsistingLikes = feedDataController.postList[postIndex!].comments![commentIndex].likes   {
                for index in 0..<exsistingLikes.count  {
                    let postLike = exsistingLikes[index]
                    var image: String!
                    if let postuser = postLike.user{
                        if postLike.user?.image_path?.range(of:"/") != nil{
                            image = (postLike.user?.image_path)!
                        }else{
                            image = (postLike.user?.avatar)!
                        }
                        if Int((sessionUser?.ID)!) != postLike.user?.id!.intValue    {
                            var otherUserLike = Like(
                                userId: (postLike.user?.id?.intValue)!,
                                firstName: (postLike.user?.first_name)!,
                                imagePath: image,
                                special_icon: (postLike.user?.special_icon)!,
                                color:  (postLike.user?.pointsColor)!
                            )
                            //otherUserLike.firstName = postLike.user.firstName
                            //                ...
                            otherUserLikes.append(otherUserLike)
                        }
                    }
                }
            }
        }
        
        
        var myUserLike: Like!
        if !fromComment{
        if feedDataController.postList[postIndex!].isLiked  {
            
            myUserLike = Like(
                userId: Int((sessionUser?.ID)!)!,
                firstName: (sessionUser?.userFirstName)!,
                imagePath: (sessionUser?.profilePictureURL)!,
                 special_icon: (sessionUser?.special_icon)!,
                 color:  (sessionUser?.pointsColor)!
            )
            allLikes.append(myUserLike)
        }
        }else{
            if feedDataController.postList[postIndex!].comments![commentIndex].likedCount == 1  {
                
                myUserLike = Like(
                    userId: Int((sessionUser?.ID)!)!,
                    firstName: (sessionUser?.userFirstName)!,
                    imagePath: (sessionUser?.profilePictureURL)!,
                    special_icon: (sessionUser?.special_icon)!,
                    color:  (sessionUser?.pointsColor)!
                )
                allLikes.append(myUserLike)
            }
        }

        allLikes.append(contentsOf: otherUserLikes)
        print(allLikes)
        
        // TODO: use this
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDoneButton(sender: UIButton!){
        self.dismiss(animated: false, completion: {
            if self.feedDetailVC != nil{
               isfromYoutubePlayer = true
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likeTableView.dequeueReusableCell(withIdentifier: "LikedByCell", for: indexPath) as! LikesByTableViewCell
        cell.userID = String(allLikes[indexPath.row].userId)
        cell.userNameLabel.text = allLikes[indexPath.row].firstName
        cell.userNameLabel.textColor = allLikes[indexPath.row].color
        cell.profileImage.sd_addActivityIndicator()
        cell.profileImage.sd_showActivityIndicatorView()
        cell.profileImage.sd_setShowActivityIndicatorView(true)
        if allLikes[indexPath.row].imagePath.range(of:"http") != nil {
            if let url = URL(string: allLikes[indexPath.row].imagePath){
                cell.profileImage.sd_setImage(with: url,placeholderImage :#imageLiteral(resourceName: "placeholderMenu") ,completed: nil)
            }
        }else{
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + allLikes[indexPath.row].imagePath){
                 cell.profileImage.sd_setImage(with: url,placeholderImage :#imageLiteral(resourceName: "placeholderMenu") ,completed: nil)
            }
        }
        if (allLikes[indexPath.row].special_icon.characters.count) > 6 {
            cell.profileImageTop.isHidden = false
            let linked = URL(string: WebServiceName.images_baseurl.rawValue + (allLikes[indexPath.row].special_icon.RemoveSpace()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            cell.profileImageTop.af_setImage(withURL: linked)
        }else {
            cell.profileImageTop.isHidden = true
        }
        cell.profileButtonAction = {[unowned self] userId in
            var fdc: FeedDataController?
            
            let likeDataDict:[String: AnyObject] = ["userid": userId as AnyObject]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LikerProfile"), object: nil, userInfo: likeDataDict)
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    

    var likes: [Like]!

}
typealias Like = (userId: Int, firstName: String, imagePath: String, special_icon: String, color: UIColor)
