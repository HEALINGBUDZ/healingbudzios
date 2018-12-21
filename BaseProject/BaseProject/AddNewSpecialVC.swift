//
//  AddNewSpecialVC.swift
//  BaseProject
//

//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import AAPickerView

class AddNewSpecialVC: BaseViewController , UITextViewDelegate  {
    let constantCountString = "/140 characters"
    @IBOutlet weak var chartacterss: UILabel!
    @IBOutlet weak var date_picker: AAPickerView!
    @IBOutlet weak var TV_Discription: UITextView!
    var budz_specials:Specials?
    @IBOutlet weak var TF_Title: UITextField!
    var delegate:refreshDataDelgate?
    var budz_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TV_Discription.delegate = self
        self.TV_Discription.text = "Description.."
        self.date_picker.pickerType = .DatePicker
        self.date_picker.datePicker?.datePickerMode = .date
        self.date_picker.datePicker?.minimumDate = Date()
        self.date_picker.delegate = self
        self.date_picker.dateDidChange = { date in
            print("selectedDate ", date )
        }
        setData()
        
    }
    func setData(){
        if(self.budz_specials != nil){
            self.TV_Discription.text = self.budz_specials?.discription
            self.TF_Title.text = self.budz_specials?.title
            self.date_picker.text = self.budz_specials?.date.UTCToLocal(inputFormate: "yyyy-MM-dd", outputFormate: "MM/dd/yyyy")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSelectDate(_ sender: Any) {
        self.date_picker.becomeFirstResponder()
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if (self.TF_Title.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
           self.ShowErrorAlert(message: "Please add title!")
            return
        }
        
        if self.TV_Discription.text?.lowercased() == "Description..".lowercased() || self.TV_Discription.text!.isEmpty {
            self.ShowErrorAlert(message: "Please add description!")
            return
        }
        
        if self.date_picker.text?.lowercased() == "valid until...".lowercased() {
            self.ShowErrorAlert(message: "Please add date!")
            return
        }
        
        var newParam = [String : AnyObject]()
        var valiDate = self.date_picker.text
        valiDate = valiDate?.UTCToLocal(inputFormate: "MM/dd/yyyy", outputFormate: "yyyy-MM-dd")
        newParam["date"] = valiDate as AnyObject
        newParam["description"] = self.TV_Discription.text.trimmingCharacters(in: .whitespaces) as AnyObject
        newParam["title"]  = self.TF_Title.text?.trimmingCharacters(in: .whitespaces) as AnyObject
        newParam["budz_id"]  = self.budz_id as AnyObject
        if(self.budz_specials != nil){
            newParam["id"]  = self.budz_specials?.id as AnyObject
        }
        print(newParam)
         self.showLoading()
        NetworkManager.PostCall(UrlAPI:"add_budz_special", params: newParam, completion: { (successResponse, messageResponse, mainResponse) in
            self.hideLoading()
            if successResponse {
                if (mainResponse["status"] as! String) == "success" {
                    self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String, complition: { (isConfirm, btn) in
                        if self.delegate != nil {
                           self.delegate?.refreshData()
                            self.dismiss(animated: true, completion: nil)
                        }
                       
                        
                    })
                }else {
                    if (mainResponse["errorMessage"] as! String) == "Session Expired" {
                        DataManager.sharedInstance.logoutUser()
                        self.ShowLogoutAlert()
                        
                    }
                }
            }else {
                self.ShowErrorAlert(message:messageResponse)
            }
        })
        
        
    }
    
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description.." {
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.text = "Valid until..."
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description.."
            textView.textColor = UIColor.init(hex: "C3C3C3")
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if self.TV_Discription.text.count > 139 && text.count > 0 {
            return false
        }
        
        if text.count > 0 {
            self.chartacterss.text = String(self.TV_Discription.text.count + 1) + constantCountString
            
        }else if self.TV_Discription.text.count < 2 {
            self.chartacterss.text = "0" + constantCountString
        }else {
            self.chartacterss.text = String(self.TV_Discription.text.count - 1) + constantCountString
        }
        return true
    }
}
