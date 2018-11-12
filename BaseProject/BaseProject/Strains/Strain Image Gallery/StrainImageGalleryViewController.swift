//
//  StrainImageGalleryViewController.swift
//  BaseProject
//
//  Created by macbook on 31/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ObjectMapper
class StrainImageGalleryViewController: BaseViewController , CameraDelegate , UITableViewDelegate, UITableViewDataSource , EFImageViewZoomDelegate{

    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var MainCollectionView2: UICollectionView!
    var StrainMain = Strain()
     @IBOutlet var view_filter : UIView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblImagCunter : UILabel!
    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var lblReview : UILabel!
    @IBOutlet var lblRating : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblUploadedBy : UILabel!
    @IBOutlet var lblImageTime : UILabel!
    @IBOutlet var lblImageLikeCount : UILabel!
    @IBOutlet var lblImageDiLikeCount : UILabel!
    
    @IBOutlet weak var btnDownloadImage: UIButton!
    @IBOutlet var imgViewRating : UIImageView!
    @IBOutlet var imgViewLike : UIImageView!
    @IBOutlet var imgViewBigImage : UIImageView!
    @IBOutlet var imgViewDislike : UIImageView!
    @IBOutlet var imgViewFlagImage : UIImageView!
    
    @IBOutlet var tbleViewFilter: UITableView!
    
    var reportValue = StrainReport.Answer.rawValue
     @IBOutlet weak var image_indicator: UIImageView!
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    
     var array_filter = [[String : String]]()
    var imageGallery = [StrainImage]()
    var chooseImage = StrainImage()
    var isFilterOpen = false
    @IBOutlet var View_FullImage : UIView!
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image_indicator.image = #imageLiteral(resourceName: "QAMenuUp").withRenderingMode(.alwaysTemplate)
        self.image_indicator.tintColor = UIColor.init(hex: "F4B927")
        
        self.tbleViewFilter.register(UINib(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.MainCollectionView.addSubview(refreshControl)
       // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDownloadImagePressed(_ sender: Any) {
        if self.MainCollectionView.isHidden {
            if let cell = MainCollectionView2.cellForItem(at: self.MainCollectionView2.indexPathsForVisibleItems.first!) as? MainGalleryCell{
                _ = self.imageGallery[self.MainCollectionView2.indexPathsForVisibleItems.first!.row]
                if cell.imgViewMainZoom.image != nil {
                    self.saveImageInGallery(img: cell.imgViewMainZoom.image!)
                }
            }
        }
    }
    @objc func RefreshAPICall(sender:AnyObject){
        //        self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        //        self.pageNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.getStrainDetailId(id: "\((self.StrainMain.strainID!))")
            //            self.APICAllForMyAnswers(page:  0)
            //            self.isRefreshCall = true
            //            self.getPosts()
//            self.view_Save.isHidden = true
//            self.GetDetailAPI()
//            self.surveyStartView = self.GetView(nameViewController: "StrainSurveyViewController", nameStoryBoard: "SurveyStoryBoard") as! StrainSurveyViewController
        })
        
    }
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            if isFilterOpen{
                isFilterOpen = false
                self.MainCollectionView.isScrollEnabled = true
                self.MainCollectionView.isUserInteractionEnabled = true
                
                self.MainCollectionView2.isScrollEnabled = true
                self.MainCollectionView2.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.View_FullImage.alpha = 1.0
                    self.MainCollectionView.alpha = 1.0
                    self.MainCollectionView2.alpha = 1.0
                    self.FilterTopValue.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if isRefreshonWillAppear {
            View_FullImage.isHidden = true
            self.MainCollectionView.isHidden = false
            
            if self.StrainMain.images != nil {
                self.imageGallery = self.StrainMain.images!
            }
            
            
            self.lblType.text = self.StrainMain.strainType?.title
            self.lblName.text = self.StrainMain.title
            self.lblHeading.text = "Strain Gallery"
            self.lblReview.text = String(format:"%d", (self.StrainMain.get_review_count!.intValue)) + " Reviews"
            
            self.lblRating.text = "0.0"
            if (self.StrainMain.rating != nil) {
                if ((self.StrainMain.rating?.total) != nil) {
                        self.lblRating.text = String(format:"%.1f", (self.StrainMain.rating?.total!.doubleValue)!)
                }
            }
            
            if Double(self.lblRating.text!)! < 1.0 {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain0B")
            }else if Double(self.lblRating.text!)! < 2.0 {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain1B")
            }else if Double(self.lblRating.text!)! < 3.0 {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain2B")
            }else if Double(self.lblRating.text!)! < 4.0 {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain3B")
            }else if Double(self.lblRating.text!)! < 5.0 {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain4B")
            }else {
                self.imgViewRating.image = #imageLiteral(resourceName: "Strain5B")
            }
            
            self.MainCollectionView.reloadData()
            self.MainCollectionView2.reloadData()
        }
        self.isRefreshonWillAppear = false
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    @IBAction func onClickUserProfile(_ sender: Any) {
        if let id = self.chooseImage.user?.id?.intValue {
             self.OpenProfileVC(id: "\(id)")
        }
       
    }
}



extension StrainImageGalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == MainCollectionView {
            return CGSize.init(width: (collectionView.bounds.size.width/2) - 10 , height: (collectionView.bounds.size.width/2) - 10)

        }else {
            return CGSize.init(width: collectionView.bounds.size.width - 10 , height: collectionView.bounds.size.height)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGallery.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay")
        print(indexPath)
        
        
        if collectionView == MainCollectionView2 {
            DispatchQueue.main.async {
                self.chooseImage = self.imageGallery[indexPath.row]
                self.lblImagCunter.text = "\(indexPath.row + 1)/\(self.imageGallery.count)"
                self.ReloadBigImageData()
            }
            
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        cell.backgroundColor = UIColor.clear
        cell.indicator.isHidden = false
        cell.indicator.startAnimating()
        if collectionView != MainCollectionView {
             cell.imgViewMain.contentMode = .scaleAspectFit
        }else {
            cell.imgViewMain.contentMode = .scaleAspectFill
            
        }
        if collectionView == MainCollectionView {
            let item = self.imageGallery[indexPath.row]
            if item.is_approved == 0 {
                cell.imgViewPending.isHidden = false
            }else {
                cell.imgViewPending.isHidden = true
            }
            if item.user_id?.intValue == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)! {
                cell.viewDelete.isHidden = false
            }else {
                cell.viewDelete.isHidden = true
            }
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.deletePic), for: .touchUpInside)
            cell.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.imageGallery[indexPath.row].image_path!.RemoveSpace())) { (img, error, chache, url) in
                cell.imgViewMain.backgroundColor = UIColor.clear
                cell.indicator.isHidden = true
            }
        }else{
            cell.imgViewMainZoom._delegate = self
            UIImageView().sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.imageGallery[indexPath.row].image_path!.RemoveSpace())) { (img, error, chache, url) in
                cell.imgViewMain.backgroundColor = UIColor.clear
                cell.indicator.isHidden = true
                cell.imgViewMain.image = nil
                cell.imgViewMainZoom.image = img
            }
        }
       
        return cell
    }
    @objc func deletePic(send:UIButton){
        let item = self.imageGallery[send.tag]
        self.deleteCustomeAlert(title: "Delete Picture", discription: "Are you sure you want to delete this picture?", btnTitle1: "No", btnTitle2: "Yes") { (IsHas, has) in
            if IsHas {
                self.showLoading()
                NetworkManager.GetCall(UrlAPI: "delete_strain_image/" + "\((item.id?.intValue)!)") { (IsDone, Message, Response) in
                    self.hideLoading()
                    if IsDone {
                        self.getStrainDetailId(id: "\((self.StrainMain.strainID!))")
                    }else {
                        self.ShowSuccessAlertWithNoAction(message: "Message")
                    }
                }
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        print(indexPath)
        print(self.imageGallery.count)
        if collectionView == MainCollectionView {
            View_FullImage.isHidden = false
            let cellMain = collectionView.cellForItem(at: indexPath) as! MainGalleryCell
            self.imgViewBigImage.image = cellMain.imgViewMain.image
            self.chooseImage = self.imageGallery[indexPath.row]
            self.imgViewBigImage.isHidden = true
            
            self.lblImagCunter.text = "\(indexPath.row + 1)/\(self.imageGallery.count)"
            self.ReloadBigImageData()
            
            self.MainCollectionView2.scrollToItem(at: indexPath, at: .left, animated: false)
            self.MainCollectionView.isHidden = true
        }
        
    }
    
    
    func ReloadBigImageData(){
        
        
        if self.chooseImage.like_count != nil {
            self.lblImageLikeCount.text = self.chooseImage.Image_like_count
        }else {
            self.lblImageLikeCount.text = "0"
        }
        
        if self.chooseImage.dis_like_count != nil {
            self.lblImageDiLikeCount.text = self.chooseImage.Image_Dilike_count
        }else {
            self.lblImageDiLikeCount.text = "0"
        }
   
        
        if self.chooseImage.flagged{
                self.imgViewFlagImage.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                self.imgViewFlagImage.tintColor = UIColor.init(hex: "F4B927")
        }else{
            self.imgViewFlagImage.image = #imageLiteral(resourceName: "flag_white")
        }
        
        if self.chooseImage.liked != nil {
            if Int(self.chooseImage.liked!) == 1 {
                self.imgViewLike.image = #imageLiteral(resourceName: "like_Up_Green").withRenderingMode(.alwaysTemplate)
                self.imgViewLike.tintColor = UIColor.init(hex: "F4B927")
                self.imgViewDislike.image = #imageLiteral(resourceName: "like_Down_White")
            }else {
                self.imgViewLike.image = #imageLiteral(resourceName: "like_Up_White")
            }
        }else {
            self.imgViewLike.image = #imageLiteral(resourceName: "like_Up_White")
        }
        
        
        
        if self.chooseImage.disliked != nil {
            if Int(self.chooseImage.disliked!) == 1 {
                self.imgViewDislike.image = #imageLiteral(resourceName: "like_Down_Green").withRenderingMode(.alwaysTemplate)
                self.imgViewDislike.tintColor = UIColor.init(hex: "F4B927")
                self.imgViewLike.image = #imageLiteral(resourceName: "like_Up_White")
            }else {
                self.imgViewDislike.image = #imageLiteral(resourceName: "like_Down_White")
            }
        }else {
            self.imgViewDislike.image = #imageLiteral(resourceName: "like_Down_White")
        }
        self.lblUploadedBy.text =  self.chooseImage.user?.first_name
        if  let points  = self.chooseImage.user?.points?.intValue {
            self.lblUploadedBy.textColor = self.getColor(point: points)
        }
       
        self.lblImageTime.text = self.getDateWithTh(date: self.chooseImage.created_at!)//GetDateWith(formate: "MMMM dd, yyyy", inputFormat: "yyyy-MM-dd HH:mm:ss")
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            return self.ReportHeadingCell(tableView, cellForRowAt: indexPath)
        }else if indexPath.row == self.array_filter.count - 1 {
            
            return self.SendButtonCell(tableView, cellForRowAt: indexPath)
            
        }else {
            return self.ReportOptionCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            if indexPath.row == 0 || indexPath.row == self.array_filter.count - 1 {
                
            }else {
                for index in 1..<self.array_filter.count - 1 {
                    
                    if indexPath.row == index {
                        let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleS")
                        tbleviewCell.view_BG.isHidden = false
                        self.ChooseReportOption(value: index)
                        
                    }else {
                        let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAReasonCell
                        tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleE")
                        tbleviewCell.view_BG.isHidden = true
                    }
                }
                
            }
    }
    
    func ChooseReportOption(value : Int){
        
//        print("value \(value)")
        switch value {
        case 1:
            self.reportValue = StrainReport.Nudity.rawValue
            break
        case 2:
            self.reportValue = StrainReport.harassment.rawValue
            break
        case 3:
            self.reportValue = StrainReport.violent.rawValue
            break
        case 4:
            self.reportValue = StrainReport.Answer.rawValue
            break
        case 5:
            self.reportValue = StrainReport.Spam.rawValue
            break
        case 6:
            self.reportValue = StrainReport.Unrelated.rawValue
            break
            
        default:
            break;
        }
    }

    
}

//MARK:
//MARK: Button Actions
extension StrainImageGalleryViewController {
    @IBAction func Back_Action(sender : UIButton){
        if self.MainCollectionView.isHidden {
            self.View_FullImage.isHidden = true
            self.MainCollectionView.isHidden = false
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()

    }
    
    
    
    @IBAction func Upload_Action(sender : UIButton){
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    
    
    func UploadImageOnGallery(image: UIImage,gif_url:URL? = nil){
        self.showLoading()
        var newPAram = [String : AnyObject]()

        newPAram["strain_id"] = self.StrainMain.strainID?.stringValue as AnyObject
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.upload_strain_image.rawValue, image: image,gif_url:gif_url, withParams: newPAram, onView: self) { (MainData) in
            self.hideLoading()
            if MainData["status"] as! String == "success" {
                let newImage = StrainImage()
                let dataMain = MainData["successData"] as! [String : AnyObject]
                newImage.id = dataMain["id"] as? NSNumber
                newImage.image_path = dataMain["image_path"] as? String
                newImage.liked = 0
                newImage.disliked = 0
                newImage.Image_like_count = "0"
                newImage.Image_Dilike_count = "0"
                newImage.dis_like_count = [LikeDislikeCount]()
                newImage.like_count = [LikeDislikeCount]()
                newImage.created_at = dataMain["created_at"] as? String
                var map = [String: AnyObject]()
                map["id"] = NSNumber(value:Int((DataManager.sharedInstance.user?.ID)!)!)
                map["first_name"] = DataManager.sharedInstance.user?.userFirstName as AnyObject
                map["image_path"] = DataManager.sharedInstance.user?.profileImage
                map["avatar"] = DataManager.sharedInstance.user?.avatarImage as AnyObject
                map["points"] = NSNumber(value:Int((DataManager.sharedInstance.user?.Points)!)!)
                newImage.user = StrainUser(JSON: map)
                let pot = Int((DataManager.sharedInstance.user?.Points)!)
                newImage.user!.points =  NSNumber(value:pot!)
                newImage.user!.first_name = DataManager.sharedInstance.user?.userFirstName
                
//                self.imageGallery.append(newImage)
//                self.MainCollectionView.reloadData()
//                self.MainCollectionView2.reloadData()
                self.ShowSuccessAlertWithNoAction(message: "Thanks bud! Your image has been submitted for approval.")
            }
        }
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        

        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        
        self.UploadImageOnGallery(image: image,gif_url: gifURL)
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        
        self.UploadImageOnGallery(image: image)
    }
    
    
    @IBAction func Like_Action(sender : UIButton){
        var newparam = [String : AnyObject]()
        var isLikedImage = 0
        if (self.chooseImage.liked != nil) {
            if self.chooseImage.liked!.intValue == 0 {
                newparam["is_like"] = "1" as AnyObject
                isLikedImage = 1
            }else {
                newparam["is_like"] = "0" as AnyObject
                isLikedImage = 0
            }
        }else {
             newparam["is_like"] = "1" as AnyObject
        }
        newparam["strain_image_id"] = self.chooseImage.id?.stringValue as AnyObject

        
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_image_strain_like.rawValue, params: newparam) { (successMain, messageResponse, successResponse) in

            self.hideLoading()
            
            
            if (self.chooseImage.disliked != nil) {
                if self.chooseImage.disliked!.intValue == 1 {
                    self.chooseImage.disliked = 0
                    self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! - 1)
                }
            }
            
            print(self.chooseImage.Image_Dilike_count)
            
            if successMain{
                if (successResponse["status"] as! String) == "success" {
                    var successDataMain = successResponse["successData"] as! [String : Any]
                    
                    let likeCount = successDataMain["is_liked"] as! Int
                    
                        if (self.chooseImage.liked != nil)
                        {
                                if likeCount > 0
                                {
                                    self.chooseImage.liked = 1
                                    self.chooseImage.Image_like_count = String(Int(self.chooseImage.Image_like_count!)! + 1)
                                }else
                                {
                                     self.chooseImage.liked = 0
                                    self.chooseImage.Image_like_count = String(Int(self.chooseImage.Image_like_count!)! - 1)
                                }
                        }else {
                            self.chooseImage.liked = 1
                            self.chooseImage.Image_like_count = String(Int(self.chooseImage.Image_like_count!)! + 1)
                            
                        }
                }else {
                    if (successResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        if let error_msg = successResponse["errorMessage"] as? String{
                            self.ShowErrorAlert(message:error_msg)
                        }else{
                            self.ShowErrorAlert(message:"Try again later!")
                        }
                        
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
                
                
            
            
          
            
            var index = 0
            for indexObj in self.imageGallery {
                if indexObj.id == self.chooseImage.id {
                    self.imageGallery[index] = self.chooseImage
                }
                
                index = index + 1
            }
            self.lblImagCunter.text = "\(index + 1)/\(self.imageGallery.count)"
            self.ReloadBigImageData()
            
        }
        
    }
    
    @IBAction func DiLike_Action(sender : UIButton){
        var newparam = [String : AnyObject]()
        if (self.chooseImage.disliked != nil) {
            if self.chooseImage.disliked!.intValue == 0 {
                newparam["is_disliked"] = "1" as AnyObject
            }else {
                newparam["is_disliked"] = "0" as AnyObject
            }
        }else {
            newparam["is_disliked"] = "1" as AnyObject
        }
        newparam["strain_image_id"] = self.chooseImage.id?.stringValue as AnyObject
//        self.chooseImage.liked = 0
//        if self.chooseImage.Image_like_count != nil {
//            if Int(self.chooseImage.Image_like_count!)! > 0 {
//                self.chooseImage.Image_like_count = String(Int(self.chooseImage.Image_like_count!)! - 1)
//            }
//        }
        self.showLoading()
        NetworkManager.PostCall(UrlAPI: WebServiceName.save_user_image_strain_dislike.rawValue, params: newparam) { (successMain, messageResponse, successResponse) in
            
            self.hideLoading()
            
            
            if (self.chooseImage.liked != nil) {
                if self.chooseImage.liked!.intValue == 1 {
                    self.chooseImage.liked = 0
                    self.chooseImage.Image_like_count = String(Int(self.chooseImage.Image_like_count!)! - 1)
                }
            }
            
            if successMain{
                if (successResponse["status"] as! String) == "success" {
                    var successDataMain = successResponse["successData"] as! [String : Any]
                    
                    let likeCount = successDataMain["is_disliked"] as! Int
                    
                    if (self.chooseImage.disliked != nil)
                    {
                        if likeCount > 0
                        {
                            self.chooseImage.disliked = 1
                            self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! + 1)
                        }else
                        {
                            self.chooseImage.disliked = 0
                            self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! - 1)
                        }
                    }else {
                        self.chooseImage.disliked = 1
                        self.chooseImage.Image_Dilike_count = "1"
                        
                    }
                }else {
                    if (successResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }else{
                        if let error_msg = successResponse["errorMessage"] as? String{
                            self.ShowErrorAlert(message:error_msg)
                        }else{
                            self.ShowErrorAlert(message:"Try again later!")
                        }
                        
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            
            
            
            
            
            var index = 0
            for indexObj in self.imageGallery {
                if indexObj.id == self.chooseImage.id {
                    self.imageGallery[index] = self.chooseImage
                }
                
                index = index + 1
            }
            self.lblImagCunter.text = "\(index + 1)/\(self.imageGallery.count)"
            self.ReloadBigImageData()
            
        }
        
    }
    
    
    
//            if (self.chooseImage.disliked != nil) {
//                if self.chooseImage.disliked!.intValue == 0 {
//                    self.chooseImage.disliked = 1
//                    if Int(self.chooseImage.Image_Dilike_count!)! > 0 {
//                        self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! + 1)
//                    }else {
//                        self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! - 1)
//                    }
//                }else {
//                    self.chooseImage.disliked = 1
//                    self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! + 1)
//                }
//            }else {
//                self.chooseImage.disliked = 1
//                self.chooseImage.Image_Dilike_count = String(Int(self.chooseImage.Image_Dilike_count!)! + 1)
//            }
//
//            self.ReloadBigImageData()
//
//        }
//    }
    
    @IBAction func Flag_Action(sender : UIButton){
        
        if !self.chooseImage.flagged{
            self.ShowFilterView(sender: sender)
        }else{
            self.ShowErrorAlert(message: "Photo already reported!")
        }
        
    }
}


//MARK: View Filter
extension StrainImageGalleryViewController {
    func RefreshFilterArray(){
        self.array_filter.removeAll()
        
        
        
        var dataDict = [String : String]()
        dataDict["image"] = "CircleE"
        dataDict["name"] = "Report"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "CircleE"
        dataDict2["name"] = "Spam"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "CircleE"
        dataDict3["name"] = "Unrelated"
        
        var dataDict4 = [String : String]()
        dataDict4["image"] = "CircleE"
        dataDict4["name"] = "Nudity or sexual content"
        
        var dataDict7 = [String : String]()
        dataDict7["image"] = "CircleE"
        dataDict7["name"] = "Harssment or hate speech"
        
        var dataDict6 = [String : String]()
        dataDict6["image"] = "CircleE"
        dataDict6["name"] = "Threatening, violent or concerning"
        
        var dataDict5 = [String : String]()
        dataDict5["image"] = ""
        dataDict5["name"] = ""
        
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict4)
        self.array_filter.append(dataDict7)
        self.array_filter.append(dataDict6)
        self.array_filter.append(dataDict2)
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict3)
        self.array_filter.append(dataDict5)
        
        self.tbleViewFilter.reloadData()
    }
    
    @IBAction func ShowFilterView(sender : UIButton){
        isFilterOpen = true
        self.MainCollectionView.isScrollEnabled = false
        self.MainCollectionView.isUserInteractionEnabled = false
        
        self.MainCollectionView2.isScrollEnabled = false
        self.MainCollectionView2.isUserInteractionEnabled = false
        self.RefreshFilterArray()
        UIView.animate(withDuration: 0.5, animations: {
            self.MainCollectionView.alpha  = 0.2
             self.MainCollectionView2.alpha  = 0.2
            self.View_FullImage.alpha = 0.2
            self.FilterTopValue.constant = -420 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func HideFilterView(sender : UIButton){
        isFilterOpen = false
        self.MainCollectionView.isScrollEnabled = true
        self.MainCollectionView.isUserInteractionEnabled = true
        
        self.MainCollectionView2.isScrollEnabled = true
        self.MainCollectionView2.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.MainCollectionView.alpha  = 1.0
            self.MainCollectionView2.alpha  = 1.0
            self.View_FullImage.alpha = 1.0
            self.FilterTopValue.constant = 40 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.view_filter{
                isFilterOpen = false
                self.MainCollectionView.isScrollEnabled = true
                self.MainCollectionView.isUserInteractionEnabled = true
                self.MainCollectionView2.isScrollEnabled = true
                self.MainCollectionView2.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.MainCollectionView.alpha  = 1.0
                    self.MainCollectionView2.alpha  = 1.0
                    self.View_FullImage.alpha = 1.0
                    self.FilterTopValue.constant = 40 // heightCon is the IBOutlet to the constraint
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    func ReportHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAHeadingcell") as! QAHeadingcell
        
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func SendButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QASendButtonCell") as! QASendButtonCell
        cellFilter.btn_Send.backgroundColor = UIColor.init(hex: "F4B927")
        cellFilter.btn_Send.addTarget(self, action:#selector(self.APICAllForFlag), for: UIControlEvents.touchUpInside)
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    
    func ReportOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAReasonCell") as! QAReasonCell
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"]
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
        cellFilter.selectionStyle = .none
        cellFilter.selected_line.backgroundColor = UIColor.init(hex: "F4B927")
        if indexPath.row == 1 {
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
            cellFilter.view_BG.isHidden = false
        }else{
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
            cellFilter.view_BG.isHidden = true
        }
        return cellFilter
    }
    
    func APICAllForFlag(){
        if reportValue.count == 0 {
            self.ShowErrorAlert(message: "Please choose reason for reporting.")
            return
        }
        
        self.view.showLoading()
        
        var param = [String : AnyObject]()
        param["strain_image_id"] = self.chooseImage.id as AnyObject
        param["is_flagged"] = "1" as AnyObject
        param["reason"] = reportValue as AnyObject
        
        let mainUrl = WebServiceName.save_user_image_strain_flag.rawValue
        
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            
            if successRespons {
                if let successMessage = dataResponse["successMessage"] as? String {
                    
                    self.HideFilterView(sender: UIButton.init())
                    
                    
                    var index = 0
                    for indexObj in self.imageGallery {
                        if indexObj.id?.stringValue == self.chooseImage.id?.stringValue {
                            indexObj.flagged = true
                            self.imageGallery[index] = indexObj
                            break
                        }
                        index = index + 1
                    }
            
                    self.imgViewFlagImage.image = #imageLiteral(resourceName: "ic_flag_strain").withRenderingMode(.alwaysTemplate)
                    self.imgViewFlagImage.tintColor = UIColor.init(hex: "F4B927")
                    self.MainCollectionView.reloadData()
                    self.MainCollectionView2.reloadData()
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                    DataManager.sharedInstance.logoutUser()
                    self.ShowLogoutAlert()
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.MainCollectionView.reloadData()
            self.MainCollectionView2.reloadData()
        }
    }
}
extension StrainImageGalleryViewController {
    func getStrainDetailId(id : String) {
        self.showLoading()
        let mainUrl = WebServiceName.get_strain_detail.rawValue + id
        NetworkManager.GetCall(UrlAPI: mainUrl)
        { (success, message, dataMain) in
            self.hideLoading()
            print(dataMain)
            if success {
                if (dataMain["status"] as! String) == "success" {
                    print(dataMain["successData"]! as! [String : Any])
                    self.StrainMain = Mapper<Strain>().map(JSONObject: dataMain["successData"]! as! [String : Any])!
                    if let strin : Strain =  self.StrainMain.strain {
                        if let data = dataMain["successData"]! as? [String : Any] {
                            if let top_strain = data["top_strain"] as? [String : Any] {
                                if let strain_dis = top_strain["description"] as? String {
                                    strin.overview = strain_dis
                                }
                            }
                        }
                        self.StrainMain = strin
                        if self.StrainMain.images != nil {
                            self.imageGallery = self.StrainMain.images!
                        }
                        self.lblType.text = self.StrainMain.strainType?.title
                        self.lblName.text = self.StrainMain.title
                        self.lblHeading.text = "Strain Gallery"
                        self.lblReview.text = String(format:"%d", (self.StrainMain.get_review_count!.intValue)) + " Reviews"
                        self.lblRating.text = "0.0"
                        if (self.StrainMain.rating != nil) {
                            if ((self.StrainMain.rating?.total) != nil) {
                                self.lblRating.text = String(format:"%.1f", (self.StrainMain.rating?.total!.doubleValue)!)
                            }
                        }
                        if Double(self.lblRating.text!)! < 1.0 {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain0B")
                        }else if Double(self.lblRating.text!)! < 2.0 {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain1B")
                        }else if Double(self.lblRating.text!)! < 3.0 {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain2B")
                        }else if Double(self.lblRating.text!)! < 4.0 {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain3B")
                        }else if Double(self.lblRating.text!)! < 5.0 {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain4B")
                        }else {
                            self.imgViewRating.image = #imageLiteral(resourceName: "Strain5B")
                        }
                        self.MainCollectionView.reloadData()
                        self.MainCollectionView2.reloadData()

                        
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
}
