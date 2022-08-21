//
//  KeychainAuthService.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import Foundation

protocol AuthServiceProtocol {
    var hasSavedPassword: Bool { get }
    func isValid(password: String) -> Bool
    func save(password: String) throws
    func update(password: String) throws
    func deletePassword() throws
}

struct KeychainAuthService: AuthServiceProtocol {

    // MARK: - Properties

    private let keychain = Keychain()

    var hasSavedPassword: Bool {
        let credentials = KeychainCredentials(password: "")
        return (try? keychain.retrievePassword(with: credentials)) != nil
   }

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods


    func isValid(password: String) -> Bool {
        let credentials = KeychainCredentials(password: password)
        do {
            let savedPassword = try keychain.retrievePassword(with: credentials)
            return savedPassword == password
        } catch {
            return false
        }
    }

    func save(password: String) throws {
        try keychain.setPassword(with: KeychainCredentials(password: password))
    }

    func update(password: String) throws {
        try keychain.updatePassword(with: KeychainCredentials(password: password))
    }

    func deletePassword() throws {
        try keychain.deletePassword(with: KeychainCredentials(password: ""))
    }
}
