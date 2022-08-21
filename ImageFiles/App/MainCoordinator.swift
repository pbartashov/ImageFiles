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

    private var subscriptions: Set<AnyCancellable> = []

    init(window: UIWindow
    ) {
        self.window = window
    }


    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

    func start() -> UIViewController {
        let viewController = ViewControllerFactory()
            .createLoginViewController(coordinator: self, authService: authService)

        viewController.$loginFinishedSuccessfully
            .sink { [weak self] success in
                if success {
                    self?.switchToMainViewController()
                }
            }
            .store(in: &subscriptions)

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

        viewController.$loginFinishedSuccessfully
            .sink { [weak self] success in
                if success {
                    self?.window.rootViewController?.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)

        window.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}
