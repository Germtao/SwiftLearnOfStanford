//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by QDSG on 2019/10/16.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class ThemeChooseViewController: LoggingViewController, UISplitViewControllerDelegate {
    
    override var loggingName: String {
        return "Theme"
    }
    
    let themes = [
        "Sports": "⚽️🏀⚾️🏉🎾🏐🎱🏓🎳⛳️",
        "Faces": "😀☺️😂🥰🤪🤔🤗🙄🥶😒",
        "Animals": "🐶🐭🦊🐷🙉🦁🐯🐼🐔🐴"
    ]
    
    // iPhone上的细节
    private var lastSeguedToDetailController: ConcentrationViewController?
    
    // iPad上的细节
    private var splitViewDetailController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    @IBAction func changeTheme(_ sender: Any) {
//        if let cvc = splitViewDetailController {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
//                cvc.theme = theme
//            }
//        } else if let cvc = lastSeguedToDetailController {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
//                cvc.theme = theme
//            }
//            navigationController?.pushViewController(cvc, animated: true)
//        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle,
                let theme = themes[themeName] {
                if let vc = segue.destination as? ConcentrationViewController {
                    vc.theme = theme
                    lastSeguedToDetailController = vc
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // 折叠
            }
        }
        return false
    }
}
