//
//  GrubChaserBaseViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import RxCocoa
import RxSwift

class GrubChaserBaseViewModel<Router>: GrubChaserViewModelProtocol {
    var disposeBag = DisposeBag(),
        service = GrubChaserService.instance,
        router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    open func setupBindings() {}
    
    open func cleanBindings() {
        disposeBag = DisposeBag()
    }
}
