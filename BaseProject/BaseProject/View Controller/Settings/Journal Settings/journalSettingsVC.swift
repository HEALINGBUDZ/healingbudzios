//
//  journalSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class journalSettingsVC: BaseViewController {
    @IBOutlet weak var tableView_settings: UITableView!
    
    var mainArray =  [[String : Any]]()
    var isSwithOn = false
    override func viewDidLoad() {
        super.viewDidLoad()
         self.RegisterXib()
         self.ReloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension journalSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : journalSettings.quickEntryCell.rawValue])
        self.mainArray.append(["type" : journalSettings.reminderCell.rawValue])
        self.mainArray.append(["type" : journalSettings.dataCell.rawValue])
       
        
    }
    
    func RegisterXib(){
        
        
        self.tableView_settings.register(UINib(nibName: "journalSettingCell1", bundle: nil), forCellReuseIdentifier: "journalSettingCell1")
        self.tableView_settings.register(UINib(nibName: "journalSettingCell2", bundle: nil), forCellReuseIdentifier: "journalSettingCell2")
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.PushViewWithIdentifier(name: "reminderSettingsVC")
        }
        else if indexPath.row == 2{
            self.PushViewWithIdentifier(name: "dataSettingsVC")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let DataElement = self.mainArray[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        switch dataType {
        case journalSettings.quickEntryCell.rawValue:
            return journalSettingCell1(tableView:tableView  ,cellForRowAt:indexPath)
            
        default:
              //  return journalSettingCell1(tableView:tableView  ,cellForRowAt:indexPath)
            return journalSettingCell2(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }
 
    //MARK: settingCell1
    func journalSettingCell1(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalSettingCell1") as? journalSettingCell1
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
        if(isSwithOn){
            isSwithOn =  false
        }else{
            isSwithOn =  true
        }
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: _sender.tag, section: 0)], with: .fade)
    }
    //MARK: settingCell2
    func journalSettingCell2(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalSettingCell2") as? journalSettingCell2
        if indexPath.row == 1{
            cell?.Lbl_title.text = "Reminders"
            cell?.Lbl_subtitle.text = "Set writing reminders"
        }
        else{
            cell?.Lbl_title.text = "Data"
            cell?.Lbl_subtitle.text = "Sync,backup & restore"
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    @IBAction func GoBAck(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoHOme(sender : UIButton){
        self.GotoHome()
    }
    
}
class journalSettingCell1 :UITableViewCell{
    @IBOutlet weak var switch_btn: UIButton!
    @IBOutlet weak var switch_img: UIImageView!
}
class journalSettingCell2 :UITableViewCell{
    @IBOutlet weak var Lbl_title: UILabel!
    @IBOutlet weak var Lbl_subtitle: UILabel!
    
}
