//
//  KeychainError.swift
//  ImageFiles
//
//  Created by Павел Барташов on 19.08.2022.
//

import Foundation


enum KeychainError: Error {
    case common(String?)
    case encodingFailed
    case decodingFailed
    case passwordNotFound
    case error(description: String, code: Int32)

}

extension KeychainError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .common(let text):
                if let text = text {
                    return NSLocalizedString(text, comment: "")
                }
                return NSLocalizedString("Неизвестная ошибка в Keychain", comment: "")

            case .encodingFailed:
                return NSLocalizedString("Ошибка при кодировании пароля", comment: "")

            case .decodingFailed:
                return NSLocalizedString("Ошибка при декодировании пароля", comment: "")

            case .passwordNotFound:
                return NSLocalizedString("Пароль не найден", comment: "")

            case let .error(description, code):
                return NSLocalizedString("\(description): \(convert(status: code))", comment: "")
        }
    }

    func convert(status: OSStatus) -> String {
        switch status {
            case errSecSuccess:
                return "Keychain Status: No error"
            case errSecUnimplemented:
                return "Keychain Status: Function or operation not implemented"
            case errSecIO:
                return "Keychain Status: I/O error (bummers)"
            case errSecOpWr:
                return "Keychain Status: File already open with with write permission"
            case errSecParam:
                return "Keychain Status: One or more parameters passed to a function where not valid"
            case errSecAllocate:
                return "Keychain Status: Failed to allocate memory"
            case errSecUserCanceled:
                return "Keychain Status: User canceled the operation"
            case errSecBadReq:
                return "Keychain Status: Bad parameter or invalid state for operation"
            case errSecInternalComponent:
                return "Keychain Status: Internal Component"
            case errSecNotAvailable:
                return "Keychain Status: No keychain is available. You may need to restart your computer"
            case errSecDuplicateItem:
                return "Keychain Status: The specified item already exists in the keychain"
            case errSecItemNotFound:
                return "Keychain Status: The specified item could not be found in the keychain"
            case errSecInteractionNotAllowed:
                return "Keychain Status: User interaction is not allowed"
            case errSecDecode:
                return "Keychain Status: Unable to decode the provided data"
            case errSecAuthFailed:
                return "Keychain Status: The user name or passphrase you entered is not correct"
            default:
                return "Keychain Status: Unknown. (\(status))"
        }
    }
}
