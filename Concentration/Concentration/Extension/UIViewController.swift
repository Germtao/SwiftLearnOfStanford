//
//  UIViewController.swift
//  Concentration
//
//  Created by QDSG on 2019/10/18.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

extension UIViewController {
    var contents: UIViewController {
        if let navc = self as? UINavigationController {
            return navc.visibleViewController ?? self
        } else {
            return self
        }
    }
}
