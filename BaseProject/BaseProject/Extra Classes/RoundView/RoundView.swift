//
//  SaveMeView.swift
//  SaveMe
//
//  Created by Vengile on 20/03/2017.
//  Copyright © 2017 Vengile. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
	override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.clear.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RoundViewRewardItem: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.init(hex: "5C5D5D").cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class BudzMapRoundFeaturedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
         self.roundCorners(corners: [.topLeft, .bottomLeft], radius: 12)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewTopCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RoundViewRightCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.roundCorners(corners: [.bottomRight, .topRight], radius: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewLeftCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.roundCorners(corners: [.bottomLeft, .topLeft], radius: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewBottomCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class RoundWhiteCornerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
//        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.init(red: (206/255), green: (204/255), blue: (206/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class StrainRoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class JournelRoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.init(red: (124/255), green: (193/255), blue: (69/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class Strainroundview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (246/255), green: (195/255), blue: (80/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class StrainRedRoundview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (194/255), green: (68/255), blue: (98/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class StrainGreenRoundview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (124/255), green: (194/255), blue: (68/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class StrainPurpleRoundview: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (174/255), green: (89/255), blue: (194/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIImageView {
     func RoundView()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func roundViewRemove()  {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
//class CircleImageView: UIImageView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        //custom logic goes here
//        self.CornerRadious()
//    }
//
//    override func CornerRadious()  {
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = self.frame.size.height/2
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}



class RoundViewWithGrayBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (107/255), green: (102/255), blue: (93/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


extension UIView {
    
    
    func  StrainRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (107/255), green: (102/255), blue: (93/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    
    func CornerRadious(WithColor : UIColor)  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = WithColor.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
}
//    func DashBorder(){
//        
//        let color = UIColor.lightGray.cgColor
//        
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        var frameSize = self.frame.size
////        frameSize.width = UIScreen.main.bounds.size.width - 20
//        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//        
//        shapeLayer.bounds = shapeRect
//        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = color
//        shapeLayer.lineWidth = 2
//        shapeLayer.lineJoin = kCALineJoinRound
//        shapeLayer.lineDashPattern = [6,3]
//        
//        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
//        
//        self.layer.addSublayer(shapeLayer)
//        
////        let viewBorder = CAShapeLayer()
////        print(self.frame)
////        viewBorder.strokeColor = UIColor.white.cgColor
////        viewBorder.lineDashPattern = [2, 2]
////        viewBorder.frame = self.frame
////        viewBorder.fillColor = nil
////        viewBorder.path = UIBezierPath(rect: self.frame).cgPath
////        self.layer.addSublayer(viewBorder)
//    }
//}


class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = UIColor.white.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).cgPath
        _border.frame = self.bounds
    }
}


class DashedBorderCornerView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = UIColor.white.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:0).cgPath
        _border.frame = self.bounds
    }
}


class CircleLabelWhite: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.CornerRadious()
    }
    
    override func CornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
