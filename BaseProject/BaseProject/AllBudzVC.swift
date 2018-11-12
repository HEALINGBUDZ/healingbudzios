//
//  AllBudzVC.swift
//  BaseProject
//
//  Created by lucky on 10/31/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class AllBudzVC: BaseViewController {
    var array_Answer = [User]()
    var choose_Answer = User()
    var pageNumber = 0
    fileprivate var shouldLoadMore = true
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView_myAnswer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_myAnswer.addSubview(refreshControl)
        self.APICAllForMyAnswers(page:  0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        
        
        self.pageNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.APICAllForMyAnswers(page:  0)
            
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func APICAllForMyAnswers(page : Int){
        self.showLoading()
        let mainUrl = "get_all_users?skip=" + String(page)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successResponse, messageResponse, dataResponse) in
            print(dataResponse)
            self.hideLoading()
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    let mainData = dataResponse["successData"] as! [[String : Any]]
                    
                    if page > 0{
                    }else{
                        self.array_Answer.removeAll()
                    }
                    for indexObj in mainData {
                        self.array_Answer.append(User.init(json: indexObj as [String : AnyObject] ))
                    }
                    self.shouldLoadMore = !mainData.isEmpty
                    self.pageNumber = page
                }else {
                    if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            if self.array_Answer.count == 0 {
                self.TableViewNoDataAvailabl(tableview: self.tableView_myAnswer, text: "No Budz Found!")
            }else{
                self.TableViewRemoveNoDataLable(tableview: self.tableView_myAnswer)
            }
            self.tableView_myAnswer.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllBudzVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        self.tableView_myAnswer.register(UINib(nibName: "AllBudzCell", bundle: nil), forCellReuseIdentifier: "AllBudzCell")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_Answer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        return myAnswerCell(tableView:tableView  ,cellForRowAt:indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.array_Answer[indexPath.row]
        self.OpenProfileVC(id: "\((item.ID))")
    }
    //MARK: mySaveCell
    func myAnswerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllBudzCell") as! AllBudzCell
        let item = self.array_Answer[indexPath.row]
        cell.lblName.text = item.userFirstName + " " + item.userLastName
        if item.profilePictureURL.contains("facebook.com") || item.profilePictureURL.contains("google.com") || item.profilePictureURL.contains("https") || item.profilePictureURL.contains("http"){
            cell.imgUser.sd_setImage(with: URL.init(string: item.profilePictureURL.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
        }else {
            if item.profilePictureURL.count > 6 {
                cell.imgUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + item.profilePictureURL.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
            }else {
                cell.imgUser.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + item.avatarImage.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "placeholderMenu"), completed: nil)
            }
            
        }
        if item.special_icon.characters.count > 6 {
            cell.imgUserTopi.isHidden = false
            cell.imgUserTopi.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue + item.special_icon.RemoveSpace()),placeholderImage : #imageLiteral(resourceName: "topi_ic"), completed: nil)
        }else {
            cell.imgUserTopi.isHidden = true
        }
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(self.EditAction), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func EditAction(sender : UIButton){
        self.choose_Answer = self.array_Answer[sender.tag]
        var newPAram  = [String : AnyObject]()
        newPAram["followed_id"] = self.choose_Answer.ID as AnyObject
        let urlMain = WebServiceName.follow_user.rawValue
        self.showLoading()
        NetworkManager.PostCall(UrlAPI:urlMain , params: newPAram) { (success, MessageSingle, MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if success {
                
                if (MainResponse["status"] as! String) == "error" {
                    self.ShowErrorAlert(message: MainResponse["errorMessage"] as! String)
                }else {
                    self.ShowSuccessAlert(message: "User Followed Successfully", completion: {
                        self.array_Answer.remove(at: sender.tag)
                        self.tableView_myAnswer.reloadData()
                    })
                    
                }
            }else{
                if !MessageSingle.isEmpty {
                    self.ShowErrorAlert(message: MessageSingle)
                }
            }
        }
    }
    
    
    func DeleteAction(sender : UIButton){
        
        self.choose_Answer = self.array_Answer[sender.tag]
        
    }
    
    
   
}
extension AllBudzVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
    
    fileprivate func loadMore() {
        if shouldLoadMore {
            self.APICAllForMyAnswers(page: pageNumber +  1)
        }
    }
}


