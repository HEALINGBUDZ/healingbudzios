//
//  PopViewForEditVC.swift
//  BaseProject
//
//  Created by Abc on 9/10/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import  KUIPopOver
import ActiveLabel

class PopViewForEditVC: BaseViewController , KUIPopOverUsable{
    var userObjectEditInfo: UserStrain?
    @IBOutlet weak var lb_climateLevel: UILabel!
    @IBOutlet weak var lb_yieldLevel: UILabel!
    @IBOutlet weak var lb_notes: UILabel!
    @IBOutlet weak var lb_scaleUp: UILabel!
    @IBOutlet weak var lb_timeDays: UILabel!
    @IBOutlet weak var lb_cbdFrom: UILabel!
    @IBOutlet weak var lb_typeStrainEdit: UILabel!
    @IBOutlet weak var lb_hideView: UIView!
    @IBOutlet weak var Btn_Type: UIButton!
    @IBOutlet weak var lb_description: ActiveLabel!
    @IBOutlet weak var lb_bgColorView: UIView!
    @IBOutlet weak var lb_endPercent: UILabel!
    @IBOutlet weak var lb_startPercent: UILabel!
    @IBOutlet weak var gradParent: UIView!
    @IBOutlet weak var lb_mainHeightCnstant: NSLayoutConstraint!
    @IBOutlet weak var Btn_Bottom_Left: UIButton!
    @IBOutlet weak var lb_cbdTo: UILabel!
    @IBOutlet weak var lb_tchTo: UILabel!
    @IBOutlet weak var lb_tchFrom: UILabel!
    @IBOutlet weak var Btn_Bottom_Right: UIButton!
    @IBOutlet weak var lb_hardnessDiffrence: UILabel!
    @IBOutlet weak var lb_scaleBottom: UILabel!
    @IBOutlet weak var lb_hideConstantCrossStrain: NSLayoutConstraint!//101.5
    @IBOutlet weak var lb_dif_image: UIImageView!
    @IBOutlet weak var lb_secondCrossTitle: UILabel!
    @IBOutlet weak var lb_heightInch: UILabel!
    @IBOutlet weak var lb_difficultyLevel: UILabel!
    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var lb_firstCrossTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if userObjectEditInfo?.description!.trimmingCharacters(in: .whitespaces) == ""{
            self.lb_description.applyTag(baseVC: self, mainText: "No description added.")
            self.lb_description.text = "No description added."
        }else{
            self.lb_description.applyTag(baseVC: self, mainText: (userObjectEditInfo?.description)!)
            self.lb_description.text = userObjectEditInfo?.description?.RemoveBRTag()
            self.lb_description.text = self.lb_description.text?.RemoveHTMLTag()
        }
        self.lb_bgColorView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - ((gradParent?.frame.origin.x)! * 2), height: gradParent.frame.size.height)
        gradParent.bringSubview(toFront: self.lb_startPercent)
        gradParent.bringSubview(toFront: self.lb_endPercent)
        lb_bgColorView.backgroundColor = UIColor.blue
        self.createGradientLayer()
        if let percent = userObjectEditInfo?.minCBD?.stringValue {
            if percent.contains(".") {
                self.lb_cbdTo.text = (percent) + "%"
            }else {
                self.lb_cbdTo.text = (percent) + ".0%"
            }
        }else{
            self.lb_cbdTo.text = "0.0%"
        }
        
        if let percent = userObjectEditInfo?.maxCBD?.stringValue {
            if percent.contains(".") {
                self.lb_cbdFrom.text = (percent) + "%"
            }else {
                self.lb_cbdFrom.text = (percent) + ".0%"
            }
        }else{
            self.lb_cbdFrom.text = "0.0%"
        }
        
        if let percent = userObjectEditInfo?.minTHC?.stringValue {
            if percent.contains(".") {
                self.lb_tchTo.text = (percent) + "%"
            }else {
                self.lb_tchTo.text = (percent) + ".0%"
            }
        }else{
            self.lb_tchTo.text = "0.0%"
        }
        
        if let percent = userObjectEditInfo?.maxTHC?.stringValue {
            if percent.contains(".") {
                self.lb_tchFrom.text = (percent) + "%"
            }else {
                self.lb_tchFrom.text = (percent) + ".0%"
            }
        }else{
            self.lb_tchFrom.text = "0.0%"
        }
        if userObjectEditInfo?.indica?.intValue == 100 {
            self.lb_hideConstantCrossStrain.constant = 0
            self.lb_hideView.isHidden = true
            self.lb_typeStrainEdit.text = "Indica"
            self.lb_typeStrainEdit.textColor = UIColor.init(hex: "AE59C2")
        }else if userObjectEditInfo?.indica?.intValue == 0{
            self.lb_hideConstantCrossStrain.constant = 0
            self.lb_hideView.isHidden = true
            self.lb_typeStrainEdit.text = "Sativa"
            self.lb_typeStrainEdit.textColor = UIColor.init(hex: "C24462")
        }else{
            self.lb_typeStrainEdit.text = "Hybrid"
            self.lb_typeStrainEdit.textColor = UIColor.init(hex: "7cc244")
        }
        if userObjectEditInfo?.indica?.intValue == 100 {
            self.ValueChange(senderValue: Float(0))
        } else{
            self.ValueChange(senderValue: Float(100 - (userObjectEditInfo?.indica?.intValue)!))
        }
        if userObjectEditInfo?.note != nil{
            self.lb_notes.text = userObjectEditInfo?.note
        }else{
            self.lb_notes.text = "No notes added."
        }
        
        self.lb_difficultyLevel.text = userObjectEditInfo?.growing?.capitalizingFirstLetter()
        self.lb_heightInch.text = (userObjectEditInfo?.plant_height?.stringValue)! + "\""
        self.lb_timeDays.text = (userObjectEditInfo?.flowering_time?.stringValue)!
        self.lb_scaleUp.text = (userObjectEditInfo?.max_fahren_temp?.stringValue)! + "℉"
        self.lb_scaleBottom.text = (userObjectEditInfo?.min_fahren_temp?.stringValue)! + "℉"
        self.lb_hardnessDiffrence.text = (userObjectEditInfo?.min_celsius_temp?.stringValue)! + "℃ - " + (userObjectEditInfo?.max_celsius_temp?.stringValue)! + "℃"
        self.lb_yieldLevel.text = userObjectEditInfo?.yeild?.capitalizingFirstLetter()
        self.lb_climateLevel.text = userObjectEditInfo?.climate?.capitalizingFirstLetter()
        self.setDifficultylevel(image_view: lb_dif_image, level: (userObjectEditInfo?.growing!)!)
        //
        if let cross_breed = userObjectEditInfo?.cross_breed{
            if cross_breed.contains(","){
                self.lb_firstCrossTitle.text =  userObjectEditInfo?.cross_breed?.components(separatedBy: ",").first
                self.lb_secondCrossTitle.text  = userObjectEditInfo?.cross_breed?.components(separatedBy: ",").last
            }else{
                self.lb_firstCrossTitle.text = cross_breed
                self.lb_secondCrossTitle.text = ""
            }
        }else{
            self.lb_firstCrossTitle.text =  ""
            self.lb_secondCrossTitle.text  = ""
        }
        Btn_Type.addTarget(self, action: #selector(self.StrainTypeInfo), for: UIControlEvents.touchUpInside)
        Btn_Bottom_Left.addTarget(self, action: #selector(self.StrainTypeBottomLeft), for: UIControlEvents.touchUpInside)
        Btn_Bottom_Right.addTarget(self, action: #selector(self.StrainTypeBottomRight), for: UIControlEvents.touchUpInside)
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    func setDifficultylevel(image_view : UIImageView , level : String) {
        switch level {
        case "easy":
            image_view.image = #imageLiteral(resourceName: "easy_dft")
            break
        case "moderate":
            image_view.image = #imageLiteral(resourceName: "mid_dft")
            break
        case "hard":
            image_view.image = #imageLiteral(resourceName: "hard_dft")
            break
        default:
            break
        }
    }
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.lb_bgColorView.frame
        gradientLayer.colors = [UIColor(red:1.000, green:0.694, blue:0.212, alpha:1.000).cgColor,UIColor(red:0.965, green:0.000, blue:0.216, alpha:1.000).cgColor]
        gradientLayer.locations = [0.2, 0.45]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.lb_bgColorView.layer.addSublayer(gradientLayer)
    }
    @IBAction func lb_secondCross(_ sender: Any) {
    }
    @IBAction func lb_firstCross(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var popOverBackgroundColor: UIColor?{
        return  UIColor.init(hex: "4f4f4b")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    var contentSize: CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 800)
        
    }
    func StrainTypeInfo(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "TypeStrainViewController", nameStoryBoard: "Main") as! TypeStrainViewController
        viewMain.text = "Hybrid strains are a cross-breed of Indica and Sativa strains. Due to the plethora of possible combinations, the medical benefits, effects and sensations vary greatly.\n\nHybrids are most commonly created to target and treat specific medical conditions and illnesses."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
    }
    func StrainTypeBottomLeft(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "TypeStrainViewController", nameStoryBoard: "Main") as! TypeStrainViewController
        viewMain.text = "Indica plants typically grow short and wide which makes them better suited for indoor growing. Indica-dominant strains tend to have a strong sweet/sour odor.\n\nIndicas are very effective for overall pain relief and helpful in treating general anxiety, body pain, and sleeping disorders. It is commonly used in the evening or even right before bed due to it’s relaxing effects.\nMost Commonly Known Benefits:\n1.\tRelieves body pain\n2.\tRelaxes muscles\n3.\tRelieves spasms, reduces seizures\n4.\tRelieves headaches and migraines\n5.\tRelieves anxiety or stress\n"
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    
    func InfoTypeBottomLeft(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "TypeStrainViewController", nameStoryBoard: "Main") as! TypeStrainViewController
        viewMain.text = "Our metrics are calculated from experiences submitted by the users of the Healing Budz community - not a laboratory."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func StrainEditBottom(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "TypeStrainViewController", nameStoryBoard: "Main") as! TypeStrainViewController
        viewMain.text = "Your Vote Counts! \n\nBy up-voting a user submitted description, you are endorsing that the information provided is the best among other user submissions.\n\nThe highest voted description becomes the featured description for this strain."
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    
    func StrainTypeBottomRight(sender : UIButton){
        let viewMain = self.GetView(nameViewController: "TypeStrainViewController", nameStoryBoard: "Main") as! TypeStrainViewController
        viewMain.text = "Sativa plants grow tall and thin, making them better suited for outdoor growing- some strains can reach over 25 ft. in height. Sativa-dominant strains tend to have a more grassy-type odor.\n\nSativa effects are known to spark creativity and produce energetic and uplifting sensations. It is commonly used in the daytime due to its cerebral stimulation.\n\nMost Commonly Known Benefits:\n1.\tProduces feelings of well-being\n2.\tUplifting and cerebral thoughts\n3.\tStimulates and energizes\n4.\tIncreases focus and creativity\n5.\tFights depression"
        
        self.navigationController?.popoverPresentationController?.backgroundColor = UIColor.clear
        viewMain.showPopover(withNavigationController: sender, sourceRect: sender.bounds)
        
    }
    func ValueChange(senderValue: Float) {
        
        var x = Double(Float(self.lb_bgColorView.frame.width/100) * senderValue) - 9
        if x <= Double(self.lb_bgColorView.frame.origin.x) {
            x = Double(self.lb_bgColorView.frame.origin.x) - 8
        }else if x >= Double((self.lb_bgColorView.frame.origin.x + self.lb_bgColorView.frame.size.width)){
            x = Double((self.lb_bgColorView.frame.origin.x + self.lb_bgColorView.frame.size.width))
        }
        
        if senderValue < 50{
            self.lb_endPercent.text = String(format: "%.0f",senderValue) + " %"
            self.lb_startPercent.text = String(format: "%.0f",(100 - senderValue)) + " %"
        }
        else if senderValue >= 50{
            self.lb_endPercent.text = String(format: "%.0f",senderValue) + " %"
            self.lb_startPercent.text = String(format: "%.0f",(100 - senderValue)) + " %"
            
        }
        
//        self.imageViewForThumb?.frame = CGRect.init(x: x, y: Double(self.gradView.frame.origin.y-10), width: Double(14), height: Double(self.gradView.frame.size.height+20))
        
        gradientLayer.colors = [ConstantsColor.gradiant_first_colro, ConstantsColor.gradiant_second_colro]
        switch (senderValue/100) {
        case 0...0.05:
            gradientLayer.locations = [1.0, 1.0]
        case 0.05...0.10:
            gradientLayer.locations = [0.9, 0.95]
        case 0.10...0.15:
            gradientLayer.locations = [0.85, 0.90]
        case 0.15...0.20:
            gradientLayer.locations = [0.80, 0.85]
        case 0.20...0.25:
            gradientLayer.locations = [0.75, 0.80]
        case 0.25...0.30:
            gradientLayer.locations = [0.70, 0.75]
        case 0.30...0.35:
            gradientLayer.locations = [0.65, 0.70]
        case 0.35...0.40:
            gradientLayer.locations = [0.60, 0.65]
        case 0.40...0.45:
            gradientLayer.locations = [0.55, 0.60]
        case 0.45...0.50:
            gradientLayer.locations = [0.50, 0.55]
            
        case 0.50...0.55:
            gradientLayer.locations = [0.45, 0.50]
        case 0.55...0.60:
            gradientLayer.locations = [0.40, 0.45]
        case 0.60...0.65:
            gradientLayer.locations = [0.35, 0.40]
        case 0.65...0.70:
            gradientLayer.locations = [0.30, 0.35]
        case 0.70...0.75:
            gradientLayer.locations = [0.25, 0.30]
        case 0.75...0.80:
            gradientLayer.locations = [0.20, 0.25]
        case 0.80...0.85:
            gradientLayer.locations = [0.15, 0.20]
        case 0.85...0.90:
            gradientLayer.locations = [0.10, 0.15]
        case 0.90...0.95:
            gradientLayer.locations = [0.05, 0.10]
        case 0.95...1.0:
            gradientLayer.locations = [0.0, 0.0]
        default:
            break
        }
    }
    @IBAction func DismissInfo(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
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
