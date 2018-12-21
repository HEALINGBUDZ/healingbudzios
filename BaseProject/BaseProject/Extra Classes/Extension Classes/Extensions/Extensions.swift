//
//  Extensions.swift
//  SaveMe
//
//  Created by Vengile on 26/04/2017.
//  Copyright © 2017 Vengile. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit
extension UIView {
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func takeSnapShotWithoutScreenUpdate() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        var image:UIImage? = nil
        
        if self.drawHierarchy(in: self.bounds, afterScreenUpdates: false) {
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIButton {
    /// 0 => .ScaleToFill
    /// 1 => .ScaleAspectFit
    /// 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIViewContentMode(rawValue: newValue),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}


extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    func FindSize() -> Int{
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        return Int(imgData.length)

    }
}


extension MBProgressHUD {
    private class func createHud(addedTo view: UIView, image: UIImage?, text: String, rotate: Bool = true) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let img = UIImageView(image: image)
        hud.customView = img
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = false
        
        // Equal width/height depending on whichever is larger
        hud.isSquare = true
        
        hud.label.text = ""
        hud.label.textColor = .clear
        
        // Partially see-through bezel
        hud.bezelView.color = .clear
        hud.bezelView.style = .solidColor
        
        // Dim background
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.3)
        hud.backgroundView.style = .solidColor
        
        if rotate {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0.0
            animation.toValue = 2.0 * Double.pi
            animation.duration = 1
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            hud.customView?.layer.add(animation, forKey: "rotationAnimation")
        }
        
        return hud
    }
    
    class func refreshing(addedTo view: UIView) -> MBProgressHUD {
        return createHud(addedTo: view, image: UIImage.init(named: "loader.gif"), text: "refreshing", rotate: false)
    }
}



//MARK:- UIView
extension UIView
{
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {

        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func CornerRadiousView()  {
        self.layer.cornerRadius = Constants.kCornerRaious
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    
    func DrawCorner()  {
//        self.layer.cornerRadius = Constants.kCornerRaious
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    
    func showLoading() {
        DispatchQueue.main.async {
//            _ = MBProgressHUD.refreshing(addedTo: self)
            let hud =   MBProgressHUD.showAdded(to: self, animated: true)
            hud.contentColor = UIColor.init(hex: "FFFFFF")
            hud.bezelView.color = UIColor.clear
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            hud.bezelView.style = .solidColor
            hud.label.text = "Loading.."
            hud.mode = .indeterminate
        }
    }
    func hideLoading() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    func drawBorderWithColor(color:UIColor){
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
    }
    func removeBorder() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
}
extension String{
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func SpecificLetterCount(char:Character) ->Int {
        var letters = Array(self); var count = 0
        for letter in letters {
            if letter == char {
                count += 1
            }
        }
        return count
    }
}
extension Date {
    
    func GetString(dateFormate : String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = dateFormate
        
        return dateFormatterGet.string(from: self)
    }
    func GetStringDefaultUtc(dateFormate : String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = dateFormate
        dateFormatterGet.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatterGet.string(from: self)
    }
    
    func GetTimezone() -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "z"
        
        return dateFormatterGet.string(from: self)
    }
	

    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    
}

extension String {
    
    func RemoveSpace() -> String{
        
        
        let newString = self.replacingOccurrences(of: " ", with: "%20")
        return newString
    }
    func replaceSpace(str : String) -> String{
        let newString = self.replacingOccurrences(of: " ", with: str)
        return newString
    }
    
    func RemoveHTMLTag() -> String{
        var newString = self.replacingOccurrences(of: "<b ><font class='keyword_class' color=#6d96ad>", with: "")
        newString = newString.replacingOccurrences(of: "<b ><font class=\"keyword_class\" color=#6d96ad>", with: "")
        newString =  newString.replacingOccurrences(of: "</font></b>", with: "")
        let str = newString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
         return str
    }
    
    func RemoveBRTag() -> String{
        let newString = self.replacingOccurrences(of: "<br />", with: "\n")
        return newString
    }
    
    
//    func GetTimeAgo(StringDate : String) -> String{
//        let dateRangeStart = Date()
//
//        let dateRangeEnd = self.UTCToLocal(date: StringDate)
//
//        let components = Calendar.current.dateComponents([.month , .day ,.hour ,.minute], from: dateRangeEnd, to: dateRangeStart)
//
//
//        var stringReturn = "moments ago"
//        if components.month! > 0 {
//            stringReturn = String(components.month!) + " month ago"
//        }else if components.day! > 0 {
//            if components.day! > 7 && components.day! < 14 {
//                stringReturn = "1 week ago"
//            }else if components.day! > 14 && components.day! < 21 {
//                stringReturn = "2 weeks ago"
//            }else if components.day! > 21 && components.day! < 28 {
//                stringReturn = "3 weeks ago"
//            }else {
//                stringReturn = String(components.day!) + " day ago"
//            }
//        }else if components.hour! > 0 {
//            stringReturn = String(components.hour!) + " hours ago"
//        }else if components.minute! > 0 {
//            stringReturn = String(components.minute!) + " minutes ago"
//        }
//
//        return stringReturn
//
//    }
    
    func ShoutOutMonthCalculate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(self)
        let dateRangeEnd = dateFormatter.date(from: self)

        let dateRangeStart = Date()
        
        
        let components = Calendar.current.dateComponents([.month , .day ,.hour ,.minute], from: dateRangeEnd!, to: dateRangeStart)
        
        
        var stringReturn = "Just now"
        if components.month! > 0 {
            stringReturn = String(components.month!) + " month ago"
        }else if components.day! > 0 {
            if components.day! >= 7 && components.day! < 14 {
                stringReturn = "1 week ago"
            }else if components.day! > 13 && components.day! < 21 {
                stringReturn = "2 weeks ago"
            }else if components.day! > 20 && components.day! < 28 {
                stringReturn = "3 weeks ago"
            }else {
                if(components.day! == 1){
                     stringReturn = String(components.day!) + " day ago"
                }else {
                     stringReturn = String(components.day!) + " days ago"
                }
            }
        }else if components.hour! > 0 {
            stringReturn = String(components.hour!) + " hours ago"
        }else if components.minute! > 0 {
            stringReturn = String(components.minute!) + " minutes ago"
        }
        
        return stringReturn
        
        
//        let currentCalendar = Calendar.current
//
//        guard let start = currentCalendar.ordinality(of: Calendar.Component.month, in: .era, for: date!) else { return "" }
//        guard let end = currentCalendar.ordinality(of: Calendar.Component.month, in: .era, for: Date.init()) else { return "" }
//
//        return String(end - start) + " months ago"
    }
    
    
    func ShoutOutDayCalculate() -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: self)
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: Calendar.Component.month, in: .era, for: date!) else { return 0 }
        guard let end = currentCalendar.ordinality(of: Calendar.Component.month, in: .era, for: Date.init()) else { return 0 }
        
        return start - end
    }
    
    
    func GetDaysAgo(formate : String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: self)
        return Calendar.current.dateComponents([.day], from: Date(), to: date!).day!
    }
    func GetShoutout() -> String {
        
        if self.characters.count > 0 {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: self)
            return date!.GetString(dateFormate: "MM.d.yyy")
            
        }else {
            return ""
        }
    }
    func GetShoutoutSpecial() -> String {
        
        if self.characters.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: self)
            return date!.GetString(dateFormate: "MMMM dd, yyyy")
            
        }else {
            return ""
        }
    }
    
    func GetDateFormate() -> String {
        
        if self.characters.count > 0 {
           
            
            if UInt64(self)! > 0 {
                let endIndex = self.index(self.endIndex, offsetBy: -3)
                let truncated = self.substring(to: endIndex)
                let date = Date(timeIntervalSince1970: Double(truncated)!)
                return date.GetString(dateFormate: "YYYY-MM-dd")
            }else {
               return "" 
            }
            
        }else {
            return ""
        }
    }
    
    
    func GetTimeFormDate() -> String {
        
        print(self)
        if self.characters.count > 0 {
            
            
            if Int(self)! > 0 {
                let endIndex = self.index(self.endIndex, offsetBy: -3)
                let truncated = self.substring(to: endIndex)
                let date = Date(timeIntervalSince1970: Double(truncated)!)
                return date.GetString(dateFormate: "HH:mm")
            }else {
                return ""
            }
            
        }else {
            return ""
        }
    }
    
    
    
    
    func AnswerTimeConvert() -> String {
        
        print("GetDateObject ==> \(self)")
        if self.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateMy = dateFormatter.date(from: self)!
            dateFormatter.dateFormat = "MM.dd.yyyy hh:mm a"
             dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            return dateFormatter.string(from: dateMy)
            
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.string(from: Date())
        }
    }
    
    func UTCToLocal(inputFormate : String , outputFormate : String) -> String {
        if self.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  inputFormate  //Input Format "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let UTCDate = dateFormatter.date(from: self)
            dateFormatter.dateFormat =  outputFormate // Output Format "MM.dd.yyyy hh:mm a"
            dateFormatter.timeZone =  NSTimeZone.local
            if UTCDate != nil {
                let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
                return UTCToCurrentFormat
            }
            return self
           
        }else{
            return "Empty Date!"
        }
    }
    
    func UTCToLocalSameZone(inputFormate : String , outputFormate : String) -> String {
        if self.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  inputFormate  //Input Format "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone =  NSTimeZone.local
            if let UTCDate = dateFormatter.date(from: self){
            dateFormatter.dateFormat =  outputFormate // Output Format "MM.dd.yyyy hh:mm a"
            dateFormatter.timeZone =  NSTimeZone.local
                let UTCToCurrentFormat = dateFormatter.string(from: UTCDate)
            return UTCToCurrentFormat
            }else{
            return "Empty Date!"
            }
        }else{
            return "Empty Date!"
        }
    }
    
    
    func GetDateObject(formate: String) -> Date {
        if self == nil || self == "null" {
            return Date()
        }
        
        
        print("GetDateObject ==> \(self)")
        if self.characters.count > 0 {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate
            if let test = dateFormatter.date(from: self){
                return test
            }else {
              return Date()
            }
            
            
        }else {
            return Date()
        }
    }
//    let calendar = Calendar.current
//    let dayOfMonth = calendar.component(.day, from: date)
//    switch dayOfMonth {
//    case 1, 21, 31: return "st"
//    case 2, 22: return "nd"
//    case 3, 23: return "rd"
//    default: return "th"
    
    func GetDateWith(formate: String , inputFormat:String) -> String {
        
        print("GetDateObject ==> \(self)")
            if self.count > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = inputFormat
                if let newdate = dateFormatter.date(from: self){
                    dateFormatter.dateFormat = formate
                    return dateFormatter.string(from: newdate)
                }else{
                     return self
                }
            }else {
                return ""
            }
    }
    
    
    func TimeAgoDate() -> Date {
        
        print(self)
        if self.characters.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateNew = dateFormatter.date(from: self)
            
            return dateNew!
        }else {
            return Date()
        }
    }
    
    
        func setUnderline()->NSAttributedString{
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: self, attributes: underlineAttribute)
            
            return underlineAttributedString
        }
        func setUnderLineForSpecific(str:String)->NSAttributedString{
            let range               = (self as NSString).range(of: str)
            let attributedString    = NSMutableAttributedString(string: self)
            
            
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range)
            return attributedString
            
        }
    
    func FloatValue() -> String{
        print(self)
        
        if self.characters.count > 0 {
            return  String(format: "%.2f", Double(self)!)
        }else {
            return  "0.0"
        }
    }
    
    func FloatWholeValue() -> String{
        print(self)
        
        if self.characters.count > 0 {
            return  String(format: "%.0f", Double(self)!)
        }else {
            return  "0"
        }
    }
}
extension Double{
    func round2digit() -> String {
        return  String(format: "%.2f", self)
    }
}
extension Notification.Name {
    static let budUnfollowed = Notification.Name("budUnfollowed")
}
extension UIViewController
{
    func showLoading() {
        self.view.showLoading()
    }
    
    func hideLoading() {
        self.view.hideLoading()
    }
    
    func ShowAlertWithDissmiss(message : String , AlertTitle : String = kErrorTitle) {
        self.oneBtnCustomeAlert(title: AlertTitle, discription: message) { (isBtnClik, btnNmbr) in
              self.dismiss(animated: true, completion: nil)
        }
    }
    func ShowAlertWithDim(message : String , AlertTitle : String = kErrorTitle,complition : @escaping(Bool) -> Void) {
        self.oneBtnCustomeAlert(title: AlertTitle, discription: message) { (isBtnClik, btnNmbr) in
            complition(true)
        }
    }
    func ShowErrorAlert(message : String , AlertTitle : String = kErrorTitle) {
       self.simpleCustomeAlert(title: AlertTitle, discription: message)
    }
    //,complition : @escaping(Bool,Int) -> Void
    func ShowLogoutAlert() {
        self.oneBtnCustomeAlert(title: "", discription: "Your session is expired. Please login again!") { (isComp, btn) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushLoginView"), object: nil)
        }
       
    }
}


@IBDesignable
class GradientView: UIView {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var leftGradientColor: UIColor? {
        didSet {
            setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
        }
    }
    
    @IBInspectable
    var rightGradientColor: UIColor? {
        didSet {
            setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
        }
    }
    
    private func setGradient(leftGradientColor: UIColor?, rightGradientColor: UIColor?) {
        if let leftGradientColor = leftGradientColor, let rightGradientColor = rightGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [leftGradientColor.cgColor, rightGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
