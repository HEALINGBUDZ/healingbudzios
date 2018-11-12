//
//  GroupListViewController.swift
//  BaseProject
//
//  Created by macbook on 17/11/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class GroupListViewController: BaseViewController {

    @IBOutlet var tbleView :UITableView!
    
    @IBOutlet var view_Filter : UIView!
    
     @IBOutlet var tbleViewFilter: UITableView!
     @IBOutlet weak var FilterTopValue: NSLayoutConstraint!
    
    var array_filter = [[String : String]]()
    
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
        self.FilterTopValue.constant = -400
        self.view.layoutIfNeeded()
        
        self.tabBarController?.tabBar.isHidden = false
       
        
    }

    
    func DummyData(){
        var dataDict = [String : String]()
        dataDict["image"] = "Alphabetical_Group"
        dataDict["name"] = "ALPHABETICAL"
        
        var dataDict2 = [String : String]()
        dataDict2["image"] = "New_groups_header_new"
        dataDict2["name"] = "NEWEST"
        
        var dataDict3 = [String : String]()
        dataDict3["image"] = "add_new_groups"
        dataDict3["name"] = "JOINED"
        
        
        self.array_filter.append(dataDict)
        self.array_filter.append(dataDict2)
        self.array_filter.append(dataDict3)
        self.tbleViewFilter.reloadData()
        self.tbleView.reloadData()
    }
}


extension GroupListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func RegisterXib(){
        
        self.tbleView.register(UINib(nibName: "GroupListingCell", bundle: nil), forCellReuseIdentifier: "GroupListingCell")
        
        self.tbleViewFilter.register(UINib(nibName: "QAFilterCell", bundle: nil), forCellReuseIdentifier: "QAFilterCell")
        
        

        self.DummyData()
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return self.array_filter.count
            
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(tableView.tag)
         if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QAFilterCell") as? QAFilterCell
            
            cell?.lbl_Main.text = array_filter[indexPath.row]["name"]
            
            cell?.imageView_Main.image = UIImage.init(named: array_filter[indexPath.row]["image"]!)
            
            cell?.view_BGColor.backgroundColor = UIColor.init(red: (233/255), green: (138/255), blue: (31/255), alpha: 1.0)
            
            
            cell?.selectionStyle = .none
            return cell!
         }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListingCell") as! GroupListingCell
            
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 100 {
            for index in 0..<self.array_filter.count{
                
                if indexPath.row == index {
                    let tbleviewCell = tableView.cellForRow(at: indexPath) as! QAFilterCell
                    tbleviewCell.view_BG.isHidden = false
                }else {
                    let tbleviewCell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! QAFilterCell
                    tbleviewCell.view_BG.isHidden = true
                }
            }
        }else {
            self.PushViewWithIdentifier(name: "GroupChatViewController")
        }
    }
}

//MARK:
//MARK: Button Actions
extension GroupListViewController {
    @IBAction func Goto_NewListing(sender : UIButton){
        self.PushViewWithIdentifier(name: "NewGroupViewController")
    }
    
    
    @IBAction func Menu_open (sender : UIButton){
        
    }
    
    
    @IBAction func showFilter_open (sender : UIButton){

        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = 60 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    @IBAction func HideFilterView(sender : UIButton){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.FilterTopValue.constant = -400 
            self.view.layoutIfNeeded()
        })
    }

}

class GroupListingCell : UITableViewCell {
    
}
