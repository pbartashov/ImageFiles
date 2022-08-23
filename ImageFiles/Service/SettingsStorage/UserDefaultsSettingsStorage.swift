//
//  UserDefaultsSettingsStorage.swift
//  ImageFiles
//
//  Created by Павел Барташов on 22.08.2022.
//

import Foundation


import Combine

final class SettingsStorage: SettingsStorageProtocol {

    enum Constants {
        static let imageFilesSortTypeName = "com.imageFiles.sortType"
    }

    // MARK: - Properties

    private let userDefaults = UserDefaults.standard

    var storedValueChanged: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification, object: nil)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    // MARK: - Metods

    func saveSortType(_ sortType: SortType) {
        let key = Constants.imageFilesSortTypeName
        let toSave = sortType.rawValue

        userDefaults.set(toSave, forKey: key)
    }

    func restoreSortType() -> SortType {
        guard let saved = userDefaults.object(forKey: Constants.imageFilesSortTypeName) as? Int else {
            return .defaultValue
        }
        
        return SortType(saved)
    }
}
