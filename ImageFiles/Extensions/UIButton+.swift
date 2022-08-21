//
//  UIButton+.swift
//  ImageFiles
//
//  Created by Павел Барташов on 19.08.2022.
//

import UIKit

extension UIButton {
    var titleForNormal: String {
        get {
            title(for: .normal) ?? ""
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
}
