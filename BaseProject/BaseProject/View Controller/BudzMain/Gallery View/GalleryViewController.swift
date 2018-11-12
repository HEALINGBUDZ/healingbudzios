//
//  GalleryViewController.swift
//  BaseProject
//
//  Created by macbook on 16/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit


class GalleryViewController: BaseViewController , CameraDelegate , EFImageViewZoomDelegate{

    @IBOutlet weak var btn_Upload: UIButton!
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var MainCollectionView2: UICollectionView!
    @IBOutlet var imgView_FullImage : UIImageView!
    
    @IBOutlet weak var img_Upload: UIImageView!
    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblReviewCount : UILabel!
    @IBOutlet var lblimageCount: UILabel!
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var imgViewLogo : UIImageView!//calloutImage
    
    @IBOutlet var imgViewStar1 : UIImageView!
    @IBOutlet var imgViewStar2 : UIImageView!
    @IBOutlet var imgViewStar3 : UIImageView!
    @IBOutlet var imgViewStar4 : UIImageView!
    @IBOutlet var imgViewStar5 : UIImageView!
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet var viewOrganic : UIView!
    @IBOutlet var viewDelivery : UIView!
    
    var array_Attachment = [Attachment]()
    
    var chooseBudzMap = BudzMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblimageCount.isHidden = true
        self.btnDownload.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDownloadPressed(_ sender: Any) {
        if self.MainCollectionView.isHidden {
            if let cell = MainCollectionView2.cellForItem(at: self.MainCollectionView2.indexPathsForVisibleItems.first!) as? MainGalleryCell{
                _ = self.chooseBudzMap.images[self.MainCollectionView2.indexPathsForVisibleItems.first!.row]
                if cell.imgViewMainZoom.image != nil {
                    self.saveImageInGallery(img: cell.imgViewMainZoom.image!)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.MainCollectionView.reloadData()
        self.MainCollectionView2.reloadData()
        self.MainCollectionView2.isHidden = true
        imgView_FullImage.isHidden = true
        self.MainCollectionView.isHidden = false
        if(String(self.chooseBudzMap.user_id) == DataManager.sharedInstance.user!.ID){
            self.btn_Upload.isHidden = false
            self.img_Upload.isHidden = false
        }else {
             self.btn_Upload.isHidden = true
            self.img_Upload.isHidden = true
        }
        self.lblName.text = self.chooseBudzMap.title
        self.lblHeading.text = "Cannabusiness Gallery"
        
        self.viewOrganic.isHidden = true
        if self.chooseBudzMap.is_organic == "1" {
            self.viewOrganic.isHidden = false
        }
        
        self.viewDelivery.isHidden = true
        if self.chooseBudzMap.is_delivery == "1" {
            self.viewDelivery.isHidden = false
        }
     
        
        self.imgViewStar1.image = #imageLiteral(resourceName: "starUnfilled")
        self.imgViewStar2.image = #imageLiteral(resourceName: "starUnfilled")
        self.imgViewStar3.image = #imageLiteral(resourceName: "starUnfilled")
        self.imgViewStar4.image = #imageLiteral(resourceName: "starUnfilled")
        self.imgViewStar5.image = #imageLiteral(resourceName: "starUnfilled")
        
        if Double(self.chooseBudzMap.rating_sum)! < 1.0 {
            if Double(self.chooseBudzMap.rating_sum)! >= 0.1 {
                self.imgViewStar1.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.chooseBudzMap.rating_sum)! < 2.0 {
            self.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.chooseBudzMap.rating_sum)! >= 1.1 {
                self.imgViewStar2.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.chooseBudzMap.rating_sum)! < 3.0 {
            self.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.chooseBudzMap.rating_sum)! >= 2.1 {
                self.imgViewStar3.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.chooseBudzMap.rating_sum)! < 4.0 {
            self.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.chooseBudzMap.rating_sum)! >= 3.1 {
                self.imgViewStar4.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  if Double(self.chooseBudzMap.rating_sum)! < 5.0 {
            self.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar4.image = #imageLiteral(resourceName: "starFilled")
            if Double(self.chooseBudzMap.rating_sum)! >= 4.1 {
                self.imgViewStar5.image = #imageLiteral(resourceName: "half_star")
                
            }
        }else  {
            self.imgViewStar1.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar2.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar3.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar4.image = #imageLiteral(resourceName: "starFilled")
            self.imgViewStar5.image = #imageLiteral(resourceName: "starFilled")
        }
        
        
        self.lblReviewCount.text = String(self.chooseBudzMap.reviews.count) + " Reviews"
        self.imgViewLogo.moa.url = WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.logo.RemoveSpace()
         self.imgViewLogo.RoundView()
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
}

extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == MainCollectionView {
            return CGSize.init(width: (collectionView.bounds.size.width/2) - 10 , height: (collectionView.bounds.size.width/2) - 10)

        }else {
            return CGSize.init(width: collectionView.bounds.size.width , height: collectionView.bounds.size.width)
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chooseBudzMap.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == MainCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        cell.backgroundColor = UIColor.clear
        cell.indicator.isHidden = false
        cell.indicator.startAnimating()
        cell.imgViewMainZoom.isHidden = true
//        cell.imgViewPending.isHidden = false
//        cell.viewDelete.isHidden = true
//        let item = self.chooseBudzMap.images[indexPath.row]
//            if item.is_approved == 0 {
//                cell.imgViewPending.isHidden = false
//            }else {
//                cell.imgViewPending.isHidden = true
//            }
//            if item.user_id == Int((DataManager.sharedInstance.getPermanentlySavedUser()?.ID)!)! {
//                cell.viewDelete.isHidden = false
//            }else {
//                cell.viewDelete.isHidden = true
//            }
//            cell.btnDelete
        cell.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.images[indexPath.row].image_path.RemoveSpace())) { (img, error, chache, url) in
            print(url)
            cell.indicator.isHidden = true
        }
          return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
            cell.backgroundColor = UIColor.clear
            cell.indicator.isHidden = false
            cell.imgViewMain.isHidden = true
//            cell.imgViewPending.isHidden = true
            cell.imgViewMainZoom.isHidden = false
            cell.indicator.startAnimating()
            cell.imgViewMainZoom._delegate = self
            UIImageView().sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.chooseBudzMap.images[indexPath.row].image_path.RemoveSpace())) { (img, error, chache, url) in
                print(url)
                cell.imgViewMain.isHidden = true
                cell.indicator.isHidden = true
                cell.imgViewMainZoom.image = img
                cell.imgViewMainZoom.contentMode = .left
            }
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.lblimageCount.text = String(indexPath.row + 1) + "/" + String(self.chooseBudzMap.images.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

        
        if collectionView == MainCollectionView {
            self.MainCollectionView2.isHidden = false
            self.MainCollectionView.isHidden = true
            self.lblimageCount.isHidden = false
            self.btnDownload.isHidden = false
            self.MainCollectionView2.scrollToItem(at: indexPath, at: .right, animated: false)
        }
    }
}

//MARK:
//MARK: Button Actions
extension GalleryViewController {
    @IBAction func Back_Action(sender : UIButton){
        if self.MainCollectionView.isHidden {
            self.imgView_FullImage.isHidden = true
            self.MainCollectionView2.isHidden = true
            self.MainCollectionView.isHidden = false
            self.lblimageCount.isHidden = true
            self.btnDownload.isHidden = true
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
    
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        var newparam = [String : AnyObject]()
        newparam["id"] = String(self.chooseBudzMap.id) as AnyObject
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_budz_image.rawValue, image: image,gif_url:gifURL, withParams: newparam, onView: self) { (MainResponse) in
            self.hideLoading()
            print(MainResponse)
            
            if MainResponse["status"] as! String == "success" {
                let newData = MainResponse["successData"] as! [String : AnyObject]
                let newImage = Images()
                newImage.id  = newData["id"] as! Int
                newImage.image_path  = newData["image"] as! String
                self.chooseBudzMap.images.append(newImage)
                self.MainCollectionView.reloadData()
                self.MainCollectionView2.reloadData()
                self.MainCollectionView2.reloadData()
            }
        }
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        var newparam = [String : AnyObject]()
        newparam["id"] = String(self.chooseBudzMap.id) as AnyObject
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_budz_image.rawValue, image: image, withParams: newparam, onView: self) { (MainResponse) in
            self.hideLoading()
            print(MainResponse)
            
            if MainResponse["status"] as! String == "success" {
                let newData = MainResponse["successData"] as! [String : AnyObject]
                let newImage = Images()
                newImage.id  = newData["id"] as! Int
                newImage.image_path  = newData["image"] as! String
                self.chooseBudzMap.images.append(newImage)
                self.MainCollectionView.reloadData()
                self.MainCollectionView2.reloadData()
                self.MainCollectionView2.reloadData()
            }
        }
    }
    
    
}

class MainGalleryCell : UICollectionViewCell {
    @IBOutlet weak var video_icon: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    @IBOutlet weak var imgViewMainZoom: EFImageViewZoom!
    @IBOutlet weak var imgViewMain: UIImageView!
    @IBOutlet weak var imgViewPending: UIImageView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    
}
