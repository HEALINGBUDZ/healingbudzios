//
//  ViewController.swift
//  cameraForHealingBudz
//
//  Created by MAC MINI on 12/10/2017.
//  Copyright © 2017 MAC MINI. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
 @objc protocol CameraDelegate {
    
    func captured(image:UIImage)
    func VideoOutPulURL(videoURL:URL , image:UIImage )
    @objc optional func gifData(gifURL:URL , image:UIImage )
   
}
class CameraVC: BaseViewController,AVCaptureFileOutputRecordingDelegate{
    
    @IBOutlet weak var waiting_main_view: UIView!
    @IBOutlet weak var viewWaiting: UIView!
    @IBOutlet weak var lblVideoTimer: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var toggleImg: UIImageView!
    @IBOutlet weak var btnCapture: UIButton!
    
    @IBOutlet weak var viewGallery: UIView!
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewVideophoto:UIView!
    @IBOutlet weak var viewVideogallery:UIView!
    @IBOutlet weak var viewVideophotobutton:UIView!
    @IBOutlet weak var viewVideoGallerybutton:UIView!
    let picker = UIImagePickerController()
    
    @IBOutlet weak var lblGallery: UILabel!
    @IBOutlet weak var lblVideo: UILabel!
    @IBOutlet weak var lblPhoto: UILabel!
    @IBOutlet weak var lblPhotoText: UILabel!
    
    @IBOutlet weak var viewPhotoOption: UIView!
    @IBOutlet weak var viewVideoOption: UIView!
    var profileDeletegate : EditCoverPhotoVC?
    var callFromWall = false
    
    var shouldStartSession = true
    @IBOutlet weak var cameraView: UIView!
    var count = 20
    var timer:Timer?
    var isViewPresent : Bool = false
    var delegate:CameraDelegate? = nil
    var usingFrontCamera = false
    
    var isOnlyImage = false
    
    var captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var isPhotoCapturing = true
    var recordingStarted:Bool?
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?

    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.viewWaiting.isHidden = true
          recordingStarted = false
          lblVideoTimer.isHidden = true
        
    }
    
    func checkPermission(){
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted: Bool) in
            if granted {
                print("access")
            } else {
                 print("reject")
            }
        })
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .authorized {
            //already authorized
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               print("access")
            }
            
            
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) in
                if granted {
                     print("access")
                } else {
                    //access denied
                }
            })
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted: Bool) in
                if granted {
                    print("access")
                } else {
                   
                }
            })
        }
        
    }
    
    deinit {
        stopSession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewVideoOption.isHidden = true
        self.viewPhotoOption.isHidden = true
        
        
        if self.isOnlyImage {
            self.viewPhotoOption.isHidden = false
            isPhotoCapturing = true
            self.lblPhotoText.text = "Photo"
        }else {
            
            self.lblPhotoText.text = "Photo"
            self.viewVideoOption.isHidden = false
            isPhotoCapturing = true
//            lblVideoTimer.isHidden = false
            self.lblPhoto.textColor = UIColor.black
            self.lblVideo.textColor = UIColor.lightGray
            self.lblGallery.textColor = UIColor.lightGray
            self.viewVideophoto.backgroundColor = UIColor.black
            self.viewVideo.backgroundColor = UIColor.clear
            self.viewVideogallery.backgroundColor = UIColor.clear
            lblVideoTimer.isHidden = true
        }
        if callFromWall{
            isPhotoCapturing = false
            self.viewVideophotobutton.isHidden = true
//            self.viewVideo
            self.viewVideoGallerybutton.isHidden = true
        }
        if isCancel {
            self.viewWaiting.isHidden = true
            isPhotoCapturing = false
            lblVideoTimer.isHidden = false
            self.lblPhotoText.text = "Video"
            self.lblPhoto.textColor = UIColor.lightGray
            self.lblVideo.textColor = UIColor.black
            self.lblGallery.textColor = UIColor.lightGray
            self.viewVideophoto.backgroundColor = UIColor.clear
            self.viewVideo.backgroundColor = UIColor.black
            self.viewVideogallery.backgroundColor = UIColor.clear
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.checkPermission()
        self.showLoading()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if let deviceDescoverySession = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera],mediaType: AVMediaTypeVideo,position: AVCaptureDevicePosition.unspecified) {
            
            for device in deviceDescoverySession.devices {
                if device.hasMediaType(AVMediaTypeVideo){
                    if device.position == .back {
                        captureDevice = device
                        if captureDevice != nil {
                            print("Capture device found")
                            if shouldStartSession{
                                beginSession()
                            }
                            self.hideLoading()
                        }
                    }
                }else {
                    self.hideLoading()
                }
                
            }
        }
        
//        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
//            // Loop through all the capture devices on this phone
//            for device in devices {
//                // Make sure this particular device supports video
//                if (device.hasMediaType(AVMediaTypeVideo)) {
//                    // Finally check the position and confirm we've got the back camera
//                    if(device.position == AVCaptureDevicePosition.back) {
//                        captureDevice = device
//                        if captureDevice != nil {
//                            print("Capture device found")
//                            if shouldStartSession{
//                                   beginSession()
//                            }
//                            self.hideLoading()
//                        }
//                    }
//                }
//            }
//        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewDidLayoutSubviews() {
     


    }
    func loadCameraAgain()  {
        
        captureDevice = (usingFrontCamera ? getFrontCamera()! : getBackCamera())
        if captureDevice != nil{
              beginSession()
        }
        
        
        
    }
    func getFrontCamera() -> AVCaptureDevice?{
    
        stopSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        if let deviceDescoverySession = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera],mediaType: AVMediaTypeVideo,position: AVCaptureDevicePosition.unspecified) {
            
            for device in deviceDescoverySession.devices {
                if device.hasMediaType(AVMediaTypeVideo){
                    if device.position == .front {
                        return device
                    }
                }
                
            }
        }
        
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        stopSession()
        if let deviceDescoverySession = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera],mediaType: AVMediaTypeVideo,position: AVCaptureDevicePosition.unspecified) {
            
            for device in deviceDescoverySession.devices {
                if device.hasMediaType(AVMediaTypeVideo){
                    if device.position == .back {
                        return device
                    }
                }
                
            }
        }
        return nil
    }
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        if !isPhotoCapturing{
            self.stopSession()
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.sourceType = .camera
            picker.delegate = self
            picker.videoQuality = .typeMedium
            picker.videoMaximumDuration = TimeInterval(20.0)
            self.present(self.picker, animated: true, completion: {
                 self.picker.startVideoCapture()
                self.waiting_main_view.isHidden = false
                self.viewWaiting.isHidden = false
                self.waiting_main_view.zoomIn()
            })
            return
            if !recordingStarted!{
            captureSession.stopRunning()
            previewLayer?.removeFromSuperlayer()
            
            
            self.videoOutput.stopRecording()
            
            
            captureSession.removeOutput(videoOutput)
            captureSession.removeOutput(stillImageOutput)
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            captureSession.usesApplicationAudioSession = true
            captureSession.automaticallyConfiguresApplicationAudioSession = true
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            self.beginVideoSession()
                 }
            else{
                self.videoOutput.stopRecording()
            }
            
        }
    else{
            print("Camera button pressed")
            saveToCamera()
        }
        
    }
    @IBAction func btnToggle(_ sender: Any) {
        if recordingStarted! {
            
        }else {
            usingFrontCamera = !usingFrontCamera
            self.loadCameraAgain()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        stopSession()
    }
    func stopSession() {
        captureSession.stopRunning()
        previewLayer?.removeFromSuperlayer()
        self.videoOutput.stopRecording()
        captureSession.removeOutput(videoOutput)
        captureSession.removeOutput(stillImageOutput)
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
    func beginSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
//           try captureSession.addInput(AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
         
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("no preview layer")
            return
        }
     
        
       captureSession.startRunning()
        previewLayer.frame = self.cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.cameraView.layer.addSublayer(previewLayer)
    //    self.cameraView.layer.masksToBounds = true
        captureSession.startRunning()
        self.cameraView.backgroundColor = UIColor.white
       // self.cameraView.addSubview(btnCapture)
        self.cameraView.addSubview(btnToggle)
        self.cameraView.addSubview(toggleImg)
    }
    
    func saveToCamera() {
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: CMSampleBuffer!, previewPhotoSampleBuffer: CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        print("size of image in KB: %f ", cameraImage.getSizeKB())
                        print("size of image in MB: %f ", cameraImage.getSizeMB())
                        if cameraImage.getSizeMB() > 5 {
                            self.showImagesizeAlert(cameraImage: cameraImage)
                            return
                        }
                        if cameraImage.getSizeMB() > 1 {
                            if self.delegate != nil{
                                let img = UIImage.init(data: cameraImage.jpeg(.medium)!)
                                print("size of reducesd image in MB: %f ", img?.getSizeMB() as Any)
                                self.delegate?.captured(image: img!)
                                if self.isViewPresent{
                                    self.dismiss(animated: true, completion: nil)
                                }else{
                                     self.navigationController?.popViewController(animated: true)
                                }
                               
                            }
                        }else{
                            if self.delegate != nil{
                                self.delegate?.captured(image: cameraImage)
                            if self.isViewPresent{
                                self.dismiss(animated: true, completion: nil)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                            }
                        }
                    }
                }
            })
        }
    }
    func showImagesizeAlert(cameraImage:UIImage) {
        
        self.deleteCustomeAlert(title: "", discription: "Image size greater than 10 MB. It may increase loading time, would you like to continue?", btnTitle1: "NO", btnTitle2: "YES") { (isCom, btn) in
            if(isCom){
                if self.delegate != nil{
                    let img = UIImage.init(data: cameraImage.jpeg(.medium)!)
                    self.delegate?.captured(image: img!)
                    if self.isViewPresent{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else {
                
            }
        }
       
    }
    //MARK: AVCaptureFileOutputRecordingDelegate Methods
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        recordingStarted = true
        lblVideoTimer.isHidden = false
        count = 20
        timer?.invalidate()
        timer = nil
          timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CameraVC.update), userInfo: nil, repeats: true)
          print("recording started")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("FINISHED \(error)")
        recordingStarted = false
        timer?.invalidate()
        timer = nil
        lblVideoTimer.text = "20"
        if error == nil {
            if delegate != nil{
                if let image:UIImage = self.getThumbnailFrom(path: outputFileURL){
                 delegate?.VideoOutPulURL(videoURL: outputFileURL , image: image)
                    if self.isViewPresent{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    print("could not produce thumbnail")
                }
            }
        }
    }

    @IBAction func btnPhoto(_ sender: Any) {
        
        self.lblPhoto.textColor = UIColor.black
        self.lblVideo.textColor = UIColor.lightGray
        lblVideoTimer.isHidden = true
        self.lblGallery.textColor = UIColor.lightGray
        self.lblPhotoText.text = "Photo"
        self.viewPhoto.backgroundColor = UIColor.black
        self.viewVideo.backgroundColor = UIColor.clear
        self.viewGallery.backgroundColor = UIColor.clear
        isPhotoCapturing = true
        lblVideoTimer.isHidden = true
        if  recordingStarted! {
            self.videoOutput.stopRecording()
        }

    }
  
    @IBAction func btnVideo(_ sender: Any) {
        isPhotoCapturing = false
        lblVideoTimer.isHidden = false
        self.lblPhotoText.text = "Video"
        self.lblPhoto.textColor = UIColor.lightGray
        self.lblVideo.textColor = UIColor.black
        self.lblGallery.textColor = UIColor.lightGray
        self.viewVideophoto.backgroundColor = UIColor.clear
        self.viewVideo.backgroundColor = UIColor.black
        self.viewVideogallery.backgroundColor = UIColor.clear
//        self.stopSession()
//        picker.mediaTypes = [kUTTypeMovie as String]
//        picker.sourceType = .camera
//        picker.delegate = self
//        picker.videoMaximumDuration = TimeInterval(20.0)
//        self.present(self.picker, animated: true, completion: {
//            self.picker.startVideoCapture()
//            self.waiting_main_view.isHidden = false
//            self.viewWaiting.isHidden = false
//            self.waiting_main_view.zoomIn()
//        })
    }
    func beginVideoSession(){
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice))
//            try captureSession.addInput(AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) as AVCaptureDevice))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("no preview layer")
            return
        }
        
        
        captureSession.startRunning()
        if !isPhotoCapturing{
            captureSession.addOutput(videoOutput)
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            videoOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
        }
        
        print(captureSession)
        
        
        previewLayer.frame = self.cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.cameraView.layer.addSublayer(previewLayer)
        //    self.cameraView.layer.masksToBounds = true
        captureSession.startRunning()
        self.cameraView.backgroundColor = UIColor.white
        
        // self.cameraView.addSubview(btnCapture)
        self.cameraView.addSubview(btnToggle)
        self.cameraView.addSubview(toggleImg)
    }
    
    func update() {
        if(count > 0) {
            count = count-1
            lblVideoTimer.text = String(count)
        }else if count == 0{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                print("stopping")
                self.videoOutput.stopRecording()
            }

        }
    }
    
    @IBAction func btn_close(_ sender: Any) {
        self.delayWithSeconds(0.2) {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseCamera"), object: nil)
//            if self.profileDeletegate != nil {
//                self.profileDeletegate?.displayPopUp()
//            }
        }
        if self.profileDeletegate != nil {
            self.profileDeletegate?.displayPopUp()
        }
        if self.isViewPresent{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
    
    @IBAction func galleryBtn(_ sender: Any) {
        self.showGallery()
    }
    func showGallery()   {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        if self.isOnlyImage {
            imagePicker.mediaTypes = ["public.image"]
        }else {
            imagePicker.mediaTypes = ["public.image", "public.movie"]
        }
        
        imagePicker.videoMaximumDuration = 20
        shouldStartSession = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            self.shouldStartSession = true
        }
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            if mediaType  == "public.image" {
                if #available(iOS 11.0, *) {
                    if let imageURL = info[UIImagePickerControllerImageURL] as? NSURL {
                        if (imageURL.lastPathComponent?.contains(".gif"))!{
                            if delegate != nil{
                                delegate?.gifData!(gifURL: imageURL as URL, image:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
                                if self.isViewPresent{
                                    self.dismiss(animated: true, completion: nil)
                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                }
                                return
                            }
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    print("size of image in KB: %f ", pickedImage.getSizeKB())
                    print("size of image in MB: %f ", pickedImage.getSizeMB())
                    if pickedImage.getSizeMB() > 1 {
                        self.showImagesizeAlert(cameraImage: pickedImage)
                        return
                    }
                    if pickedImage.getSizeMB() > 1 {
                        if self.delegate != nil{
                            let img = UIImage.init(data: pickedImage.jpeg(.medium)!)
                             print("size of reduced image in MB: %f ", img!.getSizeMB())
                            self.delegate?.captured(image: img!)
                            if self.isViewPresent{
                                self.dismiss(animated: true, completion: nil)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        if self.delegate != nil{
                            if pickedImage.isGIF() {
                                self.delegate?.captured(image: pickedImage)
                                if self.isViewPresent{
                                    self.dismiss(animated: true, completion: nil)
                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }else{
                                self.delegate?.captured(image: pickedImage)
                                if self.isViewPresent{
                                    self.dismiss(animated: true, completion: nil)
                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    }
                }
            }
            
            if mediaType == "public.movie" {
                print("Video Selected")
                if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                    if delegate != nil{
                        if let image:UIImage = self.getThumbnailFrom(path: videoURL as URL){
                            delegate?.VideoOutPulURL(videoURL: videoURL as URL, image: image)
                            if self.isViewPresent{
                                self.dismiss(animated: true, completion: nil)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else{
                            print("could not produce thumbnail")
                        }
                        
                        
                    }
                }
                return
            }else {
                self.viewWaiting.isHidden = true
            }
        }else if let videoURL =  info[UIImagePickerControllerMediaURL] as? URL{
            if delegate != nil{
                if let image:UIImage = self.getThumbnailFrom(path: videoURL as URL){
                    delegate?.VideoOutPulURL(videoURL: videoURL as URL, image: image)
                    if self.isViewPresent{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    print("could not produce thumbnail")
                }
                
                
            }
        }else {
            self.viewWaiting.isHidden = true
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.shouldStartSession = true
        }
        isCancel = true
        self.viewWaiting.isHidden = true
        isPhotoCapturing = false
        lblVideoTimer.isHidden = false
        self.lblPhotoText.text = "Video"
        self.lblPhoto.textColor = UIColor.lightGray
        self.lblVideo.textColor = UIColor.black
        self.lblGallery.textColor = UIColor.lightGray
        self.viewVideophoto.backgroundColor = UIColor.clear
        self.viewVideo.backgroundColor = UIColor.black
        self.viewVideogallery.backgroundColor = UIColor.clear
    }
    var isCancel:Bool = false
}

