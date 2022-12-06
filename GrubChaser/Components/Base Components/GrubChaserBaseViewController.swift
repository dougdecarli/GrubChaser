//
//  GrubChaserBaseViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import RxCocoa
import RxSwift
import UIKit
import NVActivityIndicatorView

class GrubChaserBaseViewController<ViewModel: GrubChaserViewModelProtocol>: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    lazy var activityIndicatorView = NVActivityIndicatorView(
        frame: CGRect(x: Int(view.frame.width) / 2 - 25,
                      y: Int(view.frame.height) / 2,
                      width: 50,
                      height: 50),
        type: NVActivityIndicatorType.ballPulse,
        color: ColorPallete.defaultRed
    )
    
    open func bindInputs() {
        if let viewModel = viewModel as? GrubChaserAlertableViewModel {
            viewModel.showAlert.asObservable()
                .subscribe(onNext: showToastMessage)
                .disposed(by: disposeBag)
        }
        if let viewModel = viewModel as? GrubChaserLoadableViewModel {
            viewModel.isLoaderShowing.asObservable()
                .subscribe(onNext: toggleLoaderState)
                .disposed(by: disposeBag)
        }
    }
    
    open func bindOutputs() {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLoaderToSubview()
        viewModel.setupBindings()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.cleanBindings()
    }
    
    private func addLoaderToSubview() {
        view.addSubview(activityIndicatorView)
    }
    
    internal func showToastMessage(_ alert: ShowAlertModel) {
        GrubChaserUIAlertView.showAlert(with: alert)
    }
    
    internal func toggleLoaderState(_ showLoader: Bool) {
        toggleIsUserInteractionEnabled(showLoader)
        
        showLoader ?
        activityIndicatorView.startAnimating() :
        activityIndicatorView.stopAnimating()
    }
    
    private func toggleIsUserInteractionEnabled(_ showLoader: Bool) {
        view.isUserInteractionEnabled = !showLoader
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension GrubChaserBaseViewController: GrubChaserViewControllerProtocol {}
