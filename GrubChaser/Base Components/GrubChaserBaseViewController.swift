//
//  GrubChaserBaseViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import RxCocoa
import RxSwift
import UIKit

class GrubChaserBaseViewController<ViewModel: GrubChaserViewModelProtocol>: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    open func bindInputs() {}
    
    open func bindOutputs() {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setupBindings()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.cleanBindings()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension GrubChaserBaseViewController: GrubChaserViewControllerProtocol {}
