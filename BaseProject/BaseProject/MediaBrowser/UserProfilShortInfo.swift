//
//  UserProfilShortInfo.swift
//  BaseProject
//
//  Created by MAC MINI on 06/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class UserProfilShortInfo: UIView {

    
    @IBOutlet weak var dots_btn_width_contraints: NSLayoutConstraint!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var menu_dots: UIImageView!
    var isViewPresent : Bool  = false
    @IBOutlet weak var CloseMenu: UIView!
    var profileButtonAction: ((String) -> Void)?
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var budLabel: UILabel!
    @IBOutlet weak var pointsBudzSeperator: UIView!
    @IBOutlet weak var budIconImageView: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    var menuButtonAction: ((UIButton) -> Void)?
    var downloadBtn: ((UIButton) -> Void)?
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


    
  
   
    @IBAction func onClickDownloadImage(_ sender: Any) {
         downloadBtn?(btnDownload)
    }
    
    @IBAction func openSharePopup(_ sender: Any)
    {
        menuButtonAction?(btnShare)
    }
    
    
    func displayUserProfile(post: Post)    {
        
        
      
        pointsLabel.text = post.user?.pointsValue
        budLabel.text = post.user?.budType
        
        let pointsColor = post.user?.pointsColor
        
        pointsLabel.textColor = pointsColor
        pointsBudzSeperator.backgroundColor = pointsColor
        budLabel.textColor = pointsColor
        userNameLabel.textColor=pointsColor
        userNameLabel.text = post.user?.first_name
        budIconImageView.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
        budIconImageView.tintColor = pointsColor
        
        
        if let profilePicUrlString = post.user?.profilePictureURL {
            let url = URL(string: profilePicUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            profilePictureImageView.af_setImage(withURL: url)
        }
        else {
            profilePictureImageView.image =  #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
            profilePictureImageView.tintColor = pointsColor
        }
        
       self.profileButtonAction =  {[unowned self] userId in
            let sessionUserId = DataManager.sharedInstance.user!.ID
        let controller = self.viewContainingController as! MediaBrowser2
            var fdc: FeedDataController?
            if userId == sessionUserId  {
                fdc = controller.feedDataController
            }
            controller.OpenProfileVC(id: userId, feedDataController: fdc)
        }
        
    }
    
  
    @IBAction func profileButtonTapped(_ sender: Any)
    {
        
        // TODO: Show relevant user
        let btn = sender as! UIButton
        let controller = self.viewContainingController as! MediaBrowser2
        var userId: String!
        switch btn.tag {
        case 10, 11:
            userId = controller.post.user!.id!.stringValue
        case 12:
            userId = controller.post.shared_user!.id!.stringValue
        default: // case 10
            userId = controller.post.user!.id!.stringValue
        }
        profileButtonAction?(userId)
    }
  
    @IBAction func closeGallaryViewer(_ sender: Any) {
        if isViewPresent {
             self.viewContainingController?.dismiss(animated: true, completion: nil)
        }else{
             self.viewContainingController?.navigationController?.popViewController(animated: false)
        }
       
    }
    
}
