//
//  LoginService.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import Foundation

struct LoginService {
    
    // MARK: - Properties

    private let authService: AuthServiceProtocol

    var hasSavedPassword: Bool {
        authService.hasSavedPassword
    }

    // MARK: - LifeCicle

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - Metods

    func check(password: String) throws {
        guard authService.isValid(password: password) else { throw LoginError.wrongPassword }
    }

    func save(password: String) throws {
        do {
            try authService.save(password: password)
        } catch {
            throw LoginError.unknown
        }
    }

    func update(password: String) throws {
        do {
            try authService.update(password: password)
        } catch {
            throw LoginError.unknown
        }
    }

    func deletePassword() throws {
        do {
            try authService.deletePassword()
        } catch {
            throw LoginError.unknown
        }
    }
}
