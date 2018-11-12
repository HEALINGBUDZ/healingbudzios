//
//  ImageExtension.swift
//  Wave
//
//  Created by Vengile on 08/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	func dropShadow(scale: Bool = true) {

		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 1
		self.layer.shadowOffset = CGSize.zero
		self.layer.shadowRadius = 7
		
		
	}
    
    
    func DropRightShadow(){
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2.0;
    }
    
    
    func CellDropShadow(scale: Bool = true) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        
        
    }
	
	
	func CornerRadious()  {
		self.layer.borderWidth = 1;
		self.layer.cornerRadius = self.frame.height / 2
		self.layer.borderColor = UIColor.clear.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = false
	}
    
    
    func CornerRadiousWithRadious(radious : CGFloat)  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = radious
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
    func getSizeKB() -> Double {
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        
        let imageSize: Int = imgData.length
        let imageSizeInKB = Double(imageSize) / 1024.0
        return imageSizeInKB
    }
    
    func getSizeMB() -> Double {
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        let imageSize: Int = imgData.length
        let imageSizeInKB = Double(imageSize) / 1024.0
        return imageSizeInKB/1024
    }
}

extension UIImageView
{
    func setUserProfilesImage()
    {
        let user = DataManager.sharedInstance.user
        if let profilePicUrlString = user?.profilePictureURL {
            if profilePicUrlString.contains("facebook.com")  || profilePicUrlString.contains("google.com"){
                let urlString = profilePicUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: urlString)!
                self.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholderMenu"))
            }else{
                let urlString = WebServiceName.images_baseurl.rawValue + profilePicUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: urlString)!
                self.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholderMenu"))
            }
           
            
        }
        else {
            let pointsColor = user?.colorMAin
            self.image = #imageLiteral(resourceName: "QA_Rate").withRenderingMode(.alwaysTemplate)
            self.tintColor = pointsColor
        }
    }
    
   
    
}


