//
//  BudzPaymentPopVC.swift
//  BaseProject
//
//  Created by lucky on 11/27/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
protocol PaymentDelegate: class {
    func close ()
    func done (obj:PayBudzModel)
}
class BudzPaymentPopVC: BaseViewController {

    
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCard: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfCVC: UITextField!
    var cardModel:PayBudzModel?
    var txtPayText:String?
    weak var delegade:PaymentDelegate?
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegade?.close()
        }
    }
    
    
    @IBAction func donePay(_ sender: Any) {
        if (isValid ()) {
            self.dismiss(animated: true) {
                var obj = PayBudzModel(em: self.tfEmail.text!,cardNum: self.tfCard.text!,dateCard: self.tfDate.text!,cvcCard: self.tfCVC.text!)
                self.delegade?.done(obj: obj)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if (cardModel != nil){
            self.tfEmail.text = cardModel?.email
            self.tfCard.text = cardModel?.card
            self.tfDate.text = cardModel?.date
            self.tfCVC.text = cardModel?.cvc
        }
        
        self.lblPay.text = txtPayText ?? "PAY 99.99$"
        
    }
    func isValidEmail(txt:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txt)
    }
    func isValid () -> Bool {
        if (tfEmail.text?.trimmingCharacters(in: .whitespaces).count == 0){
            self.ShowErrorAlert(message: "Email Required!")
            return false
        }
        if !(isValidEmail(txt: tfEmail.text!.trimmingCharacters(in: .whitespaces))) {
            self.ShowErrorAlert(message: "Email is not valid!")
            return false
        }
        if (tfCard.text?.trimmingCharacters(in: .whitespaces).count == 0){
            self.ShowErrorAlert(message: "Card Number Required!")
            return false
        }
        if (tfDate.text?.trimmingCharacters(in: .whitespaces).count == 0){
            self.ShowErrorAlert(message: "Date Required!")
            return false
        }
        if (self.GetDateValidBudz(date: (tfDate.text?.trimmingCharacters(in: .whitespaces))!) == "Wrong Date"){
            self.ShowErrorAlert(message: "Expiry Date is not valid!")
            return false
        }
        if (tfCVC.text?.trimmingCharacters(in: .whitespaces).count == 0){
            self.ShowErrorAlert(message: "CVC Required!")
            return false
        }
        
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        // Do any additional setup after loading the view.
    }
    func setupDelegate() {
        self.tfEmail.delegate = self
        self.tfCard.delegate = self
        self.tfCVC.delegate = self
        self.tfDate.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.tfCVC {
            let textTemp = (textField.text?.count)! + string.count
            if textTemp > 3 {
                return false
            }
        }else if textField == self.tfCard {
            let textTemp = (textField.text?.count)! + string.count
            if textTemp > 16 {
                return false
            }
        }
        else if textField == self.tfDate{
            guard let text = textField.text else {
                return true
            }
            let newLength = text.count + string.count - range.length
            if string.count > 0 {
                if newLength == 3 {
                    textField.text = textField.text! + "/"
                }
            }else {
                if newLength == 3  && string == ""{
                    textField.text = textField.text!.replacingOccurrences(of: "/", with: "")
                }
            }
            return newLength <= 5
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
