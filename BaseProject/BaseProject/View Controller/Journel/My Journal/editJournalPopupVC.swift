//
//  editJournalPopupVC.swift
//  BaseProject
//
//  Created by MAC MINI on 08/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import KUIPopOver
class editJournalPopupVC: UIViewController,KUIPopOverUsable {

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
        return CGSize(width: 160, height: 100.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    @IBAction func editJournalBtn(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func deleteJournalBtn(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }

  

}
