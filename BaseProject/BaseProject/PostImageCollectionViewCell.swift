//
//  PostImageCollectionViewCell.swift
//  BaseProject
//
//  Created by Yasir Ali on 30/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AlamofireImage
import SDWebImage
import FLAnimatedImage

class PostImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var videoIconImageView: UIImageView!
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let whiteColor = UIColor.darkGray.withAlphaComponent(0.1)
        let blackColor = UIColor.black.withAlphaComponent(0.3)
        layer.colors = [whiteColor.cgColor, blackColor.cgColor]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//      imageView.image = #imageLiteral(resourceName: "placeholder")
        self.deleteButton.isHidden = true
//        shadeView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = shadeView.bounds
        print("awakeFromNib: \(shadeView.bounds)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageView.contentMode = .scaleAspectFit
//        gradientLayer.removeFromSuperlayer()
//        shadeView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = shadeView.bounds
        print("layoutSubviews: \(shadeView.bounds), gradientLayer: \(imageView.bounds)")
    }
    
    var deleteButtonAction: (() -> Void)?
    
    
    @IBAction func deleteButtonTapped()   {
        deleteButtonAction?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func display(file: PostFile)    {
        self.imageView.backgroundColor = UIColor.clear
        if let poster = file.poster, poster != "<null>"{
            videoIconImageView.isHidden = false
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + poster)   {
                print(url)
                self.imageView.sd_addActivityIndicator()
                self.imageView.sd_setShowActivityIndicatorView(true)
                 self.imageView.sd_showActivityIndicatorView()
                print( url.lastPathComponent)
                if url.lastPathComponent.contains(".gif"){
                   self.imageView.loadGif(url: url)
                }else{
                     self.imageView.sd_setImage(with: url,completed: nil)
                }
            
            }
        } else if let file = file.file    {
            videoIconImageView.isHidden = true
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + file)    {
                if url.lastPathComponent.contains(".gif"){
                  self.imageView.loadGif(url: url)
                }else{
                    self.imageView.sd_setImage(with: url,completed: nil)
                }
            }
        }
        else {
        }
        self.layoutIfNeeded()
        self.reloadInputViews()
    }
   func displayImageWhileSaving(file: Attachment){
        imageView.image = #imageLiteral(resourceName: "placeholder")
        self.deleteButton.isHidden = false;
        if file.is_Video == true{
            videoIconImageView.isHidden = false
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + file.image_URL)    {
                imageView.af_setImage(withURL: url)
                print(url)
            }
        }else{
            videoIconImageView.isHidden = true
            if file.server_URL != ""{
            if let url = URL(string: WebServiceName.images_baseurl.rawValue + file.server_URL)    {
                imageView.af_setImage(withURL: url)
                print(url)
            }
            }else{
                imageView.image = file.image_Attachment
            }

        }
        
    }

}
extension FLAnimatedImageView {
    
    func loadGif(url:URL,placeholder: UIImage? = #imageLiteral(resourceName: "placeholder")){
        self.sd_addActivityIndicator()
        self.sd_setShowActivityIndicatorView(true)
        self.sd_showActivityIndicatorView()
        if url.lastPathComponent.contains(".gif"){
            var localdata : Data  = Data.init()
            let localGifArray = DataManager.sharedInstance.getGiftArray()
            var isGifFound:Bool = false
            for items in localGifArray {
                if(items.url?.contains(url.absoluteString))!{
                    isGifFound = true
                    localdata = items.gifData!
                    break
                }
            }
            if !isGifFound  {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        self.sd_removeActivityIndicator()
                        self.sd_setImage(with: url,placeholderImage: placeholder,completed: nil)
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let gif = FLAnimatedImage(animatedGIFData: data)
                        self.animatedImage = gif
                        self.sd_removeActivityIndicator()
                        var gifNewArray = localGifArray
                        let newGifData = GifPostModel()
                        newGifData.url = url.absoluteString
                        newGifData.gifData = data;
                        gifNewArray.append(newGifData)
                        DataManager.sharedInstance.saveGiftData(gifDataArray: gifNewArray)
                        //
                    })
                }).resume()
            }else{
                let gif = FLAnimatedImage(animatedGIFData: localdata)
                self.animatedImage = gif
                self.sd_removeActivityIndicator()
            }
        }else {
            self.sd_removeActivityIndicator()
            self.sd_setImage(with: url,placeholderImage: placeholder,completed: nil)
        }
       
    }
}
