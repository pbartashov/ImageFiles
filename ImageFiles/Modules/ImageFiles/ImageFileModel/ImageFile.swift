//
//  ImageFile.swift
//  ImageFiles
//
//  Created by Павел Барташов on 15.08.2022.
//

import UIKit

struct ImageFile {
    let image: UIImage
    let url: URL
}

extension ImageFile {
    init?(image: UIImage?, url: URL?) {
        guard let image = image, let url = url else { return nil }
        self.init(image: image, url: url)
    }
}
