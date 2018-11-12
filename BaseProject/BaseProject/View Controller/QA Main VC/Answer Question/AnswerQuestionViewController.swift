//
//  AnswerQuestionViewController.swift
//  BaseProject
//
//  Created by macbook on 11/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import ActiveLabel
import IQKeyboardManager

class AnswerQuestionViewController: BaseViewController, CameraDelegate {
    
    // Textview
    @IBOutlet var lbl_Answer_Count : UILabel!
    @IBOutlet var txtView_Answer : UITextView!
    @IBOutlet var btn_Answer: UIButton!
    @IBOutlet var attachemntHeight: NSLayoutConstraint!
    @IBOutlet weak var video_icon_one: UIImageView!
    @IBOutlet weak var video_icon_two: UIImageView!
    @IBOutlet weak var video_icon_three: UIImageView!
    let constantCountString = "/2500 characters"
    
    var isFromMainVC : Bool = false
    @IBOutlet var view_Attachment : UIView!
    
    // Image view
    @IBOutlet var view_Main_One : UIView!
    @IBOutlet var view_Main_Two : UIView!
    @IBOutlet var view_Main_Three : UIView!
    
    @IBOutlet var imgView_One : UIImageView!
    @IBOutlet var imgView_Two : UIImageView!
    @IBOutlet var imgView_Three : UIImageView!
    
    var chooseQuestion = QA()
    var chooseAnswers = Answer()
    @IBOutlet var lbl_Question : ActiveLabel!
    @IBOutlet var lbl_Question_Description : ActiveLabel!
    
    var isViewWillApear : Bool = true
    var array_Attachment = [Attachment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView_Answer.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if isViewWillApear {
            var newArray = [Any]()
            for indexObj in appdelegate.keywords {
                let customType = ActiveType.custom(pattern: String.init(format: "\\s%@\\b",indexObj))
                self.lbl_Question.customColor[customType] = Constants.kTagColor
                self.lbl_Question_Description.customColor[customType] = Constants.kTagColor
                newArray.append(customType)
            }
            self.lbl_Question.enabledTypes = newArray as! [ActiveType]
            self.lbl_Question_Description.enabledTypes = newArray as! [ActiveType]
            if self.chooseAnswers.answer_ID.count > 0 {
                if Int(self.chooseAnswers.answer_ID)! >  0 {
                    self.lbl_Answer_Count.text = String(self.chooseAnswers.answer.trimmingCharacters(in: .whitespaces).count) + constantCountString
                    self.array_Attachment = self.chooseAnswers.attachments
                    self.ShowImageView(answer_Attachments: self.chooseAnswers.attachments)
                    self.txtView_Answer.text = self.chooseAnswers.answer.trimmingCharacters(in: .whitespaces)
                }else {
                    self.lbl_Answer_Count.text = "0" + constantCountString
                    self.ShowImageView(answer_Attachments: [])
                }
                self.btn_Answer.setTitle("UPDATE ANSWER", for: .normal)
                self.attachemntHeight.constant = 64
            }else {
                self.attachemntHeight.constant = 64
                self.btn_Answer.setTitle("ANSWER YOUR BUD", for: .normal)
                //            self.btn_Answer.text = "ANSWER YOUR BUD"
                self.lbl_Answer_Count.text = "0" + constantCountString
                self.ShowImageView(answer_Attachments: [])
            }
            self.lbl_Question.text = chooseQuestion.Question
            self.lbl_Question_Description.text = chooseQuestion.Question_description
        }
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
}

//MARK:
//MARK: Text View
extension AnswerQuestionViewController : UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
           textView.text = "Type your answer here..."
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your answer here..." {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 0 {
            if (textView.text.count + text.count ) > 2500 {
                return false
            }
        }else{
            if (textView.text.count) > 2500 {
                return false
            }
        }
        let char_count = 2500
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.lbl_Answer_Count.text = "\(numberOfChars)/2500 characters"
        return numberOfChars < char_count;
    }
}


extension AnswerQuestionViewController {
    
    @IBAction func AddNewImages(sender : UIButton){
        
        if self.array_Attachment.count > 2 {
            self.ShakeView(viewMain: self.view_Main_Three)
            self.ShakeView(viewMain: self.view_Main_One)
            self.ShakeView(viewMain: self.view_Main_Two)
        }else {
            self.isViewWillApear = false
            let vcCamera = self.GetView(nameViewController: "CameraVC", nameStoryBoard: "Main") as! CameraVC
            vcCamera.delegate = self
            vcCamera.isOnlyImage = false
            self.navigationController?.pushViewController(vcCamera, animated: true)
            
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    func VideoOutPulURL(videoURL: URL, image: UIImage) {
        
        let newAttachment = Attachment()
        newAttachment.is_Video = true
        newAttachment.image_Attachment = image
        newAttachment.video_URL = videoURL.absoluteString
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.ShowImageView(answer_Attachments: self.array_Attachment)
        if self.array_Attachment.count == 1 {
            self.imgView_One.image = image
        }else if self.array_Attachment.count == 2 {
            self.imgView_Two.image = image
        }else if self.array_Attachment.count == 3 {
            self.imgView_Three.image = image
        }
        self.UploadVideoFiles(videoUrl: videoURL)
    }
    func gifData(gifURL: URL, image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.ShowImageView(answer_Attachments: self.array_Attachment)
        if self.array_Attachment.count == 1 {
            self.imgView_One.image = image
        }else if self.array_Attachment.count == 2 {
            self.imgView_Two.image = image
        }else if self.array_Attachment.count == 3 {
            self.imgView_Three.image = image
        }
        self.UploadFiles(imageMain: image,gif_url: gifURL)
    }
    func captured(image: UIImage) {
        let newAttachment = Attachment()
        newAttachment.is_Video = false
        newAttachment.image_Attachment = image
        newAttachment.ID = "-1"
        self.array_Attachment.append(newAttachment)
        self.ShowImageView(answer_Attachments: self.array_Attachment)
        if self.array_Attachment.count == 1 {
            self.imgView_One.image = image
        }else if self.array_Attachment.count == 2 {
            self.imgView_Two.image = image
        }else if self.array_Attachment.count == 3 {
            self.imgView_Three.image = image
        }
        self.UploadFiles(imageMain: image)
    }
    
    
    @IBAction func RemoveImage(sender : UIButton){
        self.array_Attachment.remove(at: sender.tag)
        if sender.tag == 0 {
              self.imgView_One.image = self.imgView_Two.image
              self.imgView_Two.image = self.imgView_Three.image
        }else if sender.tag == 1 {
            self.imgView_Two.image = self.imgView_Three.image
        }else if sender.tag == 2 {
            self.imgView_Three.image = nil
        }
        self.ShowImageView(answer_Attachments: self.array_Attachment)
    }
    
    @IBAction func close_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Submit_Action(sender : UIButton){
        let textMAin = txtView_Answer.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if txtView_Answer.text.count > 0 && txtView_Answer.text != "Type your answer here..." && textMAin.count > 0
        {
            var paramaMain = [String : AnyObject]()
            paramaMain["answer"] = txtView_Answer.text.trimmingCharacters(in: .whitespaces) as AnyObject
            paramaMain["question_id"] = self.chooseQuestion.id as AnyObject
            var index = 0
            var attach_array  = [[String:Any]]()
            for indexObj in self.array_Attachment {
                if indexObj.is_Video {
                    if indexObj.ID == "-1" {
                         attach_array.append(["path" : indexObj.server_URL as Any , "media_type" : "video" as Any ,  "poster" : indexObj.image_URL as Any ])
                    }else{
                          attach_array.append(["path" : indexObj.video_URL as Any , "media_type" : "video" as Any ,  "poster" : indexObj.image_URL as Any ])
                    }
                   
                }else {
                    if indexObj.ID == "-1" {
                         attach_array.append(["path" : indexObj.server_URL as Any , "media_type" : "image" as Any ,  "poster" : "" as Any ])
                    }else{
                        attach_array.append(["path" : indexObj.image_URL as Any , "media_type" : "image" as Any ,  "poster" : "" as Any ])
                    }
                   
                }
                index = index + 1
            }
            paramaMain["file"] = attach_array as AnyObject
            
            if self.chooseAnswers.answer_ID.count > 0 {
                if Int(self.chooseAnswers.answer_ID)! >  0 {
                   paramaMain["answer_id"] = self.chooseAnswers.answer_ID as AnyObject
                }
            }
            self.showLoading()
            print("paramaMain ==> \(paramaMain)")
            NetworkManager.PostCall(UrlAPI: WebServiceName.add_answer.rawValue , params: paramaMain, completion: { (SuccessResponse, MessageResponse, DataResponse) in
                print(SuccessResponse)
                print(MessageResponse)
                print(DataResponse)
                self.hideLoading()
                if SuccessResponse {
                    if  let status  = DataResponse["status"] as? String {
                        if status == "success" {
                            _ = DataResponse["successData"] as! [String : AnyObject]
                            if let Errormessage = DataResponse["errorMessage"] as? String {
                                if Errormessage == "Session Expired" {
                                    DataManager.sharedInstance.logoutUser()
                                    self.ShowLogoutAlert()
                                }
                            }else if let successmessage = DataResponse["successMessage"] as? String {
                                if self.chooseAnswers.answer_ID.count > 0 {
                                    if Int(self.chooseAnswers.answer_ID)! >  0 {
                                        if  self.isFromMainVC {
                                            
                                            self.ShowSuccessAlert(message: "Answer Updated Successfully!") {() in
                                                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                                                DetailQuestionVc.isFromNewAnser = true
                                                DetailQuestionVc.QuestionID = String(self.chooseQuestion.id)
                                                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                                            }
                                           
                                        }else{
                                             self.ShowSuccessAlert(message: "Answer Updated Successfully!")
                                        }
                                    }else{
                                        if  self.isFromMainVC {
                                            self.ShowSuccessAlert(message: successmessage) {() in
                                                let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                                                DetailQuestionVc.isFromNewAnser = true
                                                DetailQuestionVc.QuestionID = String(self.chooseQuestion.id)
                                                self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                                            }
                                           
                                        }else{
                                           self.ShowSuccessAlert(message: successmessage)
                                        }
                                    }
                                }else{
                                    if  self.isFromMainVC {
                                        self.ShowSuccessAlert(message: successmessage) {() in
                                            let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
                                            DetailQuestionVc.isFromNewAnser = true
                                            DetailQuestionVc.QuestionID = String(self.chooseQuestion.id)
                                            self.navigationController?.pushViewController(DetailQuestionVc, animated: true)
                                        }
                                    }else{
                                        self.ShowSuccessAlert(message: successmessage)
                                    }
                                }
                            }
                        }else{
                            self.ShowErrorAlert(message:MessageResponse)
                        }
                    }else {
                        self.ShowErrorAlert(message:MessageResponse)
                    }
                }else{
                     self.ShowErrorAlert(message:MessageResponse)
                }
                
            })
        }else {
            self.ShowErrorAlert(message: "Enter answer!")
        }
        
    }
    
    func UploadFiles(imageMain : UIImage , gif_url:URL? = nil){
        self.showLoading()
        NetworkManager.UploadFiles(kBaseURLString + WebServiceName.add_image.rawValue, image: imageMain,gif_url:gif_url, onView: self) { (MainResponse) in
            
            print(MainResponse)
            self.hideLoading()
            
            if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [String : AnyObject]
                    self.array_Attachment.last?.server_URL = mainData["path"] as! String
                  print( self.array_Attachment.last?.server_URL )
            }else {
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    
    
    func UploadVideoFiles(videoUrl : URL){
        self.showLoading()
        NetworkManager.UploadVideo(WebServiceName.add_video.rawValue, urlVideo: videoUrl, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if (MainResponse["status"] as! String) == "success" {
                    let mainData = MainResponse["successData"] as! [String : AnyObject]
                    self.array_Attachment.last?.server_URL = mainData["path"] as! String
                    self.array_Attachment.last?.image_URL = mainData["poster"] as! String
                
                   print( self.array_Attachment.last?.server_URL )
                   print( self.array_Attachment.last?.image_URL )
                
            }else {
                self.ShowErrorAlert(message:kNetworkNotAvailableMessage)
            }
        }
    }
    
}


//MARK:
//MARK: Random function
extension AnswerQuestionViewController {
    func ShowImageView(answer_Attachments : [Attachment]){
        self.view_Main_Three.isHidden = true
        self.view_Main_Two.isHidden = true
        self.view_Main_One.isHidden = true
        
        self.video_icon_three.isHidden = true
        self.video_icon_two.isHidden = true
        self.video_icon_one.isHidden = true
        switch answer_Attachments.count {
        case 3:
            // 1
            print(answer_Attachments[2].image_URL)
            self.view_Main_Three.isHidden = false
            if answer_Attachments[2].is_Video {
                self.video_icon_three.isHidden = false
                if answer_Attachments[2].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[2].image_Attachment
                }else{
                    self.imgView_Three.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[2].image_URL), completed: { (image, error, chache, url) in
                    })
                }
               
            }else{
                 self.video_icon_three.isHidden = true
                if answer_Attachments[2].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[2].image_Attachment
                }else{
                    self.imgView_Three.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[2].image_URL), completed: { (image, error, chache, url) in
                    })
                }
               
            }
            // 2
            self.view_Main_Two.isHidden = false
            if answer_Attachments[1].is_Video {
                self.video_icon_two.isHidden = false
                
                if answer_Attachments[1].ID == "-1" {
                     self.imgView_Three.image = answer_Attachments[1].image_Attachment
                }else{
                    self.imgView_Two.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[1].image_URL), completed: { (image, error, chache, url) in
                    })
                }
               
            }else{
                self.video_icon_two.isHidden = true
                if answer_Attachments[1].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[1].image_Attachment
                }else{
                    self.imgView_Two.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[1].image_URL), completed: { (image, error, chache, url) in
                    })
                }
            }
            //3
            self.view_Main_One.isHidden = false
            if answer_Attachments[0].is_Video {
                self.video_icon_one.isHidden = false
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                    })
                }
            }else{
                 self.video_icon_one.isHidden = true
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                    })
                }
                
            }
            break;
        case 2:
            // 2
            self.view_Main_Two.isHidden = false
            if answer_Attachments[1].is_Video {
                self.video_icon_two.isHidden = false
                
                if answer_Attachments[1].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[1].image_Attachment
                }else{
                    self.imgView_Two.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[1].image_URL), completed: { (image, error, chache, url) in
                        print(url)
                    })
                }
                
            }else{
                self.video_icon_two.isHidden = true
                if answer_Attachments[1].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[1].image_Attachment
                }else{
                    self.imgView_Two.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[1].image_URL), completed: { (image, error, chache, url) in
                    })
                }
            }
            //3
            self.view_Main_One.isHidden = false
            if answer_Attachments[0].is_Video {
                self.video_icon_one.isHidden = false
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                    })
                }
            }else{
                self.video_icon_one.isHidden = true
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                         print(url)
                    })
                }
                
            }
            break;
        case 1:
             print(answer_Attachments[0].image_URL)
             //3
             self.view_Main_One.isHidden = false
             if answer_Attachments[0].is_Video {
                self.video_icon_one.isHidden = false
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    print("path ==> \(WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL)")
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                          print(url)
                        if error != nil {
                             print(error.debugDescription)
                        }
                    })
                }
             }else{
                self.video_icon_one.isHidden = true
                
                if answer_Attachments[0].ID == "-1" {
                    self.imgView_Three.image = answer_Attachments[0].image_Attachment
                }else{
                    self.imgView_One.sd_setImage(with: URL.init(string: WebServiceName.images_baseurl.rawValue+answer_Attachments[0].image_URL), completed: { (image, error, chache, url) in
                        print(url)
                        if error != nil {
                            print(error.debugDescription)
                        }
                    })
                }
                
             }
            break;
            
            
        default:
            
            break
        }
    }
}
