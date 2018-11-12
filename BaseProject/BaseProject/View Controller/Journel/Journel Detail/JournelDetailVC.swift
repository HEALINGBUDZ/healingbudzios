//
//  JournelDetailVC.swift
//  BaseProject
//
//  Created by macbook on 13/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class JournelDetailVC: BaseViewController
{

    var mainArray =  [[String : Any]]()
    
    @IBOutlet var journalTbleView : UITableView!
    
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
         self.tabBarController?.tabBar.isHidden = true
        self.DummyData()
    }
   
    
    
    func DummyData(){
        
        self.mainArray.removeAll()
        
        
        let newDateHeading = JournalDateHeading()
        newDateHeading.id = "1"
        newDateHeading.isExpand = "0"
        newDateHeading.mainLabel = "February, 2017"
        newDateHeading.rowheight = "45"

        self.mainArray.append(["type" : JournalListing.ExpandCell.rawValue , "data" : newDateHeading])
        
        
        let detailObj1 = JournalDetail()
        detailObj1.id = "1"
        detailObj1.parentID = "1"
        detailObj1.rowHeight = "0"
        
        self.mainArray.append(["type" : JournalListing.DetailCell.rawValue , "data" : detailObj1])

        
        let detailObj2 = JournalDetail()
        detailObj2.id = "2"
        detailObj2.parentID = "1"
        detailObj2.rowHeight = "0"
        
        self.mainArray.append(["type" : JournalListing.DetailCell.rawValue , "data" : detailObj2])
        
        
        
        
        
        let newDateHeading2 = JournalDateHeading()
        newDateHeading2.id = "2"
        newDateHeading2.isExpand = "0"
        newDateHeading2.mainLabel = "January, 2017"
        newDateHeading2.rowheight = "45"
        
        self.mainArray.append(["type" : JournalListing.ExpandCell.rawValue , "data" : newDateHeading2])

        
        
        
        let detailObj3 = JournalDetail()
        detailObj3.id = "3"
        detailObj3.parentID = "2"
        detailObj3.rowHeight = "0"
        
        self.mainArray.append(["type" : JournalListing.DetailCell.rawValue , "data" : detailObj3])
        
        
        let detailObj4 = JournalDetail()
        detailObj4.id = "4"
        detailObj4.parentID = "2"
        detailObj4.rowHeight = "0"
        
        self.mainArray.append(["type" : JournalListing.DetailCell.rawValue , "data" : detailObj4])
        
        
        self.journalTbleView.reloadData()
        
    }
    
}


//MARK:
//MARK: Button ACtions
extension JournelDetailVC {
    @IBAction func Back_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Home_Action(sender : UIButton){
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
        
        self.GotoHome()
    }
    
    
    @IBAction func Like_Action(sender : UIButton){

    }
    
    @IBAction func Share_Action(sender : UIButton){
        
    }
    
    @IBAction func Edit_Action(sender : UIButton){
        
    }
    
    @IBAction func AddEntery_Action(sender : UIButton){
        
    }
    
    @IBAction func Filter_Action(sender : UIButton){
        
    }
    
    @IBAction func ExpandView_Action(sender : UIButton){
        
    }
    
    @IBAction func ShowBudz_Action(sender : UIButton){
        
    }
}



//MARK:
//MARK: UItableView Delegate

extension JournelDetailVC : UITableViewDelegate ,  UITableViewDataSource {
    
    func RegisterXib(){
        
        self.journalTbleView.register(UINib(nibName: "JournalDateHeadingCell", bundle: nil), forCellReuseIdentifier: "JournalDateHeadingCell")
        
        self.journalTbleView.register(UINib(nibName: "JournalDetailDataCell", bundle: nil), forCellReuseIdentifier: "JournalDetailDataCell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mainData = self.mainArray[indexPath.row]
        
        
        switch (mainData["type"] as! String) {
                    case JournalListing.ExpandCell.rawValue:
                        if let n = NumberFormatter().number(from: (mainData["data"] as! JournalDateHeading).rowheight) {
                            return CGFloat(n)
                        }else {
                                return 0
                        }            
        default:
            if let n = NumberFormatter().number(from: (mainData["data"] as! JournalDetail).rowHeight) {
                return CGFloat(n)
            }else {
                return 0
            }
            
            
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let mainData = self.mainArray[indexPath.row]
        
        switch (mainData["type"] as! String) {
        case JournalListing.DetailCell.rawValue:
            return DetailDateCell(tableView ,cellForRowAt:indexPath)
            
        default:
            return MainDateHeadingCell(tableView ,cellForRowAt:indexPath)
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainData = self.mainArray[indexPath.row]

         if (mainData["data"] as? JournalDetail) != nil {
            self.PushViewWithIdentifier(name: "JournalMainDetailVC")
        }
        
    }
    func MainDateHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalDateHeadingCell") as! JournalDateHeadingCell

        let mainData = self.mainArray[indexPath.row]
        let dataCell = mainData["data"] as! JournalDateHeading
        cell.lblMainHEading.text = dataCell.mainLabel
        
        if dataCell.isExpand == "1" {
            cell.imgViewExpand.image = UIImage.init(named: "downArrow")
        }else {
            cell.imgViewExpand.image = UIImage.init(named: "rightArrow")
        }
        
        cell.btnExpand.tag = indexPath.row
        cell.btnExpand.addTarget(self, action: #selector(self.ExpandCell), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func DetailDateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalDetailDataCell") as! JournalDetailDataCell
        
//        let mainData = self.mainArray[indexPath.row]
//        let dataCell = mainData["data"] as! JournalDateHeading
//        cell.lblMainHEading.text = dataCell.mainLabel
        
//        if dataCell.isExpand == "1" {
//            cell.imgViewExpand.image = UIImage.init(named: "downArrow")
//        }else {
//            cell.imgViewExpand.image = UIImage.init(named: "rightArrow")
//        }
//        
//        cell.btnExpand.tag = indexPath.row
//        cell.btnExpand.addTarget(self, action: #selector(self.ExpandCell), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }

    
    
    func ExpandCell(sender : UIButton){
        
        var mainData = self.mainArray[sender.tag]
        let dataCell = mainData["data"] as! JournalDateHeading
        
        if dataCell.isExpand == "1" {
            dataCell.isExpand = "0"
        }else {
            dataCell.isExpand = "1"
        }
        
        
        mainData["data"] = dataCell
        self.mainArray[sender.tag] = mainData
        
        
        for index in 0..<self.mainArray.count {
            var indexObj = self.mainArray[index]
            
            
            if let dataCellDetail = indexObj["data"] as? JournalDetail {
                if dataCellDetail.parentID  == dataCell.id {
                    
                    
                    if dataCell.isExpand == "0" {
                        dataCellDetail.rowHeight = "0"
                    }else {
                        dataCellDetail.rowHeight = "125"
                    }
                    
                }
                indexObj["data"] = dataCellDetail
                
                self.mainArray[index] = indexObj
                
            }
        }
        
        self.journalTbleView.reloadData()
        
    }
    

}



class JournalDateHeadingCell : UITableViewCell {
    @IBOutlet var lblMainHEading : UILabel!
    @IBOutlet var imgViewExpand : UIImageView!
    @IBOutlet var btnExpand : UIButton!
    
}


class JournalDetailDataCell : UITableViewCell {
 
    @IBOutlet var lblMainHEading : UILabel!
    @IBOutlet var lblDay : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var lblImageCount : UILabel!
    @IBOutlet var lblMovieCount : UILabel!
    @IBOutlet var lblTagCount : UILabel!
    @IBOutlet var imgViewEmoji : UIImageView!
    @IBOutlet var imgViewMain : UIImageView!
    
    
}
