//
//  TextfieldViewCell.swift
//  EmojiArt
//
//  Created by QDSG on 2019/12/10.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class TextfieldViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet private weak var textfield: UITextField! {
        didSet {
            textfield.delegate = self
        }
    }
    
    var inputClosure: ((String?) -> Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputClosure?(textField.text)
    }
    
    func beginEditing() {
        textfield?.becomeFirstResponder()
    }
    
}
