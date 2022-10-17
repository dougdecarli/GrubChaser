//
//  GrubChaserSignUpViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 06/10/22.
//

import UIKit

final class GrubChaserSignUpViewController: GrubChaserBaseViewController<GrubChaserSignUpViewModel> {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
        
        nameTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.nameValue)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.onSignUpButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel.isSignUpButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
