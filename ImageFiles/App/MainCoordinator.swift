//
//  MainCoordinator.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import UIKit


import Combine

final class MainCoordinator {

    // MARK: - Properties

    private let window: UIWindow
    let authService = KeychainAuthService()

    private var loginFinishedSubscriptions: AnyCancellable?

    // MARK: - LifeCicle

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Metods

    func start() -> UIViewController {
        let viewController = ViewControllerFactory()
            .createLoginViewController(coordinator: self, authService: authService)

        loginFinishedSubscriptions = viewController.$loginFinishedSuccessfully
            .sink { [weak self] success in
                if success {
                    self?.switchToMainViewController()
                }
            }

        return viewController
    }

    func switchTo(viewController: UIViewController) {

        window.rootViewController = viewController

        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }

    func switchToMainViewController() {
        let viewController = ViewControllerFactory().createMainViewController()
        switchTo(viewController: viewController)
    }

    func switchToLoginViewController() {
        let viewController = start()
        switchTo(viewController: viewController)
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription,
                                      message: nil,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ясно", style: .default)

        alert.addAction(cancelAction)

        if let presented = window.rootViewController?.presentedViewController {
            presented.present(alert, animated: true)
        } else {
            window.rootViewController?.present(alert, animated: true)
        }
    }

    func presentChangePassword() {
        let viewController = ViewControllerFactory()
            .createLoginViewController(coordinator: self,
                                       authService: authService,
                                       isChangePasswordMode: true)

        loginFinishedSubscriptions = viewController.$loginFinishedSuccessfully
            .sink { [weak self] success in
                if success {
                    self?.window.rootViewController?.dismiss(animated: true)
                }
            }

        window.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}
