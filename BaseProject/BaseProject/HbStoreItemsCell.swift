//
//  HbStoreItemsCell.swift
//  BaseProject
//
//  Created by MAC MINI on 21/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class HbStoreItemsCell: UITableViewCell {
    var baseView : BaseViewController?
    var products_array : [[String : Any]]?
    @IBOutlet weak var Constraint_collection_view_height: NSLayoutConstraint!
    @IBOutlet weak var store_item_collectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.store_item_collectionview.delegate = self
        self.store_item_collectionview.dataSource = self
        self.store_item_collectionview.register(UINib.init(nibName: "StoreITemCell", bundle: nil), forCellWithReuseIdentifier: "StoreITemCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HbStoreItemsCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print((collectionView.bounds.size.width/2) - 6)
          return CGSize.init(width: (collectionView.bounds.size.width/2) - 6 , height: 215)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.products_array?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreITemCell", for: indexPath) as! StoreITemCell
        cell.data = self.products_array?[indexPath.row]
        cell.baseView = self.baseView
        cell.setUI()
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
