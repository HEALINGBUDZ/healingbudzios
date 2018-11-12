//
//  myAnwerVC.swift
//  BaseProject
//
//  Created by MAC MINI on 24/10/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel

class myAnwerVC: BaseViewController {
    var array_Answer = [Answer]()
    var choose_Answer = Answer()
    
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
        self.APICAllForMyAnswers(page:  0)
        self.disableMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.enableMenu()
    }
    
    func APICAllForMyAnswers(page : Int){
        self.showLoading()
        let mainUrl = WebServiceName.get_my_answers.rawValue + String(page)
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
                        self.array_Answer.append(Answer.init(json: indexObj as [String : AnyObject] ))
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
                self.TableViewNoDataAvailabl(tableview: self.tableView_myAnswer, text: "No Answers Found!")
            }else{
                self.TableViewRemoveNoDataLable(tableview: self.tableView_myAnswer)
            }
            self.tableView_myAnswer.reloadData()
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
extension myAnwerVC:UITableViewDelegate,UITableViewDataSource{
    func RegisterXib(){
        self.tableView_myAnswer.register(UINib(nibName: "myAnswerCell", bundle: nil), forCellReuseIdentifier: "myAnswerCell")
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
        let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
        print(self.self.array_Answer[indexPath.row])
        DetailQuestionVc.QuestionID = String(self.array_Answer[indexPath.row].mainQuestion.id)
        self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
    }
    //MARK: mySaveCell
    func myAnswerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAnswerCell") as? myAnswerCell
        cell?.btnEdit.addTarget(self, action: #selector(self.EditAction), for: UIControlEvents.touchUpInside)
        cell?.lblQuestion.applyTag(baseVC: self , mainText:  "Q: " + self.array_Answer[indexPath.row].mainQuestion.Question)
        cell?.lblQuestion.text = "Q: " + self.array_Answer[indexPath.row].mainQuestion.Question

        cell?.btnEdit.tag = indexPath.row
        cell?.btnDelete.tag = indexPath.row
        
        cell?.btnDelete.addTarget(self, action: #selector(self.DeleteAction), for: .touchUpInside)
        cell?.btnEdit.addTarget(self, action: #selector(self.EditAction), for: .touchUpInside)
        
         cell?.view_Edit.isHidden = false
//        if Int(self.array_Answer[indexPath.row].answer_like_count)! > 0 {
//            cell?.view_Edit.isHidden = true
//        }else {
//            cell?.view_Edit.isHidden = false
//        }
        
        cell?.lblTime.text = self.GetTimeAgo(StringDate: self.array_Answer[indexPath.row].answertime)
       
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func EditAction(sender : UIButton){
        self.choose_Answer = self.array_Answer[sender.tag]
        let answer = self.GetView(nameViewController: "AnswerQuestionViewController", nameStoryBoard: StoryBoardConstant.QA) as! AnswerQuestionViewController
        answer.chooseAnswers = self.choose_Answer
        answer.chooseQuestion = self.choose_Answer.mainQuestion
        self.navigationController?.pushViewController(answer, animated: true)
        
    }
    
    
    func DeleteAction(sender : UIButton){
        
        self.choose_Answer = self.array_Answer[sender.tag]
        self.deleteCustomeAlert(title: "Are you sure?", discription: "You want to delete this answer?") { (isComplete, btnNUm) in
            if isComplete {
                self.APIDeleteCall()
            }
        }
    }
    
    
    func APIDeleteCall(){
        let UrlMain = WebServiceName.delete_answer.rawValue + self.choose_Answer.answer_ID
        
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: UrlMain) { (successResponse, messageResponse, dataResponse) in
            
            print(dataResponse)
            self.hideLoading()
            if successResponse {
                self.APICAllForMyAnswers(page: 0)
              
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
}
extension myAnwerVC: UIScrollViewDelegate  {
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
class myAnswerCell :UITableViewCell{
    @IBOutlet var lblQuestion : ActiveLabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var btnEdit : UIButton!
    @IBOutlet var btnDelete : UIButton!
    
    @IBOutlet var view_Edit : UIView!
}
