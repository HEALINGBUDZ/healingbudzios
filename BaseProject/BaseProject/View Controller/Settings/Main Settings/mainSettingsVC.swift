//
//  mainSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class mainSettingsVC: BaseViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    @IBOutlet weak var tableView_settings: UITableView!
    
    var mainArray =  [[String : Any]]()
    var isSwithOn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
        isSwithOn = true
         self.disableMenu()
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.value(forKey: "firstView") != nil) {
            
            if  ((userDefaults.value(forKey: "firstView") as! String) == "0") {
                isSwithOn = false
            }
        }
        
    }
 

}
extension mainSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : mainSettingCell.normalCell.rawValue])
        self.mainArray.append(["type" : mainSettingCell.normalCell.rawValue])
        self.mainArray.append(["type" : mainSettingCell.normalCell.rawValue])
//        self.mainArray.append(["type" : mainSettingCell.normalCell.rawValue])
        self.mainArray.append(["type" : mainSettingCell.switchCell.rawValue])
        self.RegisterXib()
       
    }

    func RegisterXib(){
        
        
        self.tableView_settings.register(UINib(nibName: "settingCell1", bundle: nil), forCellReuseIdentifier: "settingCell1")
        self.tableView_settings.register(UINib(nibName: "settingsCell2", bundle: nil), forCellReuseIdentifier: "settingsCell2")
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let DataElement = self.mainArray[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        switch dataType {
        case mainSettingCell.normalCell.rawValue:
        return settingCell1(tableView:tableView  ,cellForRowAt:indexPath)
        
        default:
            return settingCell2(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {

            let menu =       self.menuContainerViewController.centerViewController as? MainTabbar
            let navigation = menu?.selectedViewController as? BaseNavigationController
            let myProfile = self.GetView(nameViewController: "UserProfileViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserProfileViewController
            myProfile.user_id = (DataManager.sharedInstance.user?.ID)!
            navigation?.pushViewController(myProfile, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
            
        }
       else if indexPath.row == 1 {
            self.PushViewWithIdentifier(name: "businessListingSettingsVC")
        }
//        else if indexPath.row == 2{
//            self.PushViewWithIdentifier(name: "journalSettingsVC")
//        }
        else if indexPath.row == 2{
            self.PushViewWithIdentifier(name: "Notifications_AlertsVC")
        }
    
        
    }
    //MARK: settingCell1
    func settingCell1(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell1") as? settingCell1
        switch indexPath.row {
        case 0:
            cell?.Lbl_main.text = "Profile Settings"
        case 1:
            cell?.Lbl_main.text = "Business Listing Settings"
//        case 2:
//            cell?.Lbl_main.text = "Journal Settings"
        default:
            cell?.Lbl_main.text = "Notifications & Alerts"
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK: settingCell2
    func settingCell2(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell2") as? settingsCell2
        if(isSwithOn){
            cell?.switch_img.image =  #imageLiteral(resourceName: "btn_on1")
        }else{
            cell?.switch_img.image = #imageLiteral(resourceName: "btn_off")
        }
        cell?.switch_btn.tag = indexPath.row
        cell?.switch_btn.addTarget(self, action: #selector(self.SwitchAction(_sender:)), for: UIControlEvents.touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func SwitchAction(_sender : UIButton) {
        let userDefaults = UserDefaults.standard
//         userDefaults.setValue("0", forKey: "firstView")
        if(isSwithOn){
           isSwithOn =  false
            userDefaults.setValue("0", forKey: "firstView")
        }else{
           isSwithOn =  true
            userDefaults.setValue("1", forKey: "firstView")
        }
        
        userDefaults.synchronize()
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: _sender.tag, section: 0)], with: .fade)
    }
    
    @IBAction func GoBAck(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoHOme(sender : UIButton){
        self.GotoHome()
    }
    
}
class settingCell1 :UITableViewCell{
  
    @IBOutlet weak var Lbl_main: UILabel!
}
class settingsCell2 :UITableViewCell{
    @IBOutlet weak var switch_btn: UIButton!
    @IBOutlet weak var switch_img: UIImageView!
    
}
