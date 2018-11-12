//
//  SuccessMessageGroupViewController.swift
//  BaseProject
//
//  Created by macbook on 21/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class SuccessMessageGroupViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }

}


//MARK:
//MARK: Button Actions

extension SuccessMessageGroupViewController {
    @IBAction func GoBAck_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
    }
    
    @IBAction func InviteBud_Action(sender : UIButton){
        self.PushViewWithIdentifier(name: "BudzListViewController")
    }
}
