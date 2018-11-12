//
//  ReportAlertVC.swift
//  BaseProject
//
//  Created by MAC MINI on 20/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class ReportAlertVC:BaseViewController {
    @IBOutlet weak var filter_view: UIView!
    var review_id : String?
    var isBudzFlag: Bool = false
    @IBOutlet weak var image_indicator: UIImageView!
    var reportValue = QAReport.Answer.rawValue
    @IBOutlet weak var tbl_filter: UITableView!
    @IBOutlet weak var filter_top_constraint: NSLayoutConstraint!
    var array_filter = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image_indicator.image = #imageLiteral(resourceName: "QAMenuUp").withRenderingMode(.alwaysTemplate)
        self.image_indicator.tintColor = UIColor.init(hex: "932a88")
        self.tbl_filter.register(UINib.init(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        self.tbl_filter.register(UINib.init(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        self.tbl_filter.register(UINib.init(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        self.filter_top_constraint.constant = -650
        UIView.animate(withDuration: 1.0, animations: {
            self.filter_top_constraint.constant = 0
            self.filter_view.layoutIfNeeded()
        })
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFromTop
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
            if  view != self.filter_view{
                let transition: CATransition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromTop
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.Dismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        createArray()
    }
    func createArray() {
        var dataDict = [String : String]()
        dataDict["image"] = "CircleE"
        dataDict["name"] = "Report"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "CircleE"
        dataDict2["name"] = "Spam"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "CircleE"
        dataDict3["name"] = "Unrelated"
        var dataDict5 = [String : String]()
        dataDict5["image"] = ""
        dataDict5["name"] = ""
        
        var dataDict6 = [String : String]()
        dataDict6["image"] = "CircleE"
        dataDict6["name"] = "Nudity or sexual content"
        
        var dataDict7 = [String : String]()
        dataDict7["image"] = "CircleE"
        dataDict7["name"] = "Harassment or hate speech"
        
        var dataDict8 = [String : String]()
        dataDict8["image"] = "CircleE"
        dataDict8["name"] = "Threatening, violent or concerning"
        
        
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict6)
        self.array_filter.append(dataDict7)
        self.array_filter.append(dataDict8)
        self.array_filter.append(dataDict2)
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict3)
        self.array_filter.append(dataDict5)
        self.tbl_filter.reloadData()
    }
    
}


extension ReportAlertVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_filter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.ReportHeadingCell(tableView, cellForRowAt: indexPath)
        }else if indexPath.row == self.array_filter.count - 1 {
            return self.SendButtonCell(tableView, cellForRowAt: indexPath)
        }else {
            return self.ReportOptionCell(tableView, cellForRowAt: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func ReportHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAHeadingcell") as! QAHeadingcell
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.row == 0 || indexPath.row == self.array_filter.count - 1 {
            
        }else {
            for index in 1..<self.array_filter.count - 1 {
                
                if indexPath.row == index {
                    let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAReasonCell
                    tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleS")
                    tbleviewCell.view_BG.isHidden = false
                    self.ChooseReportOption(value: index)
                }else {
                    let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAReasonCell
                    tbleviewCell.imageView_Main.image = UIImage.init(named: "CircleE")
                    tbleviewCell.view_BG.isHidden = true
                }
            }
            
        }
    }
    
    func ChooseReportOption(value : Int){
        print("value \(value)")
        switch value {
        case 1:
            self.reportValue = QAReport.Nudity.rawValue
            break
        case 2:
            self.reportValue = QAReport.harassment.rawValue
            break
        case 3:
            self.reportValue = QAReport.violent.rawValue
            break
        case 4:
            self.reportValue = QAReport.Answer.rawValue
            break
        case 5:
            self.reportValue = QAReport.Spam.rawValue
            break
        case 6:
            self.reportValue = QAReport.Unrelated.rawValue
            break
            
        default:
            break;
        }
    }
    func SendButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QASendButtonCell") as! QASendButtonCell
        cellFilter.btn_Send.addTarget(self, action:#selector(self.APICAllForFlag), for: UIControlEvents.touchUpInside)
        cellFilter.selectionStyle = .none
        cellFilter.btn_Send.backgroundColor = UIColor.init(hex: "932a88")
        return cellFilter
    }
    func ReportOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAReasonCell") as! QAReasonCell
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"] as? String
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]! as! String)
        cellFilter.selectionStyle = .none
        if indexPath.row == 1 {
             cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
             cellFilter.view_BG.isHidden = false
        }else{
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
             cellFilter.view_BG.isHidden = true
        }
        cellFilter.selected_line.backgroundColor = UIColor.init(hex: "932a88")
        return cellFilter
    }
    
    func APICAllForFlag(){
        if reportValue.count == 0 {
            self.ShowErrorAlert(message: "Please choose reason for reporting!")
            return
        }
        self.view.showLoading()
        var param = [String : AnyObject]()
        var mainUrl = WebServiceName.add_budz_review_flag.rawValue
        
        if self.isBudzFlag {
            param["budz_id"] = review_id as AnyObject
            mainUrl = WebServiceName.add_budz_flag.rawValue
        }else {
            param["review_id"] = review_id as AnyObject
            mainUrl = WebServiceName.add_budz_review_flag.rawValue
        }
        param["reason"] = reportValue as AnyObject
        NetworkManager.PostCall(UrlAPI: mainUrl , params: param) { (successRespons, messageResponse, dataResponse) in
            print(dataResponse)
            self.view.hideLoading()
            if successRespons {
                if (dataResponse["successMessage"] as? String) != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BudzFlagReview"), object: nil)
                    self.Dismiss()
                    
                }else if (dataResponse["errorMessage"] as! String) == "Session Expired" {
                    DataManager.sharedInstance.logoutUser()
                    self.ShowLogoutAlert()
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        }
    }
    
}
