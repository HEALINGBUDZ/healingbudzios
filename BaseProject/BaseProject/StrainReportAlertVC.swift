//
//  StrainReportAlertVC.swift
//  BaseProject
//
//  Created by MAC MINI on 26/04/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class StrainReportAlertVC: BaseViewController {
    @IBOutlet weak var filter_view: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var image_indicator: UIImageView!
    var reportValue = StrainReport.Answer.rawValue
    @IBOutlet weak var tbl_filter: UITableView!
    @IBOutlet weak var filter_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var backgrounView: UIView!
    var array_filter = [[String : Any]]()
    var fromMediaBrowser = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_filter.register(UINib.init(nibName: "QAHeadingcell", bundle: nil), forCellReuseIdentifier: "QAHeadingcell")
        self.tbl_filter.register(UINib.init(nibName: "QASendButtonCell", bundle: nil), forCellReuseIdentifier: "QASendButtonCell")
        self.tbl_filter.register(UINib.init(nibName: "QAReasonCell", bundle: nil), forCellReuseIdentifier: "QAReasonCell")
        self.image_indicator.image = #imageLiteral(resourceName: "QAMenuUp").withRenderingMode(.alwaysTemplate)
        if self.fromMediaBrowser == 1{
           
            self.lineView.backgroundColor = UIColor.init(hex: "7cc244")
            self.image_indicator.tintColor = UIColor.init(hex: "7cc244")
        }else {
             self.lineView.backgroundColor = UIColor.init(hex: "F4B927")
            self.image_indicator.tintColor = UIColor.init(hex: "F4B927")
        }
        
        self.filter_top_constraint.constant = -650
        UIView.animate(withDuration: 1.0, animations: {
            self.filter_top_constraint.constant = 0
            self.filter_view.layoutIfNeeded()
        })
        if fromMediaBrowser == 1{
//            self.backgrounView.backgroundColor = nil
        }
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        topSwipe.direction = .up
        view.addGestureRecognizer(topSwipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func onClickClose(_ sender: Any) {
        self.Dismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        createArray()
    }
    func createArray() {
        var dataDict = [String : String]()
        dataDict["image"] = "CircleE"
        if self.fromMediaBrowser == 1 {
            dataDict["name"] = "Post is Offensive"
        }else {
           dataDict["name"] = "Report"

        }
        var dataDict2 = [String : String]()
        dataDict2["image"] = "CircleE"
        dataDict2["name"] = "Spam"
        if self.fromMediaBrowser == 1 {
            dataDict2["name"] = "Spam"
        }else {
            dataDict2["name"] = "Spam"
            
        }
        var dataDict3 = [String : String]()
        dataDict3["image"] = "CircleE"
        dataDict3["name"] = "Unrelated"
        if self.fromMediaBrowser == 1 {
            dataDict3["name"] = "Unrelated Post"
        }else {
            dataDict3["name"] = "Unrelated"
            
        }
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


extension StrainReportAlertVC : UITableViewDelegate , UITableViewDataSource {
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
            self.reportValue = StrainReport.Nudity.rawValue
            break
        case 2:
            self.reportValue = StrainReport.harassment.rawValue
            break
        case 3:
            self.reportValue = StrainReport.violent.rawValue
            break
        case 4:
            self.reportValue = StrainReport.Answer.rawValue
            break
        case 5:
            self.reportValue = StrainReport.Spam.rawValue
            break
        case 6:
            self.reportValue = StrainReport.Unrelated.rawValue
            break
            
        default:
            break;
        }
    }
    func SendButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QASendButtonCell") as! QASendButtonCell
        cellFilter.btn_Send.addTarget(self, action:#selector(self.APICAllForFlag), for: UIControlEvents.touchUpInside)
        if self.fromMediaBrowser == 1 {
            cellFilter.btn_Send.backgroundColor = UIColor.init(hex: "7cc244")
            
        }else {
            cellFilter.btn_Send.backgroundColor = UIColor.init(hex: "F4B927")
            
        }
//        /DC831C
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    func ReportOptionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAReasonCell") as! QAReasonCell
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"] as? String
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]! as! String)
        if self.fromMediaBrowser == 1 {
            
            cellFilter.selected_line.backgroundColor = UIColor.init(hex: "7cc244")
        }else {
            cellFilter.selected_line.backgroundColor = UIColor.init(hex: "F4B927")
            
        }
        
        if indexPath.row == 1 {
            cellFilter.imageView_Main.image = UIImage.init(named: "CircleS")
            cellFilter.view_BG.isHidden = false
        }else{
             cellFilter.imageView_Main.image = UIImage.init(named: "CircleE")
            cellFilter.view_BG.isHidden = true
        }
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    func APICAllForFlag(){
        if reportValue.count == 0 {
            self.ShowErrorAlert(message: "Please choose reason for reporting!")
            return
        }
        if fromMediaBrowser == 0{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StrainReport"), object: nil, userInfo: ["value" : reportValue as AnyObject ])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MediaReport"), object: nil, userInfo: ["value" : reportValue as AnyObject])
        }
        self.Dismiss()
    }
    
}
