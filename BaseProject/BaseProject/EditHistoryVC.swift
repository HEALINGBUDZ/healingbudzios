//
//  EditHistoryVC.swift
//  BaseProject
//
//  Created by Abc on 9/12/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EditHistoryVC: BaseViewController ,UITableViewDelegate ,  UITableViewDataSource {
    var array_Answer = [Answer]()
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var tbl_view: UITableView!
    var idAnswer:Int = 0
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        RegisterXib()
        self.btn_back.addTarget(self, action: #selector(self.GoBack(sender:)), for: .touchUpInside)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tbl_view.addSubview(refreshControl)
        self.CallApi()
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    func RefreshAPICall(sender:AnyObject){
        self.playSound(named: "refresh")
        refreshControl.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.CallApi()
            
        })
        
    }
    func CallApi(){
        self.showLoading()
        let mainUrl = "get_edits/" + String(idAnswer)
        NetworkManager.GetCall(UrlAPI: mainUrl) { (successResponse, messageResponse, dataResponse) in
            print(dataResponse)
            self.hideLoading()
            if successResponse {
                if (dataResponse["status"] as! String) == "success" {
                    let mainData = dataResponse["successData"] as! [[String : Any]]
                    
                   self.array_Answer.removeAll()
                    for indexObj in mainData {
                        self.array_Answer.append(Answer.init(json: indexObj as [String : AnyObject] ))
                    }
                    
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
                self.TableViewNoDataAvailabl(tableview: self.tbl_view, text: "No Answers Found!")
            }else{
                self.TableViewRemoveNoDataLable(tableview: self.tbl_view)
            }
            self.tbl_view.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func GoBack(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func RegisterXib(){
        self.tbl_view.register(UINib(nibName: "EditCells", bundle: nil), forCellReuseIdentifier: "EditCells")
        self.tbl_view.register(UINib(nibName: "EditFirstCellTableViewCell", bundle: nil), forCellReuseIdentifier: "EditFirstCellTableViewCell")
        self.tbl_view.reloadData()
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
    override func viewWillAppear(_ animated: Bool) {
       
        self.tabBarController?.tabBar.isHidden = true
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    func myAnswerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditFirstCellTableViewCell") as? EditFirstCellTableViewCell
             cell?.lbl_description.applyTag(baseVC: self, mainText: self.array_Answer[indexPath.row].answer)
            cell?.lbl_time.text = self.GetTimeAgo(StringDate: self.array_Answer[indexPath.row].answertime)
            cell?.lbl_description.text = self.array_Answer[indexPath.row].answer
            cell?.selectionStyle = .none
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCells") as? EditCells
            cell?.lbl_description.applyTag(baseVC: self, mainText: self.array_Answer[indexPath.row].answer)
            cell?.lbl_time.text = self.GetTimeAgo(StringDate: self.array_Answer[indexPath.row].answertime)
            cell?.lbl_description.text = self.array_Answer[indexPath.row].answer
            cell?.selectionStyle = .none
            return cell!
        }
        
    }
}
extension EditHistoryVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
    
    fileprivate func loadMore() {
        self.CallApi()
    }
}
