//
//  ImagesManager.swift
//  ImageFiles
//
//  Created by Павел Барташов on 15.08.2022.
//

import UIKit
import Combine

final class ImagesManager {

    enum State {
        case initaial
        case itemAdded(at: Int)
        case itemRemoved(at: Int)
        case loadingCompleted
    }

    // MARK: - Properties

    private let storage = ImageFileStrorage()
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()

    var imageFiles: [ImageFile] = []
    
    @Published var state = State.initaial

    var nextID: String {
        storage.nextFileName
    }


    private var subscription: AnyCancellable?

    // MARK: - LifeCicle

    init() {
        defer {
            subscription = settingsStorage.storedValueChanged
                .sink { [weak self] in
                    self?.loadImageFilesSorted()
                }
        }
    }

    // MARK: - Metods


    func loadStorage() {
        imageFiles.removeAll()
        loadImageFilesSorted()
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

    private func loadImageFilesSorted() {
        let sortType = settingsStorage.restoreSortType()

        if imageFiles.isEmpty || sortType == .off {
            imageFiles = storage.content
                .compactMap {
                    ImageFile(image: UIImage(contentsOfFile: $0.path),
                              url: $0)
                }
        }

        switch sortType {
            case .off:
                break

            case .ascending:
                imageFiles.sort { $0.url < $1.url }

            case .descending:
                imageFiles.sort { $0.url > $1.url }
        }

        state = .loadingCompleted
    }
}

fileprivate extension Array where Element == ImageFile {
    mutating func append(image: UIImage, url: URL) {
        let imageFile = ImageFile(image: image, url: url)
        append(imageFile)
    }
}

fileprivate extension URL {
    static func < (lhs: URL, rhs: URL) -> Bool {
        lhs.lastPathComponent < rhs.lastPathComponent
    }

    static func > (lhs: URL, rhs: URL) -> Bool {
        lhs.lastPathComponent > rhs.lastPathComponent
    }
}
