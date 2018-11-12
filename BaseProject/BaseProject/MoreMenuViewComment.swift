//
//  MoreMenuViewComment.swift
//  BaseProject
//
//  Created by MAC MINI on 13/06/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class MoreMenuViewComment: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var postIndex:Int!
    var editPostAction: ((MoreMenuViewComment) -> Void)?
    var deletePostAction: ((MoreMenuViewComment) -> Void)?
    var likePostAction: ((MoreMenuViewComment) -> Void)?
    
    typealias MenuItem = (image: UIImage, title: String, action: MenuAction)
    
    let menuItemsComment: [String: MenuItem] = [
        MenuItemKey.edit    :   (image: #imageLiteral(resourceName: "post_edit"), title: "Edit", action: .edit),
        MenuItemKey.delete  :   (image: #imageLiteral(resourceName: "post_delete"), title: "Delete", action: .delete),
        MenuItemKey.like  :   (image: #imageLiteral(resourceName: "like-icon-highlighted").withRenderingMode(.alwaysTemplate), title: "Liked By", action: .likeBy)
    ]
    var visibleMenuItems = [MenuItem]()
    
    var post: PostComment!  {
        didSet  {
            displayMenu()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
        
    }
    
}

extension MoreMenuViewComment    {
    fileprivate func configure()    {
        let bubbleImage = #imageLiteral(resourceName: "popup-bubble")
        let edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        bubbleImageView.image = bubbleImage.resizableImage(withCapInsets: edgeInsets)
        
        let postMoreCellNib = UINib(nibName: Cell.identifier, bundle: nil)
        tableView.register(postMoreCellNib, forCellReuseIdentifier: Cell.identifier)
        //        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
    }
    
    fileprivate func displayMenu()  {
        visibleMenuItems.removeAll()
        
        visibleMenuItems.append(menuItemsComment[MenuItemKey.edit]!)
        visibleMenuItems.append(menuItemsComment[MenuItemKey.delete]!)
        visibleMenuItems.append(menuItemsComment[MenuItemKey.like]!)
        
       
        
        let user = DataManager.sharedInstance.user!
        
    }
}
extension MoreMenuViewComment: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleMenuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? PostMoreTableViewCell
        let menuItem = visibleMenuItems[indexPath.row]
        cell?.imageView?.image = menuItem.image
        cell?.imageView?.tintColor = UIColor.black
        cell?.nameLabel?.text = menuItem.title
        cell?.selectionStyle = .none
        return cell!
    }
}

extension MoreMenuViewComment: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuItem = visibleMenuItems[indexPath.row]
        switch menuItem.action {
        case .delete:
            deletePostAction?(self)
        case .edit:
            editPostAction?(self)
        case .likeBy:
            likePostAction?(self)
        default:
            break
        }
    }
}

fileprivate struct Cell   {
    static let identifier = "PostMoreTableViewCell"
}

fileprivate struct MenuItemKey  {
  
    static let edit = "edit"
    static let delete = "delete"
    static let like = "LikedBy"
}
