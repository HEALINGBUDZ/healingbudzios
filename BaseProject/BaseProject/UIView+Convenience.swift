//
//  UIView+Convenience.swift
//  iKioska
//
//  Created by Adnan Ahmad on 24/09/2017.
//  Copyright © 2017 Adnan Ahmad. All rights reserved.
//

import UIKit
extension UIView
{
    static func loadFromXib<T>(withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}
