//
//  MediaPostTableViewCell.swift
//  BaseProject
//
//  Created by Yasir Ali on 30/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit

class MediaPostTableViewCell: TextPostTableViewCell {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        MediacollectionViewLayout.minimumLineSpacing = 0
        MediacollectionViewLayout.minimumInteritemSpacing = 0
        
        configureCollectionViewLayoutItemSize()
        pageControl.currentPage = 0
        let postImageCellNib = UINib(nibName: PostImageCell.identifier, bundle: nil)
        MediacollectionView!.register(postImageCellNib, forCellWithReuseIdentifier: PostImageCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCollectionViewLayoutItemSize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        MediacollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    
    
    private func configureCollectionViewLayoutItemSize()    {
        MediacollectionView.invalidateIntrinsicContentSize()
        
        MediacollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        MediacollectionViewLayout.itemSize = MediacollectionView!.frame.size
        MediacollectionViewLayout.collectionView!.reloadData()
    }
    
    override func display(post: Post, parentVC: UIViewController!) {
        super.display(post: post, parentVC: parentVC)
        
        pageControl.numberOfPages = post.files!.count
        pageControl.currentPage = 0
        
        configureCollectionViewLayoutItemSize()
        MediacollectionView.layoutSubviews()
        MediacollectionView.layoutIfNeeded()
    }
}

//extension MediaPostTableViewCell {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return post.files?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCell.identifier, for: indexPath) as! PostImageCollectionViewCell
//        let file = post.files![indexPath.item]
//        collectionViewLayout.itemSize = collectionView.frame.size
//        cell.display(file: file)
//        return cell
//    }
//}

fileprivate struct PostImageCell    {
    static let identifier = "PostImageCollectionViewCell"
}

