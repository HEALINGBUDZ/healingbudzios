//
//  AddYourEpertiesVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AAPickerView
import IQKeyboardManager

protocol ChangeEpertiesDelegate: class {
    
    func NewExperties(experties : [AddExperties] , experties2 :[AddExperites2])
}

class AddYourEpertiesVC: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var question_two_table: UITableView!
    @IBOutlet weak var question_one_table: UITableView!
    @IBOutlet weak var chooseQuestion2Height: NSLayoutConstraint!
    
    @IBOutlet weak var question1suggestionTable: UITableView!
    @IBOutlet weak var question2SuggestionTable: UITableView!
    @IBOutlet weak var question1suggestionheight: NSLayoutConstraint!
    @IBOutlet weak var question2suggestionheight: NSLayoutConstraint!
    
    @IBOutlet weak var chooseQuestion1Heaight: NSLayoutConstraint!
    @IBOutlet weak var Question2Heaight: NSLayoutConstraint!
    @IBOutlet weak var Question2view: UIView!
    @IBOutlet weak var Question1View: UIView!
    @IBOutlet weak var Question1Heaight: NSLayoutConstraint!
    @IBOutlet var lblOne: UILabel!
    @IBOutlet var lblTwo: UILabel!
    @IBOutlet var BTNCompleteProfile: UIButton!
    @IBOutlet var BTNADDEXPERTIES: UIButton!
    @IBOutlet var BTNREMINDMELATER: UIButton!
    
//    @IBOutlet var txtFieldOne: AAPickerView!
//    @IBOutlet var txtFieldTwo: AAPickerView!

    @IBOutlet var txtFieldOne: UITextField!
    @IBOutlet var txtFieldTwo: UITextField!
    var question1  = [AddExperties]()
    var question2  = [AddExperites2]()
    var forSearchQ1 = [AddExperties]()
    var forSearchQ2 = [AddExperites2]()
    var question1TxtData  = [AddExperties]()
    var question2TxtData  = [AddExperites2]()
    
    var Choose1  = [AddExperties]()
    var Choose2  = [AddExperites2]()
    
    
    var isShowComplete = false
    var ispopView = false
    
    @IBOutlet weak var expertiseView: UIView!
    
    @IBOutlet weak var crossView: UIView!
    weak var ChangeEpertiesDelegate: ChangeEpertiesDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.question_one_table.delegate = self
        self.question_one_table.dataSource = self
        self.question_two_table.delegate = self
        self.question_two_table.dataSource = self
        
        self.txtFieldOne.delegate = self
        self.txtFieldTwo.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        question1suggestionTable.separatorStyle = .none
        question2SuggestionTable.separatorStyle = .none
        
        self.question_two_table.register(UINib(nibName: "AddExpertiesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddExpertiesTableViewCell")
        
        self.question_one_table.register(UINib(nibName: "AddExpertiesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddExpertiesTableViewCell")
        
        self.question1suggestionTable.register(UINib(nibName: "SuggestAnAddition", bundle: nil), forCellReuseIdentifier: "SuggestAnAddition")
        self.question1suggestionTable.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        self.question2SuggestionTable.register(UINib(nibName: "SuggestAnAddition", bundle: nil), forCellReuseIdentifier: "SuggestAnAddition")
        self.question2SuggestionTable.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        self.expertiseView.isHidden = true
        self.crossView.isHidden = true
        self.ReloadTableData()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.chooseQuestion1Heaight.constant = 150
//        self.chooseQuestion2Height.constant = 150
        self.BTNCompleteProfile.isHidden = true
        self.APICAll()
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldOne{
            if !((txtFieldOne.text!+string).isEmpty){
            self.Question1Heaight.constant = 220
            self.Question1View.layoutIfNeeded()
            self.chooseQuestion1Heaight.constant = 55
                self.question1.removeAll()
                for index in self.forSearchQ1{
                    if index.title.lowercased().contains(txtFieldOne.text!+string){
                        self.question1.append(index)
                    }
                }
                if self.question1.count == 0 {
                    question1suggestionheight.constant = 54
                    self.Question1Heaight.constant = 130
                }else{
                    question1suggestionheight.constant = 150
                }
              self.question1suggestionTable.reloadData()
            }else{
                self.Question1Heaight.constant = 220
                self.Question1View.layoutIfNeeded()
                question1suggestionheight.constant = 150
                self.chooseQuestion1Heaight.constant = 55
                self.question1.removeAll()
                self.question1 = self.forSearchQ1
                self.question1suggestionTable.reloadData()
            }
            
        }
        if textField == txtFieldTwo{
            if !((txtFieldTwo.text!+string).isEmpty){
                self.Question2Heaight.constant = 220
                self.Question2view.layoutIfNeeded()
                self.chooseQuestion1Heaight.constant = 55
                self.question2.removeAll()
                for index in self.forSearchQ2{
                    if index.title.lowercased().contains(txtFieldTwo.text!+string){
                        self.question2.append(index)
                    }
                }
                if self.question2.count == 0 {
                    question2suggestionheight.constant = 54
                    self.Question2Heaight.constant = 130
                }else{
                    question2suggestionheight.constant = 150
                }
                self.question2SuggestionTable.reloadData()
            }else{
                self.Question2Heaight.constant = 220
                self.Question2view.layoutIfNeeded()
                question2suggestionheight.constant = 150
                self.chooseQuestion2Height.constant = 55
                self.question2.removeAll()
                self.question2 = self.forSearchQ2
                self.question2SuggestionTable.reloadData()
            }
        }
        
        if (textField.text?.count)! > 15 {
            return false
        }
        return true
    }
    func APICAll(){
        self.showLoading()
        NetworkManager.GetCall(UrlAPI: WebServiceName.get_expertise.rawValue) { (successResponse, messageResponse, MainResponse) in

            self.hideLoading()
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    print(MainResponse)
                    let mainData = MainResponse["successData"] as! [String : Any]
                    
                    
//                            self.lblOne.text =  mainData[indexObj]["question"] as? String
                            
                            let experties =  mainData["medicals"] as? [[String : AnyObject]]
                            print(experties)
                            for indexObjExperties in experties! {
//
//                                var isFound = false
//
//                                for indexObjChoose in self.Choose1 {
//                                    if (indexObjExperties["title"] as? String) == indexObjChoose.title {
//                                        isFound = true
//                                        break
//                                    }
//                                }
//
//                                if isFound {
//
//                                }else {
//                                    if let isApprove = indexObjExperties["is_approved"] as? String {
//                                        if isApprove == "1" {
//                                           self.question1.append(AddExperties.init(json: indexObjExperties))
//
//                                        }
//                                    }else if let isApprove = indexObjExperties["is_approved"] as? Int {
//                                        if isApprove == 1 {
//                                            self.question1.append(AddExperties.init(json: indexObjExperties))
//
//                                        }
//                                    }
                                    self.question1.append(AddExperties.init(json: indexObjExperties))
                                    self.question1TxtData.append(AddExperties.init(json: indexObjExperties))
//                                }
//                                if let isApprove = indexObjExperties["is_approved"] as? String {
//                                    if isApprove == "1" {
//                                        self.question1TxtData.append(AddExperties.init(json: indexObjExperties))
//
//                                    }
//                                }else if let isApprove = indexObjExperties["is_approved"] as? Int {
//                                    if isApprove == 1 {
//                                        self.question1TxtData.append(AddExperties.init(json: indexObjExperties))
//
//                                    }
//                                }
//
                            }
                    
//                            self.lblTwo.text =  mainData[indexObj]["question"] as? String
                            
                            let experties2 =  mainData["strains"] as? [[String : AnyObject]]
                            
                            for indexObjExperties in experties2! {
//                                var isFound = false
//
//                                for indexObjChoose in self.Choose2 {
//                                    if (indexObjExperties["title"] as? String) == indexObjChoose.title {
//                                        isFound = true
//                                        break
//                                    }
//                                }
                                
//                                if isFound {
//
//                                }else {
//                                    if let isApprove = indexObjExperties["is_approved"] as? String {
//                                        if isApprove == "1" {
//                                           self.question2.append(AddExperties.init(json: indexObjExperties))
//
//                                        }
//                                    }else if let isApprove = indexObjExperties["is_approved"] as? Int {
//                                        if isApprove == 1 {
//                                           self.question2.append(AddExperties.init(json: indexObjExperties))
//
//                                        }
//                                    }
                                    self.question2.append(AddExperites2.init(json: indexObjExperties))
                                    self.question2TxtData.append(AddExperites2.init(json: indexObjExperties))
//                                }
                                
                                
//                                if let isApprove = indexObjExperties["is_approved"] as? String {
//                                    if isApprove == "1" {
//                                        self.question2TxtData.append(AddExperties.init(json: indexObjExperties))
//
//                                    }
//                                }else if let isApprove = indexObjExperties["is_approved"] as? Int {
//                                    if isApprove == 1 {
//                                       ç
//
//                                    }
//                                }
                            
                            }
                    
                    
                    
                    
                    
                    var newvalue = [String]()
                    for indexObj in self.question1 {
                        newvalue.append(indexObj.title)
                    }
                    
                    var newvalue2 = [String]()
                    for indexObj in self.question2 {
                        newvalue2.append(indexObj.title)
                    }
                    
//                    self.txtFieldOne.pickerType = .StringPicker
//                    self.txtFieldOne.stringPickerData = newvalue
//
//                    self.txtFieldTwo.pickerType = .StringPicker
//                    self.txtFieldTwo.stringPickerData = newvalue2
                    self.forSearchQ1 = self.question1
                    self.forSearchQ2 = self.question2
                    self.question1suggestionTable.reloadData()
                    self.question2SuggestionTable.reloadData()
    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == txtFieldOne{
//            if (txtFieldOne.text?.isEmpty)!{
                self.Question1Heaight.constant = 75
                self.Question1View.layoutIfNeeded()
                question1suggestionheight.constant = 0
                self.chooseQuestion1Heaight.constant = 150
                self.ReloadTableData()
                self.question1suggestionTable.reloadData()
//            }
        }else{
//            if (txtFieldTwo.text?.isEmpty)!{
            self.Question2Heaight.constant = 75
            self.Question2view.layoutIfNeeded()
            question2suggestionheight.constant = 0
            self.chooseQuestion2Height.constant = 150
            self.ReloadTableData()
            self.question2SuggestionTable.reloadData()
//            }
        }
        
        

    }
    
    @IBAction func Remember_Me(_ sender: Any) {
        if ispopView {
            self.showLoading()
             self.ChangeEpertiesDelegate?.NewExperties(experties: self.Choose1 , experties2 : self.Choose2)
            self.delayWithSeconds(1) {
                 self.hideLoading()
                self.ChangeEpertiesDelegate?.NewExperties(experties: self.Choose1 , experties2 : self.Choose2)
                self.Back()
            }
        }else {
            self.ShowMenuBaseView()
        }
    }
    
    @IBAction func onClickCross(_ sender: Any) {
        
        self.expertiseView.isHidden = true
        self.crossView.isHidden = true
        
    }
    @IBAction func onClickInfo(_ sender: Any) {
//        self.expertiseView.isHidden = false
//        self.crossView.isHidden = false
    }
    
    func saveExperties() {
          self.showLoading()
        self.delayWithSeconds(1) {
            self.question2suggestionheight.constant = 0
            self.question1suggestionheight.constant = 0
            var newPAram = [String : AnyObject]()
            var questionExperties = ""
            for indexObj in self.Choose1 {
                if questionExperties.characters.count == 0 {
                    questionExperties = String(indexObj.id)
                }else {
                    questionExperties = questionExperties + "," + String(indexObj.id)
                }
            }
            newPAram["question_one_exprties"] = questionExperties as AnyObject
            questionExperties = ""
            for indexObj in self.Choose2 {
                if questionExperties.characters.count == 0 {
                    questionExperties = String(indexObj.id)
                }else {
                    questionExperties = questionExperties + "," + String(indexObj.id)
                }
            }
            newPAram["question_two_exprties"] = questionExperties as AnyObject
            print(newPAram)
            NetworkManager.PostCall(UrlAPI: WebServiceName.add_expertise.rawValue, params: newPAram) { (successResponse, messageResponse, MainResponse) in
                self.hideLoading()
                
                if successResponse {
                    if (MainResponse["status"] as! String) == "success" {
                        self.ChangeEpertiesDelegate?.NewExperties(experties: self.Choose1 , experties2 : self.Choose2)
                    }else {
                        if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                            DataManager.sharedInstance.logoutUser()
                            self.ShowLogoutAlert()
                        }
                    }
                }else {
                    self.ShowErrorAlert(message:messageResponse)
                }
                
                
            }
        }
    }
    @IBAction func Add_Experties(_ sender: Any) {
        self.question2suggestionheight.constant = 0
        self.question1suggestionheight.constant = 0
        if self.Choose2.count == 0 || self.Choose1.count == 0 {
            
//            self.ShowErrorAlert(message: "Please add at least one answer in each question!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.ReloadTableData()
            })
            
            self.BTNCompleteProfile.isHidden = true
            self.BTNADDEXPERTIES.isHidden = false
            self.BTNREMINDMELATER.isHidden = false
            self.Question2view.isHidden = false
            self.Question1View.isHidden = false
//            return
        }
        
        var newPAram = [String : AnyObject]()
        
        var questionExperties = ""
        for indexObj in self.Choose1 {
            if questionExperties.characters.count == 0 {
                questionExperties = String(indexObj.id)
            }else {
                questionExperties = questionExperties + "," + String(indexObj.id)
            }
        }
        
        newPAram["question_one_exprties"] = questionExperties as AnyObject
        
        
        questionExperties = ""
        for indexObj in self.Choose2 {
            if questionExperties.characters.count == 0 {
                questionExperties = String(indexObj.id)
            }else {
                questionExperties = questionExperties + "," + String(indexObj.id)
            }
        }
        
        newPAram["question_two_exprties"] = questionExperties as AnyObject
        
        self.showLoading()
        
        print(newPAram)
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_expertise.rawValue, params: newPAram) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    if self.isShowComplete{
                        self.ChangeEpertiesDelegate?.NewExperties(experties: self.Choose1 , experties2 : self.Choose2)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.PushViewWithIdentifier(name: "CompleteProfileVC")
                    }
                    
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            
        }
        
//            self.BTNCompleteProfile.isHidden = false
//            self.BTNADDEXPERTIES.isHidden = true
//            self.BTNREMINDMELATER.isHidden = true
//
//            self.Question2view.isHidden = true
//            self.Question2Heaight.constant = 0
//
//            self.Question1View.isHidden = true
//            self.Question1Heaight.constant = 0
    }
    
    
    func addNewSuggestion1(sender: UIButton!){
        question2suggestionheight.constant = 0
        txtFieldOne.endEditing(true)
        if !(txtFieldOne.text?.isEmpty)!{
           let string = txtFieldOne.text!
            var optionSuggest = self.Choose1.filter({$0.title.trimmingCharacters(in: .whitespaces) == string.trimmingCharacters(in: .whitespaces)})
            if optionSuggest.count != 0{
                self.ShowErrorAlert(message: "Cannot add same experty two times!")
            }else{
                self.showLoading()
                var params = [String: AnyObject]()
                params["exp_question_id"] = "1" as AnyObject
                params["suggestion"] = string as AnyObject
                NetworkManager.PostCall(UrlAPI: "add_expertise_suggestion", params: params, completion: {(success, message, response) in
                    self.hideLoading()
                    print(response)
                    if success{
                        self.txtFieldOne.text = ""
                        var suggest = AddExperties()
                        let s = response["successData"] as! [String: AnyObject]
                        let new = AddExperties.init(json: s)
                        suggest = new
                        suggest.title = string
                        suggest.id = s["exp_id"] as! Int
                        suggest.suggestion = true
                        self.Choose1.append(suggest)
                        for item in 0..<self.Choose1.count {
                            self.Choose1[item].warnpopup = 0
                        }
                        self.Question1Heaight.constant = 75
                        self.Question1View.layoutIfNeeded()
                        self.question1suggestionheight.constant = 0
                        self.chooseQuestion1Heaight.constant = 150
                        self.ReloadTableData()
                        self.question1suggestionTable.reloadData()
                    }else{
                        self.ShowErrorAlert(message: message)
                    }
                })
            }
        }
    }
    
    func addNewSuggestion2(sender: UIButton!){
        question1suggestionheight.constant = 0
        txtFieldTwo.endEditing(true)
        if !(txtFieldTwo.text?.isEmpty)!{
            let string = txtFieldTwo.text!
            var optionSuggest = self.Choose2.filter({$0.title.trimmingCharacters(in: .whitespaces) == string.trimmingCharacters(in: .whitespaces)})
            if optionSuggest.count != 0{
                self.ShowErrorAlert(message: "Cannot add same experty two times!")
            }else{
                self.showLoading()
                var params = [String: AnyObject]()
                params["exp_question_id"] = "2" as AnyObject
                params["suggestion"] = string as AnyObject
                NetworkManager.PostCall(UrlAPI: "add_expertise_suggestion", params: params, completion: {(success, message, response) in
                    self.hideLoading()
                    print(response)
                    if success{
                        self.txtFieldTwo.text = ""
                        var suggest = AddExperties()
                        let s = response["successData"] as! [String: AnyObject]
                        let new = AddExperties.init(json: s)
                        suggest = new
                        suggest.title = string
                        suggest.id = s["exp_id"] as! Int
                        suggest.suggestion = true
//                        self.Choose2.append(suggest)
                        for item in 0..<self.Choose2.count {
                            self.Choose2[item].warnpopup = 0
                        }
                        self.Question2Heaight.constant = 75
                        self.Question2view.layoutIfNeeded()
                        self.question2suggestionheight.constant = 0
                        self.chooseQuestion2Height.constant = 150
                        self.ReloadTableData()
                        self.question2SuggestionTable.reloadData()
                    }else{
                        self.ShowErrorAlert(message: message)
                    }
                })
            }
        }
    }
    
    func warnPopup1(sender: UIButton!){
        if self.Choose1[sender.tag].suggestion{
        if self.Choose1[sender.tag].warnpopup == 0{
        self.Choose1[sender.tag].warnpopup = 0
        }else{
        self.Choose1[sender.tag].warnpopup = 0
        }
       
        }
         self.question_one_table.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .fade)
    }
    
    func warnPopup2(sender: UIButton!){
        if self.Choose2[sender.tag].suggestion{
        if self.Choose2[sender.tag].warnpopup == 0{
            self.Choose2[sender.tag].warnpopup = 0
        }else{
            self.Choose2[sender.tag].warnpopup = 0
        }
            
        }
        self.question_two_table.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .fade)
    }
    
    func cross1(sender: UIButton!){
        self.question1.append(self.Choose1[sender.tag])
        self.forSearchQ1.append(self.Choose1[sender.tag])
        self.Choose1.remove(at: sender.tag)
        self.ReloadTableData()
        self.question1suggestionTable.reloadData()
        self.question_one_table.reloadData()
        self.saveExperties()
    }
    func cross2(sender: UIButton!){
        self.question2.append(self.Choose2[sender.tag])
        self.forSearchQ2.append(self.Choose2[sender.tag])
        self.Choose2.remove(at: sender.tag)
        self.ReloadTableData()
        self.question2SuggestionTable.reloadData()
        self.question_two_table.reloadData()
        
        self.saveExperties()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == question1suggestionTable{
            if self.question1.count == 0{
                return 1
            }else{
                return question1.count
            }
        }else if tableView == question2SuggestionTable{
            if self.question2.count == 0{
                return 1
            }else{
                return question2.count
            }
        }else
        if tableView == question_two_table {
            return Choose2.count
        }else{
        
        return Choose1.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == question1suggestionTable || tableView == question2SuggestionTable{
         var newValue = [String]()
            if tableView == question1suggestionTable{
                for value in question1{
                    newValue.append(value.title)
                }
                if newValue.count > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                    cell.lblName.text = newValue[indexPath.row]
                    cell.lblName.textAlignment = .left
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 0{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                        cell.lblName.text = "No Condition Found"
                        cell.lblName.textAlignment = .center
                        cell.selectionStyle = .none
                        return cell
                }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestAnAddition", for: indexPath) as! SuggestAnAddition
                    cell.btn_Suggestion.addTarget(self, action: #selector(addNewSuggestion1), for: .touchUpInside)
                        cell.selectionStyle = .none
                        return cell
                    }
            }else if tableView == question2SuggestionTable{
                for value in question2{
                    newValue.append(value.title)
                }
                if newValue.count > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                    cell.lblName.text = newValue[indexPath.row]
                    cell.lblName.textAlignment = .left
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 0{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                        cell.lblName.text = "No Condition Found"
                        cell.lblName.textAlignment = .center
                        cell.selectionStyle = .none
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestAnAddition", for: indexPath) as! SuggestAnAddition
                    cell.btn_Suggestion.addTarget(self, action: #selector(addNewSuggestion2), for: .touchUpInside)
                        cell.selectionStyle = .none
                        return cell
                    }
            }

            
        }
        
        
        if tableView == question_two_table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpertiesTableViewCell", for: indexPath) as! AddExpertiesTableViewCell
            cell.lblName.text = self.Choose2[indexPath.row].title
            if self.Choose2[indexPath.row].suggestion{
                cell.warnView.isHidden = true
                cell.warnButton.tag = indexPath.row
                cell.warnButton.addTarget(self, action: #selector(warnPopup2), for: .touchUpInside)
                if self.Choose2[indexPath.row].warnpopup == 1{
                    cell.warnPopUP.isHidden = false
                    
                }else{
                    cell.warnPopUP.isHidden = true
                }
            }else{
                cell.warnView.isHidden = true
                cell.warnPopUP.isHidden = true
            }
           
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self, action: #selector(cross2), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpertiesTableViewCell", for: indexPath) as! AddExpertiesTableViewCell
            cell.lblName.text = self.Choose1[indexPath.row].title
            if self.Choose1[indexPath.row].suggestion{
                cell.warnView.isHidden = true
                cell.warnButton.tag = indexPath.row
                cell.warnButton.addTarget(self, action: #selector(warnPopup1), for: .touchUpInside)
                if self.Choose1[indexPath.row].warnpopup == 1{
                    cell.warnPopUP.isHidden = false
                }else{
                    cell.warnPopUP.isHidden = true
                }
            }else{
                cell.warnView.isHidden = true
                cell.warnPopUP.isHidden = true
            }
            
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self, action: #selector(cross1), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.txtFieldOne.resignFirstResponder()
        self.txtFieldTwo.resignFirstResponder()
        if tableView == question1suggestionTable{
            question2suggestionheight.constant = 0
            if question1.count > 0{
            self.txtFieldOne.text = ""
            self.Choose1.append(question1[indexPath.row])
            self.forSearchQ1.remove(at: self.forSearchQ1.index(where: {$0.title == self.question1[indexPath.row].title})!)
            self.question1.remove(at: indexPath.row)
            self.Question1Heaight.constant = 75
            self.Question1View.layoutIfNeeded()
            question1suggestionheight.constant = 0
            self.chooseQuestion1Heaight.constant = 150
            self.ReloadTableData()
            self.question1suggestionTable.reloadData()
            }
            
        }else if tableView == question2SuggestionTable{
            question1suggestionheight.constant = 0
            if question2.count  > 0{
            self.txtFieldTwo.text = ""
            self.Choose2.append(question2[indexPath.row])
            self.forSearchQ2.remove(at: self.forSearchQ2.index(where: {$0.title == self.question2[indexPath.row].title})!)
            self.question2.remove(at: indexPath.row)
            self.Question2Heaight.constant = 75
            self.Question2view.layoutIfNeeded()
            question2suggestionheight.constant = 0
            self.chooseQuestion2Height.constant = 150
            self.ReloadTableData()
            self.question2SuggestionTable.reloadData()
            }
        }
       
    }

    func ReloadTableData(){
        if self.Choose2.count > 4 {
            self.Question2view.isHidden = true
            self.Question2Heaight.constant = 0
        }else {
            self.Question2view.isHidden = false
            self.Question2Heaight.constant = 75
        }
        
        
        var newvalue = [String]()
        for indexObj in self.question1 {
            newvalue.append(indexObj.title)
        }
        
        
//        self.txtFieldOne.stringPickerData = newvalue
        
        
        var newvalue2 = [String]()
        for indexObj in self.question2 {
            newvalue2.append(indexObj.title)
        }
        
        
//        self.txtFieldTwo.stringPickerData = newvalue2
        
        
        if self.Choose1.count > 4 {
            self.Question1View.isHidden = true
            self.Question1Heaight.constant = 0
        }else {
            self.Question1View.isHidden = false
            self.Question1Heaight.constant = 75
        }
        
        self.question_two_table.reloadData()
        self.question_one_table.reloadData()
        
        self.chooseQuestion2Height.constant = CGFloat((25 * (self.Choose2.count +  1)) + 50 )
        self.chooseQuestion1Heaight.constant = CGFloat((25 * (self.Choose1.count +  1)) + 50 )
        self.view.layoutIfNeeded()
    }
    @IBAction func Complete_Profile(sender : UIButton){
        
        
        if self.Choose2.count == 0 || self.Choose1.count == 0 {
            
            self.ShowErrorAlert(message: "Please add at least one answer in each question!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.ReloadTableData()
            })
            
            self.BTNCompleteProfile.isHidden = true
            self.BTNADDEXPERTIES.isHidden = false
            self.BTNREMINDMELATER.isHidden = false
            self.Question2view.isHidden = false
            self.Question1View.isHidden = false
            return
        }
        
        var newPAram = [String : AnyObject]()
        
        var questionExperties = ""
        for indexObj in self.Choose1 {
            if questionExperties.characters.count == 0 {
                questionExperties = String(indexObj.id)
            }else {
                questionExperties = questionExperties + "," + String(indexObj.id)
            }
        }
        
        newPAram["question_one_exprties"] = questionExperties as AnyObject

        
        questionExperties = ""
        for indexObj in self.Choose2 {
            if questionExperties.characters.count == 0 {
                questionExperties = String(indexObj.id)
            }else {
                questionExperties = questionExperties + "," + String(indexObj.id)
            }
        }
        
        newPAram["question_two_exprties"] = questionExperties as AnyObject
        
        self.showLoading()

        print(newPAram)
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_expertise.rawValue, params: newPAram) { (successResponse, messageResponse, MainResponse) in
            self.hideLoading()
            
            if successResponse {
                if (MainResponse["status"] as! String) == "success" {
                    if self.isShowComplete{
                        self.ChangeEpertiesDelegate?.NewExperties(experties: self.Choose1 , experties2 : self.Choose2)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.PushViewWithIdentifier(name: "CompleteProfileVC")
                    }
   
                }else {
                    if (MainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
            
            
        }
        
    }
}
