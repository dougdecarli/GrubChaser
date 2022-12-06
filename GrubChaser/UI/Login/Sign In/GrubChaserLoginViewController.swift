//
//  GrubChaserLoginViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 07/09/22.
//

import UIKit
import RxSwift
import RxGesture
import FirebaseCore

final class GrubChaserLoginViewController: GrubChaserBaseViewController<GrubChaserLoginViewModel> {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLogin: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        emailTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.emailValue)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.passwordValue)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.onLoginButtonTouched)
            .disposed(by: disposeBag)
        
        facebookLogin.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.onFacebookButtonTouched)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.onSignUpButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel.isLoginButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
