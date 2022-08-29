//
//  GrubChaserBaseViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import RxCocoa
import RxSwift

class GrubChaserBaseViewModel<Router>: GrubChaserViewModelProtocol {
    let disposeBag = DisposeBag(),
        service: GrubChaserServiceProtocol,
        router: Router
    
    init(service: GrubChaserServiceProtocol,
         router: Router) {
        self.service = service
        self.router = router
    }
    
    open func setupBindings() {}
}
