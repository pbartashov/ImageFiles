//
//  LoginViewController.swift
//  ImageFiles
//
//  Created by Павел Барташов on 18.08.2022.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    //    enum UserAction {
    //        case tapButton(Button)
    //        case enterPassword(String)
    //    }

    enum Button {
        case next
    }


    // MARK: - Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    private var viewModel: LoginViewModel!
    //private var userAction = PassthroughSubject<UserAction, Never>()
    private var userTapButton = PassthroughSubject<Button, Never>()
    private var subscriptions: Set<AnyCancellable> = []
//    private(set) var loginFinishedSuccessfully = PassthroughSubject<Void, Never>()
//    private(set) var loginFinishedSuccessfully: Published<Void>.Publisher
    @Published private(set) var loginFinishedSuccessfully = false

    // MARK: - Views

    // MARK: - LifeCicle

    convenience init?(coder: NSCoder, viewModel: LoginViewModel) {
        self.init(coder: coder)
        self.viewModel = viewModel

//        self.loginFinishedSuccessfully =
        viewModel.loginFinishedSuccessfully
//            .eraseToAnyPublisher()
            .assign(to: &$loginFinishedSuccessfully)
    }

    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //        self.viewModel = LoginViewModel()
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()

        userTapButton.send(.next)

#warning("Text becomeFirstResponder")
        textField.becomeFirstResponder()
    }
    
    // MARK: - Metods

    @IBAction func nextButtonTApped(_ sender: UIButton) {
        //        let tabController = Strory

        userTapButton.send(.next)
        
    }


    private func setupBindings() {
        func subscribeViewToViewModel() {
            textField.textPublisher
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &viewModel.$password)
            //            .assign(to: \.password, on: viewModel)
            //            .store(in: &subscriptions)
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
            ////        subscriptions = [

            //            viewModel.$password.assign(to: \.text!, on: textField)
            //            viewModel.$distance.assign(to: \.text!, on: distanceLabel),
            //            viewModel.$isOpen.map { $0.openStatusText }.assign(to: \.text!, on: openStatusLabel),
            //            viewModel.$isOpen.map { $0 ? UIColor.green : UIColor.red }.assign(to: \.textColor!, on: openStatusLabel)
            //        ]
            viewModel.subscribe(toUserTapButton: userTapButton.eraseToAnyPublisher())
        }

        subsribeViewModelToView()
        subscribeViewToViewModel()
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
