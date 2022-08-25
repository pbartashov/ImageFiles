//
//  SettingsStorage.swift
//  ImageFiles
//
//  Created by Павел Барташов on 22.08.2022.
//

import Combine

enum SortType: Int {
    case off = 0
    case ascending = 1
    case descending = 2
}

extension SortType {
    static let defaultValue: SortType = .ascending

    init(_ value: Int) {
        self = .init(rawValue: value) ?? SortType.defaultValue
    }
}

protocol SettingsStorageProtocol {
    var storedValueChanged: AnyPublisher<Void, Never> { get }

    func saveSortType(_ sortType: SortType)
    func restoreSortType() -> SortType
}
