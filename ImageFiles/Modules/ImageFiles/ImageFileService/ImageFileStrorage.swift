//
//  ImageFileStrorage.swift
//  ImageFiles
//
//  Created by Павел Барташов on 15.08.2022.
//

import Foundation

struct ImageFileStrorage {

    // MARK: - Properties

    private let documentsUrl: URL

    var content: [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                               includingPropertiesForKeys: nil,
                                                               options: [.skipsHiddenFiles])
        } catch {
            print("Error while reading Documents directory: \(error)")
        }

        return []
    }

    var nextFileName: String {
        var number = 0
        let urls = content.sorted { $0.lastPathComponent > $1.lastPathComponent }

        for url in urls {
            if let n = Int(url.lastPathComponent) {
                number = n + 1
                break
            }
        }

        return String(format: "%09d", number)
    }

    // MARK: - LifeCicle

    init() {
        do {
            documentsUrl = try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
        } catch {
            fatalError("Error while accessing to Documents directory")
        }
    }

    // MARK: - Metods

    func save(_ data: Data, to fileName: String) -> URL? {
        let url = documentsUrl.appendingPathComponent(fileName)
        let success = FileManager.default.createFile(atPath: url.path,
                                                     contents: data,
                                                     attributes: nil)
        return success ? url : nil
    }

    func remove(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error while saving: \(error)")
        }
    }
}
