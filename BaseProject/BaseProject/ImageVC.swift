//
//  ImageVC.swift
//  BaseProject
//
//  Created by MAC MINI on 10/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import FLAnimatedImage
class ImageVC: BaseViewController {
    var img : UIImage!
    var urlMain : String!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var image: FLAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.indicator.startAnimating()
        self.indicator.isHidden = false
        if urlMain.count > 0 {
            self.image.backgroundColor =  UIColor.black
            self.image.image = nil
            self.image.loadGif(url: URL.init(string: WebServiceName.images_baseurl.rawValue + urlMain.RemoveSpace())!)
//                .sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + urlMain.RemoveSpace()), placeholderImage: nil, completed: { (image, error, chache, url) in
//                    self.indicator.isHidden = true
//                })
        }else {
             self.indicator.isHidden = true
          self.image.image  = img
        }
    }
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
