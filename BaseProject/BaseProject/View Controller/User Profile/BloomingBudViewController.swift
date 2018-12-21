//
//  BloomingBudViewController.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import  KUIPopOver

class BloomingBudViewController: BaseViewController ,KUIPopOverUsable{
    @IBOutlet weak var lbl_title: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.lbl_title.textColor =  UserProfileViewController.userMain.colorMAin
        print(UserProfileViewController.userMain.colorMAin)
        self.lbl_title.text = UserProfileViewController.userMain.bloomingBudText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var popOverBackgroundColor: UIColor?{
        return  UIColor.init(hex: "3A3A3A")
    }
    var contentSize: CGSize {
        return CGSize(width: 200, height: 226.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    @IBAction func DismissInfo(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }


}
