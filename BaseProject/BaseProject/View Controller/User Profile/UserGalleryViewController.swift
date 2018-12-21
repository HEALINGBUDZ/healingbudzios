//
//  UserGalleryViewController.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AVKit
class UserGalleryViewController: BaseViewController , EFImageViewZoomDelegate  , CameraDelegate {
    
    
    @IBOutlet weak var btn_download: UIView!
    @IBOutlet weak var download_img: UIImageView!
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var MainCollectionView2: UICollectionView!
     @IBOutlet weak var lblTitle: UILabel!
    var userName  = ""
    var userID = ""
    var array_Attachment = [Attachment]()
    
    override func viewDidLoad() {
        self.btn_download.isHidden = true
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.MainCollectionView2.isHidden = true
        if self.userID == DataManager.sharedInstance.getPermanentlySavedUser()?.ID {
             self.btn_download.isHidden = false
             self.download_img.image = #imageLiteral(resourceName: "Upload_Whites")
        }else{
             self.btn_download.isHidden = true
        }
       
        self.MainCollectionView.isHidden = false
        print(userName)
        if userName.isEmpty{
           lblTitle.text = "My HB Gallery"
        }else{
            lblTitle.text = userName + "'s Gallery"
        }
        
        self.GetallImages()
    }
    
    
    func GetallImages(){
        self.showLoading()
        self.array_Attachment.removeAll()
        NetworkManager.GetCall(UrlAPI: WebServiceName.hb_gallery.rawValue + self.userID) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        self.array_Attachment.append(Attachment.init(json: indexObj as [String : AnyObject] ))
                    }
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            if self.array_Attachment.count == 0 {
                self.MainCollectionView.setEmptyMessage("No record found in gallery!", color: UIColor.white.withAlphaComponent(0.7))
            }else{
                self.MainCollectionView.restore()
            }
            
            self.MainCollectionView.reloadData()
            self.MainCollectionView2.reloadData()
           
            
        }
    }
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newparam = [String : AnyObject]()
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + "add_hb_media", image: image, withParams: newparam, onView: self) { (MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if MainResponse["status"] as! String == "success" {
                self.GetallImages()
            }
        }
    }
    func captured(image: UIImage) {
        let newparam = [String : AnyObject]()
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + "add_hb_media", image: image, withParams: newparam, onView: self) { (MainResponse) in
            self.hideLoading()
            print(MainResponse)
            if MainResponse["status"] as! String == "success" {
               self.GetallImages()
            }
        }
    }
    
    @IBAction func onClickDownloadImage(_ sender: Any) {
        
        
        if self.MainCollectionView.isHidden {
            if let cell = MainCollectionView2.cellForItem(at: self.MainCollectionView2.indexPathsForVisibleItems.first!) as? MainGalleryCell{
                let obj = self.array_Attachment[self.MainCollectionView2.indexPathsForVisibleItems.first!.row]
                if obj.is_Video{
                    let videoURL =  WebServiceName.videos_baseurl.rawValue + obj.video_URL
//                    self.saveVideo(path: videoURL)
                }else{
                    if cell.imgViewMainZoom.image != nil {
                        self.saveImageInGallery(img: cell.imgViewMainZoom.image!)
                    }
                }
                
            }
        }else{
            let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
            vcCamera.delegate = self
            vcCamera.isOnlyImage = true
            self.navigationController?.pushViewController(vcCamera, animated: true)
        }
    }
    
}

extension UserGalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == MainCollectionView {
            return CGSize.init(width: (collectionView.bounds.size.width/2) - 10 , height: (collectionView.bounds.size.width/2) - 10)
            
        }else {
            return CGSize.init(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array_Attachment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             if collectionView.tag == 555 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
                cell.backgroundColor = UIColor.clear
                cell.imgViewMain.backgroundColor = UIColor.clear
                cell.imgViewMain.contentMode = .scaleAspectFit
                cell.indicator.tintColor = UIColor.white
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                
                if self.array_Attachment[indexPath.row].is_Video {
                    cell.imgViewMainZoom.isHidden = true
                    cell.video_icon.isHidden = false
                    cell.imgViewMain.isHidden = false
                    cell.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.array_Attachment[indexPath.row].image_URL.RemoveSpace())) { (img, error, chache, url) in
                        print(url ?? "")
                        cell.indicator.isHidden = true

                    }
                }else{
                    cell.imgViewMainZoom.isHidden = false
                    cell.imgViewMainZoom._delegate = self
                    cell.video_icon.isHidden = true
                    UIImageView().sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.array_Attachment[indexPath.row].image_URL.RemoveSpace())) { (img, error, chache, url) in
                        print(url ?? "")
                        cell.imgViewMain.image = nil
                        cell.imgViewMain.isHidden = true
                        cell.imgViewMainZoom.image = img
                        cell.indicator.isHidden = true
                    }
                }
                return cell
                
             }else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryUserCell", for: indexPath) as! MainGalleryUserCell
                cell.backgroundColor = UIColor.clear
                cell.viewDelete.isHidden = true
                if self.userID == DataManager.sharedInstance.user?.ID {
                    cell.viewDelete.isHidden = false
                    cell.btnDelete.tag = indexPath.row
                    cell.btnDelete.addTarget(self, action: #selector(self.DeleteImage), for: .touchUpInside)
                }
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                if self.array_Attachment[indexPath.row].is_Video {
                    cell.video_icon.isHidden = false
                    cell.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.array_Attachment[indexPath.row].image_URL.RemoveSpace())) { (img, error, chache, url) in
                        print(url ?? "")
                        cell.indicator.isHidden = true

                    }
                }else{
                    cell.video_icon.isHidden = true
                    cell.imgViewMain.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + self.array_Attachment[indexPath.row].image_URL.RemoveSpace())) { (img, error, chache, url) in
                        print(url ?? "")
                        cell.indicator.isHidden = true
                    }
                }
               
                return cell
                
        }
    }
    
    func DeleteImage(sender : UIButton){
        self.openDeleteAlert(text: "You want to delete this image?") {
            let urlMain = "delete_hb_gallery/" + self.array_Attachment[sender.tag].ID
            NetworkManager.GetCall(UrlAPI: urlMain) { (successMain, messageSuccess, dataMain) in
                self.GetallImages()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == MainCollectionView {
            self.MainCollectionView2.isHidden = false
            self.btn_download.isHidden = false
             self.download_img.image = #imageLiteral(resourceName: "download-to-storage-drive")
            self.MainCollectionView.isHidden = true
            self.MainCollectionView2.scrollToItem(at: indexPath, at: .right, animated: false)
        }else {
            if self.array_Attachment[indexPath.row].is_Video {
                let videoURL =  WebServiceName.videos_baseurl.rawValue + self.array_Attachment[indexPath.row].video_URL
                let player = AVPlayer(url:  NSURL(string: videoURL)! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == MainCollectionView2 && self.MainCollectionView.isHidden{
            if self.array_Attachment[indexPath.row].is_Video{
                 self.btn_download.isHidden = true
            }else{
                 self.btn_download.isHidden = false
            }
        }
    }
}

//MARK:
//MARK: Button Actions
extension UserGalleryViewController {
    @IBAction func Back_Action(sender : UIButton){
        if self.MainCollectionView.isHidden {
            self.MainCollectionView2.isHidden = true
            self.MainCollectionView.isHidden = false
            
            if self.userID == DataManager.sharedInstance.getPermanentlySavedUser()?.ID {
                self.btn_download.isHidden = false
                self.download_img.image = #imageLiteral(resourceName: "Upload_Whites")
            }else{
                self.btn_download.isHidden = true
            }
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
        
    }
    
}


class MainGalleryUserCell : UICollectionViewCell {
    
    @IBOutlet weak var video_icon: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var viewDelete : UIView!
}
