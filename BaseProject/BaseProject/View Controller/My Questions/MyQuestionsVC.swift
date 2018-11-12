//
//  MyQuestionsVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class MyQuestionsVC: BaseViewController {
    var array_Question = [QA]()
    
    var choose_Question = QA()
    var pageNumber = 0
    fileprivate var shouldLoadMore = true
    var refreshControl: UIRefreshControl!
    
  @IBOutlet weak var tableView_myQuestion: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RegisterXib()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.RefreshAPICall) , for: UIControlEvents.valueChanged)
        self.tableView_myQuestion.addSubview(refreshControl)
        
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
            self.GetAllQuestion(page:  0)
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.tabBarController?.tabBar.isHidden = true
        self.GetAllQuestion(page: 0)
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
  
    
    func GetAllQuestion(page : Int){
            self.showLoading()     
            NetworkManager.GetCall(UrlAPI: WebServiceName.get_my_question.rawValue + String(page)) { (successResponse, messageResponse, dataResponse) in
                print(dataResponse)
                self.hideLoading()
                if successResponse {
                    if (dataResponse["status"] as! String) == "success" {
                        let mainData = dataResponse["successData"] as! [[String : Any]]
                        if page > 0{
                        }else{
                           self.array_Question.removeAll()
                        }
                        for indexObj in mainData {
                            self.array_Question.append(QA.init(json: indexObj as [String : AnyObject] ))
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
                
                if self.array_Question.count == 0 {
                    self.TableViewNoDataAvailabl(tableview: self.tableView_myQuestion, text: "No Questions Found!")
                }else{
                    self.TableViewRemoveNoDataLable(tableview: self.tableView_myQuestion)
                }
                self.tableView_myQuestion.reloadData()
            }
        
    }
    // MARK: - Navigation
    @IBAction func Home_Btn(_ sender: Any) {
        self.GotoHome()
    }
    
    @IBAction func Back_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension MyQuestionsVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        
        
        self.tableView_myQuestion.register(UINib(nibName: "myQuestionCell", bundle: nil), forCellReuseIdentifier: "myQuestionCell")
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_Question.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        return myQuestionCell(tableView:tableView  ,cellForRowAt:indexPath)
        
    }
    
    //MARK: mySaveCell
    func myQuestionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myQuestionCell") as? myQuestionCell
        cell?.lblQuestion.applyTag(baseVC: self , mainText: "Q: " + self.array_Question[indexPath.row].Question)
        cell?.lblQuestion.text = "Q: " + self.array_Question[indexPath.row].Question
        cell?.lblAnswerCount.text = String(self.array_Question[indexPath.row].AnswerCount)
        print(self.array_Question[indexPath.row].questiontime)
        cell?.lblTimeAgo.text = self.GetTimeAgo(StringDate: self.array_Question[indexPath.row].questiontime)
        
        cell?.btnDelete.tag = indexPath.row
        cell?.btnDelete.addTarget(self, action: #selector(self.DeleteAction), for: .touchUpInside)

        cell?.btnEdit.tag = indexPath.row
        
        if self.array_Question[indexPath.row].AnswerCount == 0 {
            cell?.viewEdit.isHidden = false
            cell?.btnEdit.addTarget(self, action: #selector(self.EditAction), for: .touchUpInside)

        }else {
            cell?.viewEdit.isHidden = true
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print(self.self.array_Question[indexPath.row])
        let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
        DetailQuestionVc.QuestionID = String(self.array_Question[indexPath.row].id)
        self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
    }
    
    func DeleteAction(sender : UIButton){
        self.choose_Question = self.array_Question[sender.tag]
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this question?") { (isConfirm, btn_nmbr) in
            if isConfirm{
                self.APIDeleteCall()
            }else{
                
            }
        }
    }
    
    func EditAction(sender : UIButton){
        let AskQuestionVc = self.GetView(nameViewController: "AskQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AskQuestionViewController
        AskQuestionVc.chooseQuestion = self.array_Question[sender.tag]
        self.navigationController?.pushViewController(AskQuestionVc, animated: true)
    }
    
    func APIDeleteCall(){
        let UrlMain = WebServiceName.delete_question.rawValue + String(self.choose_Question.id)
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: UrlMain) { (successResponse, messageResponse, dataResponse) in
            print(dataResponse)
            self.hideLoading()
            if successResponse {
                self.GetAllQuestion(page: 0)
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
    
}

extension MyQuestionsVC: UIScrollViewDelegate  {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMore()
        }
    }
    
    fileprivate func loadMore() {
        if shouldLoadMore {
            self.GetAllQuestion(page: pageNumber +  1)
        }
    }
}
class myQuestionCell :UITableViewCell{
    @IBOutlet var lblQuestion : ActiveLabel!
    @IBOutlet var lblAnswerCount : UILabel!
    @IBOutlet var lblTimeAgo : UILabel!
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var btnEdit : UIButton!
    
    @IBOutlet var viewEdit : UIView!
    @IBOutlet var viewDelete : UIView!
}
