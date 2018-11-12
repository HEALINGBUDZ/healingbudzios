//
//  StoreITemCell.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class StoreITemCell: UICollectionViewCell {
    var data : [String : Any]?
    var baseView : BaseViewController?
    
    @IBOutlet weak var Btn_Redeem_rewards: UIButton!
    @IBOutlet weak var Lbl_product_points: UILabel!
    @IBOutlet weak var IMG_product_img: UIImageView!
    
    @IBOutlet weak var Lbl_product_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func OnClickRedeemReward(_ sender: Any) {
        self.baseView?.OpenClaimRewardAlert(reward_data: data!)
    }
    func setUI() {
        
        if let attachment = data?["attachment"] as? String {
            self.IMG_product_img.moa.url = WebServiceName.images_baseurl.rawValue + attachment.RemoveSpace()
        }
        self.Lbl_product_name.text = data?["name"] as? String
        if let points = data?["points"] as? NSNumber {
            self.Lbl_product_points.text = "\(points.intValue) Points"
            if points.intValue > MyRewardsVC.total_points.intValue {
                self.Btn_Redeem_rewards.setTitle("Get Enough Points", for: .normal)
                self.Btn_Redeem_rewards.backgroundColor = UIColor.lightGray
                self.Btn_Redeem_rewards.isEnabled = false
            }else{
               self.Btn_Redeem_rewards.setTitle("Redeem Reward", for: .normal)
               self.Btn_Redeem_rewards.backgroundColor = UIColor.init(hex: "82BC2B")
               self.Btn_Redeem_rewards.isEnabled = true
            }
        }else{
            self.Lbl_product_points.text = "0 Points"
        }
        
    }
}
