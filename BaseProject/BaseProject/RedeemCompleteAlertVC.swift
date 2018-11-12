//
//  RedeemCompleteAlertVC.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class RedeemCompleteAlertVC: BaseViewController {
    var data : [String : Any]?
    @IBOutlet weak var Lbl_Discription: UILabel!
    @IBOutlet weak var alert_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = data!["name"] as? String {
              self.Lbl_Discription.text =  "for redeeming product \"\(name)\""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alert_view.zoomIn()
        
    }
    @IBAction func OnClickCross(_ sender: Any) {
        self.alert_view.zoomOut()
        self.Dismiss()
    }
}

