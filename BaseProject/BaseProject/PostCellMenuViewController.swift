//
//  PostCellMenuViewController.swift
//  BaseProject
//
//  Created by MAC MINI on 28/03/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
import KUIPopOver

class PostCellMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems = [
        (image: #imageLiteral(resourceName: "QAShare"), name: "Share Post"),
        (image: #imageLiteral(resourceName: "QAReport"), name: "Report"),
        (image: #imageLiteral(resourceName: "QAShare"), name: "Mute this post"),
        (image: #imageLiteral(resourceName: "QAShare"), name: "Unfollow this bud")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - Private Methods
extension PostCellMenuViewController    {
    fileprivate func configure()    {
        let postMoreCellNib = UINib(nibName: Cell.identifier, bundle: nil)
        tableView.register(postMoreCellNib, forCellReuseIdentifier: Cell.identifier)
    }
}

/*extension PostCellMenuViewController: KUIPopOverUsable  {
    var contentSize: CGSize {
        return CGSize(width: 200, height: 150)
    }
    
    var arrowDirection: UIPopoverArrowDirection {
        return .up
    }
}*/

extension PostCellMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? PostMoreTableViewCell
        
        let menuItem = menuItems[indexPath.row]
        cell?.imageView?.image = menuItem.image
        
        cell?.nameLabel?.text = menuItem.name
        return cell!
    }
}

fileprivate struct Cell   {
    static let identifier = "PostMoreTableViewCell"
}
