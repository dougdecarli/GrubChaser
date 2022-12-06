//
//  GrubChaserSignUpViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 06/10/22.
//

import RxSwift
import RxRelay
import RxCocoa
import FirebaseAuth
import FirebaseAuth
import UIKit

final class GrubChaserSignUpViewModel: GrubChaserBaseViewModel<GrubChaserLoginRouterProtocol> {
    private let firebaseAuth: Auth,
                viewControllerRef: UIViewController
    
    let onSignUpButtonTouched = PublishRelay<Void>(),
        nameValue = BehaviorRelay<String>(value: ""),
        emailValue = BehaviorRelay<String>(value: ""),
        passwordValue = BehaviorRelay<String>(value: "")
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    var isSignUpButtonEnabled: Observable<Bool> {
        setupIsSignUpButtonEnabled()
    }
    
    var isEmailValid: Observable<Bool> {
        setupIsEmailValid()
    }
    
    var isPasswordValid: Observable<Bool> {
        setupIsPasswordValid()
    }
    
    var isNameValid: Observable<Bool> {
        setupIsNameValid()
    }
    
    init(router: GrubChaserLoginRouterProtocol,
         firebaseAuth: Auth = Auth.auth(),
         viewControllerRef: UIViewController) {
        self.firebaseAuth = firebaseAuth
        self.viewControllerRef = viewControllerRef
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnSignUpButtonTouched()
    }
    
    //MARK: - Inputs
    private func setupOnSignUpButtonTouched() {
        onSignUpButtonTouched
            .withLatestFrom(Observable.combineLatest(emailValue, passwordValue, nameValue))
            .flatMap(buildSignUpModel)
            .do(onNext: startLoading(_:))
            .subscribe(onNext: signUp)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupIsSignUpButtonEnabled() -> Observable<Bool> {
        Observable.combineLatest(isEmailValid,
                                 isPasswordValid,
                                 isNameValid)
        .map { $0 && $1 && $2 }
    }
    
    private func setupIsEmailValid() -> Observable<Bool> {
        emailValue
            .map { $0.contains("@") && $0.contains(".com") }
    }
    
    private func setupIsPasswordValid() -> Observable<Bool> {
        passwordValue
            .map { $0.count > 6 }
    }
    
    private func setupIsNameValid() -> Observable<Bool> {
        nameValue
            .map { $0.count > 3 }
    }
    
    //MARK: - Sign up
    private func signUp(_ signUpModel: GrubChaserSignUpModel) {
        func handleSuccess(_ authResult: AuthDataResult) {
            let userModel = GrubChaserUserModel(uid: authResult.user.uid,
                                                name: signUpModel.name)
            saveUserSignUpData(userModel)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        firebaseAuth.rx.createUser(withEmail: signUpModel.email,
                                   password: signUpModel.password)
        .subscribe(onNext: handleSuccess,
                   onError: handleError)
        .disposed(by: disposeBag)
    }
    
    //MARK: - Save user data into database
    private func saveUserSignUpData(_ userModel: GrubChaserUserModel) {
        func handleSuccess(_: Any) {
            stopLoading()
            UserDefaults.standard.saveLoggedUser(userModel)
            router.goToMainFlow()
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        service.createUser(userModel: userModel)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Helper methods
    private func buildSignUpModel(email: String,
                                  password: String,
                                  name: String) -> Observable<GrubChaserSignUpModel> {
        Observable.of(.init(email: email, password: password, name: name))
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    func showErrorOnLoginAlertView() {
        showAlert.onNext(.init(title: "Ocorreu um erro ao efetuar o seu cadastro",
                               message: "Por favor, verifique seus dados e tente novamente",
                               viewControllerRef: viewControllerRef))
    }
}

extension GrubChaserSignUpViewModel: GrubChaserAlertableViewModel {}
extension GrubChaserSignUpViewModel: GrubChaserLoadableViewModel {}
