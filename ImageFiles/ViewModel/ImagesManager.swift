//
//  ImagesManager.swift
//  ImageFiles
//
//  Created by Павел Барташов on 15.08.2022.
//

import UIKit

final class ImagesManager {

    enum State {
        case initaial
        case itemAdded(at: Int)
        case itemRemoved(at: Int)
        case loadingCompleted
    }

    // MARK: - Properties

    private let storage = ImageFileStrorage()

    var imageFiles: [ImageFile] = []
    
    @Published var state = State.initaial

    var nextID: String {
        storage.nextFileName
    }

    // MARK: - Metods

    func loadStorage() {
        imageFiles.removeAll()
        
        for url in storage.content {
            if let image = UIImage(contentsOfFile: url.path) {
                imageFiles.append(image: image, url: url)
            }
        }

        state = .loadingCompleted
    }

    func saveToStorage(image: UIImage) {
        let imageName = nextID

        if let jpegData = image.jpegData(compressionQuality: 0.8),
           let url = storage.save(jpegData, to: imageName) {

            imageFiles.append(image: image, url: url)
            state = .itemAdded(at: imageFiles.count - 1)
        }
    }

    func delete(imageFile: ImageFile) {
        storage.remove(at: imageFile.url)

        if let index = imageFiles.firstIndex(where: { $0.url == imageFile.url }) {
            imageFiles.remove(at: index)
            state = .itemRemoved(at: index)
        }
    }
}

fileprivate extension Array where Element == ImageFile {
    mutating func append(image: UIImage, url: URL) {
        let imageFile = ImageFile(image: image, url: url)
        append(imageFile)
    }
}
