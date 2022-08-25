//
//  LoginError.swift
//  ImageFiles
//
//  Created by Павел Барташов on 19.08.2022.
//

import Foundation

enum LoginError: Error {
    case unknown
    case wrongPassword
    case passwordsMismatch
}

extension LoginError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .unknown:
                return NSLocalizedString("Ошибка при авторизации. Попробуйте еще раз.", comment: "")

            case .wrongPassword:
                return NSLocalizedString("Неверный пароль.", comment: "")

            case .passwordsMismatch:
                return NSLocalizedString("Введенные пароли не совпадают.", comment: "")
        }
    }
}
