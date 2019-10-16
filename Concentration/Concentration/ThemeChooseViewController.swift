//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by QDSG on 2019/10/16.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class ThemeChooseViewController: UIViewController {
    
    let themes = [
        "Sports": "⚽️🏀⚾️🏉🎾🏐🎱🏓🎳⛳️",
        "Faces": "😀☺️😂🥰🤪🤔🤗🙄🥶😒",
        "Animals": "🐶🐭🦊🐷🙉🦁🐯🐼🐔🐴"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle,
                let theme = themes[themeName] {
                if let vc = segue.destination as? ConcentrationViewController {
                    vc.theme = theme
                }
            }
        }
    }
}
