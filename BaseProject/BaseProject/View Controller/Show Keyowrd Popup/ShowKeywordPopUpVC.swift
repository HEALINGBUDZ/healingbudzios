//
//  ShowKeywordPopUpVC.swift
//  BaseProject
//
//  Created by waseem on 28/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

protocol ChooseOpenOptions {
    func ChooseOpenOptions(index : Int , value : String)
}
class ShowKeywordPopUpVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView_Main   : UITableView!
    @IBOutlet weak var lblMAin   : UILabel!
    
    var delegate: ChooseOpenOptions?
    
    var newValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView_Main.register(UINib(nibName: "KeywordChoosecell", bundle: nil), forCellReuseIdentifier: "KeywordChoosecell") 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.lblMAin.text = newValue
    }
    
    
    @IBAction func close_Action(sender : UIButton){
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func Follow_Action(sender : UIButton){
        self.showLoading()
        var newparam = [String : AnyObject]()
        newparam["keyword"] = self.lblMAin.text as AnyObject
        NetworkManager.PostCall(UrlAPI: WebServiceName.follow_keyword.rawValue, params: newparam) { (success, MainMessage, response) in
            print(success)
            print(MainMessage)
            print(response)
            self.hideLoading()
//            self.ShowAlertWithDissmiss(message: "Keyword Followed Successfuly", AlertTitle: "")
            if success {
                self.ShowAlertWithDissmiss(message: response["successMessage"] as! String, AlertTitle: "")
            }else {
                self.ShowAlertWithDissmiss(message: "Error Following Keyword!", AlertTitle: "")
            }
           
            
            
        }
        
    }
    
    
   
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:KeywordChoosecell = (tableView.dequeueReusableCell(withIdentifier: "KeywordChoosecell") as? KeywordChoosecell)!
        
        
        switch indexPath.row {
        case 0:
            cell.lblMain.text = "Questions"
            break
        case 1:
            cell.lblMain.text = "Answers"
            break
            
        case 2:
            cell.lblMain.text = "Strain"
            break
        default:
            cell.lblMain.text = "Budz Adz"
        break
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.delegate?.ChooseOpenOptions(index: indexPath.row, value: self.newValue.replacingOccurrences(of: "#", with: ""))
            self.dismiss(animated: false) {
                
            }
        }
        
        
        
        
    }
    
}

class KeywordChoosecell : UITableViewCell {
    @IBOutlet var lblMain : UILabel!
}
