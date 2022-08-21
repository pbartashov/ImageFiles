//
//  LoginViewModel.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import Combine
import Foundation
import UIKit

final class LoginViewModel {

    enum State: String {
        case initial = " "
//        case changePassword = "Сменить пароль"
        case createPassword = "Создать пароль"
        case confirmPassword = "Повторите пароль"
        case enterPassword = "Введите пароль"
    }
    
    // MARK: - Properties

    private let loginService: LoginService
    private weak var coordinator: MainCoordinator?

    private var subscriptions: Set<AnyCancellable> = []

    @Published var password = ""
    private var previousPassword: String?

    @Published var buttonTitle = ""

    private var state: State = .initial {
        didSet {
            buttonTitle = state.rawValue
        }
    }


//    @Published private(set) var title = ""


    private(set) lazy var isInputValid = $password
        .map { $0.count >= 4 }
        .eraseToAnyPublisher()

    private(set) lazy var loginFinishedSuccessfully = PassthroughSubject<Bool, Never>()
    private let isChangePasswordMode: Bool

    // MARK: - Views

    // MARK: - LifeCicle

    init(coordinator: MainCoordinator,
         loginService: LoginService,
         isChangePasswordMode: Bool = false
//         initalState: State = .initial

    ) {
        self.loginService = loginService
        self.coordinator = coordinator
        self.isChangePasswordMode = isChangePasswordMode
//        self.state = initalState
    }

    // MARK: - Metods

//    func subscribe(toUserAction inputPublisher: AnyPublisher<LoginViewController.UserAction, Never>) {
//        let publisher = inputPublisher
//            .debounce(for: 0.3, scheduler: DispatchQueue.main)
//            .share()
//            .eraseToAnyPublisher()
//
//        publisher
//            .convertToPassword()
//            .assign(to: &$password)
//
//        publisher
//            .sink { [weak self] in
//                if case .tapButton(let button) = $0,
//                   button == .next {
//                    self?.coordinator?.switchToMainViewController()
//                }
//            }
//            .store(in: &subsriptions)
//
//    }
    func subscribe(toUserTapButton publisher: AnyPublisher<LoginViewController.Button, Never>) {
        publisher
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink(receiveValue: handleUserTapButton)
            .store(in: &subscriptions)

        func handleUserTapButton(_ button: LoginViewController.Button) {
            if button == .next {
                switch state {
                    case .initial:
                        state = !isChangePasswordMode && loginService.hasSavedPassword ? .enterPassword : .createPassword

//                    case .changePassword:
//                        state = .createPassword

                    case .createPassword:
                        previousPassword = password
                        state = .confirmPassword

                    case .confirmPassword:
                        if let previousPassword = previousPassword,
                           previousPassword == password {
                            handleNewPassword(password)
                        } else {
                            coordinator?.showError(LoginError.passwordsMismatch)
                            state = .createPassword
                        }

                        previousPassword = nil


                    case .enterPassword:
                        checkPassword()

                }
//                print(password)
                password = ""

            }
        }

        func checkPassword() {
            do {
                try loginService.check(password: password)
//                coordinator?.switchToMainViewController()
                loginFinishedSuccessfully.send(true)
            } catch {
                coordinator?.showError(error)
            }
        }

        func handleNewPassword(_ password: String) {
            do {
                if isChangePasswordMode {
                    try loginService.deletePassword()
                }
                
                try loginService.save(password: password)
//                coordinator?.switchToMainViewController()
                loginFinishedSuccessfully.send(true)
            } catch {
                coordinator?.showError(error)
                state = .createPassword
            }
        }
    }
}

//
//fileprivate extension AnyPublisher where Output == LoginViewController.UserAction, Failure == Never {
//    func convertToPassword() -> AnyPublisher<String, Never> {
//        compactMap {
//            if case .enterPassword(let password) = $0 {
//                return password
//            }
//
//            return nil
//        }
//        .eraseToAnyPublisher()
//    }
//}
