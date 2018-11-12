//
//  reminderSettingsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class reminderSettingsVC: BaseViewController {
    @IBOutlet weak var tableView_settings: UITableView!
    let timePicker = UIDatePicker()
    var Reminder_Time : String = "08:00 AM"
    var mainArray =  [[String : Any]]()
    var day_selected : [Bool] = [false , true , true , true, true, false, false]
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
    func openTimePicker()  {
        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2), width: self.view.frame.width, height: (self.view.frame.height/2))
        timePicker.backgroundColor = UIColor.white
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(self.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }
    
    func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        Reminder_Time = formatter.string(from: sender.date)
        timePicker.removeFromSuperview()
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
    }
}


extension reminderSettingsVC:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()

        self.mainArray.append(["type" : reminderSettings.reminderSettingsSwitchCell.rawValue , "isCheck" : false] )
        self.mainArray.append(["type" : reminderSettings.reminderSettingsTimerCell.rawValue , "isCheck" : false] )
         self.mainArray.append(["type" : reminderSettings.reminderSettingsSwitchCell.rawValue , "isCheck" : false] )
         self.mainArray.append(["type" : reminderSettings.reminderSettingsSwitchCell.rawValue , "isCheck" : false] )
      
        self.RegisterXib()
        
    }
    
    func RegisterXib(){
        
        
        self.tableView_settings.register(UINib(nibName: "reminderSettingsSwitchCell", bundle: nil), forCellReuseIdentifier: "reminderSettingsSwitchCell")
        self.tableView_settings.register(UINib(nibName: "reminderSettingsTimerCell", bundle: nil), forCellReuseIdentifier: "reminderSettingsTimerCell")
  
        
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
        case reminderSettings.reminderSettingsSwitchCell.rawValue:
            return reminderSettingsSwitchCell(tableView:tableView  ,cellForRowAt:indexPath)
        case reminderSettings.reminderSettingsTimerCell.rawValue:
            return reminderSettingsTimerCell(tableView:tableView  ,cellForRowAt:indexPath)

        default:
            return reminderSettingsTimerCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        
        
    }
    
    //MARK: settingCell1
    func reminderSettingsSwitchCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderSettingsSwitchCell") as? reminderSettingsSwitchCell
        switch indexPath.row {
        case 0:
            cell?.Lbl_main.text = "Entry Reminders"
        case 2:
            cell?.Lbl_main.text = "Mute sound"
        default:
            cell?.Lbl_main.text = "Don't notify if entry was created on the same day"
        }
        
        if(self.mainArray[indexPath.row]["isCheck"] as? Bool ?? false){
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
    func reminderSettingsTimerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderSettingsTimerCell") as? reminderSettingsTimerCell
        
        
        if(self.day_selected[0]){
            cell?.btn_sun.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_sun.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_sun.tag = 0
        cell?.btn_sun.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[1]){
            cell?.btn_mon.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_mon.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_mon.tag = 1
        cell?.btn_mon.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[2]){
            cell?.btn_tue.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_tue.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_tue.tag = 2
        cell?.btn_tue.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[3]){
            cell?.btn_wed.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_wed.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_wed.tag = 3
        cell?.btn_wed.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[4]){
            cell?.btn_thu.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_thu.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_thu.tag = 4
        cell?.btn_thu.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[5]){
            cell?.btn_fri.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_fri.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_fri.tag = 5
        cell?.btn_fri.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        if(self.day_selected[6]){
            cell?.btn_sat.titleLabel?.textColor = UIColor.init(hex: "76C353")
        }else{
            cell?.btn_sat.titleLabel?.textColor = UIColor.white
        }
        cell?.btn_sat.tag = 6
        cell?.btn_sat.addTarget(self, action: #selector(self.SelectReminderDay(_sender:)), for: UIControlEvents.touchUpInside)
        
        cell?.reminder_Time.titleLabel?.text = Reminder_Time
        cell?.reminder_Time.addTarget(self, action: #selector(self.ReminderTime(_sender:)), for: UIControlEvents.touchUpInside)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func SelectReminderDay(_sender : UIButton) {
        if(self.day_selected[_sender.tag]){
            self.day_selected[_sender.tag] = false
        }else{
            self.day_selected[_sender.tag] = true
        }
        self.tableView_settings.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
    }
    func ReminderTime(_sender : UIButton) {
          self.openTimePicker()
    }
}
class reminderSettingsSwitchCell:UITableViewCell{
    @IBOutlet weak var Lbl_main: UILabel!
    @IBOutlet weak var switch_btn: UIButton!
    @IBOutlet weak var switch_img: UIImageView!
    
}
class reminderSettingsTimerCell:UITableViewCell{
    
    @IBOutlet weak var btn_sat: UIButton!
    @IBOutlet weak var btn_fri: UIButton!
    @IBOutlet weak var btn_thu: UIButton!
    @IBOutlet weak var btn_wed: UIButton!
    @IBOutlet weak var btn_tue: UIButton!
    @IBOutlet weak var btn_mon: UIButton!
    @IBOutlet weak var btn_sun: UIButton!
    @IBOutlet weak var reminder_Time: UIButton!
}
