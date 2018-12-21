//
//  MainUserViewController.swift
//  BaseProject
//

//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class MainUserViewController: BaseViewController {

    @IBOutlet var tbleViewMain : UITableView!
    
    var mainArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}


//MARK:
//MARK: TableView
extension MainUserViewController:UITableViewDelegate,UITableViewDataSource{
    func ReloadData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : profileSettings.profileSettingsUserInfo.rawValue])
        
//        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsDetailCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsEmailCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsTitleCell.rawValue])
//        self.mainArray.append(["type" : profileSettings.profileSettingsMedicalConditionsCell.rawValue])
        
        self.RegisterXib()
        
    }
    
    func RegisterXib(){
        
        self.tbleViewMain.register(UINib(nibName: "MainUserHeaderCell", bundle: nil), forCellReuseIdentifier: "MainUserHeaderCell")
//
//
//        self.tableView_settings.register(UINib(nibName: "profileSettingsDetailCell", bundle: nil), forCellReuseIdentifier: "profileSettingsDetailCell")
//        self.tableView_settings.register(UINib(nibName: "profileSettingsEmailCel", bundle: nil), forCellReuseIdentifier: "profileSettingsEmailCel")
//        self.tableView_settings.register(UINib(nibName: "profileSettingsEmailCell", bundle: nil), forCellReuseIdentifier: "profileSettingsEmailCell")
//        self.tableView_settings.register(UINib(nibName: "profileSettingsMedicalConditionsCell", bundle: nil), forCellReuseIdentifier: "profileSettingsMedicalConditionsCell")
        self.tbleViewMain.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let DataElement = self.mainArray[indexPath.row]
        
        let dataType = DataElement["type"] as! String
        switch dataType {
//        case profileSettings.profileSettingsTitleCell.rawValue:
//            return profileSettingsTitleCell(tableView:tableView  ,cellForRowAt:indexPath)
        case profileSettings.profileSettingsUserInfo.rawValue:
            return profileInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
//
//        case profileSettings.profileSettingsDetailCell.rawValue:
//            return profileSettingsDetailCell(tableView:tableView  ,cellForRowAt:indexPath)
//        case profileSettings.profileSettingsEmailCell.rawValue:
//            return profileSettingsEmailCell(tableView:tableView  ,cellForRowAt:indexPath)
//        case profileSettings.profileSettingsMedicalConditionsCell.rawValue:
//            return profileSettingsMedicalConditionsCell(tableView:tableView  ,cellForRowAt:indexPath)
        default:
            break
//            return profileSettingsMedicalConditionsCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
        return profileInfoCell(tableView:tableView  ,cellForRowAt:indexPath)
    }
    
    
    //MARK: settingCell0
    func profileInfoCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainUserHeaderCell") as? MainUserHeaderCell
        
         cell?.btn_BoomingBud.addTarget(self, action: #selector(self.BloomingBud), for: UIControlEvents.touchUpInside)
        
        
        
        cell?.btn_Gallery.addTarget(self, action: #selector(self.ShowGallery), for: UIControlEvents.touchUpInside)
        
        
        
//        cell?.btn_UploadImage.addTarget(self, action: #selector(self.ShowUploadImage), for: UIControlEvents.touchUpInside)
//
//        cell?.btn_Followers.addTarget(self, action: #selector(self.ShowFollowers), for: UIControlEvents.touchUpInside)
//
//        cell?.btn_Following.addTarget(self, action: #selector(self.ShowFollowing), for: UIControlEvents.touchUpInside)
        
        
//        cell?.btn_Back.addTarget(self, action: #selector(self.BackAction), for: UIControlEvents.touchUpInside)
//        
//        cell?.btn_Home.addTarget(self, action: #selector(self.HomeAction), for: UIControlEvents.touchUpInside)
        
//        cell?.btn_EditCoverPhoto.addTarget(self, action: #selector(self.EditoverPhotoAction), for: UIControlEvents.touchUpInside)
        
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func ShowGallery(sender : UIButton){
        
        
        let viewMain = self.GetView(nameViewController: "UserGalleryViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserGalleryViewController
//        viewMain.userID = self..ID
        self.navigationController?.pushViewController(viewMain, animated: true)
        
        
    }

    
    
    func BloomingBud(sender : UIButton){
        
        let viewMain = self.GetView(nameViewController: "BloomingBudViewController", nameStoryBoard: StoryBoardConstant.Profile) as! BloomingBudViewController
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.red
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    
}

//MARK:
//MARK: Button Actions

extension MainUserViewController {
    @IBAction func GoBack_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home_Action(sender : UIButton){
        self.GotoHome()        
    }
}



class MainUserHeaderCell : UITableViewCell {
    @IBOutlet var btn_Message : UIButton!
    @IBOutlet var btn_Back : UIButton!
    @IBOutlet var btn_Home : UIButton!
    @IBOutlet var btn_Followers : UIButton!
    @IBOutlet var btn_Follow : UIButton!
    @IBOutlet var btn_Following : UIButton!
    @IBOutlet var btn_Gallery : UIButton!
    @IBOutlet var btn_BoomingBud : UIButton!
    @IBOutlet var btn_Edit : UIButton!
    
    @IBOutlet var lblBloomingBud : UILabel!
    
}

class MainUserTitleHeadingCell : UITableViewCell {
    @IBOutlet var lblMain: UILabel!
}


