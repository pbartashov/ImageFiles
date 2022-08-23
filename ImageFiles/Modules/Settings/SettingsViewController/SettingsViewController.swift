//
//  SettingsViewController.swift
//  ImageFiles
//
//  Created by Павел Барташов on 21.08.2022.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Properties

    private weak var coordinator = {
        (UIApplication.shared
            .connectedScenes
            .first?
            .delegate as? SceneDelegate)?
            .mainCoordinator
    }()

    private var settingStorage: SettingsStorageProtocol = SettingsStorage()

    // MARK: - Views

    @IBOutlet weak var sortTypeSelector: UISegmentedControl!

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettings()
    }


    // MARK: - Metods

    private func loadSettings() {
        let saved = settingStorage.restoreSortType()
        sortTypeSelector.selectedSegmentIndex = saved.rawValue
    }

    @IBAction func sortTypeValueChanged(_ sender: UISegmentedControl) {
        let sortType = SortType(sender.selectedSegmentIndex)
        settingStorage.saveSortType(sortType)
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        coordinator?.presentChangePassword()
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        coordinator?.switchToLoginViewController()
    }

    @IBAction func deletePasswordButtonTapped(_ sender: UIButton) {
        do {
            try coordinator?.authService.deletePassword()
            coordinator?.switchToLoginViewController()
        } catch {
            coordinator?.showError(error)
        }
    }
}
