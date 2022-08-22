//
//  Reactive+UICollectionView.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 30/06/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import Foundation
import RxSwift

private var prepareForReuseBag: Int8 = 0

public extension Reactive where Base: UICollectionViewCell {
    var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(UICollectionViewCell.prepareForReuse)).map { _ in () }, deallocated).merge()
    }
    
    var disposeBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = sentMessage(#selector(UITableViewHeaderFooterView.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                let newBag = DisposeBag()
                objc_setAssociatedObject(base, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        
        return bag
    }
}
