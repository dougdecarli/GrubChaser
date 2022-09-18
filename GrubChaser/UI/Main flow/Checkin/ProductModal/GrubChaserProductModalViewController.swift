//
//  GrubChaserProductModalViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/09/22.
//

import UIKit

class GrubChaserProductModalViewController: GrubChaserBaseViewController<GrubChaserProductModalViewModel> {
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
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        productName.text = viewModel.product.name
        productDescription.text = viewModel.product.description
        productPrice.text = "\(String(viewModel.product.price).currencyFormatting())"
        productImage.loadImage(imageURL: viewModel.product.image, genericImage: R.image.productImage()!)
    }
}
