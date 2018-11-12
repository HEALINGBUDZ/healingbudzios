//
//  GroupChatViewController.swift
//  BaseProject
//
//  Created by macbook on 20/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class GroupChatViewController: BaseViewController {

    @IBOutlet var tbleViewChat : UITableView!
    @IBOutlet weak var group_name: UILabel!
    @IBOutlet weak var group_img: UIImageView!
    @IBOutlet var txtField_chat : UITextField!
    @IBOutlet var tbleView_GroupInfo : UITableView!
    @IBOutlet var viewInfo : UIView!
    @IBOutlet weak var InfoTopValue: NSLayoutConstraint!
    @IBOutlet weak var InfoHeightValue: NSLayoutConstraint!
    var arraychat = [String]()
     var grp_data_model  = Group()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.group_name.text = grp_data_model.title
        self.group_img.image = UIImage.init(named: grp_data_model.image)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.InfoTopValue.constant = UIScreen.main.bounds.height * -1
        self.RegisterXib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.InfoHeightValue.constant = UIScreen.main.bounds.height - 35
    }
    
    func Duymmydata(){
        arraychat.removeAll()
        self.arraychat.append("Hi everyone,I'm new to the group. I live in Miami. Hi everyone,I'm new to the group. I live in Miami. Hi everyone,I'm new to the group. I live in Miami. Hi everyone,I'm new to the group. I live in Miami. Hi everyone,I'm new to the group. I live in Miami.")
        
        
        self.tbleViewChat.reloadData()
    }
    
}

//MARK:
//MARK: UItableView Action
extension GroupChatViewController  : UITableViewDelegate , UITableViewDataSource {
    
    func RegisterXib(){
        
        self.tbleViewChat.register(UINib(nibName: "ChatTextCell", bundle: nil), forCellReuseIdentifier: "ChatTextCell")

        self.tbleView_GroupInfo.register(UINib(nibName: "GroupInfoImagecell", bundle: nil), forCellReuseIdentifier: "GroupInfoImagecell")
        
        self.tbleView_GroupInfo.register(UINib(nibName: "GroupDescriptionCell", bundle: nil), forCellReuseIdentifier: "GroupDescriptionCell")

        self.tbleView_GroupInfo.register(UINib(nibName: "GroupTagCell", bundle: nil), forCellReuseIdentifier: "GroupTagCell")

          self.tbleView_GroupInfo.register(UINib(nibName: "GroupDetailCell", bundle: nil), forCellReuseIdentifier: "GroupDetailCell")
        
        self.tbleView_GroupInfo.register(UINib(nibName: "JoinGroupCell", bundle: nil), forCellReuseIdentifier: "JoinGroupCell")
        
        
        
        self.Duymmydata()
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return 6
        }
        return self.arraychat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            
            switch indexPath.row {
            case 1:
                return GroupDescriptioncell(tableView:tableView ,cellForRowAt:indexPath)
                
            case 2:
               return GroupTagcell(tableView:tableView ,cellForRowAt:indexPath)
                
            case 3,4:
                return GroupDetailcell(tableView:tableView ,cellForRowAt:indexPath)
            
            case 5:
                return GroupJoincell(tableView:tableView ,cellForRowAt:indexPath)
                
            default:
                return self.GroupInfoImagecell(tableView:tableView ,cellForRowAt:indexPath)
            }
            
        }else {
            return self.ChatTextCell(tableView:tableView ,cellForRowAt:indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            print(indexPath)
            
            if indexPath.row == 4 {
              self.PushViewWithIdentifier(name: "GroupSettingsViewController")
            }else if indexPath.row == 3 {
                self.PushViewWithIdentifier(name: "BudzListViewController")
            }
        }
    }
    
    func ChatTextCell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTextCell") as? ChatTextCell
        
        cell?.lbl_MainData.text = self.arraychat[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func GroupInfoImagecell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupInfoImagecell") as? GroupInfoImagecell
        
        cell?.btn_Back.addTarget(self, action: #selector(self.GoBack_Action), for: UIControlEvents.touchUpInside)
        cell?.btn_Home.addTarget(self, action: #selector(self.Home_Action), for: UIControlEvents.touchUpInside)

        cell?.selectionStyle = .none
        return cell!
    }

    
    
    func GroupDescriptioncell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDescriptionCell") as? GroupDescriptionCell
        
        cell?.selectionStyle = .none
        return cell!
    }

    
    func GroupTagcell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTagCell") as? GroupTagCell
        
        cell?.selectionStyle = .none
        return cell!
    }

    
    func GroupDetailcell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailCell") as? GroupDetailCell
        
        if indexPath.row == 3 {
            cell?.lbl_Main.text = "122 Budz"
        }else {
            cell?.lbl_Main.text = "Settings"
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func GroupJoincell(tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "JoinGroupCell") as? JoinGroupCell
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
}


//MARK:
//MARK: Button Actions
extension GroupChatViewController  {
     override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
        self.arraychat.append(textField.text!)
        }
        
        self.tbleViewChat.reloadData()
        
        self.txtField_chat.text = ""
        return true
        
    }
    
    @IBAction func SendMessage_Action(){
        if (self.txtField_chat.text?.characters.count)! > 0 {
            self.arraychat.append(self.txtField_chat.text!)
        }
        
        self.tbleViewChat.reloadData()
        
        self.txtField_chat.text = ""
        
        self.txtField_chat.resignFirstResponder()
    }
    
    @IBAction func GoBack_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
    }
    
    @IBAction func ShowFilterView(sender : UIButton){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.InfoTopValue.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func HideFilterView(sender : UIButton){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.InfoTopValue.constant = UIScreen.main.bounds.height * -1
            self.view.layoutIfNeeded()
        })
    }
}

class ChatTextCell: UITableViewCell {
    @IBOutlet var lbl_MainData : UILabel!
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_LikeCount : UILabel!
    
    @IBOutlet var imgView_Main : UIImageView!
    @IBOutlet var imgView_Like : UIImageView!
    
}

class GroupInfoImagecell : UITableViewCell {

    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Home : UIButton!
}



class GroupDescriptionCell : UITableViewCell {
    
}


class GroupTagCell : UITableViewCell {
    
}


class GroupDetailCell : UITableViewCell {
    @IBOutlet var lbl_Main : UILabel!
}

class JoinGroupCell : UITableViewCell {
    
}
