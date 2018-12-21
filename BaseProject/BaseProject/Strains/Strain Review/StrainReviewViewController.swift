//
//  StrainReviewViewController.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import AVKit
import ObjectMapper

class StrainReviewViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource, CameraDelegate, UITextViewDelegate {

    @IBOutlet var tbleView_Strain : UITableView!
    
    var txtCommentText = ""
    var DetailStrain  = Strain()
    var typeComment = "Type your comment here"
    var mainIndex : Int = 0
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var editView: UIView!
    var editIndex = -1
    var editTableArray = [String]()
    var editAttachment = Attachment()
    var ischooseGallery = false
    var array_Attachment = [Attachment]()
    var chooseStrain  = Strain()
    var ratingCount  = 5
    var IDMain  = ""
    var delegate: StrainDetailViewController!
    var deleteImageReview = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXIB()
        editTableLoad()
        self.editTableView.separatorStyle = .none
        self.editView.isHidden = true
        self.tbleView_Strain.register(UINib(nibName: "Commentcell", bundle: nil), forCellReuseIdentifier: "Commentcell")
         NotificationCenter.default.addObserver(self, selector: #selector(self.reportComment), name: NSNotification.Name(rawValue: "StrainReport"), object: nil)
        
        // Do any additional setup after loading the view.
    }

    func registerXIB(){
        self.editTableView.register(UINib(nibName: "TypeCommectStrainCell", bundle: nil), forCellReuseIdentifier: "TypeCommectStrainCell")
        self.editTableView.register(UINib(nibName: "AddImageStrainCell", bundle: nil), forCellReuseIdentifier: "AddImageStrainCell")
        self.editTableView.register(UINib(nibName: "ShoeMediaCell", bundle: nil), forCellReuseIdentifier: "ShoeMediaCell")
        self.editTableView.register(UINib(nibName: "StrainRatingcell", bundle: nil), forCellReuseIdentifier: "StrainRatingcell")
        self.tbleView_Strain.register(UINib(nibName: "GoogleAddCell", bundle: nil), forCellReuseIdentifier: "GoogleAddCell")
        
        self.editTableView.register(UINib(nibName: "SubmitcommentStrainCell", bundle: nil), forCellReuseIdentifier: "SubmitcommentStrainCell")
    }
    func GetDetailAPI(){
        self.showLoading()
        var mainUrl = WebServiceName.get_strain_detail.rawValue
        if IDMain.characters.count == 0 {
            mainUrl = WebServiceName.get_strain_detail.rawValue + String(describing: self.chooseStrain.strainID!.intValue)
        }else {
            mainUrl = WebServiceName.get_strain_detail.rawValue + IDMain
        }
        IDMain = ""
        print(mainUrl)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (success, message, dataMain) in
            self.hideLoading()
            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
                    print(dataMain["successData"]! as! [String : Any])
                    self.DetailStrain = Mapper<Strain>().map(JSONObject: dataMain["successData"]! as! [String : Any])!
                    print(self.DetailStrain)
                    if let strin : Strain =  self.DetailStrain.strain {
                        if let data = dataMain["successData"]! as? [String : Any] {
                            if let top_strain = data["top_strain"] as? [String : Any] {
                                if let coutLike = top_strain["get_likes_count"] as? Int {
                                    if coutLike > 4 {
                                        if let strain_dis = top_strain["description"] as? String {
                                            strin.overview = strain_dis
                                        }
                                    }
                                }else if let coutLike = top_strain["get_likes_count"] as? String {
                                    if Int(coutLike)! > 4 {
                                        if let strain_dis = top_strain["description"] as? String {
                                            strin.overview = strain_dis
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        self.chooseStrain = strin
                        print(self.chooseStrain.images?.count as Any)
                        print(self.DetailStrain.images?.count as Any)
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                        
                        self.tbleView_Strain.setNeedsLayout()
                        self.tbleView_Strain.layoutIfNeeded()
                        self.tbleView_Strain.reloadData()
                    }
                }else {
                    if (dataMain["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tbleView_Strain.reloadData()
        
    }
    func editTableLoad(){
        editTableArray.removeAll()
        editTableArray.append("TextView")
        if self.editAttachment.ID != "-1"{
            editTableArray.append("UploadButton")
        }else{
            editTableArray.append("Image")
        }
        editTableArray.append("AddRating")
        editTableArray.append("SubmitAction")
        editTableView.reloadData()
    }
    
    func editAction(sender: UIButton!){
        if self.DetailStrain.strain?.strainReview![sender.tag].attachment?.attachment != nil{
            self.editAttachment.image_URL = (self.DetailStrain.strain?.strainReview![sender.tag].attachment?.attachment)!
            self.editAttachment.ID = "-1"
        }
        self.editView.isHidden = false
        self.editIndex = sender.tag
        editTableLoad()
        
    }
    @IBAction func removeEditView(sender: UIButton!){
        editView.isHidden = true
    }
    func deleteAction(sender: UIButton!){
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this review?") { (isComp, btnNum) in
            if isComp {
                self.deleteReview(index: sender.tag)
            }
        }
     
    }
    
    func deleteReview(index: Int!){
        var newPAram = [String : AnyObject]()
        newPAram["strain_review_id"] = self.DetailStrain.strain?.strainReview![index].id as AnyObject
        
        
        print(newPAram)
        self.showLoading()
        
        NetworkManager.PostCall(UrlAPI: WebServiceName.delete_strain_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
            self.hideLoading()
            
            if successResponse {
                if (DataResponse["status"] as! String) == "success" {
                    
                    self.DetailStrain.strain?.strainReview?.remove(at: index)
                    //                        if self.editedCellIndex != -1{
                    //                            self.editCommentView.isHidden = true
                    //                            self.editedCellIndex = -1
                    //                        }
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
    
    @IBAction func BAck(sender : UIButton){
        delegate.isRefreshonWillAppear = true
        self.navigationController?.popViewController(animated: true)
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
            self.txtCommentText = textView.text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(textView.text.characters.count)
        self.txtCommentText = textView.text
        var cell: TypeCommectStrainCell!
        let index = IndexPath.init(row: textView.tag, section: 0)
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        if self.editIndex != -1{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text =  "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. 500 Characters"
            }else{
                cell = (editTableView.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text =  "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }else{
            if (isBackSpace == -92) {
                if textView.text.dropLast() == ""{
                    cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. 500 Characters"
                    return true
                }else{
                    cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                    cell.lblcont.text = "Max. \(textView.text.characters.count - 1)/500 Characters"
                    return true
                }
            }
            if textView.text + text == ""{
                cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. 500 Characters"
            }else{
                cell = (tbleView_Strain.cellForRow(at: index) as! TypeCommectStrainCell)
                cell.lblcont.text = "Max. \(textView.text.characters.count + 1)/500 Characters"
            }
        }
        var textTemp = textView.text.count + text.count
        if textTemp > 499 {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == editTableView{
            return editTableArray.count
        }else{
           return (self.DetailStrain.strain?.strainReview?.count)! //+ (Int( (self.DetailStrain.strain?.strainReview?.count)!/10))
        }
    }
    func CommentAddCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellCommentAdd = tableView.dequeueReusableCell(withIdentifier: "TypeCommectStrainCell") as! TypeCommectStrainCell
        cellCommentAdd.txtViewMain.tag = indexPath.row
        cellCommentAdd.txtViewMain.delegate = self as? UITextViewDelegate
        if editIndex != -1{
            cellCommentAdd.txtViewMain.text = self.DetailStrain.strain?.strainReview![editIndex].review
        }
        
        if self.txtCommentText != "" {
            cellCommentAdd.txtViewMain.text = self.txtCommentText
        }
        cellCommentAdd.selectionStyle = .none
        return cellCommentAdd
    }
    func AddImageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "AddImageStrainCell") as! AddImageStrainCell
        cellAddImage.btnUploadNew.addTarget(self, action: #selector(self.addImage), for: .touchUpInside)
        cellAddImage.selectionStyle = .none
        return cellAddImage
    }
    
    func addImage(sender : UIButton){
        
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
        ischooseGallery = false
        self.disableMenu()
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        newAttachment.video_URL = gifURL.absoluteString
        self.editAttachment = newAttachment
        self.editTableLoad()
        ischooseGallery = false
        self.disableMenu()
    }
    func captured(image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.editAttachment = newAttachment
        self.editTableLoad()
        ischooseGallery = false
        self.disableMenu()
    }
    //    func UploadImageOnGallery(image: UIImage){
    //        self.showLoading()
    //        var newPAram = [String : AnyObject]()
    //        newPAram["strain_id"] = self.chooseStrain.strainID?.stringValue as AnyObject
    //        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.upload_strain_image.rawValue, image: image, withParams: newPAram, onView: self) { (MainData) in
    //            print(MainData)
    //            self.hideLoading()
    //            if MainData["status"] as! String == "success" {
    //                let newImage = StrainImage()
    //                let dataMain = MainData["successData"] as! [String : AnyObject]
    //                newImage.id = dataMain["id"] as? NSNumber
    //                newImage.image_path = dataMain["image_path"] as? String
    //                newImage.liked = 0
    //                newImage.disliked = 0
    //
    //                self.chooseStrain.images?.append(newImage)
    //                self.DetailStrain.images?.append(newImage)
    //            }
    //        }
    //    }
    
    func MediaChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "ShoeMediaCell") as! ShoeMediaCell
        
        
        let mianAttachment = self.editAttachment
        
        if editIndex != -1 && editAttachment.image_URL != ""{
            cellMedia.imgViewImage.moa.url = WebServiceName.images_baseurl.rawValue + editAttachment.image_URL
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
    
    func DeleteImageAction(sender : UIButton){
        self.deleteImageReview = 1
        self.editAttachment = Attachment()
        self.array_Attachment.removeAll()
        editTableLoad()
    }
    
    
    func AddStrainRatingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "StrainRatingcell") as! StrainRatingcell
        
        if editIndex != -1{
            
            cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain0B")
            cellMedia.imgview_Star5.image = #imageLiteral(resourceName: "Strain0B")
            let rating = self.DetailStrain.strain?.strainReview![editIndex].rating?.doubleValue
            ratingCount = Int(rating!)
            if rating == 1 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
            }else if rating == 2 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
            }else if rating == 3 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
            }else if rating == 4 {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
            }else {
                cellMedia.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                cellMedia.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                cellMedia.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                cellMedia.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                cellMedia.imgview_Star5.image = #imageLiteral(resourceName: "Strain5B")
            }
        }

        cellMedia.btn_Star1.tag = 1
        cellMedia.btn_Star2.tag = 2
        cellMedia.btn_Star3.tag = 3
        cellMedia.btn_Star4.tag = 4
        cellMedia.btn_Star5.tag = 5
        cellMedia.btn_Star1.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star2.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star3.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star4.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.btn_Star5.addTarget(self, action: #selector(self.RateImageTap), for: .touchUpInside)
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    func RateImageTap(sender : UIButton){
        let tableSubviews = self.editTableView.subviews
        
        self.ratingCount = sender.tag
        
        for indexObj in tableSubviews{
            if let cellMain = indexObj as? StrainRatingcell {
                
                cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain0B")
                cellMain.imgview_Star5.image = #imageLiteral(resourceName: "Strain0B")
                
                
                if sender.tag == 1 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                }else if sender.tag == 2 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                }else if sender.tag == 3 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                }else if sender.tag == 4 {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                    cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                }else {
                    cellMain.imgview_Star1.image = #imageLiteral(resourceName: "Strain1B")
                    cellMain.imgview_Star2.image = #imageLiteral(resourceName: "Strain2B")
                    cellMain.imgview_Star3.image = #imageLiteral(resourceName: "Strain3B")
                    cellMain.imgview_Star4.image = #imageLiteral(resourceName: "Strain4B")
                    cellMain.imgview_Star5.image = #imageLiteral(resourceName: "Strain5B")
                }
            }
        }
    }
    
    func SubmitStrainComment(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMedia = tableView.dequeueReusableCell(withIdentifier: "SubmitcommentStrainCell") as! SubmitcommentStrainCell
        cellMedia.btnSubmit.addTarget(self, action: #selector(self.submitAction), for: .touchUpInside)
        if editIndex != -1{
            cellMedia.btnSubmit.setTitle("UPDATE COMMENT", for: .normal)
        }else {
            cellMedia.btnSubmit.setTitle("SUBMIT COMMENT", for: .normal)
        }
        cellMedia.selectionStyle = .none
        return cellMedia
    }
    
    func submitAction(sender : UIButton){
        var textviewText = ""
        
        var findRow = -1
        
        for index in 0..<self.editTableArray.count {
            var cellMain: UITableViewCell!
            cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
            if cellMain is TypeCommectStrainCell {
                findRow = index
                let cellNew = cellMain as! TypeCommectStrainCell
                textviewText = cellNew.txtViewMain.text!
            }
        }
        
        if textviewText == "Type your comment here" {
            self.ShowErrorAlert(message: "Enter comment!")
            return
        }
        if textviewText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            self.ShowErrorAlert(message: "Enter comment!")
            return
        }
        
        
        var newPAram = [String : AnyObject]()
        newPAram["strain_id"] = self.chooseStrain.strainID?.stringValue as AnyObject
        newPAram["review"] = textviewText as AnyObject
        newPAram["rating"] = String(ratingCount) as AnyObject
        var reviewID = self.DetailStrain.strain?.strainReview![editIndex].id!.intValue
        newPAram["strain_review_id"] = String(reviewID!) as AnyObject
        if deleteImageReview == 1{
            newPAram["delete_attachment"] = deleteImageReview as AnyObject
        }
        
        if editIndex != -1 && editAttachment.ID == "-1" && editAttachment.image_URL == "" {
            self.array_Attachment.removeAll()
            self.array_Attachment.append(editAttachment)
        }
        if self.array_Attachment.count == 0 {
            self.showLoading()
            print(newPAram)
            NetworkManager.PostCall(UrlAPI: WebServiceName.add_strain_review.rawValue, params: newPAram, completion: { (successResponse, messageResponse, DataResponse) in
                self.hideLoading()
                print(DataResponse)
                if successResponse {
                    if (DataResponse["status"] as! String) == "success" {
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex != -1{
                            cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                            cellMain  = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }
                        
                        cellMain.txtViewMain.text = ""
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        self.array_Attachment.removeAll()
                        self.GetDetailAPI()
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
            if self.array_Attachment[0].is_Video {
                self.showLoading()
                print(newPAram)
                NetworkManager.UploadVideo( WebServiceName.add_strain_review.rawValue, imageMain: self.array_Attachment[0].image_Attachment, urlVideo: (URL.init(string: self.array_Attachment[0].video_URL)!), withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    print(MainData)
                    if (MainData["status"] as! String) == "success" {
                        
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex == -1{
                            cellMain  = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                            cellMain  = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }
                        self.array_Attachment.removeAll()
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        
                        cellMain.txtViewMain.text = ""
                        
                        
                        self.GetDetailAPI()
                    }else {
                        if (MainData["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                })
            }else {
                self.showLoading()
                print(newPAram)
                var gifDataUrl : URL? = nil
                if let gif_url = URL.init(string: (self.array_Attachment[0].video_URL)){
                    gifDataUrl = gif_url
                }
                NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_strain_review.rawValue, image: self.array_Attachment[0].image_Attachment,gif_url: gifDataUrl, withParams: newPAram, onView: self, completion: { (MainData) in
                    self.hideLoading()
                    print(MainData)
                    
                    if (MainData["status"] as! String) == "success" {
                        
                        var cellMain: TypeCommectStrainCell!
                        if self.editIndex != -1{
                            cellMain = self.editTableView.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }else{
                            cellMain = self.tbleView_Strain.cellForRow(at: IndexPath.init(row: findRow, section: 0)) as! TypeCommectStrainCell
                        }
                        self.array_Attachment.removeAll()
                        if self.editIndex != -1{
                            self.editView.isHidden = true
                            self.editIndex = -1
                        }
                        
                        cellMain.txtViewMain.text = ""
                        
                        self.GetDetailAPI()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == editTableView{
            switch editTableArray[indexPath.row] {
            case "TextView":
                return CommentAddCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "UploadButton":
                return AddImageCell(tableView:tableView  ,cellForRowAt:indexPath)
            case "Image":
                return MediaChooseCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "AddRating":
                return AddStrainRatingCell(tableView:tableView  ,cellForRowAt:indexPath)
                
            case "SubmitAction":
                return SubmitStrainComment(tableView:tableView  ,cellForRowAt:indexPath)
                
            default:
                
                return SubmitStrainComment(tableView:tableView  ,cellForRowAt:indexPath)
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
        let cellCommentHeader = tableView.dequeueReusableCell(withIdentifier: "Commentcell") as! Commentcell
        let decreased_index = (Int(indexPath.row/10))
        let index = indexPath.row// - decreased_index
        cellCommentHeader.lbl_Name.text = self.DetailStrain.strain!.strainReview![index].get_user!.first_name
        if (self.DetailStrain.strain!.strainReview![index].get_user!.special_icon?.characters.count)! > 6 {
            cellCommentHeader.ImgView_UserTop.isHidden = false
            cellCommentHeader.ImgView_UserTop.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![index].get_user!.special_icon!.RemoveSpace()
        }else {
            cellCommentHeader.ImgView_UserTop.isHidden = true
        }
        if let newUser = self.DetailStrain.strain!.strainReview![index].get_user {
            
            if (newUser.image_path != nil) {
                if((newUser.image_path?.contains("facebook.com"))! || (newUser.image_path?.contains("google.com"))!){
                    cellCommentHeader.ImgView_User.moa.url = newUser.image_path!.RemoveSpace()
                }else {
                    cellCommentHeader.ImgView_User.moa.url = WebServiceName.images_baseurl.rawValue + newUser.image_path!.RemoveSpace()
                }
            
            }else {
                if newUser.avatar != nil {
                    cellCommentHeader.ImgView_User.moa.url = WebServiceName.images_baseurl.rawValue + newUser.avatar!.RemoveSpace()
                }
            }
            
        }
        
        cellCommentHeader.ImgView_User.RoundView()
        
        cellCommentHeader.lbl_Message.applyTag(baseVC: self , mainText: self.DetailStrain.strain!.strainReview![index].review!)
        
        cellCommentHeader.lbl_Message.text = self.DetailStrain.strain!.strainReview![index].review
        if self.DetailStrain.strain!.strainReview![index].rating != nil {
            cellCommentHeader.Lbl_Rating.text =  "\(self.DetailStrain.strain!.strainReview![index].rating?.intValue ?? 0)"
        }else {
            cellCommentHeader.Lbl_Rating.text = "0"
        }
        cellCommentHeader.Lbl_Time.text = self.getDateWithTh(date: self.DetailStrain.strain!.strainReview![index].created_at!)// self.DetailStrain.strain!.strainReview![index].created_at?.UTCToLocal(inputFormate: Constants.defaultDateFormate, outputFormate: "dd MMM yyyy")
        if Double(cellCommentHeader.Lbl_Rating.text!)! < 1.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain0B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 2.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain1B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 3.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain2B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 4.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain3B")
        }else if Double(cellCommentHeader.Lbl_Rating.text!)! < 5.0 {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain4B")
        }else {
            cellCommentHeader.ImgView_Star.image = #imageLiteral(resourceName: "Strain5B")
        }
        if(self.DetailStrain.strain!.strainReview![index].is_reviewed_count == "0"){
            cellCommentHeader.reveiwLikeBtn.isSelected = false
        }else{
            cellCommentHeader.reveiwLikeBtn.isSelected = true
        }
        cellCommentHeader.likesCount.text = String(self.DetailStrain.strain!.strainReview![index].likes_count!)
        cellCommentHeader.reveiwLikeBtn.tag = index
        cellCommentHeader.reveiwLikeBtn.addTarget(self, action: #selector(self.Likereview), for: .touchUpInside)
        cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "QAReport")
        cellCommentHeader.lbl_title_report.textColor = UIColor.init(hex: "7D7D7D")
        if self.DetailStrain.strain!.strainReview![index].is_user_flaged_count != nil {
            if self.DetailStrain.strain!.strainReview![index].is_user_flaged_count == 1 {
                cellCommentHeader.ImgView_Flag.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                cellCommentHeader.ImgView_Flag.tintColor = UIColor.init(hex: "F4B927")
                cellCommentHeader.lbl_title_report.textColor = UIColor.init(hex: "F4B927")
            }
        }
        var iD = Int((DataManager.sharedInstance.user?.ID)!)
        if self.DetailStrain.strain!.strainReview![index].get_user?.id?.intValue == iD{
            cellCommentHeader.commentDeleteView.isHidden = false
            cellCommentHeader.commentEditView.isHidden = false
             cellCommentHeader.flagView.isHidden = true
            cellCommentHeader.flagViewWidth.constant = 0
            cellCommentHeader.commentDeleteViewWidth.constant = 30
            cellCommentHeader.commentEditViewWidth.constant = 30
        }else{
            
            cellCommentHeader.flagViewWidth.constant = 108
            cellCommentHeader.commentDeleteView.isHidden = true
            cellCommentHeader.commentEditView.isHidden = true
            cellCommentHeader.flagView.isHidden = false
            cellCommentHeader.commentDeleteViewWidth.constant = 0
            cellCommentHeader.commentEditViewWidth.constant = 0
        }
        
        if(self.DetailStrain.strain!.strainReview![index].is_reviewed_count == "0"){
            cellCommentHeader.reveiwLikeBtn.isSelected = false
            cellCommentHeader.reveiwLikeBtn.setImage(#imageLiteral(resourceName: "like_Up_White"), for: .normal)
        }else{
            cellCommentHeader.reveiwLikeBtn.isSelected = true
            cellCommentHeader.reveiwLikeBtn.setImage(#imageLiteral(resourceName: "like_Up_White").withRenderingMode(.alwaysTemplate), for: .selected)
            cellCommentHeader.reveiwLikeBtn.tintColor = UIColor.init(hex: "f4c42f")
        }
        
        if(self.DetailStrain.strain!.strainReview![index].attachment == nil){
            cellCommentHeader.attachmentViewHeight.constant = 0
        }else{
            cellCommentHeader.attachmentViewHeight.constant = 56
        }
        
        cellCommentHeader.commentEditButton.tag = index
        cellCommentHeader.commentEditButton.addTarget(self, action: #selector(self.editAction), for: .touchUpInside)
        cellCommentHeader.commentDeleteButton.tag = index
        cellCommentHeader.commentDeleteButton.addTarget(self, action: #selector(self.deleteAction), for: .touchUpInside)
        cellCommentHeader.Btn_Flag.addTarget(self, action: #selector(self.CommentFlag), for: .touchUpInside)
        cellCommentHeader.Btn_Flag.tag = index
        cellCommentHeader.Btn_share.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
        cellCommentHeader.Btn_share.tag = index
        cellCommentHeader.Btn_UserProfile.addTarget(self, action: #selector(self.USerProfile), for: .touchUpInside)
        cellCommentHeader.Btn_UserProfile.tag = index
        cellCommentHeader.view_Attachment.isHidden = false
        cellCommentHeader.ImgView_Video.isHidden = true
        cellCommentHeader.Btn_Attachment.tag = index
        if self.DetailStrain.strain!.strainReview![index].attachment != nil {
            if self.DetailStrain.strain!.strainReview![index].attachment!.id!.intValue > 0 {
                cellCommentHeader.view_Attachment.isHidden = false
                if self.DetailStrain.strain!.strainReview![index].attachment!.type == "video" {
                    cellCommentHeader.ImgView_Attachment.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![index].attachment!.poster!.RemoveSpace()
                    cellCommentHeader.ImgView_Video.image = #imageLiteral(resourceName: "Video_play_icon_White")
                    cellCommentHeader.ImgView_Video.isHidden = false
                }else {
                    cellCommentHeader.ImgView_Attachment.moa.url = WebServiceName.images_baseurl.rawValue + self.DetailStrain.strain!.strainReview![index].attachment!.attachment!.RemoveSpace()
                     cellCommentHeader.ImgView_Video.image = #imageLiteral(resourceName: "Gallery_White")
                    
                }
                
                cellCommentHeader.Btn_Attachment.addTarget(self, action: #selector(self.OpenAttachment), for: .touchUpInside)
            }
        }
        cellCommentHeader.selectionStyle = .none
        return cellCommentHeader
    }
    func Likereview(sender : UIButton){
        var test = self.DetailStrain.strain!.strainReview![sender.tag]
        var param = [String : Any] ()
        if(test.is_reviewed_count == "0"){
            //TODO FOR LIKE
            self.DetailStrain.strain!.strainReview![sender.tag].is_reviewed_count = "1"
            self.DetailStrain.strain!.strainReview![sender.tag].likes_count = self.DetailStrain.strain!.strainReview![sender.tag].likes_count! + 1
            param["like_val"] = "1" as AnyObject
        }else {
            self.DetailStrain.strain!.strainReview![sender.tag].is_reviewed_count = "0"
            self.DetailStrain.strain!.strainReview![sender.tag].likes_count = self.DetailStrain.strain!.strainReview![sender.tag].likes_count! - 1
            param["like_val"] = "0" as AnyObject
            //TODO FOR DISLIKE
        }
        param["review_id"] = test.id as AnyObject
        param["strain_id"] = test.strain_id as AnyObject
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: "add_strain_review_like", params: param as [String:AnyObject]) { (success, message, response) in
            self.hideLoading()
            print(success)
            
            print(message)
            print(response)
            if(success){
                self.tbleView_Strain.reloadData()
            }
        }
    }
    func CommentFlag(sender : UIButton){
        self.mainIndex = sender.tag
        if (self.DetailStrain.strain!.strainReview![mainIndex].get_user?.id?.intValue)! != Int((DataManager.sharedInstance.user?.ID)!){
            if self.DetailStrain.strain!.strainReview![mainIndex].is_user_flaged_count != 1 {
                self.openStrainFlag()
            }else{
                self.ShowErrorAlert(message: "Review already reported!")
            }
        }else {
            self.ShowErrorAlert(message: "You can't report your own review!")
        }
    }
    func reportComment(notification:NSNotification){
        if let userInfo = notification.userInfo as? [String: AnyObject]
        {
            self.view.showLoading()
            var param = [String : AnyObject]()
            param["is_flaged"] = "1" as AnyObject
            param["strain_id"] = self.DetailStrain.strain!.strainID?.intValue as AnyObject
            param["reason"] =  userInfo["value"]
            param["strain_review_id"] =  self.DetailStrain.strain!.strainReview![self.mainIndex].id?.intValue as AnyObject
            print(param)
            let mainUrl = WebServiceName.flag_strain_review.rawValue
            NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
                print(dataResponse)
                self.view.hideLoading()
                if successRespons {
                    if (dataResponse["successMessage"] as? String) != nil {
                       let data  = self.DetailStrain.strain!.strainReview![self.mainIndex]
                        data.is_user_flaged_count = 1
                        self.DetailStrain.strain!.strainReview![self.mainIndex] = data
                        self.tbleView_Strain.reloadRows(at: [IndexPath.init(row: self.mainIndex, section: 0)], with: .fade)
                    }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            }
        }
    }
    func USerProfile(sender : UIButton){
        self.OpenProfileVC(id: "\(self.DetailStrain.strain!.strainReview![sender.tag].get_user!.id!.intValue)")
    }
    func shareAction(sender : UIButton){
        var parmas = [String: Any]()
        parmas["id"] = "\(self.DetailStrain.strain!.strainReview![sender.tag].id!.intValue)"
        parmas["type"] = "Strain"//\(self.DetailStrain.strain!.strainReview![sender.tag].id!.intValue)" + "/" + "
        let link : String = Constants.ShareLinkConstant + "strain-details/\((self.DetailStrain.strain!.strainID!.intValue))"
        self.OpenShare(params:parmas,link: link, content:self.DetailStrain.strain!.title!)
    }
    
    
    func OpenAttachment(sender : UIButton){
        
        if self.DetailStrain.strain!.strainReview![sender.tag].attachment!.id!.intValue > 0 {
            if self.DetailStrain.strain!.strainReview![sender.tag].attachment?.type == "video" {
                let video_path =  WebServiceName.videos_baseurl.rawValue + (self.DetailStrain.strain!.strainReview![sender.tag].attachment?.attachment)!
                let player = AVPlayer(url:  NSURL(string: video_path)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }else {
                
                let image_path =  self.DetailStrain.strain!.strainReview![sender.tag].attachment?.attachment
                self.showImagess( attachments: [image_path!])
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
//                vc.urlMain = image_path
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }

}
