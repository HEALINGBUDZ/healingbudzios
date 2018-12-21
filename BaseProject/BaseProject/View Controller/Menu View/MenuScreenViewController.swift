//
//  MenuScreenViewController.swift
//  BaseProject
//
//  Created by Vengile on 15/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class MenuScreenViewController: BaseViewController {
    
    var arrayMenu = [MenuObj]()
    
    @IBOutlet var tbleViewMain : UITableView!
    
    @IBOutlet weak var lblDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
       
//        self.lblDate.text = "@" + "\(year)" + " HealingBudz";
        NotificationCenter.default.addObserver(self, selector: #selector(self.HomeScreenLoading(notification:)), name: Notification.Name("HomeView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateUI(notification:)), name: Notification.Name("UpdateUI"), object: nil)
        self.ReloadArray()
        
        
        self.tbleViewMain.register(UINib(nibName: "HeaderMenuCell", bundle: nil), forCellReuseIdentifier: "HeaderMenuCell")
        self.tbleViewMain.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
        //		self.tbleViewMain.register(UINib(nibName: "MenuImageCell", bundle: nil), forCellReuseIdentifier: "MenuImageCell")
        
        if(DeviceType.IS_IPHONE_5_OR_LESS){
            self.tbleViewMain.isScrollEnabled = true
        }else{
            self.tbleViewMain.isScrollEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tbleViewMain.keyboardDismissMode = .onDrag
        self.RefreshData {
            self.tbleViewMain.reloadData()
        }
        self.tbleViewMain.reloadData()
        self.tbleViewMain.flashScrollIndicators()
    }
    
}


extension MenuScreenViewController : UITableViewDelegate ,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        let tabl_height : CGFloat  = ( self.tbleViewMain.frame.height - 70 ) / 9
        return tabl_height
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return self.HEaderCell(tableView, cellForRowAt: indexPath)
        }
        
        return self.MenuCell(tableView, cellForRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        
        let menu =       self.menuContainerViewController.centerViewController as? MainTabbar
        let navigation = menu?.selectedViewController as? BaseNavigationController
                
        print(indexPath.row)
    
      if indexPath.row == -1 {
            
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "Homescreen")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
            
            
      }else if indexPath.row == 1 {
        let move = self.GetView(nameViewController: "NewBudzMapViewController", nameStoryBoard: "Main") as! NewBudzMapViewController
        move.afterCompleting = 1
        navigation?.pushViewController(move, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
      }else if indexPath.row == 2 {
        let mySaveVC = self.GetView(nameViewController: "AllBudzVC", nameStoryBoard: "ProfileView") as! AllBudzVC
        navigation?.pushViewController(mySaveVC, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
      }else if indexPath.row == 3 {
            let mySaveVC = self.GetView(nameViewController: "MyWallViewController", nameStoryBoard: "Wall") as! MyWallViewController
            navigation?.pushViewController(mySaveVC, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
        }else if indexPath.row == 4 {
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "ActivityLogVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
            
        }else if indexPath.row == 5 {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openMessageVc"), object: nil)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)

        }else if indexPath.row == 6 {
            
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "MyQuestionsVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)

            
        }else if indexPath.row == 7 {
            
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "myAnwerVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)

            
        }else if indexPath.row == 8 {
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "myStrainVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)

            
            
        }else if indexPath.row == 9 {
            
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "MyBudzMapVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)

            
        }else if indexPath.row == 10 {
            let rewards_vc = self.GetView(nameViewController: "MyRewardsVC", nameStoryBoard: "Rewards")
            navigation?.pushViewController(rewards_vc, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
        }else if indexPath.row == 11 {
            let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "mySaveVC")
            navigation?.pushViewController(mySaveVC!, animated: true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
        }
    }
    
}

extension MenuScreenViewController {
    
    func HEaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "HeaderMenuCell") as! HeaderMenuCell
        cellHeader.btn_Gear.addTarget(self, action: #selector(GotoSetting), for: .touchUpInside)
        cellHeader.btn_UserProfile.addTarget(self, action: #selector(GotoUserProfile), for: .touchUpInside)
        cellHeader.lbl_Name.text = DataManager.sharedInstance.user?.userFirstName
        if (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace().contains("facebook.com") || (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace().contains("google.com"){
            cellHeader.imgView_User.sd_addActivityIndicator()
            cellHeader.imgView_User.sd_setShowActivityIndicatorView(true)
            cellHeader.imgView_User.sd_showActivityIndicatorView()
            cellHeader.imgView_User.sd_setImage(with: URL.init(string:  (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace()), placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"),completed: nil)
        }else{
             cellHeader.imgView_User.sd_setImage(with: URL.init(string:  WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace()), placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"), completed: nil)
        }
        if (DataManager.sharedInstance.user?.special_icon.count)! > 6
        {
            cellHeader.imgView_UserTop.isHidden = false
            cellHeader.imgView_UserTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.special_icon.trimmingCharacters(in: .whitespaces))!.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic")) { (Iamge, Error, Chache, url) in
                if Error != nil{
                    cellHeader.imgView_UserTop.image = #imageLiteral(resourceName: "noimage")
                }else {
                    cellHeader.imgView_UserTop.image = Iamge
                }
            }
        }else {
            cellHeader.imgView_UserTop.isHidden = true
        }
        print(WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.profilePictureURL)!)
        cellHeader.selectionStyle = .none
        return cellHeader
    }
    
    func GotoSetting(sender : UIButton){
        let menu =       self.menuContainerViewController.centerViewController as? MainTabbar
        let navigation = menu?.selectedViewController as? BaseNavigationController
        let mySaveVC = self.storyboard?.instantiateViewController(withIdentifier: "mainSettingsVC")
        navigation?.pushViewController(mySaveVC!, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
    
    func GotoUserProfile(sender : UIButton){
        
        
        let menu =       self.menuContainerViewController.centerViewController as? MainTabbar
        let navigation = menu?.selectedViewController as? BaseNavigationController
        let myProfile = self.GetView(nameViewController: "UserProfileViewController", nameStoryBoard: StoryBoardConstant.Profile)  as! UserProfileViewController
        myProfile.user_id = (DataManager.sharedInstance.user?.ID)!
        navigation?.pushViewController(myProfile, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
    
    func MenuCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
        cellMenu.lbl_Name.text = self.arrayMenu[indexPath.row].name
        cellMenu.imgView_Main.tintColor = UIColor.init(hex: "363736")
        cellMenu.imgView_Main.image?.withRenderingMode(.alwaysTemplate)
        cellMenu.imgView_Main.image = UIImage.init(named: self.arrayMenu[indexPath.row].imageName)!.withRenderingMode(.alwaysTemplate)
        cellMenu.imgView_Main.tintColor = UIColor.init(hex: "363736")
        cellMenu.imgView_Main.image?.withRenderingMode(.alwaysTemplate)
        cellMenu.selectionStyle = .none
        return cellMenu
    }
    
    func MenuImageCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuImageCell") as! MenuImageCell
        cellMenu.imgview_Main.image = UIImage.init(named: "Export")
        cellMenu.selectionStyle = .none
        return cellMenu
    }
    
    func ReloadArray(){
        
        let userobj = MenuObj()
        userobj.name = "user"
        userobj.imageName = ""
        
        let allBudz = MenuObj()
        allBudz.name = "All Budz"
        allBudz.imageName = "ic_feed_user"
        
        let activityObj = MenuObj()
        activityObj.name = "Activity Log"
        activityObj.imageName = "activity"
        
        let myHome = MenuObj()
        myHome.name = "Home"
        myHome.imageName = "home"
        
        
        let myWall = MenuObj()
        myWall.name = "My Buzz"
        myWall.imageName = "my_wall"
        
        let messageObj = MenuObj()
        messageObj.name = "Messages"
        messageObj.imageName = "messages"
        
//        let journalObj = MenuObj()
//        journalObj.name = "My Journal"
//        journalObj.imageName = "journals"
        
        let questionObj = MenuObj()
        questionObj.name = "My Questions"
        questionObj.imageName = "question"
        
        let answerObj = MenuObj()
        answerObj.name = "My Answers"
        answerObj.imageName = "answers"
        
//        let groupObj = MenuObj()
//        groupObj.name = "My Groups"
//        groupObj.imageName = "groups"
        
        let strinsObj = MenuObj()
        strinsObj.name = "My Strains"
        strinsObj.imageName = "strains"
        
        let mapObj = MenuObj()
        mapObj.name = "My Budz Adz"
        mapObj.imageName = "budztabnew_gray"
        
        let rewardObj = MenuObj()
        rewardObj.name = "My Rewards"
        rewardObj.imageName = "rewards"
        
        
        let saveObj = MenuObj()
        saveObj.name = "My Saves"
        saveObj.imageName = "saves"
        
        let AddBusinessObj = MenuObj()
        AddBusinessObj.name = "Add a Business Listing"
        AddBusinessObj.imageName = "add_new_bdzGraymenu"
        
        
        
        self.arrayMenu.append(userobj)
        self.arrayMenu.append(AddBusinessObj)
        self.arrayMenu.append(allBudz)
        self.arrayMenu.append(myWall)
        self.arrayMenu.append(activityObj)
        self.arrayMenu.append(messageObj)
        self.arrayMenu.append(questionObj)
        self.arrayMenu.append(answerObj)
        self.arrayMenu.append(strinsObj)
        self.arrayMenu.append(mapObj)
        self.arrayMenu.append(rewardObj)
        self.arrayMenu.append(saveObj)
        
    }
    
    
    
    func HomeScreenLoading(notification: NSNotification){
        let centerViewNavigation = self.menuContainerViewController.centerViewController as! UITabBarController
        
        centerViewNavigation.selectedIndex = 0
        let navigationMain = centerViewNavigation.selectedViewController as! BaseNavigationController
        
        let viewAbout  = self.GetViewcontrollerWithName(nameViewController: "UserWallViewController")
            
//            "Homescreen")
        
        navigationMain.viewControllers = [viewAbout]
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
    
    func UpdateUI(notification: NSNotification){
        let cellHeader = self.tbleViewMain.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HeaderMenuCell
        cellHeader.imgView_User.image = #imageLiteral(resourceName: "user_placeholder_Budz")
        cellHeader.lbl_Name.text = DataManager.sharedInstance.user?.userFirstName
        if (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace().contains("facebook.com") || (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace().contains("google.com"){
            cellHeader.imgView_User.sd_addActivityIndicator()
            cellHeader.imgView_User.sd_showActivityIndicatorView()
            cellHeader.imgView_User.sd_setShowActivityIndicatorView(true)
            cellHeader.imgView_User.sd_setImage(with: URL.init(string: (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace()), placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"),completed: nil)
        }else{
            cellHeader.imgView_User.sd_addActivityIndicator()
            cellHeader.imgView_User.sd_showActivityIndicatorView()
            cellHeader.imgView_User.sd_setShowActivityIndicatorView(true)
            cellHeader.imgView_User.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.profilePictureURL)!.RemoveSpace()), placeholderImage : #imageLiteral(resourceName: "user_placeholder_Budz"),completed: nil)
        }
        if (DataManager.sharedInstance.user?.special_icon.characters.count)! > 6
        {
            cellHeader.imgView_UserTop.isHidden = false
            cellHeader.imgView_UserTop.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.special_icon.trimmingCharacters(in: .whitespaces))!.RemoveSpace()), placeholderImage: #imageLiteral(resourceName: "topi_ic")) { (Iamge, Error, Chache, url) in
                if Error != nil{
                    cellHeader.imgView_UserTop.image = #imageLiteral(resourceName: "noimage")
                }else {
                    cellHeader.imgView_UserTop.image = Iamge
                }
            }
        }else {
            cellHeader.imgView_UserTop.isHidden = true
        }
//        cellHeader.imgView_UserTop.moa.url = WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.getPermanentlySavedUser()?.special_icon.trimmingCharacters(in: .whitespaces))!.RemoveSpace()
        
        
        print(WebServiceName.images_baseurl.rawValue + (DataManager.sharedInstance.user?.profilePictureURL)!)
        self.tbleViewMain.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
    }
    @IBAction func Goto_SupportAction(sender : UIButton){
        
        let menu =       self.menuContainerViewController.centerViewController as? MainTabbar
        let navigation = menu?.selectedViewController as? BaseNavigationController
        let supportvc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC")
        navigation?.pushViewController(supportvc!, animated: true)
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
}


class HeaderMenuCell: UITableViewCell {
    @IBOutlet var lbl_Name      : UILabel!
    @IBOutlet var imgView_User  : UIImageView!
    @IBOutlet var imgView_UserTop  : UIImageView!
    @IBOutlet var btn_Gear      : UIButton!
    @IBOutlet var btn_UserProfile      : UIButton!
}


class MenuItemCell: UITableViewCell {
    @IBOutlet var lbl_Name      : UILabel!
    @IBOutlet var imgView_Main  : UIImageView!
    
}
