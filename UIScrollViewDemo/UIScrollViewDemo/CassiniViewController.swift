//
//  CassiniViewController.swift
//  UIScrollViewDemo
//
//  Created by QDSG on 2019/10/18.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = ImageURLs.NASA[identifier] {
                if let imageVC = segue.destination.contents as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navc = self as? UINavigationController {
            return navc.visibleViewController ?? self
        } else {
            return self
        }
    }
}
