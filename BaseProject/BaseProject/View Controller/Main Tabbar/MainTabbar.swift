//
//  MainTabbar.swift
//  BaseProject
//
//  Created by macbook on 16/07/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import AVFoundation

class MainTabbar: UITabBarController,
UITabBarControllerDelegate  {

    
   var player:AVAudioPlayer = AVAudioPlayer()
    @discardableResult func playSound(named soundName: String) -> AVAudioPlayer {
        let audioPath = Bundle.main.path(forResource: soundName, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        player.volume = 0.2
        player.play()
        return player
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarSeparators()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        playSound(named: "click_hb")
        let indexOfTab = tabBar.items?.index(of: item)
        switch self.selectedIndex {
        case 0 , 1 , 2 , 3 ,4:
            let yourView = self.viewControllers![self.selectedIndex] as! UINavigationController
            _ = yourView.popToRootViewController(animated: false)
            break
        default:
            break
        }
        
        
        if indexOfTab! == 1 {
            
            let yourView = self.viewControllers![indexOfTab!] as! UINavigationController
            
            if (yourView.viewControllers.first?.isKind(of: QAMainVC.self))! {
                
            }else {
                let mainQA = self.storyboard?.instantiateViewController(withIdentifier: "QAMainVC") as! QAMainVC
                
                yourView.setViewControllers([mainQA], animated: true)
            }
            
            
            
            
        }
        
    }
    
    


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        print("Value is ===> \(tabBarController.selectedIndex)")
        
        let yourView = self.viewControllers![tabBarController.selectedIndex] as! UINavigationController
        _ = yourView.popToRootViewController(animated: false)
        
        return true
    }
    
    
    func setupTabBarSeparators() {
        let itemWidth = floor(self.tabBar.frame.size.width / CGFloat(self.tabBar.items!.count))
        
        // this is the separator width.  0.5px matches the line at the top of the tab bar
        let separatorWidth: CGFloat = 0.5
        
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...(self.tabBar.items!.count - 1) {
            // make a new separator at the end of each tab bar item
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 5, width: CGFloat(separatorWidth), height: self.tabBar.frame.size.height - 10))
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = UIColor.init(red: (58/255), green: (58/255), blue: (58/255), alpha: 1.0)
            
            self.tabBar.addSubview(separator)
        }
    }

}
