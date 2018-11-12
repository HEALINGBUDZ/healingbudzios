//
//  sortVC.swift
//  BaseProject
//
//  Created by MAC MINI on 08/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import  KUIPopOver
class sortVC: UIViewController,KUIPopOverUsable {

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 150.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    @IBAction func NewestFirstBtn(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func AlphabeticallyBtn(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func EnteriesBtn(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }


}
