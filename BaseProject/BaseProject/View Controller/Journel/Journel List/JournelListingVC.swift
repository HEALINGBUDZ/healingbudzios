//
//  JournelListingVC.swift
//  BaseProject
//
//  Created by macbook on 06/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class JournelListingVC: BaseViewController {
    
    
    @IBOutlet var tableView_Journal : UITableView!
    
    @IBOutlet var tbleViewFilter: UITableView!
    
    @IBOutlet var viewFilter : UIView!
    @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
        
    var sectionArray = [[String : AnyObject]]()
    var array_filter = [[String : String]]()
    
    var isFilterChoose = false
    
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
         self.tabBarController?.tabBar.isHidden = false
        self.ReloadData()
       self.RefreshFilterArray()
        
    }
    
    
    func ReloadData(value : Int = 0){
        self.sectionArray.removeAll()
        
        var dummyData = [String : AnyObject]()
        dummyData["name"] = "Journal Name" as AnyObject
        dummyData["subName"] = "John Doe" as AnyObject
        dummyData["idExpand"] = false as AnyObject
        dummyData["type"] = JournalListing.ExpandCell.rawValue as AnyObject
        
        
        var InternalData1 = [String : AnyObject]()
        InternalData1["name"] = "First Day of Treatment" as AnyObject
        InternalData1["date"] = "WED o1 FEB,05:30 PM" as AnyObject
        InternalData1["image"] = UIImage.init(named: "")
        InternalData1["type"] = JournalListing.DetailCell.rawValue as AnyObject
        
        
        
        
        
        var linceCell1 = [String : AnyObject]()
        linceCell1["type"] = JournalListing.LineCell.rawValue as AnyObject
        
        self.sectionArray.append(dummyData)

        
        if value == 1 {
            for _ in 0..<4 {
                self.sectionArray.append(InternalData1)
                
            }
        }
        
        
        
        self.sectionArray.append(linceCell1)

        self.tableView_Journal.reloadData()
    }
    
    
    
    func RefreshFilterArray(){
        self.array_filter.removeAll()
        
        
        var dataDict = [String : String]()
        dataDict["image"] = "AlphabeticalJournal"
        dataDict["name"] = "ALPHABETICAL"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "journal_header_new"
        dataDict2["name"] = "NEWEST"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "HeartF_Journal"
        dataDict3["name"] = "FAVORITES"
        
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict2)
        self.array_filter.append(dataDict3)
        
        
        print(self.array_filter.count)

        self.tbleViewFilter.reloadData()
        
    }
}


//MARK:
//MARK: TableView Delegate
extension JournelListingVC:UITableViewDelegate,UITableViewDataSource{
    
    func RegisterXib(){
        
        self.tableView_Journal.register(UINib(nibName: "JournalSectionCell", bundle: nil), forCellReuseIdentifier: "JournalSectionCell")

        self.tableView_Journal.register(UINib(nibName: "JournelDetailListingCell", bundle: nil), forCellReuseIdentifier: "JournelDetailListingCell")
        
        self.tableView_Journal.register(UINib(nibName: "LineMainCell", bundle: nil), forCellReuseIdentifier: "LineMainCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAFilterCell", bundle: nil), forCellReuseIdentifier: "QAFilterCell")
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.isFilterChoose {
            print(self.array_filter.count)
            return self.array_filter.count
        }
        
        return self.sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView.tag == 100 {
            return self.Filtercell(tableView, cellForRowAt: indexPath)
        }
        
        let mainData = self.sectionArray[indexPath.row]
        
        switch (mainData["type"] as! String) {
        case JournalListing.ExpandCell.rawValue:
            return MainSectionCell(tableView:tableView ,cellForRowAt:indexPath)
        case JournalListing.LineCell.rawValue:
            return LineCell(tableView:tableView ,cellForRowAt:indexPath)
            
        default:
            return JournalDetailListing(tableView:tableView ,cellForRowAt:indexPath)


        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 100 {
            
            
                for index in 0..<self.array_filter.count{
                    
                    if indexPath.row == index {
                        let tbleviewCell = self.tbleViewFilter.cellForRow(at: indexPath) as! QAFilterCell
                        tbleviewCell.view_BG.isHidden = false
                    }else {
                        let tbleviewCell = self.tbleViewFilter.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAFilterCell
                        tbleviewCell.view_BG.isHidden = true
                    }
                }
          
        }else {
             self.PushViewWithIdentifier(name: "JournelDetailVC")
        }
    }

    
    func MainSectionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> JournalSectionCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalSectionCell") as! JournalSectionCell

        
        if (cell.btn_Expand.isSelected){
            cell.imgView_Expand.image = UIImage.init(named: "downArrow")

        }else {
            cell.imgView_Expand.image = UIImage.init(named: "rightArrow")
        }

        cell.btn_Expand.tag = indexPath.row

        cell.btn_Expand.addTarget(self, action: #selector(hideShowCells), for: UIControlEvents.touchUpInside)
        
        
        cell.lbl_Name.text = "Journal Name"
        cell.lbl_Sub_Name.text = "John Doe"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func JournalDetailListing(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournelDetailListingCell") as? JournelDetailListingCell
        
        
        cell?.lbl_Name.text = "First Day of Treatment"
        cell?.lbl_Sub_Name.text = "WED 01 FEB 04:30 PM"
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func LineCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineMainCell") as? LineMainCell
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    
    func hideShowCells(sender : UIButton){
        let cellMain = tableView_Journal.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! JournalSectionCell
        
        if cellMain.btn_Expand.isSelected {
           cellMain.btn_Expand.isSelected = false
            cellMain.imgView_Expand.image = UIImage.init(named: "rightArrow")
            self.ReloadData()
            
        }else {
            cellMain.btn_Expand.isSelected = true
            cellMain.imgView_Expand.image = UIImage.init(named: "downArrow")
            self.ReloadData(value: 1)
        }
    }
    
    func Filtercell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellFilter = tableView.dequeueReusableCell(withIdentifier: "QAFilterCell") as! QAFilterCell
        
        
        cellFilter.lbl_Main.text = array_filter[indexPath.row]["name"]
        
        cellFilter.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
        cellFilter.view_BGColor.backgroundColor = UIColor.init(red: (123/255), green: (192/255), blue: (67/255), alpha: 1.0)
        cellFilter.selectionStyle = .none
        return cellFilter
    }
    
    
    @IBAction func AddNew_Action(sender : UIButton){
        self.PushViewWithIdentifier(name: "NewJournalVC")
    }
    
    @IBAction func Home_Action(sender : UIButton){
//       self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen, completion: nil)
        self.GotoHome()
        
    }
    
    @IBAction func ShowFilterView(sender : UIButton){
         self.isFilterChoose = true
        
        self.RefreshFilterArray()
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = 40 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func HideFilterView(sender : UIButton){
         self.isFilterChoose = false
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = -400 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }

    
}



class JournalSectionCell : UITableViewCell {
    
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Sub_Name : UILabel!
    
    @IBOutlet var imgView_Main : UIImageView!
    @IBOutlet var imgView_Heart : UIImageView!
    @IBOutlet var imgView_Expand : UIImageView!
    
    @IBOutlet var btn_Heart : UIButton!
    @IBOutlet var btn_Share : UIButton!
    @IBOutlet var btn_Expand : UIButton!
    
}

class JournelDetailListingCell : UITableViewCell {
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Sub_Name : UILabel!
    
    @IBOutlet var imgView_Emoji : UIImageView!
}


class LineMainCell : UITableViewCell {
  
}
