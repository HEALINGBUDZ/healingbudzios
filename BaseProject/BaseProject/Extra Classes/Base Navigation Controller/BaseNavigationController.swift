//
//  BaseNavigationController.swift
//  Wave
//
//  Created by Vengile on 07/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
	
    @IBOutlet weak var bar_item_qa: UITabBarItem!
    
	/****************************************************************************************************************/
	// MARK: - Override Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationBar.isTranslucent = true
		delegate = self;
//        bar_item_qa.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
//        bar_item_qa.image?.size = CGSize.init(width: 40, height: 40)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	/****************************************************************************************************************/
	// MARK: - Class Methods
	
	func AddTitle(_ target: UIViewController, title : String) {
		let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30.0))
		titleLabel.text = title;
		titleLabel.textColor = UIColor.white
		titleLabel.backgroundColor = UIColor.clear
		titleLabel.textAlignment = .center
		titleLabel.font = UIFont.init(name: "HelveticaNeue-Medium", size: 15.0)
		target.navigationItem.titleView = titleLabel
	}
		
	
    func AddViewInTitle(_ target: UIViewController , viewMain : UIView){

		target.navigationItem.titleView = viewMain
		
	}

    
    func AddImageInTitle(_ target: UIViewController){
        let logo = UIImage(named: "logo")
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 35))
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit
        target.navigationItem.titleView = imageView
        
    }

    
	
	func AddBackGroundImage() {

		navigationBar.barTintColor = UIColor.black
		
	}
	
	func addMenuButtonOn(_ target: UIViewController, selector: Selector) {
		let button = UIButton.init(frame: CGRect(x: 0 , y: 0, width: 10, height: 10.0))
//		button.setImage(UIImage.init(named: "menu"), for: .normal)
		button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
		
        button.backgroundColor = UIColor.init(red: 0.129, green: 0.129, blue: 0.129, alpha: 1.0)
		let barButtonItem = UIBarButtonItem.init(customView: button)
		target.navigationItem.leftBarButtonItem = barButtonItem
	}
	
	func addRightButton(_ target: UIViewController, selector: Selector , image : UIImage) {
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50.0, height: 30.0))
		button.setImage(image, for: .normal)
		
		button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
		
		let barButtonItem = UIBarButtonItem.init(customView: button)
		target.navigationItem.rightBarButtonItem = barButtonItem
	}
    
    func RemoveRightButton(_ target: UIViewController) {
        
        
        
        target.navigationItem.rightBarButtonItem = nil
    }
    
    
	
	func addRLeftButton(_ target: UIViewController, selector: Selector , image : UIImage) {
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25.0, height: 30.0))
		button.setImage(image, for: .normal)
		
		button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
		
		let barButtonItem = UIBarButtonItem.init(customView: button)
		target.navigationItem.leftBarButtonItem = barButtonItem
	}
	
	
    func addRightButtonWithTitle(_ target: UIViewController, selector: Selector , lblText : String ,widthValue : Double ) {
		
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: widthValue, height: 30.0))
		button.setTitle(lblText, for: .normal)
		button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
		button.titleLabel!.font =  UIFont.systemFont(ofSize: 12.0)
		button.backgroundColor = UIColor.clear
		
		
		let barButtonItem = UIBarButtonItem.init(customView: button)
		target.navigationItem.rightBarButtonItem = barButtonItem
	}
	
	
    
    func addRightButton(_ target: UIViewController, selector: Selector , lblText : String , lblText2 : String , lblText3 : String) {
        
        
        
        
        let viewMain  = UIView.init(frame: CGRect(x: 0, y: -1, width: 100.0, height: 60.0))
        viewMain.backgroundColor = UIColor.clear
        
        
        
        let labelMain = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100.0, height: 15.0))
        labelMain.backgroundColor = UIColor.clear
        labelMain.font = UIFont.boldSystemFont(ofSize: 12.0)
        labelMain.textColor = UIColor.init(red: 0.9843, green: 0.996, blue: 0.2901, alpha: 1.0)
        labelMain.textAlignment = NSTextAlignment.center
        labelMain.tag = 100
        labelMain.text = lblText
        
        
        let labelMain1 = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100.0, height: 15.0))
        labelMain1.backgroundColor = UIColor.clear
        labelMain1.font = UIFont.systemFont(ofSize: 10.0)
        labelMain1.textColor = UIColor.init(red: 0.9843, green: 0.996, blue: 0.2901, alpha: 1.0)
        labelMain1.tag = 99
        labelMain1.textAlignment = NSTextAlignment.center
        labelMain1.text = lblText2
        
        
        let labelMain2 = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100.0, height: 15.0))
        labelMain2.backgroundColor = UIColor.clear
        labelMain2.font = UIFont.systemFont(ofSize: 10.0)
        labelMain2.textColor = UIColor.init(red: 0.9843, green: 0.996, blue: 0.2901, alpha: 1.0)
        labelMain2.tag = 101
        labelMain2.textAlignment = NSTextAlignment.center
        labelMain2.text = lblText3
        
        
        let button = UIButton.init(frame: viewMain.frame)
        button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.clear
        
        
        if (lblText.characters.count > 0 ) {
            viewMain.addSubview(labelMain)
            
            
            if (lblText2.characters.count > 0 ) {
                viewMain.addSubview(labelMain1)
            }
            
            if (lblText3.characters.count > 0 ) {
                viewMain.addSubview(labelMain2)
            }
         viewMain.addSubview(button)   
        }
        
        
        
        
        
        
        
        
        
        labelMain.center = viewMain.center
        labelMain1.center = CGPoint.init(x: viewMain.center.x, y: viewMain.center.y - 15)
        labelMain2.center = CGPoint.init(x: viewMain.center.x, y: viewMain.center.y + 15)
        
//        let barButtonItem = UIBarButtonItem.init(customView: viewMain)
//        target.navigationItem.rightBarButtonItem = barButtonItem
        target.navigationItem.titleView = viewMain
    }
    
	
	func addBackButtonOn(_ target: UIViewController, selector: Selector) {
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
		button.setImage(UIImage.init(named: "Back-Arrow"), for: UIControlState())
		button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
		
		let barButtonItem = UIBarButtonItem.init(customView: button)
		target.navigationItem.leftBarButtonItem = barButtonItem
	}
}
