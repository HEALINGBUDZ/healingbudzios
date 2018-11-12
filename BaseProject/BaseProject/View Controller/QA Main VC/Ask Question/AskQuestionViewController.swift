//
//  AskQuestionViewController.swift
//  BaseProject
//
//  Created by macbook on 11/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import SDWebImage

class AskQuestionViewController: BaseViewController, CameraDelegate {

    @IBOutlet var lbl_Question_Count : UILabel!
    @IBOutlet var lbl_Detail_Count : UILabel!
    
    @IBOutlet var btn_askYourBudz : UIButton!
    
    @IBOutlet var txtView_Question : UITextView!
    @IBOutlet var txtView_Detail    : UITextView!
    
    @IBOutlet var attachemntHeight: NSLayoutConstraint!
    @IBOutlet weak var video_icon_one: UIImageView!
    @IBOutlet weak var video_icon_two: UIImageView!
    @IBOutlet weak var video_icon_three: UIImageView!
    
    @IBOutlet var view_Main_One : UIView!
    @IBOutlet var view_Main_Two : UIView!
    @IBOutlet var view_Main_Three : UIView!
    
    @IBOutlet var imgView_One : UIImageView!
    @IBOutlet var imgView_Two : UIImageView!
    @IBOutlet var imgView_Three : UIImageView!
    var array_Attachment = [Attachment]()
    var delegate = QAMainVC()
    
    let constantCountString = "/300 characters"
     let constantCountString_question = "/150 characters"
    var chooseQuestion = QA()
    var isViewWillApear : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView_Question.tag = 100
        self.txtView_Detail.tag = 110
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isViewWillApear{
        if chooseQuestion.id > 0 {
            self.btn_askYourBudz.setTitle("UPDATE YOUR QUESTION", for: .normal)
            self.array_Attachment = self.chooseQuestion.attachments
            self.ShowImageView(answer_Attachments: self.chooseQuestion.attachments)
            self.txtView_Question.text = self.chooseQuestion.Question.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtView_Detail.text = self.chooseQuestion.Question_description.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if self.txtView_Detail.text.count >= 300{
                self.lbl_Detail_Count.text = String(300) + constantCountString
            }else{
               self.lbl_Detail_Count.text = String(self.txtView_Detail.text.count) + constantCountString
            }
            
            if self.txtView_Question.text.count >= 150 {
                 self.lbl_Question_Count.text = String(150) + constantCountString_question
            }else{
                 self.lbl_Question_Count.text = String(self.txtView_Question.text.count) + constantCountString_question
            }
           
        }else {
            self.btn_askYourBudz.setTitle("ASK YOUR BUDZ", for: .normal)
            self.lbl_Detail_Count.text = "0" + constantCountString
            self.lbl_Question_Count.text = "0" + constantCountString_question
        }
        }
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    @IBAction func AskQuestion(sender : UIButton){
        
        if self.txtView_Question.text.count == 0 || self.txtView_Question.text == "Type your question here..."{
            self.ShowErrorAlert(message: "Please enter question!")
            return
        }
        
        
        
        if self.txtView_Detail.text.count == 0 || self.txtView_Detail.text == "Add a description..."{
            self.ShowErrorAlert(message: "Please enter description!")
            return
        }
        
     self.view.showLoading()
        var mainParam = [String : AnyObject]()
        
        mainParam["question"] = self.txtView_Question.text as AnyObject
        mainParam["description"] = self.txtView_Detail.text as AnyObject
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
        mainParam["file"] = attach_array as AnyObject
        if self.chooseQuestion.id > 0 {
            mainParam["question_id"] = String(self.chooseQuestion.id) as AnyObject
        }
        print(mainParam)
        NetworkManager.PostCall(UrlAPI: WebServiceName.add_question.rawValue, params: mainParam) { (successResponse, successMessage, mainResponse) in
            self.view.hideLoading()
            if successResponse {
                
                if (mainResponse["status"] as! String) == "success" {
                    if self.chooseQuestion.id > 0 {
                        if self.delegate != nil{
                            self.delegate.questionAdded = true
                        }
                        self.oneBtnCustomeAlert(title: "", discription: "Question updated successfully!") { (isComp, btn) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        if self.delegate != nil{
                            self.delegate.questionAdded = true
                        }
                        self.oneBtnCustomeAlert(title: "", discription: mainResponse["successMessage"] as! String) { (isComp, btn) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                   
                    
                }else {
                    self.ShowErrorAlert(message: mainResponse["errorMessage"] as! String)
                }
            }else {
                self.ShowErrorAlert(message: successMessage)
            }
        }
        
    }

    @IBAction func CloseButton(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
}


extension AskQuestionViewController : UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView.tag == 100 {
                textView.text = "Type your question here..."
            }else{
                textView.text = "Add a description..."
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 100 {
            if textView.text == "Type your question here..."{
                textView.text = ""
            }
        }else{
            if textView.text == "Add a description..."{
                textView.text = ""
            }
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 0 {
             if textView == txtView_Detail {
                if txtView_Detail.text.count > 299 {
                    return false
                }else {
                    self.lbl_Detail_Count.text = String(txtView_Detail.text.count + 1) + self.constantCountString
                }
            }else {
                if txtView_Question.text.count > 149 {
                    return false
                }else {
                    self.lbl_Question_Count.text = String(txtView_Question.text.count + 1) + self.constantCountString_question
                }
            }
        }else {
            if textView == txtView_Detail {
                if txtView_Detail.text.count > 0 {
                    self.lbl_Detail_Count.text = String(txtView_Detail.text.count - 1) + self.constantCountString
                }
            }else {
                if (txtView_Question.text?.count)! > 0 {
                    self.lbl_Question_Count.text = String(txtView_Question.text.count - 1) + self.constantCountString_question
                }
            }
        }
        return true
    }
    
    
//    func CheckTexgt(){
//        self.txtView_Question.text = self.getColoredText(textArray: ["Me" , "me"])
//    }
}


extension AskQuestionViewController{
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
