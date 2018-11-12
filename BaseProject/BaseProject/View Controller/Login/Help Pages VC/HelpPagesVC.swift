//
//  HelpPagesVC.swift
//  BaseProject
//
//  Created by macbook on 08/08/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit

class HelpPagesVC: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet var scroller: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var scrollPagesLoaded = false
    var colorArray = ["3A3A3A","579129","166FB2","E2B200","721D6F"]
//    3A3A3A
//    166FB2 ,"EC8105"
//    EC8105,"579129"
//    579129
//    E2B200
//    721D6F
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
        
    }
    override func viewDidLayoutSubviews() {
        if (scrollPagesLoaded == false) {
            scrollPagesLoaded = true
            
            var tutorialsXibs = Bundle.main.loadNibNamed("TutorialViews", owner: self, options: nil)
            tutorialsXibs?.remove(at: 3)
            tutorialsXibs?.remove(at: 3)
            pageControl.numberOfPages = 5
            for i in 0...4 {
                let view = tutorialsXibs?[i] as! TutorialViews
                view.frame = CGRect.init(x: CGFloat(i)*scroller.frame.size.width, y: 0, width: scroller.frame.size.width, height: scroller.frame.height)
                scroller.addSubview(view)
            }
            
            scroller.contentSize = CGSize.init(width: scroller.frame.size.width * 5, height: scroller.frame.size.height)
            
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.view.tintColor =  UIColor.init(hex: colorArray[Int(pageNumber)])
        self.view.backgroundColor = UIColor.init(hex: colorArray[Int(pageNumber)])
        pageControl.currentPage = Int(pageNumber)
    }
}
