//
//  FollowersViewController.swift
//  BaseProject
//
//  Created by macbook on 27/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class FollowersViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet var tbleViewMain : UITableView!
    
    @IBOutlet var lblHEading : UILabel!
    
    var delegate: UserProfileViewController!
    var delegate2: profileSettingsVC!
    
    var userMain = [User]()
    var isFollower = false
    
    var UserID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userMain.removeAll()
        if self.isFollower {
            self.lblHEading.text = "Followers"
            self.APICallFollowers()

        }else {
            self.lblHEading.text = "Following"
            self.APICallFollowings()
        }
    }
    
    func APICallFollowings(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_followings.rawValue + UserID) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            
            print(successResponse)
            print(messageResponse)
            print(MainResponse)
            
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        
                        let newUser = User.init(json: indexObj as [String : AnyObject]) as User
                        newUser.is_following_count = "1"
                        self.userMain.append(newUser)
                    }
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.tbleViewMain.reloadData()
        }
    }
    
    func APICallFollowers(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_followers.rawValue + UserID) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            
            print(successResponse)
            print(messageResponse)
            print(MainResponse)
            
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [[String : Any]]
                    for indexObj in mainData {
                        let userObj = indexObj["user"] as! [String : AnyObject]
                        
                        let newUser = User.init(json: userObj) as User
                        newUser.followed_id = String(indexObj["followed_id"] as! Int)
                        newUser.is_following_count = String(indexObj["is_following_count"] as! Int)
                        self.userMain.append(newUser)
                    }
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            self.tbleViewMain.reloadData()
        }
    }
    
    
    @IBAction func HideView(sender : UIButton){
        if delegate != nil{
        delegate.followScreen = false
        }
        self.view.removeFromSuperview()
    }
    
    
    
    func RegisterXib(){
        
        
        self.tbleViewMain.register(UINib(nibName: "FollowersCell", bundle: nil), forCellReuseIdentifier: "FollowersCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userMain.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as? FollowersCell
        
        cell?.lblName.text = self.userMain[indexPath.row].userFirstName.capitalizingFirstLetter()
        
        if self.userMain[indexPath.row].is_following_count == "0"{
            cell?.lblStatus.text = "FOLLOW +"
            cell?.lblStatus.textColor = UIColor.darkGray
            cell?.viewBG.backgroundColor = UIColor.init(red: (124/255), green: (194/255), blue: (68/255), alpha: 1.0)
        }else {
            cell?.lblStatus.text = "UNFOLLOW X"
            cell?.viewBG.backgroundColor = UIColor.darkGray
             cell?.lblStatus.textColor = UIColor.init(red: (124/255), green: (194/255), blue: (68/255), alpha: 1.0)
        }
        cell?.btnFollow.tag = indexPath.row
        cell?.btnFollow.addTarget(self, action: #selector(self.FollowUSer), for: .touchUpInside)
        cell?.selectionStyle = .none
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.userMain[indexPath.row].ID
//        self.view.removeFromSuperview()
        if delegate != nil{
            delegate.OpenProfileVC(id: id)
        }
        if delegate2 != nil{
            delegate2.OpenProfileVC(id: id)
        }
        
    }
    
    func FollowUSer(sender : UIButton){
        print(sender.tag)
        var newPAram = [String : AnyObject]()
        
        var urlMain = WebServiceName.follow_user.rawValue
        
        let userMain = self.userMain[sender.tag]
        newPAram["followed_id"] = userMain.ID as AnyObject
        
        if userMain.is_following_count == "0"{
            
            userMain.is_following_count = "1"
            
            
            let userDataDict:[String: String] = ["count": "1" , "text" : self.lblHEading.text!]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil , userInfo: userDataDict)

            
        }else {
            urlMain = WebServiceName.un_follow.rawValue
            userMain.is_following_count = "0"
            
            let userDataDict:[String: String] = ["count": "-1" , "text" : self.lblHEading.text!]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadFoloowers"), object: nil , userInfo: userDataDict)
            
        }
        

        
        self.userMain[sender.tag] = userMain
        
        self.tbleViewMain.reloadData()
        NetworkManager.PostCall(UrlAPI: urlMain, params: newPAram) { (success, message, mainData) in
            print(newPAram)
        }
    }
}

class FollowersCell : UITableViewCell{
    @IBOutlet var lblName : UILabel!
    @IBOutlet var viewBG : UIView!
    @IBOutlet var lblStatus : UILabel!
    @IBOutlet var btnFollow : UIButton!
}
