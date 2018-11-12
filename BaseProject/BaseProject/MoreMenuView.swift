
//
//  MoreMenuView.swift
//  BaseProject
//
//  Created by MAC MINI on 29/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

enum MenuAction    {
    case share
    case flagReport
    case repost
    case mute
    case unmute
    case follow
    case unfollow
    case edit
    case delete
    case likeBy
}

class MoreMenuView: UIView  {
    
    @IBOutlet weak var img_hight: NSLayoutConstraint!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var postIndex:Int!
    var isShownonTop:Bool = false
    var sharePostAction: ((MoreMenuView) -> Void)?
    var flagPostAction: ((MoreMenuView) -> Void)?
    var mutePostAction: ((MoreMenuView) -> Void)?
    var unmutePostAction: ((MoreMenuView) -> Void)?
    var unfollowPostAction: ((MoreMenuView) -> Void)?
    var editPostAction: ((MoreMenuView) -> Void)?
    var deletePostAction: ((MoreMenuView) -> Void)?
    var likedByAction: ((MoreMenuView) -> Void)?
    
    typealias MenuItem = (image: UIImage, title: String, action: MenuAction)
    
    var menuItems: [String: MenuItem] = [
        MenuItemKey.share   :   (image: #imageLiteral(resourceName: "share-post-icon"), title: "Share Post", action: .share),
        MenuItemKey.flag    :   (image: #imageLiteral(resourceName: "report-post-icon"), title: "Report", action: .flagReport),
        MenuItemKey.mute    :   (image: #imageLiteral(resourceName: "post_mute"), title: "Mute this post", action: .mute),
        MenuItemKey.unmute  :   (image: #imageLiteral(resourceName: "post_unmute"), title: "Unmute this post", action: .unmute),
        MenuItemKey.edit    :   (image: #imageLiteral(resourceName: "post_edit"), title: "Edit", action: .edit),
        MenuItemKey.delete  :   (image: #imageLiteral(resourceName: "post_delete"), title: "Delete", action: .delete),
        MenuItemKey.likeby  :   (image: #imageLiteral(resourceName: "like-icon-highlighted").withRenderingMode(.alwaysTemplate), title: "Liked By", action: .likeBy)
    ]
    let menuItemsComment: [String: MenuItem] = [
        MenuItemKey.edit    :   (image: #imageLiteral(resourceName: "post_edit"), title: "Edit", action: .edit),
        MenuItemKey.delete  :   (image: #imageLiteral(resourceName: "post_delete"), title: "Delete", action: .delete)
    ]
    var visibleMenuItems = [MenuItem]()
    
    var post: Post!  {
        didSet  {
            displayMenu()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
}


// MARK: - Private Methods
extension MoreMenuView    {
    fileprivate func configure()    {
        let bubbleImage = #imageLiteral(resourceName: "popup-bubble")
        let edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        bubbleImageView.image = bubbleImage.resizableImage(withCapInsets: edgeInsets)
        
        print(CGFloat(10 + (CGFloat(self.visibleMenuItems.count) * 35.5)))
        self.img_hight.constant =  CGFloat(10 + (CGFloat(self.visibleMenuItems.count) * 35.5))
        self.layoutIfNeeded()
        
        
        let postMoreCellNib = UINib(nibName: Cell.identifier, bundle: nil)
        tableView.register(postMoreCellNib, forCellReuseIdentifier: Cell.identifier)

    }
    
    fileprivate func displayMenu()  {
        visibleMenuItems.removeAll()
        
        visibleMenuItems.append(menuItems[MenuItemKey.share]!)
        
        if let mutePostByUserCount = post.mute_post_by_user_count, mutePostByUserCount.intValue > 0 {
            visibleMenuItems.append(menuItems[MenuItemKey.unmute]!)
        }   else {
            visibleMenuItems.append(menuItems[MenuItemKey.mute]!)
        }
        visibleMenuItems.append(menuItems[MenuItemKey.likeby]!)
        let user = DataManager.sharedInstance.user!
        if let postUserId = post.user?.id, postUserId.intValue == Int(user.ID)  {

            if post.comments_count?.intValue     == 0 ||
                post.flaged_count?.intValue      == 0 ||
                post.shared_id?.intValue         == 0 ||
                post.shared_user_id?.intValue    == 0 {
                visibleMenuItems.append(menuItems[MenuItemKey.edit]!)
            }
            visibleMenuItems.append(menuItems[MenuItemKey.delete]!)
        }
        else    {
            if post.allow_repost?.intValue     == 0 ||
                post.shared_id?.intValue         == 0
            {
                if let item = menuItems[MenuItemKey.repost]{
                    visibleMenuItems.append(item)
                }
            }
            if(post.flaged_count!.intValue > 0){
                menuItems[MenuItemKey.flag] = (image: #imageLiteral(resourceName: "report-post-icon-selected"), title: "Report", action: .flagReport)
            }else {//
                menuItems[MenuItemKey.flag] = (image: #imageLiteral(resourceName: "report-post-icon"), title: "Report", action: .flagReport)
            }
            if let item = menuItems[MenuItemKey.flag]{
                visibleMenuItems.append(item)
            }
        }
        configure()
    }
}




extension MoreMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleMenuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? PostMoreTableViewCell
        let menuItem = visibleMenuItems[indexPath.row]
        cell?.imageView?.image = menuItem.image
        cell?.imageView?.tintColor = UIColor.black
        cell?.nameLabel?.text = menuItem.title
        cell?.isLastCell = indexPath.row == visibleMenuItems.count - 1
        cell?.isFlagged = post.flaged_count!.intValue > 0 ? true : false
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34.5
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  34.5
    }
}

extension MoreMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuItem = visibleMenuItems[indexPath.row]
        switch menuItem.action {
        case .share:
            sharePostAction?(self)
        case .flagReport:
            flagPostAction?(self)
        case .mute:
            mutePostAction?(self)
        case.unmute:
            mutePostAction?(self)
        case .unfollow:
            unfollowPostAction?(self)
        case .delete:
            deletePostAction?(self)
        case .edit:
            editPostAction?(self)
        case .likeBy:
            likedByAction?(self)
        default:
            break
        }
    }
}

fileprivate struct Cell   {
    static let identifier = "PostMoreTableViewCell"
}

fileprivate struct MenuItemKey  {
    static let share = "share"
    static var flag = "flag"
    static let repost = "repost"
    static let mute = "mute"
    static let unmute = "unmute"
    static let follow = "follow"
    static let unfollow = "unfollow"
    static let edit = "edit"
    static let likeby = "Liked By"
    static let delete = "delete"
}
