//
//  EditGroupVC.swift
//  BaseProject
//
//  Created by MAC MINI on 11/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EditGroupVC: BaseViewController {
    @IBOutlet weak var Group_Nmae: UILabel!
    @IBOutlet weak var Budz_private_pblic_img: UIImageView!
   var grp_data_model  = Group()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Group_Nmae.text = grp_data_model.title
        if(grp_data_model.is_private == 0){
            self.Budz_private_pblic_img.image = #imageLiteral(resourceName: "ic_public_group")
        }else{
            self.Budz_private_pblic_img.image = #imageLiteral(resourceName: "private_group")
        }
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
    
    
    @IBAction func Remove_Members(_ sender: Any) {
        self.BudzListingVC();
    }
    @IBAction func Edit_Group_Name(_ sender: Any) {
        self.EditScreen();
    }
    @IBAction func Edit_Group_Discription(_ sender: Any) {
        self.EditScreen();
    }
    @IBAction func Edit_TAgs(_ sender: Any) {
        self.EditScreen();
    }
    
    func EditScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditGroupDetailsVC") as! EditGroupDetailsVC
        vc.grp_data_model = self.grp_data_model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func BudzListingVC () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BudzListViewController") as! BudzListViewController
        vc.grp_data_model = grp_data_model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
