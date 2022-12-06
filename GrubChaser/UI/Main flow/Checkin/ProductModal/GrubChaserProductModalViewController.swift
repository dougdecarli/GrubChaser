//
//  GrubChaserProductModalViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/09/22.
//

import UIKit
import RxAnimated

final class GrubChaserProductModalViewController: GrubChaserBaseViewController<GrubChaserProductModalViewModel> {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productsQuantityNumber: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        plusButton.rx.tap
            .bind(to: viewModel.onPlusButtonTouched)
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .bind(to: viewModel.onMinusButtonTouched)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.onAddButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        productName.text = viewModel.product.name
        productDescription.text = viewModel.product.description
        productPrice.text = "\(String(viewModel.product.price).currencyFormatting())"
        productImage.loadImage(imageURL: viewModel.product.image, genericImage: R.image.genericFood()!)
        
        viewModel.quantityText
            .bind(to: productsQuantityNumber.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isMinusButtonDisabled
            .map { !$0 }
            .bind(to: minusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.addButtonTextDriver
            .drive(addButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.dismissModal
            .subscribe(onNext: onModalDismiss)
            .disposed(by: disposeBag)
    }
    
    private func onModalDismiss(products: [GrubChaserProduct]) {
        if let tabBar = presentingViewController as? UITabBarController {
            if let mainNavBar = tabBar.viewControllers![1] as? UINavigationController {
                if let checkinNavBar = mainNavBar.topViewController as? GrubChaserCheckinTabBarController {
                    if let orderNavBar = checkinNavBar.viewControllers![0] as? UINavigationController {
                        if let presenter = orderNavBar.topViewController as? GrubChaserRestaurantOrderViewController {
                            let currentProductsSelected = presenter.viewModel.productsSelected.value
                            presenter.viewModel.productsSelected.accept(currentProductsSelected + products)
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}
