//
//  FollowKeyword.swift
//  BaseProject
//
//  Created by Jawad on 8/11/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class FollowKeyword: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    var tags_array = [[String : Any]]()
    var total_keywords = [String]()
    @IBOutlet weak var tbl_view: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        total_keywords = appdelegate.keywords
        self.getUserKeywords()
        self.tbl_view.register(UINib(nibName: "FollowersCell", bundle: nil), forCellReuseIdentifier: "FollowersCell")
    }

    func getUserKeywords(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.getKeywords.rawValue) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.hideLoading()
            if successRespons {
                if (dataResponse["status"] as! String) == "success" {
                    let maindata = dataResponse["successData"] as! [[String : AnyObject]]
                    self.tags_array = maindata
                    

                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
               
                for keywrd in self.tags_array{
                    let tags_obj = keywrd
                    if let tags = tags_obj["tag"] as? [String : Any]{
                        if let tag_title = tags["title"] as? String{
                            if self.total_keywords.contains(tag_title){
                                self.total_keywords.remove(at: self.total_keywords.index(of: tag_title)!)
                            }
                        }
                    }
                }
               
                self.tbl_view.reloadData()
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.Back()

    }
    @IBAction func onClickHome(_ sender: Any) {
         self.GotoHome()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags_array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as? FollowersCell
        cell?.lblName.text = ((self.tags_array[indexPath.row])["title"] as! String).capitalizingFirstLetter()
        
        cell?.lblName.textColor = UIColor.white.withAlphaComponent(0.8)
        cell?.lblStatus.text = "FOLLOW +"
        if ((self.tags_array[indexPath.row])["is_following_count"] as! Int) == 1 {
            cell?.lblStatus.text = "UNFOLLOW"
            cell?.btnFollow.tag = indexPath.row
            cell?.btnFollow.addTarget(self, action: #selector(self.followKeyword(sender:)), for: .touchUpInside)
        }else {
            cell?.btnFollow.tag = indexPath.row
            cell?.lblStatus.text = "FOLLOW +"
            cell?.btnFollow.addTarget(self, action: #selector(self.followKeyword(sender:)), for: .touchUpInside)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func unfollowKeyword(sender : UIButton){
        print(sender.tag)
        let keyword  = ((self.tags_array[sender.tag])["title"] as! String)
        var newparam = [String : AnyObject]()
        self.showLoading()
        newparam["keyword"] = keyword as AnyObject
        let url = WebServiceName.remove_tag.rawValue + "/\(((self.tags_array[sender.tag])["id"] as! Int))"
        NetworkManager.GetCall(UrlAPI: url) { (success, MainMessage, response) in
            print(success)
            print(MainMessage)
            print(response)
            self.hideLoading()
            if success {
                (self.tags_array[sender.tag])["is_following_count"] = 0
                self.tbl_view.reloadData()
                self.total_keywords.remove(at: sender.tag)
                self.tbl_view.reloadData()
                self.oneBtnCustomeAlert(title: "", discription: response["successMessage"] as! String) { (isBtnClik, btnNmbr) in
                }
            }else {
                self.simpleCustomeAlert(title: "Error", discription: "Error Following Keyword!")
            }
        }
    }
    func followKeyword(sender : UIButton){
        print(sender.tag)
        if ((self.tags_array[sender.tag])["is_following_count"] as! Int) == 1 {
            let keyword  = ((self.tags_array[sender.tag])["title"] as! String)
            var newparam = [String : AnyObject]()
            self.showLoading()
            newparam["keyword"] = keyword as AnyObject
            let url = WebServiceName.remove_tag.rawValue + "/\(((self.tags_array[sender.tag])["id"] as! Int))"
            NetworkManager.GetCall(UrlAPI: url) { (success, MainMessage, response) in
                print(success)
                print(MainMessage)
                print(response)
                self.hideLoading()
                if success {
                    (self.tags_array[sender.tag])["is_following_count"] = 0
                    
                    self.tbl_view.reloadData()
                    
                    
                    self.oneBtnCustomeAlert(title: "", discription: response["successMessage"] as! String) { (isBtnClik, btnNmbr) in
                    }
                }else {
                    self.simpleCustomeAlert(title: "Error", discription: "Error Following Keyword!")
                }
            }
        }else {
            let keyword  = ((self.tags_array[sender.tag])["title"] as! String)
            var newparam = [String : AnyObject]()
            self.showLoading()
            newparam["keyword"] = keyword as AnyObject
            NetworkManager.PostCall(UrlAPI: WebServiceName.follow_keyword.rawValue, params: newparam) { (success, MainMessage, response) in
                print(success)
                print(MainMessage)
                print(response)
                self.hideLoading()
                if success {
                    (self.tags_array[sender.tag])["is_following_count"] = 1
                    (self.tags_array[sender.tag])["id"] = response["successData"]!["id"] as! Int
                    self.tbl_view.reloadData()
                    
                    
                    self.oneBtnCustomeAlert(title: "", discription: response["successMessage"] as! String) { (isBtnClik, btnNmbr) in
                    }
                }else {
                    self.simpleCustomeAlert(title: "Error", discription: "Error Following Keyword!")
                }
            }
        }
    }
}
