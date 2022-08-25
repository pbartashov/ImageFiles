//
//  LoginViewController.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {

    enum Button {
        case next
    }

    // MARK: - Properties

    private var viewModel: LoginViewModel!

    private var userTapButton = PassthroughSubject<Button, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    @Published private(set) var loginFinishedSuccessfully = false

    // MARK: - Views

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - LifeCicle

    convenience init?(coder: NSCoder, viewModel: LoginViewModel) {
        self.init(coder: coder)
        self.viewModel = viewModel

        viewModel.loginFinishedSuccessfully
            .assign(to: &$loginFinishedSuccessfully)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()

        userTapButton.send(.next)

        textField.becomeFirstResponder()
    }
    
    // MARK: - Metods

    @IBAction func nextButtonTApped(_ sender: UIButton) {
        userTapButton.send(.next)
    }

    private func setupBindings() {
        func subscribeViewToViewModel() {
            textField.textPublisher
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &viewModel.$password)
        }

        func subsribeViewModelToView() {
            viewModel.$password
                .removeDuplicates()
                .assign(to: \.textUnwrapped, on: textField)
                .store(in: &subscriptions)

            viewModel.isInputValid
                .assign(to: \.isEnabled, on: nextButton)
                .store(in: &subscriptions)

            viewModel.$buttonTitle
                .assign(to: \.titleForNormal, on: nextButton)
                .store(in: &subscriptions)

            viewModel.subscribe(toUserTapButton: userTapButton.eraseToAnyPublisher())
        }

        subsribeViewModelToView()
        subscribeViewToViewModel()
    }
}
