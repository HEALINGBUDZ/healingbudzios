//
//  EvnetPaymentMethodsCell.swift
//  BaseProject
//
//  Created by Jawad on 8/16/18.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class EvnetPaymentMethodsCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDataSource {
     var array = [String]()
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var noPaymentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let paymentCellNib = UINib(nibName: "PaymentMethodCollectionViewCell", bundle: nil)
        collection_view.register(paymentCellNib, forCellWithReuseIdentifier: "PaymentMethodCollectionCell")
        collection_view.delegate = self
        collection_view.dataSource = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if array.count == 0 {
            self.collection_view.setEmptyMessage("No payment method found.", color: UIColor.init(hex: "7D7D7D").withAlphaComponent(0.6))
        }else {
            self.collection_view.setEmptyMessage("", color: UIColor.init(hex: "7D7D7D").withAlphaComponent(0.6))
        }
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodCollectionCell", for: indexPath) as! PaymentMethodCollectionViewCell
        cell.imageView.moa.url = self.array[indexPath.row]
        return cell
    }
    
}
