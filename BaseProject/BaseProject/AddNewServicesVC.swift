//
//  AddNewServicesVC.swift
//  BaseProject
//
//  Created by Jawad on 10/4/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AddNewServicesVC: BaseViewController {
    @IBOutlet weak var page_title: UILabel!
    var isUpdate : Bool = false
    var budz_service  = BudzMapServices()
    @IBOutlet weak var btn_cancel: UIImageView!
    @IBOutlet weak var TF_services_name: UITextField!
    @IBOutlet weak var TF_charges: UITextField!
    var isImageSelected : Bool = false
    @IBOutlet weak var mediaCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var media_collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var selected_img: UIImageView!
    var uploadedImages : [String] = [String]()
    var sub_user_id :Int = 0
    var delegate:refreshDataDelgate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_cancel.isHidden = true
        if isUpdate{
            self.setData()
        }
    }
    
    func setData() {
        self.TF_services_name.text =  self.budz_service.name
        self.TF_charges.text =  self.budz_service.charges
        if self.budz_service.image.count > 4 {
            self.btn_cancel.isHidden = false
            self.selected_img.sd_setImage(with:URL.init(string:  WebServiceName.images_baseurl.rawValue + self.budz_service.image), completed: nil)
        }
         self.page_title.text = "Edit Service"
    }
    class func addNewService(id  : Int ,delegate :refreshDataDelgate)->AddNewServicesVC
    {
        let me = AddNewServicesVC(nibName: String(describing: AddNewServicesVC.self), bundle: nil)
        me.sub_user_id = id
        me.delegate = delegate
        return me
    }
    class func updateData(id  : Int , services : BudzMapServices ,delegate :refreshDataDelgate)->AddNewServicesVC
    {
        let me = AddNewServicesVC(nibName: String(describing: AddNewServicesVC.self), bundle: nil)
        me.sub_user_id = id
        me.delegate = delegate
        me.budz_service = services
        me.isUpdate = true
        return me
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickCancelImg(_ sender: Any) {
        if !self.btn_cancel.isHidden{
            self.isImageSelected = false
            self.selected_img.image = #imageLiteral(resourceName: "placeholder")
            self.btn_cancel.isHidden = true
        }
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        if self.TF_services_name.text?.count == 0 {
            self.ShowErrorAlert(message: "Service Name Required!")
            return
        }
        if self.TF_charges.text?.count == 0 {
            self.ShowErrorAlert(message: "Charges Required!")
            return
        }
        var url = "add_budz_service"
        if isUpdate {
            url = "add_budz_service"
        }
        if isImageSelected {
            var newParam = [String : AnyObject]()
            if isUpdate {
               newParam["id"] = self.budz_service.id as AnyObject
            }
            newParam["sub_user_id"] = self.sub_user_id as AnyObject
            newParam["service_name"] = self.TF_services_name.text! as AnyObject
            newParam["service_charges"] = self.TF_charges.text! as AnyObject
            self.showLoading()
            NetworkManager.UploadFiles(kBaseURLString + url, image: self.selected_img.image!, withParams: newParam, onView: self) { (mainResponse) in
                self.hideLoading()
                if (mainResponse["status"] as! String) == "success" {
                    self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String, complition: { (isConfirm, btn) in
                        if self.delegate != nil {
                            isProductAdded = true
                            self.delegate?.refreshData()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }else {
                    if (mainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }
        }else{
            var newParam = [String : AnyObject]()
            newParam["sub_user_id"] = self.sub_user_id as AnyObject
            newParam["service_name"] = self.TF_services_name.text! as AnyObject
            newParam["service_charges"] = self.TF_charges.text! as AnyObject
            if isUpdate {
                newParam["id"] = self.budz_service.id as AnyObject
                if self.btn_cancel.isHidden {
                     newParam["path"] = "" as AnyObject
                }else{
                     newParam["path"] = self.budz_service.image as AnyObject
                }
            }
            self.showLoading()
            NetworkManager.PostCall(UrlAPI:url, params: newParam, completion: { (successResponse, messageResponse, mainResponse) in
                self.hideLoading()
                if successResponse {
                    if (mainResponse["status"] as! String) == "success" {
                        self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String, complition: { (isConfirm, btn) in
                            if self.delegate != nil {
                                isProductAdded = true
                                self.delegate?.refreshData()
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }else {
                        if (mainResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
            })
        }
    }
    
    @IBAction func onClickUploadPhotos(_ sender: Any) {
        if self.uploadedImages.count < 5{
            let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
            vcCamera.delegate = self
            vcCamera.isOnlyImage = true
            vcCamera.isViewPresent = true
            self.present(vcCamera, animated: true, completion: nil)
        }else{
            self.ShowErrorAlert(message: "Maximum upload photos limit has been reached!")
        }
    }
}

// MARK: - Delegates
extension AddNewServicesVC: CameraDelegate{
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
    }
    func captured(image: UIImage) {
        self.btn_cancel.isHidden = false
       self.selected_img.image = image
       self.isImageSelected = true
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        self.btn_cancel.isHidden = false
        self.selected_img.image = image
        self.isImageSelected = true
    }
}

