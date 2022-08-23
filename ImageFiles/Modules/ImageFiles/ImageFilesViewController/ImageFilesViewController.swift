//
//  ImageFilesViewController.swift
//  ImageFiles
//
//  Created by Павел Барташов on 15.08.2022.
//

import UIKit
import Combine

final class ImageFilesViewController: UITableViewController, UINavigationControllerDelegate {

    // MARK: - Properties

    private var viewModel = ImagesManager()
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()

        viewModel.loadStorage()
        setTitle()
    }

    // MARK: - Metods

    private func initialize() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                    case .itemRemoved(let row):
                        let indexPath = IndexPath(row: row, section: 0)
                        self?.tableView.deleteRows(at: [indexPath], with: .fade)

                    case .itemAdded(let row):
                        let indexPath = IndexPath(row: row, section: 0)
                        self?.tableView.insertRows(at: [indexPath], with: .automatic)

                    case .loadingCompleted:
                        self?.tableView.reloadData()

                    default:
                        break
                }

                self?.setTitle()
            }
            .store(in: &subscriptions)
    }

    private func setTitle() {
        navigationItem.title = viewModel.imageFiles.count > 0 ? "" : "Нажмите \"+\""
    }

    @IBAction func addImageButtonTapped(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self

        present(picker, animated: true)
    }

    // TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.imageFiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        var configuration = cell.defaultContentConfiguration()
        configuration.image = viewModel.imageFiles[indexPath.row].image
        cell.contentConfiguration = configuration

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = viewModel.imageFiles[indexPath.row].image
        let imageRatio = currentImage.size.width / currentImage.size.height

        return tableView.bounds.width / imageRatio
    }

    // TableView Delegate methods
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.deleteRow(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    private func deleteRow(at indexPath: IndexPath) {
        let imageFile = viewModel.imageFiles[indexPath.row]
        viewModel.delete(imageFile: imageFile)
    }
}

// UIImagePickerControllerDelegate
extension ImageFilesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        dismiss(animated: true)
        
        viewModel.saveToStorage(image: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
