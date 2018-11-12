//
//  RewardsTabCell.swift
//  BaseProject
//
//  Created by MAC MINI on 20/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
protocol TabClickListner {
    func OnClickFreePointsTab(index : Int)
    func OnClickPointsLogTab(index : Int)
    func OnClickHbStoreTab(index : Int)
}
class RewardsTabCell: UITableViewCell {

    var tab_clickListner_delegate: TabClickListner?
    @IBOutlet weak var view_free_points: UIView!
    @IBOutlet weak var view_points_log: UIView!
    @IBOutlet weak var view_hb_store: UIView!
    
    
    
    @IBOutlet weak var Btn_hb_store: UIButton!
    @IBOutlet weak var btn_points_logs: UIButton!
    @IBOutlet weak var Btn_free_points: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func OnClickFreePints(_ sender: Any) {
       self.view_free_points.backgroundColor = UIColor.init(hex: "82BB2C")
        self.view_points_log.backgroundColor = UIColor.clear
         self.view_hb_store.backgroundColor = UIColor.clear
        tab_clickListner_delegate?.OnClickFreePointsTab(index: self.tag)
    }
    @IBAction func OnClickPointsLog(_ sender: Any) {
        self.view_points_log.backgroundColor = UIColor.init(hex: "82BB2C")
        self.view_free_points.backgroundColor = UIColor.clear
        self.view_hb_store.backgroundColor = UIColor.clear
        tab_clickListner_delegate?.OnClickPointsLogTab(index: self.tag)
    }
    @IBAction func OnClickHBStore(_ sender: Any) {
        self.view_hb_store.backgroundColor = UIColor.init(hex: "82BB2C")
        self.view_points_log.backgroundColor = UIColor.clear
        self.view_free_points.backgroundColor = UIColor.clear
        tab_clickListner_delegate?.OnClickHbStoreTab(index: self.tag)
    }
}
