//
//  GalleryBottomBarView.swift
//  BaseProject
//
//  Created by MAC MINI on 06/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class GalleryBottomBarView: UIView {

    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var commentsCountButton: UIButton!
    
    
    func increaseRepost()    {
        let controller = self.viewContainingController as! MediaBrowser2
        let  repostCount = controller.post.shared_count!.intValue+1
        repostsButton.setTitle(" \(repostCount) Repost\(repostCount > 1 ? "s" : "")", for: .normal)
        controller.post.shared_count = NSNumber(integerLiteral: repostCount)
    }
    
    var repostsButtonAction: (() -> Void)?
    @IBAction func repostsButonTapped()  {
        repostsButtonAction?()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
   
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func comment(_ sender: Any)
    {
        showFeedDetail()
    }
    fileprivate func showFeedDetail() {
        let controller = self.viewContainingController as! MediaBrowser2
        let sotryboard = UIStoryboard(name: "Wall", bundle: nil)
        let feedDetailController = sotryboard.instantiateViewController(withIdentifier: "FeedDetail") as! FeedDetailViewController
        feedDetailController.postindex = controller.index
        feedDetailController.feedDataController = controller.feedDataController
        controller.navigationController?.pushViewController(feedDetailController, animated: true)
    }
    @IBAction func LikePost(_ sender: Any)
    {
        let controller = self.viewContainingController as! MediaBrowser2
        var count = controller.post.liked_count!.intValue
        if controller.post.isLiked
        {
            count = count-1
        }
        else
        {
            count = count+1
        }
        likesButton.isSelected = !controller.post.isLiked
        likesCountButton.setTitle(" \(count) Like\(count > 1 ? "s" : "s")", for: .normal)
        controller.post.liked_count = NSNumber(value: count)
        controller.feedDataController.performlikeFromGallery(index: controller.index, islike: !controller.post.isLiked)
        
    }
    
    var likeCount: (() -> Void)?
    @IBAction func likesCountAction(_ sender: Any){
        likeCount?()
        
    }
}
