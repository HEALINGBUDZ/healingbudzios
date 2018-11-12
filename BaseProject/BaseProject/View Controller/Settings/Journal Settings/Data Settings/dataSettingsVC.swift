//
//  dataSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class dataSettingsVC: BaseViewController {
    @IBOutlet weak var tableView_settings: UITableView!
    
    var mainArray =  [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoBAck(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoHOme(sender : UIButton){
        self.GotoHome()
    }
    


}
extension dataSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : dataSettings.dataSettingsWifiCell.rawValue, "isCheck" : false] )
        self.mainArray.append(["type" : dataSettings.dataSettingsSyncNotification.rawValue, "isCheck" : false] )
        self.mainArray.append(["type" : dataSettings.dataSettingsBackupCell.rawValue, "isCheck" : false] )
     
        
        self.RegisterXib()
        
    }
    
    func RegisterXib(){
        
        
        self.tableView_settings.register(UINib(nibName: "dataSettingsSwitchCell", bundle: nil), forCellReuseIdentifier: "dataSettingsSwitchCell")
        self.tableView_settings.register(UINib(nibName: "dataSettingsDropboxCell", bundle: nil), forCellReuseIdentifier: "dataSettingsDropboxCell")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let DataElement = self.mainArray[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        switch dataType {
        case dataSettings.dataSettingsWifiCell.rawValue:
            return dataSettingsWifiCell(tableView:tableView  ,cellForRowAt:indexPath)
        case dataSettings.dataSettingsSyncNotification.rawValue:
            return dataSettingsSyncNotification(tableView:tableView  ,cellForRowAt:indexPath)
            
        default:
            return dataSettingsDropboxCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }
    
    //MARK: settingCell1
    func dataSettingsWifiCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSettingsSwitchCell") as? dataSettingsSwitchCell
        cell?.Lbl_main.text = "Wi-Fi only"
        cell?.lbl_sub.text = "Sync only when connected to Wi-Fi"
        cell?.selectionStyle = .none
        
        if(self.mainArray[indexPath.row]["isCheck"] as? Bool ?? false){
            cell?.switch_img.image =  #imageLiteral(resourceName: "btn_on1")
        }else{
            cell?.switch_img.image = #imageLiteral(resourceName: "btn_off")
        }
        cell?.switch_btn.tag = indexPath.row
        cell?.switch_btn.addTarget(self, action: #selector(self.SwitchAction(_sender:)), for: UIControlEvents.touchUpInside)
        
        return cell!
    }
    
    func SwitchAction(_sender : UIButton) {
        var obg = self.mainArray[_sender.tag]
        if(obg["isCheck"] as? Bool ?? false ){
            obg["isCheck"] =  false
        }else{
            obg["isCheck"] =  true
        }
        self.mainArray[_sender.tag] = obg
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: _sender.tag, section: 0)], with: .fade)
    }
    //MARK: settingCell2
    func dataSettingsSyncNotification(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSettingsSwitchCell") as? dataSettingsSwitchCell
        cell?.Lbl_main.text = "Show sync notification"
        cell?.lbl_sub.text = "Show sync notification when the app is in the background"
        cell?.selectionStyle = .none
        
        if(self.mainArray[indexPath.row]["isCheck"] as? Bool ?? false){
            cell?.switch_img.image =  #imageLiteral(resourceName: "btn_on1")
        }else{
            cell?.switch_img.image = #imageLiteral(resourceName: "btn_off")
        }
        cell?.switch_btn.tag = indexPath.row
        cell?.switch_btn.addTarget(self, action: #selector(self.SwitchAction(_sender:)), for: UIControlEvents.touchUpInside)
        return cell!
    }
    func dataSettingsDropboxCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSettingsDropboxCell") as? dataSettingsDropboxCell
        
        cell?.selectionStyle = .none
        return cell!
    }
    
}
class dataSettingsSwitchCell:UITableViewCell{
    @IBOutlet weak var Lbl_main: UILabel!
    @IBOutlet weak var lbl_sub: UILabel!
    
    @IBOutlet weak var switch_btn: UIButton!
    @IBOutlet weak var switch_img: UIImageView!
    
}
class dataSettingsDropboxCell:UITableViewCell{
    
}

