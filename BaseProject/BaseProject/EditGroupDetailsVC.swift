//
//  EditGroupDetailsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 11/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EditGroupDetailsVC: BaseViewController {
 
    @IBOutlet weak var group_name: UITextField!
    @IBOutlet weak var group_discription: UITextView!
    
    var grp_data_model  = Group()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.group_name.text = grp_data_model.title
        self.group_discription.text = grp_data_model.group_description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UpdateGrup(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
