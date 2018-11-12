//
//  AddNewProductVC.swift
//  BaseProject
//
//  Created by Jawad on 10/3/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AAPickerView
class StrainDropDown: NSObject {
    var title : String?
    var id : Int?
}
class AddNewProductVC: BaseViewController {
    
    @IBOutlet weak var page_title: UILabel!
    @IBOutlet weak var TF_Productname: UITextField!
    @IBOutlet weak var TF_Categoryname: UITextField!
    @IBOutlet weak var TF_Strain: AAPickerView!
    @IBOutlet weak var TF_THC_amount: UITextField!
    @IBOutlet weak var TF_CBD_Amount: UITextField!
    
    @IBOutlet weak var TF_Weight_1: UITextField!
    @IBOutlet weak var TF_Weight_2: UITextField!
    @IBOutlet weak var TF_Weight_3: UITextField!
    @IBOutlet weak var TF_Weight_4: UITextField!
    @IBOutlet weak var TF_price_1: UITextField!
    @IBOutlet weak var TF_price_2: UITextField!
    @IBOutlet weak var TF_price_3: UITextField!
    @IBOutlet weak var TF_price_4: UITextField!
    var strain_list  = [StrainDropDown]()
    var straing_string_list  = [String]()
    var selected_strain_id = 0
    
    var product  = StrainProduct()
    var isUpdate  : Bool = false
    var sub_user_id :Int = 0
    var delegate:refreshDataDelgate?
    @IBOutlet weak var mediaCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var media_collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    var uploadedImages : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let mediaPostCellNib = UINib(nibName:  "PostImageCollectionViewCell", bundle: nil)
        self.media_collectionView.register(mediaPostCellNib, forCellWithReuseIdentifier:  "PostImageCollectionViewCell")
        mediaCollectionViewLayout.minimumLineSpacing = 0
        mediaCollectionViewLayout.minimumInteritemSpacing = 0
        self.media_collectionView.invalidateIntrinsicContentSize()
        mediaCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mediaCollectionViewLayout.itemSize = self.media_collectionView.frame.size
        self.TF_Strain.pickerType = .StringPicker
        self.TF_Strain.delegate = self
        self.TF_Strain.stringPickerData = self.straing_string_list
        self.TF_Strain.stringDidChange = { index in
            print(self.strain_list[index].title ?? "Empty ")
            self.selected_strain_id = self.strain_list[index].id!
        }
        
        if isUpdate{
            self.setData()
        }
    }
    
    func setData() {
        self.TF_Productname.text = self.product.name
        self.TF_Categoryname.text = self.product.strainCategory?.title
        if (self.product.straintype?.title.count)! > 0 {
            for str in self.strain_list{
                if str.id == Int(self.product.strain_id) {
                    self.TF_Strain.text = str.title
                    self.selected_strain_id =  str.id!
                }
            }
        }
        self.TF_THC_amount.text = self.product.thc
        self.TF_CBD_Amount.text = self.product.cbd
        
        let data  = self.product.priceArray
        var count  = 0
        for arr in data {
            if count == 0 {
                 self.TF_Weight_1.text = arr.weight
                 self.TF_price_1.text = arr.price
            }else if count == 1 {
                self.TF_Weight_2.text = arr.weight
                self.TF_price_2.text = arr.price
            }else if count == 2 {
                self.TF_Weight_3.text = arr.weight
                self.TF_price_3.text = arr.price
            }else if count == 3 {
                self.TF_Weight_4.text = arr.weight
                self.TF_price_4.text = arr.price
            }
            count = count + 1
        }
        
        for image in self.product.images{
            self.uploadedImages.append(image.image)
        }
        self.page_title.text = "Edit Product"
        self.media_collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    class func addNewProduct(strains : [[String : Any]] , id  : Int ,delegate :refreshDataDelgate)->AddNewProductVC
    {
        let me = AddNewProductVC(nibName: String(describing: AddNewProductVC.self), bundle: nil)
        me.strain_list.removeAll()
        me.straing_string_list.removeAll()
        for str in strains{
            let obj = StrainDropDown()
            if let title = str["title"] as? String {
                obj.title = title
            }else{
                obj.title = ""
            }
            if let id = str["id"] as? NSNumber {
                obj.id = id.intValue
            }else{
                obj.id = 0
            }
            me.straing_string_list.append(obj.title!)
            me.strain_list.append(obj)
        }
        print(strains)
        me.sub_user_id = id
        me.delegate = delegate
        return me
    }
    class func updateData(strains : [[String : Any]] , id  : Int ,product : StrainProduct,delegate :refreshDataDelgate)->AddNewProductVC
    {
        let me = AddNewProductVC(nibName: String(describing: AddNewProductVC.self), bundle: nil)
        me.strain_list.removeAll()
        me.straing_string_list.removeAll()
        me.product = product
        me.isUpdate = true
        for str in strains{
            let obj = StrainDropDown()
            if let title = str["title"] as? String {
                obj.title = title
            }else{
                obj.title = ""
            }
            
            if let id = str["id"] as? NSNumber {
                obj.id = id.intValue
            }else{
                obj.id = 0
            }
            me.straing_string_list.append(obj.title!)
            me.strain_list.append(obj)
        }
        print(strains)
        me.sub_user_id = id
        me.delegate = delegate
        return me
    }
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)  
    }
    @IBAction func onClickSave(_ sender: Any) {
        if self.TF_Productname.text!.count == 0 {
            self.ShowErrorAlert(message: "Product Name Required!")
            return
        }
        
        
        if let value =  Double(self.TF_THC_amount.text!) {
            if(value > 100){
                self.ShowErrorAlert(message: "THC Value only 1-100!")
                return
            }
        }else{
            if (self.TF_THC_amount.text?.count)! > 0 {
                self.ShowErrorAlert(message: "Invalid THC value!")
                return
            }
        }
        
        if let value =  Double(self.TF_CBD_Amount.text!) {
            if(value > 100){
                self.ShowErrorAlert(message: "CBD Value only 1-100!")
                return
            }
        }else{
            if (self.TF_CBD_Amount.text?.count)! > 0 {
                self.ShowErrorAlert(message: "Invalid CBD value!")
                return
            }
        }
        
        if self.TF_Weight_1.text!.count == 0 {
            self.ShowErrorAlert(message: "Weight 1 Required!")
            return
        }else {
            if self.TF_Weight_1.text!.count > 8 {
                self.ShowErrorAlert(message: "Weight 1 limit is 8 characters!")
                return
            }
        }
        
        
        
        if self.TF_price_1.text!.count == 0 {
            self.ShowErrorAlert(message: "Price 1 Required!")
            return
        }else {
            if self.TF_price_1.text!.count > 8 {
                self.ShowErrorAlert(message: "Price 1 limit is 8 digit!")
                return
            }
        }
        if self.TF_Weight_2.text!.count > 8 {
            self.ShowErrorAlert(message: "Weight 2 limit is 8 characters!")
            return
        }

        if self.TF_price_2.text!.count > 8 {
            self.ShowErrorAlert(message: "Price 2 limit is 8 digit!")
            return
        }

        if self.TF_Weight_3.text!.count > 8 {
            self.ShowErrorAlert(message: "Weight 3 limit is 8 characters!")
            return
        }

        if self.TF_price_3.text!.count > 8 {
            self.ShowErrorAlert(message: "Price 3 limit is 8 digit!")
            return
        }

        if self.TF_Weight_4.text!.count > 8 {
            self.ShowErrorAlert(message: "Weight 4 limit is 8 characters!")
            return
        }

        if self.TF_price_4.text!.count > 8 {
            self.ShowErrorAlert(message: "Price 4 limit is 8 digit!")
            return
        }
        var newParam = [String : AnyObject]()
        var images_url = ""
        for img in self.uploadedImages {
            if images_url.count == 0 {
                images_url = img
            }else{
                images_url = images_url + "," + img
            }
        }
        newParam["sub_user_id"] = self.sub_user_id as AnyObject
        newParam["attachments"] = images_url as AnyObject
        newParam["product_name"] = self.TF_Productname.text as AnyObject
        newParam["cat_name"] = self.TF_Categoryname.text as AnyObject
        newParam["strain_id"] = self.selected_strain_id as AnyObject
        
        newParam["thc"] = self.TF_THC_amount.text as AnyObject
        newParam["cbd"] = self.TF_CBD_Amount.text as AnyObject
        
        if isUpdate{
             newParam["id"] =  self.product.ID as AnyObject
        }
        var str_weight  = self.TF_Weight_1.text! //+ "," + self.TF_Weight_2.text! + "," + self.TF_Weight_3.text! + "," + self.TF_Weight_4.text!
        
        var str_price  = self.TF_price_1.text! //+ "," + self.TF_price_2.text! + "," + self.TF_price_3.text! + "," + self.TF_price_4.text!
        if(self.TF_Weight_2.text!.trimmingCharacters(in: .whitespaces).count>0){
            if(self.TF_price_2.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + self.TF_Weight_2.text!
                str_price = str_price + "," + self.TF_price_2.text!
            }else {
                str_weight = str_weight + "," + self.TF_Weight_2.text!
                str_price = str_price + "," + "0"
                
            }
        }else {
            if(self.TF_price_2.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + "0"
                str_price = str_price + "," + self.TF_price_2.text!
            }
        }
        if(self.TF_Weight_3.text!.trimmingCharacters(in: .whitespaces).count>0){
            if(self.TF_price_3.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + self.TF_Weight_3.text!
                str_price = str_price + "," + self.TF_price_3.text!
            }else {
                str_weight = str_weight + "," + self.TF_Weight_3.text!
                str_price = str_price + "," + "0"
                
            }
        }else {
            if(self.TF_price_3.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + "0"
                str_price = str_price + "," + self.TF_price_3.text!
            }
        }
        if(self.TF_Weight_4.text!.trimmingCharacters(in: .whitespaces).count>0){
            if(self.TF_price_4.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + self.TF_Weight_4.text!
                str_price = str_price + "," + self.TF_price_4.text!
            }else {
                str_weight = str_weight + "," + self.TF_Weight_4.text!
                str_price = str_price + "," + "0"
                
            }
        }else {
            if(self.TF_price_4.text!.trimmingCharacters(in: .whitespaces).count>0){
                str_weight = str_weight + "," + "0"
                str_price = str_price + "," + self.TF_price_4.text!
            }
        }
        newParam["weight"] = str_weight as AnyObject
        newParam["price"] = str_price as AnyObject
        print(newParam)
        self.showLoading()
        NetworkManager.PostCall(UrlAPI:"add_budz_product", params: newParam, completion: { (successResponse, messageResponse, mainResponse) in
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

extension AddNewProductVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageController.numberOfPages = self.uploadedImages.count
        if self.uploadedImages.count > 0 {
            if self.pageController.isHidden {
                self.pageController.isHidden = false
            }
        }else{
            self.pageController.isHidden = true
        }
        return self.uploadedImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        let file = uploadedImages[indexPath.row]
        let attachment = Attachment()
        attachment.server_URL = file
        cell.displayImageWhileSaving(file: attachment)
        cell.deleteButtonAction = {[unowned self] in
            self.uploadedImages.remove(at: indexPath.row)
            self.media_collectionView.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.item
    }
    
    func UploadFiles(imageMain : UIImage, index: Int){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + "add_budz_product_image", image: imageMain, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if MainResponse != nil {
                if let data = MainResponse["successData"] as? [String : Any]{
                    self.uploadedImages.append(data["path"] as! String)
                    self.media_collectionView.reloadData()
                    self.media_collectionView.scrollToItem(at: IndexPath.init(row: self.uploadedImages.count - 1 , section: 0), at: .centeredHorizontally, animated: true)
                }
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
}

// MARK: - Delegates
extension AddNewProductVC: CameraDelegate{
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
    }
    func captured(image: UIImage) {
        self.UploadFiles(imageMain: image, index: 0)
    }
    
    func gifData(gifURL: URL, image: UIImage) {
        self.UploadFiles(imageMain: image, index: 0)
    }
}
