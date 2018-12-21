//
//  AddNewEventVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AddNewEventVC: BaseViewController {
    var isUpdate : Bool = false
    @IBOutlet weak var page_title: UILabel!
    var selected_ticket = Ticktes()
    @IBOutlet weak var btn_cancel: UIImageView!
    @IBOutlet weak var TF_ticket_name: UITextField!
    @IBOutlet weak var TF_charges: UITextField!
    @IBOutlet weak var TF_URL: UITextField!
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
        self.TF_ticket_name.text =  self.selected_ticket.title
        self.TF_charges.text =  self.selected_ticket.price
        if self.selected_ticket.image.count > 4 {
            self.btn_cancel.isHidden = false
            self.selected_img.sd_setImage(with:URL.init(string:  WebServiceName.images_baseurl.rawValue + self.selected_ticket.image), completed: nil)
        }
        self.TF_URL.text = self.selected_ticket.purchase_ticket_url
      self.page_title.text = "Edit Ticket"
    }
    class func addNewEvent(id  : Int ,delegate :refreshDataDelgate)->AddNewEventVC
    {
        let me = AddNewEventVC(nibName: String(describing: AddNewEventVC.self), bundle: nil)
        me.sub_user_id = id
        me.delegate = delegate
        return me
    }
    class func updateData(id  : Int , ticket : Ticktes ,delegate :refreshDataDelgate)->AddNewEventVC
    {
        let me = AddNewEventVC(nibName: String(describing: AddNewEventVC.self), bundle: nil)
        me.sub_user_id = id
        me.delegate = delegate
        me.selected_ticket = ticket
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
        if self.TF_ticket_name.text?.count == 0 {
            self.ShowErrorAlert(message: "Ticket Name Required!")
            return
        }
        if self.TF_charges.text?.count == 0 {
            self.ShowErrorAlert(message: "Charges Required!")
            return
        }
        var url = "add_budz_ticket"
        if isUpdate {
            url = "add_budz_ticket"
        }
        if isImageSelected {
            var newParam = [String : AnyObject]()
            if isUpdate {
                newParam["id"] = self.selected_ticket.id as AnyObject
            }
            newParam["sub_user_id"] = self.sub_user_id as AnyObject
            newParam["ticket_title"] = self.TF_ticket_name.text! as AnyObject
            newParam["ticket_price"] = self.TF_charges.text! as AnyObject
             newParam["purchase_ticket_url"] = self.TF_URL.text! as AnyObject
            print(newParam)
            self.showLoading()
            NetworkManager.UploadFiles(kBaseURLString + url, image: self.selected_img.image!, withParams: newParam, onView: self) { (mainResponse) in
                self.hideLoading()
                if (mainResponse["status"] as! String) == "success" {
                    self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String, complition: { (isConfirm, btn) in
                        if self.delegate != nil {
                            isProductAdded = true
                            self.delegate?.refreshTabs!()
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
            newParam["ticket_title"] = self.TF_ticket_name.text! as AnyObject
            newParam["ticket_price"] = self.TF_charges.text! as AnyObject
             newParam["purchase_ticket_url"] = self.TF_URL.text! as AnyObject
            if isUpdate {
                newParam["id"] = self.selected_ticket.id as AnyObject
                if self.btn_cancel.isHidden {
                    newParam["path"] = "" as AnyObject
                }else{
                    newParam["path"] = self.selected_ticket.image as AnyObject
                }
            }
            print(newParam)
            self.showLoading()
            NetworkManager.PostCall(UrlAPI:url, params: newParam, completion: { (successResponse, messageResponse, mainResponse) in
                self.hideLoading()
                if successResponse {
                    if (mainResponse["status"] as! String) == "success" {
                        self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String, complition: { (isConfirm, btn) in
                            if self.delegate != nil {
                                isProductAdded = true
                                self.delegate?.refreshTabs!()
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
extension AddNewEventVC: CameraDelegate{
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

