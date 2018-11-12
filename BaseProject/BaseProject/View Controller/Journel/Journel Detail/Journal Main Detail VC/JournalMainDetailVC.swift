//
//  JournalMainDetailVC.swift
//  BaseProject
//
//  Created by macbook on 14/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class JournalMainDetailVC: BaseViewController {

    @IBOutlet var tbleViewMain : UITableView!
    
    var mainArray =  [[String : Any]]()
        
    
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
        self.dummyData()
        
    }

    
    func dummyData(){
        self.mainArray.removeAll()
        self.mainArray.append(["type" : "1" , "data" : ""])
        self.mainArray.append(["type" : "2" , "data" : ""])
        self.mainArray.append(["type" : "3" , "data" : ""])
        self.mainArray.append(["type" : "4" , "data" : ""])
        self.mainArray.append(["type" : "5" , "data" : ""])
        self.mainArray.append(["type" : "6" , "data" : ""])
        self.mainArray.append(["type" : "7" , "data" : ""])
        self.tbleViewMain.reloadData()
    }
}

//MARK:
//MARK: TableView Dalegate 
extension JournalMainDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func RegisterXib(){
        
        self.tbleViewMain.register(UINib(nibName: "JournalMainDetailHeadingCell", bundle: nil), forCellReuseIdentifier: "JournalMainDetailHeadingCell")
        
        self.tbleViewMain.register(UINib(nibName: "JournalDetailFeelingCell", bundle: nil), forCellReuseIdentifier: "JournalDetailFeelingCell")
        
        self.tbleViewMain.register(UINib(nibName: "JournalLikeCell", bundle: nil), forCellReuseIdentifier: "JournalLikeCell")

        self.tbleViewMain.register(UINib(nibName: "MoreStainCell", bundle: nil), forCellReuseIdentifier: "MoreStainCell")

        self.tbleViewMain.register(UINib(nibName: "JournalTagsCell", bundle: nil), forCellReuseIdentifier: "JournalTagsCell")

        self.tbleViewMain.register(UINib(nibName: "JournalDetailStrainCell", bundle: nil), forCellReuseIdentifier: "JournalDetailStrainCell")

        self.tbleViewMain.register(UINib(nibName: "JournalStrainButtonCell", bundle: nil), forCellReuseIdentifier: "JournalStrainButtonCell")

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainArray.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainData = self.mainArray[indexPath.row]
        
        
        switch (mainData["type"] as! String) {
            
            case "2":
                return FeelingCell(tableView, cellForRowAt: indexPath)
            
            case "3":
                return JournalLikecell(tableView, cellForRowAt: indexPath)
            
        case "4":
            return MoreAboutStrainCell(tableView, cellForRowAt: indexPath)
            
        case "5":
            return TagsJournalCell(tableView, cellForRowAt: indexPath)

            
        case "6":
            return JournalStrainCell(tableView, cellForRowAt: indexPath)
            
            
        case "7":
            return JournalStrainButtonCell(tableView, cellForRowAt: indexPath)
            
            default :
                return MainHeadingCell(tableView, cellForRowAt: indexPath)
            
        }
    }
    
    
    
    func MainHeadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalMainDetailHeadingCell") as! JournalMainDetailHeadingCell
        
        cell.btnBack.addTarget(self, action: #selector(self.Back_Action), for: UIControlEvents.touchUpInside)
        
        cell.btnHome.addTarget(self, action: #selector(self.Home_Action), for: UIControlEvents.touchUpInside)

        cell.selectionStyle = .none
        return cell
    }
    
    
    func FeelingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalDetailFeelingCell") as! JournalDetailFeelingCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func JournalLikecell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalLikeCell") as! JournalLikeCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func MoreAboutStrainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreStainCell") as! MoreStainCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func TagsJournalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalTagsCell") as! JournalTagsCell
        
        
        cell.selectionStyle = .none
        return cell
    }

    func JournalStrainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalDetailStrainCell") as! JournalDetailStrainCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func JournalStrainButtonCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalStrainButtonCell") as! JournalStrainButtonCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}


//MARK:
//MARK: Button Actions
extension JournalMainDetailVC {
     func Back_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
     func Home_Action(sender : UIButton){
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
        
        self.GotoHome()
    }

    
    @IBAction func AddAttachment_Action(sender : UIButton) {
        
    }
    
    @IBAction func Share_Action(sender : UIButton) {
        
    }
    
    @IBAction func Edit_Action(sender : UIButton) {
        
    }
    
    @IBAction func Menu_Action(sender : UIButton) {
        
    }
}



class  JournalMainDetailHeadingCell: UITableViewCell {
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnHome : UIButton!
    @IBOutlet var btnAttach : UIButton!
    @IBOutlet var btnShare : UIButton!
    @IBOutlet var btnEdit : UIButton!
    @IBOutlet var btnMenu : UIButton!
    @IBOutlet var imgViwMain : UIImageView!
    @IBOutlet var lblVideoCount : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblDay : UILabel!
    @IBOutlet var lblMonth : UILabel!
    @IBOutlet var lblTime : UILabel!
}


class JournalDetailFeelingCell : UITableViewCell {
    @IBOutlet var lblFeeling        : UILabel!
    @IBOutlet var imgViewFeelings   : UIImageView!
}


class JournalLikeCell : UITableViewCell {
    
}

class MoreStainCell : UITableViewCell {
    
}

class JournalTagsCell : UITableViewCell{
    
}

class JournalDetailStrainCell : UITableViewCell {
    
}

class JournalStrainButtonCell : UITableViewCell {
    
}
