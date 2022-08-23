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

    private(set) lazy var isInputValid = $password
        .map { $0.count >= 4 }
        .eraseToAnyPublisher()

    private(set) lazy var loginFinishedSuccessfully = PassthroughSubject<Bool, Never>()
    private let isChangePasswordMode: Bool

    // MARK: - LifeCicle

    init(coordinator: MainCoordinator,
         loginService: LoginService,
         isChangePasswordMode: Bool = false
    ) {
        self.loginService = loginService
        self.coordinator = coordinator
        self.isChangePasswordMode = isChangePasswordMode
    }

    // MARK: - Metods

    func subscribe(toUserTapButton publisher: AnyPublisher<LoginViewController.Button, Never>) {
        publisher
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] button in
                self?.handleUserTapButton(button)
            }
            .store(in: &subscriptions)
    }

    private func handleUserTapButton(_ button: LoginViewController.Button) {
        if button == .next {
            switch state {
                case .initial:
                    state = !isChangePasswordMode && loginService.hasSavedPassword ? .enterPassword : .createPassword

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

            password = ""
        }

        func checkPassword() {
            do {
                try loginService.check(password: password)
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
                loginFinishedSuccessfully.send(true)
            } catch {
                coordinator?.showError(error)
                state = .createPassword
            }
        }
    }


}
