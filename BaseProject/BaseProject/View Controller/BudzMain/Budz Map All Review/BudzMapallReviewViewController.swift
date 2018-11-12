//
//  BudzMapallReviewViewController.swift
//  BaseProject
//
//  Created by waseem on 14/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import AVKit

class BudzMapallReviewViewController: BaseViewController ,CameraDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var slected_review : Int = 0
    @IBOutlet var tbleView_Strain : UITableView!
    var txtCommentTxt = ""
    var typeComment = "Type your comment here..."
    @IBOutlet weak var editCommentView: UIView!
    @IBOutlet weak var editCommentTableView: UITableView!
    var editTableArray = [String]()
    var replyEditTableArray = [String]()
    var editAttachment = Attachment()
    @IBOutlet weak var replyEditView: UIView!
    @IBOutlet weak var replyEditTableView: UITableView!
    var replyEditIndex = -1
    var editedCellIndex = -1
    var budz_map_id : String =  ""
    var delegate: DispensaryDetailVC!
    var chooseBudzMap = BudzMap()
    var deleteImageReview = 0
    var rating = 1.0
    var replyUpdating = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyEditTableView.separatorStyle = .none
        editCommentTableView.separatorStyle = .none
        editCommentView.isHidden = true
        replyEditView.isHidden = true
        self.editCommentTableView.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
        self.editCommentTableView.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.editCommentTableView.register(UINib(nibName: "UploadBudzCell", bundle: nil), forCellReuseIdentifier: "UploadBudzCell")
        self.editCommentTableView.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.editCommentTableView.register(UINib(nibName: "AddRatingcell", bundle: nil), forCellReuseIdentifier: "AddRatingcell")
        self.editCommentTableView.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        
        self.replyEditTableView.register(UINib(nibName: "AddYourCommentCell", bundle: nil), forCellReuseIdentifier: "AddYourCommentCell")
        self.replyEditTableView.register(UINib(nibName: "EnterCommentCell", bundle: nil), forCellReuseIdentifier: "EnterCommentCell")
        self.replyEditTableView.register(UINib(nibName: "SubmitBudzCell", bundle: nil), forCellReuseIdentifier: "SubmitBudzCell")
        
        self.tbleView_Strain.register(UINib(nibName: "BudzCommentcell", bundle: nil), forCellReuseIdentifier: "BudzCommentcell")
        
         self.tbleView_Strain.register(UINib(nibName: "GoogleAddCell", bundle: nil), forCellReuseIdentifier: "GoogleAddCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reportReview), name: NSNotification.Name(rawValue: "BudzFlagReview"), object: nil)
        
        editTableLoad()
        replyEditTableLoad()
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == typeComment {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = typeComment
        }else{
            self.txtCommentTxt = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(textView.text.characters.count)
        self.txtCommentTxt = textView.text
        var cell: EnterCommentCell!
        let index = IndexPath.init(row: textView.tag, section: 0)
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        if self.editedCellIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text =  "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. 500 Characters"
            }else{
                cell = (editCommentTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }else if self.replyEditIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                    cell.lblTextcount.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. 500 Characters"
            }else{
                cell = (replyEditTableView.cellForRow(at: index) as! EnterCommentCell)
                cell.lblTextcount.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }
        var textTemp = textView.text.count + text.count
        if textTemp > 499 {
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tbleView_Strain.reloadData()
        
    }
    
    func GetBudzMapDetail(){
    self.showLoading()
    
    var newURL : String = ""
    if self.budz_map_id.count == 0 {
    newURL =  WebServiceName.get_budz_profile.rawValue + String(self.chooseBudzMap.id)
    }else{
    newURL =  WebServiceName.get_budz_profile.rawValue + String(self.budz_map_id)
    }
    
    print(newURL)
    NetworkManager.GetCall(UrlAPI: newURL) { (successResponse, MessageResponse, DataResponse) in
    
    self.hideLoading()
    if successResponse {
    print(DataResponse as! [String : AnyObject])
    if (DataResponse["status"] as! String) == "success" {
    let mainData = DataResponse["successData"] as! [String : AnyObject]
    self.chooseBudzMap = BudzMap.init(json: mainData)
    print(mainData)
    }else {
    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
    DataManager.sharedInstance.logoutUser()
    self.ShowLogoutAlert()
    }
    }
    }else {
    self.ShowErrorAlert(message:MessageResponse)
    }
    self.tbleView_Strain.reloadData()
    
    }
    }
    
    func replyAction(sender: UIButton){
        replyEditView.isHidden = false
        self.replyEditIndex = sender.tag
        replyEditTableLoad()
    }
    
    func editCommentAction(sender: UIButton!){
        if self.chooseBudzMap.reviews[sender.tag].attachments.count != 0{
            self.editAttachment = self.chooseBudzMap.reviews[sender.tag].attachments[0]
            self.editAttachment.ID = "-1"
            
        }
        editCommentView.isHidden = false
        self.editedCellIndex = sender.tag
        editTableLoad()
    }
    
    
    func deleteCommentAction(sender: UIButton!){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this review?") { (isComp, btnNum) in
            if isComp {
               self.deleteReview(index: sender.tag)
            }
        }
       
    }
    
    func deleteReplyAction(sender: UIButton!){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this reply?") { (isComp, btnNum) in
            if isComp {
                self.deleteReply(index: sender.tag)
            }
        }
      
    }
    
    
    func Likereview(sender : UIButton){
        var test = self.chooseBudzMap.reviews[sender.tag]
        var param = [String : Any] ()
        if(test.is_reviewed_count == "0"){
            //TODO FOR LIKE
            self.chooseBudzMap.reviews[sender.tag].is_reviewed_count = "1"
            self.chooseBudzMap.reviews[sender.tag].likes_count = self.chooseBudzMap.reviews[sender.tag].likes_count + 1
            param["like_val"] = "1" as AnyObject
        }else {
            self.chooseBudzMap.reviews[sender.tag].is_reviewed_count = "0"
            self.chooseBudzMap.reviews[sender.tag].likes_count = self.chooseBudzMap.reviews[sender.tag].likes_count - 1
            param["like_val"] = "0" as AnyObject
            //TODO FOR DISLIKE
        }
        param["review_id"] = test.id as AnyObject
        param["budz_id"] = self.chooseBudzMap.id as AnyObject
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: "add_budz_review_like", params: param as [String:AnyObject]) { (success, message, response) in
            self.hideLoading()
            print(success)
            
            print(message)
            print(response)
            if(success){
                self.tbleView_Strain.reloadData()
            }
        }
    }
    
    func deleteReply(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["review_reply_id"] = self.chooseBudzMap.reviews[index].reply.id as AnyObject
        
        
        print(newPAram)
        self.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_budz_review_reply.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
            self.hideLoading()
            
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    
                    //                        if self.editedCellIndex != -1{
                    //                            self.editCommentView.isHidden = true
                    //                            self.editedCellIndex = -1
                    //                        }
                    self.chooseBudzMap.reviews[index].reply = nil
                    self.tbleView_Strain.reloadData()
                }else {
                    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        })
    }
    
    @IBAction func closeEditReview(sender: UIButton!){
        if !self.editCommentView.isHidden{
            self.editCommentView.isHidden = true
        }else  if !self.replyEditView.isHidden{
            self.replyEditView.isHidden = true
        }
        self.txtCommentTxt = ""
    }
    func deleteReview(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["review_id"] = self.chooseBudzMap.reviews[index].id as AnyObject
        
        
        print(newPAram)
        self.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_budz_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
            self.hideLoading()
            
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    self.chooseBudzMap.reviews.remove(at: index)
                    self.tbleView_Strain.reloadData()
                }else {
                    if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        })
    }

    func OpenCamera(){
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = false
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
            self.editAttachment = newAttachment
            self.editTableLoad()
        
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        newAttachment.video_URL = gifURL.absoluteString
        self.editAttachment = newAttachment
        self.editTableLoad()
        
        self.disableMenu()
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        
            self.editAttachment = newAttachment
            self.editTableLoad()
        
        self.disableMenu()
    }

    func DeleteImageAction(sender : UIButton){
            self.deleteImageReview = 1
            self.editAttachment = Attachment()
            self.editTableLoad()
    }
    func SubmitAction(sender : UIButton){
        
        txtCommentTxt = ""
        var textviewText = ""
        var ratingCount : Double = 5.0
        
        for index in 0..<self.chooseBudzMap.reviews.count {
            var cellMain: UITableViewCell!
            if editedCellIndex != -1{
                cellMain  = self.editCommentTableView.cellForRow(at: IndexPath.init(row: 1, section: 0))
            }else if replyEditIndex != -1{
                cellMain  = self.replyEditTableView.cellForRow(at: IndexPath.init(row: 1, section: 0))
            }
            if cellMain is EnterCommentCell {
                let cellNew = cellMain as! EnterCommentCell
                textviewText = cellNew.txtviewMain.text
//                cellNew.txtviewMain.text =  ""
            }else  if cellMain is AddRatingcell {
                let cellNew = cellMain as! AddRatingcell
                ratingCount = cellNew.viewRating.rating
            }
            
        }
        
        if textviewText == "Type your comment here..." {
            textviewText = ""
        }
        if textviewText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            self.ShowErrorAlert(message: "Enter comment")
            return
        }
        
        var newPAram = [String : AnyObject]()
        if replyEditIndex != -1{
            newPAram["review_id"] = self.chooseBudzMap.reviews[replyEditIndex].id as AnyObject
            newPAram["reply"] = textviewText as AnyObject
        }else{
            newPAram["sub_user_id"] = String(self.chooseBudzMap.id) as AnyObject
            newPAram["review"] = textviewText as AnyObject
            newPAram["rating"] = String(self.rating) as AnyObject
            newPAram["business_review_id"] = String(self.chooseBudzMap.reviews[editedCellIndex].id) as AnyObject
            if deleteImageReview == 1{
                newPAram["delete_attachment"] = deleteImageReview as AnyObject
            }
        }
        print(newPAram)
        if (editedCellIndex != -1 && (editAttachment.image_URL != "" || editAttachment.ID != "-1")) || replyEditIndex != -1{
            self.showLoading()
            var url = ""
            if replyEditIndex != -1{
                url = WebServiceName.add_budz_review_reply.rawValue
            }else{
                url = WebServiceName.add_budz_review.rawValue
            }
            NetworkManager.PostCall(UrlAPI: url, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
                self.hideLoading()
                
                if successResponse {
                    if (DataResponse["status"] as! String) == "success" {
                        
                        self.GetBudzMapDetail()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        if self.replyEditIndex != -1{
                            self.replyEditView.isHidden = true
                            self.replyEditIndex = -1
                        }
                        
                       self.tbleView_Strain.reloadData()
                    }else {
                        if (DataResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            })
        }else {
            if self.editAttachment.is_Video {
                self.showLoading()
                
                NetworkManager.UploadVideo( WebServiceName.add_budz_review.rawValue, imageMain: self.editAttachment.image_Attachment, urlVideo: (URL.init(string: self.editAttachment.video_URL)!), withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    
                    if (MainData["status"] as! String) == "success" {
                        self.editAttachment = Attachment()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        self.GetBudzMapDetail()
                        self.tbleView_Strain.reloadData()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                })
            }else {
                self.showLoading()
                var gifDataUrl : URL? = nil
                if let gif_url = URL.init(string: (self.editAttachment.video_URL)){
                    gifDataUrl = gif_url
                }
                
                NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_budz_review.rawValue, image: self.editAttachment.image_Attachment, gif_url: gifDataUrl,withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    
                    
                    if (MainData["status"] as! String) == "success" {
                        self.editAttachment = Attachment()
                        if self.editedCellIndex != -1{
                            self.editCommentView.isHidden = true
                            self.editedCellIndex = -1
                        }
                        self.GetBudzMapDetail()
                        self.tbleView_Strain.reloadData()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                    
                })
            }
        }
    }

    func editTableLoad(){
        editTableArray.removeAll()
        editTableArray.append("CommentHeader")
        editTableArray.append("TextView")
        if self.editAttachment.ID != "-1"{
            editTableArray.append("UploadButton")
        }else{
            editTableArray.append("Image")
        }
        editTableArray.append("AddRating")
        editTableArray.append("SubmitAction")
        
        editCommentTableView.reloadData()
    }
    
    func replyEditTableLoad(){
        replyEditTableArray.removeAll()
        replyEditTableArray.append("CommentHeader")
        replyEditTableArray.append("TextView")
        replyEditTableArray.append("SubmitAction")
        
        replyEditTableView.reloadData()
        
    }
    func reportReview() {
      let mainReview = self.chooseBudzMap.reviews[self.slected_review]
      mainReview.isFlag = 1
      self.chooseBudzMap.reviews[self.slected_review] = mainReview
      self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: self.slected_review, section: 0)], with: .fade)
    }
    
    @IBAction func BAck(sender : UIButton){
        self.delegate.isRefreshonWillAppear = true
        self.navigationController?.popViewController(animated: true)
    }
    func EnterCommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "EnterCommentCell") as! EnterCommentCell
        cellCommentHeader.txtviewMain.delegate = self
        cellCommentHeader.txtviewMain.tag = indexPath.row
        if editedCellIndex != -1{
            cellCommentHeader.txtviewMain.text = self.chooseBudzMap.reviews[editedCellIndex].text
            
        }else if replyEditIndex != -1{
            if self.chooseBudzMap.reviews[replyEditIndex].reply != nil{
                self.replyUpdating = true
                cellCommentHeader.txtviewMain.text = self.chooseBudzMap.reviews[replyEditIndex].reply.reply
            }else{
                cellCommentHeader.txtviewMain.text = "Type your comment here..."
                self.replyUpdating = false
            }
            
        }
        if self.txtCommentTxt.characters.count > 0 {
            cellCommentHeader.txtviewMain.text = self.txtCommentTxt
        }
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    
    
    func YourCommentHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "AddYourCommentCell") as! AddYourCommentCell
        if editedCellIndex != -1{
            cellCommentHeader.commentLabel.text = "Edit Your Comment Below"
        }else if replyEditIndex != -1{
            cellCommentHeader.commentLabel.text = "Add Reply"
        }
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    //MARK:
    //MARK: Upload button Cell
    func UPloadBudzButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellUploadBudz = tableView.dequeueReusableCell(withIdentifier: "UploadBudzCell") as! UploadBudzCell
        
        cellUploadBudz.btnUpload.addTarget(self, action: #selector(self.OpenCamera), for: .touchUpInside)
        
        cellUploadBudz.selectionStyle = .none
        return cellUploadBudz
    }
    
    
    //MARK:
    //MARK: Media Choose Cell
    func MediaChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "ShoeMediaCell") as! ShoeMediaCell
        
            
            
            let mianAttachment = self.editAttachment
            
        if editedCellIndex != -1 && mianAttachment.image_URL != ""{
            cellMedia.imgViewImage.moa.url = WebServiceName.images_baseurl.rawValue + mianAttachment.image_URL
        }else{
            cellMedia.imgViewImage.image = mianAttachment.image_Attachment
        }

            
            cellMedia.imgViewVideo.isHidden = true
            if mianAttachment.is_Video {
                cellMedia.imgViewVideo.isHidden = false
            }
            self.deleteImageReview = 0
            cellMedia.btnDelete.tag = 0
            cellMedia.btnDelete.addTarget(self, action: #selector(self.DeleteImageAction), for: .touchUpInside)
            
            
            cellMedia.selectionStyle = .none
        
        return cellMedia
    }
    
    
    //MARK:
    //MARK: RATING Cell
    func RatingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "AddRatingcell") as! AddRatingcell
        if editedCellIndex != -1{
            self.rating = chooseBudzMap.reviews[editedCellIndex].rating
            cellMedia.viewRating.rating = self.rating
        }else{
            cellMedia.viewRating.rating = 5.0
        }
        cellMedia.viewRating.settings.fillMode = .full
        cellMedia.viewRating.didTouchCosmos = { rating in
            cellMedia.viewRating.rating = rating
             self.rating = rating
//            self.editTableLoad()
        }
        cellMedia.viewRating.settings.minTouchRating = 1.0
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    //MARK:
    //MARK: Your Comment Heading Cell
    func SubmitCommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "SubmitBudzCell") as! SubmitBudzCell
        if tableView == replyEditTableView{
            cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
            if replyEditIndex != -1{
                cellMedia.btnSubmit.setTitle("SUBMIT REPLY", for: .normal)
                if self.replyUpdating{
                    cellMedia.btnSubmit.setTitle("UPDATE REPLY", for: .normal)
                }
            }
            cellMedia.selectionStyle = .none
            return cellMedia
        }else if tableView == editCommentTableView{
            cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
            cellMedia.btnSubmit.setTitle("UPDATE COMMENT", for: .normal)
            cellMedia.selectionStyle = .none
            return cellMedia
        }else{
            cellMedia.btnSubmit.addTarget(self, action: #selector(self.SubmitAction), for: .touchUpInside)
            cellMedia.selectionStyle = .none
            return cellMedia
        }
    }

    
    func shareAction(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.chooseBudzMap.reviews[sender.tag].id)"
        parmas["type"] = "Budz Reviews"
        parmas["budzNotSahre"] = "1"
        let link : String = Constants.ShareLinkConstant + "get-budz?business_id=\(self.chooseBudzMap.id)&business_type_id=\(self.chooseBudzMap.budzMapType.idType)" //"get-budz-review/\(self.chooseBudzMap.reviews[sender.tag].id)" + "/" + "\(self.chooseBudzMap.id)"
        self.OpenShare(params:parmas,link: link, content:self.chooseBudzMap.title)
    }
    
    func USerProfile(sender : UIButton){
        let mainReview = self.chooseBudzMap.reviews[sender.tag]
        self.OpenProfileVC(id: "\(mainReview.userMain.ID)")
    }
    
    func OpenAttachment(sender : UIButton){
        
        
        if self.chooseBudzMap.reviews[sender.tag].attachments[0].is_Video {
            let video_path =  WebServiceName.videos_baseurl.rawValue + self.chooseBudzMap.reviews[sender.tag].attachments[0].video_URL
            let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else {
            let image_path =  self.chooseBudzMap.reviews[sender.tag].attachments[0].image_URL
            self.showImagess(attachments: [image_path])
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
//            vc.urlMain = image_path
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func ReportComment(sender:UIButton){
        slected_review = sender.tag
        let mainReview = self.chooseBudzMap.reviews[sender.tag]
        if mainReview.isFlag == 0 {
            if mainReview.userMain.ID ==  DataManager.sharedInstance.user?.ID {
                self.ShowErrorAlert(message: "You can't report on your review!")
                return
            }
            isRefreshonWillAppear = true
            print(mainReview)
            self.openFlagAlert(id: "\(mainReview.id)")
        }else {
            self.ShowErrorAlert(message: "Review already reported!")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableView == editCommentTableView{
            return editTableArray.count
        }else if tableView == replyEditTableView{
            return replyEditTableArray.count
        }else{
          return self.chooseBudzMap.reviews.count //+ (Int(self.chooseBudzMap.reviews.count/10))
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == editCommentTableView{
            switch editTableArray[indexPath.row] {
            case "CommentHeader":
                return YourCommentHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "TextView":
                return EnterCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "UploadButton":
                return UPloadBudzButtonCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "Image":
                return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "AddRating":
                return RatingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "SubmitAction":
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            }
            
        }else if tableView == replyEditTableView{
            switch replyEditTableArray[indexPath.row] {
            case "CommentHeader":
                return YourCommentHeadingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "TextView":
                return EnterCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "SubmitAction":
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitCommentCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            }
        }else{
            if (false ) {//indexPath.row % 10 == 0 && indexPath.row > 8
                let add_cell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddCell") as! GoogleAddCell
                self.addBannerViewToView(add_cell.add_view)
                add_cell.selectionStyle = .none
                return add_cell
            }else{
                return CommentCell(tableView:tableView, cellForRowAt:indexPath)
            }
            
            
        }
    }
    
    func CommentCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "BudzCommentcell") as! BudzCommentcell
        let decreased_index = (Int(indexPath.row/10))
        let index = indexPath.row// - decreased_index
        
        
        let indexMain = index
        
        let mainReview = self.chooseBudzMap.reviews[indexMain]
        
        var newArray = [Any]()
        let budzId = String(describing: chooseBudzMap.user_id)
        if budzId == DataManager.sharedInstance.user?.ID{
            cellCommentHeader.replyButton.isHidden = false
            cellCommentHeader.replyImage.isHidden = false
        }else{
            cellCommentHeader.replyButton.isHidden = true
            cellCommentHeader.replyImage.isHidden = true
        }
        cellCommentHeader.likesCount.text = String(mainReview.likes_count)
        cellCommentHeader.Lbl_Description.applyTag(baseVC: self , mainText: mainReview.text)
        let r = Int(mainReview.rating)
        cellCommentHeader.Lbl_Rating.text = String(r)
        if mainReview.rating > 0 {
             cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "starFilled")
        }else{
             cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "starUnfilled")
        }
        cellCommentHeader.Lbl_Description.text = mainReview.text
        cellCommentHeader.Lbl_UserName.text = mainReview.userMain.userFirstName
        cellCommentHeader.Lbl_Time.text = self.getDateWithTh(date: mainReview.created_at)//.GetDateWith(formate: "dd MMM yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
        cellCommentHeader.Btn_UserProfile.addTarget(self, action: #selector(self.USerProfile), for: .touchUpInside)
        cellCommentHeader.Btn_UserProfile.tag = index
        cellCommentHeader.ImgView_USer.image = #imageLiteral(resourceName: "user_placeholder_Budz")
        if mainReview.userMain.profilePictureURL.contains("facebook.com") || mainReview.userMain.profilePictureURL.contains("google.com"){
             cellCommentHeader.ImgView_USer.moa.url = mainReview.userMain.profilePictureURL.RemoveSpace()
        }else{
             cellCommentHeader.ImgView_USer.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.userMain.profilePictureURL.RemoveSpace()
        }
        if mainReview.userMain.special_icon.characters.count > 6 {
            cellCommentHeader.ImgView_USerTop.isHidden = false
            cellCommentHeader.ImgView_USerTop.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.userMain.special_icon.RemoveSpace()
        }else {
            cellCommentHeader.ImgView_USerTop.isHidden = true
        }
        cellCommentHeader.ImgView_USer.RoundView()
        cellCommentHeader.view_Attachment1.isHidden = true
        cellCommentHeader.view_Attachment2.isHidden = true
        cellCommentHeader.view_Attachment3.isHidden = true
        
        cellCommentHeader.ImgView_Attachment1_Video.isHidden = true
        cellCommentHeader.ImgView_Attachment2_Video.isHidden = true
        cellCommentHeader.ImgView_Attachment3_Video.isHidden = true
        cellCommentHeader.attachmentView.isHidden = true
        cellCommentHeader.attachmentViewHeight.constant = 0
        let id = String(describing: mainReview.reviewed_by)
        if id == DataManager.sharedInstance.user?.ID{
            cellCommentHeader.commentEditView.isHidden = false
            cellCommentHeader.commentDeleteView.isHidden = false
            cellCommentHeader.commentEditViewWidth.constant = 20
            cellCommentHeader.commentDeleteViewWidth.constant = 20
            
            cellCommentHeader.falgViewBudz.isHidden = true
            cellCommentHeader.falgViewBudzWidth.constant = 0
        }else{
            cellCommentHeader.falgViewBudz.isHidden = false
            cellCommentHeader.falgViewBudzWidth.constant = 55
            cellCommentHeader.commentEditView.isHidden = true
            cellCommentHeader.commentDeleteView.isHidden = true
            cellCommentHeader.commentEditViewWidth.constant = 0
            cellCommentHeader.commentDeleteViewWidth.constant = 0
            
        }
        if mainReview.attachments.count > 0 {
            cellCommentHeader.attachmentView.isHidden = false
            cellCommentHeader.attachmentViewHeight.constant = 56
            cellCommentHeader.view_Attachment1.isHidden = false
            
            cellCommentHeader.ImgView_Attachment1.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[0].image_URL.RemoveSpace()
            
            cellCommentHeader.view_Attachment1.isHidden = false
            
            if mainReview.attachments[0].is_Video {
                cellCommentHeader.ImgView_Attachment1_Video.image = #imageLiteral(resourceName: "Video_play_icon_White")
                cellCommentHeader.ImgView_Attachment1_Video.isHidden = false
            }else{
                cellCommentHeader.ImgView_Attachment1_Video.image = #imageLiteral(resourceName: "Gallery_White")
            }
            
            cellCommentHeader.btn_Attachment1.addTarget(self, action: #selector(self.OpenAttachment), for: UIControlEvents.touchUpInside)
            
        }
        
        cellCommentHeader.btn_Attachment1.tag = indexMain
        if mainReview.is_reviewed_count == "1"{
            cellCommentHeader.reviewLikeButton.setImage(#imageLiteral(resourceName: "like_Up_White").withRenderingMode(.alwaysTemplate), for: .normal)
            cellCommentHeader.reviewLikeButton.tintColor = UIColor.init(hex: "992D7F")
        }else{
            cellCommentHeader.reviewLikeButton.setImage(#imageLiteral(resourceName: "like_Up_White"), for: .normal)
        }
        cellCommentHeader.reviewLikeButton.tag = indexMain
        cellCommentHeader.reviewLikeButton.addTarget(self, action: #selector(self.Likereview(sender:)), for: .touchUpInside)
        if let reply = mainReview.reply{
            cellCommentHeader.replyView.isHidden = false
            
            cellCommentHeader.replyButton.isHidden = true
            cellCommentHeader.replyImage.isHidden = true
            cellCommentHeader.replyViewHeight.constant = 137
            cellCommentHeader.replyDescription.text = reply.reply
            cellCommentHeader.replyTimeAgo.text = self.GetTimeAgo(StringDate: (reply.created_at)!)
            let id = reply.userId
            if id?.intValue == Int((DataManager.sharedInstance.user?.ID)!){
                cellCommentHeader.replyEditView.isHidden = false
                cellCommentHeader.replyDeleteView.isHidden = false
                cellCommentHeader.replyEditViewWidth.constant = 30
                cellCommentHeader.replyDeleteViewWidth.constant = 30
            }else{
                cellCommentHeader.replyEditView.isHidden = true
                cellCommentHeader.replyDeleteView.isHidden = true
                cellCommentHeader.replyEditViewWidth.constant = 0
                cellCommentHeader.replyDeleteViewWidth.constant = 0
                
            }
        }else{
            let budzId = String(describing: chooseBudzMap.user_id)
            if budzId == DataManager.sharedInstance.user?.ID{
                cellCommentHeader.replyButton.isHidden = false
                cellCommentHeader.replyImage.isHidden = false
            }else{
                cellCommentHeader.replyButton.isHidden = true
                cellCommentHeader.replyImage.isHidden = true
            }
            cellCommentHeader.replyViewHeight.constant = 0
            cellCommentHeader.replyView.isHidden = true
        }
        
        //        if mainReview.attachments.count > 1 {
        //            cellCommentHeader.view_Attachment2.isHidden = false
        //            cellCommentHeader.ImgView_Attachment2.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[1].image_URL.RemoveSpace()
        //
        //            cellCommentHeader.view_Attachment2.isHidden = false
        //
        //            if mainReview.attachments[1].is_Video {
        //                cellCommentHeader.ImgView_Attachment2_Video.isHidden = false
        //            }
        //        }
        
        
        
        //        if mainReview.attachments.count > 2 {
        //            cellCommentHeader.view_Attachment3.isHidden = false
        //            cellCommentHeader.ImgView_Attachment3.moa.url = WebServiceName.images_baseurl.rawValue + mainReview.attachments[2].image_URL.RemoveSpace()
        //
        //            cellCommentHeader.view_Attachment3.isHidden = false
        //
        //            if mainReview.attachments[2].is_Video {
        //                cellCommentHeader.ImgView_Attachment3_Video.isHidden = false
        //            }
        //        }
        //
        
        if mainReview.isFlag == 0 {
            cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "QAReport")
            cellCommentHeader.lbl_report_abuse.textColor =  UIColor.init(hex: "7D7D7D")
        }else {
            cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "ic_flag_budz")
            cellCommentHeader.lbl_report_abuse.textColor = UIColor.init(hex: "922F87")
        }
        cellCommentHeader.Btn_Report.tag = indexMain
        cellCommentHeader.Btn_Report.addTarget(self, action: #selector(self.ReportComment), for: UIControlEvents.touchUpInside)
        
        cellCommentHeader.Btn_Share.tag = indexMain
        cellCommentHeader.Btn_Share.addTarget(self, action: #selector(self.shareAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyButton.tag = indexMain
        cellCommentHeader.replyButton.addTarget(self, action: #selector(self.replyAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyEditButton.tag = indexMain
        cellCommentHeader.replyEditButton.addTarget(self, action: #selector(self.replyAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.commentEditButton.tag = indexMain
        cellCommentHeader.commentEditButton.addTarget(self, action: #selector(self.editCommentAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.commentDeleteButton.tag = indexMain
        cellCommentHeader.commentDeleteButton.addTarget(self, action: #selector(self.deleteCommentAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.replyDeleteButton.tag = indexMain
        cellCommentHeader.replyDeleteButton.addTarget(self, action: #selector(self.deleteReplyAction), for: UIControlEvents.touchUpInside)
        cellCommentHeader.selectionStyle = .none
    
    return cellCommentHeader
}

}
