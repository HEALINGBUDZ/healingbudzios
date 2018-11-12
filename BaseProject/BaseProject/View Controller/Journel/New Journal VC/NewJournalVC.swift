//
//  NewJournalVC.swift
//  BaseProject
//
//  Created by macbook on 14/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class NewJournalVC: BaseViewController {

    @IBOutlet var tbleViewMain : UITableView!
    @IBOutlet var view_Feeling : UIView!
    
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
        self.mainArray.append(["type" : "8" , "data" : ""])
        self.tbleViewMain.reloadData()
    }
}


extension NewJournalVC : UITableViewDataSource, UITableViewDelegate {

    func RegisterXib(){
        
        self.tbleViewMain.register(UINib(nibName: "NewJournalUploadPhotoCell", bundle: nil), forCellReuseIdentifier: "NewJournalUploadPhotoCell")
        self.tbleViewMain.register(UINib(nibName: "NewJournalDateChoosecell", bundle: nil), forCellReuseIdentifier: "NewJournalDateChoosecell")

        self.tbleViewMain.register(UINib(nibName: "NewJournalFeelingcell", bundle: nil), forCellReuseIdentifier: "NewJournalFeelingcell")

        self.tbleViewMain.register(UINib(nibName: "NewJournalNameCell", bundle: nil), forCellReuseIdentifier: "NewJournalNameCell")

        self.tbleViewMain.register(UINib(nibName: "NewJournaltagsCell", bundle: nil), forCellReuseIdentifier: "NewJournaltagsCell")

        self.tbleViewMain.register(UINib(nibName: "NewJournaltagsStrainCell", bundle: nil), forCellReuseIdentifier: "NewJournaltagsStrainCell")

        self.tbleViewMain.register(UINib(nibName: "NewJournalCrossStrainCell", bundle: nil), forCellReuseIdentifier: "NewJournalCrossStrainCell")

        self.tbleViewMain.register(UINib(nibName: "NewJournalPublishCell", bundle: nil), forCellReuseIdentifier: "NewJournalPublishCell")

        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainData = self.mainArray[indexPath.row]
        
        
        switch (mainData["type"] as! String) {
            
        case "2":
            return NewJournalDateChoose(tableView, cellForRowAt: indexPath)

        case "3":
            return NewJournalFeelingCell(tableView, cellForRowAt: indexPath)

        case "4":
            return NewJournalEnterNameCell(tableView, cellForRowAt: indexPath)
            
        case "5":
            return NewJournalTag(tableView, cellForRowAt: indexPath)

        case "6":
            return NewJournalStrainTag(tableView, cellForRowAt: indexPath)

            
        case "7":
            return NewJournalStrain(tableView, cellForRowAt: indexPath)

            
        case "8":
            return NewJournalPublishCell(tableView, cellForRowAt: indexPath)
            
        default :
            return UploadPhotoCell(tableView, cellForRowAt: indexPath)
            
        }

    }
    
    
    
    func UploadPhotoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalUploadPhotoCell") as! NewJournalUploadPhotoCell
        
        cell.btn_back.addTarget(self, action: #selector(self.Back_Action), for: UIControlEvents.touchUpInside)
        
        cell.btn_home.addTarget(self, action: #selector(self.Home_Action), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func NewJournalPublishCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalPublishCell") as! NewJournalPublishCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func NewJournalDateChoose(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalDateChoosecell") as! NewJournalDateChoosecell
        
        
        cell.selectionStyle = .none
        return cell
    }

    
    func NewJournalFeelingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalFeelingcell") as! NewJournalFeelingcell
        
        
        cell.btn_AddNew.addTarget(self, action: #selector(self.ShowFeeling), for: UIControlEvents.touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func NewJournalEnterNameCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalNameCell") as! NewJournalNameCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func NewJournalStrain(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournalCrossStrainCell") as! NewJournalCrossStrainCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func NewJournalStrainTag(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournaltagsStrainCell") as! NewJournaltagsStrainCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func NewJournalTag(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJournaltagsCell") as! NewJournaltagsCell
        
        
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:
//MARK: Button Actions 
extension NewJournalVC {
    func ShowFeeling(){
        self.view_Feeling.isHidden = false
    }
    
    @IBAction func HideFeelingView(){
        self.view_Feeling.isHidden = true
    }
 
    
    func Back_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func Home_Action(sender : UIButton){
        self.GotoHome()
//        self.navigationController?.popViewController(animated: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)
    }

    
    
}

class NewJournalUploadPhotoCell : UITableViewCell {
    
    @IBOutlet var btn_back : UIButton!
    @IBOutlet var btn_home : UIButton!
}

class NewJournalDateChoosecell : UITableViewCell{
    
}

class NewJournalFeelingcell : UITableViewCell {
    @IBOutlet var btn_AddNew : UIButton!
}

class NewJournalNameCell: UITableViewCell {
    
}

class NewJournaltagsCell: UITableViewCell {
    
}

class NewJournaltagsStrainCell : UITableViewCell {
    
}

class NewJournalCrossStrainCell : UITableViewCell {
    
}

class NewJournalPublishCell : UITableViewCell {
    
}

