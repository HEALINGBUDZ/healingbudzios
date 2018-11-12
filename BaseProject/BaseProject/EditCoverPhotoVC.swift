//
//  EditCoverPhotoVC.swift
//  BaseProject
//
//  Created by MAC MINI on 17/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EditCoverPhotoVC: BaseViewController{
    var orignal_image  : UIImage?
    @IBOutlet weak var lbl_user_name: UILabel!
    @IBOutlet weak var user_profile_img: CircularImageView!
    @IBOutlet weak var user_profile_imgTop: UIImageView!
    @IBOutlet weak var upload_cross_btn_view: UIView!
    @IBOutlet weak var upload_view: UIView!
    @IBOutlet weak var upload_viewBtn: UIButton!
    @IBOutlet weak var Img_cover: UIImageView!
    
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var scrollView: FAScrollView!
    
    private var croppedImage: UIImage? = nil
    var userMain = UserProfileViewController.userMain//: User? = nil
    var isSelecCoverImage : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func isSquareImage() -> Bool{
        let image = scrollView.imageToDisplay
        if image?.size.width == image?.size.height { return true }
        else { return false }
    }

    
//    func onClickcloseView(){
////       self.Back()
//    }
    override func viewWillAppear(_ animated: Bool) {
        if self.userMain != nil  && !self.isSelecCoverImage{
            self.isSelecCoverImage = false
            self.lbl_user_name.text = self.userMain.userFirstName
            if self.userMain.profilePictureURL.contains("facebook.com") || self.userMain.profilePictureURL.contains("google.com"){
                self.user_profile_img.moa.url = ((self.userMain.profilePictureURL).RemoveSpace())
            }else{
                self.user_profile_img.moa.url = WebServiceName.images_baseurl.rawValue + ((self.userMain.profilePictureURL).RemoveSpace())
            }
            
            self.user_profile_img.RoundView()
            if self.userMain.special_icon.count > 6 {
                              self.user_profile_imgTop.isHidden = false
                self.user_profile_imgTop.moa.url = WebServiceName.images_baseurl.rawValue +  ((self.userMain.special_icon.trimmingCharacters(in: .whitespaces)).RemoveSpace())
            }else {
                self.user_profile_imgTop.isHidden = true
            }
            print(WebServiceName.images_baseurl.rawValue + ((self.userMain.coverPhoto).RemoveSpace()))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.Back()
    }
    @IBAction func onClickCrossPopUp(_ sender: Any) {
         self.Back()
    }
    @IBAction func onClickSave(_ sender: Any) {
        if self.scrollView.imageToDisplay == nil {
            return
        }
        
        croppedImage = captureVisibleRect()
        if croppedImage != nil{
        let newAttachment = Attachment()
        newAttachment.is_Video = false
            newAttachment.image_Attachment =  croppedImage!
        newAttachment.ID = "-1"
        self.showLoading()
            NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_cover.rawValue, image: croppedImage!, onView: self, completion: { (MainResponse) in
                NetworkManager.UploadFiles(kBaseURLString + WebServiceName.update_cover_orignal_image.rawValue, image: self.orignal_image!, onView: self, completion: { (MainResponse) in
                    print(MainResponse)
                    self.hideLoading()
                    self.Back()
                })
          })
        }
    }
    
    private func captureVisibleRect() -> UIImage{
        
        var croprect = CGRect.zero
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
        let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixImageOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        
        return cropped
        
    }
    @IBAction func onClickUploadbtn(_ sender: Any) {
        self.user_profile_img.isHidden = true
         self.user_profile_imgTop.isHidden = true
         self.lbl_user_name.isHidden = true
        self.isSelecCoverImage = true
        self.upload_view.isHidden = true
        self.upload_viewBtn.isHidden = true
        self.upload_cross_btn_view.isHidden = true
        let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
        vcCamera.delegate = self
        vcCamera.isOnlyImage = true
        vcCamera.profileDeletegate = self
        self.navigationController?.pushViewController(vcCamera, animated: true)
    }
    func displayPopUp(){
        self.isSelecCoverImage = false
        self.upload_view.isHidden = false
        self.upload_viewBtn.isHidden = false
        self.upload_cross_btn_view.isHidden = false
    }
    
}

extension EditCoverPhotoVC : CameraDelegate {
    func gifData(gifURL: URL, image: UIImage) {
        self.orignal_image = image
        self.scrollView.imageToDisplay = image
        self.scrollView.minimumZoomScale = 2.0
        self.scrollView.setZoomScale(2.0, animated: true)
    }
    func captured(image: UIImage) {
        self.orignal_image = image
        self.scrollView.imageToDisplay = image
        self.scrollView.minimumZoomScale = 2.0
        self.scrollView.setZoomScale(2.0, animated: true)
    }
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
    }
}
