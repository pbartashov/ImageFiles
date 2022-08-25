//
//  UITextField+.swift
//  ImageFiles
//
//  Created by Павел Барташов on 19.08.2022.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher()
    }

    var textUnwrapped: String {
        get {
            text ?? ""
        }
        set {
            text = newValue
        }
    }
}
