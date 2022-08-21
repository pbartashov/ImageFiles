//
//  SettingsViewController.swift
//  ImageFiles
//
//  Created by Павел Барташов on 21.08.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    #warning("Folder structure")
    // MARK: - Properties

    private weak var coordinator = {
        (UIApplication.shared
            .connectedScenes
            .first?
            .delegate as? SceneDelegate)?
            .mainCoordinator
    }()

    // MARK: - Views

    // MARK: - LifeCicle



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Metods

    @IBAction func deletePasswordButtonTapped(_ sender: UIButton) {
        do {
            try coordinator?.authService.deletePassword()
            coordinator?.switchToLoginViewController()
        } catch {
            coordinator?.showError(error)
        }
    }


    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        coordinator?.switchToLoginViewController()
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        coordinator?.presentChangePassword()
    }

}
