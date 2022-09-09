//
//  GrubChaserLoginViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 07/09/22.
//

import RxSwift
import RxRelay
import RxCocoa
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FirebaseAuth
import UIKit
import NVActivityIndicatorView

class GrubChaserLoginViewModel: GrubChaserBaseViewModel<GrubChaserLoginRouterProtocol> {
    private let fbReadPermissions: [Permission] = [.publicProfile,
                                                   .email],
                firebaseAuth: Auth,
                fbLoginManager: LoginManager,
                viewControllerRef: UIViewController
    
    var emailValue = BehaviorRelay<String>(value: ""),
        passwordValue = BehaviorRelay<String>(value: ""),
        onLoginButtonTouched = PublishRelay<Void>(),
        onFacebookButtonTouched = PublishRelay<Void>(),
        showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    var isLoginButtonEnabled: Observable<Bool> {
        setupIsLoginButtonEnabled()
    }
    
    var isEmailValid: Observable<Bool> {
        setupIsEmailValid()
    }
    
    var isPasswordValid: Observable<Bool> {
        setupIsPasswordValid()
    }
    
    init(service: GrubChaserServiceProtocol,
         router: GrubChaserLoginRouterProtocol,
         firebaseAuth: Auth = Auth.auth(),
         fbLoginManager: LoginManager = LoginManager(),
         viewControllerRef: UIViewController) {
        self.firebaseAuth = firebaseAuth
        self.fbLoginManager = fbLoginManager
        self.viewControllerRef = viewControllerRef
        super.init(service: service,
                   router: router)
    }
    
    override func setupBindings() {
        setupOnLoginButtonTouched()
        setupOnFacebookLoginTouched()
    }
    
    //MARK: Inputs
    private func setupOnLoginButtonTouched() {
        onLoginButtonTouched
            .withLatestFrom(Observable.combineLatest(emailValue, passwordValue))
            .flatMap(buildLoginModel)
            .do(onNext: startLoading)
            .subscribe(onNext: defaultLogin)
            .disposed(by: disposeBag)
    }
    
    private func setupOnFacebookLoginTouched() {
        onFacebookButtonTouched
            .do(onNext: startLoading)
            .subscribe(onNext: facebookLogin)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupIsLoginButtonEnabled() -> Observable<Bool> {
        Observable.combineLatest(isEmailValid,
                                 isPasswordValid)
        .map { $0 && $1 }
    }
    
    private func setupIsEmailValid() -> Observable<Bool> {
        emailValue
            .map { $0.contains("@") && $0.contains(".com") }
    }
    
    private func setupIsPasswordValid() -> Observable<Bool> {
        passwordValue
            .map { $0.count > 4 }
    }
    
    //MARK: - Defaut Login
    private func defaultLogin(_ loginModel: GrubChaserLoginModel) {
        func handleSuccess(_ authResult: AuthDataResult) {
            stopLoading()
            saveUserSignUpData()
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        firebaseAuth.rx.signIn(withEmail: loginModel.email,
                              password: loginModel.password)
        .subscribe(onNext: handleSuccess,
                   onError: handleError)
        .disposed(by: disposeBag)
    }
    
    //MARK: - Facebook Login
    private func facebookLogin() {
        fbLoginManager.logIn(permissions: fbReadPermissions,
                             viewController: viewControllerRef) { [weak self] loginResult in
            guard let self = self else { return }
            switch loginResult {
                case .success:
                    self.didLoginWithFacebook()
                default:
                    self.stopLoading()
                    self.showErrorOnLoginAlertView()
            }
        }
    }
    
    private func didLoginWithFacebook() {
        func handleSuccess(_ authResult: AuthDataResult) {
            stopLoading()
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        if let accessToken = AccessToken.current {
            firebaseAuth.rx.signInAndRetrieveData(with: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString))
                .subscribe(onNext: handleSuccess,
                           onError: handleError)
                .disposed(by: disposeBag)
        } else {
            showErrorOnLoginAlertView()
        }
    }
    
    //MARK: - Save user data into database
    private func saveUserSignUpData() {
        
    }
    
    //MARK: Helper methods
    private func buildLoginModel(email: String,
                                 password: String) -> Observable<GrubChaserLoginModel> {
        Observable.of(.init(email: email, password: password))
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    func showErrorOnLoginAlertView() {
        showAlert.onNext(.init(title: "Ocorreu um erro ao efetuar o seu login",
                               message: "Por favor, tente novamente",
                               preferredStyle: .alert,
                               actionStyle: .default,
                               actionTitle: "Ok",
                               viewControllerRef: viewControllerRef))
    }
}

extension GrubChaserLoginViewModel: GrubChaserAlertableViewModel {}
extension GrubChaserLoginViewModel: GrubChaserLoadableViewModel {}
