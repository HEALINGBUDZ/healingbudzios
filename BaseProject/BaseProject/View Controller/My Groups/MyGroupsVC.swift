//
//  MyGroupsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 25/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class MyGroupsVC: BaseViewController {

    @IBOutlet weak var tableView_myGroups: UITableView!
     var group_list = [Group]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        self.InitGroup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    // MARK: - Navigation
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func InitGroup() {
        let dis : String  =  "This group Disciption is added just for testig, so please ignore it, remove it and add new one.... "
        let grp = Group()
        grp.id = 1
        grp.title = "Smoking Bud"
        grp.get_members_count = 2
        grp.group_message_count = 0
        grp.is_private = 0
        grp.isCurrentUserAdmin = false
        grp.image = "test_img"
        grp.group_description = dis
        var members_List = [GroupMembers]()
        // Memeber 1
        let memb_obj = GroupMembers()
        memb_obj.Name = "Alex 1"
        members_List.append(memb_obj)
        
        // Memeber 2
        let memb_obj1 = GroupMembers()
        memb_obj1.Name = "Alex 2"
        members_List.append(memb_obj1)
        
        grp.group_members = members_List
        self.group_list.append(grp)
        
        
        let grp1 = Group()
        grp1.id = 2
        grp1.title = "Mojo MMJ Medical"
        grp1.get_members_count = 2
        grp1.group_message_count = 0
        grp1.is_private = 0
         grp1.group_description = dis
        grp1.isCurrentUserAdmin = true
        grp1.image = "bgimage5"
        grp1.group_members = members_List
        self.group_list.append(grp1)
    
        let grp2 = Group()
        grp2.id = 2
        grp2.title = "Budderz"
        grp2.get_members_count = 2
        grp2.group_message_count = 0
        grp2.is_private = 0
        grp2.image = "logo"
         grp2.group_description = dis
        grp2.isCurrentUserAdmin = false
         grp2.group_members = members_List
        self.group_list.append(grp2)
        self.tableView_myGroups.reloadData()
    }


}
extension MyGroupsVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        self.tableView_myGroups.register(UINib(nibName: "myGroupCell", bundle: nil), forCellReuseIdentifier: "myGroupCell")
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group_list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        return myGroupCell(tableView:tableView  ,cellForRowAt:indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grp_obg = self.group_list[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
        vc.grp_data_model = grp_obg
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: mySaveCell
    func myGroupCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupCell") as? myGroupCell
//        cell?.notification_View.layer.cornerRadius = (cell?.notification_View.bounds.size.width)!/2;
        let grp_obg = self.group_list[indexPath.row]
           cell?.private_View.isHidden = false
        if(grp_obg.is_private == 0){
            cell?.prvt_pblc_icon.image = #imageLiteral(resourceName: "ic_public_group")
        }else{
            cell?.prvt_pblc_icon.image = #imageLiteral(resourceName: "private_group")
        }
        cell?.Lbl_Title.text = grp_obg.title
        cell?.Lbl_TotalBudz.text = String(grp_obg.get_members_count) + " Budz"
        cell?.group_img.image = UIImage.init(named: grp_obg.image )
        if(grp_obg.isCurrentUserAdmin){
            cell?.members_view.isHidden = false
            cell?.edit_view_icon.image = UIImage.init(named: "Edit-QA-Icons")
        }else{
             cell?.members_view.isHidden = true
            cell?.edit_view_icon.image = #imageLiteral(resourceName: "men")
        }
        cell?.edit_view_button.tag = indexPath.row
         cell?.members_button.tag = indexPath.row
        cell?.edit_view_button.addTarget(self, action: #selector(self.EditGroup_Btn_Action), for: UIControlEvents.touchUpInside)
        cell?.members_button.addTarget(self, action: #selector(self.GroupMembers_Btn_Action), for: UIControlEvents.touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func EditGroup_Btn_Action(sender : UIButton){
        let grp_obg = self.group_list[sender.tag]
        if(grp_obg.isCurrentUserAdmin){
            // Go To Edit Screen
            let grp_obg = self.group_list[sender.tag]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditGroupVC") as! EditGroupVC
            vc.grp_data_model = grp_obg
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            // Go To Members Screen
            self.BudzListingVC(index: sender.tag)
        }
    }
    
    func GroupMembers_Btn_Action(sender : UIButton){
         // Go To Members Screen
        self.BudzListingVC(index: sender.tag)
    }
    
    func BudzListingVC (index : Int ) {
        let grp_obg = self.group_list[index]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BudzListViewController") as! BudzListViewController
        vc.grp_data_model = grp_obg
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
class myGroupCell :UITableViewCell{
    
    @IBOutlet weak var prvt_pblc_icon: UIImageView!
    @IBOutlet weak var members_view: UIView!
    
    @IBOutlet weak var edit_view: UIView!
    @IBOutlet weak var edit_view_icon: UIImageView!
    
    @IBOutlet weak var members_button: UIButton!
    @IBOutlet weak var edit_view_button: UIButton!
    @IBOutlet weak var notification_View: UIView!
    @IBOutlet weak var private_View: UIView!
    @IBOutlet weak var group_img: RoundImageView!
    @IBOutlet weak var Lbl_notification: UILabel!
     @IBOutlet weak var Lbl_Title: UILabel!
     @IBOutlet weak var Lbl_TotalBudz: UILabel!
}
