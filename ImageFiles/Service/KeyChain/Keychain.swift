//
//  Keychain.swift
//  ImageFiles
//
//  Created by Павел Барташов on 19.08.2022.
//

import Foundation

struct Keychain {

    // MARK: - Properties

//    let kSecAttrService: String
//    let kSecAttrAccount: String

    // MARK: - Views

    // MARK: - LifeCicle
//    init(kSecAttrService: String = "ImageFilesPassword",
//         kSecAttrAccount: String = "ImageFilesUser") {
//        self.kSecAttrService = kSecAttrService
//        self.kSecAttrAccount = kSecAttrAccount
//    }

    // MARK: - Metods

    func setPassword(with credentials: KeychainCredentials) throws {
        // Переводим пароль в объект типа Data.
        guard let passwordData = credentials.password.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }

        // Создаем атрибуты для хранения файла.
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passwordData,
            kSecAttrAccount: credentials.username,
            kSecAttrService: credentials.serviceName,
        ] as CFDictionary

        // Добавляем новую запись в Keychain. nil - указатель на объекты, которые были добавлены в базу данных Keychain.
        let status = SecItemAdd(attributes, nil)

        guard status == errSecSuccess else {
            throw KeychainError.error(description: "Невозможно добавить пароль", code: status)
        }
    }

    func retrievePassword(with credentials: KeychainCredentials) throws -> String {
        // Создаем поисковые атрибуты.
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecAttrAccount: credentials.username,
            kSecReturnData: true
        ] as CFDictionary

        // Объявляем ссылку на объект, которая в будущем будет указывать на полученную запись Keychain.
        var extractedData: AnyObject?
        // Запрашиваем запись в Keychain.
        let status = SecItemCopyMatching(query, &extractedData)

        guard status != errSecItemNotFound else {
            throw KeychainError.passwordNotFound
        }

        guard status == errSecSuccess else {
            throw KeychainError.error(description: "Невозможно получить пароль", code: status)
        }

        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            throw KeychainError.decodingFailed
        }

        return password
    }

    func updatePassword(with credentials: KeychainCredentials) throws {
        // Переводим пароль в объект типа Data.
        guard let passData = credentials.password.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }

        // Создаем поисковые атрибуты.
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecAttrAccount: credentials.username,
            kSecReturnData: false // Не обязательно, false по-умолчанию.
        ] as CFDictionary

        let attributesToUpdate = [
            kSecValueData: passData,
        ] as CFDictionary

        let status = SecItemUpdate(query, attributesToUpdate)

        guard status == errSecSuccess else {
            throw KeychainError.error(description: "Невозможно обновить пароль", code: status)
        }
    }

    func deletePassword(with credentials: KeychainCredentials) throws {
        // Создаем поисковые атрибуты
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecAttrAccount: credentials.username,
            kSecReturnData: false  // Не обязательно, false по-умолчанию.
        ] as CFDictionary

        let status = SecItemDelete(query)

        guard status == errSecSuccess else {
            throw KeychainError.error(description: "Невозможно удалить пароль", code: status)
        }
    }
}

