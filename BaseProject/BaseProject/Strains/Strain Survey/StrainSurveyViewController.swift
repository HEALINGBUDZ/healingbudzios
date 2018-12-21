//
//  StrainSurveyViewController.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


class StrainSurveyViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var backView: CircleView!
    
    @IBOutlet weak var addd_flavor_btn: UILabel!
    var question1 = "What medical conditions have you effectively treated with this strain?"
    var question2 = "Which moods or sensations have you experienced with this strain?"
    var question3 = "What negative effects have you experienced with this strain?"
    var question4 = "Are you currently using cannabis as preventive medication?"
    var question5 = "Which 3 prevention areas are you focusing on?"
    var question6 = "What flavor profiles would you associate with this strain?"
    
    var first = ""
    var second = ""
    var third = ""
    
    var questionNumber = 0
    var skip = 0
    var chooseStrain = Strain()
    
    var answer1 = [String]()
    var answer1New = [SurveyAnswers]()
    var answer2New = [SurveyAnswers]()
    var answer3New = [SurveyAnswers]()
    var answer5New = [SurveyAnswers]()
    var answer2 = [String]()
    var answer3 = [String]()
    var answer4 = [String]()
    var answer5 = [String]()
    var answer6 = [String]()
    
    @IBOutlet weak var btnCrossSelection: UIButton!
    var suggestionCount = 0
    
   
    @IBOutlet var view_First : UIView!
    @IBOutlet var view_Last : UIView!
    @IBOutlet var view_FirstCross : UIView!
    
    @IBOutlet var view_Empty : UIView!
    @IBOutlet var view_Question4 : UIView!
    
    @IBOutlet var btnYes_Question4 : UIButton!
    @IBOutlet var btnNo_Question4 : UIButton!
    
    @IBOutlet var view_ChooseValue : UIView!
    @IBOutlet var view_MaxValue : UIView!
    @IBOutlet var lblMAxChooseAnswer : UILabel!
    
    @IBOutlet var lblQuestion : UILabel!
    @IBOutlet var lblChooseAnswer : UILabel!
    @IBOutlet var lblQuestionNumber : UILabel!
    
    @IBOutlet var txtFieldMain : UITextField!
    
    @IBOutlet var tbleViewMain : UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var tbleViewFlavor : UITableView!
    @IBOutlet var viewFlavor : UIView!
    @IBOutlet var viewFlavor_TbleView : UIView!
    @IBOutlet var lblchooseFlavor : UILabel!
    @IBOutlet var view_AddMoreFlovoutBtn : UIView!
    @IBOutlet var viewChooseWarning: UIView!
    @IBOutlet var viewMaxChooseWarning: UIView!
    @IBOutlet var viewChooseWarningPopUp: UIView!
    @IBOutlet var viewMaxChooseWarningPopup: UIView!
    @IBOutlet var viewChooseWarning2: UIView!
    @IBOutlet var viewMaxChooseWarning2: UIView!
    @IBOutlet var viewChooseWarningPopUp2: UIView!
    @IBOutlet var viewMaxChooseWarningPopup2: UIView!
    @IBOutlet var viewChooseWarning3: UIView!
    @IBOutlet var viewMaxChooseWarning3: UIView!
    @IBOutlet var viewChooseWarningPopUp3: UIView!
    @IBOutlet var viewMaxChooseWarningPopup3: UIView!
    @IBOutlet var viewChooseWarningButton: UIButton!
    @IBOutlet var viewMaxChooseWarningButton: UIButton!
    @IBOutlet var viewChooseWarningAlignment1: NSLayoutConstraint!
    @IBOutlet var viewChooseWarningAlignment2: NSLayoutConstraint!
    @IBOutlet var viewChooseWarningAlignment3: NSLayoutConstraint!
    @IBOutlet var viewMaxChooseWarningAlignment1: NSLayoutConstraint!
    @IBOutlet var viewMaxChooseWarningAlignment2: NSLayoutConstraint!
    @IBOutlet var viewMaxChooseWarningAlignment3: NSLayoutConstraint!
    @IBOutlet var tableViewAnswers: UITableView!
    @IBOutlet var tableviewAnswersHeight: NSLayoutConstraint!
    @IBOutlet var answerTableViewContainer: UIView!
    @IBOutlet var flavourSearchField: UITextField!
    @IBOutlet var noItemFound: UILabel!
    var arraySuggestion = [String]()
    
    var arrayTbleView = [String]()
    var searchFlavor = [String]()
    var valueforYEs = "YES"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tbleViewMain.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")

        self.tbleViewFlavor.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")

        self.tbleViewMain.register(UINib(nibName: "SuggestAnAddition", bundle: nil), forCellReuseIdentifier: "SuggestAnAddition")
        
        self.tableViewAnswers.register(UINib.init(nibName: "AddExpertiesTableViewCell", bundle:  nil), forCellReuseIdentifier: "AddExpertiesTableViewCell")
        // Do any additional setup after loading the view.
        self.tableViewHeight.constant = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.view_First.isHidden = false
        self.view_FirstCross.isHidden = false
        self.view_Empty.isHidden = true
        self.view_AddMoreFlovoutBtn.isHidden = false
        self.view_MaxValue.isHidden = true
        self.view_ChooseValue.isHidden = true
         self.viewFlavor_TbleView.isHidden = true
        self.viewFlavor.isHidden = true
        self.view_Last.isHidden = true
        self.viewChooseWarning.isHidden = true
        self.viewMaxChooseWarning.isHidden = true
        self.viewChooseWarningPopUp.isHidden = true
        self.viewMaxChooseWarningPopup.isHidden = true
        self.answer1.removeAll()
        self.answer2.removeAll()
        self.answer3.removeAll()
        self.answer4.removeAll()
        self.answer5.removeAll()
        self.answer6.removeAll()
        self.questionNumber = 0
        tableViewHeight.constant = 0
        self.lblchooseFlavor.text = ""
        self.btnYes_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
        self.backView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnCancelSelection(_ sender: Any) {
        
        if questionNumber == 1{
            if answer1New.count == 3{
                self.answerTableViewContainer.isHidden = false
                self.view_MaxValue.isHidden = false
            }else{
                if answer1New.count > 0{
                    self.answerTableViewContainer.isHidden = false
                    self.view_ChooseValue.isHidden = false
                
                }
            }
        }
       else if questionNumber == 2{
            if answer2New.count == 3{
                self.answerTableViewContainer.isHidden = false
                self.view_MaxValue.isHidden = false
            }else{
                if answer2New.count > 0{
                    self.answerTableViewContainer.isHidden = false
                    self.view_ChooseValue.isHidden = false
                    
                }
            }
        }
       else if questionNumber == 3{
            if answer3New.count == 3{
                self.answerTableViewContainer.isHidden = false
                self.view_MaxValue.isHidden = false
            }else{
                if answer3New.count > 0{
                    self.answerTableViewContainer.isHidden = false
                    self.view_ChooseValue.isHidden = false
                    
                }
            }
        }
        
        
       else if questionNumber == 5{
            if answer5New.count == 3{
                self.answerTableViewContainer.isHidden = false
                self.view_MaxValue.isHidden = false
            }else{
                if answer5New.count > 0{
                    self.answerTableViewContainer.isHidden = false
                    self.view_ChooseValue.isHidden = false
                }
            }
        }
        
        
        self.tableViewAnswers.reloadData()
        
    }
    @IBAction func StartSurvey(sender : UIButton){
        
        self.txtFieldMain.endEditing(true)
        suggestionCount = 0
        skip = 0
        
        self.first = ""
        self.second = ""
        if questionNumber == 6 {
            if self.answer6.count == 0 {
                return
            }
        }
        self.view_First.isHidden = true
        self.view_FirstCross.isHidden = true
        if (questionNumber == 4){
            if (self.isNoSelect == 0){
                questionNumber = questionNumber + 1
            }else {
                questionNumber = questionNumber + 2
            }
        }else {
         questionNumber = questionNumber + 1
        }
        

        if questionNumber > 6 {
            view_Last.isHidden = false
            self.SubmitCall()
            self.view_First.isHidden = true
            self.view_FirstCross.isHidden = false
            self.view_Empty.isHidden = true
            self.view_MaxValue.isHidden = true
            self.view_ChooseValue.isHidden = true
            self.viewFlavor_TbleView.isHidden = true
            self.viewFlavor.isHidden = true
            self.view_Last.isHidden = false
        }else {
            self.GotoQuestion()
        }
    }
    
    func SubmitCall(){
        var newPAram = [String : AnyObject]()
        newPAram["strain_id"] = self.chooseStrain.strain?.strainID as AnyObject
        var param1 = [String]()
        var param2 = [String]()
        var param3 = [String]()
        var param5 = [String]()
        for i in 0..<answer1New.count{
            param1.append(answer1New[i].value)
        }
        for i in 0..<answer2New.count{
            param2.append(answer2New[i].value)
        }
        
        for i in 0..<answer3New.count{
            param3.append(answer3New[i].value)
        }
        
        for i in 0..<answer5New.count{
            param5.append(answer5New[i].value)
        }
        newPAram["q1_answer"] = param1.joined(separator: ",") as AnyObject
        newPAram["q2_answer"] = param2.joined(separator: ",") as AnyObject
        newPAram["q3_answer"] = param3.joined(separator: ",") as AnyObject
        newPAram["q4_answer"] = valueforYEs as AnyObject
        newPAram["q5_answer"] = param5.joined(separator: ",") as AnyObject
        newPAram["q6_answer"] = answer6.joined(separator: ",") as AnyObject
        
        
        print(newPAram)
        
        self.showLoading()
        NetworkManager.PostCall(UrlAPI:WebServiceName.save_survey_answer.rawValue , params: newPAram) { (success, message, mainData) in
            print(mainData)
            self.view_ChooseValue.isHidden = false
            self.hideLoading()
            
            if success {
                if (mainData["status"] as! String) == "success" {
//                    self.ShowSuccessAlertWithNoAction(message: "Survey submitted successfully!")
                }else {
                    if (mainData["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                self.ShowErrorAlert(message:message)
            }
        }
    }
    
    @IBAction func backButtonSurvey(sender: UIButton!){
        //GotoQuestion
//        self.isNoSelect
        if (questionNumber == 6){
            if (self.isNoSelect == 0){
                self.questionNumber = self.questionNumber - 1
            }else {
                self.questionNumber = self.questionNumber - 2
            }
        }else {
            self.questionNumber = self.questionNumber - 1
        }
    
        self.GotoQuestion()
    }
    
    func GotoQuestion(){
        if self.questionNumber == 1{
        self.backView.isHidden = true
        }else{
            self.backView.isHidden = false
        }
        self.viewFlavor_TbleView.isHidden = true
        self.view_MaxValue.isHidden = true
        self.answerTableViewContainer.isHidden = true
        self.lblMAxChooseAnswer.text = ""
        self.view_Question4.isHidden = true
        self.viewChooseWarning.isHidden = true
        self.viewMaxChooseWarning.isHidden = true
        self.viewChooseWarningPopUp.isHidden = true
        self.viewMaxChooseWarningPopup.isHidden = true
        self.viewChooseWarning2.isHidden = true
        self.viewMaxChooseWarning2.isHidden = true
        self.viewChooseWarningPopUp2.isHidden = true
        self.viewMaxChooseWarningPopup2.isHidden = true
        self.viewChooseWarning3.isHidden = true
        self.viewMaxChooseWarning3.isHidden = true
        self.viewChooseWarningPopUp3.isHidden = true
        self.viewMaxChooseWarningPopup3.isHidden = true
        self.skip = 0
        lblQuestionNumber.text = "QUESTION " + String(questionNumber) + "/6"

        self.arraySuggestion.removeAll()
        self.arrayTbleView.removeAll()
        self.lblChooseAnswer.text = ""
        self.view_ChooseValue.isHidden = true
        
        
        tableViewAnswers.reloadData()
        self.arraySuggestion.removeAll()
        self.arrayTbleView.removeAll()
        if self.questionNumber == 1 {
            for indexObj in self.chooseStrain.ans_Madical_conditions!
            {
                if let effect = indexObj.effect{
                    if !self.arraySuggestion.contains(effect){
                        self.arraySuggestion.append(effect)
                    }
                }
                
                if let effect = indexObj.effect{
                    print(effect)
                    if !self.arrayTbleView.contains(effect){
                         self.arrayTbleView.append(effect)
                    }
                }
            }
            self.arrayTbleView = self.arrayTbleView.removingDuplicates()
             print(self.arrayTbleView)
            self.lblQuestion.text = self.question1
            if self.answer1New.count > 0{
                if self.answer1New.count == 3{
                    self.view_MaxValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer1.count{
                        if i == 0{
                            self.lblMAxChooseAnswer.text = answer1[i]
                            
                        }else{
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer1[i]
                        }
                    }
                }else{
                self.view_ChooseValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                for i in 0..<answer1.count{
                    if i == 0{
                        self.lblChooseAnswer.text = answer1[i]
                        self.lblMAxChooseAnswer.text = answer1[i]
                    }else{
                        self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + answer1[i]
                        self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer1[i]
                    }
                }
                }
            }
            self.txtFieldMain.becomeFirstResponder()
        }else if self.questionNumber == 2 {
            for indexObj in self.chooseStrain.ans_Sensations!
            {
                if let effect = indexObj.effect{
                    self.arraySuggestion.append(effect)
                }
                if let effect = indexObj.effect{
                    if !self.arrayTbleView.contains(effect){
                        self.arrayTbleView.append(effect)
                    }
                }
            }
            self.lblQuestion.text = self.question2
            if self.answer2New.count > 0{
                if self.answer2New.count == 3{
                    self.view_MaxValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer2.count{
                        if i == 0{
                            self.lblMAxChooseAnswer.text = answer2[i]
                            
                        }else{
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer2[i]
                        }
                    }
                }else{
                    self.view_ChooseValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer2.count{
                        if i == 0{
                            self.lblChooseAnswer.text = answer2[i]
                            self.lblMAxChooseAnswer.text = answer2[i]
                        }else{
                            self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + answer2[i]
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer2[i]
                        }
                    }
                }
            }
            self.txtFieldMain.becomeFirstResponder()
        }else if self.questionNumber == 3 {
            for indexObj in self.chooseStrain.ans_Negative_effects!
            {
                if let effect = indexObj.effect{
                    self.arraySuggestion.append(effect)
                }
                if let effect = indexObj.effect{
                    if !self.arrayTbleView.contains(effect){
                        self.arrayTbleView.append(effect)
                    }
                }
            }
            self.lblQuestion.text = self.question3
            if self.answer3New.count > 0{
                if self.answer3New.count == 3{
                    self.view_MaxValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer3.count{
                        if i == 0{
                            self.lblMAxChooseAnswer.text = answer3[i]
                            
                        }else{
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer3[i]
                        }
                    }
                }else{
                    self.view_ChooseValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer3.count{
                        if i == 0{
                            self.lblChooseAnswer.text = answer3[i]
                            self.lblMAxChooseAnswer.text = answer3[i]
                        }else{
                            self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + answer3[i]
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer3[i]
                        }
                    }
                }
            }
            self.txtFieldMain.becomeFirstResponder()
        }else if self.questionNumber == 4 {
            self.lblQuestion.text = self.question4
            if self.valueforYEs == "YES"{
                self.isNoSelect = 0
                self.btnNo_Question4.setTitleColor(ConstantsColor.kBudzUnselectColor, for: .normal)
                self.btnYes_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
            }else{
                self.isNoSelect = 1
                self.btnYes_Question4.setTitleColor(ConstantsColor.kBudzUnselectColor, for: .normal)
                self.btnNo_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
            }
        }else if self.questionNumber == 5 {
            for indexObj in self.chooseStrain.ans_Preventions!
            {
                if let effect = indexObj.effect{
                    self.arraySuggestion.append(effect)
                }
                if let effect = indexObj.effect{
                    if !self.arrayTbleView.contains(effect){
                        self.arrayTbleView.append(effect)
                    }
                }
            }
            self.lblQuestion.text = self.question5
            if self.answer5New.count > 0{
                self.viewFlavor.isHidden = true
                if self.answer5New.count == 3{
                    self.view_MaxValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer5.count{
                        if i == 0{
                            self.lblMAxChooseAnswer.text = answer5[i]
                            
                        }else{
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer5[i]
                        }
                    }
                }else{
                    self.view_ChooseValue.isHidden = false
                    self.answerTableViewContainer.isHidden = false
                    for i in 0..<answer5.count{
                        if i == 0{
                            self.lblChooseAnswer.text = answer5[i]
                            self.lblMAxChooseAnswer.text = answer5[i]
                        }else{
                            self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + answer5[i]
                            self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + answer5[i]
                        }
                    }
                }
            }
            self.txtFieldMain.becomeFirstResponder()
        }else if self.questionNumber == 6 {
            for indexObj in self.chooseStrain.ans_Survey_flavors!
            {
                if let effect = indexObj.effect{
                    self.arraySuggestion.append(effect)
                }
                if let effect = indexObj.effect{
                    if !self.arrayTbleView.contains(effect){
                        self.arrayTbleView.append(effect)
                    }
                }

            }
            self.lblQuestion.text = self.question6
        }
        
        self.txtFieldMain.text = ""
        self.tbleViewMain.reloadData()
        self.view_First.isHidden = true
        self.view_FirstCross.isHidden = true
        self.view_Empty.isHidden = false
        
        
        if questionNumber == 4 {
            self.view_Question4.isHidden = false
            self.viewFlavor.isHidden = true
//            self.btnNo_Question4.setTitleColor(ConstantsColor.kBudzUnselectColor, for: .normal)
//            self.btnYes_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
        }else if questionNumber == 6 {
            self.viewFlavor.isHidden = false
             self.view_Question4.isHidden = true
        }
        self.tbleViewMain.reloadData()
    }

    @IBAction func HideAction(sender : UIButton){
        print( sender.title(for: .normal) ?? "")
       answer1.removeAll()
         answer1New.removeAll()
         answer2New.removeAll()
         answer3New.removeAll()
         answer5New.removeAll()
         answer2.removeAll()
         answer3.removeAll()
         answer4.removeAll()
         answer5.removeAll()
         answer6.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideSurvey"), object: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewAnswers{
            switch questionNumber{
            case 1:
                return answer1New.count
            case 2:
                return answer2New.count
            case 3:
                return answer3New.count
            case 5:
                return answer5New.count
            default:
                return 0
            }
        }
        if tableView.tag == 100 {
            self.arrayTbleView = self.arrayTbleView.removingDuplicates()
            return self.arrayTbleView.count
        }else {
            if self.arrayTbleView.count > 0 {
                self.arrayTbleView = self.arrayTbleView.removingDuplicates()
                return self.arrayTbleView.count
            }else {
                if self.txtFieldMain.text!.count > 0 {
                    return 1
                }
            }
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView != tableViewAnswers{
        if tableView.tag == 100 {
            let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            
            if self.arrayTbleView.count > indexPath.row {
                
                if self.answer6.contains(self.arrayTbleView[indexPath.row]) {
                    cellAddImage.tickImage.image = #imageLiteral(resourceName: "uncheck")
                    cellAddImage.tickView.backgroundColor = UIColor.white
                }else {
                    cellAddImage.tickImage.image = nil
                    cellAddImage.tickView.backgroundColor = UIColor.clear
                }
                cellAddImage.lblName.text = self.arrayTbleView[indexPath.row]
                cellAddImage.lblName.textColor = UIColor.init(hex: "ffffff")
                
            }
            
            cellAddImage.lblName.textAlignment = .left
            cellAddImage.selectionStyle = .none
            
            
            return cellAddImage
        }else {
            if self.arrayTbleView.count > 0 {
                let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
                
                if self.arrayTbleView.count > indexPath.row {
                    cellAddImage.lblName.text = self.arrayTbleView[indexPath.row]
                }
                
                cellAddImage.lblName.textAlignment = .left
                cellAddImage.selectionStyle = .none
                return cellAddImage
            }else {
                
                if indexPath.row == 0 {
                    let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
                    
                    cellAddImage.lblName.text = "No Condition Found"
                    cellAddImage.lblName.textAlignment = .center
                    cellAddImage.selectionStyle = .none
                    return cellAddImage
                }else {
                    let cellAddImage = tableView.dequeueReusableCell(withIdentifier: "SuggestAnAddition") as! SuggestAnAddition
                    
                    cellAddImage.btn_Suggestion.addTarget(self, action: #selector(addNewSuggestion), for: .touchUpInside)
                    cellAddImage.selectionStyle = .none
                    return cellAddImage
                }
            }
        }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpertiesTableViewCell", for: indexPath) as! AddExpertiesTableViewCell
            switch questionNumber{
            case 1:
                cell.lblName.text = answer1New[indexPath.row].value
                cell.warnPopUP.isHidden = true
                if answer1New[indexPath.row].isSuggestion{
                    cell.warnView.isHidden = false
                }else{
                    cell.warnView.isHidden = true
                }
            case 2:
                cell.lblName.text = answer2New[indexPath.row].value
                cell.warnPopUP.isHidden = true
                if answer2New[indexPath.row].isSuggestion{
                    cell.warnView.isHidden = false
                }else{
                    cell.warnView.isHidden = true
                }
            case 3:
                cell.lblName.text = answer3New[indexPath.row].value
                cell.warnPopUP.isHidden = true
                if answer3New[indexPath.row].isSuggestion{
                    cell.warnView.isHidden = false
                }else{
                    cell.warnView.isHidden = true
                }
            case 5:
                cell.lblName.text = answer5New[indexPath.row].value
                cell.warnPopUP.isHidden = true
                if answer5New[indexPath.row].isSuggestion{
                    cell.warnView.isHidden = false
                }else{
                    cell.warnView.isHidden = true
                }
            default:
                cell.lblName.text = answer1New[indexPath.row].value
                if answer1New[indexPath.row].isSuggestion{
                    cell.warnView.isHidden = false
                }else{
                    cell.warnView.isHidden = true
                }
            }
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self, action: #selector(self.removeValue), for: .touchUpInside)
            cell.warnButton.tag = indexPath.row
            cell.warnButton.addTarget(self, action: #selector(self.warnPopUp), for: .touchUpInside)
            return cell
        }
    }
    
    @IBAction func warnPopUp(sender: UIButton!){
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableViewAnswers.cellForRow(at: indexPath) as! AddExpertiesTableViewCell
        if cell.warnPopUP.isHidden{
            cell.warnPopUP.isHidden = false
        }else{
            cell.warnPopUP.isHidden = true
        }
    }
    @IBAction func removeValue(sender: UIButton!){
        switch questionNumber {
        case 1:
            if !answer1New[sender.tag].isSuggestion{
                let obj = StrainSurveyAnswers()
                obj.effect = answer1New[sender.tag].value
                self.chooseStrain.ans_Madical_conditions?.append(obj)
            }
             answer1New.remove(at: sender.tag)
        case 2:
            if !answer2New[sender.tag].isSuggestion{
                let obj = StrainSurveyAnswers()
                obj.effect = answer2New[sender.tag].value
                self.chooseStrain.ans_Sensations?.append(obj)
            }
            answer2New.remove(at: sender.tag)
        case 3:
            if !answer3New[sender.tag].isSuggestion{
                let obj = StrainSurveyAnswers()
                obj.effect = answer3New[sender.tag].value
                self.chooseStrain.ans_Negative_effects?.append(obj)
            }
              answer3New.remove(at: sender.tag)
           
        case 5:
            if !answer5New[sender.tag].isSuggestion{
                let obj = StrainSurveyAnswers()
                obj.effect = answer5New[sender.tag].value
                self.chooseStrain.ans_Preventions?.append(obj)
            }
              answer5New.remove(at: sender.tag)
            
        default:
            print("default")
        }
        
        self.GotoQuestion()
    }
    
    func addNewSuggestion(sender : UIButton){
        self.txtFieldMain.endEditing(true)
        var UrlMain = ""
        var newPAram = [String : AnyObject]()
        tableViewHeight.constant = 0
        self.answerTableViewContainer.isHidden = false
        if self.lblChooseAnswer.text!.characters.count > 0 {
            if self.first != self.txtFieldMain.text! {
                if self.second.count > 0 {
                    if self.second != self.txtFieldMain.text! {
                        self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + self.txtFieldMain.text!
                        self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + self.txtFieldMain.text!
                        self.suggestionCount = self.suggestionCount + 1
                    }else{
                        self.ShowErrorAlert(message: "Already added!")
                        return
                    }
                }else {
                    self.second = self.txtFieldMain.text!
                    self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + self.txtFieldMain.text!
                    self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" + self.txtFieldMain.text!
                    self.suggestionCount = self.suggestionCount + 1
                }
//            if !(self.lblChooseAnswer.text?.contains(self.txtFieldMain.text!))!{
             
//                }
            }else{
                self.ShowErrorAlert(message: "Already added!")
                return
            }
        }else {
            self.first = self.txtFieldMain.text!
            self.lblChooseAnswer.text = self.txtFieldMain.text!
            self.lblMAxChooseAnswer.text = self.txtFieldMain.text!
            self.suggestionCount = self.suggestionCount + 1
        }
        if questionNumber == 1{
            UrlMain = WebServiceName.suggest_medical_condition.rawValue
            newPAram["medical_condition"] = self.txtFieldMain.text! as AnyObject
            
        }else if questionNumber == 2{
            UrlMain = WebServiceName.suggest_sensation.rawValue
            newPAram["sensation"] = self.txtFieldMain.text! as AnyObject
            
            
        }else if questionNumber == 3{
            UrlMain = WebServiceName.suggest_negative_effect.rawValue
            newPAram["negative_effect"] = self.txtFieldMain.text! as AnyObject
            
        }else if questionNumber == 5{
            UrlMain = WebServiceName.suggest_disease_prevention.rawValue
            newPAram["prevention"] = self.txtFieldMain.text! as AnyObject
            
            
        }
        self.showLoading()
        print(newPAram)
        NetworkManager.PostCall(UrlAPI: UrlMain, params: newPAram) { (success, message, mainData) in
            print(mainData)
             self.hideLoading()
            if success {
                if self.questionNumber == 1{
                    
                    self.answer1.append(self.txtFieldMain.text!)
                    let obj = SurveyAnswers()
                    obj.value = self.txtFieldMain.text!
                    obj.isSuggestion = true
                    self.answer1New.append(obj)
//                    self.tableviewAnswersHeight.constant = 60
                    self.tableViewAnswers.reloadData()
                }else if self.questionNumber == 2{
                 
                    self.answer2.append(self.txtFieldMain.text!)
                    let obj = SurveyAnswers()
                    obj.value = self.txtFieldMain.text!
                    obj.isSuggestion = true
                    self.answer2New.append(obj)
//                    self.tableviewAnswersHeight.constant = 60
                    self.tableViewAnswers.reloadData()
                }else if self.questionNumber == 3{
                 
                    self.answer3.append(self.txtFieldMain.text!)
                    let obj = SurveyAnswers()
                    obj.value = self.txtFieldMain.text!
                    obj.isSuggestion = true
                    self.answer3New.append(obj)
//                    self.tableviewAnswersHeight.constant = 60
                    self.tableViewAnswers.reloadData()
                }else if self.questionNumber == 5{
                   
                    self.answer5.append(self.txtFieldMain.text!)
                    let obj = SurveyAnswers()
                    obj.value = self.txtFieldMain.text!
                    obj.isSuggestion = true
                    self.answer5New.append(obj)
//                    self.tableviewAnswersHeight.constant = 60
                    self.tableViewAnswers.reloadData()
                }
                if (mainData["status"] as! String) == "success" {
                    
            self.view_ChooseValue.isHidden = false
            if self.suggestionCount == 1{
             self.viewChooseWarningAlignment1.constant = 0
             self.viewChooseWarning.isHidden = false
             self.viewMaxChooseWarning.isHidden = true
            }else if self.suggestionCount == 2{
                self.viewChooseWarningAlignment1.constant = -10
                self.viewChooseWarningAlignment2.constant = 5
                self.viewChooseWarning.isHidden = false
                self.viewMaxChooseWarning.isHidden = true
                self.viewChooseWarning2.isHidden = false
                self.viewMaxChooseWarning2.isHidden = true
            }
            if self.skip == -1{
                self.viewChooseWarningAlignment2.constant = 10
                self.viewChooseWarning.isHidden = true
                self.viewMaxChooseWarning.isHidden = true
                self.viewMaxChooseWarning2.isHidden = true
                self.viewChooseWarning2.isHidden = false
                self.viewChooseWarning3.isHidden = true
                self.viewMaxChooseWarning3.isHidden = true
                
            }
            if self.questionNumber == 1{
                if self.answer1New.count == 3 {
                    self.view_ChooseValue.isHidden = true
                    self.view_MaxValue.isHidden = false
                    if self.suggestionCount == 1{
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        if self.skip == 2{
                            self.viewMaxChooseWarningAlignment3.constant = 16
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }

                    }else if self.suggestionCount == 2{
                        self.viewMaxChooseWarningAlignment1.constant = -10
                        self.viewMaxChooseWarningAlignment2.constant = 5
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        if self.skip == 1{
                            self.viewMaxChooseWarningAlignment1.constant = -12
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                        if self.skip == -1{
                            self.viewMaxChooseWarningAlignment2.constant = 0
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                   
                    }else if self.suggestionCount == 3{
                        self.viewMaxChooseWarningAlignment1.constant = -12
                        self.viewMaxChooseWarningAlignment2.constant = 0
                        self.viewMaxChooseWarningAlignment3.constant = 12
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        self.viewChooseWarning3.isHidden = true
                        self.viewMaxChooseWarning3.isHidden = false
                    }
                    //                        self.roundViewWithGrayHeight.constant = 0
                    //                        self.orViewHeight.constant = 0
                }
            }else if self.questionNumber == 2{
                if self.answer2New.count == 3 {
                    self.view_ChooseValue.isHidden = true
                    self.view_MaxValue.isHidden = false
                    if self.suggestionCount == 1{
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        if self.skip == 2{
                            self.viewMaxChooseWarningAlignment3.constant = 16
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }

                    }else if self.suggestionCount == 2{
                        self.viewMaxChooseWarningAlignment1.constant = -10
                        self.viewMaxChooseWarningAlignment2.constant = 5
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        if self.skip == 1{
                            self.viewMaxChooseWarningAlignment1.constant = -12
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                        }
                        if self.skip == -1{
                            self.viewMaxChooseWarningAlignment2.constant = 0
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                       
                    }else if self.suggestionCount == 3{
                        self.viewMaxChooseWarningAlignment1.constant = -12
                        self.viewMaxChooseWarningAlignment2.constant = 0
                        self.viewMaxChooseWarningAlignment3.constant = 12
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        self.viewChooseWarning3.isHidden = true
                        self.viewMaxChooseWarning3.isHidden = false
                    }
                }
            }else if self.questionNumber == 3{
                if self.answer3New.count == 3 {
                    self.view_ChooseValue.isHidden = true
                    self.view_MaxValue.isHidden = false
                    if self.suggestionCount == 1{
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        if self.skip == 2{
                            self.viewMaxChooseWarningAlignment3.constant = 16
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }

                    }else if self.suggestionCount == 2{
                        self.viewMaxChooseWarningAlignment1.constant = -10
                        self.viewMaxChooseWarningAlignment2.constant = 5
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        if self.skip == 1{
                            self.viewMaxChooseWarningAlignment1.constant = -12
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                        }
                        if self.skip == -1{
                            self.viewMaxChooseWarningAlignment2.constant = 0
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                    }else if self.suggestionCount == 3{
                        self.viewMaxChooseWarningAlignment1.constant = -12
                        self.viewMaxChooseWarningAlignment2.constant = 0
                        self.viewMaxChooseWarningAlignment3.constant = 12
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        self.viewChooseWarning3.isHidden = true
                        self.viewMaxChooseWarning3.isHidden = false
                    }
                }
            }else if self.questionNumber == 5{
                if self.answer5New.count == 3 {
                    self.view_ChooseValue.isHidden = true
                    self.view_MaxValue.isHidden = false
                    if self.suggestionCount == 1{
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        if self.skip == 2{
                            self.viewMaxChooseWarningAlignment3.constant = 16
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                    }else if self.suggestionCount == 2{
                        self.viewMaxChooseWarningAlignment1.constant = -10
                        self.viewMaxChooseWarningAlignment2.constant = 5
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        if self.skip == 1{
                            self.viewMaxChooseWarningAlignment1.constant = -12
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewChooseWarning2.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                        }
                        if self.skip == -1{
                            self.viewMaxChooseWarningAlignment2.constant = 0
                            self.viewMaxChooseWarningAlignment3.constant = 12
                            self.viewChooseWarning.isHidden = true
                            self.viewMaxChooseWarning.isHidden = true
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewChooseWarning2.isHidden = true
                            self.viewChooseWarning3.isHidden = true
                            self.viewMaxChooseWarning3.isHidden = false
                            
                        }
                       
                    }else if self.suggestionCount == 3{
                        self.viewMaxChooseWarningAlignment1.constant = -12
                        self.viewMaxChooseWarningAlignment2.constant = 0
                        self.viewMaxChooseWarningAlignment3.constant = 12
                        self.viewChooseWarning.isHidden = true
                        self.viewMaxChooseWarning.isHidden = false
                        self.viewChooseWarning2.isHidden = true
                        self.viewMaxChooseWarning2.isHidden = false
                        self.viewChooseWarning3.isHidden = true
                        self.viewMaxChooseWarning3.isHidden = false
                    }
                }
            }
           
            
          
                }else {
                  
                    self.suggestionCount = self.suggestionCount - 1
                    if (mainData["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                    }
                }
            }else {
                if (self.lblChooseAnswer.text?.contains("\n"))!{
                    self.lblChooseAnswer.text = self.lblChooseAnswer.text?.replacingOccurrences(of: "\n"+self.txtFieldMain.text!, with: "")
                    self.lblMAxChooseAnswer.text = self.lblChooseAnswer.text?.replacingOccurrences(of: "\n"+self.txtFieldMain.text!, with: "")
                }else{
                    self.lblChooseAnswer.text = self.lblChooseAnswer.text?.replacingOccurrences(of: self.txtFieldMain.text!, with: "")
                    self.lblMAxChooseAnswer.text = self.lblChooseAnswer.text?.replacingOccurrences(of: self.txtFieldMain.text!, with: "")
                }
                if self.first == self.txtFieldMain.text{
                    self.first = ""
                }else if self.second == self.txtFieldMain.text{
                    self.second = ""
                }
                if self.skip == -1{
                    self.skip = 0
                }else if self.skip == 1{
                    self.skip = -1
                }
                self.suggestionCount = self.suggestionCount - 1
                self.ShowErrorAlert(message:message)
                self.answerTableViewContainer.isHidden = true
            }
        }
    }
    @IBAction func chooseWarningPopup(sender: UIButton!){
        self.viewChooseWarningPopUp.isHidden = !self.viewChooseWarningPopUp.isHidden
    }
    @IBAction func chooseMaxWarningPopup(sender: UIButton!){
        self.viewMaxChooseWarningPopup.isHidden = !self.viewMaxChooseWarningPopup.isHidden
    }
    @IBAction func chooseWarningPopup2(sender: UIButton!){
        self.viewChooseWarningPopUp2.isHidden = !self.viewChooseWarningPopUp2.isHidden
    }
    @IBAction func chooseMaxWarningPopup2(sender: UIButton!){
        self.viewMaxChooseWarningPopup2.isHidden = !self.viewMaxChooseWarningPopup2.isHidden
    }
    @IBAction func chooseWarningPopup3(sender: UIButton!){
        self.viewChooseWarningPopUp3.isHidden = !self.viewChooseWarningPopUp3.isHidden
    }
    @IBAction func chooseMaxWarningPopup3(sender: UIButton!){
        self.viewMaxChooseWarningPopup3.isHidden = !self.viewMaxChooseWarningPopup3.isHidden
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         tableViewHeight.constant = 0
         tableView.layoutIfNeeded()
        
        if tableView.tag == 100 {
            
            if self.answer6.contains(self.arrayTbleView[indexPath.row]) {
                self.answer6.remove(at:self.answer6.index(of: self.arrayTbleView[indexPath.row])!)
            }else {
                self.answer6.append(self.arrayTbleView[indexPath.row])
                
            }
            
            if !(self.answer6.count > 3) {
                self.lblchooseFlavor.text =  ""
            for index in self.answer6 {
                if self.lblchooseFlavor.text!.count > 0 {
                    self.lblchooseFlavor.text = self.lblchooseFlavor.text! + "\n" + index
                }else {
                    self.lblchooseFlavor.text = index
                }
            }
            }
            self.lblchooseFlavor.textColor = UIColor.white
            self.tbleViewFlavor.reloadData()
            if self.answer6.count >= 3 {
                self.addd_flavor_btn.text = "edit flavour"
            }else{
                self.addd_flavor_btn.text = "add flavour"
            }
            if self.answer6.count > 3 {
                self.ShowErrorAlert(message: "You can't select more than 3 flavour!")
                self.answer6.remove(at: self.answer6.count - 1)
            }
        }else {
            if self.arrayTbleView.count > 0 {
                self.view_ChooseValue.isHidden = false
                self.answerTableViewContainer.isHidden = false
                if self.lblChooseAnswer.text!.characters.count > 0 {
                    self.lblChooseAnswer.text = self.lblChooseAnswer.text! + "\n" + self.arrayTbleView[indexPath.row]
                    self.lblMAxChooseAnswer.text = self.lblMAxChooseAnswer.text! + "\n" +
                        self.arrayTbleView[indexPath.row]
                }else {
                    self.lblChooseAnswer.text = self.arrayTbleView[indexPath.row]
                    self.lblMAxChooseAnswer.text = self.arrayTbleView[indexPath.row]
                }
                
                if questionNumber == 1 {
                    self.answer1.append(self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces))
                    let obj = SurveyAnswers()
                    obj.value = self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces)
                    obj.isSuggestion = false
                    self.answer1New.append(obj)
                    self.chooseStrain.ans_Madical_conditions?.remove(at: indexPath.row)
//                    self.tableviewAnswersHeight.constant = 100
                    self.tableViewAnswers.reloadData()
                    if self.suggestionCount == 0{
                        self.skip = -1
                    }
                    if self.suggestionCount == 0 && self.answer1.count == 2{
                        self.skip = 2
                    }
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.answer1New.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        self.answerTableViewContainer.isHidden = false
                        if self.suggestionCount == 0{
                            self.skip = -1
                        }
                        if self.suggestionCount == 1{
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
//                        self.roundViewWithGrayHeight.constant = 0
//                        self.orViewHeight.constant = 0
                    }
                }else  if questionNumber == 2 {
                    self.answer2.append(self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces))
                    let obj = SurveyAnswers()
                    obj.value = self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces)
                    obj.isSuggestion = false
                    self.answer2New.append(obj)
                    self.chooseStrain.ans_Sensations?.remove(at: indexPath.row)
//                    self.tableviewAnswersHeight.constant = 100
                    self.tableViewAnswers.reloadData()

                    if self.suggestionCount == 0{
                        self.skip = -1
                    }
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.suggestionCount == 0 && self.answer2.count == 2{
                        self.skip = 2
                    }
                    if self.answer2New.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        self.answerTableViewContainer.isHidden = false
                        if self.suggestionCount == 0{
                            self.skip = -1
                        }
                        if self.suggestionCount == 1{
                           self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
                    }
                }else  if questionNumber == 3 {
                    self.answer3.append(self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces))
                    let obj = SurveyAnswers()
                    obj.value = self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces)
                    obj.isSuggestion = false
                    self.answer3New.append(obj)
                    self.chooseStrain.ans_Negative_effects?.remove(at: indexPath.row)
//                    self.tableviewAnswersHeight.constant = 100
                    self.tableViewAnswers.reloadData()

                    if self.suggestionCount == 0{
                        self.skip = -1
                    }
                    if self.suggestionCount == 0 && self.answer3.count == 2{
                        self.skip = 2
                    }
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.answer3New.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        self.answerTableViewContainer.isHidden = false
                        if self.suggestionCount == 1{
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
                    }
                }else  if questionNumber == 4 {
                    self.answer4.append(self.arrayTbleView[indexPath.row])
                    if self.suggestionCount == 0{
                        self.skip = -1
                    }
                    
                    if self.suggestionCount == 0 && self.answer4.count == 2{
                        self.skip = 2
                    }
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.answer4.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        if self.suggestionCount == 1{
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
                    }
                }else  if questionNumber == 5 {
                    self.answer5.append(self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces))
                    let obj = SurveyAnswers()
                    obj.value = self.arrayTbleView[indexPath.row].trimmingCharacters(in: .whitespaces)
                    obj.isSuggestion = false
                    self.answer5New.append(obj)
                    self.chooseStrain.ans_Preventions?.remove(at: indexPath.row)
//                    self.tableviewAnswersHeight.constant = 100
                    self.tableViewAnswers.reloadData()

                    if self.suggestionCount == 0{
                        self.skip = -1
                    }
                    if self.suggestionCount == 0 && self.answer5.count == 2{
                        self.skip = 2
                    }
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.answer5New.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        self.answerTableViewContainer.isHidden = false
                        if self.suggestionCount == 1{
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
                    }
                }else  if questionNumber == 6 {
                    self.answer6.append(self.arrayTbleView[indexPath.row])
                    if self.suggestionCount == 1{
                        self.viewChooseWarningAlignment1.constant = -12
                        self.skip = 1
                    }
                    if self.answer6.count == 3 {
                        self.view_ChooseValue.isHidden = true
                        self.view_MaxValue.isHidden = false
                        if self.suggestionCount == 1{
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -12
                        }else if self.suggestionCount == 2{
                            self.viewMaxChooseWarning2.isHidden = false
                            self.viewMaxChooseWarning.isHidden = false
                            self.viewMaxChooseWarningAlignment1.constant = -10
                            self.viewMaxChooseWarningAlignment2.constant = 5
                        }
                    }
                }
                
                print(self.arraySuggestion)
                let index = self.arraySuggestion.index(of: self.arrayTbleView[indexPath.row])
                self.arraySuggestion.remove(at: index!)
                self.txtFieldMain.resignFirstResponder()
            }
        }
    }
    
    
    @IBAction func ShowFlavour(sender : UIButton){
        self.viewFlavor_TbleView.isHidden = false
        for i in 0..<(self.chooseStrain.ans_Survey_flavors?.count)!{
            arrayTbleView.append(self.chooseStrain.ans_Survey_flavors![i].effect!)
        }
        self.tbleViewFlavor.reloadData()
        
    }
    
    @IBAction func HideFlavour(sender : UIButton){
        self.viewFlavor_TbleView.isHidden = true
    }
    
    @IBAction func AddMore(sender : UIButton){
        self.view_ChooseValue.isHidden = true
        self.viewMaxChooseWarningPopup.isHidden = true
        self.viewChooseWarningPopUp.isHidden = true
        self.answerTableViewContainer.isHidden = true
        self.tableViewHeight.constant = 0
        self.arrayTbleView.removeAll()
        self.txtFieldMain.text = ""
        self.tbleViewMain.reloadData()
        self.txtFieldMain.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag != 1000{
        if self.txtFieldMain.text == ""{
            tableViewHeight.constant = 0
        }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1000{
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                for i in 0..<(self.chooseStrain.ans_Survey_flavors?.count)!{
                    arrayTbleView.append(self.chooseStrain.ans_Survey_flavors![i].effect!)
                }
                if textField.text!.dropLast() != ""{
                arrayTbleView = arrayTbleView.filter({$0.localizedCaseInsensitiveContains(textField.text!.dropLast())})
                    
                }
                if arrayTbleView.count == 0{
                    noItemFound.isHidden = false
                    tbleViewFlavor.isHidden = true
                }else{
                    noItemFound.isHidden = true
                    tbleViewFlavor.isHidden = false
                }
                tbleViewFlavor.reloadData()
                return true
            }
            arrayTbleView = arrayTbleView.filter({$0.localizedCaseInsensitiveContains((textField.text)! + string)})
            if arrayTbleView.count == 0{
                noItemFound.isHidden = false
                tbleViewFlavor.isHidden = true
            }else{
                noItemFound.isHidden = true
                tbleViewFlavor.isHidden = false
            }
            tbleViewFlavor.reloadData()
            return true
        }else{
        if tableViewHeight.constant == 0{
            tableViewHeight.constant = 100
        }
        var newString = ""

        if string.count > 0 {
            newString = self.txtFieldMain.text! + string
        }else {
            let stringText = self.txtFieldMain.text!
            newString = stringText.substring(to: stringText.index(before: stringText.endIndex))
        }
        
        
        newString = newString.lowercased()
        let matchingTerms = self.arraySuggestion.filter { item in
            return item.lowercased().contains(newString.lowercased())
        }
        self.arrayTbleView = matchingTerms
        
        switch questionNumber {
        case 1:
            for obj in self.answer1New {
                if self.arrayTbleView.contains(obj.value){
                    self.arrayTbleView.remove(at: self.arrayTbleView.index(of: obj.value)!)
                }
            }
            break
        case 2:
            for obj in self.answer2New {
                if self.arrayTbleView.contains(obj.value){
                    self.arrayTbleView.remove(at: self.arrayTbleView.index(of: obj.value)!)
                }
            }
            break
        case 3:
            for obj in self.answer3New {
                if self.arrayTbleView.contains(obj.value){
                    self.arrayTbleView.remove(at: self.arrayTbleView.index(of: obj.value)!)
                }
            }
            break
        case 5:
            for obj in self.answer5New {
                if self.arrayTbleView.contains(obj.value){
                    self.arrayTbleView.remove(at: self.arrayTbleView.index(of: obj.value)!)
                }
            }
            break
        default:
            break
        }
        for obj in self.answer1New {
            if self.arrayTbleView.contains(obj.value){
                 self.arrayTbleView.remove(at: self.arrayTbleView.index(of: obj.value)!)
            }
        }
        self.arrayTbleView = self.arrayTbleView.removingDuplicates()
        print(self.arrayTbleView)
        self.tbleViewMain.reloadData()
        return true
        }
    }
    
    @IBAction func Yes_ACtion(sender : UIButton){
        self.valueforYEs = "YES"
        self.isNoSelect = 0
        self.btnNo_Question4.setTitleColor(ConstantsColor.kBudzUnselectColor, for: .normal)
        self.btnYes_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
    }
    
    @IBAction func No_ACtion(sender : UIButton){
        self.valueforYEs = "NO"
        self.isNoSelect = 1
        self.btnNo_Question4.setTitleColor(ConstantsColor.kStrainGreenColor, for: .normal)
        self.btnYes_Question4.setTitleColor(ConstantsColor.kBudzUnselectColor, for: .normal)
    }
    var isNoSelect:Int = 0
    
}


class TextCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var tickImage: UIImageView!
    @IBOutlet var tickView: UIView!
}

class SuggestAnAddition : UITableViewCell {
    @IBOutlet var btn_Suggestion : UIButton!
}
