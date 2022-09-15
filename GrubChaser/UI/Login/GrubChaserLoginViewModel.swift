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

enum AuthType {
    case firebase
    case facebook
}

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
    
    init(router: GrubChaserLoginRouterProtocol,
         firebaseAuth: Auth = Auth.auth(),
         fbLoginManager: LoginManager = LoginManager(),
         viewControllerRef: UIViewController) {
        self.firebaseAuth = firebaseAuth
        self.fbLoginManager = fbLoginManager
        self.viewControllerRef = viewControllerRef
        super.init(router: router)
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
            .subscribe(onNext: firebaseLoggingUserHasAccount)
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
    
    //MARK: - Firebase sign in
    private func firebaseLoggingUserHasAccount(loginModel: GrubChaserLoginModel) {
        func handleSuccess(_ providers: [String]) {
            providers.count > 0 ?
            firebaseLogin(loginModel) :
            signUp(loginModel)
        }
        
        func handleError(_ error: Error) {
            showErrorOnLoginAlertView()
        }
        
        firebaseAuth.rx.fetchProviders(forEmail: loginModel.email)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func firebaseLogin(_ loginModel: GrubChaserLoginModel) {
        func handleSuccess(_ authResult: AuthDataResult) {
            stopLoading()
            let userModel = GrubChaserUserModel(uid: authResult.user.uid,
                                                name: "")
            UserDefaults.standard.saveLoggedUser(userModel)
            router.goToMainFlow()
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
    
    //MARK: - Sign up
    private func signUp(_ userModel: GrubChaserLoginModel) {
        func handleSuccess(_ authResult: AuthDataResult) {
            let userModel = GrubChaserUserModel(uid: authResult.user.uid,
                                                name: "")
            saveUserSignUpData(userModel)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        firebaseAuth.rx.createUser(withEmail: userModel.email,
                                   password: userModel.password)
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

extension GrubChaserLoginViewModel {
    //MARK: - Facebook sign in
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
            let userModel = GrubChaserUserModel(uid: authResult.user.uid,
                                                name: authResult.user.displayName ?? "")
            facebookUserHasAccount(userModel)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        if let fbAccessToken = AccessToken.current {
            firebaseAuth.rx.signInAndRetrieveData(with: FacebookAuthProvider.credential(withAccessToken: fbAccessToken.tokenString))
                .subscribe(onNext: handleSuccess,
                           onError: handleError)
                .disposed(by: disposeBag)
        } else {
            showErrorOnLoginAlertView()
        }
    }
    
    private func facebookUserHasAccount(_ userModel: GrubChaserUserModel) {
        func handleSuccess(hasAccount: Bool) {
            if hasAccount {
                stopLoading()
                UserDefaults.standard.saveLoggedUser(userModel)
                router.goToMainFlow()
            } else {
                saveUserSignUpData(userModel)
            }
        }
        
        func handleError(_ error: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        service.checkUserHasAccount(uid: userModel.uid)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
}

//TODO: Create func to verify user has account from user email to unificate methods

extension GrubChaserLoginViewModel: GrubChaserAlertableViewModel {}
extension GrubChaserLoginViewModel: GrubChaserLoadableViewModel {}
