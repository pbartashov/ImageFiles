//
//  ViewControllerFactory.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import UIKit

struct ViewControllerFactory {

    // MARK: - Properties

    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods



    func createLoginViewController(coordinator: MainCoordinator,
                                   authService: AuthServiceProtocol,
                                   isChangePasswordMode: Bool = false
    ) -> LoginViewController {
        let loginService = LoginService(authService: authService)
        let viewModel = LoginViewModel(coordinator: coordinator,
                                       loginService: loginService,
                                       isChangePasswordMode: isChangePasswordMode)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController") { coder in
            LoginViewController.init(coder: coder, viewModel: viewModel)
        }

        return loginViewController
    }

    func createMainViewController() -> UIViewController {
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")

        return mainViewController
    }
}

