 //
//  CommentTableViewCell.swift
//  BaseProject
//
//  Created by Yasir Ali on 31/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import AlamofireImage
import FLAnimatedImage
import SwiftyJSON

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profilePictureImageViewTop: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: ActiveLabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var menuButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaImage: FLAnimatedImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var heightForMediaImage: NSLayoutConstraint!
    @IBOutlet weak var imageVideoOverlay: UIImageView!
    @IBOutlet weak var likeIconImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var performLike: UIButton!
    var post :Post!
    var baseVC : BaseViewController?
    var comment  : PostComment!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        commentLabel.mentionColor = UIColor(hex: "7CC244")
        commentLabel.hashtagColor = UIColor(hex: "7CC244")
        commentLabel.URLColor     = UIColor(hex: "808080")
    }
    
    

    override func prepareForReuse() {
        profilePictureImageView.image = nil
        imageVideoOverlay.isHidden=true
        heightForMediaImage.constant = 0
        self.selectionStyle = .none   
    }
    func mediaImageCustomization()
    {
        self.mediaImage.layer.cornerRadius=15.0
        self.mediaImage.layer.borderColor = UIColor.clear.cgColor
        self.mediaImage.layer.borderWidth = 1
        self.mediaImage.layer.masksToBounds=true
        self.mediaImage.contentMode = .scaleAspectFill
    }
    
    func display(comment: PostComment)    {
        self.comment = comment
        if self.comment.json_data == nil{
            commentLabel.mentionColor = UIColor(hex: "FFFFFF")
            commentLabel.hashtagColor = UIColor(hex: "FFFFFF")
        }else{
            commentLabel.mentionColor = UIColor(hex: "7CC244")
            commentLabel.hashtagColor = UIColor(hex: "7CC244")
        }
        if let attachment =  comment.attachment
        {
            
            heightForMediaImage.constant = 150
            if let poster = attachment.poster , poster != "<null>"
            {
                imageVideoOverlay.isHidden=false
                let url = URL(string: WebServiceName.images_baseurl.rawValue + poster)!
                mediaImage.loadGif(url:url)
            }
            else
            {
                imageVideoOverlay.isHidden=true
                let url = URL(string: WebServiceName.images_baseurl.rawValue + (comment.attachment?.file!)!)
                mediaImage.loadGif(url:url!)
                
            }
        }
        else
        {
            imageVideoOverlay.isHidden=true
            heightForMediaImage.constant = 0
        }
         mediaImageCustomization()
        let desc = self.comment.comment?.html2String
        var mention_array = [String]()
        if self.comment.json_data != nil{
            let jsonObj = JSON.init(parseJSON: self.comment.json_data!)
            if let json_data_array = jsonObj.array{
                print(jsonObj.rawValue)
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
        commentLabel.createMentions(array: mention_array, color: UIColor.init(hex: "7CC244")) { (clicked_word) in
            print(clicked_word)
            print(self.post.json_data ?? "te")
            if self.post.json_data == nil{
                return
            }
            let jsonObj = JSON.init(parseJSON: self.comment.json_data!)
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

        }
        commentLabel.text = desc
        if let l = comment.likesCount{
        likeLabel.text = "(" + String(l) + ")" 
        }else{
        likeLabel.text = "(0)"
        }
        if let m = comment.likedCount{
        if m == 1{
            self.likeIconImage.image = #imageLiteral(resourceName: "like-icon-highlighted")
        }else{
            self.likeIconImage.image = #imageLiteral(resourceName: "like-icon-normal")
        }
        }else{
            self.likeIconImage.image = #imageLiteral(resourceName: "like-icon-normal")
        }
        userNameLabel.text = comment.user?.first_name
        if (comment.user?.special_icon?.characters.count)! > 6 {
            profilePictureImageViewTop.isHidden = false
            var linked = URL(string: WebServiceName.images_baseurl.rawValue + (comment.user?.special_icon?.RemoveSpace())!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
             profilePictureImageViewTop.af_setImage(withURL: linked)
        }else {
            profilePictureImageViewTop.isHidden = true
        }
        
        let pointsColor = comment.user?.pointsColor
        userNameLabel.textColor = pointsColor

        if let profilePicUrlString = comment.user?.profilePictureURL, profilePicUrlString != "" {
            let url = URL(string: profilePicUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            profilePictureImageView.af_setImage(withURL: url)

        }
        else {
            profilePictureImageView.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
            profilePictureImageView.tintColor = pointsColor
        }
    }

    var profileButtonAction: ((String) -> Void)?
    var menuButtonCommentAction: ((UIButton) -> Void)?
    @IBAction func menuButtonTapped(_ sender: Any)   {
        menuButtonCommentAction?(menuButton)
    }
    @IBAction func profileButtonTapped(_ sender: Any) {
        let btn = sender as! UIButton
        var userId: String!
        // TODO: Fix to comment user
        switch btn.tag {
        case 10, 11:
            userId = post.user!.id!.stringValue
        case 12:
            userId = post.shared_user!.id!.stringValue
        default: // case 10
            userId = post.user!.id!.stringValue
        }
        profileButtonAction?(userId)
    }
}



