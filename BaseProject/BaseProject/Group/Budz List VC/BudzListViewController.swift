//
//  BudzListViewController.swift
//  BaseProject
//
//  Created by macbook on 21/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class BudzListViewController: BaseViewController {

    @IBOutlet weak var invite_bud_view_height: NSLayoutConstraint!
    @IBOutlet weak var tbl_invite_bud_height: NSLayoutConstraint!
    @IBOutlet weak var invite_new_bud: UIView!
     @IBOutlet weak var invite_new_bud_invite_final: UIView!
    @IBOutlet var tbleViewBudz : UITableView!
    @IBOutlet var tbleView_budz_invite : UITableView!
      @IBOutlet weak var Group_Nmae: UILabel!
     @IBOutlet weak var Budz_Count: UILabel!
     @IBOutlet weak var Budz_private_pblic_img: UIImageView!
    var grp_data_model  = Group()
    override func viewDidLoad() {
        super.viewDidLoad()
      self.Group_Nmae.text = grp_data_model.title
        self.Budz_Count.text = String(grp_data_model.get_members_count) + " BUDZ"
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
    

    override func viewWillAppear(_ animated: Bool) {
       
        self.RegisterXib()
    }
   
    @IBAction func Invite_New_Bud_action(_ sender: Any) {
       self.invite_new_bud.isHidden = false
        self.invite_new_bud.alpha = 0
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.invite_new_bud.layoutIfNeeded()
                        self.invite_new_bud.alpha = 1
        }, completion: { (finished) -> Void in
        })
       
    }
    @IBAction func Invite_new_bud_cross(_ sender: Any) {
          self.invite_new_bud.isHidden = true
    }
    
    
    @IBAction func Invite_new_bud_FirstDialg_Btn(_ sender: Any) {
        self.invite_new_bud.isHidden = true
        self.invite_new_bud_invite_final.isHidden = false
        self.invite_new_bud_invite_final.alpha = 0
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.invite_new_bud_invite_final.layoutIfNeeded()
                        self.invite_new_bud_invite_final.alpha = 1
        }, completion: { (finished) -> Void in
        })
    }
    @IBAction func Invite_new_bud_SecondDialg_Btn(_ sender: Any) {
         self.invite_new_bud_invite_final.isHidden = true
    }
    @IBAction func Invite_new_bud_cross_invite_final(_ sender: Any) {
        self.invite_new_bud_invite_final.isHidden = true
    }
}

//MARK:
//MARK: TableView Delegate
extension BudzListViewController :UITableViewDelegate , UITableViewDataSource {

    func RegisterXib(){
        
        self.tbleViewBudz.register(UINib(nibName: "BudzGroupChatCell", bundle: nil), forCellReuseIdentifier: "BudzGroupChatCell")
         self.tbleView_budz_invite.register(UINib(nibName: "BudzListInvitedTVCell", bundle: nil), forCellReuseIdentifier: "BudzListInvitedTVCell")
        
        self.tbl_invite_bud_height.constant = CGFloat((self.grp_data_model.group_members.count * 50))
        self.invite_bud_view_height.constant = 270 + CGFloat((self.grp_data_model.group_members.count * 50)) - 50
        self.tbleViewBudz.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.grp_data_model.group_members.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tbleView_budz_invite){
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudzListInvitedTVCell") as? BudzListInvitedTVCell
            cell?.selectionStyle = .none
            return cell!
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudzGroupChatCell") as? BudzGroupChatCell
        cell?.name.text = self.grp_data_model.group_members[indexPath.row].Name
        cell?.selectionStyle = .none
        return cell!
        }
    }
    
}

//MARK:
//MARK: Button Actions
extension BudzListViewController {
    @IBAction func Back_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
    }
}

class BudzGroupChatCell : UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
}
